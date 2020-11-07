//
//  ViewController.swift
//  Weather
//
//  Created by Vaibhav Patil.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
   

    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization() // location permission
        locationManager.requestLocation()  // one time delivery
        
        weatherManager.delegate = self

        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }

   
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation() 
        
    }
    
    
    
}

extension ViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // hide the keyboard
        
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // hide the keyboard
 
        print(searchTextField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    //reminding user to input some text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else
        {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
}

extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weathermManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName

        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.last{
        locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat,longitude: lon)
        // print(lat)
           // print(lon)
        }
       // print("Got Location Data")
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error)
    {
        print(error)
    }
}
