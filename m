Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaFOTrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 15:47:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:39333 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaFOTrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 15:47:40 -0400
Message-ID: <539DF8C6.8030009@kernel.org>
Date: Sun, 15 Jun 2014 20:49:26 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 1/8] mfd: Add support for DA9150 combined charger & fuel-gauge
 device
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <bf472aa7fddd1e67a3d5b9024b5b621744146a27.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <bf472aa7fddd1e67a3d5b9024b5b621744146a27.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/14 12:11, Adam Thomson wrote:
> DA9150 is a combined Charger and Fuel-Gauge IC, with additional
> GPIO and GPADC functionality.
>
> This patch adds core support for the device.
>
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Hi Adam,

Some general comments inline.

It's been a while since I've looked at any particularly similar parts,
but it seems to me that a lot of indirection gets added here that
if anything makes the codes slightly harder to follow...

Feel free to disagree with me though!
> ---
>   drivers/mfd/Kconfig                  |   12 +
>   drivers/mfd/Makefile                 |    2 +
>   drivers/mfd/da9150-core.c            |  398 ++++++++++++
>   drivers/mfd/da9150-i2c.c             |  268 ++++++++
>   include/linux/mfd/da9150/core.h      |  125 ++++
>   include/linux/mfd/da9150/pdata.h     |  148 +++++
>   include/linux/mfd/da9150/registers.h | 1160 ++++++++++++++++++++++++++++++++++
>   7 files changed, 2113 insertions(+)
>   create mode 100644 drivers/mfd/da9150-core.c
>   create mode 100644 drivers/mfd/da9150-i2c.c
>   create mode 100644 include/linux/mfd/da9150/core.h
>   create mode 100644 include/linux/mfd/da9150/pdata.h
>   create mode 100644 include/linux/mfd/da9150/registers.h
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3383412..4af7cc4 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -171,6 +171,18 @@ config MFD_DA9063
>   	  Additional drivers must be enabled in order to use the functionality
>   	  of the device.
>
> +config MFD_DA9150
> +	bool "Dialog Semiconductor DA9150 Charger Fuel-Gauge chip"
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
>   config MFD_MC13XXX
>   	tristate
>   	depends on (SPI_MASTER || I2C)
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 2851275..0344494 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -112,6 +112,8 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
>   da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
>   obj-$(CONFIG_MFD_DA9063)	+= da9063.o
>
> +obj-$(CONFIG_MFD_DA9150)	+= da9150-core.o da9150-i2c.o
> +
>   obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
>   obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
>   obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
> diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
> new file mode 100644
> index 0000000..24c62ba
> --- /dev/null
> +++ b/drivers/mfd/da9150-core.c
> @@ -0,0 +1,398 @@
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
> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +#include <linux/mfd/da9150/pdata.h>
> +
> +
Single line comment syntax.
> +/*
> + * Register/Device Access
> + */
> +
To my mind all these wrappers add nothing significant so you might as well
just call da9150->read_dev etc directly.

