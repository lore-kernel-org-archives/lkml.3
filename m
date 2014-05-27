Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaE0Qro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:47:44 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60975 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaE0Qri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:47:38 -0400
Date: Tue, 27 May 2014 17:47:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3 3/4] mfd: intel_soc_pmic: Crystal Cove support
Message-ID: <20140527164731.GD4227@lee--X1>
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401163576-14872-4-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401163576-14872-4-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Zhu, Lejun wrote:

> Crystal Cove is the PMIC in Baytrail-T platform. This patch provides chip-specific support for Crystal Cove.
> 
> v2:
> - Add regmap_config for Crystal Cove.
> v3:
> - Convert IRQ config to regmap_irq_chip.

Same comments about the commit log as before.

> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/mfd/intel_soc_pmic_crc.c | 175 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 175 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
> 
> diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
> new file mode 100644
> index 0000000..341ab02
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_crc.c
> @@ -0,0 +1,175 @@
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
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/core.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/acpi.h>
> +#include <linux/version.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include "intel_soc_pmic_core.h"

Please review these.

> +#define	CHIP_NAME			"Crystal Cove"

Don't do this.  Just use the name in the correct places.

> +#define CRYSTAL_COVE_MAX_REGISTER	0xC6
> +
> +#define CHIPID		0x00
> +#define CHIPVER		0x01
> +#define IRQLVL1		0x02
> +#define MIRQLVL1	0x0E
> +
> +enum {
> +	PWRSRC_IRQ = 0,
> +	THRM_IRQ,
> +	BCU_IRQ,
> +	ADC_IRQ,
> +	CHGR_IRQ,
> +	GPIO_IRQ,
> +	VHDMIOCP_IRQ
> +};
> +
> +static struct resource gpio_resources[] = {
> +	{
> +		.name	= "GPIO",
> +		.start	= GPIO_IRQ,
> +		.end	= GPIO_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource pwrsrc_resources[] = {
> +	{
> +		.name  = "PWRSRC",
> +		.start = PWRSRC_IRQ,
> +		.end   = PWRSRC_IRQ,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource adc_resources[] = {
> +	{
> +		.name  = "ADC",
> +		.start = ADC_IRQ,
> +		.end   = ADC_IRQ,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource thermal_resources[] = {
> +	{
> +		.name  = "THERMAL",
> +		.start = THRM_IRQ,
> +		.end   = THRM_IRQ,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource bcu_resources[] = {
> +	{
> +		.name  = "BCU",
> +		.start = BCU_IRQ,
> +		.end   = BCU_IRQ,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell crystal_cove_dev[] = {
> +	{
> +		.name = "crystal_cove_pwrsrc",
> +		.id = 0,
> +		.num_resources = ARRAY_SIZE(pwrsrc_resources),
> +		.resources = pwrsrc_resources,
> +	},
> +	{
> +		.name = "crystal_cove_adc",
> +		.id = 0,
> +		.num_resources = ARRAY_SIZE(adc_resources),
> +		.resources = adc_resources,
> +	},
> +	{
> +		.name = "crystal_cove_thermal",
> +		.id = 0,
> +		.num_resources = ARRAY_SIZE(thermal_resources),
> +		.resources = thermal_resources,
> +	},
> +	{
> +		.name = "crystal_cove_bcu",
> +		.id = 0,
> +		.num_resources = ARRAY_SIZE(bcu_resources),
> +		.resources = bcu_resources,
> +	},
> +	{
> +		.name = "crystal_cove_gpio",
> +		.id = 0,
> +		.num_resources = ARRAY_SIZE(gpio_resources),
> +		.resources = gpio_resources,
> +	},
> +};

You can remove the id field.

> +static struct regmap_config crystal_cove_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = CRYSTAL_COVE_MAX_REGISTER,
> +	.cache_type = REGCACHE_NONE,
> +};
> +
> +#define	CRC_REGMAP_IRQ_VALUE(irq)	{	\
> +		.reg_offset = 0,		\
> +		.mask = BIT(irq),		\
> +	}

Can you sort out the whitespace here?

> +static const struct regmap_irq crystal_cove_irqs[] = {
> +	[PWRSRC_IRQ]	= CRC_REGMAP_IRQ_VALUE(PWRSRC_IRQ),
> +	[THRM_IRQ]	= CRC_REGMAP_IRQ_VALUE(THRM_IRQ),
> +	[BCU_IRQ]	= CRC_REGMAP_IRQ_VALUE(BCU_IRQ),
> +	[ADC_IRQ]	= CRC_REGMAP_IRQ_VALUE(ADC_IRQ),
> +	[CHGR_IRQ]	= CRC_REGMAP_IRQ_VALUE(CHGR_IRQ),
> +	[GPIO_IRQ]	= CRC_REGMAP_IRQ_VALUE(GPIO_IRQ),
> +	[VHDMIOCP_IRQ]	= CRC_REGMAP_IRQ_VALUE(VHDMIOCP_IRQ),
> +};
> +
> +static struct regmap_irq_chip crystal_cove_irq_chip = {
> +	.name = CHIP_NAME,
> +	.irqs = crystal_cove_irqs,
> +	.num_irqs = ARRAY_SIZE(crystal_cove_irqs),
> +	.num_regs = 1,
> +	.status_base = IRQLVL1,
> +	.mask_base = MIRQLVL1,
> +};
> +
> +static int crystal_cove_init(void)
> +{
> +	pr_debug("%s: ID 0x%02X, VERSION 0x%02X\n", CHIP_NAME,
> +		 intel_soc_pmic_readb(CHIPID), intel_soc_pmic_readb(CHIPVER));
> +	return 0;
> +}

This seems pointless.

> +struct intel_soc_pmic_config crystal_cove_pmic = {
> +	.label		= CHIP_NAME,

Where is this used?

> +	.irq_flags	= IRQF_TRIGGER_RISING,
> +	.init		= crystal_cove_init,
> +	.cell_dev	= crystal_cove_dev,
> +	.n_cell_devs	= ARRAY_SIZE(crystal_cove_dev),
> +	.regmap_cfg	= &crystal_cove_regmap_config,
> +	.irq_chip	= &crystal_cove_irq_chip,
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
