Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaCGPRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:17:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39836 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:17:48 -0500
Date: Fri, 7 Mar 2014 09:14:55 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: thloh@altera.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        dinguyen@altera.com, lftan@altera.com, thloh.linux@gmail.com
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
Message-ID: <20140307151455.GI18529@joshc.qualcomm.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393842463-5206-1-git-send-email-thloh@altera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:27:43PM +0800, thloh@altera.com wrote:
> From: Tien Hock Loh <thloh@altera.com>
> 
> Add driver support for Altera GPIO soft IP, including interrupts and I/O.
> Tested on Altera CV SoC board using dipsw and LED using LED framework.
> 
> Signed-off-by: Tien Hock Loh <thloh@altera.com>
> ---
>  .../devicetree/bindings/gpio/gpio-altera.txt       |  44 +++
>  drivers/gpio/Kconfig                               |   7 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-altera.c                         | 419 +++++++++++++++++++++
>  4 files changed, 471 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt
>  create mode 100644 drivers/gpio/gpio-altera.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> new file mode 100644
> index 0000000..1de1f9b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> @@ -0,0 +1,44 @@
> +Altera GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "altr,pio-1.0"
> +- reg: Physical base address and length of the controller's registers.
> +- #gpio-cells : Should be 1
> +  - The first cell is the gpio offset number
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- #interrupt-cells : Should be 1.
> +  - The first cell is the GPIO offset number within the GPIO controller.
> +- interrupts: Specify the interrupt.
> +- interrupt-controller: Mark the device node as an interrupt controller
> +
> +Altera GPIO specific required properties:
> +- altr,interrupt_trigger: Specifies the interrupt trigger type the GPIO
> +  hardware is synthesized. This field is required if the Altera GPIO controller
> +  used has IRQ enabled as the interrupt type is not software controlled,
> +  but hardware synthesized. Required if GPIO is used as an interrupt
> +  controller. The value is defined in <dt-bindings/interrupt-controller/irq.h>
> +  Only the following flags are supported:
> +    IRQ_TYPE_EDGE_RISING
> +    IRQ_TYPE_EDGE_FALLING
> +    IRQ_TYPE_EDGE_BOTH
> +    IRQ_TYPE_LEVEL_HIGH

I'd suggest "altr,interrupt-trigger" (with a hyphen).  So, if I'm
understanding properly, this controller doesn't support per-gpio trigger
settings?

Low-level triggered interrupts aren't supported?

> +
> +Altera GPIO specific optional properties:
> +- altr,gpio-bank-width: Width of the GPIO bank. This defines how many pins the
> +  GPIO device has. Ranges between 1-32. Optional and defaults to 32 is not
> +  specified.

Generally, this is called 'ngpio', I think.  Might be nice to stay
consistent with other bindings.

> +
> +Example:
> +
> +gpio_altr: gpio@40000 {
> +    compatible = "altr,pio-1.0";
> +    reg = <0xff200000 0x10>;
> +    interrupts = <0 45 4>;
> +    altr,gpio-bank-width = <32>;
> +    altr,interrupt_trigger = <IRQ_TYPE_EDGE_RISING>;
> +    #gpio-cells = <1>;
> +    gpio-controller;
> +    #interrupt-cells = <1>;
> +    interrupt-controller;
> +};
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 6973387..07bccdf 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -128,6 +128,13 @@ config GPIO_GENERIC_PLATFORM
>  	help
>  	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
>  
> +config GPIO_ALTERA
> +       tristate "Altera GPIO"
> +       select IRQ_DOMAIN
> +       depends on OF_GPIO
> +       help
> +         Say yes here to support the Altera PIO device.

nit: you should use tabs for indentation instead of spaces to stay
consistent.