Also, what are the read_qif and write_qif for?  They don't seem to be used
anywhere.
> +int da9150_read_qif(struct da9150 *da9150, u8 addr, int count, u8 *buf)
> +{
> +	int ret;
> +
> +	ret = da9150->read_dev(da9150->core_qif, addr, count, buf);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to read from QIF 0x%x: %d\n",
> +			addr, ret);
> +
> +	return ret;
> +}
> +
> +int da9150_write_qif(struct da9150 *da9150, u8 addr, int count, const u8 *buf)
> +{
> +	int ret;
> +
> +	ret = da9150->write_dev(da9150->core_qif, addr, count, buf);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to write to QIF 0x%x: %d\n",
> +			addr, ret);
> +
> +	return ret;
> +}
> +
The only real reason I can see for these wrappers is because you want
to hide the struct da9150 contents from the children of the mfd. As you
aren't doing that, you might as well drop these in favour of direct
calls to regmap_read and friends.
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg)
> +{
> +	int val, ret;
> +
> +	ret = regmap_read(da9150->regmap, reg, &val);
> +	if (ret < 0)
> +		dev_err(da9150->dev, "Failed to read from reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return (u8) val;
> +}
> +
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
> +
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
> +
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
> +
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
> +
> +
> +/*
> + * IRQ Handling
> + */
> +
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
> +/* Helper function for sub-devices to request IRQs */
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
> +
> +
> +/*
> + * MFDs
Multi function devices?  Elements of perhaps.
> + */
> +
> +static struct resource da9150_gpio_resources[] = {
> +	{
> +		.name = "GPIOA",
> +		.start = DA9150_IRQ_GPIOA,
> +		.end = DA9150_IRQ_GPIOA,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
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
> +static struct resource da9150_fg_resources[] = {
> +	{
> +		.name = "FG",
> +		.start = DA9150_IRQ_FG,
> +		.end = DA9150_IRQ_FG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell da9150_devs[] = {
> +	{
> +		.name = "da9150-gpio",
> +		.of_compatible = "dlg,da9150-gpio",
> +		.resources = da9150_gpio_resources,
> +		.num_resources = ARRAY_SIZE(da9150_gpio_resources),
> +	},
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
> +	{
> +		.name = "da9150-fuelgauge",
> +		.of_compatible = "dlg,da9150-fg",
> +		.resources = da9150_fg_resources,
> +		.num_resources = ARRAY_SIZE(da9150_fg_resources),
> +	},
> +};
> +
> +
> +/*
> + * Device Init/Exit
> + */
I'll continue my tirade against obvious comments. Wrong format and
adds nothing to what is here as init and exit functions are clearly
doing what there name suggests (it's one of my pet hates ;)
> +
> +int da9150_device_init(struct da9150 *da9150)
> +{
> +	struct da9150_pdata *pdata = da9150->dev->platform_data;
> +	int ret;
> +
> +	/* Handle platform data */
> +	if (pdata) {
> +		da9150->irq_base = pdata->irq_base;
> +
As a general good practice point, I'd rather that the driver supported
more than one instance of the chip.. Hence you'd take a copy of da9150_devs
to use here.  I guess it is relatively unlikely with one of these, but
you never know ;)
> +		da9150_devs[0].platform_data = pdata->gpio_pdata;
> +		da9150_devs[0].pdata_size = sizeof(struct da9150_gpio_pdata);
> +		da9150_devs[2].platform_data = pdata->charger_pdata;
> +		da9150_devs[2].pdata_size = sizeof(struct da9150_charger_pdata);
> +		da9150_devs[3].platform_data = pdata->fg_pdata;
> +		da9150_devs[3].pdata_size = sizeof(struct da9150_fg_pdata);
> +	} else {
> +		da9150->irq_base = -1;
> +	}
> +
> +	/* Init IRQs */
> +	ret = regmap_add_irq_chip(da9150->regmap, da9150->irq,
> +				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				  da9150->irq_base, &da9150_regmap_irq_chip,
> +				  &da9150->regmap_irq_data);
> +	if (ret < 0)
> +		goto err_irq;
> +
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
> +	return;
> +}
> +
> +void da9150_device_shutdown(struct da9150 *da9150)
> +{
> +	if (da9150->can_shutdown) {
> +		/* Make sure we have a wakup source for the device */
> +		da9150_set_bits(da9150, DA9150_CONFIG_D,
> +				DA9150_WKUP_PM_EN_MASK,
> +				DA9150_WKUP_PM_EN_MASK);
> +
> +		/* Set device to DISABLED mode */
> +		da9150_set_bits(da9150, DA9150_CONTROL_C,
> +				DA9150_DISABLE_MASK, DA9150_DISABLE_MASK);
> +	}
> +}
> +
> +MODULE_DESCRIPTION("MFD Core Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/da9150-i2c.c b/drivers/mfd/da9150-i2c.c
> new file mode 100644
> index 0000000..725aaef
> --- /dev/null
> +++ b/drivers/mfd/da9150-i2c.c
> @@ -0,0 +1,268 @@
> +/*
> + * DA9150 I2C Driver
Why does this need it's own file?  Does the DA9150 support any other
interfaces?
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
> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +
> +
> +/*
> + * Regmap Config
> + */
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
> +
> +/*
> + * Device access for QIF interface
> + */
> +
> +static int da9150_i2c_read_device(struct i2c_client *client, u8 addr, int count,
> +				  u8 *buf)
> +{
> +	struct i2c_msg xfer;
> +	int ret;
> +
> +	/*
> +	 * Read is split into two transfers as device expects STOP/START rather
> +	 * than repeated start to carry out this kind of access.
> +	 */
> +
> +	/* Write address */
> +	xfer.addr = client->addr;
> +	xfer.flags = 0;
> +	xfer.len = 1;
> +	xfer.buf = &addr;
> +
> +	ret = i2c_transfer(client->adapter, &xfer, 1);
> +	if (ret != 1) {
> +		if (ret < 0)
> +			return ret;
> +		else
> +			return -EIO;
> +	}
	Not equivalent of i2c_smbus_write_byte?
> +
> +	/* Read data */
> +	xfer.addr = client->addr;
> +	xfer.flags = I2C_M_RD;
> +	xfer.len = count;
> +	xfer.buf = buf;
> +
> +	ret = i2c_transfer(client->adapter, &xfer, 1);
> +	if (ret == 1)
> +		return 0;
There is indeed nothing equivalent to this one...
> +	else if (ret < 0)
> +		return ret;
> +	else
> +		return -EIO;
> +}
> +
> +static int da9150_i2c_write_device(struct i2c_client *client, u8 addr, int count,
> +				   const u8 *buf)
> +{
> +	struct i2c_msg xfer;
> +	u8 *reg_data;
> +	int ret;
> +
> +	reg_data = kzalloc(1 + count, GFP_KERNEL);
> +	if (!reg_data)
> +		return -ENOMEM;
> +
This at least superficialy looks like i2c_smbus_i2c_write_block_data.
> +	reg_data[0] = addr;
> +	memcpy(&reg_data[1], buf, count);
> +
> +	/* Write address & data */
> +	xfer.addr = client->addr;
> +	xfer.flags = 0;
> +	xfer.len = 1 + count;
> +	xfer.buf = reg_data;
> +
> +	ret = i2c_transfer(client->adapter, &xfer, 1);
> +	kfree(reg_data);
> +	if (ret == 1)
> +		return 0;
> +	else if (ret < 0)
> +		return ret;
> +	else
> +		return -EIO;
> +}
> +
> +
> +/*
> + * Driver top level functions
> + */
> +
> +static int da9150_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct da9150 *da9150;
> +	int ret;
> +
> +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);
> +	if (da9150 == NULL)
> +		return -ENOMEM;
> +	da9150->dev = &client->dev;
> +	da9150->irq = client->irq;
> +	i2c_set_clientdata(client, da9150);
> +	dev_set_drvdata(da9150->dev, da9150);
> +
> +	da9150->core_qif = i2c_new_dummy(client->adapter, DA9150_QIF_I2C_ADDR);
> +	i2c_set_clientdata(da9150->core_qif, da9150);
> +
> +	da9150->regmap = devm_regmap_init_i2c(client, &da9150_regmap_config);
> +	if (IS_ERR(da9150->regmap)) {
> +		ret = PTR_ERR(da9150->regmap);
> +		dev_err(da9150->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	da9150->read_dev = (read_dev_t) da9150_i2c_read_device;
> +	da9150->write_dev = (write_dev_t) da9150_i2c_write_device;
Why the indirection?  The da9150 only supports i2c as far as I can see.

> +
> +	return da9150_device_init(da9150);
> +}
> +
> +static int da9150_remove(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_exit(da9150);
> +	i2c_unregister_device(da9150->core_qif);
> +
> +	return 0;
> +}
> +
> +static void da9150_shutdown(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_shutdown(da9150);
I'd roll this into one line and not bother with the local variable...

> +}
> +
> +static const struct i2c_device_id da9150_i2c_id[] = {
> +	{ "da9150", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, da9150_i2c_id);
> +
> +static const struct of_device_id da9150_of_match[] = {
> +	{ .compatible = "dlg,da9150", },
> +	{ }
> +};
> +
> +static struct i2c_driver da9150_driver = {
> +	.driver	= {
> +		.name	= "da9150",
> +		.owner	= THIS_MODULE,
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
> index 0000000..39997406
> --- /dev/null
> +++ b/include/linux/mfd/da9150/core.h
> @@ -0,0 +1,125 @@
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
> +#ifndef _DA9150_CORE_H
> +#define _DA9150_CORE_H
> +
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +#include <linux/mutex.h>
> +
> +/*
> + * Defines
> + */
> +
> +/* I2C sub-device addresses */
> +#define DA9150_QIF_I2C_ADDR	0x6D
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
> +/* Helper macros to convert real world values to register values */
> +#define DA9150_CHG_IBAT_FACTOR		25000
> +#define DA9150_CHG_IEND_FACTOR		4800
> +#define DA9150_CHG_IBAT_UA_TO_REG(val)	(val / DA9150_CHG_IBAT_FACTOR)
> +#define DA9150_CHG_IEND_UA_TO_REG(val)	(val / DA9150_CHG_IEND_FACTOR)
> +#define DA9150_CHG_IBAT_REG_TO_UA(val)	(val * DA9150_CHG_IBAT_FACTOR)
> +#define DA9150_CHG_IEND_REG_TO_UA(val)	(val * DA9150_CHG_IEND_FACTOR)
> +
> +
> +/*
> + * I/O Function Typedefs
> + */
> +
> +typedef int (*read_dev_t)(void *client, u8 addr, int count, u8 *buf);
> +typedef int (*write_dev_t)(void *client, u8 addr, int count, const u8 *buf);
> +
> +/*
> + * Main structure
> + */
> +
> +struct da9150 {
> +	struct device *dev;
> +
> +	struct regmap *regmap;
> +	struct i2c_client *core_qif;
> +
> +	read_dev_t read_dev;
> +	write_dev_t write_dev;
> +
> +	struct regmap_irq_chip_data *regmap_irq_data;
> +	int irq;
> +	int irq_base;
> +
> +	bool can_shutdown;
> +	bool gpadc_ready;
> +};
> +
> +/*
> + * APIs
> + */
> +
> +/* Device I/O */
> +int da9150_read_core(struct da9150 *da9150, u8 addr, int count, u8 *buf);
> +int da9150_write_core(struct da9150 *da9150, u8 addr, int count, const u8 *buf);
> +
> +int da9150_read_qif(struct da9150 *da9150, u8 addr, int count, u8 *buf);
> +int da9150_write_qif(struct da9150 *da9150, u8 addr, int count, const u8 *buf);
> +
> +int da9150_read_fwdl(struct da9150 *da9150, u8 addr, int count, u8 *buf);
> +int da9150_write_fwdl(struct da9150 *da9150, u8 addr, int count, const u8 *buf);
> +
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg);
> +int da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val);
> +int da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val);
> +
> +int da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf);
> +int da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8 *buf);
> +
> +/* IRQ */
> +int da9150_register_irq(struct platform_device *pdev, void *dev_id,
> +			irq_handler_t handler, const char *name);
> +
> +/* Init/Exit */
> +int da9150_device_init(struct da9150 *da9150);
> +void da9150_device_exit(struct da9150 *da9150);
> +void da9150_device_shutdown(struct da9150 *da9150);
> +
> +#endif /* _DA9150_CORE_H */
> diff --git a/include/linux/mfd/da9150/pdata.h b/include/linux/mfd/da9150/pdata.h
> new file mode 100644
> index 0000000..c1dd2b3
> --- /dev/null
> +++ b/include/linux/mfd/da9150/pdata.h
> @@ -0,0 +1,148 @@
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
> +#ifndef _DA9150_PDATA_H
> +#define _DA9150_PDATA_H
> +
> +/*
> + * GPIO
> + */
> +
> +#define DA9150_NUM_GPIOS	4
> +
> +/* Values are as bit fields for registers */
> +enum da9150_gpi_trigger {
> +	DA9150_GPI_ACTIVE_LOW = 0,
> +	DA9150_GPI_ACTIVE_HIGH,
> +};
> +
> +enum da9150_gpi_mode {
> +	DA9150_GPI_DIG = 0,
> +	DA9150_GPI_ANA = 3,
> +};
> +
> +enum da9150_gpo_mode {
> +	DA9150_GPO_OD = 1,
> +	DA9150_GPO_PP,
> +};
> +
> +enum da9150_gpo_supply {
> +	DA9150_GPO_SUPPLY_VDDIO1 = 0,
> +	DA9150_GPO_SUPPLY_VDDIO2,
> +};
> +
> +enum da9150_gpio_pupd {
> +	DA9150_GPIO_PUPD_DISABLED = 0,
> +	DA9150_GPIO_PUPD_ENABLED,
> +};
> +
> +struct da9150_gpio_cfg {
> +	enum da9150_gpi_trigger gpi_trigger;
> +	enum da9150_gpi_mode gpi_mode;
> +	enum da9150_gpo_mode gpo_mode;
> +	enum da9150_gpo_supply gpo_supply;
> +	enum da9150_gpio_pupd gpio_pupd;
> +};
> +
> +enum da9150_gpi_debounce_time {
> +	DA9150_GPI_DEBOUNCE_TIME_OFF = 0,
> +	DA9150_GPI_DEBOUNCE_TIME_100US,
> +	DA9150_GPI_DEBOUNCE_TIME_1MS,
> +	DA9150_GPI_DEBOUNCE_TIME_10MS24,
> +	DA9150_GPI_DEBOUNCE_TIME_51MS20,
> +	DA9150_GPI_DEBOUNCE_TIME_256MS,
> +	DA9150_GPI_DEBOUNCE_TIME_512MS,
> +	DA9150_GPI_DEBOUNCE_TIME_1024MS,
> +};
> +
> +/* Charging LED Data */
> +enum da9150_led_freq {
> +	DA9150_LED_FREQ_ALWAYS_ON = 0,
> +	DA9150_LED_FREQ_1_S,
> +	DA9150_LED_FREQ_2_S,
> +	DA9150_LED_FREQ_4_S,
> +};
> +
> +enum da9150_led_ontime {
> +	DA9150_LED_ONTIME_10_MS = 0,
> +	DA9150_LED_ONTIME_20_MS,
> +	DA9150_LED_ONTIME_40_MS,
> +	DA9150_LED_ONTIME_HALF_FREQ,
> +};
> +
> +enum da9150_pin {
> +	DA9150_PIN_OFF = 0,
> +	DA9150_PIN_GPIOA = 1,
> +	DA9150_PIN_GPIOB = 2,
> +	DA9150_PIN_GPIOC = 3,
> +	DA9150_PIN_GPIOD = 4,
> +};
> +
> +
> +/* Fault Pin Data */
> +enum da9150_fault_type {
> +	DA9150_FAULT_TYPE_VFAULT = 0,
> +	DA9150_FAULT_TYPE_RESET,
> +};
> +
> +
> +/* GPIO data */
> +struct da9150_gpio_pdata {
> +	int base;
> +
> +	/* General GPIO config */
> +	struct da9150_gpio_cfg gpio_cfg[DA9150_NUM_GPIOS];
> +	enum da9150_gpi_debounce_time gpi_debounce_time;
> +
> +	/* Charge LED features */
> +	enum da9150_led_freq led_frequency;
> +	bool led_dbl_flash;
> +	enum da9150_led_ontime led_ontime;
> +	enum da9150_pin led_pin;
> +
> +	/* Fault Pin features */
> +	enum da9150_pin fault_pin;
> +	enum da9150_fault_type fault_type;
> +};
> +
> +/*
> + * Fuel-Gauge
> + */
> +
> +struct da9150_fg_pdata {
> +	u32 update_interval;	/* msecs */
> +	u8 warn_soc_lvl;	/* % value */
> +	u8 crit_soc_lvl;	/* % value */
> +};
> +
> +/*
> + * Charger
> + */
> +
> +struct da9150_charger_pdata {
> +	bool invalid_tbat;
> +};
> +
> +
> +/*
> + * Main struct
> + */
Drop comments on things that are self evident.  Also these are one
line comments so should be using the single line comment syntax.
> +
> +struct da9150_pdata {
> +	int irq_base;
> +	struct da9150_gpio_pdata *gpio_pdata;
> +	struct da9150_fg_pdata *fg_pdata;
> +	struct da9150_charger_pdata *charger_pdata;
> +};
> +
> +#endif /* _DA9150_PDATA_H */
> diff --git a/include/linux/mfd/da9150/registers.h b/include/linux/mfd/da9150/registers.h
> new file mode 100644
> index 0000000..a6a8e28
> --- /dev/null
> +++ b/include/linux/mfd/da9150/registers.h
> @@ -0,0 +1,1160 @@
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
> +#ifndef _DA9150_REGISTERS_H
> +#define _DA9150_REGISTERS_H
> +
> +/*
> + * Registers
> + */
> +
> +#define DA9150_PAGE_CON			0x000
> +#define DA9150_STATUS_A			0x068
> +#define DA9150_STATUS_B			0x069
> +#define DA9150_STATUS_C			0x06A
> +#define DA9150_STATUS_D			0x06B
> +#define DA9150_STATUS_E			0x06C
> +#define DA9150_STATUS_F			0x06D
> +#define DA9150_STATUS_G			0x06E
> +#define DA9150_STATUS_H			0x06F
> +#define DA9150_STATUS_I			0x070
> +#define DA9150_STATUS_J			0x071
> +#define DA9150_STATUS_K			0x072
> +#define DA9150_STATUS_L			0x073
> +#define DA9150_STATUS_N			0x074
> +#define DA9150_FAULT_LOG_A		0x076
> +#define DA9150_FAULT_LOG_B		0x077
> +#define DA9150_EVENT_E			0x078
> +#define DA9150_EVENT_F			0x079
> +#define DA9150_EVENT_G			0x07A
> +#define DA9150_EVENT_H			0x07B
> +#define DA9150_IRQ_MASK_E		0x07C
> +#define DA9150_IRQ_MASK_F		0x07D
> +#define DA9150_IRQ_MASK_G		0x07E
> +#define DA9150_IRQ_MASK_H		0x07F
> +#define DA9150_PAGE_CON_1		0x080
> +#define DA9150_CONFIG_A			0x0E0
> +#define DA9150_CONFIG_B			0x0E1
> +#define DA9150_CONFIG_C			0x0E2
> +#define DA9150_CONFIG_D			0x0E3
> +#define DA9150_CONFIG_E			0x0E4
> +#define DA9150_CONTROL_A		0x0E5
> +#define DA9150_CONTROL_B		0x0E6
> +#define DA9150_CONTROL_C		0x0E7
> +#define DA9150_GPIO_A_B			0x0E8
> +#define DA9150_GPIO_C_D			0x0E9
> +#define DA9150_GPIO_MODE_CONT		0x0EA
> +#define DA9150_GPIO_CTRL_B		0x0EB
> +#define DA9150_GPIO_CTRL_A		0x0EC
> +#define DA9150_GPIO_CTRL_C		0x0ED
> +#define DA9150_GPIO_CFG_A		0x0EE
> +#define DA9150_GPIO_CFG_B		0x0EF
> +#define DA9150_GPIO_CFG_C		0x0F0
> +#define DA9150_GPADC_MAN		0x0F2
> +#define DA9150_GPADC_RES_A		0x0F4
> +#define DA9150_GPADC_RES_B		0x0F5
> +#define DA9150_PAGE_CON_2		0x100
> +#define DA9150_OTP_CONT_SHARED		0x101
> +#define DA9150_INTERFACE_SHARED		0x105
> +#define DA9150_CONFIG_A_SHARED		0x106
> +#define DA9150_CONFIG_D_SHARED		0x109
> +#define DA9150_ADETVB_CFG_C		0x150
> +#define DA9150_ADETD_STAT		0x151
> +#define DA9150_ADET_CMPSTAT		0x152
> +#define DA9150_ADET_CTRL_A		0x153
> +#define DA9150_ADETVB_CFG_B		0x154
> +#define DA9150_ADETVB_CFG_A		0x155
> +#define DA9150_ADETAC_CFG_A		0x156
> +#define DA9150_ADDETAC_CFG_B		0x157
> +#define DA9150_ADETAC_CFG_C		0x158
> +#define DA9150_ADETAC_CFG_D		0x159
> +#define DA9150_ADETVB_CFG_D		0x15A
> +#define DA9150_ADETID_CFG_A		0x15B
> +#define DA9150_ADET_RID_PT_CHG_H	0x15C
> +#define DA9150_ADET_RID_PT_CHG_L	0x15D
> +#define DA9150_PPR_TCTR_B		0x160
> +#define DA9150_PPR_BKCTRL_A		0x163
> +#define DA9150_PPR_BKCFG_A		0x164
> +#define DA9150_PPR_BKCFG_B		0x165
> +#define DA9150_PPR_CHGCTRL_A		0x166
> +#define DA9150_PPR_CHGCTRL_B		0x167
> +#define DA9150_PPR_CHGCTRL_C		0x168
> +#define DA9150_PPR_TCTR_A		0x169
> +#define DA9150_PPR_CHGCTRL_D		0x16A
> +#define DA9150_PPR_CHGCTRL_E		0x16B
> +#define DA9150_PPR_CHGCTRL_F		0x16C
> +#define DA9150_PPR_CHGCTRL_G		0x16D
> +#define DA9150_PPR_CHGCTRL_H		0x16E
> +#define DA9150_PPR_CHGCTRL_I		0x16F
> +#define DA9150_PPR_CHGCTRL_J		0x170
> +#define DA9150_PPR_CHGCTRL_K		0x171
> +#define DA9150_PPR_CHGCTRL_L		0x172
> +#define DA9150_PPR_CHGCTRL_M		0x173
> +#define DA9150_PPR_THYST_A		0x174
> +#define DA9150_PPR_THYST_B		0x175
> +#define DA9150_PPR_THYST_C		0x176
> +#define DA9150_PPR_THYST_D		0x177
> +#define DA9150_PPR_THYST_E		0x178
> +#define DA9150_PPR_THYST_F		0x179
> +#define DA9150_PPR_THYST_G		0x17A
> +#define DA9150_PAGE_CON_3		0x180
> +#define DA9150_PAGE_CON_4		0x200
> +#define DA9150_PAGE_CON_5		0x280
> +#define DA9150_PAGE_CON_6		0x300
> +#define DA9150_COREBTLD_STAT_A		0x302
> +#define DA9150_COREBTLD_CTRL_A		0x303
> +#define DA9150_CORE_CONFIG_A		0x304
> +#define DA9150_CORE_CONFIG_C		0x305
> +#define DA9150_CORE_CONFIG_B		0x306
> +#define DA9150_CORE_CFG_DATA_A		0x307
> +#define DA9150_CORE_CFG_DATA_B		0x308
> +#define DA9150_CORE_CMD_A		0x309
> +#define DA9150_CORE_DATA_A		0x30A
> +#define DA9150_CORE_DATA_B		0x30B
> +#define DA9150_CORE_DATA_C		0x30C
> +#define DA9150_CORE_DATA_D		0x30D
> +#define DA9150_CORE2WIRE_STAT_A		0x310
> +#define DA9150_CORE2WIRE_CTRL_A		0x311
> +#define DA9150_FW_CTRL_A		0x312
> +#define DA9150_FW_CTRL_C		0x313
> +#define DA9150_FW_CTRL_D		0x314
> +#define DA9150_FG_CTRL_A		0x315
> +#define DA9150_FG_CTRL_B		0x316
> +#define DA9150_FW_CTRL_E		0x317
> +#define DA9150_FW_CTRL_B		0x318
> +#define DA9150_GPADC_CMAN		0x320
> +#define DA9150_GPADC_CRES_A		0x322
> +#define DA9150_GPADC_CRES_B		0x323
> +#define DA9150_CC_CFG_A			0x328
> +#define DA9150_CC_CFG_B			0x329
> +#define DA9150_CC_ICHG_RES_A		0x32A
> +#define DA9150_CC_ICHG_RES_B		0x32B
> +#define DA9150_CC_IAVG_RES_A		0x32C
> +#define DA9150_CC_IAVG_RES_B		0x32D
> +#define DA9150_TAUX_CTRL_A		0x330
> +#define DA9150_TAUX_RELOAD_H		0x332
> +#define DA9150_TAUX_RELOAD_L		0x333
> +#define DA9150_TAUX_VALUE_H		0x334
> +#define DA9150_TAUX_VALUE_L		0x335
> +#define DA9150_AUX_DATA_0		0x338
> +#define DA9150_AUX_DATA_1		0x339
> +#define DA9150_AUX_DATA_2		0x33A
> +#define DA9150_AUX_DATA_3		0x33B
> +#define DA9150_BIF_CTRL			0x340
> +#define DA9150_TBAT_CTRL_A		0x342
> +#define DA9150_TBAT_CTRL_B		0x343
> +#define DA9150_TBAT_RES_A		0x344
> +#define DA9150_TBAT_RES_B		0x345
> +
> +
> +/*
> + * Bit fields
> + */
> +
> +/* DA9150_PAGE_CON = 0x000 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_I2C_PAGE_SHIFT			1
> +#define DA9150_I2C_PAGE_MASK			(0x1f << 1)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_STATUS_A = 0x068 */
> +#define DA9150_WKUP_STAT_SHIFT			2
> +#define DA9150_WKUP_STAT_MASK			(0x0f << 2)
> +#define DA9150_SLEEP_STAT_SHIFT			6
> +#define DA9150_SLEEP_STAT_MASK			(0x03 << 6)
> +
> +/* DA9150_STATUS_B = 0x069 */
> +#define DA9150_VFAULT_STAT_SHIFT		0
> +#define DA9150_VFAULT_STAT_MASK			(0x01 << 0)
> +#define DA9150_TFAULT_STAT_SHIFT		1
> +#define DA9150_TFAULT_STAT_MASK			(0x01 << 1)
> +
> +/* DA9150_STATUS_C = 0x06A */
> +#define DA9150_VDD33_STAT_SHIFT			0
> +#define DA9150_VDD33_STAT_MASK			(0x01 << 0)
> +#define DA9150_VDD33_SLEEP_SHIFT		1
> +#define DA9150_VDD33_SLEEP_MASK			(0x01 << 1)
> +#define DA9150_LFOSC_STAT_SHIFT			7
> +#define DA9150_LFOSC_STAT_MASK			(0x01 << 7)
> +
> +/* DA9150_STATUS_D = 0x06B */
> +#define DA9150_GPIOA_STAT_SHIFT			0
> +#define DA9150_GPIOA_STAT_MASK			(0x01 << 0)
> +#define DA9150_GPIOB_STAT_SHIFT			1
> +#define DA9150_GPIOB_STAT_MASK			(0x01 << 1)
> +#define DA9150_GPIOC_STAT_SHIFT			2
> +#define DA9150_GPIOC_STAT_MASK			(0x01 << 2)
> +#define DA9150_GPIOD_STAT_SHIFT			3
> +#define DA9150_GPIOD_STAT_MASK			(0x01 << 3)
> +
> +/* DA9150_STATUS_E = 0x06C */
> +#define DA9150_DTYPE_SHIFT			0
> +#define DA9150_DTYPE_MASK			(0x1f << 0)
> +#define DA9150_DTYPE_DT_NIL			(0x00 << 0)
> +#define DA9150_DTYPE_DT_USB_OTG			(0x01 << 0)
> +#define DA9150_DTYPE_DT_USB_STD			(0x02 << 0)
> +#define DA9150_DTYPE_DT_USB_CHG			(0x03 << 0)
> +#define DA9150_DTYPE_DT_ACA_CHG			(0x04 << 0)
> +#define DA9150_DTYPE_DT_ACA_OTG			(0x05 << 0)
> +#define DA9150_DTYPE_DT_ACA_DOC			(0x06 << 0)
> +#define DA9150_DTYPE_DT_DED_CHG			(0x07 << 0)
> +#define DA9150_DTYPE_DT_CR5_CHG			(0x08 << 0)
> +#define DA9150_DTYPE_DT_CR4_CHG			(0x0c << 0)
> +#define DA9150_DTYPE_DT_PT_CHG			(0x11 << 0)
> +#define DA9150_DTYPE_DT_NN_ACC			(0x16 << 0)
> +#define DA9150_DTYPE_DT_NN_CHG			(0x17 << 0)
> +
> +/* DA9150_STATUS_F = 0x06D */
> +#define DA9150_SESS_VLD_SHIFT			0
> +#define DA9150_SESS_VLD_MASK			(0x01 << 0)
> +#define DA9150_ID_ERR_SHIFT			1
> +#define DA9150_ID_ERR_MASK			(0x01 << 1)
> +#define DA9150_PT_CHG_SHIFT			2
> +#define DA9150_PT_CHG_MASK			(0x01 << 2)
> +
> +/* DA9150_STATUS_G = 0x06E */
> +#define DA9150_RID_SHIFT			0
> +#define DA9150_RID_MASK				(0xff << 0)
> +
> +/* DA9150_STATUS_H = 0x06F */
> +#define DA9150_VBUS_STAT_SHIFT			0
> +#define DA9150_VBUS_STAT_MASK			(0x07 << 0)
> +#define DA9150_VBUS_STAT_OFF			(0x00 << 0)
> +#define DA9150_VBUS_STAT_WAIT			(0x01 << 0)
> +#define DA9150_VBUS_STAT_CHG			(0x02 << 0)
> +#define DA9150_VBUS_TRED_SHIFT			3
> +#define DA9150_VBUS_TRED_MASK			(0x01 << 3)
> +#define DA9150_VBUS_DROP_STAT_SHIFT		4
> +#define DA9150_VBUS_DROP_STAT_MASK		(0x0f << 4)
> +
> +/* DA9150_STATUS_I = 0x070 */
> +#define DA9150_VBUS_ISET_STAT_SHIFT		0
> +#define DA9150_VBUS_ISET_STAT_MASK		(0x1f << 0)
> +#define DA9150_VBUS_OT_SHIFT			7
> +#define DA9150_VBUS_OT_MASK			(0x01 << 7)
> +
> +/* DA9150_STATUS_J = 0x071 */
> +#define DA9150_CHG_STAT_SHIFT			0
> +#define DA9150_CHG_STAT_MASK			(0x0f << 0)
> +#define DA9150_CHG_STAT_OFF			(0x00 << 0)
> +#define DA9150_CHG_STAT_SUSP			(0x01 << 0)
> +#define DA9150_CHG_STAT_ACT			(0x02 << 0)
> +#define DA9150_CHG_STAT_PRE			(0x03 << 0)
> +#define DA9150_CHG_STAT_CC			(0x04 << 0)
> +#define DA9150_CHG_STAT_CV			(0x05 << 0)
> +#define DA9150_CHG_STAT_FULL			(0x06 << 0)
> +#define DA9150_CHG_STAT_TEMP			(0x07 << 0)
> +#define DA9150_CHG_STAT_TIME			(0x08 << 0)
> +#define DA9150_CHG_STAT_BAT			(0x09 << 0)
> +#define DA9150_CHG_TEMP_SHIFT			4
> +#define DA9150_CHG_TEMP_MASK			(0x07 << 4)
> +#define DA9150_CHG_TEMP_UNDER			(0x06 << 4)
> +#define DA9150_CHG_TEMP_OVER			(0x07 << 4)
> +#define DA9150_CHG_IEND_STAT_SHIFT		7
> +#define DA9150_CHG_IEND_STAT_MASK		(0x01 << 7)
> +
> +/* DA9150_STATUS_K = 0x072 */
> +#define DA9150_CHG_IAV_H_SHIFT			0
> +#define DA9150_CHG_IAV_H_MASK			(0xff << 0)
> +
> +/* DA9150_STATUS_L = 0x073 */
> +#define DA9150_CHG_IAV_L_SHIFT			5
> +#define DA9150_CHG_IAV_L_MASK			(0x07 << 5)
> +
> +/* DA9150_STATUS_N = 0x074 */
> +#define DA9150_CHG_TIME_SHIFT			1
> +#define DA9150_CHG_TIME_MASK			(0x01 << 1)
> +#define DA9150_CHG_TRED_SHIFT			2
> +#define DA9150_CHG_TRED_MASK			(0x01 << 2)
> +#define DA9150_CHG_TJUNC_CLASS_SHIFT		3
> +#define DA9150_CHG_TJUNC_CLASS_MASK		(0x07 << 3)
> +#define DA9150_CHG_TJUNC_CLASS_6		(0x06 << 3)
> +#define DA9150_EBS_STAT_SHIFT			6
> +#define DA9150_EBS_STAT_MASK			(0x01 << 6)
> +#define DA9150_CHG_BAT_REMOVED_SHIFT		7
> +#define DA9150_CHG_BAT_REMOVED_MASK		(0x01 << 7)
> +
> +/* DA9150_FAULT_LOG_A = 0x076 */
> +#define DA9150_TEMP_FAULT_SHIFT			0
> +#define DA9150_TEMP_FAULT_MASK			(0x01 << 0)
> +#define DA9150_VSYS_FAULT_SHIFT			1
> +#define DA9150_VSYS_FAULT_MASK			(0x01 << 1)
> +#define DA9150_START_FAULT_SHIFT		2
> +#define DA9150_START_FAULT_MASK			(0x01 << 2)
> +#define DA9150_EXT_FAULT_SHIFT			3
> +#define DA9150_EXT_FAULT_MASK			(0x01 << 3)
> +#define DA9150_POR_FAULT_SHIFT			4
> +#define DA9150_POR_FAULT_MASK			(0x01 << 4)
> +
> +/* DA9150_FAULT_LOG_B = 0x077 */
> +#define DA9150_VBUS_FAULT_SHIFT			0
> +#define DA9150_VBUS_FAULT_MASK			(0x01 << 0)
> +#define DA9150_OTG_FAULT_SHIFT			1
> +#define DA9150_OTG_FAULT_MASK			(0x01 << 1)
> +
> +/* DA9150_EVENT_E = 0x078 */
> +#define DA9150_E_VBUS_SHIFT			0
> +#define DA9150_E_VBUS_MASK			(0x01 << 0)
> +#define DA9150_E_CHG_SHIFT			1
> +#define DA9150_E_CHG_MASK			(0x01 << 1)
> +#define DA9150_E_TCLASS_SHIFT			2
> +#define DA9150_E_TCLASS_MASK			(0x01 << 2)
> +#define DA9150_E_TJUNC_SHIFT			3
> +#define DA9150_E_TJUNC_MASK			(0x01 << 3)
> +#define DA9150_E_VFAULT_SHIFT			4
> +#define DA9150_E_VFAULT_MASK			(0x01 << 4)
> +#define DA9150_EVENTS_H_SHIFT			5
> +#define DA9150_EVENTS_H_MASK			(0x01 << 5)
> +#define DA9150_EVENTS_G_SHIFT			6
> +#define DA9150_EVENTS_G_MASK			(0x01 << 6)
> +#define DA9150_EVENTS_F_SHIFT			7
> +#define DA9150_EVENTS_F_MASK			(0x01 << 7)
> +
> +/* DA9150_EVENT_F = 0x079 */
> +#define DA9150_E_CONF_SHIFT			0
> +#define DA9150_E_CONF_MASK			(0x01 << 0)
> +#define DA9150_E_DAT_SHIFT			1
> +#define DA9150_E_DAT_MASK			(0x01 << 1)
> +#define DA9150_E_DTYPE_SHIFT			3
> +#define DA9150_E_DTYPE_MASK			(0x01 << 3)
> +#define DA9150_E_ID_SHIFT			4
> +#define DA9150_E_ID_MASK			(0x01 << 4)
> +#define DA9150_E_ADP_SHIFT			5
> +#define DA9150_E_ADP_MASK			(0x01 << 5)
> +#define DA9150_E_SESS_END_SHIFT			6
> +#define DA9150_E_SESS_END_MASK			(0x01 << 6)
> +#define DA9150_E_SESS_VLD_SHIFT			7
> +#define DA9150_E_SESS_VLD_MASK			(0x01 << 7)
> +
> +/* DA9150_EVENT_G = 0x07A */
> +#define DA9150_E_FG_SHIFT			0
> +#define DA9150_E_FG_MASK			(0x01 << 0)
> +#define DA9150_E_GP_SHIFT			1
> +#define DA9150_E_GP_MASK			(0x01 << 1)
> +#define DA9150_E_TBAT_SHIFT			2
> +#define DA9150_E_TBAT_MASK			(0x01 << 2)
> +#define DA9150_E_GPIOA_SHIFT			3
> +#define DA9150_E_GPIOA_MASK			(0x01 << 3)
> +#define DA9150_E_GPIOB_SHIFT			4
> +#define DA9150_E_GPIOB_MASK			(0x01 << 4)
> +#define DA9150_E_GPIOC_SHIFT			5
> +#define DA9150_E_GPIOC_MASK			(0x01 << 5)
> +#define DA9150_E_GPIOD_SHIFT			6
> +#define DA9150_E_GPIOD_MASK			(0x01 << 6)
> +#define DA9150_E_GPADC_SHIFT			7
> +#define DA9150_E_GPADC_MASK			(0x01 << 7)
> +
> +/* DA9150_EVENT_H = 0x07B */
> +#define DA9150_E_WKUP_SHIFT			0
> +#define DA9150_E_WKUP_MASK			(0x01 << 0)
> +
> +/* DA9150_IRQ_MASK_E = 0x07C */
> +#define DA9150_M_VBUS_SHIFT			0
> +#define DA9150_M_VBUS_MASK			(0x01 << 0)
> +#define DA9150_M_CHG_SHIFT			1
> +#define DA9150_M_CHG_MASK			(0x01 << 1)
> +#define DA9150_M_TJUNC_SHIFT			3
> +#define DA9150_M_TJUNC_MASK			(0x01 << 3)
> +#define DA9150_M_VFAULT_SHIFT			4
> +#define DA9150_M_VFAULT_MASK			(0x01 << 4)
> +
> +/* DA9150_IRQ_MASK_F = 0x07D */
> +#define DA9150_M_CONF_SHIFT			0
> +#define DA9150_M_CONF_MASK			(0x01 << 0)
> +#define DA9150_M_DAT_SHIFT			1
> +#define DA9150_M_DAT_MASK			(0x01 << 1)
> +#define DA9150_M_DTYPE_SHIFT			3
> +#define DA9150_M_DTYPE_MASK			(0x01 << 3)
> +#define DA9150_M_ID_SHIFT			4
> +#define DA9150_M_ID_MASK			(0x01 << 4)
> +#define DA9150_M_ADP_SHIFT			5
> +#define DA9150_M_ADP_MASK			(0x01 << 5)
> +#define DA9150_M_SESS_END_SHIFT			6
> +#define DA9150_M_SESS_END_MASK			(0x01 << 6)
> +#define DA9150_M_SESS_VLD_SHIFT			7
> +#define DA9150_M_SESS_VLD_MASK			(0x01 << 7)
> +
> +/* DA9150_IRQ_MASK_G = 0x07E */
> +#define DA9150_M_FG_SHIFT			0
> +#define DA9150_M_FG_MASK			(0x01 << 0)
> +#define DA9150_M_GP_SHIFT			1
> +#define DA9150_M_GP_MASK			(0x01 << 1)
> +#define DA9150_M_TBAT_SHIFT			2
> +#define DA9150_M_TBAT_MASK			(0x01 << 2)
> +#define DA9150_M_GPIOA_SHIFT			3
> +#define DA9150_M_GPIOA_MASK			(0x01 << 3)
> +#define DA9150_M_GPIOB_SHIFT			4
> +#define DA9150_M_GPIOB_MASK			(0x01 << 4)
> +#define DA9150_M_GPIOC_SHIFT			5
> +#define DA9150_M_GPIOC_MASK			(0x01 << 5)
> +#define DA9150_M_GPIOD_SHIFT			6
> +#define DA9150_M_GPIOD_MASK			(0x01 << 6)
> +#define DA9150_M_GPADC_SHIFT			7
> +#define DA9150_M_GPADC_MASK			(0x01 << 7)
> +
> +/* DA9150_IRQ_MASK_H = 0x07F */
> +#define DA9150_M_WKUP_SHIFT			0
> +#define DA9150_M_WKUP_MASK			(0x01 << 0)
> +
> +/* DA9150_PAGE_CON_1 = 0x080 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_CONFIG_A = 0x0E0 */
> +#define DA9150_RESET_DUR_SHIFT			0
> +#define DA9150_RESET_DUR_MASK			(0x03 << 0)
> +#define DA9150_RESET_EXT_SHIFT			2
> +#define DA9150_RESET_EXT_MASK			(0x03 << 2)
> +#define DA9150_START_MAX_SHIFT			4
> +#define DA9150_START_MAX_MASK			(0x03 << 4)
> +#define DA9150_PS_WAIT_EN_SHIFT			6
> +#define DA9150_PS_WAIT_EN_MASK			(0x01 << 6)
> +#define DA9150_PS_DISABLE_DIRECT_SHIFT		7
> +#define DA9150_PS_DISABLE_DIRECT_MASK		(0x01 << 7)
> +
> +/* DA9150_CONFIG_B = 0x0E1 */
> +#define DA9150_VFAULT_ADJ_SHIFT			0
> +#define DA9150_VFAULT_ADJ_MASK			(0x0f << 0)
> +#define DA9150_VFAULT_HYST_SHIFT		4
> +#define DA9150_VFAULT_HYST_MASK			(0x07 << 4)
> +#define DA9150_VFAULT_EN_SHIFT			7
> +#define DA9150_VFAULT_EN_MASK			(0x01 << 7)
> +
> +/* DA9150_CONFIG_C = 0x0E2 */
> +#define DA9150_VSYS_MIN_SHIFT			3
> +#define DA9150_VSYS_MIN_MASK			(0x1f << 3)
> +
> +/* DA9150_CONFIG_D = 0x0E3 */
> +#define DA9150_LFOSC_EXT_SHIFT			0
> +#define DA9150_LFOSC_EXT_MASK			(0x01 << 0)
> +#define DA9150_VDD33_DWN_SHIFT			1
> +#define DA9150_VDD33_DWN_MASK			(0x01 << 1)
> +#define DA9150_WKUP_PM_EN_SHIFT			2
> +#define DA9150_WKUP_PM_EN_MASK			(0x01 << 2)
> +#define DA9150_WKUP_CE_SEL_SHIFT		3
> +#define DA9150_WKUP_CE_SEL_MASK			(0x03 << 3)
> +#define DA9150_WKUP_CLK32K_EN_SHIFT		5
> +#define DA9150_WKUP_CLK32K_EN_MASK		(0x01 << 5)
> +#define DA9150_DISABLE_DEL_SHIFT		7
> +#define DA9150_DISABLE_DEL_MASK			(0x01 << 7)
> +
> +/* DA9150_CONFIG_E = 0x0E4 */
> +#define DA9150_PM_SPKSUP_DIS_SHIFT		0
> +#define DA9150_PM_SPKSUP_DIS_MASK		(0x01 << 0)
> +#define DA9150_PM_MERGE_SHIFT			1
> +#define DA9150_PM_MERGE_MASK			(0x01 << 1)
> +#define DA9150_PM_SR_OFF_SHIFT			2
> +#define DA9150_PM_SR_OFF_MASK			(0x01 << 2)
> +#define DA9150_PM_TIMEOUT_EN_SHIFT		3
> +#define DA9150_PM_TIMEOUT_EN_MASK		(0x01 << 3)
> +#define DA9150_PM_DLY_SEL_SHIFT			4
> +#define DA9150_PM_DLY_SEL_MASK			(0x07 << 4)
> +#define DA9150_PM_OUT_DLY_SEL_SHIFT		7
> +#define DA9150_PM_OUT_DLY_SEL_MASK		(0x01 << 7)
> +
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
> +
> +/* DA9150_GPIO_A_B = 0x0E8 */
> +#define DA9150_GPIOA_PIN_SHIFT			0
> +#define DA9150_GPIOA_PIN_MASK			(0x07 << 0)
> +#define DA9150_GPIOA_PIN_GPI			(0x00 << 0)
> +#define DA9150_GPIOA_PIN_GPO_OD			(0x01 << 0)
> +#define DA9150_GPIOA_TYPE_SHIFT			3
> +#define DA9150_GPIOA_TYPE_MASK			(0x01 << 3)
> +#define DA9150_GPIOB_PIN_SHIFT			4
> +#define DA9150_GPIOB_PIN_MASK			(0x07 << 4)
> +#define DA9150_GPIOB_PIN_GPI			(0x00 << 4)
> +#define DA9150_GPIOB_PIN_GPO_OD			(0x01 << 4)
> +#define DA9150_GPIOB_TYPE_SHIFT			7
> +#define DA9150_GPIOB_TYPE_MASK			(0x01 << 7)
> +
> +/* DA9150_GPIO_C_D = 0x0E9 */
> +#define DA9150_GPIOC_PIN_SHIFT			0
> +#define DA9150_GPIOC_PIN_MASK			(0x07 << 0)
> +#define DA9150_GPIOC_PIN_GPI			(0x00 << 0)
> +#define DA9150_GPIOC_PIN_GPO_OD			(0x01 << 0)
> +#define DA9150_GPIOC_TYPE_SHIFT			3
> +#define DA9150_GPIOC_TYPE_MASK			(0x01 << 3)
> +#define DA9150_GPIOD_PIN_SHIFT			4
> +#define DA9150_GPIOD_PIN_MASK			(0x07 << 4)
> +#define DA9150_GPIOD_PIN_GPI			(0x00 << 4)
> +#define DA9150_GPIOD_PIN_GPO_OD			(0x01 << 4)
> +#define DA9150_GPIOD_TYPE_SHIFT			7
> +#define DA9150_GPIOD_TYPE_MASK			(0x01 << 7)
> +
> +/* DA9150_GPIO_MODE_CONT = 0x0EA */
> +#define DA9150_GPIOA_MODE_SHIFT			0
> +#define DA9150_GPIOA_MODE_MASK			(0x01 << 0)
> +#define DA9150_GPIOB_MODE_SHIFT			1
> +#define DA9150_GPIOB_MODE_MASK			(0x01 << 1)
> +#define DA9150_GPIOC_MODE_SHIFT			2
> +#define DA9150_GPIOC_MODE_MASK			(0x01 << 2)
> +#define DA9150_GPIOD_MODE_SHIFT			3
> +#define DA9150_GPIOD_MODE_MASK			(0x01 << 3)
> +#define DA9150_GPIOA_CONT_SHIFT			4
> +#define DA9150_GPIOA_CONT_MASK			(0x01 << 4)
> +#define DA9150_GPIOB_CONT_SHIFT			5
> +#define DA9150_GPIOB_CONT_MASK			(0x01 << 5)
> +#define DA9150_GPIOC_CONT_SHIFT			6
> +#define DA9150_GPIOC_CONT_MASK			(0x01 << 6)
> +#define DA9150_GPIOD_CONT_SHIFT			7
> +#define DA9150_GPIOD_CONT_MASK			(0x01 << 7)
> +
> +/* DA9150_GPIO_CTRL_B = 0x0EB */
> +#define DA9150_WAKE_PIN_SHIFT			0
> +#define DA9150_WAKE_PIN_MASK			(0x03 << 0)
> +#define DA9150_WAKE_MODE_SHIFT			2
> +#define DA9150_WAKE_MODE_MASK			(0x01 << 2)
> +#define DA9150_WAKE_CONT_SHIFT			3
> +#define DA9150_WAKE_CONT_MASK			(0x01 << 3)
> +#define DA9150_WAKE_DLY_SHIFT			4
> +#define DA9150_WAKE_DLY_MASK			(0x01 << 4)
> +
> +/* DA9150_GPIO_CTRL_A = 0x0EC */
> +#define DA9150_GPIOA_ANAEN_SHIFT		0
> +#define DA9150_GPIOA_ANAEN_MASK			(0x01 << 0)
> +#define DA9150_GPIOB_ANAEN_SHIFT		1
> +#define DA9150_GPIOB_ANAEN_MASK			(0x01 << 1)
> +#define DA9150_GPIOC_ANAEN_SHIFT		2
> +#define DA9150_GPIOC_ANAEN_MASK			(0x01 << 2)
> +#define DA9150_GPIOD_ANAEN_SHIFT		3
> +#define DA9150_GPIOD_ANAEN_MASK			(0x01 << 3)
> +#define DA9150_GPIO_ANAEN			0x01
> +#define DA9150_GPIO_ANAEN_MASK			0x0F
> +#define DA9150_CHGLED_PIN_SHIFT			5
> +#define DA9150_CHGLED_PIN_MASK			(0x07 << 5)
> +
> +/* DA9150_GPIO_CTRL_C = 0x0ED */
> +#define DA9150_CHGBL_DUR_SHIFT			0
> +#define DA9150_CHGBL_DUR_MASK			(0x03 << 0)
> +#define DA9150_CHGBL_DBL_SHIFT			2
> +#define DA9150_CHGBL_DBL_MASK			(0x01 << 2)
> +#define DA9150_CHGBL_FRQ_SHIFT			3
> +#define DA9150_CHGBL_FRQ_MASK			(0x03 << 3)
> +#define DA9150_CHGBL_FLKR_SHIFT			5
> +#define DA9150_CHGBL_FLKR_MASK			(0x01 << 5)
> +
> +/* DA9150_GPIO_CFG_A = 0x0EE */
> +#define DA9150_CE_LPM_DEB_SHIFT			0
> +#define DA9150_CE_LPM_DEB_MASK			(0x07 << 0)
> +
> +/* DA9150_GPIO_CFG_B = 0x0EF */
> +#define DA9150_GPIOA_PUPD_SHIFT			0
> +#define DA9150_GPIOA_PUPD_MASK			(0x01 << 0)
> +#define DA9150_GPIOB_PUPD_SHIFT			1
> +#define DA9150_GPIOB_PUPD_MASK			(0x01 << 1)
> +#define DA9150_GPIOC_PUPD_SHIFT			2
> +#define DA9150_GPIOC_PUPD_MASK			(0x01 << 2)
> +#define DA9150_GPIOD_PUPD_SHIFT			3
> +#define DA9150_GPIOD_PUPD_MASK			(0x01 << 3)
> +#define DA9150_GPIO_PUPD_MASK			(0xF << 0)
> +#define DA9150_GPI_DEB_SHIFT			4
> +#define DA9150_GPI_DEB_MASK			(0x07 << 4)
> +#define DA9150_LPM_EN_SHIFT			7
> +#define DA9150_LPM_EN_MASK			(0x01 << 7)
> +
> +/* DA9150_GPIO_CFG_C = 0x0F0 */
> +#define DA9150_GPI_V_SHIFT			0
> +#define DA9150_GPI_V_MASK			(0x01 << 0)
> +#define DA9150_VDDIO_INT_SHIFT			1
> +#define DA9150_VDDIO_INT_MASK			(0x01 << 1)
> +#define DA9150_FAULT_PIN_SHIFT			3
> +#define DA9150_FAULT_PIN_MASK			(0x07 << 3)
> +#define DA9150_FAULT_TYPE_SHIFT			6
> +#define DA9150_FAULT_TYPE_MASK			(0x01 << 6)
> +#define DA9150_NIRQ_PUPD_SHIFT			7
> +#define DA9150_NIRQ_PUPD_MASK			(0x01 << 7)
> +
> +/* DA9150_GPADC_MAN = 0x0F2 */
> +#define DA9150_GPADC_EN_SHIFT			0
> +#define DA9150_GPADC_EN_MASK			(0x01 << 0)
> +#define DA9150_GPADC_MUX_SHIFT			1
> +#define DA9150_GPADC_MUX_MASK			(0x1f << 1)
> +
> +/* DA9150_GPADC_RES_A = 0x0F4 */
> +#define DA9150_GPADC_RES_H_SHIFT		0
> +#define DA9150_GPADC_RES_H_MASK			(0xff << 0)
> +
> +/* DA9150_GPADC_RES_B = 0x0F5 */
> +#define DA9150_GPADC_RUN_SHIFT			0
> +#define DA9150_GPADC_RUN_MASK			(0x01 << 0)
> +#define DA9150_GPADC_RES_L_SHIFT		6
> +#define DA9150_GPADC_RES_L_MASK			(0x03 << 6)
> +
> +/* DA9150_PAGE_CON_2 = 0x100 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_OTP_CONT_SHARED = 0x101 */
> +#define DA9150_PC_DONE_SHIFT			3
> +#define DA9150_PC_DONE_MASK			(0x01 << 3)
> +
> +/* DA9150_INTERFACE_SHARED = 0x105 */
> +#define DA9150_IF_BASE_ADDR_SHIFT		4
> +#define DA9150_IF_BASE_ADDR_MASK		(0x0f << 4)
> +
> +/* DA9150_CONFIG_A_SHARED = 0x106 */
> +#define DA9150_NIRQ_VDD_SHIFT			1
> +#define DA9150_NIRQ_VDD_MASK			(0x01 << 1)
> +#define DA9150_NIRQ_PIN_SHIFT			2
> +#define DA9150_NIRQ_PIN_MASK			(0x01 << 2)
> +#define DA9150_NIRQ_TYPE_SHIFT			3
> +#define DA9150_NIRQ_TYPE_MASK			(0x01 << 3)
> +#define DA9150_PM_IF_V_SHIFT			4
> +#define DA9150_PM_IF_V_MASK			(0x01 << 4)
> +#define DA9150_PM_IF_FMP_SHIFT			5
> +#define DA9150_PM_IF_FMP_MASK			(0x01 << 5)
> +#define DA9150_PM_IF_HSM_SHIFT			6
> +#define DA9150_PM_IF_HSM_MASK			(0x01 << 6)
> +
> +/* DA9150_CONFIG_D_SHARED = 0x109 */
> +#define DA9150_NIRQ_MODE_SHIFT			1
> +#define DA9150_NIRQ_MODE_MASK			(0x01 << 1)
> +
> +/* DA9150_ADETVB_CFG_C = 0x150 */
> +#define DA9150_TADP_RISE_SHIFT			0
> +#define DA9150_TADP_RISE_MASK			(0xff << 0)
> +
> +/* DA9150_ADETD_STAT = 0x151 */
> +#define DA9150_DCD_STAT_SHIFT			0
> +#define DA9150_DCD_STAT_MASK			(0x01 << 0)
> +#define DA9150_PCD_STAT_SHIFT			1
> +#define DA9150_PCD_STAT_MASK			(0x03 << 1)
> +#define DA9150_SCD_STAT_SHIFT			3
> +#define DA9150_SCD_STAT_MASK			(0x03 << 3)
> +#define DA9150_DP_STAT_SHIFT			5
> +#define DA9150_DP_STAT_MASK			(0x01 << 5)
> +#define DA9150_DM_STAT_SHIFT			6
> +#define DA9150_DM_STAT_MASK			(0x01 << 6)
> +
> +/* DA9150_ADET_CMPSTAT = 0x152 */
> +#define DA9150_DP_COMP_SHIFT			1
> +#define DA9150_DP_COMP_MASK			(0x01 << 1)
> +#define DA9150_DM_COMP_SHIFT			2
> +#define DA9150_DM_COMP_MASK			(0x01 << 2)
> +#define DA9150_ADP_SNS_COMP_SHIFT		3
> +#define DA9150_ADP_SNS_COMP_MASK		(0x01 << 3)
> +#define DA9150_ADP_PRB_COMP_SHIFT		4
> +#define DA9150_ADP_PRB_COMP_MASK		(0x01 << 4)
> +#define DA9150_ID_COMP_SHIFT			5
> +#define DA9150_ID_COMP_MASK			(0x01 << 5)
> +
> +/* DA9150_ADET_CTRL_A = 0x153 */
> +#define DA9150_AID_DAT_SHIFT			0
> +#define DA9150_AID_DAT_MASK			(0x01 << 0)
> +#define DA9150_AID_ID_SHIFT			1
> +#define DA9150_AID_ID_MASK			(0x01 << 1)
> +#define DA9150_AID_TRIG_SHIFT			2
> +#define DA9150_AID_TRIG_MASK			(0x01 << 2)
> +
> +/* DA9150_ADETVB_CFG_B = 0x154 */
> +#define DA9150_VB_MODE_SHIFT			0
> +#define DA9150_VB_MODE_MASK			(0x03 << 0)
> +#define DA9150_VB_MODE_VB_SESS			(0x01 << 0)
> +
> +#define DA9150_TADP_PRB_SHIFT			2
> +#define DA9150_TADP_PRB_MASK			(0x01 << 2)
> +#define DA9150_DAT_RPD_EXT_SHIFT		5
> +#define DA9150_DAT_RPD_EXT_MASK			(0x01 << 5)
> +#define DA9150_CONF_RPD_SHIFT			6
> +#define DA9150_CONF_RPD_MASK			(0x01 << 6)
> +#define DA9150_CONF_SRP_SHIFT			7
> +#define DA9150_CONF_SRP_MASK			(0x01 << 7)
> +
> +/* DA9150_ADETVB_CFG_A = 0x155 */
> +#define DA9150_AID_MODE_SHIFT			0
> +#define DA9150_AID_MODE_MASK			(0x03 << 0)
> +#define DA9150_AID_EXT_POL_SHIFT		2
> +#define DA9150_AID_EXT_POL_MASK			(0x01 << 2)
> +
> +/* DA9150_ADETAC_CFG_A = 0x156 */
> +#define DA9150_ISET_CDP_SHIFT			0
> +#define DA9150_ISET_CDP_MASK			(0x1f << 0)
> +#define DA9150_CONF_DBP_SHIFT			5
> +#define DA9150_CONF_DBP_MASK			(0x01 << 5)
> +
> +/* DA9150_ADDETAC_CFG_B = 0x157 */
> +#define DA9150_ISET_DCHG_SHIFT			0
> +#define DA9150_ISET_DCHG_MASK			(0x1f << 0)
> +#define DA9150_CONF_GPIOA_SHIFT			5
> +#define DA9150_CONF_GPIOA_MASK			(0x01 << 5)
> +#define DA9150_CONF_GPIOB_SHIFT			6
> +#define DA9150_CONF_GPIOB_MASK			(0x01 << 6)
> +#define DA9150_AID_VB_SHIFT			7
> +#define DA9150_AID_VB_MASK			(0x01 << 7)
> +
> +/* DA9150_ADETAC_CFG_C = 0x158 */
> +#define DA9150_ISET_DEF_SHIFT			0
> +#define DA9150_ISET_DEF_MASK			(0x1f << 0)
> +#define DA9150_CONF_MODE_SHIFT			5
> +#define DA9150_CONF_MODE_MASK			(0x03 << 5)
> +#define DA9150_AID_CR_DIS_SHIFT			7
> +#define DA9150_AID_CR_DIS_MASK			(0x01 << 7)
> +
> +/* DA9150_ADETAC_CFG_D = 0x159 */
> +#define DA9150_ISET_UNIT_SHIFT			0
> +#define DA9150_ISET_UNIT_MASK			(0x1f << 0)
> +#define DA9150_AID_UNCLAMP_SHIFT		5
> +#define DA9150_AID_UNCLAMP_MASK			(0x01 << 5)
> +
> +/* DA9150_ADETVB_CFG_D = 0x15A */
> +#define DA9150_ID_MODE_SHIFT			0
> +#define DA9150_ID_MODE_MASK			(0x03 << 0)
> +#define DA9150_DAT_MODE_SHIFT			2
> +#define DA9150_DAT_MODE_MASK			(0x0f << 2)
> +#define DA9150_DAT_SWP_SHIFT			6
> +#define DA9150_DAT_SWP_MASK			(0x01 << 6)
> +#define DA9150_DAT_CLAMP_EXT_SHIFT		7
> +#define DA9150_DAT_CLAMP_EXT_MASK		(0x01 << 7)
> +
> +/* DA9150_ADETID_CFG_A = 0x15B */
> +#define DA9150_TID_POLL_SHIFT			0
> +#define DA9150_TID_POLL_MASK			(0x07 << 0)
> +#define DA9150_RID_CONV_SHIFT			3
> +#define DA9150_RID_CONV_MASK			(0x01 << 3)
> +
> +/* DA9150_ADET_RID_PT_CHG_H = 0x15C */
> +#define DA9150_RID_PT_CHG_H_SHIFT		0
> +#define DA9150_RID_PT_CHG_H_MASK		(0xff << 0)
> +
> +/* DA9150_ADET_RID_PT_CHG_L = 0x15D */
> +#define DA9150_RID_PT_CHG_L_SHIFT		6
> +#define DA9150_RID_PT_CHG_L_MASK		(0x03 << 6)
> +
> +/* DA9150_PPR_TCTR_B = 0x160 */
> +#define DA9150_CHG_TCTR_VAL_SHIFT		0
> +#define DA9150_CHG_TCTR_VAL_MASK		(0xff << 0)
> +
> +/* DA9150_PPR_BKCTRL_A = 0x163 */
> +#define DA9150_VBUS_MODE_SHIFT			0
> +#define DA9150_VBUS_MODE_MASK			(0x03 << 0)
> +#define DA9150_VBUS_MODE_CHG			(0x01 << 0)
> +#define DA9150_VBUS_MODE_OTG			(0x02 << 0)
> +#define DA9150_VBUS_LPM_SHIFT			2
> +#define DA9150_VBUS_LPM_MASK			(0x03 << 2)
> +#define DA9150_VBUS_SUSP_SHIFT			4
> +#define DA9150_VBUS_SUSP_MASK			(0x01 << 4)
> +#define DA9150_VBUS_PWM_SHIFT			5
> +#define DA9150_VBUS_PWM_MASK			(0x01 << 5)
> +#define DA9150_VBUS_ISO_SHIFT			6
> +#define DA9150_VBUS_ISO_MASK			(0x01 << 6)
> +#define DA9150_VBUS_LDO_SHIFT			7
> +#define DA9150_VBUS_LDO_MASK			(0x01 << 7)
> +
> +/* DA9150_PPR_BKCFG_A = 0x164 */
> +#define DA9150_VBUS_ISET_SHIFT			0
> +#define DA9150_VBUS_ISET_MASK			(0x1f << 0)
> +#define DA9150_VBUS_IMAX_SHIFT			5
> +#define DA9150_VBUS_IMAX_MASK			(0x01 << 5)
> +#define DA9150_VBUS_IOTG_SHIFT			6
> +#define DA9150_VBUS_IOTG_MASK			(0x03 << 6)
> +
> +/* DA9150_PPR_BKCFG_B = 0x165 */
> +#define DA9150_VBUS_DROP_SHIFT			0
> +#define DA9150_VBUS_DROP_MASK			(0x0f << 0)
> +#define DA9150_VBUS_FAULT_DIS_SHIFT		6
> +#define DA9150_VBUS_FAULT_DIS_MASK		(0x01 << 6)
> +#define DA9150_OTG_FAULT_DIS_SHIFT		7
> +#define DA9150_OTG_FAULT_DIS_MASK		(0x01 << 7)
> +
> +/* DA9150_PPR_CHGCTRL_A = 0x166 */
> +#define DA9150_CHG_EN_SHIFT			0
> +#define DA9150_CHG_EN_MASK			(0x01 << 0)
> +
> +/* DA9150_PPR_CHGCTRL_B = 0x167 */
> +#define DA9150_CHG_VBAT_SHIFT			0
> +#define DA9150_CHG_VBAT_MASK			(0x1f << 0)
> +#define DA9150_CHG_VDROP_SHIFT			6
> +#define DA9150_CHG_VDROP_MASK			(0x03 << 6)
> +
> +/* DA9150_PPR_CHGCTRL_C = 0x168 */
> +#define DA9150_CHG_VFAULT_SHIFT			0
> +#define DA9150_CHG_VFAULT_MASK			(0x0f << 0)
> +#define DA9150_CHG_IPRE_SHIFT			4
> +#define DA9150_CHG_IPRE_MASK			(0x03 << 4)
> +
> +/* DA9150_PPR_TCTR_A = 0x169 */
> +#define DA9150_CHG_TCTR_SHIFT			0
> +#define DA9150_CHG_TCTR_MASK			(0x07 << 0)
> +#define DA9150_CHG_TCTR_MODE_SHIFT		4
> +#define DA9150_CHG_TCTR_MODE_MASK		(0x01 << 4)
> +
> +/* DA9150_PPR_CHGCTRL_D = 0x16A */
> +#define DA9150_CHG_IBAT_SHIFT			0
> +#define DA9150_CHG_IBAT_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_E = 0x16B */
> +#define DA9150_CHG_IEND_SHIFT			0
> +#define DA9150_CHG_IEND_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_F = 0x16C */
> +#define DA9150_CHG_VCOLD_SHIFT			0
> +#define DA9150_CHG_VCOLD_MASK			(0x1f << 0)
> +#define DA9150_TBAT_TQA_EN_SHIFT		6
> +#define DA9150_TBAT_TQA_EN_MASK			(0x01 << 6)
> +#define DA9150_TBAT_TDP_EN_SHIFT		7
> +#define DA9150_TBAT_TDP_EN_MASK			(0x01 << 7)
> +
> +/* DA9150_PPR_CHGCTRL_G = 0x16D */
> +#define DA9150_CHG_VWARM_SHIFT			0
> +#define DA9150_CHG_VWARM_MASK			(0x1f << 0)
> +
> +/* DA9150_PPR_CHGCTRL_H = 0x16E */
> +#define DA9150_CHG_VHOT_SHIFT			0
> +#define DA9150_CHG_VHOT_MASK			(0x1f << 0)
> +
> +/* DA9150_PPR_CHGCTRL_I = 0x16F */
> +#define DA9150_CHG_ICOLD_SHIFT			0
> +#define DA9150_CHG_ICOLD_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_J = 0x170 */
> +#define DA9150_CHG_IWARM_SHIFT			0
> +#define DA9150_CHG_IWARM_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_K = 0x171 */
> +#define DA9150_CHG_IHOT_SHIFT			0
> +#define DA9150_CHG_IHOT_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_L = 0x172 */
> +#define DA9150_CHG_IBAT_TRED_SHIFT		0
> +#define DA9150_CHG_IBAT_TRED_MASK		(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_M = 0x173 */
> +#define DA9150_CHG_VFLOAT_SHIFT			0
> +#define DA9150_CHG_VFLOAT_MASK			(0x0f << 0)
> +#define DA9150_CHG_LPM_SHIFT			5
> +#define DA9150_CHG_LPM_MASK			(0x01 << 5)
> +#define DA9150_CHG_NBLO_SHIFT			6
> +#define DA9150_CHG_NBLO_MASK			(0x01 << 6)
> +#define DA9150_EBS_EN_SHIFT			7
> +#define DA9150_EBS_EN_MASK			(0x01 << 7)
> +
> +/* DA9150_PPR_THYST_A = 0x174 */
> +#define DA9150_TBAT_T1_SHIFT			0
> +#define DA9150_TBAT_T1_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_B = 0x175 */
> +#define DA9150_TBAT_T2_SHIFT			0
> +#define DA9150_TBAT_T2_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_C = 0x176 */
> +#define DA9150_TBAT_T3_SHIFT			0
> +#define DA9150_TBAT_T3_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_D = 0x177 */
> +#define DA9150_TBAT_T4_SHIFT			0
> +#define DA9150_TBAT_T4_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_E = 0x178 */
> +#define DA9150_TBAT_T5_SHIFT			0
> +#define DA9150_TBAT_T5_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_F = 0x179 */
> +#define DA9150_TBAT_H1_SHIFT			0
> +#define DA9150_TBAT_H1_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_G = 0x17A */
> +#define DA9150_TBAT_H5_SHIFT			0
> +#define DA9150_TBAT_H5_MASK			(0xff << 0)
> +
> +/* DA9150_PAGE_CON_3 = 0x180 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_PAGE_CON_4 = 0x200 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_PAGE_CON_5 = 0x280 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_PAGE_CON_6 = 0x300 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			(0x01 << 6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			(0x01 << 7)
> +
> +/* DA9150_COREBTLD_STAT_A = 0x302 */
> +#define DA9150_BOOTLD_STAT_SHIFT		0
> +#define DA9150_BOOTLD_STAT_MASK			(0x03 << 0)
> +#define DA9150_CORE_LOCKUP_SHIFT		2
> +#define DA9150_CORE_LOCKUP_MASK			(0x01 << 2)
> +
> +/* DA9150_COREBTLD_CTRL_A = 0x303 */
> +#define DA9150_CORE_RESET_SHIFT			0
> +#define DA9150_CORE_RESET_MASK			(0x01 << 0)
> +#define DA9150_CORE_STOP_SHIFT			1
> +#define DA9150_CORE_STOP_MASK			(0x01 << 1)
> +
> +/* DA9150_CORE_CONFIG_A = 0x304 */
> +#define DA9150_CORE_MEMMUX_SHIFT		0
> +#define DA9150_CORE_MEMMUX_MASK			(0x03 << 0)
> +#define DA9150_WDT_AUTO_START_SHIFT		2
> +#define DA9150_WDT_AUTO_START_MASK		(0x01 << 2)
> +#define DA9150_WDT_AUTO_LOCK_SHIFT		3
> +#define DA9150_WDT_AUTO_LOCK_MASK		(0x01 << 3)
> +#define DA9150_WDT_HLT_NO_CLK_SHIFT		4
> +#define DA9150_WDT_HLT_NO_CLK_MASK		(0x01 << 4)
> +
> +/* DA9150_CORE_CONFIG_C = 0x305 */
> +#define DA9150_CORE_SW_SIZE_SHIFT		0
> +#define DA9150_CORE_SW_SIZE_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CONFIG_B = 0x306 */
> +#define DA9150_BOOTLD_EN_SHIFT			0
> +#define DA9150_BOOTLD_EN_MASK			(0x01 << 0)
> +#define DA9150_CORE_EN_SHIFT			2
> +#define DA9150_CORE_EN_MASK			(0x01 << 2)
> +#define DA9150_CORE_SW_SRC_SHIFT		3
> +#define DA9150_CORE_SW_SRC_MASK			(0x07 << 3)
> +#define DA9150_DEEP_SLEEP_EN_SHIFT		7
> +#define DA9150_DEEP_SLEEP_EN_MASK		(0x01 << 7)
> +
> +/* DA9150_CORE_CFG_DATA_A = 0x307 */
> +#define DA9150_CORE_CFG_DT_A_SHIFT		0
> +#define DA9150_CORE_CFG_DT_A_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CFG_DATA_B = 0x308 */
> +#define DA9150_CORE_CFG_DT_B_SHIFT		0
> +#define DA9150_CORE_CFG_DT_B_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CMD_A = 0x309 */
> +#define DA9150_CORE_CMD_SHIFT			0
> +#define DA9150_CORE_CMD_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_A = 0x30A */
> +#define DA9150_CORE_DATA_0_SHIFT		0
> +#define DA9150_CORE_DATA_0_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_B = 0x30B */
> +#define DA9150_CORE_DATA_1_SHIFT		0
> +#define DA9150_CORE_DATA_1_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_C = 0x30C */
> +#define DA9150_CORE_DATA_2_SHIFT		0
> +#define DA9150_CORE_DATA_2_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_D = 0x30D */
> +#define DA9150_CORE_DATA_3_SHIFT		0
> +#define DA9150_CORE_DATA_3_MASK			(0xff << 0)
> +
> +/* DA9150_CORE2WIRE_STAT_A = 0x310 */
> +#define DA9150_FW_FWDL_ERR_SHIFT		7
> +#define DA9150_FW_FWDL_ERR_MASK			(0x01 << 7)
> +
> +/* DA9150_CORE2WIRE_CTRL_A = 0x311 */
> +#define DA9150_FW_FWDL_EN_SHIFT			0
> +#define DA9150_FW_FWDL_EN_MASK			(0x01 << 0)
> +#define DA9150_FG_QIF_EN_SHIFT			1
> +#define DA9150_FG_QIF_EN_MASK			(0x01 << 1)
> +#define DA9150_CORE_BASE_ADDR_SHIFT		4
> +#define DA9150_CORE_BASE_ADDR_MASK		(0x0f << 4)
> +
> +/* DA9150_FW_CTRL_A = 0x312 */
> +#define DA9150_FW_SEAL_SHIFT			0
> +#define DA9150_FW_SEAL_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_C = 0x313 */
> +#define DA9150_FW_FWDL_CRC_SHIFT		0
> +#define DA9150_FW_FWDL_CRC_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_D = 0x314 */
> +#define DA9150_FW_FWDL_BASE_SHIFT		0
> +#define DA9150_FW_FWDL_BASE_MASK		(0x0f << 0)
> +
> +/* DA9150_FG_CTRL_A = 0x315 */
> +#define DA9150_FG_QIF_CODE_SHIFT		0
> +#define DA9150_FG_QIF_CODE_MASK			(0xff << 0)
> +
> +/* DA9150_FG_CTRL_B = 0x316 */
> +#define DA9150_FG_QIF_VALUE_SHIFT		0
> +#define DA9150_FG_QIF_VALUE_MASK		(0xff << 0)
> +
> +/* DA9150_FW_CTRL_E = 0x317 */
> +#define DA9150_FW_FWDL_SEG_SHIFT		0
> +#define DA9150_FW_FWDL_SEG_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_B = 0x318 */
> +#define DA9150_FW_FWDL_VALUE_SHIFT		0
> +#define DA9150_FW_FWDL_VALUE_MASK		(0xff << 0)
> +
> +/* DA9150_GPADC_CMAN = 0x320 */
> +#define DA9150_GPADC_CEN_SHIFT			0
> +#define DA9150_GPADC_CEN_MASK			(0x01 << 0)
> +#define DA9150_GPADC_CMUX_SHIFT			1
> +#define DA9150_GPADC_CMUX_MASK			(0x1f << 1)
> +
> +/* DA9150_GPADC_CRES_A = 0x322 */
> +#define DA9150_GPADC_CRES_H_SHIFT		0
> +#define DA9150_GPADC_CRES_H_MASK		(0xff << 0)
> +
> +/* DA9150_GPADC_CRES_B = 0x323 */
> +#define DA9150_GPADC_CRUN_SHIFT			0
> +#define DA9150_GPADC_CRUN_MASK			(0x01 << 0)
> +#define DA9150_GPADC_CRES_L_SHIFT		6
> +#define DA9150_GPADC_CRES_L_MASK		(0x03 << 6)
> +
> +/* DA9150_CC_CFG_A = 0x328 */
> +#define DA9150_CC_EN_SHIFT			0
> +#define DA9150_CC_EN_MASK			(0x01 << 0)
> +#define DA9150_CC_TIMEBASE_SHIFT		1
> +#define DA9150_CC_TIMEBASE_MASK			(0x03 << 1)
> +#define DA9150_CC_CFG_SHIFT			5
> +#define DA9150_CC_CFG_MASK			(0x03 << 5)
> +#define DA9150_CC_ENDLESS_MODE_SHIFT		7
> +#define DA9150_CC_ENDLESS_MODE_MASK		(0x01 << 7)
> +
> +/* DA9150_CC_CFG_B = 0x329 */
> +#define DA9150_CC_OPT_SHIFT			0
> +#define DA9150_CC_OPT_MASK			(0x03 << 0)
> +#define DA9150_CC_PREAMP_SHIFT			2
> +#define DA9150_CC_PREAMP_MASK			(0x03 << 2)
> +
> +/* DA9150_CC_ICHG_RES_A = 0x32A */
> +#define DA9150_CC_ICHG_RES_H_SHIFT		0
> +#define DA9150_CC_ICHG_RES_H_MASK		(0xff << 0)
> +
> +/* DA9150_CC_ICHG_RES_B = 0x32B */
> +#define DA9150_CC_ICHG_RES_L_SHIFT		3
> +#define DA9150_CC_ICHG_RES_L_MASK		(0x1f << 3)
> +
> +/* DA9150_CC_IAVG_RES_A = 0x32C */
> +#define DA9150_CC_IAVG_RES_H_SHIFT		0
> +#define DA9150_CC_IAVG_RES_H_MASK		(0xff << 0)
> +
> +/* DA9150_CC_IAVG_RES_B = 0x32D */
> +#define DA9150_CC_IAVG_RES_L_SHIFT		0
> +#define DA9150_CC_IAVG_RES_L_MASK		(0xff << 0)
> +
> +/* DA9150_TAUX_CTRL_A = 0x330 */
> +#define DA9150_TAUX_EN_SHIFT			0
> +#define DA9150_TAUX_EN_MASK			(0x01 << 0)
> +#define DA9150_TAUX_MOD_SHIFT			1
> +#define DA9150_TAUX_MOD_MASK			(0x01 << 1)
> +#define DA9150_TAUX_UPDATE_SHIFT		2
> +#define DA9150_TAUX_UPDATE_MASK			(0x01 << 2)
> +
> +/* DA9150_TAUX_RELOAD_H = 0x332 */
> +#define DA9150_TAUX_RLD_H_SHIFT			0
> +#define DA9150_TAUX_RLD_H_MASK			(0xff << 0)
> +
> +/* DA9150_TAUX_RELOAD_L = 0x333 */
> +#define DA9150_TAUX_RLD_L_SHIFT			3
> +#define DA9150_TAUX_RLD_L_MASK			(0x1f << 3)
> +
> +/* DA9150_TAUX_VALUE_H = 0x334 */
> +#define DA9150_TAUX_VAL_H_SHIFT			0
> +#define DA9150_TAUX_VAL_H_MASK			(0xff << 0)
> +
> +/* DA9150_TAUX_VALUE_L = 0x335 */
> +#define DA9150_TAUX_VAL_L_SHIFT			3
> +#define DA9150_TAUX_VAL_L_MASK			(0x1f << 3)
> +
> +/* DA9150_AUX_DATA_0 = 0x338 */
> +#define DA9150_AUX_DAT_0_SHIFT			0
> +#define DA9150_AUX_DAT_0_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_1 = 0x339 */
> +#define DA9150_AUX_DAT_1_SHIFT			0
> +#define DA9150_AUX_DAT_1_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_2 = 0x33A */
> +#define DA9150_AUX_DAT_2_SHIFT			0
> +#define DA9150_AUX_DAT_2_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_3 = 0x33B */
> +#define DA9150_AUX_DAT_3_SHIFT			0
> +#define DA9150_AUX_DAT_3_MASK			(0xff << 0)
> +
> +/* DA9150_BIF_CTRL = 0x340 */
> +#define DA9150_BIF_ISRC_EN_SHIFT		0
> +#define DA9150_BIF_ISRC_EN_MASK			(0x01 << 0)
> +
> +/* DA9150_TBAT_CTRL_A = 0x342 */
> +#define DA9150_TBAT_EN_SHIFT			0
> +#define DA9150_TBAT_EN_MASK			(0x01 << 0)
> +#define DA9150_TBAT_SW1_SHIFT			1
> +#define DA9150_TBAT_SW1_MASK			(0x01 << 1)
> +#define DA9150_TBAT_SW2_SHIFT			2
> +#define DA9150_TBAT_SW2_MASK			(0x01 << 2)
> +
> +/* DA9150_TBAT_CTRL_B = 0x343 */
> +#define DA9150_TBAT_SW_FRC_SHIFT		0
> +#define DA9150_TBAT_SW_FRC_MASK			(0x01 << 0)
> +#define DA9150_TBAT_STAT_SW1_SHIFT		1
> +#define DA9150_TBAT_STAT_SW1_MASK		(0x01 << 1)
> +#define DA9150_TBAT_STAT_SW2_SHIFT		2
> +#define DA9150_TBAT_STAT_SW2_MASK		(0x01 << 2)
> +#define DA9150_TBAT_HIGH_CURR_SHIFT		3
> +#define DA9150_TBAT_HIGH_CURR_MASK		(0x01 << 3)
> +
> +/* DA9150_TBAT_RES_A = 0x344 */
> +#define DA9150_TBAT_RES_H_SHIFT			0
> +#define DA9150_TBAT_RES_H_MASK			(0xff << 0)
> +
> +/* DA9150_TBAT_RES_B = 0x345 */
> +#define DA9150_TBAT_RES_DIS_SHIFT		0
> +#define DA9150_TBAT_RES_DIS_MASK		(0x01 << 0)
> +#define DA9150_TBAT_RES_L_SHIFT			6
> +#define DA9150_TBAT_RES_L_MASK			(0x03 << 6)
> +
> +#endif /* _DA9150_REGISTERS_H */
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

