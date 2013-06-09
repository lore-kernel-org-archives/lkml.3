Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3FIByW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 21:54:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:43963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab3FIByU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 21:54:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,829,1363158000"; 
   d="scan'208";a="346972812"
Message-ID: <51B3E069.8090301@intel.com>
Date: Sun, 09 Jun 2013 09:54:49 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / scan: Simplify ACPI driver probing
References: <2159292.upDGjkPUz6@vostro.rjw.lan> <51B3D825.3060505@intel.com>
In-Reply-To: <51B3D825.3060505@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 09:19 AM, Aaron Lu wrote:
> On 06/09/2013 06:28 AM, Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> There is no particular reason why acpi_bus_driver_init() needs to be
>> a separate function and its location with respect to its only caller,
>> acpi_device_probe(), makes the code a bit difficult to follow.
>>
>> Besides, it doesn't really make sense to check if 'device' is not
>> NULL in acpi_bus_driver_init(), because we've already dereferenced
>> dev->driver in acpi_device_probe() at that point, so that check has
>> to be moved to acpi_device_probe() anyway.
>>
>> For these reasons, drop acpi_bus_driver_init() altogether and move
>> the code from it directly into acpi_device_probe().
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>
>> Should apply on top of the bleeding-edge branch of the linux-pm.git tree.
>>
>> Thanks,
>> Rafael
>>
>> ---
>>  drivers/acpi/scan.c |   88 +++++++++++++++++++---------------------------------
>>  1 file changed, 33 insertions(+), 55 deletions(-)
>>
>> Index: linux-pm/drivers/acpi/scan.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/scan.c
>> +++ linux-pm/drivers/acpi/scan.c
>> @@ -933,32 +933,45 @@ static void acpi_device_remove_notify_ha
>>  					   acpi_device_notify);
>>  }
>>  
>> -static int acpi_bus_driver_init(struct acpi_device *, struct acpi_driver *);
>>  static int acpi_device_probe(struct device * dev)
>>  {
>> -	struct acpi_device *acpi_dev = to_acpi_device(dev);
>> -	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
>> +	struct acpi_device *acpi_dev;
>> +	struct acpi_driver *acpi_drv;
>>  	int ret;
>>  
>> -	ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
>> -	if (!ret) {
>> -		if (acpi_drv->ops.notify) {
>> -			ret = acpi_device_install_notify_handler(acpi_dev);
>> -			if (ret) {
>> -				if (acpi_drv->ops.remove)
>> -					acpi_drv->ops.remove(acpi_dev);
>> -				acpi_dev->driver = NULL;
>> -				acpi_dev->driver_data = NULL;
>> -				return ret;
>> -			}
>> -		}
>> +	if (!dev || !dev->driver)
>> +		return -EINVAL;
> 
> Just out of curiosity, will dev ever be NULL in this function?
> This function is called in really_probe by dev->bus->probe after
> assigning dev->driver, so does the above check make any sense?

BTW, I also tested the patch on a desktop and two laptops, no problems
found. Feel free to add my tested-by tag.

Thanks,
Aaron

> 
> Thanks,
> Aaron
> 
>> +
>> +	acpi_dev = to_acpi_device(dev);
>> +	acpi_drv = to_acpi_driver(dev->driver);
>> +	if (!acpi_drv->ops.add)
>> +		return -ENOSYS;
>> +
>> +	ret = acpi_drv->ops.add(acpi_dev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	acpi_dev->driver = acpi_drv;
>> +	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>> +			  "Driver [%s] successfully bound to device [%s]\n",
>> +			  acpi_drv->name, acpi_dev->pnp.bus_id));
>>  
>> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>> -			"Found driver [%s] for device [%s]\n",
>> -			acpi_drv->name, acpi_dev->pnp.bus_id));
>> -		get_device(dev);
>> +	if (acpi_drv->ops.notify) {
>> +		ret = acpi_device_install_notify_handler(acpi_dev);
>> +		if (ret) {
>> +			if (acpi_drv->ops.remove)
>> +				acpi_drv->ops.remove(acpi_dev);
>> +
>> +			acpi_dev->driver = NULL;
>> +			acpi_dev->driver_data = NULL;
>> +			return ret;
>> +		}
>>  	}
>> -	return ret;
>> +
>> +	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Found driver [%s] for device [%s]\n",
>> +			  acpi_drv->name, acpi_dev->pnp.bus_id));
>> +	get_device(dev);
>> +	return 0;
>>  }
>>  
>>  static int acpi_device_remove(struct device * dev)
>> @@ -1114,41 +1127,6 @@ static void acpi_device_unregister(struc
>>                                   Driver Management
>>     -------------------------------------------------------------------------- */
>>  /**
>> - * acpi_bus_driver_init - add a device to a driver
>> - * @device: the device to add and initialize
>> - * @driver: driver for the device
>> - *
>> - * Used to initialize a device via its device driver.  Called whenever a
>> - * driver is bound to a device.  Invokes the driver's add() ops.
>> - */
>> -static int
>> -acpi_bus_driver_init(struct acpi_device *device, struct acpi_driver *driver)
>> -{
>> -	int result = 0;
>> -
>> -	if (!device || !driver)
>> -		return -EINVAL;
>> -
>> -	if (!driver->ops.add)
>> -		return -ENOSYS;
>> -
>> -	result = driver->ops.add(device);
>> -	if (result)
>> -		return result;
>> -
>> -	device->driver = driver;
>> -
>> -	/*
>> -	 * TBD - Configuration Management: Assign resources to device based
>> -	 * upon possible configuration and currently allocated resources.
>> -	 */
>> -
>> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>> -			  "Driver successfully bound to device\n"));
>> -	return 0;
>> -}
>> -
>> -/**
>>   * acpi_bus_register_driver - register a driver with the ACPI bus
>>   * @driver: driver being registered
>>   *
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

