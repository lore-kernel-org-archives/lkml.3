Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962AbaFRKFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:05:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52157 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965376AbaFRKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:05:45 -0400
Date: Wed, 18 Jun 2014 12:04:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 09/20] clk: sunxi: Add sun6i MBUS clock support
Message-ID: <20140618100404.GM19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-10-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YS7t75H5cNTCpbja"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-10-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YS7t75H5cNTCpbja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:46PM +0800, Chen-Yu Tsai wrote:
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>  drivers/clk/sunxi/clk-sunxi.c                     | 44 +++++++++++++++++=
++++++
>  2 files changed, 45 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index b9ec668..7b2ba41 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -40,6 +40,7 @@ Required properties:
>  	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
>  	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>  	"allwinner,sun4i-a10-mod0-clk" - for the module 0 family of clocks
> +	"allwinner,sun6i-a31-mbus-clk" - for the MBUS clocks on A31 / A23
>  	"allwinner,sun7i-a20-out-clk" - for the external output clocks
>  	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
>  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index eca3c6e..a086b5b 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -307,6 +307,37 @@ static void sun4i_get_mod0_factors(u32 *freq, u32 pa=
rent_rate,
> =20
> =20
>  /**
> + * sun6i_a31_get_mbus_factors() - calculates m factor for MBUS clocks
> + * MBUS rate is calculated as follows
> + * rate =3D parent_rate / (m + 1);
> + */
> +
> +static void sun6i_a31_get_mbus_factors(u32 *freq, u32 parent_rate,
> +				       u8 *n, u8 *k, u8 *m, u8 *p)
> +{
> +	u8 div;
> +
> +	/* These clocks can only divide, so we will never be able to achieve
> +	 * frequencies higher than the parent frequency */
> +	if (*freq > parent_rate)
> +		*freq =3D parent_rate;
> +
> +	div =3D DIV_ROUND_UP(parent_rate, *freq);
> +
> +	if (div > 8)
> +		div =3D 8;
> +
> +	*freq =3D parent_rate / div;
> +
> +	/* we were called to round the frequency, we can now return */
> +	if (n =3D=3D NULL)

s/n/m/ ?

> +		return;
> +
> +	*m =3D div - 1;
> +}
> +
> +
> +/**
>   * sun7i_a20_get_out_factors() - calculates m, p factors for CLK_OUT_A/B
>   * CLK_OUT rate is calculated as follows
>   * rate =3D (parent_rate >> p) / (m + 1);
> @@ -447,6 +478,11 @@ static struct clk_factors_config sun4i_mod0_config =
=3D {
>  	.pwidth =3D 2,
>  };
> =20
> +static struct clk_factors_config sun6i_a31_mbus_config =3D {
> +	.mshift =3D 0,
> +	.mwidth =3D 3,

Actually, the A31 has an extra N factor.

So this mbus clock looks like it's only about the A23, and not the A31
at all.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--YS7t75H5cNTCpbja
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToWQUAAoJEBx+YmzsjxAgIdEP/1gAozfujWyTTDlj3feS84m0
HgRkqz7DMEbZ6Nr0rN2QQCAEx03d1qsCCMkQLQHR9FD2Lq+Oc1DSlYtY1e/j1HiO
Dzxm2OVoPaTCEHiPttzg/TSziF6OquHyPFDGGm/9ZOhTw4LneeY93P6Mo4Br6qfL
fXnc06L7cqp+EYh+Nfn/ah7AbP3Yysc6/kQfFYi/MWs9PM2pIMcEWL4mD+6gG9Zh
iuCwZ06t1o7a3gFBeX1lOgIl3M3qPtFc3C/R9+k/mgOEx/9h953S93JAU3ZxbWMB
l4yZ8sp6uQVwjQDvLyowVTc8cLNZgUuVaAStioxV6JnYdcpEta0JoPBNvriNvaj0
ayZhcyB5u/Chow0gSl36BBiaRpclPaIvRoHXelS0WSgaUVEl1mRnIRwK9QGRUlc7
a6WZo7hKEXOeDEHeeokE++/3IqwbueCVfeQmBX893mSoLzlaiRliYzwbAzZLdUT3
CSvgA/t7h2JsggpC4Q8hOFCcuyYSTGxpUGI8RtQq9U0qaaIyc+isxgML9xuDnnVi
mTcXJfPa/UIrY3hEtge5E0zXHw/+xdz20Cd5/qsTWUJEOwfqpgmQaFVcfjbswM3V
l4KJu2x5bp2T9HSWjNxRYeDK/4Mf8h7E6fTZz40tK9zT93rx0XAJjgV8FN6LH0Fq
ykj3fIdB/tq0YoqOVUQr
=LZTy
-----END PGP SIGNATURE-----

--YS7t75H5cNTCpbja--
