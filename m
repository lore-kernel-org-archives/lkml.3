Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBEO5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:57:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12118 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaBEO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:57:47 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-cb-52f251683d95
Message-id: <1391612262.3726.49.camel@AMDC1943>
Subject: Re: [PATCH 13/18] mfd: max77836: Add max77836 support to max14577
 driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 15:57:42 +0100
In-reply-to: <20140203102213.GL13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-14-git-send-email-k.kozlowski@samsung.com>
 <20140203102213.GL13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7oZgZ+CDO4cFreY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPFtysdTBabHl9jtbi8aw6bxdojd9ktbjeuYLM43c3qwOWxc9Zddo9NqzrZ
	PO5c28PmMe9koMfmJfUefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlXGjX7jgiE3FkeVLWBsY
	t+l3MXJySAiYSMydeokNwhaTuHBvPZDNxSEksJRR4svDn0wQzmdGiTUfH7OCVPEK6Eu0/G5g
	BrGFBYIldu3dxAJiswkYS2xevgSom4NDREBF4twbc5BeZoHHTBJLbn9gAqlhEVCVeDh5JTuI
	zSmgK3F3/nFWiAUrGSU+fXkPVsQsoC4xad4iZoiTlCR2t3eyQ8TlJTavecsMcYSgxI/J91gm
	MArMQtIyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMTXHYxLj1kdYhTg
	YFTi4TUQ/hgkxJpYVlyZe4hRgoNZSYT3qPunICHelMTKqtSi/Pii0pzU4kOMTBycUg2Mee7z
	Ht9Xm+y0o+7SDcUZ620+cdUnPNpVKRtwyv/+zAlnCk7Hu3FNS2vd///GITsZ+cmfvrJ4Wm6I
	+3Rws8GSTY4SqiytuTXv3+XkVj/K62PUYhUPO1Ws0yJvyHv9oORNaY9DoUdefpoQxPfVdLn4
	6qobGXfDHplM21SUkCs9yZqHj0+gPGWqEktxRqKhFnNRcSIAxhPPDGcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 10:22 +0000, Lee Jones wrote:
> On Tue, 28 Jan 2014, Krzysztof Kozlowski wrote:
> 
> > Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
> > component so the extcon, charger and regulators are almost the same. The
> > max77836 however has also PMIC and Fuel Gauge.
> > 
> > The MAX77836 uses three I2C slave addresses and has additional interrupts
> > (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> > just like MAX77686 and MAX77693.
> > 
> > The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
> > PMIC block. The PMIC block has different I2C slave address and uses own
> > regmap so another regmap_irq_chip is needed.
> > 
> > Since we have two regmap_irq_chip, use shared interrupts on MAX77836.
> > 
> > This patch adds additional defines and functions to the max14577 MFD core
> > driver so the driver will handle both chipsets.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c               |  215 ++++++++++++++++++++++++++++++++--
> >  include/linux/mfd/max14577-private.h |   85 +++++++++++++-
> >  include/linux/mfd/max14577.h         |    7 +-
> >  3 files changed, 296 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> > index 224aba8c5b3f..5b10f6f89834 100644
> > --- a/drivers/mfd/max14577.c
> > +++ b/drivers/mfd/max14577.c
> > @@ -1,7 +1,7 @@
> >  /*
> > - * max14577.c - mfd core driver for the Maxim 14577
> > + * max14577.c - mfd core driver for the Maxim 14577/77836
> 
> We may wish to consider changing the name of this file at a later
> date.

I agree, maybe "maxim-pmic.c"? The 14577 is a MUIC/charger, 77836 is a
MUIC/charger/mini-PMIC. However other max-like chipsets (77693, 77686)
have full PMIC capabilities, so the name change could be introduced when
support for these devices would be added.

> > - * Copyright (C) 2013 Samsung Electrnoics
> > + * Copyright (C) 2013,2014 Samsung Electrnoics
> 
> You can remove the the '2013' completely now.

Shouldn't it contain the date of first publication?

> >   * Chanwoo Choi <cw00.choi@samsung.com>
> >   * Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >   *
> > @@ -37,11 +37,31 @@ static struct mfd_cell max14577_devs[] = {
> >  	{ .name = "max14577-charger", },
> >  };
> >  
> > +static struct mfd_cell max77836_devs[] = {
> > +	{
> > +		.name = "max77836-muic",
> > +		.of_compatible = "maxim,max77836-muic",
> > +	},
> > +	{
> > +		.name = "max77836-regulator",
> > +		.of_compatible = "maxim,max77836-regulator",
> > +	},
> > +	{ .name = "max77836-charger", },
> 
> Why doesn't the charger require a compatible string?

Currently the charger driver doesn't use DT and does not require it. The
device type is taken from parent's MFD of_compatible.

I'll add the compatible anyway because but during review of other
charger patch it was pointed that the charger should be configurable.

> 
> > +	{
> > +		.name = "max77836-battery",
> > +		.of_compatible = "maxim,max77836-battery",
> > +	},
> > +};
> > +
> > @@ -56,6 +76,29 @@ static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
> >  	return false;
> >  }
> >  
> > +static bool max77836_muic_volatile_reg(struct device *dev, unsigned int reg)
> > +{
> > +	/* Any max14577 volatile registers are also max77836 volatile. */
> > +	if (max14577_muic_volatile_reg(dev, reg))
> > +		return true;
> 
> New line here please.

OK

> 
> > +	switch (reg) {
> > +	case MAX77836_FG_REG_VCELL_MSB ... MAX77836_FG_REG_SOC_LSB:
> > +	case MAX77836_FG_REG_CRATE_MSB ... MAX77836_FG_REG_CRATE_LSB:
> > +	case MAX77836_FG_REG_STATUS_H ... MAX77836_FG_REG_STATUS_L:
> > +		/* fall through */
> 
> It's okay not to have these here. We know how switch statements
> work. ;)

Checkpatch complained about lack of this...

> > +	case MAX77836_PMIC_REG_INTSRC:
> > +		/* fall through */
> > +	case MAX77836_PMIC_REG_TOPSYS_INT:
> > +		/* fall through */
> > +	case MAX77836_PMIC_REG_TOPSYS_STAT:
> > +		return true;
> > +	default:
> > +		break;
> > +	}
> > +	return false;
> > +}
> > +
> > +
> 
> Superfluous new line here.

