Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbaFQPEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:04:47 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:57276 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbaFQPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:04:46 -0400
Date: Tue, 17 Jun 2014 16:04:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, broonie@kernel.org, sameo@linux.intel.com,
        mika.westerberg@linux.intel.com, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com
Subject: Re: [PATCH v5 2/3] mfd: intel_soc_pmic: Crystal Cove support
Message-ID: <20140617150439.GJ29841@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014, Zhu, Lejun wrote:

> This patch provides chip-specific support for Crystal Cove. Crystal
> Cove is the PMIC in Baytrail-T platform.
> 
> Also adds Intel SoC PMIC support to the build files.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Add regmap_config for Crystal Cove.
> v3:
> - Convert IRQ config to regmap_irq_chip.
> v4:
> - Cleanup include files.
> - Remove useless init() function.
> - Remove useless .label and .init from struct intel_soc_pmic_config.
> - Fix various coding style issues.
> v5:
> - Use CRYSTAL_COVE_IRQ_ prefix for IRQ bits definition.
> - Merge build files patch to here.
> ---
>  drivers/mfd/Kconfig              |  12 +++
>  drivers/mfd/Makefile             |   3 +
>  drivers/mfd/intel_soc_pmic_crc.c | 158 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 173 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3383412..d987b71 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -241,6 +241,18 @@ config LPC_SCH
>  	  LPC bridge function of the Intel SCH provides support for
>  	  System Management Bus and General Purpose I/O.
>  
> +config INTEL_SOC_PMIC
> +	bool "Support for Intel Atom SoC PMIC"
> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	help
> +	  Select this option to enable support for the PMIC device
> +	  on some Intel SoC systems. The PMIC provides ADC, GPIO,
> +	  thermal, charger and related power management functions
> +	  on these systems.
> +
>  config MFD_INTEL_MSIC
>  	bool "Intel MSIC"
>  	depends on INTEL_SCU_IPC
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 2851275..36dda4c 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -166,3 +166,6 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
>  obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
> +
> +intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
> +obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
> new file mode 100644
> index 0000000..7107cab
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_crc.c
> @@ -0,0 +1,158 @@
> +/*
> + * intel_soc_pmic_crc.c - Device access for Crystal Cove PMIC
> + *
> + * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
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
> + * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
> + */
> +
> +#include <linux/mfd/core.h>
> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include "intel_soc_pmic_core.h"
> +
> +#define CRYSTAL_COVE_MAX_REGISTER	0xC6
> +
> +#define CRYSTAL_COVE_REG_IRQLVL1	0x02
> +#define CRYSTAL_COVE_REG_MIRQLVL1	0x0E
> +
> +#define CRYSTAL_COVE_IRQ_PWRSRC		0
> +#define CRYSTAL_COVE_IRQ_THRM		1
> +#define CRYSTAL_COVE_IRQ_BCU		2
> +#define CRYSTAL_COVE_IRQ_ADC		3
> +#define CRYSTAL_COVE_IRQ_CHGR		4
> +#define CRYSTAL_COVE_IRQ_GPIO		5
> +#define CRYSTAL_COVE_IRQ_VHDMIOCP	6
> +
> +static struct resource gpio_resources[] = {
> +	{
> +		.name	= "GPIO",
> +		.start	= CRYSTAL_COVE_IRQ_GPIO,
> +		.end	= CRYSTAL_COVE_IRQ_GPIO,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource pwrsrc_resources[] = {
> +	{
> +		.name  = "PWRSRC",
> +		.start = CRYSTAL_COVE_IRQ_PWRSRC,
> +		.end   = CRYSTAL_COVE_IRQ_PWRSRC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource adc_resources[] = {
> +	{
> +		.name  = "ADC",
> +		.start = CRYSTAL_COVE_IRQ_ADC,
> +		.end   = CRYSTAL_COVE_IRQ_ADC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource thermal_resources[] = {
> +	{
> +		.name  = "THERMAL",
> +		.start = CRYSTAL_COVE_IRQ_THRM,
> +		.end   = CRYSTAL_COVE_IRQ_THRM,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource bcu_resources[] = {
> +	{
> +		.name  = "BCU",
> +		.start = CRYSTAL_COVE_IRQ_BCU,
> +		.end   = CRYSTAL_COVE_IRQ_BCU,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell crystal_cove_dev[] = {
> +	{
> +		.name = "crystal_cove_pwrsrc",
> +		.num_resources = ARRAY_SIZE(pwrsrc_resources),
> +		.resources = pwrsrc_resources,
> +	},
> +	{
> +		.name = "crystal_cove_adc",
> +		.num_resources = ARRAY_SIZE(adc_resources),
> +		.resources = adc_resources,
> +	},
> +	{
> +		.name = "crystal_cove_thermal",
> +		.num_resources = ARRAY_SIZE(thermal_resources),
> +		.resources = thermal_resources,
> +	},
> +	{
> +		.name = "crystal_cove_bcu",
> +		.num_resources = ARRAY_SIZE(bcu_resources),
> +		.resources = bcu_resources,
> +	},
> +	{
> +		.name = "crystal_cove_gpio",
> +		.num_resources = ARRAY_SIZE(gpio_resources),
> +		.resources = gpio_resources,
> +	},
> +};
> +
> +static struct regmap_config crystal_cove_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = CRYSTAL_COVE_MAX_REGISTER,
> +	.cache_type = REGCACHE_NONE,
> +};
> +
> +static const struct regmap_irq crystal_cove_irqs[] = {
> +	[CRYSTAL_COVE_IRQ_PWRSRC] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_PWRSRC),
> +	},
> +	[CRYSTAL_COVE_IRQ_THRM] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_THRM),
> +	},
> +	[CRYSTAL_COVE_IRQ_BCU] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_BCU),
> +	},
> +	[CRYSTAL_COVE_IRQ_ADC] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_ADC),
> +	},
> +	[CRYSTAL_COVE_IRQ_CHGR] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_CHGR),
> +	},
> +	[CRYSTAL_COVE_IRQ_GPIO] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_GPIO),
> +	},
> +	[CRYSTAL_COVE_IRQ_VHDMIOCP] = {
> +		.mask = BIT(CRYSTAL_COVE_IRQ_VHDMIOCP),
> +	},
> +};
> +
> +static struct regmap_irq_chip crystal_cove_irq_chip = {
> +	.name = "Crystal Cove",
> +	.irqs = crystal_cove_irqs,
> +	.num_irqs = ARRAY_SIZE(crystal_cove_irqs),
> +	.num_regs = 1,
> +	.status_base = CRYSTAL_COVE_REG_IRQLVL1,
> +	.mask_base = CRYSTAL_COVE_REG_MIRQLVL1,
> +};
> +
> +struct intel_soc_pmic_config intel_soc_pmic_config_crc = {
> +	.irq_flags = IRQF_TRIGGER_RISING,
> +	.cell_dev = crystal_cove_dev,
> +	.n_cell_devs = ARRAY_SIZE(crystal_cove_dev),
> +	.regmap_config = &crystal_cove_regmap_config,
> +	.irq_chip = &crystal_cove_irq_chip,
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
