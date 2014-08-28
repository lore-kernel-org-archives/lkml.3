Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaH1QgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:36:22 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56283 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaH1QgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:36:19 -0400
Date: Thu, 28 Aug 2014 17:36:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        support.opensource@diasemi.com
Subject: Re: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Message-ID: <20140828163608.GY24579@lee--X1>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Adam Thomson wrote:

> DA9150 is a combined Charger and Fuel-Gauge IC, with additional
> GPIO and GPADC functionality.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> ---
>  drivers/mfd/Kconfig                  |   12 +
>  drivers/mfd/Makefile                 |    2 +
>  drivers/mfd/da9150-core.c            |  332 ++++++++++
>  drivers/mfd/da9150-i2c.c             |  176 ++++++

Do you also have another, say SPI version?

>  include/linux/mfd/da9150/core.h      |   80 +++
>  include/linux/mfd/da9150/pdata.h     |   21 +
>  include/linux/mfd/da9150/registers.h | 1153 ++++++++++++++++++++++++++++++++++
>  7 files changed, 1776 insertions(+)
>  create mode 100644 drivers/mfd/da9150-core.c
>  create mode 100644 drivers/mfd/da9150-i2c.c
>  create mode 100644 include/linux/mfd/da9150/core.h
>  create mode 100644 include/linux/mfd/da9150/pdata.h
>  create mode 100644 include/linux/mfd/da9150/registers.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..76adb2c 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -183,6 +183,18 @@ config MFD_DA9063
>  	  Additional drivers must be enabled in order to use the functionality
>  	  of the device.
> 
> +config MFD_DA9150
> +	bool "Dialog Semiconductor DA9150 Charger Fuel-Gauge chip"

Why can't this be built as a module?

> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	help
> +	  This adds support for the DA9150 integrated charger and fuel-gauge
> +	  chip. This driver provides common support for accessing the device.
> +	  Additional drivers must be enabled in order to use the specific
> +	  features of the device.
> +
>  config MFD_MC13XXX
>  	tristate
>  	depends on (SPI_MASTER || I2C)
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..098dfa1 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -114,6 +114,8 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
>  da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
>  obj-$(CONFIG_MFD_DA9063)	+= da9063.o
> 
> +obj-$(CONFIG_MFD_DA9150)	+= da9150-core.o da9150-i2c.o
> +

Do the other drivers smell?  Please butt up against them.

I'm not entirely sure why there are so many '\n's in the Makefile!

