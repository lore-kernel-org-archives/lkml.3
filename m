Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3GYRgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:36:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48415 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3GYRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:36:14 -0400
Message-ID: <1374773739.4382.18.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 2/2] regulator: Add Dialog DA9063 voltage regulators
 support.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 25 Jul 2013 19:35:39 +0200
In-Reply-To: <20130724172959.GR9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
	 <1374683683-13370-3-git-send-email-p.zabel@pengutronix.de>
	 <20130724172959.GR9858@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

thank you for the comments.

Am Mittwoch, den 24.07.2013, 18:29 +0100 schrieb Mark Brown:
> On Wed, Jul 24, 2013 at 06:34:43PM +0200, Philipp Zabel wrote:
> 
> > +/* Definition for registering bit fields */
> > +struct bfield {
> > +	unsigned short	addr;
> > +	unsigned char	mask;
> > +};
> > +#define BFIELD(_addr, _mask) \
> > +	{ .addr = _addr, .mask = _mask }
> > +
> > +struct field {
> > +	unsigned short	addr;
> > +	unsigned char	mask;
> > +	unsigned char	shift;
> > +	unsigned char	offset;
> > +};
> > +#define FIELD(_addr, _mask, _shift, _offset) \
> > +	{ .addr = _addr, .mask = _mask, .shift = _shift, .offset = _offset }
> 
> This looks like it should be generic (and there is actually a
> regmap_field API for bitfields...).

Indeed. I'm a bit unhappy about having to split all the masks into lsb and msb
only to have regmap_field_init combine them back into a mask, though.
Could we perhaps change struct reg_field to contain reg and mask, and then also use
this for the regulator_desc vsel/apply/enable/bypass_reg/mask fields?

> > +static struct regulator_ops da9063_switch_ops = {
> > +	.enable			= regulator_enable_regmap,
> > +	.disable		= regulator_disable_regmap,
> > +	.is_enabled		= regulator_is_enabled_regmap,
> > +	.set_suspend_enable	= regulator_enable_regmap,
> > +	.set_suspend_disable	= regulator_disable_regmap,
> > +};
> 
> This is clearly broken, it's using the same generic ops for both suspend
> and regular enable which means that changing the suspend state will
> change the state at runtime which isn't what's wanted.

So I'll drop these.

> > +static struct regulator_ops da9063_ldo_ops = {
> > +	.enable			= da9063_enable,
> 
> You should be avoiding forward declarations of all these things by the
> way, look at the styles followed by other drivers.

Ok, I'll reorder as necessary.

> > +static int da9063_update_mode_internal(struct da9063_regulator *regl,
> > +				       int sys_state)
> > +{
> > +	const struct da9063_regulator_info *rinfo = regl->info;
> > +	unsigned val;
> > +	unsigned mode;
> > +	int ret;
> > +
> > +	if (sys_state == SYS_STATE_SUSPEND)
> > +		/* Get mode for regulator in suspend state */
> > +		mode = regl->suspend_mode;
> > +	else
> > +		/* Get mode for regulator in normal operation */
> > +		mode = regl->mode;
> 
> What's all this about then...

[...]

> > +	/* Bucks use single mode register field for normal operation
> > +	   and suspend state. LDOs use sleep flags - one for normal
> > +	   and one for suspend state. */
> > +	if (rinfo->mode.addr) {
> > +		/* For BUCKs, there are 3 modes to map to */
> > +		ret = regmap_read(regl->hw->regmap, rinfo->mode.addr, &val);
> > +		if (ret < 0)
> > +			return ret;
> 
> If the different regulators have different register layouts and mode
> sets then they should be using different ops, this will make things much
> easier to follow as there will be fewer conditional cases.

[...]

> > +	} else {
> > +		/* No support */
> > +		return 0;
> > +	}
> 
> This should be an error, though if the regulator doesn't support mode
> setting it oughtn't to have the operation in the first place.
> 
> > +static int da9063_enable(struct regulator_dev *rdev)
> > +{
> > +	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
> > +	int ret;
> > +
> > +	if (regl->info->suspend.mask) {
> > +		/* Make sure to exit from suspend mode on enable */
> > +		ret = regmap_update_bits(regl->hw->regmap,
> > +					 regl->info->suspend.addr,
> > +					 regl->info->suspend.mask, 0);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/* BUCKs need mode update after wake-up from suspend state. */
> > +		ret = da9063_update_mode_internal(regl, SYS_STATE_NORMAL);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return regulator_enable_regmap(rdev);
> > +}
> 
> You really do need to expain all this suspend mode stuff in more detail.
> Why is a regulator enable doing anything to do with suspend states,
> especially given that the regulator isn't put into suspend mode when
> disabled.

I think this is an elaborate dance around the fact that the bucks do not
have a separate mode register for the suspend state. I'll split this up
and drop set_suspend_mode for the bucks, as right now I don't have
enough information about the DA9063 to understand how this was supposed
to work exactly.

> > +#ifdef CONFIG_OF
> > +static struct of_regulator_match da9063_matches[] = {
> > +	[DA9063_ID_BCORE1]           = { .name = "bcore1"           },
> 
> Any new DT bindings need to be documented.

Will do.

> > +	/* Allocate memory required by usable regulators */
> > +	size = sizeof(struct da9063_regulators) +
> > +		regl_pdata->n_regulators * sizeof(struct da9063_regulator);
> > +	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> > +	if (!regulators) {
> > +		dev_err(&pdev->dev, "No memory for regulators\n");
> > +		return -ENOMEM;
> > +	}
> 
> The driver should register all the regulators that physically exist, it
> shouldn't be referring to platform data for this.

Ok.

regards
Philipp


