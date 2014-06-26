Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbaFZKs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:48:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57322 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaFZKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:48:58 -0400
Message-ID: <53ABFA90.3020409@ti.com>
Date: Thu, 26 Jun 2014 13:48:48 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/video/fbdev : dereference without an error test
References: <20140621155758.GA4741@himangi-Dell>
In-Reply-To: <20140621155758.GA4741@himangi-Dell>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="N0QHDF1qoNWI64slHb5Nom3M9f5GEXlDb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N0QHDF1qoNWI64slHb5Nom3M9f5GEXlDb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/06/14 18:57, Himangi Saraogi wrote:
> After a variable is assigned the result of backlight_device_register, a=
n
> error test should be performed before a dereference.
>=20
> A simplified version of the semantic match that finds this problem is
> as follows:
>=20
> // <smpl>
> @def0@
> expression x;
> position p0;
> @@
>=20
> x@p0 =3D backlight_device_register(...)
>=20
> @protected@
> expression def0.x,E;
> position def0.p0;
> position p;
> statement S;
> @@
> x@p0
> ... when !=3D x =3D E
> if (!IS_ERR(x) && ...) {<... x@p ...>} else S
>=20
> @unprotected@
> expression def0.x,E;
> identifier fld;
> position def0.p0;
> position p !=3D protected.p;
> @@
> x@p0
> ... when !=3D x =3D E
> * x@p->fld
> // </smpl>
>=20
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c | 5 ++++=
+
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/video/fbdev/omap2/displays-new/panel-sony-acx565ak=
m.c b/drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c
> index c7ba4d8..acd9ff1 100644
> --- a/drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c
> +++ b/drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c
> @@ -817,6 +817,10 @@ static int acx565akm_probe(struct spi_device *spi)=

> =20
>  	bldev =3D backlight_device_register("acx565akm", &ddata->spi->dev,
>  			ddata, &acx565akm_bl_ops, &props);
> +	if (IS_ERR(bldev)) {
> +		r =3D PTR_ERR(bldev);
> +		goto err_reg;
> +	}
>  	ddata->bl_dev =3D bldev;
>  	if (ddata->has_cabc) {
>  		r =3D sysfs_create_group(&bldev->dev.kobj, &bldev_attr_group);
> @@ -862,6 +866,7 @@ err_reg:
>  	sysfs_remove_group(&bldev->dev.kobj, &bldev_attr_group);
>  err_sysfs:
>  	backlight_device_unregister(bldev);
> +err_reg:
>  err_detect:
>  err_gpio:
>  	omap_dss_put_device(ddata->in);

Thanks. This didn't compile, as there already was a "err_reg" label
defined. I fixed the issue, and queued for 3.17.

 Tomi



--N0QHDF1qoNWI64slHb5Nom3M9f5GEXlDb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTq/qQAAoJEPo9qoy8lh71uAAP/io6HDUMovPwE4R0YpFgEON+
v+IavEfObt7Scw5NkPUcQ04J2yCN3fjICFaKdtd8pFWeH/0cUu78UYyQs+1yoNsC
W5N8cXMp3yxjE4GHR3KQ1EHtVGi1xZXtusudVj6hlCCxkKSungr4veOJZsRwp4oL
trUfO3Fus7AHcf/S5qWu01mjFdEQYazWV5CHJODpomTk7lDn3ZCecoliM811EVIF
rAuLSkPCzPnpUKPt/Eol9z5ARNAQumcQjN54GzFxuswMUhoNLgBnNC1obrw6drdH
8uOBnMRE3lueOBA+vQ/Q6gF/pr6UTeX06D76PhDAcB3JJQAJwxSqMB2uZlt1dX0X
sf7HvGJX3AJwlZdzvA6I7V3xgF5+fzc+SNLieTtAMGIGBJIq9JZ9qcupO1GZWLPw
y9PBjRoxBcKk7lQzg7xDgm9CisGcsLeyr8fSFOxeTLJfvGdGgEOszyICea6Dh8G3
GoszEm+r2QdlRQ1WEx/fLakWxyg4KA/A1hRm4KDoH0fSMYC+3GYM8KJLHsmdEjVn
2YYP2LwUuGgJlwMVPy1q1J6c0YWuuqU9xco9kdqPBbmg1N2NuldiDQOAoi5TtWN7
yNvUUoC7NvZJE+/owEw3jHK1vx1tzTfzB3bKQDHDJlOkcyqUbavoIuIsRLjgHz+H
NfcJBfLe5d/JVAyDzMkK
=OIX3
-----END PGP SIGNATURE-----

--N0QHDF1qoNWI64slHb5Nom3M9f5GEXlDb--
