Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbbAVN3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:29:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55005 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbAVN25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:28:57 -0500
Message-ID: <54C0FADE.8000806@ti.com>
Date: Thu, 22 Jan 2015 15:27:58 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] extcon: gpio-usb: Introduce gpio usb extcon driver
References: <1421689942-10201-1-git-send-email-rogerq@ti.com> <1421689942-10201-2-git-send-email-rogerq@ti.com> <54BF3918.2000300@samsung.com>
In-Reply-To: <54BF3918.2000300@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 21/01/15 07:28, Chanwoo Choi wrote:
> Hi Roger,
> 
> On 01/20/2015 02:52 AM, Roger Quadros wrote:
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
>>  .../devicetree/bindings/extcon/extcon-usb.txt      |  20 ++
>>  drivers/extcon/Kconfig                             |   7 +
>>  drivers/extcon/Makefile                            |   1 +
>>  drivers/extcon/extcon-gpio-usb.c                   | 225 +++++++++++++++++++++
>>  4 files changed, 253 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb.txt
>>  create mode 100644 drivers/extcon/extcon-gpio-usb.c
>>
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-usb.txt b/Documentation/devicetree/bindings/extcon/extcon-usb.txt
>> new file mode 100644
>> index 0000000..171c5a4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/extcon/extcon-usb.txt
> 
> Need to rename from extcon-usb.txt to extcon-gpio-usb.txt.
> 
>> @@ -0,0 +1,20 @@
>> +USB Extcon device
>> +
>> +This is a virtual device used to generate USB cable states from the USB ID pin
>> +connected to a GPIO pin.
>> +
>> +Required properties:
>> +- compatible: Should be "linux,extcon-usb"
> 
> I think you better use "linux,extcon-gpio-usb"
> because the point of this driver use the gpio for usb cable.

I will change all instances of "extcon-usb" to "extcon-usb-gpio".

> 
>> +- id-gpio: gpio for USB ID pin. See gpio binding.
>> +
>> +Example:
>> +	extcon_usb1 {
>> +		compatible = "linux,extcon-usb";
> 
> ditto.
> 
>> +		id-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
>> +	}
>> +
>> +	usb@1 {
>> +		...
>> +		extcon = <&extcon_usb1>;
>> +		...
>> +	};
>> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
>> index 6a1f7de..8106a83 100644
>> --- a/drivers/extcon/Kconfig
>> +++ b/drivers/extcon/Kconfig
>> @@ -35,6 +35,13 @@ config EXTCON_GPIO
>>  	  Say Y here to enable GPIO based extcon support. Note that GPIO
>>  	  extcon supports single state per extcon instance.
>>  
>> +config EXTCON_GPIO_USB
>> +	tristate "USB GPIO extcon support"
>> +	depends on GPIOLIB
>> +	help
>> +	  Say Y here to enable GPIO based USB cable detection extcon support.
>> +	  Used typically if GPIO is used for USB ID pin detection.
>> +
>>  config EXTCON_MAX14577
>>  	tristate "MAX14577/77836 EXTCON Support"
>>  	depends on MFD_MAX14577
>> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
>> index 0370b42..bae594b 100644
>> --- a/drivers/extcon/Makefile
>> +++ b/drivers/extcon/Makefile
>> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
>>  obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
>>  obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
>> +obj-$(CONFIG_EXTCON_GPIO_USB)	+= extcon-gpio-usb.o
> 
> Need to re-order it alphabetically.

