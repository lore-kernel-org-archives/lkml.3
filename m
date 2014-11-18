Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaKRQ0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:26:06 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43418 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbaKRQZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:25:46 -0500
Date: Tue, 18 Nov 2014 16:25:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com, lee.jone@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH v3 1/5] mfd: rt5033: Add Richtek RT5033 driver core.
Message-ID: <20141118162537.GE13959@x1>
References: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
 <1415794082-30277-2-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415794082-30277-2-git-send-email-beomho.seo@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Beomho Seo wrote:

> This patch adds a new driver for Richtek RT5033 driver.
> RT5033 is a Multifunction device which includes battery charger, fuel gauge,
> flash LED current source, LDO and synchronous Buck converter. It is interfaced
> to host controller using I2C interface.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jone@linaro.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes in v3
> - Correct sentence errors.
> - Add author information the top of each drivers.
> - Remove unnecessary pre-initialise, struct member(rt5033->i2c) and blink.
> - Change some return check.
> - Use bool and of_match_ptr().
> 
> Changes in v2
> - Remove volatile_reg callback. Because this driver not in use regmap cache.
> - Revmoe unnecessary subnode of_compatible.
> - Add define for set_high impedance mode of charger.
> ---
> 
>  drivers/mfd/Kconfig                |   12 ++
>  drivers/mfd/Makefile               |    1 +
>  drivers/mfd/rt5033.c               |  141 +++++++++++++++++++
>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rt5033.h         |   62 +++++++++
>  5 files changed, 476 insertions(+)
>  create mode 100644 drivers/mfd/rt5033.c
>  create mode 100644 include/linux/mfd/rt5033-private.h
>  create mode 100644 include/linux/mfd/rt5033.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 72d3808..55b6551 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -618,6 +618,18 @@ config MFD_RTSX_PCI
>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>  	  Secure Digital and MultiMediaCard.
>  
> +config MFD_RT5033
> +	bool "Richtek RT5033 Power Management IC"
> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  This driver provides for the Richtek RT5033 Power Management IC,
> +	  which includes the I2C driver and the Core APIs. This driver provides
> +	  common support for accessing the device. The device supports multiple
> +	  sub-devices like charger, fuel gauge, flash LED, current source,
> +	  LDO and Buck.

What's stopping this from being built as a module?

>  config MFD_RTSX_USB
>  	tristate "Realtek USB card reader"
>  	depends on USB
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 53467e2..4059c24 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -176,6 +176,7 @@ obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>  obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
>  obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
>  obj-$(CONFIG_MFD_DLN2)		+= dln2.o
> +obj-$(CONFIG_MFD_RT5033)	+= rt5033.o
>  
>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
> new file mode 100644
> index 0000000..e29c6d9
> --- /dev/null
> +++ b/drivers/mfd/rt5033.c
> @@ -0,0 +1,141 @@
> +/*
> + * MFD core driver for the Richtek RT5033.
> + *
> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>

Why have you included this if you can't build as a module?

> +#include <linux/interrupt.h>
> +#include <linux/of_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/rt5033.h>
> +#include <linux/mfd/rt5033-private.h>
> +
> +static const struct regmap_irq rt5033_irqs[] = {
> +	{ .mask = RT5033_PMIC_IRQ_BUCKOCP, },
> +	{ .mask = RT5033_PMIC_IRQ_BUCKLV, },
> +	{ .mask = RT5033_PMIC_IRQ_SAFELDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_LDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_OT, },
> +	{ .mask = RT5033_PMIC_IRQ_VDDA_UV, },
> +};
> +
> +static const struct regmap_irq_chip rt5033_irq_chip = {
> +	.name		= "rt5033",
> +	.status_base	= RT5033_REG_PMIC_IRQ_STAT,
> +	.mask_base	= RT5033_REG_PMIC_IRQ_CTRL,
> +	.mask_invert	= true,
> +	.num_regs	= 1,
> +	.irqs		= rt5033_irqs,
> +	.num_irqs	= ARRAY_SIZE(rt5033_irqs),
> +};
> +
> +static const struct mfd_cell rt5033_devs[] = {
> +	{
> +		.name = "rt5033-regulator",
> +	}, {

Place this entry on one line.  Like you did in rt5033_irqs.

> +		.name = "rt5033-charger",
> +		.of_compatible = "richtek,rt5033-charger",
> +	}, {
> +		.name = "rt5033-battery",
> +		.of_compatible = "richtek,rt5033-battery",
> +	},
> +};
> +
> +static const struct of_device_id rt5033_dt_match[] = {
> +	{ .compatible = "richtek,rt5033", },
> +	{ }
> +};
> +
> +static const struct regmap_config rt5033_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.max_register	= RT5033_REG_END,
> +};
> +
> +static int rt5033_i2c_probe(struct i2c_client *i2c,
> +				const struct i2c_device_id *id)
> +{
> +	struct rt5033_dev *rt5033;
> +	unsigned int data;
> +	int ret;
> +
> +	rt5033 = devm_kzalloc(&i2c->dev, sizeof(*rt5033), GFP_KERNEL);
> +	if (!rt5033)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, rt5033);
> +	rt5033->dev = &i2c->dev;
> +	rt5033->irq = i2c->irq;
> +	rt5033->wakeup = true;
> +
> +	rt5033->regmap = devm_regmap_init_i2c(i2c, &rt5033_regmap_config);
> +	if (IS_ERR(rt5033->regmap)) {
> +		dev_err(&i2c->dev, "Failed to allocate register map.\n");
> +		return PTR_ERR(rt5033->regmap);
> +	}
> +
> +	ret = regmap_read(rt5033->regmap, RT5033_REG_DEVICE_ID, &data);
> +	if (ret) {
> +		dev_err(&i2c->dev, "Device not found\n");
> +		return -ENODEV;
> +	}
> +	dev_info(&i2c->dev, "Device found Device ID: %04x\n", data);
> +
> +	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			0, &rt5033_irq_chip, &rt5033->irq_data);
> +	if (ret) {
> +		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
> +							rt5033->irq, ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(rt5033->dev, -1, rt5033_devs,
> +			ARRAY_SIZE(rt5033_devs), NULL, 0,
> +			regmap_irq_get_domain(rt5033->irq_data));
> +	if (ret < 0) {
> +		dev_err(&i2c->dev, "Failed to add RT5033 child device.\n");

s/device/devices/

> +		return ret;
> +	}
> +
> +	device_init_wakeup(rt5033->dev, rt5033->wakeup);
> +
> +	return 0;
> +}
> +
> +static int rt5033_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct rt5033_dev *rt5033 = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(rt5033->dev);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id rt5033_i2c_id[] = {
> +	{ "rt5033", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, rt5033_i2c_id);

Why do you need to export this if you're not building as a module?

> +static struct i2c_driver rt5033_driver = {
> +	.driver = {
> +		.name = "rt5033",
> +		.of_match_table = of_match_ptr(rt5033_dt_match),
> +	},
> +	.probe = rt5033_i2c_probe,
> +	.remove = rt5033_i2c_remove,
> +	.id_table = rt5033_i2c_id,
> +};
> +module_i2c_driver(rt5033_driver);
>
> +MODULE_DESCRIPTION("Richtek RT5033 multi-function core driver");
> +MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
> +MODULE_LICENSE("GPL");

More module stuff?

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
