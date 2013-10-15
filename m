Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab3JOKlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:41:50 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51155 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3JOKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:41:48 -0400
Date: Tue, 15 Oct 2013 12:39:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-pwm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] pwm: add ep93xx PWM support
Message-ID: <20131015103932.GN7856@ulmo.nvidia.com>
References: <201310141457.49208.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pjk796cY0SfIo9Z2"
Content-Disposition: inline
In-Reply-To: <201310141457.49208.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pjk796cY0SfIo9Z2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 02:57:48PM -0700, H Hartley Sweeten wrote:
> Remove the non-standard EP93xx pwm driver in drivers/misc and add

pwm -> PWM

> a new driver for the PWM chips on the EP93xx platforms based on the
> PWM framework.
>=20
> These PWM chips each support 1 PWM channel with programmable duty

Perhaps "chips" -> "controllers"?

> cycle, frequency, and polarity inversion.
>=20
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
[...]
> - *	(c) Copyright 2009  Matthieu Crapet <mcrapet@gmail.com>
> - *	(c) Copyright 2009  H Hartley Sweeten <hsweeten@visionengravers.com>
[...]
> -MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
> -	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
[...]

> diff --git a/drivers/pwm/pwm-ep93xx.c b/drivers/pwm/pwm-ep93xx.c
[...]
> + * Copyright (C) 2013 H Hartley Sweeten <hsweeten@visionengravers.com>
[...]
> +MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");

Why are you removing Matthieu from the list of authors and copyright
here? From a brief look it seems like this new driver is still based on
code from the old driver and not a complete rewrite.

> +#include <mach/platform.h>	/* for ep93xx_pwm_{acquire,release}_gpio() */

I'm not sure how well that will play together with multiplatform support
but perhaps that's not an issue for ep93xx?

> +static int ep93xx_pwm_request(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct platform_device *pdev =3D to_platform_device(chip->dev);
> +
> +	return ep93xx_pwm_acquire_gpio(pdev);
> +}
> +
> +static void ep93xx_pwm_free(struct pwm_chip *chip, struct pwm_device *pw=
m)
> +{
> +	struct platform_device *pdev =3D to_platform_device(chip->dev);
> +
> +	ep93xx_pwm_release_gpio(pdev);
> +}

This looks like it would belong in the domain of pinctrl, but I suspect
that ep93xx doesn't support that.

> +static int ep93xx_pwm_config(struct pwm_chip *chip, struct pwm_device *p=
wm,
> +			     int duty_ns, int period_ns)
> +{
> +	struct ep93xx_pwm *ep93xx_pwm =3D to_ep93xx_pwm(chip);
> +	void __iomem *base =3D ep93xx_pwm->base;
> +	unsigned long long c;
> +	unsigned long period_cycles;
> +	unsigned long duty_cycles;
> +	unsigned long term;
> +	int ret =3D 0;
> +
> +	/*
> +	 * The clock needs to be enabled to access the PWM registers.
> +	 * Configuration can be changed at any time.
> +	 */
> +	if (!test_bit(PWMF_ENABLED, &pwm->flags))
> +		clk_enable(ep93xx_pwm->clk);

clk_enable() can fail, so you should check the return value and
propagate errors.

> +static int ep93xx_pwm_polarity(struct pwm_chip *chip, struct pwm_device =
*pwm,
> +			       enum pwm_polarity polarity)
> +{
> +	struct ep93xx_pwm *ep93xx_pwm =3D to_ep93xx_pwm(chip);
> +
> +	/*
> +	 * The clock needs to be enabled to access the PWM registers.
> +	 * Polarity can only be changed when the PWM is disabled.
> +	  */

Nit: the closing */ is wrongly aligned.

> +	clk_enable(ep93xx_pwm->clk);

Needs a check of the return value.

> +	writew(polarity, ep93xx_pwm->base + EP93XX_PWMx_INVERT);

I'd prefer if this did some explicit conversion from the PWM framework
value to the driver-specific value, even if they happen to be the same
in this case.

> +static int ep93xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *p=
wm)
> +{
> +	struct ep93xx_pwm *ep93xx_pwm =3D to_ep93xx_pwm(chip);
> +
> +	clk_enable(ep93xx_pwm->clk);

Also needs to check the return value.

> +static struct pwm_ops ep93xx_pwm_ops =3D {

static const, please.

> +static int ep93xx_pwm_remove(struct platform_device *pdev)
> +{
> +	struct ep93xx_pwm *ep93xx_pwm;
> +
> +	ep93xx_pwm =3D platform_get_drvdata(pdev);
> +	if (!ep93xx_pwm)
> +		return -ENODEV;

No need for this check. It will never happen.

> +
> +	return pwmchip_remove(&ep93xx_pwm->chip);
> +}
> +
> +static struct platform_driver ep93xx_pwm_driver =3D {
> +	.driver		=3D {
> +		.name	=3D "ep93xx-pwm",
> +		.owner	=3D THIS_MODULE,

This is no longer required because the core sets it to the proper value.

> +	},
> +	.probe		=3D ep93xx_pwm_probe,
> +	.remove		=3D ep93xx_pwm_remove,
> +};

Oh, and I didn't mention it before, but please get rid of all the
needless tabs for alignment. It's completely useless and doesn't help
with readability at all in my opinion.

Thierry

--Pjk796cY0SfIo9Z2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXRtkAAoJEN0jrNd/PrOhZqwQAIURJRKGlz2U6PI7IhWd6JSw
ORdNtZq55atTmqdC/n4YLzxnGWSRdrMqny2pwZ0me02dcVE4I6ADtLcd+btTUMHk
zGsWkf96F0obyy0YmGnxEYO0/axjkv6ChYXTn0WxRqznHjxS4KFgv9d6lfQgf8Db
oQ1YVmae6a8Ih+VyXAJRFbPT15I6wV7Ny5MiKbi4sg65y4xvrazWXF8FuBsnLQCA
azFurr/XUzbOf3gLGBOB/cQjs4Pm+1HEGxRsuWg0utqjF/Os7bgmUkehITBqQ4Al
ecdI0TUANwT7diS3zx6BDjYLjifKeCYHx8sXJmItpJsExUvkkIfD55W0EYx7jWhS
4N4XJns8/JSo8shpDNu2ImEHuKz2ZMye0mrDprsP51MPBlYck4Gh/SEjMfNCaxOY
iKnzcF2b8K3AtgFgRQddnhU3iRGoDghYBheqEDa0xQsMckVqxdaFJGT/EsnkQp3F
xsbgG1F4sOxHIJYwkK+sxA/rtE6K01LRAM7xnlxTjsk3VSBLdBkN4Z2DOmONovtD
OIYM1r1vdEuGvMsvzDCkfh20V549LIa8bNwjFsXuh+/lnAFaG5I1YxeDK/guK5Uh
7bXQPsXxQM2fRwkIyUkStuMuGP7uC+KoeQIeHs0eTkcogMpLoViQkLoT25CAZm0o
dytHcK9qd26+wbGSYmPC
=L4Rv
-----END PGP SIGNATURE-----

--Pjk796cY0SfIo9Z2--