>  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
>  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
>  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
> diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
> new file mode 100644
> index 0000000..029a30b
> --- /dev/null
> +++ b/drivers/mfd/da9150-core.c
> @@ -0,0 +1,332 @@
> +/*
> + * DA9150 Core MFD Driver
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +

No real need for this '\n'.

> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +#include <linux/mfd/da9150/pdata.h>
> +
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg)
> +{
> +	int val, ret;
> +
> +	ret = regmap_read(da9150->regmap, reg, &val);
> +	if (ret < 0)

What if ret > 0?  Is that a good thing? :)

Just 'if (ret)'.

> +		dev_err(da9150->dev, "Failed to read from reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return (u8) val;
> +}
> +EXPORT_SYMBOL_GPL(da9150_reg_read);

Not sure I like this abstraction stuff.  I could understand if there
were locking involved, but there isn't.  You don't appear to check for
errors in the subordinate drivers either, rather you just plough on
ahead.  Not sure that's a good idea either.

Anyone have a second opinion?

> +int da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val)
> +{
> +	int ret;
> +
> +	ret = regmap_write(da9150->regmap, reg, val);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to write to reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9150_reg_write);

Blah.

> +int da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	ret = regmap_update_bits(da9150->regmap, reg, mask, val);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to set bits in reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9150_set_bits);

Blah.

> +int da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf)
> +{
> +	int ret;
> +
> +	ret = regmap_bulk_read(da9150->regmap, reg, buf, count);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to bulk read from reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9150_bulk_read);

Blah.

> +int da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8 *buf)
> +{
> +	int ret;
> +
> +	ret = regmap_raw_write(da9150->regmap, reg, buf, count);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to bulk write to reg 0x%x %d\n",
> +			reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9150_bulk_write);

Blah.

> +static struct regmap_irq da9150_irqs[] = {
> +	[DA9150_IRQ_VBUS] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_VBUS_MASK,
> +	},
> +	[DA9150_IRQ_CHG] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_CHG_MASK,
> +	},
> +	[DA9150_IRQ_TCLASS] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_TCLASS_MASK,
> +	},
> +	[DA9150_IRQ_TJUNC] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_TJUNC_MASK,
> +	},
> +	[DA9150_IRQ_VFAULT] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_VFAULT_MASK,
> +	},
> +	[DA9150_IRQ_CONF] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_CONF_MASK,
> +	},
> +	[DA9150_IRQ_DAT] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_DAT_MASK,
> +	},
> +	[DA9150_IRQ_DTYPE] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_DTYPE_MASK,
> +	},
> +	[DA9150_IRQ_ID] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_ID_MASK,
> +	},
> +	[DA9150_IRQ_ADP] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_ADP_MASK,
> +	},
> +	[DA9150_IRQ_SESS_END] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_SESS_END_MASK,
> +	},
> +	[DA9150_IRQ_SESS_VLD] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_SESS_VLD_MASK,
> +	},
> +	[DA9150_IRQ_FG] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_FG_MASK,
> +	},
> +	[DA9150_IRQ_GP] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GP_MASK,
> +	},
> +	[DA9150_IRQ_TBAT] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_TBAT_MASK,
> +	},
> +	[DA9150_IRQ_GPIOA] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOA_MASK,
> +	},
> +	[DA9150_IRQ_GPIOB] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOB_MASK,
> +	},
> +	[DA9150_IRQ_GPIOC] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOC_MASK,
> +	},
> +	[DA9150_IRQ_GPIOD] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOD_MASK,
> +	},
> +	[DA9150_IRQ_GPADC] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPADC_MASK,
> +	},
> +	[DA9150_IRQ_WKUP] = {
> +		.reg_offset = 3,
> +		.mask = DA9150_E_WKUP_MASK,
> +	},
> +};
> +
> +static struct regmap_irq_chip da9150_regmap_irq_chip = {
> +	.name = "da9150_irq",
> +	.status_base = DA9150_EVENT_E,
> +	.mask_base = DA9150_IRQ_MASK_E,
> +	.ack_base = DA9150_EVENT_E,
> +	.num_regs = DA9150_NUM_IRQ_REGS,
> +	.irqs = da9150_irqs,
> +	.num_irqs = ARRAY_SIZE(da9150_irqs),
> +};
> +
> +/* Helper functions for sub-devices to request/free IRQs */
> +int da9150_register_irq(struct platform_device *pdev, void *dev_id,
> +			irq_handler_t handler, const char *name)
> +{
> +	int irq, ret;
> +
> +	irq = platform_get_irq_byname(pdev, name);
> +	if (irq < 0)
> +		return irq;
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, handler,
> +					IRQF_ONESHOT, name, dev_id);
> +	if (ret)
> +		dev_err(&pdev->dev, "Failed to request IRQ %d: %d\n", irq, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9150_register_irq);

Why do they need help?  What problem does adding these layers solve?

> +void da9150_release_irq(struct platform_device *pdev, void *dev_id,
> +		       const char *name)
> +{
> +	int irq;
> +
> +	irq = platform_get_irq_byname(pdev, name);
> +	if (irq < 0)
> +		return;
> +
> +	devm_free_irq(&pdev->dev, irq, dev_id);
> +}
> +EXPORT_SYMBOL_GPL(da9150_release_irq);

Do you ever release the IRQ and not unbind the driver?

Are there ordering issues at play here?

If not, there's no need to conduct a manual free.