> +
>  config GPIO_IT8761E
>  	tristate "IT8761E GPIO support"
>  	depends on X86  # unconditional access to IO space.
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 5d50179..88374d2 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_GPIO_74X164)	+= gpio-74x164.o
>  obj-$(CONFIG_GPIO_ADNP)		+= gpio-adnp.o
>  obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
> +obj-$(CONFIG_GPIO_ALTERA)  	+= gpio-altera.o
>  obj-$(CONFIG_GPIO_AMD8111)	+= gpio-amd8111.o
>  obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
>  obj-$(CONFIG_GPIO_BCM_KONA)	+= gpio-bcm-kona.o
> diff --git a/drivers/gpio/gpio-altera.c b/drivers/gpio/gpio-altera.c
> new file mode 100644
> index 0000000..ab0738f
> --- /dev/null
> +++ b/drivers/gpio/gpio-altera.c
> @@ -0,0 +1,419 @@
> +/*
> + * Copyright (C) 2013 Altera Corporation
> + * Based on gpio-mpc8xxx.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/irqdomain.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include <linux/irqchip/chained_irq.h>
> +
> +#define ALTERA_GPIO_DATA		0x0
> +#define ALTERA_GPIO_DIR			0x4
> +#define ALTERA_GPIO_IRQ_MASK		0x8
> +#define ALTERA_GPIO_EDGE_CAP		0xc
> +#define ALTERA_GPIO_OUTSET		0x10
> +#define ALTERA_GPIO_OUTCLEAR		0x14
> +
> +/**
> +* struct altera_gpio_chip
> +* @mmchip		: memory mapped chip structure.
> +* @irq			: irq domain that this driver is registered to.

s/@irq/@domain/ ?

> +* @gpio_lock		: synchronization lock so that new irq/set/get requests
> +			  will be blocked until the current one completes.
> +* @interrupt_trigger	: specifies the hardware configured IRQ trigger type
> +			  (rising, falling, both, high)

@edge_type?

> +* @mapped_irq		: kernel mapped irq number.
> +*/
> +struct altera_gpio_chip {
> +	struct of_mm_gpio_chip mmchip;

I had never really looked into of_mm_gpio_chip before but...does this
really get you anything?  All it does is manage mapping your registers
for you; as far as I can tell it's just another layer of indirection
with no gain.

I'd suggest lifting 'regs' and 'chip' directly into your
altera_gpio_chip:

	struct altera_gpio_chip {
		struct gpio_chip chip;
		struct irq_domain *domain;
		void __iomem *regs;
		spinlock_t gpio_lock;
		int mapped_irq;
	};

[..]

> +static unsigned int altera_gpio_irq_startup(struct irq_data *d)
> +{
> +	altera_gpio_irq_unmask(d);
> +
> +	return 0;
> +}
> +
> +static void altera_gpio_irq_shutdown(struct irq_data *d)
> +{
> +	altera_gpio_irq_unmask(d);
> +}

Should you really even be touching masks in startup/shutdown?

> +static struct irq_chip altera_irq_chip = {
> +	.name		= "altera-gpio",
> +	.irq_mask	= altera_gpio_irq_mask,
> +	.irq_unmask	= altera_gpio_irq_unmask,
> +	.irq_set_type	= altera_gpio_irq_set_type,
> +	.irq_startup	= altera_gpio_irq_startup,
> +	.irq_shutdown	= altera_gpio_irq_shutdown,
> +};
> +
[..]
> +static int altera_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> +	struct altera_gpio_chip *altera_gc = container_of(mm_gc,
> +				struct altera_gpio_chip, mmchip);
> +
> +	if (!altera_gc->domain)
> +		return -ENXIO;

How could this happen (hint, move your domain creation before
gpiochip_add).

> +	if (offset < altera_gc->mmchip.gc.ngpio)
> +		return irq_find_mapping(altera_gc->domain, offset);
> +	else
> +		return -ENXIO;
> +}
> +
> +static void altera_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct altera_gpio_chip *altera_gc = irq_desc_get_handler_data(desc);
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	struct of_mm_gpio_chip *mm_gc = &altera_gc->mmchip;
> +	unsigned long status;
> +
> +	int i;
> +
> +	chained_irq_enter(chip, desc);
> +	/* Handling for level trigger and edge trigger is different */
> +	if (altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH) {

Suggestion: split this into two handling functions, install
one-or-the-other in your probe() based on the "altr,trigger-type"
property.  Bonus points: remove interrupt_trigger member from
altera_gpio_chip entirely.

> +		status = readl_relaxed(mm_gc->regs + ALTERA_GPIO_DATA);
> +		status &= readl_relaxed(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +
> +		for (i = 0; i < mm_gc->gc.ngpio; i++) {
> +			if (status & BIT(i)) {
> +				generic_handle_irq(irq_find_mapping(
> +					altera_gc->domain, i));
> +			}
> +		}

You may find for_each_set_bit() handy.

> +	} else {
> +		while ((status =
> +			(readl_relaxed(mm_gc->regs + ALTERA_GPIO_EDGE_CAP) &
> +			readl_relaxed(mm_gc->regs + ALTERA_GPIO_IRQ_MASK)))) {
> +			writel_relaxed(status,
> +				mm_gc->regs + ALTERA_GPIO_EDGE_CAP);
> +			for (i = 0; i < mm_gc->gc.ngpio; i++) {
> +				if (status & BIT(i)) {
> +					generic_handle_irq(irq_find_mapping(
> +						altera_gc->domain, i));
> +				}
> +			}
> +		}
> +	}
> +
> +	chained_irq_exit(chip, desc);
> +}
> +
> +static int altera_gpio_irq_map(struct irq_domain *h, unsigned int irq,
> +				irq_hw_number_t hw_irq_num)
> +{
> +	irq_set_chip_data(irq, h->host_data);
> +	irq_set_chip_and_handler(irq, &altera_irq_chip, handle_level_irq);
> +	irq_set_irq_type(irq, IRQ_TYPE_NONE);

Does irq_set_irq_type(irq, IRQ_TYPE_NONE) even do anything meaningful here?

> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops altera_gpio_irq_ops = {

const?

> +	.map	= altera_gpio_irq_map,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +int altera_gpio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	int i, id, reg, ret;
> +	struct altera_gpio_chip *altera_gc = devm_kzalloc(&pdev->dev,
> +				sizeof(*altera_gc), GFP_KERNEL);
> +	if (altera_gc == NULL) {
> +		pr_err("%s: out of memory\n", node->full_name);

This print is not necessary, as the allocator will complain loudly on
your behalf.  Also, I'd suggest you not define and initialize
'altera_gc' on the same line.

> +		return -ENOMEM;
> +	}
> +	altera_gc->domain = 0;
> +
> +	spin_lock_init(&altera_gc->gpio_lock);
> +
> +	id = pdev->id;
> +
> +	if (of_property_read_u32(node, "altr,gpio-bank-width", &reg))
> +		/*By default assume full GPIO controller*/
> +		altera_gc->mmchip.gc.ngpio = 32;
> +	else
> +		altera_gc->mmchip.gc.ngpio = reg;
> +
> +	if (altera_gc->mmchip.gc.ngpio > 32) {
> +		dev_warn(&pdev->dev,
> +			"ngpio is greater than 32, defaulting to 32\n");
> +		altera_gc->mmchip.gc.ngpio = 32;
> +	}
> +
> +	altera_gc->mmchip.gc.direction_input	= altera_gpio_direction_input;
> +	altera_gc->mmchip.gc.direction_output	= altera_gpio_direction_output;
> +	altera_gc->mmchip.gc.get		= altera_gpio_get;
> +	altera_gc->mmchip.gc.set		= altera_gpio_set;
> +	altera_gc->mmchip.gc.to_irq		= altera_gpio_to_irq;
> +	altera_gc->mmchip.gc.owner		= THIS_MODULE;
> +
> +	ret = of_mm_gpiochip_add(node, &altera_gc->mmchip);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed adding memory mapped gpiochip\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, altera_gc);
> +
> +	altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
>

platform_get_irq(pdev, 0);

> +
> +	if (!altera_gc->mapped_irq)
> +		goto skip_irq;
> +
> +	altera_gc->domain = irq_domain_add_linear(node,
> +		altera_gc->mmchip.gc.ngpio, &altera_gpio_irq_ops, altera_gc);
> +
> +	if (!altera_gc->domain) {
> +		ret = -ENODEV;
> +		goto dispose_irq;
> +	}
> +
> +	for (i = 0; i < altera_gc->mmchip.gc.ngpio; i++)
> +		irq_create_mapping(altera_gc->domain, i);
> +
> +	if (of_property_read_u32(node, "altr,interrupt_type", &reg)) {
> +		ret = -EINVAL;
> +		dev_err(&pdev->dev,
> +			"altr,interrupt_type value not set in device tree\n");
> +		goto teardown;
> +	}
> +	altera_gc->interrupt_trigger = reg;
> +
> +	irq_set_handler_data(altera_gc->mapped_irq, altera_gc);
> +	irq_set_chained_handler(altera_gc->mapped_irq, altera_gpio_irq_handler);
> +
> +	return 0;
> +
> +teardown:
> +	irq_domain_remove(altera_gc->domain);
> +dispose_irq:
> +	irq_dispose_mapping(altera_gc->mapped_irq);
> +	WARN_ON(gpiochip_remove(&altera_gc->mmchip.gc) < 0);
> +
> +	pr_err("%s: registration failed with status %d\n",
> +		node->full_name, ret);
> +
> +	return ret;
> +skip_irq:
> +	return 0;
> +}
> +
> +static int altera_gpio_remove(struct platform_device *pdev)
> +{
> +	unsigned int irq, i;
> +	int status;
> +	struct altera_gpio_chip *altera_gc = platform_get_drvdata(pdev);
> +
> +	status = gpiochip_remove(&altera_gc->mmchip.gc);
> +
> +	if (status < 0)
> +		return status;
> +
> +	if (altera_gc->domain) {

How could this happen?

> +		irq_dispose_mapping(altera_gc->mapped_irq);

Does irq_domain_remove() not teardown mappings?
> +
> +		for (i = 0; i < altera_gc->mmchip.gc.ngpio; i++) {
> +			irq = irq_find_mapping(altera_gc->domain, i);
> +			if (irq > 0)
> +				irq_dispose_mapping(irq);
> +		}
> +
> +		irq_domain_remove(altera_gc->domain);
> +	}
> +
> +	irq_set_handler_data(altera_gc->mapped_irq, NULL);
> +	irq_set_chained_handler(altera_gc->mapped_irq, NULL);
> +	return -EIO;
> +}
> +
> +static struct of_device_id altera_gpio_of_match[] = {

const?

> +	{ .compatible = "altr,pio-1.0", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, altera_gpio_of_match);
> +
> +static struct platform_driver altera_gpio_driver = {
> +	.driver = {
> +		.name	= "altera_gpio",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(altera_gpio_of_match),
> +	},
> +	.probe		= altera_gpio_probe,
> +	.remove		= altera_gpio_remove,
> +};
> +
> +static int __init altera_gpio_init(void)
> +{
> +	return platform_driver_register(&altera_gpio_driver);
> +}
> +subsys_initcall(altera_gpio_init);
> +
> +static void __exit altera_gpio_exit(void)
> +{
> +	platform_driver_unregister(&altera_gpio_driver);
> +}
> +module_exit(altera_gpio_exit);
> +
> +MODULE_AUTHOR("Tien Hock Loh <thloh@altera.com>");
> +MODULE_DESCRIPTION("Altera GPIO driver");
> +MODULE_LICENSE("GPL");

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
