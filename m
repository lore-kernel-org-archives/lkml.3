Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbbA2L05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:26:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50260 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbbA2L0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:26:48 -0500
Message-ID: <54CA18EF.2060607@ti.com>
Date: Thu, 29 Jan 2015 13:26:39 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <myungjoo.ham@samsung.com>, <balbi@ti.com>, <tony@atomide.com>,
        <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] extcon: usb-gpio: Introduce gpio usb extcon driver
References: <1422274532-9488-1-git-send-email-rogerq@ti.com> <1422274532-9488-2-git-send-email-rogerq@ti.com> <54C8D2F4.9050404@ti.com> <54C99197.5070605@samsung.com>
In-Reply-To: <54C99197.5070605@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo,

On 29/01/15 03:49, Chanwoo Choi wrote:
> Hi Roger,
> 
> We need to discuss one point about 'id_irqwake'.
> I don't recommend to use 'id_irqwake' field.
> 
> And I catch build warning by using "select" keywork in Kconfig.
> It is my wrong guide of "select" keyword. So, I'll change it 
> as 'depends on' keyword.
> 
> Looks good to me except for 'id_irqwake'. 
> I'll apply this patch on 3.21 queue after completing this discussion.
> 
> On 01/28/2015 09:15 PM, Roger Quadros wrote:
>> This driver observes the USB ID pin connected over a GPIO and
>> updates the USB cable extcon states accordingly.
>>
>> The existing GPIO extcon driver is not suitable for this purpose
>> as it needs to be taught to understand USB cable states and it
>> can't handle more than one cable per instance.
>>
>> For the USB case we need to handle 2 cable states.
>> 1) USB (attach/detach)
>> 2) USB-Host (attach/detach)
>>
>> This driver can be easily updated in the future to handle VBUS
>> events in case it happens to be available on GPIO for any platform.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>> v3:
>> - removed IRQF_NO_SUSPEND flag. Added IRQF_TRIGGER_RISING and
>>   IRQF_TRIGGER_FALLING
>> - Added disable_irq() to suspend() and enable_irq() to resume()
>>
>>  .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  18 ++
>>  drivers/extcon/Kconfig                             |   7 +
>>  drivers/extcon/Makefile                            |   1 +
>>  drivers/extcon/extcon-usb-gpio.c                   | 233 +++++++++++++++++++++
>>  4 files changed, 259 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>>  create mode 100644 drivers/extcon/extcon-usb-gpio.c
>>
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>> new file mode 100644
>> index 0000000..85fe6b0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>> @@ -0,0 +1,18 @@
>> +USB GPIO Extcon device
>> +
>> +This is a virtual device used to generate USB cable states from the USB ID pin
>> +connected to a GPIO pin.
>> +
>> +Required properties:
>> +- compatible: Should be "linux,extcon-usb-gpio"
>> +- id-gpio: gpio for USB ID pin. See gpio binding.
>> +
>> +Example:
>> +	extcon_usb1 {
>> +		compatible = "linux,extcon-usb-gpio";
>> +		id-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
>> +	}
>> +
>> +	&omap_dwc3_1 {
>> +		extcon = <&extcon_usb1>;
>> +	};
>> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
>> index 6a1f7de..fd11536 100644
>> --- a/drivers/extcon/Kconfig
>> +++ b/drivers/extcon/Kconfig
>> @@ -93,4 +93,11 @@ config EXTCON_SM5502
>>  	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
>>  	  detector and switch.
>>  
>> +config EXTCON_USB_GPIO
>> +	tristate "USB GPIO extcon support"
>> +	select GPIOLIB
> 
> I catch the build warning if using 'select' instead of 'depends on' as following:
> It is my wrong guide to you. So, I'll modify it by using "depends on" as your original patch.

OK. Thanks.

