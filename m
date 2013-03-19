Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3CSDBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:01:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab3CSDA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:00:58 -0400
Message-ID: <1363662049.3937.363.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 66/88] hwmon: (sht15) Check return value of
 regulator_enable()
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Date: Tue, 19 Mar 2013 03:00:49 +0000
In-Reply-To: <1363257381-15900-67-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
	 <1363257381-15900-67-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-99rxbI6XNx7lVBiPWHe9"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-99rxbI6XNx7lVBiPWHe9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 10:35 +0000, Luis Henriques wrote:
> 3.5.7.8 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.
>=20
> Not having power is a pretty serious error so check that we are able to
> enable the supply and error out if we can't.
>=20
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  drivers/hwmon/sht15.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index 8b011d0..eb01802 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct platform_dev=
ice *pdev)
>  		if (voltage)
>  			data->supply_uV =3D voltage;
> =20
> -		regulator_enable(data->reg);
> +		ret =3D regulator_enable(data->reg);
> +		if (ret !=3D 0) {
> +			dev_err(&pdev->dev,
> +				"failed to enable regulator: %d\n", ret);
> +			return ret;
> +		}
> +
>  		/*
>  		 * Setup a notifier block to update this if another device
>  		 * causes the voltage to change

This needs the same fix-up as in 3.4.y:

---
From: Ben Hutchings <ben@decadent.org.uk>
Subject: hwmon: sht15: Fix memory leak if regulator_enable() fails
Date: Sat, 16 Mar 2013 04:11:01 +0000

Commit 3e78080f8148 ('hwmon: (sht15) Check return value of
regulator_enable()') depends on the use of devm_kmalloc() for automatic
resource cleanup in the failure cases, which was introduced in 3.7.  In
older stable branches, explicit cleanup is needed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -930,7 +930,7 @@
 		if (ret !=3D 0) {
 			dev_err(&pdev->dev,
 				"failed to enable regulator: %d\n", ret);
-			return ret;
+			goto err_free_data;
 		}
=20
 		/*

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-99rxbI6XNx7lVBiPWHe9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUfU4ee/yOyVhhEJAQrxnRAAoYoe1PcTwCNKkgAx/hPWhWdWfZtLjb0o
isxjY9FJPLhgijaTwfklspKmVC2iUAnRCMaDgTyNabzVQCwvnRUyDDwa7mFCgidM
/VBFj93p3Nct9rOD9k4hTqs37I+IzfgjilMg+xAATaa8lZ5xQMHMqhQlrbS7Bmad
GT8/2pmeBz1IyS0WoncPivDuVLekA9dovNWl+jSnCnm7pLWA0k73k1F+YztyF5+0
gmgQas159S3br6NNM5acAd13gfx0HjXv2m0NAaRjjTjvBHjRGU8PMl+TNE3mmfeT
30uS+tCippw8iIbcI8ulyzs/64qmfw0hBBVFmCs0at8AFmsrM4nmu/jDLTBKlUDu
NkHxJJmA3EzgjYhRDRRsXd6S1sJNsSlus9HimpNJML0C8CJ1C161j/X87Y9T3q1D
CFJJ5ZXj4FZfdNRl3HEtQgxcW6wk3JVRP+KtMvUsMUbp0MKjlx1hWdFQ4snrARaP
NHhLRzlA4yVP5qKU+V22f44gcAaFdPZ3Z5Zx7gOYj6M+gCRxXkjdzV+VcwnfZato
n+H/XB3IabaSaJPGsfNwvKIaL8KpnhbCL3TbkLyzs0o1lalGY45+Nr1QUjeeBADE
b0/HT6krxN6qeEt+FY1qbHynPS6lovzlD5w1+oeOKA4ZOPJF5pq1loosOLTvGw1O
lXfIqFpVHZw=
=fPe3
-----END PGP SIGNATURE-----

--=-99rxbI6XNx7lVBiPWHe9--
