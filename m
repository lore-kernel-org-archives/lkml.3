Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3H0Oky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:40:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42760 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab3H0Okw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:40:52 -0400
Date: Tue, 27 Aug 2013 15:40:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fabian Vogt <fabian@ritter-vogt.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH V4] gpio: New driver for LSI ZEVIO SoCs
Message-ID: <20130827144043.GN19893@e106331-lin.cambridge.arm.com>
References: <1377460180-6192-1-git-send-email-fabian@ritter-vogt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377460180-6192-1-git-send-email-fabian@ritter-vogt.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 08:49:40PM +0100, Fabian Vogt wrote:
> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.
> ---
>  .../devicetree/bindings/gpio/gpio-zevio.txt        |  18 ++
>  drivers/gpio/Kconfig                               |   6 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-zevio.c                          | 214 +++++++++++++++++++++
>  4 files changed, 239 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>  create mode 100644 drivers/gpio/gpio-zevio.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
> new file mode 100644
> index 0000000..892f953
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
> @@ -0,0 +1,18 @@
> +Zevio GPIO controller
> +
> +Required properties:
> +- compatible = "lsi,zevio-gpio"
> +- reg = <BASEADDR SIZE>
> +- #gpio-cells = <2>
> +- gpio-controller;

I take it there's nothing else known about at present that we might want
to describe in future (e.g. input clocks)?

This is more for the other dt maintainers, but I've seen a lot of
variation in how we describe properties, and it would be nice to unify
that. Does anyone fancy writing a document pushing for some standard
terminology and formatting, or should I?

> +
> +Optional:
> +- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent
> +
> +Example:
> +	gpio: gpio@90000000 {
> +		compatible = "lsi,zevio-gpio";
> +		reg = <0x90000000 0x1000>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b2450ba..49f8c62 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -138,6 +138,12 @@ config GPIO_EP93XX
>  	depends on ARCH_EP93XX
>  	select GPIO_GENERIC
>  
> +config GPIO_ZEVIO
> +	bool "LSI ZEVIO SoC memory mapped GPIOs"
> +	depends on OF
> +	help
> +	  Say yes here to support the GPIO controller in LSI ZEVIO SoCs.
> +
>  config GPIO_MM_LANTIQ
>  	bool "Lantiq Memory mapped GPIOs"
>  	depends on LANTIQ && SOC_XWAY
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index ef3e983..b70cb1b 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -87,3 +87,4 @@ obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
>  obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
>  obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
>  obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
> +obj-$(CONFIG_GPIO_ZEVIO)	+= gpio-zevio.o
> diff --git a/drivers/gpio/gpio-zevio.c b/drivers/gpio/gpio-zevio.c
> new file mode 100644
> index 0000000..35a254b
> --- /dev/null
> +++ b/drivers/gpio/gpio-zevio.c
> @@ -0,0 +1,214 @@
> +/*
> + * GPIO controller in LSI ZEVIO SoCs.
> + *
> + * Author: Fabian Vogt <fabian@ritter-vogt.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/io.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +
> +/*
> + * Memory layout:
> + * This chip has four gpio sections, each controls 8 GPIOs.
> + * Bit 0 in section 0 is GPIO 0, bit 2 in section 1 is GPIO 10.
> + * Disclaimer: Reverse engineered!
> + * For more information refer to:
> + * http://hackspire.unsads.com/wiki/index.php/Memory-mapped_I/O_ports#90000000_-_General_Purpose_I.2FO_.28GPIO.29
> + *
> + * 0x00-0x3F: Section 0
> + *     +0x00: Masked interrupt status (read-only)
> + *     +0x04: R: Interrupt status W: Reset interrupt status
> + *     +0x08: R: Interrupt mask W: Mask interrupt
> + *     +0x0C: W: Unmask interrupt (write-only)
> + *     +0x10: Direction: I/O=1/0
> + *     +0x14: Output
> + *     +0x18: Input (read-only)
> + *     +0x20: R: Level interrupt W: Set as level interrupt
> + * 0x40-0x7F: Section 1
> + * 0x80-0xBF: Section 2
> + * 0xC0-0xFF: Section 3
> + */
> +
> +#define ZEVIO_GPIO_SECTION_SIZE			0x40
> +
> +#define ZEVIO_GPIO_INT_MASKED_STATUS_OFFSET	0x00
> +#define ZEVIO_GPIO_INT_STATUS_OFFSET		0x04
> +#define ZEVIO_GPIO_INT_UNMASK_OFFSET		0x08
> +#define ZEVIO_GPIO_INT_MASK_OFFSET		0x0C
> +#define ZEVIO_GPIO_DIRECTION_OFFSET		0x10
> +#define ZEVIO_GPIO_OUTPUT_OFFSET		0x14
> +#define ZEVIO_GPIO_INPUT_OFFSET			0x18
> +#define ZEVIO_GPIO_INT_STICKY_OFFSET		0x20
> +
> +#define to_zevio_gpio(chip) container_of(to_of_mm_gpio_chip(chip), \
> +				struct zevio_gpio, chip)
> +
> +/* Bit of GPIO in section */
> +#define ZEVIO_GPIO_BIT(gpio) (gpio&7)
> +/* Offset to section of GPIO relative to base */
> +#define ZEVIO_GPIO_SECTION_OFFSET(gpio) (((gpio>>3)&3)*ZEVIO_GPIO_SECTION_SIZE)

