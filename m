Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaI3LLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:11:15 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:65046 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaI3LLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:11:11 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 30 Sep 2014 13:08:29 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Message-ID: <20140930110829.GB24736@localhost>
References: <1411624319-5596-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411624319-5596-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:21:58AM +0530, Muthu Mani wrote:
> Adds support for USB-GPIO interface of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> The GPIO get/set can be done through vendor command on control endpoint.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---
>  drivers/gpio/Kconfig          |  13 +++
>  drivers/gpio/Makefile         |   1 +
>  drivers/gpio/gpio-cyusbs23x.c | 182 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 196 insertions(+)
>  create mode 100644 drivers/gpio/gpio-cyusbs23x.c
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 9de1515..932e07c 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -886,6 +886,19 @@ config GPIO_BCM_KONA
>  
>  comment "USB GPIO expanders:"
>  
> +config GPIO_CYUSBS23X
> +	tristate "CYUSBS23x GPIO support"
> +	depends on MFD_CYUSBS23X && USB
> +	help
> +	  Say yes here to access the GPIO signals of Cypress
> +	  Semiconductor CYUSBS23x USB Serial Bridge Controller.
> +
> +	  This driver enables the GPIO interface of CYUSBS23x USB Serial
> +	  Bridge controller.
> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called gpio-cyusbs23x.
> +
>  config GPIO_VIPERBOARD
>  	tristate "Viperboard GPIO a & b support"
>  	depends on MFD_VIPERBOARD && USB
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 5d024e3..3ad89f1 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
>  obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
>  obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
>  obj-$(CONFIG_GPIO_CRYSTAL_COVE)	+= gpio-crystalcove.o
> +obj-$(CONFIG_GPIO_CYUSBS23X)	+= gpio-cyusbs23x.o
>  obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
>  obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
>  obj-$(CONFIG_GPIO_DAVINCI)	+= gpio-davinci.o
> diff --git a/drivers/gpio/gpio-cyusbs23x.c b/drivers/gpio/gpio-cyusbs23x.c
> new file mode 100644
> index 0000000..ad83b00
> --- /dev/null
> +++ b/drivers/gpio/gpio-cyusbs23x.c
> @@ -0,0 +1,182 @@
> +/*
> + * GPIO subdriver for Cypress CYUSBS234 USB-Serial Bridge controller.
> + * Details about the device can be found at:
> + *    http://www.cypress.com/?rID=84126
> + * All GPIOs are exposed for get operation and only unused GPIOs can be set.
> + *
> + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> + *
> + * Author:
> + *   Muthu Mani <muth@cypress.com>
> + *
> + * Additional contributors include:
> + *   Rajaram Regupathy <rera@cypress.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/usb.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/mfd/cyusbs23x.h>
> +
> +#define CY_GPIO_GET_LEN		(2)

No parentheses.

> +
> +struct cyusbs_gpio {
> +	struct gpio_chip gpio;
> +	struct cyusbs23x *cyusbs;
> +};
> +
> +static int cy_gpio_get(struct gpio_chip *chip,
> +			unsigned offset)
> +{
> +	int ret;
> +	char *buf;
> +	u16 wIndex, wValue;
> +	struct cyusbs_gpio *gpio =
> +				container_of(chip, struct cyusbs_gpio, gpio);

Add helper macro?

> +	struct cyusbs23x *cyusbs = gpio->cyusbs;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
> +		offset);

Drop this.

> +	wValue = offset;
> +	wIndex = 0;
> +	buf = kmalloc(CY_GPIO_GET_LEN, GFP_KERNEL);

Error handling missing.

> +
> +	mutex_lock(&cyusbs->lock);

Locking not needed.

> +	ret = usb_control_msg(cyusbs->usb_dev,
> +			usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> +			CY_GPIO_GET_VALUE_CMD,
> +			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +			wValue, wIndex, buf, CY_GPIO_GET_LEN, 2000);

timeout define.

> +	mutex_unlock(&cyusbs->lock);
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d %02x %02x\n", __func__,
> +		ret, buf[0], buf[1]);

Use the gpio_chip device rather than usb-interface device in gpio
callbacks for debug and error messages.

> +
> +	if (ret == CY_GPIO_GET_LEN) {
> +		if (buf[0] == 0)
> +			ret = buf[1];
> +		else
> +			ret = -EINVAL;
> +	} else {
> +		ret = -EREMOTEIO;
> +	}

Just use -EIO for both error cases.

> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static void cy_gpio_set(struct gpio_chip *chip,
> +			unsigned offset, int value)
> +{
> +	int ret;
> +	u16 wIndex, wValue;
> +	struct cyusbs_gpio *gpio =
> +			container_of(chip, struct cyusbs_gpio, gpio);
> +	struct cyusbs23x *cyusbs = gpio->cyusbs;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
> +		offset);

Drop.

> +	wValue = offset;
> +	wIndex = value;
> +
> +	mutex_lock(&cyusbs->lock);

Not needed.

> +	ret = usb_control_msg(cyusbs->usb_dev,
> +			usb_sndctrlpipe(cyusbs->usb_dev, 0),
> +			CY_GPIO_SET_VALUE_CMD,
> +			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +			wValue, wIndex, NULL, 0, 2000);
> +	mutex_unlock(&cyusbs->lock);
> +
> +	if (ret < 0)
> +		dev_err(&cyusbs->usb_intf->dev, "error setting gpio:%d\n", ret);

Add a space before %d.

> +}
> +
> +static int cy_gpio_direction_input(struct gpio_chip *chip,
> +					unsigned offset)
> +{
> +	return 0;
> +}
> +
> +static int cy_gpio_direction_output(struct gpio_chip *chip,
> +					unsigned offset, int value)
> +{
> +	return 0;
> +}

This is not a correct implementation of these. You're are supposed to
return what direction the gpio is configured for. You should also add a
call back to set the direction.

> +
> +static int cyusbs23x_gpio_probe(struct platform_device *pdev)
> +{
> +	struct cyusbs23x *cyusbs;
> +	struct cyusbs_gpio *cy_gpio;
> +	int ret = 0;
> +
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +	cyusbs = dev_get_drvdata(pdev->dev.parent);
> +
> +	cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
> +	if (cy_gpio == NULL)
> +		return -ENOMEM;
> +
> +	cy_gpio->cyusbs = cyusbs;
> +	/* registering gpio */
> +	cy_gpio->gpio.label = dev_name(&pdev->dev);
> +	cy_gpio->gpio.dev = &pdev->dev;
> +	cy_gpio->gpio.owner = THIS_MODULE;
> +	cy_gpio->gpio.base = -1;
> +	cy_gpio->gpio.ngpio = 12; /* total GPIOs */
> +	cy_gpio->gpio.can_sleep = true;
> +	cy_gpio->gpio.set = cy_gpio_set;
> +	cy_gpio->gpio.get = cy_gpio_get;
> +	cy_gpio->gpio.direction_input = cy_gpio_direction_input;
> +	cy_gpio->gpio.direction_output = cy_gpio_direction_output;
> +	ret = gpiochip_add(&cy_gpio->gpio);
> +	if (ret < 0) {
> +		dev_err(cy_gpio->gpio.dev, "could not add gpio");

Missing '\n' in message (double check throughout).

Just return here and get rid of the error label below.

> +		goto error;
> +	}
> +
> +	platform_set_drvdata(pdev, cy_gpio);
> +
> +	dev_dbg(&pdev->dev, "added GPIO\n");
> +	return ret;
> +
> +error:
> +	dev_dbg(&pdev->dev, "error occured %d\n", ret);
> +	return ret;
> +}
> +
> +static int cyusbs23x_gpio_remove(struct platform_device *pdev)
> +{
> +	struct cyusbs_gpio *cy_gpio = platform_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +	gpiochip_remove(&cy_gpio->gpio);
> +	return 0;
> +}
> +
> +static struct platform_driver cyusbs23x_gpio_driver = {
> +	.driver.name    = "cyusbs23x-gpio",
> +	.driver.owner   = THIS_MODULE,

No need to set the owner field when using module_platform_driver (check
i2c driver as well).

> +	.probe          = cyusbs23x_gpio_probe,
> +	.remove         = cyusbs23x_gpio_remove,
> +};
> +
> +module_platform_driver(cyusbs23x_gpio_driver);
> +
> +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> +MODULE_DESCRIPTION("GPIO driver for CYUSBS23x");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:cyusbs23x-gpio");

Johan
