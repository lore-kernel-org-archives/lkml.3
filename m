Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbaFSIoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:44:19 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47585 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbaFSIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:44:11 -0400
Date: Thu, 19 Jun 2014 09:44:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH 6/7] pwm: st: Add new driver for ST's PWM IP
Message-ID: <20140619084404.GA26560@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-6-git-send-email-lee.jones@linaro.org>
 <20140618231127.GF26514@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140618231127.GF26514@mithrandir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll comment on some of the more fluffy topics, I'll let Ajit reply to
the more technical details of the patch.

On Thu, 19 Jun 2014, Thierry Reding wrote:
> On Wed, Jun 18, 2014 at 03:52:51PM +0100, Lee Jones wrote:
> > This driver supports all current STi platforms' PWM IPs.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/pwm/Kconfig  |   9 ++
> >  drivers/pwm/Makefile |   1 +
> >  drivers/pwm/pwm-st.c | 378 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 388 insertions(+)
> >  create mode 100644 drivers/pwm/pwm-st.c
> > 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 4ad7b89..98a7bbc 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -292,4 +292,13 @@ config PWM_VT8500
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-vt8500.
> >  
> > +config PWM_ST
> 
> PWM_ST is awfully generic, perhaps PWM_STI would be a better choice?
> Even that's very generic. Maybe PWM_STI_H4XX? There's nothing wrong with
> supporting STiH{5,6,7,...}xx SoCs with such a driver. I'm just trying to
> think ahead what will happen if at some point a new SoC family is
> released that requires a different driver.

I'm inclined to agree with you, but as it stands, this driver supports
all ST h/w, so it's correct for it to be generic.  If some new IP
comes into fuition, at worst we'll have to change the name of the
driver.  I'm happy to put myself on the line for that if the time
comes.

> > diff --git a/drivers/pwm/pwm-st.c b/drivers/pwm/pwm-st.c
> [...]
> > +/*
> > + * PWM device driver for ST SoCs.
> > + * Author: Ajit Pal Singh <ajitpal.singh@st.com>
> 
> Given this line, shouldn't the commit contain Ajit Pal Singh's
> Signed-off-by?

Absolutely, this is a failing on my part - will be applied in v2.

> > + *
> > + * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
> 
> Was this driver really developed over a period of 11 years?

Probably, in one incarnation or other, but I'll speak to Ajit and see
if we can narrow this down to just this version.

> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> 
> Nit: no need for this extra blank line at the end of the comment.

Very well.

> > + */
> > +#include <linux/bsearch.h>
> 
> I prefer a blank line between the above two

Me too.  Will change.

> > +#include <linux/clk.h>
> > +#include <linux/math64.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwm.h>
> > +#include <linux/regmap.h>
> > +#include <linux/slab.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/time.h>
> 
> These should be sorted alphabetically.

Really? :)

> > +
> > +#define ST_PWMVAL(x)	(4 * (x))	/* Value used to define duty cycle */
> 
> "x" seems to designate the channel number, so perhaps make that clearer
> by naming the variable "ch"? Also in that case the comment is somewhat
> misleading.

Sure, will redefine.

> > +#define ST_PWMCR	0x50		/* Control/Config reg */
> > +#define ST_INTEN	0x54		/* Interrupt Enable/Disable reg */
> > +#define ST_CNT		0x60		/* PWMCounter */
> 
> I'd prefer s/reg/register/ and also use it consistently for the ST_CNT
> as well.

Okay.

> > +
> > +#define MAX_PWM_CNT_DEFAULT	255
> > +#define MAX_PRESCALE_DEFAULT	0xff
> > +#define NUM_CHAN_DEFAULT	1
> 
> These are only used in one place and their meaning is fairly obvious, so
> I'd just drop them.

I _always_ prefer defines over magic numbers, but as you wish - will fix.

