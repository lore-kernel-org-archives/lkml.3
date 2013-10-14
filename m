Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3JNUuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:50:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35361 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758495Ab3JNUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:50:13 -0400
Date: Mon, 14 Oct 2013 21:32:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Victor N. Ramos Mello" <victornrm@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: clk: sunxi: Fix memory leakage in
 clk-sunxi.c
Message-ID: <20131014193201.GT3041@lukather>
References: <1381615554-4167-1-git-send-email-victornrm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CYcXvPfqKSDi0QhV"
Content-Disposition: inline
In-Reply-To: <1381615554-4167-1-git-send-email-victornrm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CYcXvPfqKSDi0QhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Victor,

On Sat, Oct 12, 2013 at 07:05:54PM -0300, Victor N. Ramos Mello wrote:
> From: "Victor N. Ramos Mello" <victornrm@gmail.com>
>=20
> Fix a possible memory leak in sun4i_osc_clk_setup().
> Moved clock-frequency check to save superfluous allocation.
>=20
> Signed-off-by: Victor N. Ramos Mello <victornrm@gmail.com>
> ---
>  drivers/clk/sunxi/clk-sunxi.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 34ee69f..a741770 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -38,18 +38,16 @@ static void __init sun4i_osc_clk_setup(struct device_=
node *node)
>  	const char *clk_name =3D node->name;
>  	u32 rate;
> =20
> +	if (of_property_read_u32(node, "clock-frequency", &rate))
> +		return;
> +
>  	/* allocate fixed-rate and gate clock structs */
>  	fixed =3D kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
>  	if (!fixed)
>  		return;
>  	gate =3D kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
> -	if (!gate) {
> -		kfree(fixed);
> -		return;
> -	}
> -
> -	if (of_property_read_u32(node, "clock-frequency", &rate))
> -		return;
> +	if (!gate)
> +		goto err_gate;
> =20
>  	/* set up gate and fixed rate properties */
>  	gate->reg =3D of_iomap(node, 0);
> @@ -67,7 +65,11 @@ static void __init sun4i_osc_clk_setup(struct device_n=
ode *node)
>  	if (!IS_ERR(clk)) {
>  		of_clk_add_provider(node, of_clk_src_simple_get, clk);
>  		clk_register_clkdev(clk, clk_name, NULL);
> +		return;
>  	}
> +	kfree(gate);
> +err_gate:
> +	kfree(fixed);

While the patch is appreciated, I find the logic here a bit backward
compared to what's usually done.

I'd rather see here something like

if (IS_ERR(clk))
	goto err_gate;

of_clk_add_provider(...);
clk_register_clkdev(...);

return;

err_gate:
	kfree(gate);
err_fixed:
	kfree(fixed);

But maybe it's just me.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CYcXvPfqKSDi0QhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSXEawAAoJEBx+YmzsjxAgL+0P/ijac0Up8MZuDpulTHLqq06h
yOiWbMnhK2sT10VenlPiUX634tnQOexIYPKrmGGlNHqiIcVvbUOO+uiH8PJ+Qizf
hbZSjxEDaHaKdVx9VN8SoJ+ED3qrCPJX+q9Ml1e87l3V3JKuzthI9twYt4o31HkF
bsMpIFsp79FbGKq296ombcZ5ToLQSEWhqq2/HgOjNWcc6IDWR7ceTAQ7TGR0rVP0
ZvZ0j9S6ptrash+iRFWIWvrIMLGLn4zlTQSh6V3ooh30y2xNw2X1YrZXb5IjNUof
w0GrEFPgXhWt9CokuMs2GG/JEb+AqCmImSpbAip7nCJpLhpLqvtQJfAguAk6J769
uRLTck0R2PhPIdRDQq1J8s7H+hx/1BX+rVEWwc41Ut4nsAHAhkSqy3UwzblzN1YR
CMct84ZhOi5IxpPeCX6Z9ug4smkMXB0Yg5og5KfiPD26N3Tncf+DV06M26wGo0A8
4ymThY8Spak3Wxwn822M2RAkxBN1uV1caNi1PsL99GW1vYJDW1F+oZbU1WedxRAT
E+H1HHSgObpYgFslqUxBWH0j5j/5HkiqjzOUdyo1wRp2DuHECF4vxZI5/AjI06ON
ldQDQOnB51omzC4SFKm1ZJ97hWCJVanrGbOlLYLgEZpo7ElV2ZBCt1K4IjMo3dhO
2T3g+//UTlD5m5iQRa2O
=eYVQ
-----END PGP SIGNATURE-----

--CYcXvPfqKSDi0QhV--
