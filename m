Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaESKjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:39:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:2472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaESKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:39:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,866,1392192000"; 
   d="scan'208";a="513901720"
Date: Mon, 19 May 2014 13:39:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140519103933.GK2067@lahna.fi.intel.com>
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:44:07PM +0800, Zhu, Lejun wrote:
> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
> 
> This patch adds support for the GPIO function in Crystal Cove.

I have few comments as well in addition to comments from Linus and
Alexandre.

Please see below.

> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/gpio/Kconfig            |   9 ++
>  drivers/gpio/Makefile           |   1 +
>  drivers/gpio/gpio-crystalcove.c | 323 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 333 insertions(+)
>  create mode 100644 drivers/gpio/gpio-crystalcove.c
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index a86c49a..95bb5a0 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -440,6 +440,15 @@ config GPIO_ARIZONA
>  	help
>  	  Support for GPIOs on Wolfson Arizona class devices.
>  
> +config GPIO_INTEL_SOC_PMIC
> +	bool "GPIO on Intel SoC PMIC"
> +	depends on INTEL_SOC_PMIC
> +	help
> +	  Support for GPIO pins on Intel SoC PMIC, such as Crystal
> +	  Cove.
> +	  Say Y if you have a tablet with Intel SoC (e.g. Baytrail)
> +	  inside.

I wonder if the Kconfig name sould be GPIO_CRYSTALCOVE or similar so
that it is easier to map the Kconfig option to the actual driver name?

> +
>  config GPIO_LP3943
>  	tristate "TI/National Semiconductor LP3943 GPIO expander"
>  	depends on MFD_LP3943
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 6309aff..5380608 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
>  obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
>  obj-$(CONFIG_GPIO_GRGPIO)	+= gpio-grgpio.o
>  obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
> +obj-$(CONFIG_GPIO_INTEL_SOC_PMIC)	+= gpio-crystalcove.o
>  obj-$(CONFIG_GPIO_IOP)		+= gpio-iop.o
>  obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
>  obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
> new file mode 100644
> index 0000000..974f9b8
> --- /dev/null
> +++ b/drivers/gpio/gpio-crystalcove.c
> @@ -0,0 +1,323 @@
> +/*
> + * gpio-crystalcove.c - Intel Crystal Cove GPIO Driver
> + *
> + * Copyright (C) 2012, 2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: Yang, Bin <bin.yang@intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/seq_file.h>
> +#include <linux/sched.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include <linux/gpio.h>
> +
> +#define NUM_GPIO		16
> +
> +#define UPDATE_TYPE		(1 << 0)
> +#define UPDATE_MASK		(1 << 1)
> +
> +#define GPIO0IRQ		0x0b
> +#define GPIO1IRQ		0x0c
> +#define MGPIO0IRQS0		0x19
> +#define MGPIO1IRQS0		0x1a
> +#define MGPIO0IRQSX		0x1b
> +#define MGPIO1IRQSX		0x1c
> +#define GPIO0P0CTLO		0x2b
> +#define GPIO0P0CTLI		0x33
> +#define GPIO1P0CTLO		0x3b
> +#define GPIO1P0CTLI		0x43
> +
> +#define CTLI_INTCNT_NE		(1 << 1)
> +#define CTLI_INTCNT_PE		(2 << 1)
> +#define CTLI_INTCNT_BE		(3 << 1)
> +
> +#define CTLO_DIR_OUT		(1 << 5)
> +#define CTLO_DRV_CMOS		(0 << 4)
> +#define CTLO_DRV_OD		(1 << 4)
> +#define CTLO_DRV_REN		(1 << 3)
> +#define CTLO_RVAL_2KDW		(0)
> +#define CTLO_RVAL_2KUP		(1 << 1)
> +#define CTLO_RVAL_50KDW		(2 << 1)
> +#define CTLO_RVAL_50KUP		(3 << 1)
> +
> +#define CTLO_INPUT_DEF	(CTLO_DRV_CMOS | CTLO_DRV_REN | CTLO_RVAL_2KUP)
> +#define CTLO_OUTPUT_DEF	(CTLO_DIR_OUT | CTLO_INPUT_DEF)
> +
> +struct crystalcove_gpio {
> +	struct mutex		buslock; /* irq_bus_lock */
> +	struct gpio_chip	chip;
> +	int			irq;
> +	int			irq_base;
> +	int			update;
> +	int			trigger_type;
> +	int			irq_mask;
> +};
> +static struct crystalcove_gpio gpio_info;

Um, why you allocate private driver data like this? Typically you would
do it in driver ->probe() using devm_kzalloc() or similar.