> +static struct resource da9150_gpadc_resources[] = {
> +	{
> +		.name = "GPADC",
> +		.start = DA9150_IRQ_GPADC,
> +		.end = DA9150_IRQ_GPADC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource da9150_charger_resources[] = {
> +	{
> +		.name = "CHG_STATUS",
> +		.start = DA9150_IRQ_CHG,
> +		.end = DA9150_IRQ_CHG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_TJUNC",
> +		.start = DA9150_IRQ_TJUNC,
> +		.end = DA9150_IRQ_TJUNC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_VFAULT",
> +		.start = DA9150_IRQ_VFAULT,
> +		.end = DA9150_IRQ_VFAULT,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_VBUS",
> +		.start = DA9150_IRQ_VBUS,
> +		.end = DA9150_IRQ_VBUS,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell da9150_devs[] = {
> +	{
> +		.name = "da9150-gpadc",
> +		.of_compatible = "dlg,da9150-gpadc",
> +		.resources = da9150_gpadc_resources,
> +		.num_resources = ARRAY_SIZE(da9150_gpadc_resources),
> +	},
> +	{
> +		.name = "da9150-charger",
> +		.of_compatible = "dlg,da9150-charger",
> +		.resources = da9150_charger_resources,
> +		.num_resources = ARRAY_SIZE(da9150_charger_resources),
> +	},
> +};
> +
> +int da9150_device_init(struct da9150 *da9150)
> +{
> +	struct da9150_pdata *pdata = da9150->dev->platform_data;

dev_get_platdata()

> +	int ret;
> +
> +	/* Handle platform data */

This comment doesn't add anything - the code is clear enough.

> +	if (pdata)
> +		da9150->irq_base = pdata->irq_base;
> +	else
> +		da9150->irq_base = -1;

pdata ? pdata->irq_base : -1;

> +	/* Init IRQs */

No need for these, please only add comments where the code is complex
or convoluted.

> +	ret = regmap_add_irq_chip(da9150->regmap, da9150->irq,
> +				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				  da9150->irq_base, &da9150_regmap_irq_chip,
> +				  &da9150->regmap_irq_data);
> +	if (ret < 0)

'if (ret)' where positive replies aren't possible or are errors.

> +		goto err_irq;

Just return here and remove 'err_irq' label.

> +	da9150->irq_base = regmap_irq_chip_get_base(da9150->regmap_irq_data);
> +
> +	/* Make the IRQ line a wake source */
> +	enable_irq_wake(da9150->irq);
> +
> +	/* Add MFD Devices */
> +	ret = mfd_add_devices(da9150->dev, -1, da9150_devs,
> +			      ARRAY_SIZE(da9150_devs), NULL,
> +			      da9150->irq_base, NULL);
> +	if (ret < 0) {
> +		dev_err(da9150->dev, "Failed to add child devices: %d\n", ret);
> +		goto err_mfd;
> +	}
> +
> +	return 0;
> +
> +err_mfd:
> +	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
> +err_irq:
> +	return ret;
> +}
> +
> +void da9150_device_exit(struct da9150 *da9150)
> +{
> +	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
> +	mfd_remove_devices(da9150->dev);
> +}
> +
> +void da9150_device_shutdown(struct da9150 *da9150)
> +{
> +	/* Make sure we have a wakup source for the device */
> +	da9150_set_bits(da9150, DA9150_CONFIG_D,
> +			DA9150_WKUP_PM_EN_MASK,
> +			DA9150_WKUP_PM_EN_MASK);
> +
> +	/* Set device to DISABLED mode */
> +	da9150_set_bits(da9150, DA9150_CONTROL_C,
> +			DA9150_DISABLE_MASK, DA9150_DISABLE_MASK);
> +}
> +
> +MODULE_DESCRIPTION("MFD Core Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/da9150-i2c.c b/drivers/mfd/da9150-i2c.c
> new file mode 100644
> index 0000000..a02525c
> --- /dev/null
> +++ b/drivers/mfd/da9150-i2c.c
> @@ -0,0 +1,176 @@
> +/*
> + * DA9150 I2C Driver
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +

Remove this line.

> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +
> +static bool da9150_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case DA9150_PAGE_CON:
> +	case DA9150_STATUS_A:
> +	case DA9150_STATUS_B:
> +	case DA9150_STATUS_C:
> +	case DA9150_STATUS_D:
> +	case DA9150_STATUS_E:
> +	case DA9150_STATUS_F:
> +	case DA9150_STATUS_G:
> +	case DA9150_STATUS_H:
> +	case DA9150_STATUS_I:
> +	case DA9150_STATUS_J:
> +	case DA9150_STATUS_K:
> +	case DA9150_STATUS_L:
> +	case DA9150_STATUS_N:
> +	case DA9150_FAULT_LOG_A:
> +	case DA9150_FAULT_LOG_B:
> +	case DA9150_EVENT_E:
> +	case DA9150_EVENT_F:
> +	case DA9150_EVENT_G:
> +	case DA9150_EVENT_H:
> +	case DA9150_CONTROL_B:
> +	case DA9150_CONTROL_C:
> +	case DA9150_GPADC_MAN:
> +	case DA9150_GPADC_RES_A:
> +	case DA9150_GPADC_RES_B:
> +	case DA9150_ADETVB_CFG_C:
> +	case DA9150_ADETD_STAT:
> +	case DA9150_ADET_CMPSTAT:
> +	case DA9150_ADET_CTRL_A:
> +	case DA9150_PPR_TCTR_B:
> +	case DA9150_COREBTLD_STAT_A:
> +	case DA9150_CORE_DATA_A:
> +	case DA9150_CORE_DATA_B:
> +	case DA9150_CORE_DATA_C:
> +	case DA9150_CORE_DATA_D:
> +	case DA9150_CORE2WIRE_STAT_A:
> +	case DA9150_FW_CTRL_C:
> +	case DA9150_FG_CTRL_B:
> +	case DA9150_FW_CTRL_B:
> +	case DA9150_GPADC_CMAN:
> +	case DA9150_GPADC_CRES_A:
> +	case DA9150_GPADC_CRES_B:
> +	case DA9150_CC_ICHG_RES_A:
> +	case DA9150_CC_ICHG_RES_B:
> +	case DA9150_CC_IAVG_RES_A:
> +	case DA9150_CC_IAVG_RES_B:
> +	case DA9150_TAUX_CTRL_A:
> +	case DA9150_TAUX_VALUE_H:
> +	case DA9150_TAUX_VALUE_L:
> +	case DA9150_TBAT_RES_A:
> +	case DA9150_TBAT_RES_B:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static const struct regmap_range_cfg da9150_range_cfg[] = {
> +	{
> +		.range_min = DA9150_PAGE_CON,
> +		.range_max = DA9150_TBAT_RES_B,
> +		.selector_reg = DA9150_PAGE_CON,
> +		.selector_mask = DA9150_I2C_PAGE_MASK,
> +		.selector_shift = DA9150_I2C_PAGE_SHIFT,
> +		.window_start = 0,
> +		.window_len = 256,
> +	},
> +};
> +
> +static struct regmap_config da9150_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.ranges = da9150_range_cfg,
> +	.num_ranges = ARRAY_SIZE(da9150_range_cfg),
> +	.max_register = DA9150_TBAT_RES_B,
> +
> +	.cache_type = REGCACHE_RBTREE,
> +
> +	.volatile_reg = da9150_volatile_reg,
> +};
> +
> +static int da9150_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct da9150 *da9150;
> +	int ret;
> +
> +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);

sizeof(*da9150)

> +	if (da9150 == NULL)

if (!da9150)

> +		return -ENOMEM;

'\n'

> +	da9150->dev = &client->dev;
> +	da9150->irq = client->irq;
> +	i2c_set_clientdata(client, da9150);
> +	dev_set_drvdata(da9150->dev, da9150);

Why do you need this in both locations?

> +	da9150->regmap = devm_regmap_init_i2c(client, &da9150_regmap_config);
> +	if (IS_ERR(da9150->regmap)) {
> +		ret = PTR_ERR(da9150->regmap);
> +		dev_err(da9150->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return da9150_device_init(da9150);
> +}
> +
> +static int da9150_remove(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_exit(da9150);
> +
> +	return 0;
> +}
> +
> +static void da9150_shutdown(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_shutdown(da9150);
> +}
> +
> +static const struct i2c_device_id da9150_i2c_id[] = {
> +	{ "da9150", 0 },

I don't see the .id parameter being used, just leave it blank.

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, da9150_i2c_id);
> +
> +static const struct of_device_id da9150_of_match[] = {
> +	{ .compatible = "dlg,da9150", },
> +	{ }
> +};

MODULE_DEVICE_TABLE(of, ...)

> +static struct i2c_driver da9150_driver = {
> +	.driver	= {
> +		.name	= "da9150",
> +		.owner	= THIS_MODULE,

You can remove this line, it's taken care of for you elsewhere.

> +		.of_match_table = of_match_ptr(da9150_of_match),
> +	},
> +	.probe		= da9150_probe,
> +	.remove		= da9150_remove,
> +	.shutdown	= da9150_shutdown,
> +	.id_table	= da9150_i2c_id,
> +};
> +
> +module_i2c_driver(da9150_driver);
> +
> +MODULE_DESCRIPTION("I2C Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/da9150/core.h b/include/linux/mfd/da9150/core.h
> new file mode 100644
> index 0000000..d23c500
> --- /dev/null
> +++ b/include/linux/mfd/da9150/core.h
> @@ -0,0 +1,80 @@
> +/*
> + * DA9150 MFD Driver - Core Data
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __DA9150_CORE_H
> +#define __DA9150_CORE_H
> +
> +#include <linux/device.h>
> +#include <linux/i2c.h>

What's this used for?

> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +#include <linux/mutex.h>
> +
> +/* I2C address paging */
> +#define DA9150_REG_PAGE_SHIFT	8
> +#define DA9150_REG_PAGE_MASK	0xFF
> +
> +/* IRQs */
> +#define DA9150_NUM_IRQ_REGS	4
> +#define DA9150_IRQ_VBUS		0
> +#define DA9150_IRQ_CHG		1
> +#define DA9150_IRQ_TCLASS	2
> +#define DA9150_IRQ_TJUNC	3
> +#define DA9150_IRQ_VFAULT	4
> +#define DA9150_IRQ_CONF		5
> +#define DA9150_IRQ_DAT		6
> +#define DA9150_IRQ_DTYPE	7
> +#define DA9150_IRQ_ID		8
> +#define DA9150_IRQ_ADP		9
> +#define DA9150_IRQ_SESS_END	10
> +#define DA9150_IRQ_SESS_VLD	11
> +#define DA9150_IRQ_FG		12
> +#define DA9150_IRQ_GP		13
> +#define DA9150_IRQ_TBAT		14
> +#define DA9150_IRQ_GPIOA	15
> +#define DA9150_IRQ_GPIOB	16
> +#define DA9150_IRQ_GPIOC	17
> +#define DA9150_IRQ_GPIOD	18
> +#define DA9150_IRQ_GPADC	19
> +#define DA9150_IRQ_WKUP		20
> +
> +struct da9150 {
> +	struct device *dev;
> +
> +	struct regmap *regmap;
> +

Why the '\n's?

> +	struct regmap_irq_chip_data *regmap_irq_data;
> +	int irq;
> +	int irq_base;
> +};
> +
> +/* Device I/O */
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg);
> +int da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val);
> +int da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val);
> +
> +int da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf);
> +int da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8 *buf);
> +
> +/* IRQ helper functions */
> +int da9150_register_irq(struct platform_device *pdev, void *dev_id,
> +			irq_handler_t handler, const char *name);
> +void da9150_release_irq(struct platform_device *pdev, void *dev_id,
> +			const char *name);

