Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaDOPwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:52:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33375 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaDOPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:52:50 -0400
Date: Tue, 15 Apr 2014 10:50:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Joachim Eastwood <manabian@gmail.com>
Subject: Re: [PATCH] crypto: omap-des - handle error of pm_runtime_get_sync
Message-ID: <20140415155031.GA14623@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397575982-24866-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1397575982-24866-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 15, 2014 at 10:33:02AM -0500, Nishanth Menon wrote:
> pm_runtime_get_sync may not always succeed depending on SoC involved. So
> handle the error appropriately.
>=20
> Reported-by: Joachim Eastwood <manabian@gmail.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>=20
> based on v3.15-rc1
>=20
> Report-thread: http://marc.info/?t=3D139750330400002&r=3D1&w=3D2
>=20
> omap2plus_defconfig + CONFIG_CRYPTO_DEV_OMAP_DES=3Dy
>=20
> pandaboard-es-before: http://slexy.org/raw/s21rGPFnKl
> pandaboard-es-after:  http://slexy.org/raw/s2A4UFQVna
>=20
>  drivers/crypto/omap-des.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index ec5f131..c2d362f 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -223,12 +223,18 @@ static void omap_des_write_n(struct omap_des_dev *d=
d, u32 offset,
> =20
>  static int omap_des_hw_init(struct omap_des_dev *dd)
>  {
> +	int err;
> +
>  	/*
>  	 * clocks are enabled when request starts and disabled when finished.
>  	 * It may be long delays between requests.
>  	 * Device might go to off mode to save power.
>  	 */
> -	pm_runtime_get_sync(dd->dev);
> +	err =3D pm_runtime_get_sync(dd->dev);
> +	if (err < 0) {
> +		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
> +		return err;

even when get() fails, you must put().

> +	}
> =20
>  	if (!(dd->flags & FLAGS_INIT)) {
>  		dd->flags |=3D FLAGS_INIT;
> @@ -1083,7 +1089,11 @@ static int omap_des_probe(struct platform_device *=
pdev)
>  	dd->phys_base =3D res->start;
> =20
>  	pm_runtime_enable(dev);
> -	pm_runtime_get_sync(dev);
> +	err =3D pm_runtime_get_sync(dev);
> +	if (err < 0) {
> +		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
> +		goto err_get;

this leaves usage_count incremented, needs a put() here too.

--=20
balbi

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTVVHAAoJEIaOsuA1yqREmL0P/3a9sO75yi3MROr/hCkuXFT/
MN43QrSa++nhMScNUMYO+lWNXWFcDrsTBD0qDDOlnlv95rcDJDPn0Inz3dZr9wO6
P55vlvoZQKBZmY4sfKu2iv5aT9fZTWZN37x4L4H/h92I+PPXx7XDtghd/r++t/Pz
2/bshxwKy12XtwwoiczRhuBZVQgRQMMn1SOEnewCg6I9SPZVPgYYmmx20owfOrzE
Ba6i/JHSKi/ZqVJp54TlaQqZzlIMHjdrpjTEEA4cz7qnUtOxlNJXzHdJ6SO5Z1C8
pL07MkzmzO994PLX8VLXiM69CLjCIFt5g8rZal4RWZmdsYBEw8duaqEdXxreIKRv
wDdRGUVfacPKt+S1kkVssujPfeexrb4fUuCa+jWgBATgTAoCWR8ZgLpJ49YLb981
kP49l9uqDZjXpGtJSROvfrAqyUkwRz4ngUKsqhfhjPMON1ybzh5HbZf+uGwArtl+
fykbJex4RyugOuHH/Mhtw+wkaBXX/rzbngTO0DajdoHAL0o/MIrsnC3w7jEl49U7
mqgSiP5Oel3jsv58uY7T+DlRenHrUaj5zPDldmIUGWJJWHZw82nLFqjPmTaJ2A2S
iljfS6dY4EhVLKVdY6DP/tuMSJPqHqvmxXoC18qc9K7J95gQMcz5HE7z6eXfFISF
4ZEerdCaw2RTOQTgfO2g
=xXm8
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
