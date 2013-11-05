Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3KEVcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:32:04 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61729 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3KEVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:32:01 -0500
Message-ID: <527963CA.5010701@gmail.com>
Date: Tue, 05 Nov 2013 22:31:54 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Alan Tull <delicious.quinoa@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
References: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com> <1383670552-17566-2-git-send-email-delicious.quinoa@gmail.com>
In-Reply-To: <1383670552-17566-2-git-send-email-delicious.quinoa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 05:55 PM, Alan Tull wrote:
> From: Jamie Iles <jamie@jamieiles.com>
>
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
>
> v5:	- handle sparse bank population correctly
> v3:	- depend on rather than select IRQ_DOMAIN
> 	- split IRQ support into a separate patch
> v2:	- use Rob Herring's irqdomain in generic irq chip patches
> 	- use reg property to indicate bank index
> 	- support irqs on both edges based on LinusW's u300 driver
>

Alan,

thanks for reposting this. I haven't reviewed one of the earlier
versions, so some of my comments may be referring to already answered
questions.

> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>   .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   57 +++++++
>   drivers/gpio/Kconfig                               |    9 +
>   drivers/gpio/Makefile                              |    1 +
>   drivers/gpio/gpio-dwapb.c                          |  172 ++++++++++++++++++++
>   4 files changed, 239 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
>   create mode 100644 drivers/gpio/gpio-dwapb.c
>
> diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> new file mode 100644
> index 0000000..73adf37
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> @@ -0,0 +1,57 @@
> +* Synopsys DesignWare APB GPIO controller
> +
> +Required properties:
> +- compatible : Should be "snps,dw-apb-gpio"
> +- reg : Address and length of the register set for the device
> +
> +The GPIO controller has a configurable number of banks, each of which are
> +represented as child nodes with the following properties:
> +
> +Required properties:
> +- compatible : "snps,dw-apb-gpio-bank"

The register names refer to "bank" as "port", the above compatible
should also reflect this.

> +- gpio-controller : Marks the device node as a gpio controller.
> +- #gpio-cells : Should be two.  The first cell is the pin number and
> +  the second cell is used to specify optional parameters (currently
> +  unused).
> +- reg : The integer bank index of the bank, a single cell.
> +- nr-gpio : The number of pins in the bank, a single cell.

What about "nr-gpios" or "#gpios"? Also, this property should be
optional, as it can also be read from DW APB GPIOs CONFIG[12]
registers.

> +Optional properties:
> +- interrupt-controller : The first bank may be configured to be an interrupt
> +controller.
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
> +the second encodes the triger flags encoded as described in
> +Documentation/devicetree/bindings/interrupts.txt
> +- interrupt-parent : The parent interrupt controller.
> +- interrupts : The interrupts to the parent controller raised when GPIOs
> +generate the interrupts.
> +
> +Example:
> +
> +gpio: gpio@20000 {
> +	compatible = "snps,dw-apb-gpio";
> +	reg = <0x20000 0x1000>;
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	banka: gpio-controller@0 {
> +		compatible = "snps,dw-apb-gpio-bank";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		nr-gpio = <8>;
> +		reg = <0>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		interrupt-parent = <&vic1>;
> +		interrupts = <0 1 2 3 4 5 6 7>;
> +	};
> +
> +	bankb: gpio-controller@1 {
> +		compatible = "snps,dw-apb-gpio-bank";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		nr-gpio = <8>;
> +		reg = <1>;
> +	};
> +};
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b6ed304..c5e7868 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -121,6 +121,15 @@ config GPIO_GENERIC_PLATFORM
>   	help
>   	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
>
> +config GPIO_DWAPB
> +	bool "Synopsys DesignWare APB GPIO driver"
> +	select GPIO_GENERIC
> +	select GENERIC_IRQ_CHIP
> +	depends on OF_GPIO
> +	help
> +	  Say Y or M here to build support for the Synopsys DesignWare APB
> +	  GPIO block.  This requires device tree support.

I'd remove the comment about DT requirement, but leave the OF_GPIO
dependency. If not now, we will remove DT dependency for sure later.

>   config GPIO_IT8761E
>   	tristate "IT8761E GPIO support"
>   	depends on X86  # unconditional access to IO space.
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 98e23eb..8de041a 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
>   obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
>   obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
>   obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
> +obj-$(CONFIG_GPIO_DWAPB)	+= gpio-dwapb.o
>   obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
>   obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
>   obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> new file mode 100644
> index 0000000..3a28697
> --- /dev/null
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -0,0 +1,172 @@
> +/*
> + * Copyright (c) 2011 Jamie Iles
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * All enquiries to support@picochip.com
> + */
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/module.h>
> +#include <linux/basic_mmio_gpio.h>

alphabetical ordering

> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +
> +struct dwapb_gpio;
> +
> +struct dwapb_gpio_bank {

Again, "bank" is "port".

> +	struct bgpio_chip	bgc;
> +	unsigned int		bank_idx;
> +	bool			is_registered;
> +	struct dwapb_gpio	*gpio;
> +};
> +
> +struct dwapb_gpio {
> +	struct device_node	*of_node;
> +	struct	device		*dev;

What about taking dev.of_node instead of the an extra of_node ptr?

> +	void __iomem		*regs;
> +	struct dwapb_gpio_bank	*banks;
> +	unsigned int		nr_banks;

ditto and for the following "banks", too.

> +};
> +
> +static unsigned int dwapb_gpio_nr_banks(struct device_node *of_node)
> +{
> +	unsigned int nr_banks = 0;
> +	struct device_node *np;
> +
> +	for_each_child_of_node(of_node, np)
> +		++nr_banks;

In general, I'd prefer a DT agnostic driver based on platform_data
and DT parsing instead of using DT spread over the driver. Anyway,
I don't want to stall this patches even further, so it can be cleaned
up later.

> +	return nr_banks;
> +}
> +
> +static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
> +			       struct device_node *bank_np,
> +			       unsigned int offs)
> +{
> +	struct dwapb_gpio_bank *bank;
> +	u32 bank_idx, ngpio;
> +	int err;
> +
> +	if (of_property_read_u32(bank_np, "reg", &bank_idx)) {
> +		dev_err(gpio->dev, "invalid bank index for %s\n",
> +			bank_np->full_name);

index > 3 are also "invalid", of_property_read_u32 fails if it
is "missing".

> +		return -EINVAL;
> +	}
> +	bank = &gpio->banks[offs];
> +	bank->gpio = gpio;
> +
> +	if (of_property_read_u32(bank_np, "nr-gpio", &ngpio)) {
> +		dev_err(gpio->dev, "failed to get number of gpios for %s\n",
> +			bank_np->full_name);
> +		return -EINVAL;
> +	}
> +
> +	bank->bank_idx = bank_idx;
> +	err = bgpio_init(&bank->bgc, gpio->dev, 4,
> +			 gpio->regs + 0x50 + (bank_idx * 0x4),
> +			 gpio->regs + 0x00 + (bank_idx * 0xc),
> +			 NULL, gpio->regs + 0x04 + (bank_idx * 0xc), NULL,

#defines for the magic numbers above?

> +			 false);
> +	if (err) {
> +		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
> +			bank_np->full_name);
> +		return err;
> +	}
> +
> +	bank->bgc.gc.ngpio = ngpio;
> +	bank->bgc.gc.of_node = bank_np;
> +
> +	err = gpiochip_add(&bank->bgc.gc);
> +	if (err)
> +		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
> +			bank_np->full_name);
> +	else
> +		bank->is_registered = true;
> +
> +	return err;
> +}
> +
> +static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
> +{
> +	unsigned int m;
> +
> +	for (m = 0; m < gpio->nr_banks; ++m)
> +		if (gpio->banks[m].is_registered)
> +			WARN_ON(gpiochip_remove(&gpio->banks[m].bgc.gc));
> +	of_node_put(gpio->of_node);

I may be wrong here, but platform_device_unregister will finally remove
pdev and pdev->dev anyway. No need to put the node right before it.

> +}
> +
> +static int __devinit dwapb_gpio_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct dwapb_gpio *gpio;
> +	struct device_node *np;
> +	int err;
> +	unsigned int offs = 0;
> +
> +	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
> +	if (!gpio)
> +		return -ENOMEM;
> +	gpio->dev = &pdev->dev;
> +
> +	gpio->nr_banks = dwapb_gpio_nr_banks(pdev->dev.of_node);
> +	if (!gpio->nr_banks)
> +		return -EINVAL;
> +	gpio->banks = devm_kzalloc(&pdev->dev, gpio->nr_banks *
> +				   sizeof(*gpio->banks), GFP_KERNEL);
> +	if (!gpio->banks)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get iomem\n");
> +		return -ENXIO;
> +	}

devm_ioremap below can deal with NULL resources. I suggest to remove
the extra check and error message above, as devm_ioremap and friends
will also print error messages.

> +	gpio->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));

devm_ioremap_resource?

> +	if (!gpio->regs)
> +		return -ENOMEM;
> +
> +	gpio->of_node = of_node_get(pdev->dev.of_node);

no need to of_node_get here, and of_node_put above.

> +	for_each_child_of_node(pdev->dev.of_node, np) {
> +		err = dwapb_gpio_add_bank(gpio, np, offs++);
> +		if (err)
> +			goto out_unregister;
> +	}
> +	platform_set_drvdata(pdev, gpio);
> +
> +	return 0;
> +
> +out_unregister:
> +	dwapb_gpio_unregister(gpio);
> +
> +	return err;
> +}
> +
> +static const struct of_device_id dwapb_of_match_table[] = {
> +	{ .compatible = "snps,dw-apb-gpio" },
> +	{ /* Sentinel */ }
> +};
> +
> +static struct platform_driver dwapb_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-dwapb",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = dwapb_of_match_table,

use of_match_ptr(dwapb_of_match_table) now, we will need it later.

Sebastian

> +	},
> +	.probe		= dwapb_gpio_probe,
> +};
> +
> +static int __init dwapb_gpio_init(void)
> +{
> +	return platform_driver_register(&dwapb_gpio_driver);
> +}
> +postcore_initcall(dwapb_gpio_init);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jamie Iles");
> +MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
>

