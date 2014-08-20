Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaHTKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:04:55 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:33482 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaHTKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:04:52 -0400
Date: Wed, 20 Aug 2014 12:04:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] pwm: rockchip: Allow polarity invert on rk3288
Message-ID: <20140820100447.GG15414@ulmo>
References: <1408464476-28316-1-git-send-email-dianders@chromium.org>
 <1408464476-28316-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zrag5V6pnZGjLKiw"
Content-Disposition: inline
In-Reply-To: <1408464476-28316-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zrag5V6pnZGjLKiw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 09:07:54AM -0700, Doug Anderson wrote:
> The rk3288 has the ability to invert the polarity of the PWM.  Let's
> enable that ability.
>=20
> To do this we increase the number of pwm_cells to 3 to allow using the
> PWM_POLARITY_INVERTED flag.  Since the PWM driver on rk3288 is very
> new, I thought this was OK.

I don't see any files in arch/arm/boot/dts using either of the
rockchip,vop-pwm or rockchip,rk3288-pwm compatible strings, so there's
no reason to consider this stable ABI yet. As far as I'm concerned the
last sentence can just as well be dropped.

Besides, patches have been posted to support #pwm-cells =3D <2> and
#pwm-cells =3D <3> at the same time which should give you backwards-
compatibility for free.

A couple more comments inline.

> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
[...]
> +int rockchip_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *=
pwm,
> +			      enum pwm_polarity polarity)

This should be static.

> +{
> +	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> +
> +	if (!pc->data->has_invert)
> +		return -ENOSYS;
> +
> +	/*
> +	 * No action needed here because pwm->polarity will be set by the core
> +	 * and the core will only change polarity when the PWM is not enabled.
> +	 * We'll handle things in set_enable().
> +	 */
> +
> +	return 0;
> +}

An alternative here would be to provide a separate pwm_ops with
=2Eset_polarity =3D NULL for the versions of the IP block that don't support
polarity inversion yet, but this works for me too.

> @@ -173,6 +201,7 @@ static const struct rockchip_pwm_data pwm_data_v2 =3D=
 {
>  		.ctrl =3D 0x0c,
>  	},
>  	.prescaler =3D 1,
> +	.has_invert =3D true,
>  	.set_enable =3D rockchip_pwm_set_enable_v2,
>  };
> =20
> @@ -184,6 +213,7 @@ static const struct rockchip_pwm_data pwm_data_vop =
=3D {
>  		.ctrl =3D 0x00,
>  	},
>  	.prescaler =3D 1,
> +	.has_invert =3D true,
>  	.set_enable =3D rockchip_pwm_set_enable_v2,
>  };

Can you please add a '.has_invert =3D false,' line to pwm_data_v1? I know
it's not strictly necessary but I like it when things are explicitly
stated.

> =20
> @@ -230,6 +260,10 @@ static int rockchip_pwm_probe(struct platform_device=
 *pdev)
>  	pc->chip.ops =3D &rockchip_pwm_ops;
>  	pc->chip.base =3D -1;
>  	pc->chip.npwm =3D 1;
> +	if (pc->data->has_invert) {

There should be a blank line between the above two.

Thierry

--Zrag5V6pnZGjLKiw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9HK/AAoJEN0jrNd/PrOhuccP/31Ez0el2Hd68TZzS86HnJWv
T8YRQFdLPF6J0fokJzpY8GswxrJRrlJsM0qWtqiEzIWJahiEoeTjHOcDSujknXME
02fqbtJEdshgfiMYm4lrbhLtHVU0EOcnJeOWb5U2FFx8vOhvLrhtnp7ggNum954k
yPplJK2j5po6ECJdGL9jiL7Vy3RIfFBP2rwP3YT8ZqeRAiKZLBrCUGxxYjPUL92C
Bhu4slC8PFjmv33tFKcZWCDjEuRHIG8I4hldvcPEfD9CrLNGf/p+hDY0RtbCpp2U
pBF+xQYvTy9vZCZ7eZKExZ24F1M81dfqX2odFK8b8vXi0Bm1jHsovqp87UIGSmTw
lHdzNVpQC5rTF4Niw/ayLlYg6lj4LqAXSQ4ynloKwLsaXD60O0TZQ2ouukPU8M12
Ayzy76cq7wkBBRiT6FlzDzulmy29UUY0OE1PHcSIY+xF1K6d2/HHY8t+bmSaFjdk
EN/KxDS24N6rRMyAEWmmA2aUNhhV1rddr7PSrqHhvwKk099aSowNeQckHDEj97Qy
Tc/tWDNyiui5FoFlkXGW3ZXaU8l3VA6a9Ax4Ekt33b0OHyiIttRdXcv7bXnolqxy
o3HyTDRTJjmyuuXfaB/+7bh3d4fPjf5ubveupa+lTtT0iJP6LDfwXQpqQNFWYLSw
Dnyx69rwEhtA+LJ/q5LH
=qZJI
-----END PGP SIGNATURE-----

--Zrag5V6pnZGjLKiw--
