Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaFVK4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:56:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaFVK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:56:43 -0400
Message-ID: <53A6B658.6030709@pengutronix.de>
Date: Sun, 22 Jun 2014 12:56:24 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: c_can: convert to use devm * api
References: <1403265574-12923-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1403265574-12923-1-git-send-email-prabhakar.csengg@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fgMfhWC7AtGXTHDrHh2UnqpNvTOg1N88w"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fgMfhWC7AtGXTHDrHh2UnqpNvTOg1N88w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/20/2014 01:59 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>=20
> this patch uses devm_* APIs as they are device managed
> and make code simpler.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks for the patch. Applied to can-next with minor change (see inline).=


> ---
>  Note: This patch is compile tested only.
> =20
>  drivers/net/can/c_can/c_can_platform.c | 41 ++++++++------------------=
--------
>  1 file changed, 9 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c=
_can/c_can_platform.c
> index 1df0b32..e0dcbcf 100644
> --- a/drivers/net/can/c_can/c_can_platform.c
> +++ b/drivers/net/can/c_can/c_can_platform.c
> @@ -157,40 +157,31 @@ static int c_can_plat_probe(struct platform_devic=
e *pdev)
>  	}
> =20
>  	/* get the appropriate clk */
> -	clk =3D clk_get(&pdev->dev, NULL);
> +	clk =3D devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(clk)) {
> -		dev_err(&pdev->dev, "no clock defined\n");
> -		ret =3D -ENODEV;
> +		ret =3D PTR_ERR(clk);
>  		goto exit;
>  	}
> =20
>  	/* get the platform data */
>  	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	irq =3D platform_get_irq(pdev, 0);
> -	if (!mem || irq <=3D 0) {
> -		ret =3D -ENODEV;
> -		goto exit_free_clk;
> -	}
> -
> -	if (!request_mem_region(mem->start, resource_size(mem),
> -				KBUILD_MODNAME)) {
> -		dev_err(&pdev->dev, "resource unavailable\n");
> +	if (irq <=3D 0) {
>  		ret =3D -ENODEV;
> -		goto exit_free_clk;
> +		goto exit;
>  	}
> =20
> -	addr =3D ioremap(mem->start, resource_size(mem));
> -	if (!addr) {
> -		dev_err(&pdev->dev, "failed to map can port\n");
> -		ret =3D -ENOMEM;
> -		goto exit_release_mem;

I've moved the mem =3D platform_get_resource() for slightly better
readability here....

> +	addr =3D devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(addr)) {
> +		ret =3D  PTR_ERR(addr);
> +		goto exit;
>  	}

Thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--fgMfhWC7AtGXTHDrHh2UnqpNvTOg1N88w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlOmtlsACgkQjTAFq1RaXHNXSgCfQi30zV/CnoMzok0XdmLDaAED
gaUAn2UX++T09aAp1w/KiL4CMBSirhD6
=c4pQ
-----END PGP SIGNATURE-----

--fgMfhWC7AtGXTHDrHh2UnqpNvTOg1N88w--