Some spacing in these would really aid readability.

> +/* Address of register, which is responsible for given GPIO */
> +#define ZEVIO_GPIO(cntrlr, gpio, reg) IOMEM(cntrlr->chip.regs + \
> +		ZEVIO_GPIO_SECTION_OFFSET(gpio) + ZEVIO_GPIO_##reg##_OFFSET)
> +
> +struct zevio_gpio {
> +	spinlock_t		lock;
> +	struct of_mm_gpio_chip	chip;
> +};
> +
> +/* Functions for struct gpio_chip */
> +static int zevio_gpio_get(struct gpio_chip *chip, unsigned pin)
> +{
> +	struct zevio_gpio *controller = to_zevio_gpio(chip);
> +
> +	/* Only reading allowed, so no spinlock needed */
> +	u32 val = readl(ZEVIO_GPIO(controller, pin, INPUT));
> +
> +	return (val >> ZEVIO_GPIO_BIT(pin)) & 0x1;
> +}
> +
> +static void zevio_gpio_set(struct gpio_chip *chip, unsigned pin, int value)
> +{
> +	struct zevio_gpio *controller = to_zevio_gpio(chip);
> +	u32 val;
> +
> +	spin_lock(&controller->lock);
> +	val = readl(ZEVIO_GPIO(controller, pin, OUTPUT));
> +	if (value)
> +		val |= BIT(ZEVIO_GPIO_BIT(pin));
> +	else
> +		val &= ~(BIT(ZEVIO_GPIO_BIT(pin)));
> +
> +	writel(val, ZEVIO_GPIO(controller, pin, OUTPUT));
> +	spin_unlock(&controller->lock);
> +}
> +
> +static int zevio_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
> +{
> +	struct zevio_gpio *controller = to_zevio_gpio(chip);
> +	u32 val;
> +
> +	spin_lock(&controller->lock);
> +
> +	val = readl(ZEVIO_GPIO(controller, pin, DIRECTION));
> +	val |= BIT(ZEVIO_GPIO_BIT(pin));
> +	writel(val, ZEVIO_GPIO(controller, pin, DIRECTION));
> +
> +	spin_unlock(&controller->lock);
> +
> +	return 0;
> +}
> +
> +static int zevio_gpio_direction_output(struct gpio_chip *chip,
> +				       unsigned pin, int value)
> +{
> +	struct zevio_gpio *controller = to_zevio_gpio(chip);
> +	u32 val;
> +
> +	spin_lock(&controller->lock);
> +	val = readl(ZEVIO_GPIO(controller, pin, OUTPUT));
> +	if (value)
> +		val |= BIT(ZEVIO_GPIO_BIT(pin));
> +	else
> +		val &= ~(BIT(ZEVIO_GPIO_BIT(pin)));
> +
> +	writel(val, ZEVIO_GPIO(controller, pin, OUTPUT));
> +	val = readl(ZEVIO_GPIO(controller, pin, DIRECTION));
> +	val &= ~(BIT(ZEVIO_GPIO_BIT(pin)));
> +	writel(val, ZEVIO_GPIO(controller, pin, DIRECTION));
> +
> +	spin_unlock(&controller->lock);
> +
> +	return 0;
> +}
> +
> +static int zevio_gpio_to_irq(struct gpio_chip *chip, unsigned pin)
> +{
> +	/* TODO: Implement IRQs.
> +           Not implemented yet due to weird lockups */

	/*
	 * Normally our multi-line block comments look something like
	 * this, with aligned asterisks down the left-hand side.
	 */

> +
> +	return -ENXIO;
> +}
> +
> +static struct gpio_chip zevio_gpio_chip = {
> +	.direction_input	= zevio_gpio_direction_input,
> +	.direction_output	= zevio_gpio_direction_output,
> +	.set			= zevio_gpio_set,
> +	.get			= zevio_gpio_get,
> +	.to_irq			= zevio_gpio_to_irq,
> +	.base			= 0,
> +	.owner			= THIS_MODULE,
> +	.ngpio			= 32, /* Default, if not given in DT */
> +	.of_gpio_n_cells	= 2,
> +};
> +
> +/* Initialization */
> +static int zevio_gpio_probe(struct platform_device *pdev)
> +{
> +	struct zevio_gpio *controller;
> +	int status, i;
> +	u32 ngpio;
> +
> +	controller = devm_kzalloc(&pdev->dev, sizeof(*controller), GFP_KERNEL);
> +	if (!controller) {
> +		dev_err(&pdev->dev, "not enough free memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy our reference */
> +	controller->chip.gc = zevio_gpio_chip;
> +	controller->chip.gc.dev = &pdev->dev;
> +
> +	if (!of_property_read_u32(pdev->dev.of_node, "ngpios", &ngpio))
> +		controller->chip.gc.ngpio = ngpio;
> +
> +	status = of_mm_gpiochip_add(pdev->dev.of_node, &(controller->chip));
> +	if (status) {
> +		kfree(controller);

You shouldn't mix up the devm_* functions with their non devm_*
variants. devm_kzalloc should only be used with devm_kfree. Even better,
if you return an error in your probe function, the devm_kfree will
happen automatically anyway.

> +		dev_err(&pdev->dev, "failed to add gpiochip: %d\n", status);
> +		return status;
> +	}
> +
> +	spin_lock_init(&(controller->lock));

I don't think you need those inner brackets.

> +
> +	/* Disable interrupts, they only cause errors */
> +	for (i = 0; i < controller->chip.gc.ngpio; i += 8)
> +		writel(0xFF, ZEVIO_GPIO(controller, i, INT_MASK));

I thought I must have lost some context here, but I see that ZEVIO_GPIO
does some concatenation to get ZEVIO_GPIO_INT_MASK_OFFSET. I'm not sure
if people have any feelings on that kind of thing in drivers.

Thanks,
Mark.

> +
> +	dev_dbg(controller->chip.gc.dev, "ZEVIO GPIO controller set up!\n");
> +
> +	return 0;
> +}
> +
> +static struct of_device_id zevio_gpio_of_match[] = {
> +	{ .compatible = "lsi,zevio-gpio", },
> +	{ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, zevio_gpio_of_match);
> +
> +static struct platform_driver zevio_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-zevio",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(zevio_gpio_of_match),
> +	},
> +	.probe		= zevio_gpio_probe,
> +};
> +
> +module_platform_driver(zevio_gpio_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Fabian Vogt <fabian@ritter-vogt.de>");
> +MODULE_DESCRIPTION("LSI ZEVIO SoC GPIO driver");
> -- 
> 1.8.1.4
> 
> 
