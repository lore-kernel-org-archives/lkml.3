Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaJFKqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:46:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55843 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:46:39 -0400
Date: Mon, 6 Oct 2014 12:46:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 03/11] pwm: add support for atmel-hlcdc-pwm device
Message-ID: <20141006104634.GE25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <1412175188-28278-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 04:53:00PM +0200, Boris Brezillon wrote:
[...]
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index b800783..afb896b 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -50,6 +50,16 @@ config PWM_ATMEL
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-atmel.
> =20
> +config PWM_ATMEL_HLCDC_PWM
> +	tristate "Atmel HLCDC PWM support"
> +	select MFD_ATMEL_HLCDC
> +	depends on OF

This isn't really necessary since MFD_ATMEL_HLCDC already depends on OF.

> diff --git a/drivers/pwm/pwm-atmel-hlcdc.c b/drivers/pwm/pwm-atmel-hlcdc.c
[...]
> new file mode 100644
> index 0000000..0238f7a
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel-hlcdc.c
> @@ -0,0 +1,229 @@
> +/*
> + * Copyright (C) 2014 Free Electrons
> + * Copyright (C) 2014 Atmel
> + *
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms of the GNU General Public License version 2 as publis=
hed by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/mfd/atmel-hlcdc.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/regmap.h>
> +
> +#define ATMEL_HLCDC_PWMCVAL_MASK	GENMASK(15, 8)
> +#define ATMEL_HLCDC_PWMCVAL(x)		((x << 8) & ATMEL_HLCDC_PWMCVAL_MASK)

You might want to use an extra pair of parentheses around the "x" above.

> +struct atmel_hlcdc_pwm_chip {

Can we make this...

> +	struct pwm_chip chip;
> +	struct atmel_hlcdc *hlcdc;
> +	struct clk *cur_clk;
> +};
> +
> +static inline struct atmel_hlcdc_pwm_chip *
> +pwm_chip_to_atmel_hlcdc_pwm_chip(struct pwm_chip *chip)

=2E.. and this a little shorter? There is a lot of line-wrapping below
only because this is very long. It seems like just dropping the
pwm_chip_ prefix on this function would be enough to not exceed the
78/80 character limit.

> +{
> +	return container_of(chip, struct atmel_hlcdc_pwm_chip, chip);
> +}
> +
> +static int atmel_hlcdc_pwm_config(struct pwm_chip *c,
> +				  struct pwm_device *pwm,
> +				  int duty_ns, int period_ns)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =3D
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc =3D chip->hlcdc;
> +	struct clk *new_clk =3D hlcdc->slow_clk;
> +	u64 pwmcval =3D duty_ns * 256;
> +	unsigned long clk_freq;
> +	u64 clk_period_ns;
> +	u32 pwmcfg;
> +	int pres;
> +
> +	clk_freq =3D clk_get_rate(new_clk);
> +	clk_period_ns =3D 1000000000;

NSEC_PER_SEC?

> +	clk_period_ns *=3D 256;

Perhaps collapse the above two in a single line:

	clk_period_ns =3D NSEC_PER_SEC * 256;

?

> +	do_div(clk_period_ns, clk_freq);
> +
> +	if (clk_period_ns > period_ns) {
> +		new_clk =3D hlcdc->sys_clk;
> +		clk_freq =3D clk_get_rate(new_clk);
> +		clk_period_ns =3D 1000000000;
> +		clk_period_ns *=3D 256;

Maybe:

	clk_period_ns =3D NSEC_PER_SEC * 256;

?

> +		do_div(clk_period_ns, clk_freq);
> +	}
> +
> +	for (pres =3D 0; pres <=3D ATMEL_HLCDC_PWMPS_MAX; pres++) {
> +		if ((clk_period_ns << pres) >=3D period_ns)
> +			break;
> +	}

Technically there's no need for the curly braces.

> +
> +	if (pres > ATMEL_HLCDC_PWMPS_MAX)
> +		return -EINVAL;

I think the condition above needs to be "pres =3D=3D ATMEL_HLCDC_PWMPS_MAX",
otherwise this will never be true.

> +
> +	pwmcfg =3D ATMEL_HLCDC_PWMPS(pres);
> +
> +	if (new_clk !=3D chip->cur_clk) {
> +		u32 gencfg =3D 0;
> +
> +		clk_prepare_enable(new_clk);

This can fail so it needs error-checking.

> +		clk_disable_unprepare(chip->cur_clk);
> +		chip->cur_clk =3D new_clk;
> +
> +		if (new_clk !=3D hlcdc->slow_clk)
> +			gencfg =3D ATMEL_HLCDC_CLKPWMSEL;

There are lots of negations here, which caused me to think that there
was a third clock involved here, but it seems like new_clk can either be
slow_clk or sys_clk.

Perhaps making this condition "new_clk =3D=3D hlcdc->sys_clk" would improve
clarity here. Maybe a comment somewhere would help?

> +		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
> +				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
> +	}
> +
> +	do_div(pwmcval, period_ns);
> +	if (pwmcval > 255)

The PWM core already makes sure that duty_ns <=3D period_ns, so pwmcval
could be anywhere between 0 and 256 here. Where does the disconnect come
=66rom? Why not make pwmcval =3D duty_ns * 255 if that's the maximum?

> +		pwmcval =3D 255;
> +
> +	pwmcfg |=3D ATMEL_HLCDC_PWMCVAL(pwmcval);
> +
> +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
> +			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
> +			   pwmcfg);
> +
> +	return 0;
> +}
> +
> +static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
> +					struct pwm_device *pwm,
> +					enum pwm_polarity polarity)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =3D
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc =3D chip->hlcdc;
> +	u32 cfg =3D 0;
> +
> +	if (polarity =3D=3D PWM_POLARITY_NORMAL)
> +		cfg =3D ATMEL_HLCDC_PWMPOL;

That's strange. Inverse polarity is the default on this hardware?

> +static int atmel_hlcdc_pwm_enable(struct pwm_chip *c,
> +				  struct pwm_device *pwm)

There's no need for line-wrapping here. The above fits on one line just
fine.

> +{
> +	struct atmel_hlcdc_pwm_chip *chip =3D
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc =3D chip->hlcdc;
> +	u32 status;
> +
> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_PWM);
> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
> +	       !(status & ATMEL_HLCDC_PWM))
> +		;

This loop isn't very readable. Can you improve it? Perhaps:

	do {
		err =3D regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status);
		if (err < 0)
			return err;
	} while ((status & ATMEL_HLCDC_PWM) =3D=3D 0);

That also allows errors to be properly propagated. Perhaps you also want
to put a usleep_range() or similar in there.

> +static void atmel_hlcdc_pwm_disable(struct pwm_chip *c,
> +				    struct pwm_device *pwm)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =3D
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc =3D chip->hlcdc;
> +	u32 status;
> +
> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_PWM);
> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
> +	       (status & ATMEL_HLCDC_PWM))
> +		;

Same here.

> +static int atmel_hlcdc_pwm_probe(struct platform_device *pdev)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip;
> +	struct device *dev =3D &pdev->dev;
> +	struct atmel_hlcdc *hlcdc;
> +	int ret;
> +
> +	hlcdc =3D dev_get_drvdata(dev->parent);
> +	if (!hlcdc)
> +		return -EINVAL;

Can this really happen?

> +	ret =3D clk_prepare_enable(hlcdc->periph_clk);
> +	if (ret)
> +		return ret;
> +
> +	chip =3D devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;

Don't you want to disable and unprepare the clock here? Perhaps in order
to avoid this call clk_prepare_enable() only after all resources have
been allocated.

> +MODULE_ALIAS("platform:atmel-hlcdc-pwm");
> +MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
> +MODULE_DESCRIPTION("Atmel HLCDC PWM driver");
> +MODULE_LICENSE("GPL");

According to the file header this needs to be "GPL v2".

Thierry

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMnMKAAoJEN0jrNd/PrOhchQQALgku/s1ZwEqypiON8EcPUzr
mjuFb0t0j1gluAEHowLaBaxzD4b/61sfeQ7K+gC97JClldwANCYIRZCkf/nOPqAz
Y/0k6mjmSKaAmO8/1IQ9ZRY3vdIHqd+G5BqV0RJKsQnRYxj1LP7zuelf/tQz42Mr
JRNNhRkb9+LqFSoG84x5UuQ6Jsronzwj3EVm3lsKjbaF/wWhOA5/Nqe+dwpoLgk6
8WHcjkD3CGeJPVac+c5FWXj1v3yM2Gl/PyNxRWjONHOq5qfcOzqifI45bUkRHFFT
kgmGCxnvZNYWLgZhfSqKTEryb1MWN7pVTjaz10inGtM2BpF9C0zBD3TjgjdZGlM3
GD2ZiYVrjrPmItnB00O4PHFhfgWNJncI9NB4Ji/0h4qBgSfYneSKvClTT/slDjuw
6wfIm6aIVRi4nNkOJ3s0ZXdSGitEg/Pa4qCKy+6+Jn5K7f++NzlEpFOqvZc0cw+1
xAGQVItVBG7hc2lOQHi2pTZ4enPSTtRjy7HbFnZ+ZshF/kJoCnTCiVNuOuJYzInC
hiduI3b0807uTuE8CWzTtp2WTeHJSDwQShXD4ZCe1e/PaZc7ri/wr9l1ykg+aUyE
Ipl2eCoWiYXLJK6tp9GIP+/7CLuTXbtGR6cCVuN01VTM6JbwO2oLc4TUA0aRmh37
QZJi/Zl6eTja2gR9/IUB
=y87M
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
