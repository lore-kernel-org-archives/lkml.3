Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaEUICL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:02:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:48931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaEUICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:02:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="515291520"
Date: Wed, 21 May 2014 11:01:28 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, mathias.nyman@linux.intel.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        bin.yang@intel.com
Subject: Re: [PATCH v2] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140521080128.GO1651@lahna.fi.intel.com>
References: <1400649756-31353-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400649756-31353-1-git-send-email-lejun.zhu@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 01:22:36PM +0800, Zhu, Lejun wrote:
> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
> 
> This patch adds support for the GPIO function in Crystal Cove.
> 
> v2:
> - Use IRQ chip helper to provide irqdomain.
> - Implement .remove and can now build as a module.
> - Various fix for unreadable or ugly code pieces.

Looks much better now. I still have few comments, though.

> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/gpio/Kconfig            |  13 ++
>  drivers/gpio/Makefile           |   1 +
>  drivers/gpio/gpio-crystalcove.c | 344 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 358 insertions(+)
>  create mode 100644 drivers/gpio/gpio-crystalcove.c
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index a86c49a..fed08d9d 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -440,6 +440,19 @@ config GPIO_ARIZONA
>  	help
>  	  Support for GPIOs on Wolfson Arizona class devices.
>  
> +config GPIO_CRYSTAL_COVE
> +	tristate "GPIO support for Crystal Cove PMIC"
> +	depends on INTEL_SOC_PMIC
> +	select GPIOLIB_IRQCHIP
> +	help
> +	  Support for GPIO pins on Crystal Cove PMIC.
> +
> +	  Say Yes if you have a Intel SoC based tablet with Crystal Cove PMIC
> +	  inside.
> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called gpio-crystalcove.
> +
>  config GPIO_LP3943
>  	tristate "TI/National Semiconductor LP3943 GPIO expander"
>  	depends on MFD_LP3943
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 6309aff..e6cd935 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_GPIO_BCM_KONA)	+= gpio-bcm-kona.o
>  obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
>  obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
>  obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
> +obj-$(CONFIG_GPIO_CRYSTAL_COVE)	+= gpio-crystalcove.o
>  obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
>  obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
>  obj-$(CONFIG_GPIO_DAVINCI)	+= gpio-davinci.o
> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
> new file mode 100644
> index 0000000..49d9c52
> --- /dev/null
> +++ b/drivers/gpio/gpio-crystalcove.c
> @@ -0,0 +1,344 @@
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
> +#include <linux/bitops.h>
> +
> +#define NUM_GPIO		16
> +
> +#define UPDATE_TYPE		BIT(0)
> +#define UPDATE_MASK		BIT(1)
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
> +
> +#define CTLO_DRV_CMOS		(0 << 4)
> +#define CTLO_DRV_OD		(1 << 4)
> +
> +#define CTLO_DRV_REN		(1 << 3)
> +
> +#define CTLO_RVAL_2KDW		(0)
> +#define CTLO_RVAL_2KUP		(1 << 1)
> +#define CTLO_RVAL_50KDW		(2 << 1)
> +#define CTLO_RVAL_50KUP		(3 << 1)
> +
> +#define CTLO_INPUT_DEF	(CTLO_DRV_CMOS | CTLO_DRV_REN | CTLO_RVAL_2KUP)
> +#define CTLO_OUTPUT_DEF	(CTLO_DIR_OUT | CTLO_INPUT_DEF)
> +
> +#define GPIO_TO_CTL(gpio, dir)		\
> +	((gpio < 8 ? GPIO0P0CTL ## dir : GPIO1P0CTL ## dir) + (gpio % 8))
> +
> +/**
> + * struct crystalcove_gpio - Crystal Cove GPIO controller
> + * @buslock: for bus lock/sync and unlock.
> + * @chip: the abstract gpio_chip structure.
> + * @update: pending IRQ setting update, to be written to the chip upon unlock.
> + * @trigger_type: the trigger type of the IRQ.
> + * @set_irq_mask: true if the IRQ mask needs to be set, false to clear.
> + */
> +struct crystalcove_gpio {
> +	struct mutex		buslock; /* irq_bus_lock */
> +	struct gpio_chip	chip;
> +	int			update;
> +	int			trigger_type;
> +	bool			set_irq_mask;
> +};
> +
> +static void crystalcove_update_irq_mask(int gpio, bool mask)
> +{
> +	u8 mirqs0 = gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0;
> +	int offset = gpio % 8;
> +
> +	if (mask)
> +		intel_soc_pmic_setb(mirqs0, BIT(offset));
> +	else
> +		intel_soc_pmic_clearb(mirqs0, BIT(offset));
> +}
> +
> +static void crystalcove_update_irq_type(int gpio, int type)
> +{
> +	u8 ctli = GPIO_TO_CTL(gpio, I);
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
> +	u8 ctlo = GPIO_TO_CTL(gpio, O);
> +
> +	intel_soc_pmic_writeb(ctlo, CTLO_INPUT_DEF);
> +	return 0;
> +}
> +
> +static int crystalcove_gpio_direction_output(struct gpio_chip *chip,
> +					     unsigned gpio, int value)
> +{
> +	u8 ctlo = GPIO_TO_CTL(gpio, O);
> +
> +	intel_soc_pmic_writeb(ctlo, CTLO_OUTPUT_DEF | value);
> +	return 0;
> +}
> +
> +static int crystalcove_gpio_get(struct gpio_chip *chip, unsigned gpio)
> +{
> +	u8 ctli = GPIO_TO_CTL(gpio, I);
> +
> +	return intel_soc_pmic_readb(ctli) & 0x1;
> +}
> +
> +static void crystalcove_gpio_set(struct gpio_chip *chip,
> +				 unsigned gpio, int value)
> +{
> +	u8 ctlo = GPIO_TO_CTL(gpio, O);
> +
> +	if (value)
> +		intel_soc_pmic_setb(ctlo, 1);
> +	else
> +		intel_soc_pmic_clearb(ctlo, 1);
> +}
> +
> +static int crystalcove_irq_type(struct irq_data *data, unsigned type)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
> +	struct crystalcove_gpio *cg =
> +		container_of(gc, struct crystalcove_gpio, chip);
> +
> +	cg->trigger_type = type;
> +	cg->update |= UPDATE_TYPE;
> +
> +	return 0;
> +}
> +
> +static void crystalcove_bus_lock(struct irq_data *data)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
> +	struct crystalcove_gpio *cg =
> +		container_of(gc, struct crystalcove_gpio, chip);
> +
> +	mutex_lock(&cg->buslock);
> +}
> +
> +static void crystalcove_bus_sync_unlock(struct irq_data *data)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
> +	struct crystalcove_gpio *cg =
> +		container_of(gc, struct crystalcove_gpio, chip);
> +	int gpio = data->hwirq;
> +
> +	if (cg->update & UPDATE_TYPE)
> +		crystalcove_update_irq_type(gpio, cg->trigger_type);
> +	if (cg->update & UPDATE_MASK)
> +		crystalcove_update_irq_mask(gpio, cg->set_irq_mask);
> +	cg->update = 0;
> +
> +	mutex_unlock(&cg->buslock);
> +}
> +
> +static void crystalcove_irq_unmask(struct irq_data *data)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
> +	struct crystalcove_gpio *cg =
> +		container_of(gc, struct crystalcove_gpio, chip);
> +
> +	cg->set_irq_mask = false;
> +	cg->update |= UPDATE_MASK;
> +}
> +
> +static void crystalcove_irq_mask(struct irq_data *data)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
> +	struct crystalcove_gpio *cg =
> +		container_of(gc, struct crystalcove_gpio, chip);
> +
> +	cg->set_irq_mask = true;
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
> +	unsigned int virq;
> +
> +	pending = intel_soc_pmic_readb(GPIO0IRQ);
> +	pending |= intel_soc_pmic_readb(GPIO1IRQ) << 8;
> +	intel_soc_pmic_writeb(GPIO0IRQ, pending & 0xff);
> +	intel_soc_pmic_writeb(GPIO1IRQ, (pending >> 8) & 0xff);
> +
> +	local_irq_disable();

