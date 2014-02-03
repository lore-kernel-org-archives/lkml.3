Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBCKW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:22:26 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40499 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBCKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:22:20 -0500
Date: Mon, 3 Feb 2014 10:22:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 13/18] mfd: max77836: Add max77836 support to max14577
 driver
Message-ID: <20140203102213.GL13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-14-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-14-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Krzysztof Kozlowski wrote:

> Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
> component so the extcon, charger and regulators are almost the same. The
> max77836 however has also PMIC and Fuel Gauge.
> 
> The MAX77836 uses three I2C slave addresses and has additional interrupts
> (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> just like MAX77686 and MAX77693.
> 
> The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
> PMIC block. The PMIC block has different I2C slave address and uses own
> regmap so another regmap_irq_chip is needed.
> 
> Since we have two regmap_irq_chip, use shared interrupts on MAX77836.
> 
> This patch adds additional defines and functions to the max14577 MFD core
> driver so the driver will handle both chipsets.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mfd/max14577.c               |  215 ++++++++++++++++++++++++++++++++--
>  include/linux/mfd/max14577-private.h |   85 +++++++++++++-
>  include/linux/mfd/max14577.h         |    7 +-
>  3 files changed, 296 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 224aba8c5b3f..5b10f6f89834 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -1,7 +1,7 @@
>  /*
> - * max14577.c - mfd core driver for the Maxim 14577
> + * max14577.c - mfd core driver for the Maxim 14577/77836

We may wish to consider changing the name of this file at a later
date.

> - * Copyright (C) 2013 Samsung Electrnoics
> + * Copyright (C) 2013,2014 Samsung Electrnoics

You can remove the the '2013' completely now.

>   * Chanwoo Choi <cw00.choi@samsung.com>
>   * Krzysztof Kozlowski <k.kozlowski@samsung.com>
>   *
> @@ -37,11 +37,31 @@ static struct mfd_cell max14577_devs[] = {
>  	{ .name = "max14577-charger", },
>  };
>  
> +static struct mfd_cell max77836_devs[] = {
> +	{
> +		.name = "max77836-muic",
> +		.of_compatible = "maxim,max77836-muic",
> +	},
> +	{
> +		.name = "max77836-regulator",
> +		.of_compatible = "maxim,max77836-regulator",
> +	},
> +	{ .name = "max77836-charger", },

Why doesn't the charger require a compatible string?

> +	{
> +		.name = "max77836-battery",
> +		.of_compatible = "maxim,max77836-battery",
> +	},
> +};
> +
> @@ -56,6 +76,29 @@ static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
>  	return false;
>  }
>  
> +static bool max77836_muic_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	/* Any max14577 volatile registers are also max77836 volatile. */
> +	if (max14577_muic_volatile_reg(dev, reg))
> +		return true;

New line here please.

> +	switch (reg) {
> +	case MAX77836_FG_REG_VCELL_MSB ... MAX77836_FG_REG_SOC_LSB:
> +	case MAX77836_FG_REG_CRATE_MSB ... MAX77836_FG_REG_CRATE_LSB:
> +	case MAX77836_FG_REG_STATUS_H ... MAX77836_FG_REG_STATUS_L:
> +		/* fall through */

It's okay not to have these here. We know how switch statements
work. ;)

> +	case MAX77836_PMIC_REG_INTSRC:
> +		/* fall through */
> +	case MAX77836_PMIC_REG_TOPSYS_INT:
> +		/* fall through */
> +	case MAX77836_PMIC_REG_TOPSYS_STAT:
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;
> +}
> +
> +

Superfluous new line here.

> +static const struct regmap_irq_chip max77836_muic_irq_chip = {
> +	.name			= "max77836-muic",
> +	.status_base		= MAXIM_MUIC_REG_INT1,
> +	.mask_base		= MAXIM_MUIC_REG_INTMASK1,
> +	.mask_invert		= 1,

I'd prefer the use of 'true' or 'false' for bools.

> +	.num_regs		= 3,
> +	.irqs			= max77836_muic_irqs,
> +	.num_irqs		= ARRAY_SIZE(max77836_muic_irqs),
> +};
> +

<snip>

> +static const struct regmap_irq_chip max77836_pmic_irq_chip = {
> +	.name			= "max77836-pmic",
> +	.status_base		= MAX77836_PMIC_REG_TOPSYS_INT,
> +	.mask_base		= MAX77836_PMIC_REG_TOPSYS_INT_MASK,
> +	.mask_invert		= 0,

'false' please.

> +	.num_regs		= 1,
> +	.irqs			= max77836_pmic_irqs,
> +	.num_irqs		= ARRAY_SIZE(max77836_pmic_irqs),
> +};
> +

<snip>

> +static int max77836_init(struct maxim_core *maxim_core)
> +{
> +	int ret;
> +	u8 intsrc_mask;
> +
> +	maxim_core->i2c_pmic = i2c_new_dummy(maxim_core->i2c->adapter,
> +			I2C_ADDR_PMIC);
> +	if (!maxim_core->i2c_pmic) {
> +		dev_err(maxim_core->dev, "Failed to register PMIC I2C device\n");
> +		return -EPERM;

Not sure this is the best errno to return.

Perhaps -ENODEV would be more suitable?

<snip>

>  #define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
>  #define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
>  #define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
>  #define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
>  #define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
> +#define MAX77836_STATUS2_VIDRM_MASK	(0x1 << MAX77836_STATUS2_VIDRM_SHIFT)

It's up to you, but all of these "0x1 <<"s can be replaced with the
BIT() macro if you so wished.

>  /* MAX14577 STATUS3 register */
>  #define MAXIM_STATUS3_EOC_SHIFT		0
> @@ -232,6 +242,70 @@ enum maxim_muic_charger_type {
>  
>  
>  

Do all of these extra new lines really exist, or is it just a patch
thing? If they do, can you get rid of them please?

> +/* Slave addr = 0x46: PMIC */
> +enum max77836_pmic_reg {
> +	MAX77836_COMP_REG_COMP1			= 0x60,
> +
> +	MAX77836_LDO_REG_CNFG1_LDO1		= 0x51,
> +	MAX77836_LDO_REG_CNFG2_LDO1		= 0x52,
> +	MAX77836_LDO_REG_CNFG1_LDO2		= 0x53,
> +	MAX77836_LDO_REG_CNFG2_LDO2		= 0x54,
> +	MAX77836_LDO_REG_CNFG_LDO_BIAS		= 0x55,
> +
> +	MAX77836_PMIC_REG_PMIC_ID		= 0x20,
> +	MAX77836_PMIC_REG_PMIC_REV		= 0x21,
> +	MAX77836_PMIC_REG_INTSRC		= 0x22,
> +	MAX77836_PMIC_REG_INTSRC_MASK		= 0x23,
> +	MAX77836_PMIC_REG_TOPSYS_INT		= 0x24,
> +	MAX77836_PMIC_REG_TOPSYS_INT_MASK	= 0x26,
> +	MAX77836_PMIC_REG_TOPSYS_STAT		= 0x28,
> +	MAX77836_PMIC_REG_MRSTB_CNTL		= 0x2A,
> +	MAX77836_PMIC_REG_LSCNFG		= 0x2B,
> +
> +	MAX77836_PMIC_REG_END,
> +};

Any reason why these aren't in numerical order?

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