OK. I will change this to extcon-usb-gpio so it will remain last.
> 
>> diff --git a/drivers/extcon/extcon-gpio-usb.c b/drivers/extcon/extcon-gpio-usb.c
>> new file mode 100644
>> index 0000000..aeb2298
>> --- /dev/null
>> +++ b/drivers/extcon/extcon-gpio-usb.c
>> @@ -0,0 +1,225 @@
>> +/**
>> + * drivers/extcon/extcon_gpio_usb.c - USB GPIO extcon driver
>> + *
>> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com
>> + *
> 
> Remove un-necessary blank line.

OK.
> 
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
>> +#include <linux/extcon/extcon-gpio.h>
> 
> Is it necessary? I think it is your mistake?

right. my bad.
> 
>> +#include <linux/gpio.h>
> 
> Don't need it because 'of_gpio.h' includes already 'gpio.h'.

agreed.

> 
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
>> +static void usb_extcon_detect_cable(struct work_struct *work)
>> +{
>> +	int id;
>> +	struct usb_extcon_info *info;
>> +	const char **cable_names;
>> +
>> +	info  = container_of(to_delayed_work(work), struct usb_extcon_info,
>> +			     wq_detcable);
>> +	cable_names = info->edev->supported_cable;
> 
> I think you can use 'usb_extcon_cable' instead of 'cable_names'.
> So, you will remove 'cable_names' variable.
> 
OK.

>> +
>> +	/* check ID and update cable state */
>> +	id = gpiod_get_value_cansleep(info->id_gpiod);
>> +
>> +	if (id) {
>> +		/*
>> +		 * ID = 1 means USB HOST cable detached.
>> +		 * As we don't have event for USB peripheral cable attached,
>> +		 * we simulate USB peripheral attach here.
>> +		 */
>> +		extcon_set_cable_state(info->edev,
>> +				       cable_names[EXTCON_CABLE_USB_HOST],
>> +				       false);
>> +		extcon_set_cable_state(info->edev,
>> +				       cable_names[EXTCON_CABLE_USB], true);
>> +	} else {
>> +		/*
>> +		 * ID = 0 means USB HOST cable attached.
>> +		 * As we don't have event for USB peripheral cable detached,
>> +		 * we simulate USB peripheral detach here.
>> +		 */
>> +		extcon_set_cable_state(info->edev,
>> +				       cable_names[EXTCON_CABLE_USB], false);
>> +		extcon_set_cable_state(info->edev,
>> +				       cable_names[EXTCON_CABLE_USB_HOST],
>> +				       true);
>> +	}
>> +}
>> +
>> +static irqreturn_t usb_irq_handler(int irq, void *dev_id)
>> +{
>> +	struct usb_extcon_info *info = dev_id;
>> +
>> +	/* debounce the GPIO via delayed work */
> 
> I think this comment is not necessary.

OK.
> 
>> +	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
>> +			   info->debounce_jiffies);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int usb_extcon_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +	struct usb_extcon_info *info;
>> +	int ret;
>> +
>> +	if (!np)
>> +		return -EINVAL;
>> +
>> +	info = devm_kzalloc(&pdev->dev, sizeof(struct usb_extcon_info),
> 
> sizeof(struct usb_extcon_info) -> sizeof(*info)
>
right.
 
>> +			    GFP_KERNEL);
>> +	if (!info)
>> +		return -ENOMEM;
>> +
>> +	info->dev = dev;
>> +	info->id_gpiod = devm_gpiod_get(&pdev->dev, "id");
>> +	if (IS_ERR(info->id_gpiod)) {
>> +		dev_err(dev, "failed to get ID GPIO\n");
>> +		return PTR_ERR(info->id_gpiod);
>> +	}
>> +
>> +	ret = gpiod_set_debounce(info->id_gpiod,
>> +				 USB_GPIO_DEBOUNCE_MS * 1000);
>> +	if (ret < 0)
>> +		info->debounce_jiffies = msecs_to_jiffies(USB_GPIO_DEBOUNCE_MS);
>> +
>> +	INIT_DELAYED_WORK(&info->wq_detcable, usb_extcon_detect_cable);
>> +
>> +	info->id_irq = gpiod_to_irq(info->id_gpiod);
>> +	if (info->id_irq < 0) {
>> +		dev_err(dev, "failed to get ID IRQ\n");
>> +		return info->id_irq;
>> +	}
>> +
>> +	ret = devm_request_threaded_irq(dev, info->id_irq, NULL,
>> +					usb_irq_handler,
>> +					IRQF_SHARED | IRQF_ONESHOT,
> 
> I prefer to add IRQF_NO_SUSPEND flag because IRQF_NO_SUSPEND flag is necessary
> for wake-up from freeze pm state.

Agreed.
> 
>> +					pdev->name, info);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to request handler for ID IRQ\n");
>> +		return ret;
>> +	}
>> +
>> +	info->edev = devm_extcon_dev_allocate(dev, usb_extcon_cable);
>> +	if (IS_ERR(info->edev)) {
>> +		dev_err(dev, "failed to allocate extcon device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	ret = devm_extcon_dev_register(dev, info->edev);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to allocate extcon device\n");
> 
> Wrong error information, you have to change verb (allocate -> register)

will fix.
> 
>> +		return ret;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, info);
> 
> Need blank line.

OK.
> 
>> +	/* Perform initial detection */
>> +	usb_extcon_detect_cable(&info->wq_detcable.work);
>> +
>> +	return 0;
>> +}
>> +
>> +static int usb_extcon_remove(struct platform_device *pdev)
>> +{
>> +	struct usb_extcon_info *info = platform_get_drvdata(pdev);
>> +
>> +	cancel_delayed_work_sync(&info->wq_detcable);
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int usb_extcon_suspend(struct device *dev)
>> +{
>> +	struct usb_extcon_info *info;
>> +
>> +	info = dev_get_drvdata(dev);
> 
> Simplify this code as following:
> 	struct usb_extcon_info *info = dev_get_drvdata(dev);

OK.
> 
>> +
>> +	if (!IS_ERR(info->id_gpiod))
> 
> I think that it is sufficient cheking without IS_ERR macro as following:
> 	if (info->id_gpiod)

I will remove this if check as we're failing probe if id_gpiod is not valid.

> 
>> +		enable_irq_wake(info->id_irq);
>> +
>> +	return 0;
>> +}
>> +
>> +static int usb_extcon_resume(struct device *dev)
>> +{
>> +	struct usb_extcon_info *info;
>> +
>> +	info = dev_get_drvdata(dev);
> 
> ditto.
> 
>> +
>> +	if (!IS_ERR(info->id_gpiod))
> 
> ditto.
> 
>> +		disable_irq_wake(info->id_irq);
>> +
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static SIMPLE_DEV_PM_OPS(usb_extcon_pm_ops,
>> +			 usb_extcon_suspend, usb_extcon_resume);
>> +
>> +static struct of_device_id usb_extcon_dt_match[] = {
>> +	{ .compatible = "linux,extcon-usb", },
> 
> Change compatible name from "linux,extcon-usb", to "linux,extcon-gpio-usb".
> 

will use "linux,extcon-usb-gpio"

>> +	{ /* end */ }
>> +};
>> +
>> +static struct platform_driver usb_extcon_driver = {
>> +	.probe		= usb_extcon_probe,
>> +	.remove		= usb_extcon_remove,
>> +	.driver		= {
>> +		.name	= "extcon-usb",
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

cheers,
-roger