I'm not sure why any of these 7 functions are required.

> +/* Init/Exit */
> +int da9150_device_init(struct da9150 *da9150);
> +void da9150_device_exit(struct da9150 *da9150);
> +void da9150_device_shutdown(struct da9150 *da9150);
> +
> +#endif /* __DA9150_CORE_H */
> diff --git a/include/linux/mfd/da9150/pdata.h b/include/linux/mfd/da9150/pdata.h
> new file mode 100644
> index 0000000..e2b37f1
> --- /dev/null
> +++ b/include/linux/mfd/da9150/pdata.h
> @@ -0,0 +1,21 @@
> +/*
> + * DA9150 MFD Driver - Platform Data
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __DA9150_PDATA_H
> +#define __DA9150_PDATA_H
> +
> +struct da9150_pdata {
> +	int irq_base;
> +};

Just put this in core.h and do away witht this header file.

> +#endif /* __DA9150_PDATA_H */
> diff --git a/include/linux/mfd/da9150/registers.h b/include/linux/mfd/da9150/registers.h
> new file mode 100644
> index 0000000..ef4826d
> --- /dev/null
> +++ b/include/linux/mfd/da9150/registers.h
> @@ -0,0 +1,1153 @@
> +/*
> + * DA9150 MFD Driver - Registers
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __DA9150_REGISTERS_H
> +#define __DA9150_REGISTERS_H
> +
> +/* Registers */