Why the above? Doesn't IRQF_ONESHOT already make sure that the irq is
disabled at this point?

> +	for (gpio = 0; gpio < cg->chip.ngpio; gpio++) {
> +		if (pending & BIT(gpio)) {
> +			virq = irq_find_mapping(cg->chip.irqdomain, gpio);
> +			if (virq)
> +				generic_handle_irq(virq);
> +		}
> +	}
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
> +		ctlo = intel_soc_pmic_readb(GPIO_TO_CTL(gpio, O));
> +		ctli = intel_soc_pmic_readb(GPIO_TO_CTL(gpio, I));
> +		mirqs0 = intel_soc_pmic_readb(
> +			gpio < 8 ? MGPIO0IRQS0 : MGPIO1IRQS0);
> +		mirqsx = intel_soc_pmic_readb(
> +			gpio < 8 ? MGPIO0IRQSX : MGPIO1IRQSX);
> +		irq = intel_soc_pmic_readb(
> +			gpio < 8 ? GPIO0IRQ : GPIO1IRQ);
> +
> +		offset = gpio % 8;
> +		seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=%2x,%s %s %s\n",
> +			   gpio, ctlo & CTLO_DIR_OUT ? "out" : "in ",
> +			   ctli & 0x1 ? "hi" : "lo",
> +			   ctli & CTLI_INTCNT_NE ? "fall" : "    ",
> +			   ctli & CTLI_INTCNT_PE ? "rise" : "    ",
> +			   ctlo,
> +			   mirqs0 & BIT(offset) ? "s0 mask  " : "s0 unmask",
> +			   mirqsx & BIT(offset) ? "sx mask  " : "sx unmask",
> +			   irq & BIT(offset) ? "pending" : "       ");
> +	}
> +}
> +
> +static int crystalcove_gpio_probe(struct platform_device *pdev)
> +{
> +	int irq = platform_get_irq(pdev, 0);
> +	struct crystalcove_gpio *cg;
> +	int retval;
> +	struct device *dev = pdev->dev.parent;
> +
> +	cg = devm_kzalloc(&pdev->dev, sizeof(*cg), GFP_KERNEL);

What if devm_kzalloc() fails?

> +
> +	mutex_init(&cg->buslock);
> +	cg->chip.label = KBUILD_MODNAME;
> +	cg->chip.direction_input = crystalcove_gpio_direction_input;
> +	cg->chip.direction_output = crystalcove_gpio_direction_output;
> +	cg->chip.get = crystalcove_gpio_get;
> +	cg->chip.set = crystalcove_gpio_set;
> +	cg->chip.base = -1;
> +	cg->chip.ngpio = NUM_GPIO;
> +	cg->chip.can_sleep = true;
> +	cg->chip.dev = dev;
> +	cg->chip.dbg_show = crystalcove_gpio_dbg_show;
> +
> +	gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
> +			     handle_simple_irq, IRQ_TYPE_NONE);
> +
> +	retval = gpiochip_add(&cg->chip);
> +	if (retval) {
> +		dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> +		goto out;
> +	}
> +

