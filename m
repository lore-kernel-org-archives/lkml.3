Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaIAIZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:25:37 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34400 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaIAIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:25:34 -0400
Date: Mon, 1 Sep 2014 09:25:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Subject: Re: [PATCH v2 1/4] mfd: Add Ricoh RN5T618 PMIC core driver
Message-ID: <20140901082527.GD6226@lee--X1>
References: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
 <1409403026-28818-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409403026-28818-2-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014, Beniamino Galvani wrote:

> Ricoh RN5T618 is a power management IC which integrates 3 step-down
> DCDC converters, 7 low-dropout regulators, a Li-ion battery charger,
> fuel gauge, ADC, GPIOs and a watchdog timer.
> 
> This commit adds a MFD core driver to support the I2C communication
> with the device.
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/mfd/Kconfig         |   11 +++
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/rn5t618.c       |  134 +++++++++++++++++++++++++
>  include/linux/mfd/rn5t618.h |  228 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 374 insertions(+)
>  create mode 100644 drivers/mfd/rn5t618.c
>  create mode 100644 include/linux/mfd/rn5t618.h

Applied thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 8d5fad2..843da5d 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -582,6 +582,17 @@ config MFD_RC5T583
>  	  Additional drivers must be enabled in order to use the
>  	  different functionality of the device.
>  
> +config MFD_RN5T618
> +	tristate "Ricoh RN5T5618 PMIC"
> +	depends on I2C
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  Say yes here to add support for the Ricoh RN5T618 PMIC. This
> +	  driver provides common support for accessing the device,
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the device.
> +
>  config MFD_SEC_CORE
>  	bool "SAMSUNG Electronics PMIC Series Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..b945899 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -160,6 +160,7 @@ obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
>  obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
>  obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
>  obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
> +obj-$(CONFIG_MFD_RN5T618)	+= rn5t618.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
>  obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
> diff --git a/drivers/mfd/rn5t618.c b/drivers/mfd/rn5t618.c
> new file mode 100644
> index 0000000..6668571
> --- /dev/null
> +++ b/drivers/mfd/rn5t618.c
> @@ -0,0 +1,134 @@
> +/*
> + * MFD core driver for Ricoh RN5T618 PMIC
> + *
> + * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/rn5t618.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +
> +static const struct mfd_cell rn5t618_cells[] = {
> +	{ .name = "rn5t618-regulator" },
> +	{ .name = "rn5t618-wdt" },
> +};
> +
> +static bool rn5t618_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case RN5T618_WATCHDOGCNT:
> +	case RN5T618_DCIRQ:
> +	case RN5T618_ILIMDATAH ... RN5T618_AIN0DATAL:
> +	case RN5T618_IR_ADC1 ... RN5T618_IR_ADC3:
> +	case RN5T618_IR_GPR:
> +	case RN5T618_IR_GPF:
> +	case RN5T618_MON_IOIN:
> +	case RN5T618_INTMON:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static const struct regmap_config rn5t618_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.volatile_reg	= rn5t618_volatile_reg,
> +	.max_register	= RN5T618_MAX_REG,
> +	.cache_type	= REGCACHE_RBTREE,
> +};
> +
> +static struct rn5t618 *rn5t618_pm_power_off;
> +
> +static void rn5t618_power_off(void)
> +{
> +	/* disable automatic repower-on */
> +	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_REPCNT,
> +			   RN5T618_REPCNT_REPWRON, 0);
> +	/* start power-off sequence */
> +	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_SLPCNT,
> +			   RN5T618_SLPCNT_SWPWROFF, RN5T618_SLPCNT_SWPWROFF);
> +}
> +
> +static int rn5t618_i2c_probe(struct i2c_client *i2c,
> +			     const struct i2c_device_id *id)
> +{
> +	struct rn5t618 *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&i2c->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, priv);
> +
> +	priv->regmap = devm_regmap_init_i2c(i2c, &rn5t618_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		ret = PTR_ERR(priv->regmap);
> +		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(&i2c->dev, -1, rn5t618_cells,
> +			      ARRAY_SIZE(rn5t618_cells), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(&i2c->dev, "failed to add sub-devices: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!pm_power_off) {
> +		rn5t618_pm_power_off = priv;
> +		pm_power_off = rn5t618_power_off;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rn5t618_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct rn5t618 *priv = i2c_get_clientdata(i2c);
> +
> +	if (priv == rn5t618_pm_power_off) {
> +		rn5t618_pm_power_off = NULL;
> +		pm_power_off = NULL;
> +	}
> +
> +	mfd_remove_devices(&i2c->dev);
> +	return 0;
> +}
> +
> +static const struct of_device_id rn5t618_of_match[] = {
> +	{ .compatible = "ricoh,rn5t618" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, rn5t618_of_match);
> +
> +static const struct i2c_device_id rn5t618_i2c_id[] = {
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, rn5t618_i2c_id);
> +
> +static struct i2c_driver rn5t618_i2c_driver = {
> +	.driver = {
> +		.name = "rn5t618",
> +		.of_match_table = of_match_ptr(rn5t618_of_match),
> +	},
> +	.probe = rn5t618_i2c_probe,
> +	.remove = rn5t618_i2c_remove,
> +	.id_table = rn5t618_i2c_id,
> +};
> +
> +module_i2c_driver(rn5t618_i2c_driver);
> +
> +MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
> +MODULE_DESCRIPTION("Ricoh RN5T618 MFD driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/rn5t618.h b/include/linux/mfd/rn5t618.h
> new file mode 100644
> index 0000000..c72d534
> --- /dev/null
> +++ b/include/linux/mfd/rn5t618.h
> @@ -0,0 +1,228 @@
> +/*
> + * MFD core driver for Ricoh RN5T618 PMIC
> + *
> + * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __LINUX_MFD_RN5T618_H
> +#define __LINUX_MFD_RN5T618_H
> +
> +#include <linux/regmap.h>
> +
> +#define RN5T618_LSIVER			0x00
> +#define RN5T618_OTPVER			0x01
> +#define RN5T618_IODAC			0x02
> +#define RN5T618_VINDAC			0x03
> +#define RN5T618_CPUCNT			0x06
> +#define RN5T618_PSWR			0x07
> +#define RN5T618_PONHIS			0x09
> +#define RN5T618_POFFHIS			0x0a
> +#define RN5T618_WATCHDOG		0x0b
> +#define RN5T618_WATCHDOGCNT		0x0c
> +#define RN5T618_PWRFUNC			0x0d
> +#define RN5T618_SLPCNT			0x0e
> +#define RN5T618_REPCNT			0x0f
> +#define RN5T618_PWRONTIMSET		0x10
> +#define RN5T618_NOETIMSETCNT		0x11
> +#define RN5T618_PWRIREN			0x12
> +#define RN5T618_PWRIRQ			0x13
> +#define RN5T618_PWRMON			0x14
> +#define RN5T618_PWRIRSEL		0x15
> +#define RN5T618_DC1_SLOT		0x16
> +#define RN5T618_DC2_SLOT		0x17
> +#define RN5T618_DC3_SLOT		0x18
> +#define RN5T618_LDO1_SLOT		0x1b
> +#define RN5T618_LDO2_SLOT		0x1c
> +#define RN5T618_LDO3_SLOT		0x1d
> +#define RN5T618_LDO4_SLOT		0x1e
> +#define RN5T618_LDO5_SLOT		0x1f
> +#define RN5T618_PSO0_SLOT		0x25
> +#define RN5T618_PSO1_SLOT		0x26
> +#define RN5T618_PSO2_SLOT		0x27
> +#define RN5T618_PSO3_SLOT		0x28
> +#define RN5T618_LDORTC1_SLOT		0x2a
> +#define RN5T618_DC1CTL			0x2c
> +#define RN5T618_DC1CTL2			0x2d
> +#define RN5T618_DC2CTL			0x2e
> +#define RN5T618_DC2CTL2			0x2f
> +#define RN5T618_DC3CTL			0x30
> +#define RN5T618_DC3CTL2			0x31
> +#define RN5T618_DC1DAC			0x36
> +#define RN5T618_DC2DAC			0x37
> +#define RN5T618_DC3DAC			0x38
> +#define RN5T618_DC1DAC_SLP		0x3b
> +#define RN5T618_DC2DAC_SLP		0x3c
> +#define RN5T618_DC3DAC_SLP		0x3d
> +#define RN5T618_DCIREN			0x40
> +#define RN5T618_DCIRQ			0x41
> +#define RN5T618_DCIRMON			0x42
> +#define RN5T618_LDOEN1			0x44
> +#define RN5T618_LDOEN2			0x45
> +#define RN5T618_LDODIS			0x46
> +#define RN5T618_LDO1DAC			0x4c
> +#define RN5T618_LDO2DAC			0x4d
> +#define RN5T618_LDO3DAC			0x4e
> +#define RN5T618_LDO4DAC			0x4f
> +#define RN5T618_LDO5DAC			0x50
> +#define RN5T618_LDORTCDAC		0x56
> +#define RN5T618_LDORTC2DAC		0x57
> +#define RN5T618_LDO1DAC_SLP		0x58
> +#define RN5T618_LDO2DAC_SLP		0x59
> +#define RN5T618_LDO3DAC_SLP		0x5a
> +#define RN5T618_LDO4DAC_SLP		0x5b
> +#define RN5T618_LDO5DAC_SLP		0x5c
> +#define RN5T618_ADCCNT1			0x64
> +#define RN5T618_ADCCNT2			0x65
> +#define RN5T618_ADCCNT3			0x66
> +#define RN5T618_ILIMDATAH		0x68
> +#define RN5T618_ILIMDATAL		0x69
> +#define RN5T618_VBATDATAH		0x6a
> +#define RN5T618_VBATDATAL		0x6b
> +#define RN5T618_VADPDATAH		0x6c
> +#define RN5T618_VADPDATAL		0x6d
> +#define RN5T618_VUSBDATAH		0x6e
> +#define RN5T618_VUSBDATAL		0x6f
> +#define RN5T618_VSYSDATAH		0x70
> +#define RN5T618_VSYSDATAL		0x71
> +#define RN5T618_VTHMDATAH		0x72
> +#define RN5T618_VTHMDATAL		0x73
> +#define RN5T618_AIN1DATAH		0x74
> +#define RN5T618_AIN1DATAL		0x75
> +#define RN5T618_AIN0DATAH		0x76
> +#define RN5T618_AIN0DATAL		0x77
> +#define RN5T618_ILIMTHL			0x78
> +#define RN5T618_ILIMTHH			0x79
> +#define RN5T618_VBATTHL			0x7a
> +#define RN5T618_VBATTHH			0x7b
> +#define RN5T618_VADPTHL			0x7c
> +#define RN5T618_VADPTHH			0x7d
> +#define RN5T618_VUSBTHL			0x7e
> +#define RN5T618_VUSBTHH			0x7f
> +#define RN5T618_VSYSTHL			0x80
> +#define RN5T618_VSYSTHH			0x81
> +#define RN5T618_VTHMTHL			0x82
> +#define RN5T618_VTHMTHH			0x83
> +#define RN5T618_AIN1THL			0x84
> +#define RN5T618_AIN1THH			0x85
> +#define RN5T618_AIN0THL			0x86
> +#define RN5T618_AIN0THH			0x87
> +#define RN5T618_EN_ADCIR1		0x88
> +#define RN5T618_EN_ADCIR2		0x89
> +#define RN5T618_EN_ADCIR3		0x8a
> +#define RN5T618_IR_ADC1			0x8c
> +#define RN5T618_IR_ADC2			0x8d
> +#define RN5T618_IR_ADC3			0x8e
> +#define RN5T618_IOSEL			0x90
> +#define RN5T618_IOOUT			0x91
> +#define RN5T618_GPEDGE1			0x92
> +#define RN5T618_GPEDGE2			0x93
> +#define RN5T618_EN_GPIR			0x94
> +#define RN5T618_IR_GPR			0x95
> +#define RN5T618_IR_GPF			0x96
> +#define RN5T618_MON_IOIN		0x97
> +#define RN5T618_GPLED_FUNC		0x98
> +#define RN5T618_INTPOL			0x9c
> +#define RN5T618_INTEN			0x9d
> +#define RN5T618_INTMON			0x9e
> +#define RN5T618_PREVINDAC		0xb0
> +#define RN5T618_BATDAC			0xb1
> +#define RN5T618_CHGCTL1			0xb3
> +#define RN5T618_CHGCTL2			0xb4
> +#define RN5T618_VSYSSET			0xb5
> +#define RN5T618_REGISET1		0xb6
> +#define RN5T618_REGISET2		0xb7
> +#define RN5T618_CHGISET			0xb8
> +#define RN5T618_TIMSET			0xb9
> +#define RN5T618_BATSET1			0xba
> +#define RN5T618_BATSET2			0xbb
> +#define RN5T618_DIESET			0xbc
> +#define RN5T618_CHGSTATE		0xbd
> +#define RN5T618_CHGCTRL_IRFMASK		0xbe
> +#define RN5T618_CHGSTAT_IRFMASK1	0xbf
> +#define RN5T618_CHGSTAT_IRFMASK2	0xc0
> +#define RN5T618_CHGERR_IRFMASK		0xc1
> +#define RN5T618_CHGCTRL_IRR		0xc2
> +#define RN5T618_CHGSTAT_IRR1		0xc3
> +#define RN5T618_CHGSTAT_IRR2		0xc4
> +#define RN5T618_CHGERR_IRR		0xc5
> +#define RN5T618_CHGCTRL_MONI		0xc6
> +#define RN5T618_CHGSTAT_MONI1		0xc7
> +#define RN5T618_CHGSTAT_MONI2		0xc8
> +#define RN5T618_CHGERR_MONI		0xc9
> +#define RN5T618_CHGCTRL_DETMOD1		0xca
> +#define RN5T618_CHGCTRL_DETMOD2		0xcb
> +#define RN5T618_CHGSTAT_DETMOD1		0xcc
> +#define RN5T618_CHGSTAT_DETMOD2		0xcd
> +#define RN5T618_CHGSTAT_DETMOD3		0xce
> +#define RN5T618_CHGERR_DETMOD1		0xcf
> +#define RN5T618_CHGERR_DETMOD2		0xd0
> +#define RN5T618_CHGOSCCTL		0xd4
> +#define RN5T618_CHGOSCSCORESET1		0xd5
> +#define RN5T618_CHGOSCSCORESET2		0xd6
> +#define RN5T618_CHGOSCSCORESET3		0xd7
> +#define RN5T618_CHGOSCFREQSET1		0xd8
> +#define RN5T618_CHGOSCFREQSET2		0xd9
> +#define RN5T618_CONTROL			0xe0
> +#define RN5T618_SOC			0xe1
> +#define RN5T618_RE_CAP_H		0xe2
> +#define RN5T618_RE_CAP_L		0xe3
> +#define RN5T618_FA_CAP_H		0xe4
> +#define RN5T618_FA_CAP_L		0xe5
> +#define RN5T618_AGE			0xe6
> +#define RN5T618_TT_EMPTY_H		0xe7
> +#define RN5T618_TT_EMPTY_L		0xe8
> +#define RN5T618_TT_FULL_H		0xe9
> +#define RN5T618_TT_FULL_L		0xea
> +#define RN5T618_VOLTAGE_1		0xeb
> +#define RN5T618_VOLTAGE_0		0xec
> +#define RN5T618_TEMP_1			0xed
> +#define RN5T618_TEMP_0			0xee
> +#define RN5T618_CC_CTRL			0xef
> +#define RN5T618_CC_COUNT2		0xf0
> +#define RN5T618_CC_COUNT1		0xf1
> +#define RN5T618_CC_COUNT0		0xf2
> +#define RN5T618_CC_SUMREG3		0xf3
> +#define RN5T618_CC_SUMREG2		0xf4
> +#define RN5T618_CC_SUMREG1		0xf5
> +#define RN5T618_CC_SUMREG0		0xf6
> +#define RN5T618_CC_OFFREG1		0xf7
> +#define RN5T618_CC_OFFREG0		0xf8
> +#define RN5T618_CC_GAINREG1		0xf9
> +#define RN5T618_CC_GAINREG0		0xfa
> +#define RN5T618_CC_AVEREG1		0xfb
> +#define RN5T618_CC_AVEREG0		0xfc
> +#define RN5T618_MAX_REG			0xfc
> +
> +#define RN5T618_REPCNT_REPWRON		BIT(0)
> +#define RN5T618_SLPCNT_SWPWROFF		BIT(0)
> +#define RN5T618_WATCHDOG_WDOGEN		BIT(2)
> +#define RN5T618_WATCHDOG_WDOGTIM_M	(BIT(0) | BIT(1))
> +#define RN5T618_WATCHDOG_WDOGTIM_S	0
> +#define RN5T618_PWRIRQ_IR_WDOG		BIT(6)
> +
> +enum {
> +	RN5T618_DCDC1,
> +	RN5T618_DCDC2,
> +	RN5T618_DCDC3,
> +	RN5T618_LDO1,
> +	RN5T618_LDO2,
> +	RN5T618_LDO3,
> +	RN5T618_LDO4,
> +	RN5T618_LDO5,
> +	RN5T618_LDORTC1,
> +	RN5T618_LDORTC2,
> +	RN5T618_REG_NUM,
> +};
> +
> +struct rn5t618 {
> +	struct regmap *regmap;
> +};
> +
> +#endif /* __LINUX_MFD_RN5T618_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
