//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
        //Se retorna solo uno debido a que solo vamos a necesitar una moneda en el momento de la selección, si fuera por ejemplo
        //el sistema de fechas, deberia retornar 3 - Día - Mes - Año
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return currencyArray.count
        //Este va retornar la cantidad de monedas, este sería el contenido del picker, no lo ponemos en numero
        //por ejemplo 8 ó la cantidad que uno cuente en el array, porque al momento de agregar una nueva moneda
        // va generar un error.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url: finalURL)
        //En la línea anterior lo que se hace es tomar la dirección y se le agrega la moneda al final para poder
        //tener la dirección completa y traer los datos del Bitcoin en esa moneda de cambio.
    }
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //Esta variable se crea para combinarla con le valor final del array y así tener la dirección completa
    var finalURL = ""

    //Simbolos para poner al inicio del valor, de esta forma queda más claro para el usuario
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    //Esta varible guarda el dato del simbolo que se va poner al principio del valor del Bitcoin
    var currencySelected = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }


//    //MARK: - Networking
//    /***************************************************************/
//    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
 
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double
        {
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResult)
        }
        else
        {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }

}