> > +/* Regfield IDs */
> > +enum {
> > +	PWMCLK_PRESCALE = 0,
> 
> No need for "= 0".

It's more for clarity rather than technical requirement, but will remove.

> > +	PWM_EN,
> > +	PWM_INT_EN,
> > +	/* keep last */
> > +	MAX_REGFIELDS
> > +};
> > +
> > +struct st_pwm_chip {
> > +	struct device *dev;
> > +	struct clk *clk;
> > +	unsigned long clk_rate;
> > +	struct regmap *regmap;
> > +	struct st_pwm_compat_data *cdata;
> 
> Doesn't this require a predeclaration of struct st_pwm_compat_data? Or
> maybe just move struct st_pwm_compat_data before this.

You're right, will fix.

I think I would have expected at least a compiler warning about that?

> > +	struct regmap_field *prescale;
> > +	struct regmap_field *pwm_en;
> > +	struct regmap_field *pwm_int_en;
> > +	unsigned long *pwm_periods;
> > +	struct pwm_chip chip;
> > +	void __iomem *mmio_base;
> 
> mmio_base is somewhat long, maybe "mmio" or "base" would work equally
> well?

Okay.

> > +};
> > +
> > +struct st_pwm_compat_data {
> > +	const struct reg_field *reg_fields;
> > +	int num_chan;
> > +	int max_pwm_cnt;
> > +	int max_prescale;
> 
> Can't these three be unsigned?

I see no reason why not.  They can also be signed. :)

