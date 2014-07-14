Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaGNMOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:14:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56358 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaGNMOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:14:33 -0400
Message-ID: <53C38DC1.30000@pengutronix.de>
Date: Mon, 14 Jul 2014 09:58:57 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com
CC: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] can: flexcan: switch on clocks before accessing
 ecr register
References: <cover.1405322992.git.stefan@agner.ch> <3901272074d5a3e680a7ecfda3ffbfca4c544a86.1405322992.git.stefan@agner.ch>
In-Reply-To: <3901272074d5a3e680a7ecfda3ffbfca4c544a86.1405322992.git.stefan@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="i3T4gntv4Fq0I0IPKodMOOqI8jfQA7H5s"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i3T4gntv4Fq0I0IPKodMOOqI8jfQA7H5s
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/14/2014 09:48 AM, Stefan Agner wrote:
> Reported-by: Ashutosh Singh <ashuleapyear@gmail.com>
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [stefan@agner.ch: added return check for clk_enable_prepare]
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/net/can/flexcan.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index f425ec2..4c598c9 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -383,11 +383,25 @@ static int flexcan_get_berr_counter(const struct =
net_device *dev,
>  {
>  	const struct flexcan_priv *priv =3D netdev_priv(dev);
>  	struct flexcan_regs __iomem *regs =3D priv->base;
> -	u32 reg =3D flexcan_read(&regs->ecr);
> +	u32 reg, err;
> +
> +	err =3D clk_prepare_enable(priv->clk_ipg);
> +	if (err)
> +		return err;
> +
> +	err =3D clk_prepare_enable(priv->clk_per);
> +	if (err)
> +		goto out_disable_ipg;
> +
> +	reg =3D flexcan_read(&regs->ecr);
> =20
>  	bec->txerr =3D (reg >> 0) & 0xff;
>  	bec->rxerr =3D (reg >> 8) & 0xff;
> =20
> +	clk_disable_unprepare(priv->clk_per);
> + out_disable_ipg:
> +	clk_disable_unprepare(priv->clk_ipg);
> +
>  	return 0;

You should return an error in case of an error.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--i3T4gntv4Fq0I0IPKodMOOqI8jfQA7H5s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPDjcUACgkQjTAFq1RaXHOOHACfWqdED8RAkQxwBLuTUJW0/klr
IRUAni3MhVqNxA87wIKJ/vm7dFpHZa5A
=KxAf
-----END PGP SIGNATURE-----

--i3T4gntv4Fq0I0IPKodMOOqI8jfQA7H5s--
