Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3A0NO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:14:58 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52719 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3A0NO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:14:56 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 08:14:55 EST
MIME-Version: 1.0
In-Reply-To: <1358856404-8975-6-git-send-email-stigge@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-6-git-send-email-stigge@antcom.de>
Date: Sun, 27 Jan 2013 14:07:14 +0100
Message-ID: <CAOY=C6E-+uKQGbRDjNh5ZP9Wrmd+PNbt7djkBTzwe29=qA1_PA@mail.gmail.com>
Subject: Re: [PATCH 5/6 v14] gpio: Add device tree support to block GPIO API
From: Stijn Devriendt <highguy@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 1:06 PM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adds device tree support to the block GPIO API.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> ---
>  Documentation/devicetree/bindings/gpio/gpio-block.txt |   36 ++++++
>  drivers/gpio/Makefile                                 |    1
>  drivers/gpio/gpioblock-of.c                           |  100 ++++++++++++++++++
>  3 files changed, 137 insertions(+)
>
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio-block.txt
> @@ -0,0 +1,36 @@
> +Block GPIO definition
> +=====================
> +
> +This binding specifies arbitrary blocks of gpios, combining gpios from one or
> +more GPIO controllers together, to form a word for r/w access.
> +
> +Required property:
> +- compatible: must be "linux,gpio-block"
> +
> +Required subnodes:
> +- the name will be the registered name of the block
> +- property "gpios" is a list of gpios for the respective block
> +
> +Example:
> +
> +        blockgpio {
> +                compatible = "linux,gpio-block";
> +
> +                block0 {
> +                        gpios = <&gpio 3 0 0>,
> +                                <&gpio 3 1 0>;
> +                };
> +                block1 {
> +                        gpios = <&gpio 4 1 0>,
> +                                <&gpio 4 3 0>,
> +                                <&gpio 4 2 0>,
> +                                <&gpio 4 4 0>,
> +                                <&gpio 4 5 0>,
> +                                <&gpio 4 6 0>,
> +                                <&gpio 4 7 0>,
> +                                <&gpio 4 8 0>,
> +                                <&gpio 4 9 0>,
> +                                <&gpio 4 10 0>,
> +                                <&gpio 4 19 0>;
> +                };
> +        };

How do you see bindings for other kinds of drivers?

In my patchset, it's possible for other drivers to use gpio-blocks.
One example we have is a power sequencer with 2 pins attached
to GPIO pins. These 2 pins form a 2bit word to select power margining.
These 2 pins need to be set synchronously (as otherwise when going
from profile 0 to profile 3 you pass either profile 1 or profile 2 which
could be bad for hardware)

In the device-tree this is specified as:

powr@0x20 {
   // other properties

  gpios = <&gpio 4 0
               &gpio 5 0>;
};

Is this kind of integration also possible?

Regards,
Stijn

> --- linux-2.6.orig/drivers/gpio/Makefile
> +++ linux-2.6/drivers/gpio/Makefile
> @@ -5,6 +5,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)    += -DDEBUG
>  obj-$(CONFIG_GPIOLIB)          += gpiolib.o devres.o
>  obj-$(CONFIG_OF_GPIO)          += gpiolib-of.o
>  obj-$(CONFIG_GPIO_ACPI)                += gpiolib-acpi.o
> +obj-$(CONFIG_OF_GPIO)          += gpioblock-of.o
>
>  # Device drivers. Generally keep list sorted alphabetically
>  obj-$(CONFIG_GPIO_GENERIC)     += gpio-generic.o
> --- /dev/null
> +++ linux-2.6/drivers/gpio/gpioblock-of.c
> @@ -0,0 +1,100 @@
> +/*
> + * OF implementation for Block GPIO
> + *
> + * Copyright (C) 2012 Roland Stigge <stigge@antcom.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +static int gpioblock_of_probe(struct platform_device *pdev)
> +{
> +       struct device_node *block;
> +       unsigned *gpios;
> +       int ngpio;
> +       int ret;
> +       struct gpio_block *gb;
> +
> +       for_each_available_child_of_node(pdev->dev.of_node, block) {
> +               int i;
> +
> +               ngpio = of_gpio_count(block);
> +               if (ngpio < 1) {
> +                       ret = -ENODEV;
> +                       goto err1;
> +               }
> +
> +               gpios = kzalloc(ngpio * sizeof(*gpios), GFP_KERNEL);
> +               if (!gpios) {
> +                       ret = -ENOMEM;
> +                       goto err1;
> +               }
> +
> +               for (i = 0; i < ngpio; i++) {
> +                       ret = of_get_gpio(block, i);
> +                       if (ret < 0)
> +                               goto err2; /* expect -EPROBE_DEFER */
> +                       gpios[i] = ret;
> +               }
> +               gb = gpio_block_create(gpios, ngpio, block->name);
> +               if (IS_ERR(gb)) {
> +                       dev_err(&pdev->dev,
> +                               "Error creating GPIO block from device tree\n");
> +                       ret = PTR_ERR(gb);
> +                       goto err2;
> +               }
> +               ret = gpio_block_register(gb);
> +               if (ret < 0)
> +                       goto err3;
> +
> +               kfree(gpios);
> +               dev_info(&pdev->dev, "Registered gpio block %s: %d gpios\n",
> +                        block->name, ngpio);
> +       }
> +       return 0;
> +
> +err3:
> +       gpio_block_free(gb);
> +err2:
> +       kfree(gpios);
> +err1:
> +       of_node_put(block);
> +       return ret;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id gpioblock_of_match[] = {
> +       { .compatible = "linux,gpio-block", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, gpioblock_of_match);
> +#endif
> +
> +static struct platform_driver gpioblock_of_driver = {
> +       .driver = {
> +               .name = "gpio-block",
> +               .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(gpioblock_of_match),
> +
> +       },
> +       .probe  = gpioblock_of_probe,
> +};
> +
> +module_platform_driver(gpioblock_of_driver);
> +
> +MODULE_DESCRIPTION("GPIO Block driver");
> +MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:gpioblock-of");