I think you should reverse the order of gpiochip_add() and
request_irq(). Otherwise someone might try to use interrupt before you
have the handler ready.

> +	retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
> +				      IRQF_ONESHOT, KBUILD_MODNAME, cg);
> +
> +	if (retval) {
> +		dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> +		goto out_remove_gpio;
> +	}
> +
> +	platform_set_drvdata(pdev, cg);
> +
> +	return 0;
> +
> +out_remove_gpio:
> +	WARN_ON(gpiochip_remove(&cg->chip));
> +out:
> +	return retval;
> +}
> +
> +static int crystalcove_gpio_remove(struct platform_device *pdev)
> +{
> +	struct crystalcove_gpio *cg = platform_get_drvdata(pdev);
> +	int irq = platform_get_irq(pdev, 0);
> +	int err;
> +
> +	err = gpiochip_remove(&cg->chip);
> +
> +	if (irq >= 0)
> +		free_irq(irq, cg);
> +
> +	return err;
> +}
> +
> +static struct platform_driver crystalcove_gpio_driver = {
> +	.probe = crystalcove_gpio_probe,
> +	.remove = crystalcove_gpio_remove,
> +	.driver = {
> +		.name = "crystal_cove_gpio",

.owner = THIS_MODULE?

> +	},
> +};
> +
> +module_platform_driver(crystalcove_gpio_driver);
> +
> +MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
> +MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.8.3.2