OK

> > +static const struct regmap_irq_chip max77836_muic_irq_chip = {
> > +	.name			= "max77836-muic",
> > +	.status_base		= MAXIM_MUIC_REG_INT1,
> > +	.mask_base		= MAXIM_MUIC_REG_INTMASK1,
> > +	.mask_invert		= 1,
> 
> I'd prefer the use of 'true' or 'false' for bools.

OK

> > +	.num_regs		= 3,
> > +	.irqs			= max77836_muic_irqs,
> > +	.num_irqs		= ARRAY_SIZE(max77836_muic_irqs),
> > +};
> > +
> 
> <snip>
> 
> > +static const struct regmap_irq_chip max77836_pmic_irq_chip = {
> > +	.name			= "max77836-pmic",
> > +	.status_base		= MAX77836_PMIC_REG_TOPSYS_INT,
> > +	.mask_base		= MAX77836_PMIC_REG_TOPSYS_INT_MASK,
> > +	.mask_invert		= 0,
> 
> 'false' please.

OK

> > +	.num_regs		= 1,
> > +	.irqs			= max77836_pmic_irqs,
> > +	.num_irqs		= ARRAY_SIZE(max77836_pmic_irqs),
> > +};
> > +
> 
> <snip>
> 
> > +static int max77836_init(struct maxim_core *maxim_core)
> > +{
> > +	int ret;
> > +	u8 intsrc_mask;
> > +
> > +	maxim_core->i2c_pmic = i2c_new_dummy(maxim_core->i2c->adapter,
> > +			I2C_ADDR_PMIC);
> > +	if (!maxim_core->i2c_pmic) {
> > +		dev_err(maxim_core->dev, "Failed to register PMIC I2C device\n");
> > +		return -EPERM;
> 
> Not sure this is the best errno to return.
> 
> Perhaps -ENODEV would be more suitable?

Hmmm... I am not sure. The i2c_new_dummy() returns NULL when:
 - kzalloc fails,
 - I2C address is wrong (EINVAL),
 - I2C device is busy,
 - device_add fails.
For me none of them matches but I don't mind returning ENODEV.

> <snip>
> 
> >  #define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
> >  #define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
> >  #define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
> >  #define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
> >  #define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
> > +#define MAX77836_STATUS2_VIDRM_MASK	(0x1 << MAX77836_STATUS2_VIDRM_SHIFT)
> 
> It's up to you, but all of these "0x1 <<"s can be replaced with the
> BIT() macro if you so wished.

OK

> 
> >  /* MAX14577 STATUS3 register */
> >  #define MAXIM_STATUS3_EOC_SHIFT		0
> > @@ -232,6 +242,70 @@ enum maxim_muic_charger_type {
> >  
> >  
> >  
> 
> Do all of these extra new lines really exist, or is it just a patch
> thing? If they do, can you get rid of them please?

Sure.

> > +/* Slave addr = 0x46: PMIC */
> > +enum max77836_pmic_reg {
> > +	MAX77836_COMP_REG_COMP1			= 0x60,
> > +
> > +	MAX77836_LDO_REG_CNFG1_LDO1		= 0x51,
> > +	MAX77836_LDO_REG_CNFG2_LDO1		= 0x52,
> > +	MAX77836_LDO_REG_CNFG1_LDO2		= 0x53,
> > +	MAX77836_LDO_REG_CNFG2_LDO2		= 0x54,
> > +	MAX77836_LDO_REG_CNFG_LDO_BIAS		= 0x55,
> > +
> > +	MAX77836_PMIC_REG_PMIC_ID		= 0x20,
> > +	MAX77836_PMIC_REG_PMIC_REV		= 0x21,
> > +	MAX77836_PMIC_REG_INTSRC		= 0x22,
> > +	MAX77836_PMIC_REG_INTSRC_MASK		= 0x23,
> > +	MAX77836_PMIC_REG_TOPSYS_INT		= 0x24,
> > +	MAX77836_PMIC_REG_TOPSYS_INT_MASK	= 0x26,
> > +	MAX77836_PMIC_REG_TOPSYS_STAT		= 0x28,
> > +	MAX77836_PMIC_REG_MRSTB_CNTL		= 0x2A,
> > +	MAX77836_PMIC_REG_LSCNFG		= 0x2B,
> > +
> > +	MAX77836_PMIC_REG_END,
> > +};
> 
> Any reason why these aren't in numerical order?

I'll fix this.

> 
> <snip>
> 