> > +};
> > +
> > +static const struct reg_field st_pwm_regfields[MAX_REGFIELDS] = {
> > +	[PWMCLK_PRESCALE]	= REG_FIELD(ST_PWMCR, 0, 3),
> > +	[PWM_EN]		= REG_FIELD(ST_PWMCR, 9, 9),
> > +	[PWM_INT_EN]		= REG_FIELD(ST_INTEN, 0, 0),
> > +};
> > +
> > +static inline struct st_pwm_chip *to_st_pwmchip(struct pwm_chip *chip)
> > +{
> > +	return container_of(chip, struct st_pwm_chip, chip);
> > +}
> > +
> > +/*
> > + * Calculate the period values supported by the PWM for the
> > + * current clock rate.
> > + */
> > +static void st_pwm_calc_periods(struct st_pwm_chip *pc)
> > +{
> > +	struct st_pwm_compat_data *cdata = pc->cdata;
> > +	struct device *dev = pc->dev;
> > +	unsigned long val;
> > +	int i;
> 
> unsigned?

Why?

It's much more common this way:

$ git grep $'\t'"int i;" | wc -l
17018
$ git grep $'\t'"unsigned int i;" | wc -l
2033

> > +
> > +	/*
> > +	 * period_ns = (10^9 * (prescaler + 1) * (MAX_PWM_COUNT + 1)) / CLK_RATE
> > +	 */
> > +	val = NSEC_PER_SEC / pc->clk_rate;
> > +	val *= cdata->max_pwm_cnt + 1;
> > +
> > +	dev_dbg(dev, "possible periods for clkrate[HZ]:%lu\n", pc->clk_rate);
> > +
> > +	for (i = 0; i <= cdata->max_prescale; i++) {
> > +		pc->pwm_periods[i] = val * (i + 1);
> > +		dev_dbg(dev, "prescale:%d, period[ns]:%lu\n",
> > +			i, pc->pwm_periods[i]);
> > +	}
> > +}
> > +
> > +static int st_pwm_cmp_periods(const void *key, const void *elt)
> > +{
> > +	unsigned long i = *(unsigned long *)key;
> > +	unsigned long j = *(unsigned long *)elt;
> > +
> > +	if (i < j)
> > +		return -1;
> > +	else
> > +		return i == j ? 0 : 1;
> > +}
> > +
> > +/*
> > + * For STiH4xx PWM IP, the pwm period is fixed to 256 local clock cycles.
> 
> s/pwm/PWM/ in prose. There are probably other occurrences of this
> throughout the driver.

Will change.

> > + * The only way to change the period (apart from changing the pwm input clock)
> > + * is to change the pwm clock prescaler.
> > + * The prescaler is of 4 bits, so only 16 prescaler values and hence only
> 
> I'm confused. This says there are 16 prescaler values, but at the same
> time the default maximum number of prescaler values is set to 255. Am I
> missing something?

I'll let Ajit answer this one, as he holds the technical documentation.

> > + * 16 possible period values are supported (for a particular clock rate).
> > + * The requested period will be applied only if it matches one of these
> > + * 16 values.
> > + */
> > +static int st_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> > +			 int duty_ns, int period_ns)
> > +{
> > +	struct st_pwm_chip *pc = to_st_pwmchip(chip);
> > +	struct device *dev = pc->dev;
> > +	struct st_pwm_compat_data *cdata = pc->cdata;
> > +	unsigned int prescale, pwmvalx;
> > +	unsigned long *found;
> > +	int ret;
> > +
> > +	/*
> > +	 * Search for matching period value. The corresponding index is our
> > +	 * prescale value
> > +	 */
> > +	found = bsearch(&period_ns, &pc->pwm_periods[0],
> 
> Technically doesn't period_ns need to be converted to an unsigned long
> here? Otherwise this won't be compatible with 64-bit architectures.
> Admittedly that's maybe not something relevant for this family of SoCs,
> but you never know where this driver will be used eventually.

This driver depends on ARCH_STI which only supports 32bit.

> > +			cdata->max_prescale + 1, sizeof(unsigned long),
> > +			st_pwm_cmp_periods);
> > +	if (!found) {
> > +		dev_err(dev, "failed to find matching period\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	prescale = found - &pc->pwm_periods[0];
> 
> This is somewhat unconventional. None of the other drivers precompute
> possible periods and I'm not convinced that it's an advantage. Setting
> the period (and configuring the PWM in general) is a fairly uncommon
> operation.

Another one for Ajit I feel.

> > +	/*
> > +	 * When PWMVal == 0, PWM pulse = 1 local clock cycle.
> > +	 * When PWMVal == max_pwm_count,
> > +	 * PWM pulse = (max_pwm_count + 1) local cycles,
> > +	 * that is continuous pulse: signal never goes low.
> > +	 */
> > +	pwmvalx = cdata->max_pwm_cnt * duty_ns / period_ns;
> > +
> > +	dev_dbg(dev, "prescale:%u, period:%i, duty:%i, pwmvalx:%u\n",
> > +		prescale, period_ns, duty_ns, pwmvalx);
> > +
> > +	/* Enable clock before writing to PWM registers */
> > +	ret = clk_enable(pc->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = regmap_field_write(pc->prescale, prescale);
> > +	if (ret)
> > +		goto clk_dis;
> 
> So the prescaler is shared between all channels? In that case I think
> you should check for conflicting settings to prevent one channel from
> stomping on the other.

Ajit, if you'd be so kind.

> > +
> > +	ret = regmap_write(pc->regmap, ST_PWMVAL(pwm->hwpwm), pwmvalx);
> > +	if (ret)
> > +		goto clk_dis;
> > +
> > +	ret = regmap_field_write(pc->pwm_int_en, 0);
> 
> This seems to be never set to any other value, so perhaps it should be
> set at .probe() time?

Unfortunately not, as the clk needs to be enabled whilst setting IRQ
state.  Moving it into .probe() would mean wrapping this command
between clk_enable() and clk_disable(), which I think it a waste.

> > +
> > +clk_dis:
> > +	clk_disable(pc->clk);
> > +	return ret;
> > +}
> > +
> > +static int st_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> > +{
> > +	struct st_pwm_chip *pc = to_st_pwmchip(chip);
> > +	struct device *dev = pc->dev;
> > +	int ret;
> > +
> > +	ret = clk_enable(pc->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = regmap_field_write(pc->pwm_en, 1);
> > +	if (ret)
> > +		dev_err(dev, "%s,pwm_en write failed\n", __func__);
> 
> This error message is somewhat cryptic, perhaps:
> 
> 	"failed to enable PWM"

Agreed.  I also can't believe I missed that nasty __func__ too.

> ? Also what implications does this have on controllers with multiple
> channels?

I believe this enables both channels, but I'm sure Ajit will correct
me if I'm wrong.

> > +
> > +	return ret;
> > +}
> > +
> > +static void st_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> > +{
> > +	struct st_pwm_chip *pc = to_st_pwmchip(chip);
> > +	struct device *dev = pc->dev;
> > +	unsigned int val;
> > +
> > +	regmap_field_write(pc->pwm_en, 0);
> 
> Does this turn off the second channel as well?

Ajit, what happens if the other channel is still in use?

> > +
> > +	regmap_read(pc->regmap, ST_CNT, &val);
> 
> Does this read have any other use beyond the debugging output below?

Doesn't look like it does it.  Ajit, can this be removed?

> > +	dev_dbg(dev, "pwm counter :%u\n", val);
> > +
> > +	clk_disable(pc->clk);
> > +}
> > +
> > +static const struct pwm_ops st_pwm_ops = {
> > +	.config = st_pwm_config,
> > +	.enable = st_pwm_enable,
> > +	.disable = st_pwm_disable,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +static int st_pwm_probe_dt(struct st_pwm_chip *pc)
> > +{
> > +	struct device *dev = pc->dev;
> > +	const struct reg_field *reg_fields;
> > +	struct device_node *np = dev->of_node;
> > +	struct st_pwm_compat_data *cdata = pc->cdata;
> > +	u32 num_chan;
> > +
> > +	of_property_read_u32(np, "st,pwm-num-chan", &num_chan);
> > +	if (num_chan)
> > +		cdata->num_chan = num_chan;
> 
> I don't like this very much. What influences the number of channels? Is
> it that specific SoC revisions have one and others have two?

Ajit?

> > +	reg_fields = cdata->reg_fields;
> > +
> > +	pc->prescale = devm_regmap_field_alloc(dev, pc->regmap,
> > +					       reg_fields[PWMCLK_PRESCALE]);
> > +	pc->pwm_en = devm_regmap_field_alloc(dev, pc->regmap,
> > +					     reg_fields[PWM_EN]);
> > +	pc->pwm_int_en = devm_regmap_field_alloc(dev, pc->regmap,
> > +						 reg_fields[PWM_INT_EN]);
> > +
> > +	if (IS_ERR(pc->prescale) ||
> > +	    IS_ERR(pc->pwm_en)   ||
> > +	    IS_ERR(pc->pwm_int_en)) {
> > +		dev_err(dev, "unable to allocate reg_field(s)\n");
> > +		return -EINVAL;
> > +	}
> 
> You're obfuscating error codes here. A better approach would be to check
> each of these individually and return PTR_ERR(pc->...) to report the
> most accurate error code.

Agreed, will change.

> > +
> > +	return 0;
> > +}
> > +
> > +static struct regmap_config st_pwm_regmap_config = {
> 
> static const

Good catch.

> > +	.reg_bits   = 32,
> > +	.val_bits   = 32,
> > +	.reg_stride = 4,
> > +};
> 
> Please drop the artificial padding. A single space on each side of '='
> will do just fine.

/me likes straight lines!

... but as you wish.

> > +static int st_pwm_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *np = dev->of_node;
> > +	struct st_pwm_compat_data *cdata;
> > +	struct st_pwm_chip *pc;
> > +	struct resource *res;
> > +	int ret;
> > +
> > +	if (!np) {
> > +		dev_err(dev, "failed to find device node\n");
> > +		return -EINVAL;
> > +	}
> 
> I have difficulty imagining how this condition would ever happen. Can
> this check not simply be removed?

Although true, this check is very common.  I wonder if they can _all_
be removed from OF only drivers?  Probably something worth bringing up
with the DT guys.

> > +	pc = devm_kzalloc(dev, sizeof(*pc), GFP_KERNEL);
> > +	if (!pc)
> > +		return -ENOMEM;
> > +
> > +	cdata = devm_kzalloc(dev, sizeof(*cdata), GFP_KERNEL);
> > +	if (!cdata)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +	pc->mmio_base = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(pc->mmio_base)) {
> > +		dev_err(dev, "failed to find and map memory resources\n");
> 
> No need for this error message. devm_ioremap_resource() will provide one
> for you.
> 
> > +		return PTR_ERR(pc->mmio_base);
> > +	}
> > +
> > +	pc->regmap = devm_regmap_init_mmio(dev, pc->mmio_base,
> > +					   &st_pwm_regmap_config);
> > +	if (IS_ERR(pc->regmap))
> > +		return PTR_ERR(pc->regmap);
> > +
> > +	/*
> > +	 * Setup PWM data with default values: some values could be replaced
> > +	 * with specific ones provided from device tree
> 
> Nit: this is a sentence and therefore should be terminated with a full
> stop.

:)

> > +	 */
> > +	cdata->reg_fields   = &st_pwm_regfields[0];
> 
> Why not simply "= st_pwm_regfields;"?

Although semantically the same, I think what we're trying to achieve
is more obvious at first glance in the current format.

But will fix if you are insistent.

> > +	cdata->max_pwm_cnt  = MAX_PWM_CNT_DEFAULT;
> > +	cdata->max_prescale = MAX_PRESCALE_DEFAULT;
> > +	cdata->num_chan     = NUM_CHAN_DEFAULT;

Look at those lovely straight lines.  Are you sure you want me to
unalign the regmap_config above?

> > +	pc->cdata = cdata;
> > +	pc->dev = dev;
> > +
> > +	ret = st_pwm_probe_dt(pc);
> > +	if (ret)
> > +		return ret;
> > +
> > +	pc->pwm_periods = devm_kzalloc(dev,
> > +			sizeof(unsigned long) * (pc->cdata->max_prescale + 1),
> 
> This could use a temporary variable to make this shorter. I'd still urge
> you to consider dropping the cache here, in which case you don't need
> this allocation in the first place.

Ajit, what would you like to do?

> > +			GFP_KERNEL);
> > +	if (!pc->pwm_periods)
> > +		return -ENOMEM;
> > +
> > +	pc->clk = of_clk_get_by_name(np, "pwm");
> 
> devm_clk_get(&pdev->dev, "pwm")?

Sure.

> > +	if (IS_ERR(pc->clk)) {
> > +		dev_err(dev, "failed to get pwm clock\n");
> > +		return PTR_ERR(pc->clk);
> > +	}
> > +
> > +	pc->clk_rate = clk_get_rate(pc->clk);
> > +	if (!pc->clk_rate) {
> > +		dev_err(dev, "failed to get clk rate\n");
> 
> "... clock rate\n"

clk is a well known synonym for clock in Linux and can be found
throughout many bootlogs, but again, happy to change if it's causing
issues.

> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = clk_prepare(pc->clk);
> > +	if (ret) {
> > +		dev_err(dev, "failed to prepare clk\n");
> 
> "... prepare clock\n"

As above.

> > +		return ret;
> > +	}
> > +
> > +	st_pwm_calc_periods(pc);
> > +
> > +	pc->chip.dev = dev;
> > +	pc->chip.ops = &st_pwm_ops;
> > +	pc->chip.base = -1;
> > +	pc->chip.npwm = pc->cdata->num_chan;
> > +	pc->chip.can_sleep = true;
> > +
> > +	ret = pwmchip_add(&pc->chip);
> > +	if (ret < 0) {
> > +		clk_unprepare(pc->clk);
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, pc);
> > +
> > +	return 0;
> > +}
> > +
> > +static int st_pwm_remove(struct platform_device *pdev)
> > +{
> > +	struct st_pwm_chip *pc = platform_get_drvdata(pdev);
> > +	int i;
> 
> unsigned

As above.

> > +
> > +	for (i = 0; i < pc->cdata->num_chan; i++)
> > +		pwm_disable(&pc->chip.pwms[i]);
> > +
> > +	clk_unprepare(pc->clk);
> > +
> > +	return pwmchip_remove(&pc->chip);
> > +}
> > +
> > +static struct of_device_id st_pwm_of_match[] = {
> 
> static const

Good catch.

> > +	{ .compatible = "st,sti-pwm", },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, st_pwm_of_match);
> > +
> > +static struct platform_driver st_pwm_driver = {
> > +	.driver = {
> > +		.name	= "st-pwm",
> > +		.owner  = THIS_MODULE,
> 
> No need for this, module_platform_driver() will set it for you. Also
> please drop the artificial padding above and below.

Will remove.

> > +		.of_match_table = st_pwm_of_match,
> > +	},
> > +	.probe		= st_pwm_probe,
> > +	.remove		= st_pwm_remove,
> > +};
> > +module_platform_driver(st_pwm_driver);
> > +
> > +MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
> 
> This doesn't look right. Shouldn't the author be the same as in the
> header comment here? The email address matches that, but the company
> name is usually not a good fit for the MODULE_AUTHOR field.

Agree, will change.

> > +MODULE_DESCRIPTION("STMicroelectronics ST PWM driver");
> > +MODULE_LICENSE("GPL v2");
> 
> According to the file header comment this should be simply "GPL".

Will check with ST.

> Thierry

Thanks Thierry.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
