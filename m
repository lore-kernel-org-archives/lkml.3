Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaHSHTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:19:05 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61024 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaHSHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:19:03 -0400
Date: Tue, 19 Aug 2014 09:18:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] pwm: rockchip: Allow polarity invert on rk3288
Message-ID: <20140819071857.GD12859@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Content-Disposition: inline
In-Reply-To: <1408381749-14156-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 10:09:07AM -0700, Doug Anderson wrote:
[...]
> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
>  #define PWM_LP_DISABLE		(0 << 8)
> =20
> @@ -32,6 +34,7 @@ struct rockchip_pwm_chip {
>  	struct pwm_chip chip;
>  	struct clk *clk;
>  	const struct rockchip_pwm_data *data;
> +	enum pwm_polarity polarity;

Why do you need this field? struct pwm_device already has a copy of it.

> @@ -74,10 +78,14 @@ static void rockchip_pwm_set_enable_v2(struct pwm_chi=
p *chip, bool enable)
>  {
>  	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
>  	u32 enable_conf =3D PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
> -			  PWM_CONTINUOUS | PWM_DUTY_POSITIVE |
> -			  PWM_INACTIVE_NEGATIVE;
> +			  PWM_CONTINUOUS;
>  	u32 val;
> =20
> +	if (pc->polarity =3D=3D PWM_POLARITY_INVERSED)
> +		enable_conf |=3D PWM_DUTY_NEGATIVE | PWM_INACTIVE_POSITIVE;
> +	else
> +		enable_conf |=3D PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;

I have a feeling you're going to answer the above question with: "Because
it's needed here". If so, my reply would be: "Then this function should
take a struct pwm_device instead of struct pwm_chip."

> @@ -173,6 +195,7 @@ static const struct rockchip_pwm_data pwm_data_v2 =3D=
 {
>  		.ctrl =3D 0x0c,
>  	},
>  	.prescaler =3D 1,
> +	.has_invert =3D 1,

Since has_invert is a boolean, the proper value here would be "true".

> @@ -228,6 +252,10 @@ static int rockchip_pwm_probe(struct platform_device=
 *pdev)
>  	pc->data =3D id->data;
>  	pc->chip.dev =3D &pdev->dev;
>  	pc->chip.ops =3D &rockchip_pwm_ops;
> +	if (pc->data->has_invert) {
> +		pc->chip.of_xlate =3D of_pwm_xlate_with_flags;
> +		pc->chip.of_pwm_n_cells =3D 3;
> +	}
>  	pc->chip.base =3D -1;
>  	pc->chip.npwm =3D 1;

I suggest to rewrite the above as follows for readability:

 	pc->data =3D id->data;
 	pc->chip.dev =3D &pdev->dev;
 	pc->chip.ops =3D &rockchip_pwm_ops;
 	pc->chip.base =3D -1;
 	pc->chip.npwm =3D 1;
+
+	if (pc->data->has_invert) {
+		pc->chip.of_xlate =3D of_pwm_xlate_with_flags;
+		pc->chip.of_pwm_n_cells =3D 3;
+	}

Thierry

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8vphAAoJEN0jrNd/PrOhNqAQAKjhdIO0mRKBlcuqjV+55gGa
ZjSeGG/zLHhxCjn9OP9HEqEnPqT8q46beRO7LfpewQLqX7avnirGHHcx4bTV7Myf
RyvPqtwEIwz7Z4/NCrbqI/EDTDnyue+wEzkIdsvOa4YRjqWHSA5rI1BLjo2lFYAo
l1ism4Bl3XDnr1PhTWsZztOkivCTUkMkGuLaLoDEIzDD7Dw5ul+U4mQP7POACFfm
NObvxsFn3yUFexeAIB1pib7hWL2NI8oOPUfnBiLg1hdRR9vVFeDbqQoM5yGBpKJU
yGipps4fyxsoqpfTsD9k4WNwcfY+34jF6vTfUSHkUv2qSOBp7viWWcXLUKsK7Izx
VWz6G3cWrpPK9gQO/w1awRVVEhbIb1CsK889YIl9Ak9WQFSvYSxYsqtSLQAJloEW
j+zxg8Gzsrib2nfqzUsrqjRYqoY1oS89u4/xOYqNvECkEeMCDQhLvGl+R1XdCoYK
p3aXb16F+GdZpmmlrwP0CJNUr4wRKWqnMjqDjC0b7VbqHdlSWDpH5Xu0OPNv8XSB
HYiDMx94tTc2KWNLIQbEqnM1Txjj+EPnJbiBuwVDiHO/f2yvqyVZNB5RNbUaEUN9
ATpZg3jE0j2B9iUmkGew95S8DQmT8lTpd+6J+JgkPpijjKTwfGMMHNxMJvdTq0Zx
sgyZA5HIusA8oEMXFQ4L
=FxyI
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
