Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3GXRaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:30:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56071 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3GXRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:30:03 -0400
Date: Wed, 24 Jul 2013 18:29:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130724172959.GR9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aXB4qPGCvGizTg/w"
Content-Disposition: inline
In-Reply-To: <1374683683-13370-3-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: Add Dialog DA9063 voltage regulators
 support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aXB4qPGCvGizTg/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 06:34:43PM +0200, Philipp Zabel wrote:

> +/* Definition for registering bit fields */
> +struct bfield {
> +	unsigned short	addr;
> +	unsigned char	mask;
> +};
> +#define BFIELD(_addr, _mask) \
> +	{ .addr = _addr, .mask = _mask }
> +
> +struct field {
> +	unsigned short	addr;
> +	unsigned char	mask;
> +	unsigned char	shift;
> +	unsigned char	offset;
> +};
> +#define FIELD(_addr, _mask, _shift, _offset) \
> +	{ .addr = _addr, .mask = _mask, .shift = _shift, .offset = _offset }

This looks like it should be generic (and there is actually a
regmap_field API for bitfields...).

> +static struct regulator_ops da9063_switch_ops = {
> +	.enable			= regulator_enable_regmap,
> +	.disable		= regulator_disable_regmap,
> +	.is_enabled		= regulator_is_enabled_regmap,
> +	.set_suspend_enable	= regulator_enable_regmap,
> +	.set_suspend_disable	= regulator_disable_regmap,
> +};

This is clearly broken, it's using the same generic ops for both suspend
and regular enable which means that changing the suspend state will
change the state at runtime which isn't what's wanted.

> +static struct regulator_ops da9063_ldo_ops = {
> +	.enable			= da9063_enable,

You should be avoiding forward declarations of all these things by the
way, look at the styles followed by other drivers.

> +static int da9063_update_mode_internal(struct da9063_regulator *regl,
> +				       int sys_state)
> +{
> +	const struct da9063_regulator_info *rinfo = regl->info;
> +	unsigned val;
> +	unsigned mode;
> +	int ret;
> +
> +	if (sys_state == SYS_STATE_SUSPEND)
> +		/* Get mode for regulator in suspend state */
> +		mode = regl->suspend_mode;
> +	else
> +		/* Get mode for regulator in normal operation */
> +		mode = regl->mode;

What's all this about then...

> +	/* Bucks use single mode register field for normal operation
> +	   and suspend state. LDOs use sleep flags - one for normal
> +	   and one for suspend state. */
> +	if (rinfo->mode.addr) {
> +		/* For BUCKs, there are 3 modes to map to */
> +		ret = regmap_read(regl->hw->regmap, rinfo->mode.addr, &val);
> +		if (ret < 0)
> +			return ret;

If the different regulators have different register layouts and mode
sets then they should be using different ops, this will make things much
easier to follow as there will be fewer conditional cases.

> +	} else {
> +		/* No support */
> +		return 0;
> +	}

This should be an error, though if the regulator doesn't support mode
setting it oughtn't to have the operation in the first place.

> +static int da9063_enable(struct regulator_dev *rdev)
> +{
> +	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
> +	int ret;
> +
> +	if (regl->info->suspend.mask) {
> +		/* Make sure to exit from suspend mode on enable */
> +		ret = regmap_update_bits(regl->hw->regmap,
> +					 regl->info->suspend.addr,
> +					 regl->info->suspend.mask, 0);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* BUCKs need mode update after wake-up from suspend state. */
> +		ret = da9063_update_mode_internal(regl, SYS_STATE_NORMAL);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return regulator_enable_regmap(rdev);
> +}

You really do need to expain all this suspend mode stuff in more detail.
Why is a regulator enable doing anything to do with suspend states,
especially given that the regulator isn't put into suspend mode when
disabled.

> +#ifdef CONFIG_OF
> +static struct of_regulator_match da9063_matches[] = {
> +	[DA9063_ID_BCORE1]           = { .name = "bcore1"           },

Any new DT bindings need to be documented.

> +	/* Allocate memory required by usable regulators */
> +	size = sizeof(struct da9063_regulators) +
> +		regl_pdata->n_regulators * sizeof(struct da9063_regulator);
> +	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!regulators) {
> +		dev_err(&pdev->dev, "No memory for regulators\n");
> +		return -ENOMEM;
> +	}

The driver should register all the regulators that physically exist, it
shouldn't be referring to platform data for this.

--aXB4qPGCvGizTg/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8A8UAAoJELSic+t+oim9BPwP/Rb0AvBY6j+NeCd5ImSKDPBI
uLQvadyF6xmHdsVJHtx1gcEqCOcLsTD4ipVDOC0Ne140WeDAn9PfArYwAGvzngHy
3p5lq6FlJbwhgMe7OYxv7aGTFOgnP5bhghjgkF8rUqdvPViVBX+4A2QwE+GlzejV
Sodi1J05IgaPairLh/o/Dbq+YnPvCr+j5AEP2WnhK+40qH1bI/eX5ltM/9rFTwb0
SCGPw55UFsJTBSaWL83Sx0Kll3niKvZaPkwnOW6IqGC0lsK2yj0jE0vNTb19Zuk5
610o12gN5mZci8FctW5KpZl97lezkBs/WzKMWT6OhM9OammjAmgVrRxBZqeU/ohd
gNuJyw2dAGKRXWVleX7XmONuhWtR3DUxQ1XUyIAOpMYAaUq1a7ixUhX2jxgbkJRY
BkoRsmkflWN+k7BZBrxoXmtd0gu0t+AbH1SPWKL9Kv3fJlHw9a/liyWXTfu1U852
KFpX3xj8YYF8ci1zbzfjSTL3fyxjZrlBXUMHEmeTDFPpyAsGDOlbbLqxXjlfJq+t
sKA3XtNzqz5USz5setUjnj3qGN5HkiGW6lYn7OHk2HeMlk3A9QzOUhGWKCfN/S6W
+c7KUq36cdrbv1UZkIJ1fsRuLsMBPPuVcKl9AYbTEyltWDm/wdHFqU1VDyRCQ5Bp
FEcYf+p5jgFz7JLMYvZx
=mSC6
-----END PGP SIGNATURE-----

--aXB4qPGCvGizTg/w--