[...]

> +/* DA9150_CONTROL_A = 0x0E5 */
> +#define DA9150_VDD33_SL_SHIFT			0
> +#define DA9150_VDD33_SL_MASK			(0x01 << 0)
> +#define DA9150_VDD33_LPM_SHIFT			1
> +#define DA9150_VDD33_LPM_MASK			(0x03 << 1)
> +#define DA9150_VDD33_EN_SHIFT			3
> +#define DA9150_VDD33_EN_MASK			(0x01 << 3)
> +#define DA9150_GPI_LPM_SHIFT			6
> +#define DA9150_GPI_LPM_MASK			(0x01 << 6)
> +#define DA9150_PM_IF_LPM_SHIFT			7
> +#define DA9150_PM_IF_LPM_MASK			(0x01 << 7)
> +
> +/* DA9150_CONTROL_B = 0x0E6 */
> +#define DA9150_LPM_SHIFT			0
> +#define DA9150_LPM_MASK				(0x01 << 0)
> +#define DA9150_RESET_SHIFT			1
> +#define DA9150_RESET_MASK			(0x01 << 1)
> +#define DA9150_RESET_USRCONF_EN_SHIFT		2
> +#define DA9150_RESET_USRCONF_EN_MASK		(0x01 << 2)
> +
> +/* DA9150_CONTROL_C = 0x0E7 */
> +#define DA9150_DISABLE_SHIFT			0
> +#define DA9150_DISABLE_MASK			(0x01 << 0)

Use BIT() for all of these (1 << X) macros.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