> 
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- zImage  -j 8
> scripts/kconfig/conf --silentoldconfig Kconfig
> drivers/gpio/Kconfig:34:error: recursive dependency detected!
> drivers/gpio/Kconfig:34:	symbol GPIOLIB is selected by EXTCON_USB_GPIO
> drivers/extcon/Kconfig:96:	symbol EXTCON_USB_GPIO depends on EXTCON
> drivers/extcon/Kconfig:1:	symbol EXTCON is selected by CHARGER_MANAGER
> drivers/power/Kconfig:316:	symbol CHARGER_MANAGER depends on POWER_SUPPLY
> drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
> drivers/hid/Kconfig:670:	symbol HID_SONY depends on NEW_LEDS
> drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by BCMA_DRIVER_GPIO
> drivers/bcma/Kconfig:75:	symbol BCMA_DRIVER_GPIO depends on GPIOLIB
> 
>> +	help
>> +	  Say Y here to enable GPIO based USB cable detection extcon support.
>> +	  Used typically if GPIO is used for USB ID pin detection.
>> +
>>  endif # MULTISTATE_SWITCH
>> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
>> index 0370b42..6a08a98 100644
>> --- a/drivers/extcon/Makefile
>> +++ b/drivers/extcon/Makefile
>> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
>>  obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
>>  obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
>> +obj-$(CONFIG_EXTCON_USB_GPIO)	+= extcon-usb-gpio.o
>> diff --git a/drivers/extcon/extcon-usb-gpio.c b/drivers/extcon/extcon-usb-gpio.c
>> new file mode 100644
>> index 0000000..99a58b2
>> --- /dev/null
>> +++ b/drivers/extcon/extcon-usb-gpio.c
>> @@ -0,0 +1,233 @@
>> +/**
>> + * drivers/extcon/extcon-usb-gpio.c - USB GPIO extcon driver
>> + *
>> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com
>> + * Author: Roger Quadros <rogerq@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/extcon.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/workqueue.h>
>> +
>> +#define USB_GPIO_DEBOUNCE_MS	20	/* ms */
>> +
>> +struct usb_extcon_info {
>> +	struct device *dev;
>> +	struct extcon_dev *edev;
>> +
>> +	struct gpio_desc *id_gpiod;
>> +	int id_irq;
>> +	bool id_irqwake;		/* ID wakeup enabled flag */
> 
> Do you really think id_irqwake is necessary?
> I think it is not necessary.

I will explain below why it is necessary.

> 
>> +
>> +	unsigned long debounce_jiffies;
>> +	struct delayed_work wq_detcable;
>> +};
>> +
>> +/* List of detectable cables */
>> +enum {
>> +	EXTCON_CABLE_USB = 0,
>> +	EXTCON_CABLE_USB_HOST,
>> +
>> +	EXTCON_CABLE_END,
>> +};
>> +
>> +static const char *usb_extcon_cable[] = {
>> +	[EXTCON_CABLE_USB] = "USB",
>> +	[EXTCON_CABLE_USB_HOST] = "USB-Host",
>> +	NULL,
>> +};
>> +
> 
> [snip]
> 
>> +
>> +static int usb_extcon_remove(struct platform_device *pdev)
>> +{
>> +	struct usb_extcon_info *info = platform_get_drvdata(pdev);
>> +
>> +	cancel_delayed_work_sync(&info->wq_detcable);
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int usb_extcon_suspend(struct device *dev)
>> +{
>> +	struct usb_extcon_info *info = dev_get_drvdata(dev);
>> +
>> +	if (device_may_wakeup(dev))
>> +		if (!enable_irq_wake(info->id_irq))
>> +			info->id_irqwake = true;
>> +
> 
> You can simplify this code as following without 'id_irqwake':
> 
> 	if (device_may_wakeup(dev))
> 		enable_irq_wake(info->id_irq);

enable_irq_wake() can fail. And if it does we need to keep track of it
to prevent unbalanced disable_irq_wake() call in resume().
That's the reason I've added the id_irqwake flag in struct usb_extcon_info.

> 
>> +	/*
>> +	 * We don't want to process any IRQs after this point
>> +	 * as GPIOs used behind I2C subsystem might not be
>> +	 * accessible until resume completes. So disable IRQ.
>> +	 */
>> +	disable_irq(info->id_irq);
>> +
>> +	return 0;
>> +}
>> +
>> +static int usb_extcon_resume(struct device *dev)
>> +{
>> +	struct usb_extcon_info *info = dev_get_drvdata(dev);
>> +
>> +	if (info->id_irqwake) {
>> +		disable_irq_wake(info->id_irq);
>> +		info->id_irqwake = false;
>> +	}
> 
> ditto.
> 
> 	if (device_may_wakeup(dev))
> 		disable_irq_wake(info->id_irq);
> 
>> +
>> +	enable_irq(info->id_irq);
>> +
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static SIMPLE_DEV_PM_OPS(usb_extcon_pm_ops,
>> +			 usb_extcon_suspend, usb_extcon_resume);
>> +
>> +static struct of_device_id usb_extcon_dt_match[] = {
>> +	{ .compatible = "linux,extcon-usb-gpio", },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, usb_extcon_dt_match);
>> +
>> +static struct platform_driver usb_extcon_driver = {
>> +	.probe		= usb_extcon_probe,
>> +	.remove		= usb_extcon_remove,
>> +	.driver		= {
>> +		.name	= "extcon-usb-gpio",
>> +		.pm	= &usb_extcon_pm_ops,
>> +		.of_match_table = usb_extcon_dt_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(usb_extcon_driver);
>> +
>> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
>> +MODULE_DESCRIPTION("USB GPIO extcon driver");
>> +MODULE_LICENSE("GPL v2");
>>
> 
cheers,
-roger