> +
> +static void __crystalcove_irq_mask(int gpio, int mask)
> +{
> +	u8 mirqs0 = gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0;
> +	int offset = gpio < 8 ? gpio : gpio - 8;
> +
> +	if (mask)
> +		intel_soc_pmic_setb(mirqs0, 1 << offset);
> +	else
> +		intel_soc_pmic_clearb(mirqs0, 1 << offset);
> +}
> +
> +static void __crystalcove_irq_type(int gpio, int type)
> +{
> +	u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);
> +
> +	type &= IRQ_TYPE_EDGE_BOTH;
> +	intel_soc_pmic_clearb(ctli, CTLI_INTCNT_BE);
> +
> +	if (type == IRQ_TYPE_EDGE_BOTH)
> +		intel_soc_pmic_setb(ctli, CTLI_INTCNT_BE);
> +	else if (type == IRQ_TYPE_EDGE_RISING)
> +		intel_soc_pmic_setb(ctli, CTLI_INTCNT_PE);
> +	else if (type & IRQ_TYPE_EDGE_FALLING)
> +		intel_soc_pmic_setb(ctli, CTLI_INTCNT_NE);
> +}
> +
> +static int crystalcove_gpio_direction_input(struct gpio_chip *chip,
> +					    unsigned gpio)
> +{
> +	u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);
> +
> +	intel_soc_pmic_writeb(ctlo, CTLO_INPUT_DEF);
> +	return 0;
> +}
> +
> +static int crystalcove_gpio_direction_output(struct gpio_chip *chip,
> +					     unsigned gpio, int value)
> +{
> +	u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);
> +
> +	intel_soc_pmic_writeb(ctlo, CTLO_OUTPUT_DEF | value);
> +	return 0;
> +}
> +
> +static int crystalcove_gpio_get(struct gpio_chip *chip, unsigned gpio)
> +{
> +	u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);
> +
> +	return intel_soc_pmic_readb(ctli) & 0x1;
> +}
> +
> +static void crystalcove_gpio_set(struct gpio_chip *chip,
> +				 unsigned gpio, int value)
> +{
> +	u8 ctlo = gpio < 8 ? GPIO0P0CTLO + gpio : GPIO1P0CTLO + (gpio - 8);
> +
> +	if (value)
> +		intel_soc_pmic_setb(ctlo, 1);
> +	else
> +		intel_soc_pmic_clearb(ctlo, 1);
> +}
> +
> +static int crystalcove_irq_type(struct irq_data *data, unsigned type)
> +{
> +	struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +	cg->trigger_type = type;
> +	cg->update |= UPDATE_TYPE;
> +
> +	return 0;
> +}
> +
> +static int crystalcove_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
> +{
> +	struct crystalcove_gpio *cg =
> +		container_of(chip, struct crystalcove_gpio, chip);
> +
> +	return cg->irq_base + gpio;
> +}
> +
> +static void crystalcove_bus_lock(struct irq_data *data)
> +{
> +	struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +	mutex_lock(&cg->buslock);
> +}
> +
> +static void crystalcove_bus_sync_unlock(struct irq_data *data)
> +{
> +	struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +	int gpio = data->irq - cg->irq_base;
> +
> +	if (cg->update & UPDATE_TYPE)
> +		__crystalcove_irq_type(gpio, cg->trigger_type);
> +	if (cg->update & UPDATE_MASK)
> +		__crystalcove_irq_mask(gpio, cg->irq_mask);
> +	cg->update = 0;
> +
> +	mutex_unlock(&cg->buslock);
> +}
> +
> +static void crystalcove_irq_unmask(struct irq_data *data)
> +{
> +	struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +	cg->irq_mask = 0;
> +	cg->update |= UPDATE_MASK;
> +}
> +
> +static void crystalcove_irq_mask(struct irq_data *data)
> +{
> +	struct crystalcove_gpio *cg = irq_data_get_irq_chip_data(data);
> +
> +	cg->irq_mask = 1;
> +	cg->update |= UPDATE_MASK;
> +}
> +
> +static struct irq_chip crystalcove_irqchip = {
> +	.name			= "PMIC-GPIO",
> +	.irq_mask		= crystalcove_irq_mask,
> +	.irq_unmask		= crystalcove_irq_unmask,
> +	.irq_set_type		= crystalcove_irq_type,
> +	.irq_bus_lock		= crystalcove_bus_lock,
> +	.irq_bus_sync_unlock	= crystalcove_bus_sync_unlock,
> +};
> +
> +static irqreturn_t crystalcove_gpio_irq_handler(int irq, void *data)
> +{
> +	struct crystalcove_gpio *cg = data;
> +	int pending;
> +	int gpio;
> +
> +	pending = intel_soc_pmic_readb(GPIO0IRQ) & 0xff;

If it is readb() do you still need to apply the 0xff mask here? I would
expect it to return u8.

> +	pending |= (intel_soc_pmic_readb(GPIO1IRQ) & 0xff) << 8;
> +	intel_soc_pmic_writeb(GPIO0IRQ, pending & 0xff);
> +	intel_soc_pmic_writeb(GPIO1IRQ, (pending >> 8) & 0xff);
> +
> +	local_irq_disable();
> +	for (gpio = 0; gpio < cg->chip.ngpio; gpio++)
> +		if (pending & (1 << gpio))
> +			generic_handle_irq(cg->irq_base + gpio);
> +	local_irq_enable();
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void crystalcove_gpio_dbg_show(struct seq_file *s,
> +				      struct gpio_chip *chip)
> +{
> +	struct crystalcove_gpio *cg =
> +		container_of(chip, struct crystalcove_gpio, chip);
> +	int gpio, offset;
> +	u8 ctlo, ctli, mirqs0, mirqsx, irq;
> +
> +	for (gpio = 0; gpio < cg->chip.ngpio; gpio++) {
> +		offset = gpio < 8 ? gpio : gpio - 8;
> +		ctlo = intel_soc_pmic_readb(
> +			(gpio < 8 ? GPIO0P0CTLO : GPIO1P0CTLO) + offset);
> +		ctli = intel_soc_pmic_readb(
> +			(gpio < 8 ? GPIO0P0CTLI : GPIO1P0CTLI) + offset);
> +		mirqs0 = intel_soc_pmic_readb(
> +			gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0);
> +		mirqsx = intel_soc_pmic_readb(
> +			gpio < 8 ? MGPIO0IRQSX : MGPIO1IRQSX);
> +		irq = intel_soc_pmic_readb(
> +			gpio < 8 ? GPIO0IRQ : GPIO1IRQ);
> +		seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=%2x,%s %s %s\n",
> +			   gpio, ctlo & CTLO_DIR_OUT ? "out" : "in ",
> +			   ctli & 0x1 ? "hi" : "lo",
> +			   ctli & CTLI_INTCNT_NE ? "fall" : "    ",
> +			   ctli & CTLI_INTCNT_PE ? "rise" : "    ",
> +			   ctlo,
> +			   mirqs0 & (1 << offset) ? "s0 mask  " : "s0 unmask",
> +			   mirqsx & (1 << offset) ? "sx mask  " : "sx unmask",
> +			   irq & (1 << offset) ? "pending" : "       ");
> +	}
> +}
> +
> +static int crystalcove_gpio_probe(struct platform_device *pdev)
> +{
> +	int irq = platform_get_irq(pdev, 0);
> +	struct crystalcove_gpio *cg = &gpio_info;
> +	int retval;
> +	int i;
> +	struct device *dev = intel_soc_pmic_dev();

What does this do? Is it the parent device? Then I suppose you should
use pdev->dev.parent or similar here.

For example in MSIC driver we have pdev_to_intel_msic(pdev) that
returned the parent MFD device to the MFD cell driver.

> +
> +	mutex_init(&cg->buslock);
> +	cg->chip.label = "intel_crystalcove";

Yet another name for the same thing.

> +	cg->chip.direction_input = crystalcove_gpio_direction_input;
> +	cg->chip.direction_output = crystalcove_gpio_direction_output;
> +	cg->chip.get = crystalcove_gpio_get;
> +	cg->chip.set = crystalcove_gpio_set;
> +	cg->chip.to_irq = crystalcove_gpio_to_irq;
> +	cg->chip.base = -1;
> +	cg->chip.ngpio = NUM_GPIO;
> +	cg->chip.can_sleep = 1;
> +	cg->chip.dev = dev;
> +	cg->chip.dbg_show = crystalcove_gpio_dbg_show;
> +
> +	retval = gpiochip_add(&cg->chip);
> +	if (retval) {
> +		dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> +		goto out;
> +	}
> +
> +	cg->irq_base = irq_alloc_descs(-1, 0, NUM_GPIO, 0);
> +	if (cg->irq_base < 0) {
> +		retval = cg->irq_base;
> +		cg->irq_base = 0;
> +		dev_warn(&pdev->dev, "irq_alloc_descs error: %d\n", retval);
> +		goto out_remove_gpio;
> +	}
> +
> +	for (i = 0; i < NUM_GPIO; i++) {
> +		irq_set_chip_data(i + cg->irq_base, cg);
> +		irq_set_chip_and_handler_name(i + cg->irq_base,
> +					      &crystalcove_irqchip,
> +					      handle_simple_irq, "demux");
> +	}
> +
> +	retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
> +				      IRQF_ONESHOT, "crystalcove_gpio", cg);
> +
> +	if (retval) {
> +		dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> +		goto out_free_desc;
> +	}
> +
> +	return 0;
> +
> +out_free_desc:
> +	irq_free_descs(cg->irq_base, NUM_GPIO);
> +out_remove_gpio:
> +	gpiochip_remove(&cg->chip);
> +out:
> +	return retval;
> +}
> +
> +static struct platform_driver crystalcove_gpio_driver = {
> +	.probe = crystalcove_gpio_probe,
> +	.driver = {
> +		.name = "crystal_cove_gpio",
> +	},
> +};

Is there anything preventing building this driver as a module?

> +
> +module_platform_driver(crystalcove_gpio_driver);
> +
> +MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
> +MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
> +MODULE_LICENSE("GPL");

This should be "GPL v2" since that's what the license on the top says.
