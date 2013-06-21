Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3FUKDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:03:00 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33942 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3FUKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:02:58 -0400
Date: Fri, 21 Jun 2013 12:02:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Robin van der Gracht <robin@protonic.nl>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH] pwm: pwm-mxs: Apply configuration before disabling PWM.
Message-ID: <20130621100254.GB12441@manwe>
References: <1371642686-10300-1-git-send-email-robin@protonic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1371642686-10300-1-git-send-email-robin@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Please use my new email address and Cc the linux-pwm mailing list.

The subject implies some active procedure is used to make sure the
configuration is applied, but you really only wait for some amount of
time. Perhaps something like:

	pwm: pwm-mxs: Wait for configuration to apply before disabling PWM

is more accurate?

On Wed, Jun 19, 2013 at 01:51:26PM +0200, Robin van der Gracht wrote:
> When disabling the pwm, the output state locks at its current state.

Please use the proper spelling "PWM" in prose.

> We have to be sure the last configuration applied. Which in most
> cases sets duty cycle to 0%. To prevent the pwm from taking on
> 100% duty cycle when disabled during a high state.
>=20
> Configuration applies at the beginning of a new output period.

I have some trouble understanding this, but I think you mean:

We have to be sure that the last configuration has been applied. In most
cases drivers will have set the duty-cycle to 0%. To prevent the PWM
=66rom locking at a 100% duty-cycle for example, we delay disabling the
PWM for a whole period to make sure any new configuration has been
latched.

> diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
> index 3febddd..4ddc063 100644
> --- a/drivers/pwm/pwm-mxs.c
> +++ b/drivers/pwm/pwm-mxs.c
> @@ -21,6 +21,7 @@
>  #include <linux/pwm.h>
>  #include <linux/slab.h>
>  #include <linux/stmp_device.h>
> +#include <linux/delay.h>

Please keep the includes sorted alphabetically.

> =20
>  #define SET	0x4
>  #define CLR	0x8
> @@ -40,6 +41,7 @@ struct mxs_pwm_chip {
>  	struct pwm_chip chip;
>  	struct clk *clk;
>  	void __iomem *base;
> +	unsigned long period_ns;

This is not the proper place to put it. The period can be different for
each PWM channel. But you also don't need to store this separately as in
latest linux-next this is already done by the core. You can use the
pwm_get_period() function to obtain the current period from a PWM
device.

> @@ -113,6 +116,11 @@ static void mxs_pwm_disable(struct pwm_chip *chip, s=
truct pwm_device *pwm)
>  {
>  	struct mxs_pwm_chip *mxs =3D to_mxs_pwm_chip(chip);
> =20
> +	/*
> +	 * Ensure latest configuration applied.
> +	 */

This comment can go on a single line.

> +	ndelay(mxs->period_ns);

This introduces a potentially long delay. How about changing this to
something like:

	period =3D pwm_get_period(pwm);
	period =3D DIV_ROUND_UP(period, 1000);
	usleep_range(period, period + 1000);

?

Thierry

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxCTOAAoJEN0jrNd/PrOhcpgP/iF13L5VAOidIEotNkNjEk/V
IxXOxL6+2JQa9Qu04zRISS2fEatSJJCvs/XZpAZ6Xv9vzHgMtGu5NWLUvk9Cj35A
j1FAIv48JwVEtYFhq/KLN91FFv8X7wxwTrI4uKjCNKDgFwlu/WmvLcSskiiQdiHx
YYyFld0LqPqosZekIek1oZkp2qmlvqgrepqLvW0OYdBojuTMHTPJLS4V562PWYZ3
WUUz+5y1cwKaVoVdjsl7kMyENgKVFbfAAyAln5X9jkfikWaP+IaPsaiHKmSkTz5e
2fW9s0JY6QfrRhepRVwNca/uvN+K3Ixm7Uf2/34Hj5+w4l/jQ3EFF8t6eCXLWaug
WGAfwPldK+RUk8kNWakPDyHvBijKY9lJb/It7HMGH//C5axQipvRT7sl0UbeZHle
HwPGI/vAXKdicmfZHfAOzmiPbZhccg9hMrqgTeB4dPQ2wpJvcQ61ke+LZPR9FEFf
vpcxD6DcFO8KqSDNOZGf9dIkJNNvfPtPctAGiestTJpb0u3bcFHs6Oo4NUpU7pM2
buSE8lRl84mkwFPlx/w1NdPyTKUoadImfn2BORw49SXZ/xNspTVpV21M1tRhHNo1
7U/a1AU/vBAnMY08/o71jc95rB07BAlMMv/e5RiWN+0ZZTDV6cXnyrFKNPKvcBP2
xpZ8Kta3rkp7J8xaOxNY
=cgYR
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
