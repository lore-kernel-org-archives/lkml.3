Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3CPEPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 00:15:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab3CPEPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 00:15:39 -0400
Message-ID: <1363407324.3937.169.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 11/21] hwmon: (sht15) Check return value of regulator_enable()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Date: Sat, 16 Mar 2013 04:15:24 +0000
In-Reply-To: <20130312223246.431610777@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223246.431610777@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MZ4JAE29NoGdYHAJaIXA"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MZ4JAE29NoGdYHAJaIXA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
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

> ---
>  drivers/hwmon/sht15.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct
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

Since this has now been released, I think you need this follow-up fix in
3.0.y and 3.4.y:

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
It is easier to change the specification to fit the program than vice versa=
.

--=-MZ4JAE29NoGdYHAJaIXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUPx3Oe/yOyVhhEJAQoiQxAAvM6gRkSr8Edn7PBT8ue0mPUVXPL5Oaq0
9MtVEmNqr45qXYU8ftYu0iqkiwR0MtWgCghgyK2PNb7iWKY+k7cWKsBCI6oMhJ6o
LVHPVVemGi8wtBsdPwfqwQFXmE1QqRcDAangcZzOEzo2lLE5Wfd3I7Rv5xqTWTN4
rhcbP2lPcBTB91kwn9PNaimQ6xAKAquMnIoeNliN/QDvXYUuU1FUPUL4uEDATvhc
oj0BLTbCMZLlt5Z9iLpUqm7qqlwmhvNQqHR29m1Bw9QzKtx00POoOR5NnBTnBk64
0KhVKrjyIMe6hDucjl0s2rchsdkI+1ri1aM0kRJI2mYoKSfvqL9qSLMsYwK/ypwU
gTW1aKX5+GSmuOHZKfYO57fgrkcX03wAJhUJuikwnuiIhC9bXUDOhjXcd22bpKg6
OVwScuf+yMsdaVgboJhIYn51EdmkaX1hQsuJN2p+aHhcwpHLjJmDE0I4dIZsz2dE
PBRX/YJ/lTQB+ybnD/rBKLhbr1bZcgDDba3X19h4gNYc610x4ueM6WmdMrdW2Fsz
4WMBpjkfRGamEKep2p4dZGQ/lgy2S0PPpPd9qs0+Q5xnFKPOFNLFQOjvmaimL/vB
p1iG0L/s5lJ8XKeHTIiIku9Eiwa3k6dDlzgyBlVgJQ4T62wpyUQUBmoU4IpimNBa
OaovtrVVjJc=
=4yiY
-----END PGP SIGNATURE-----

--=-MZ4JAE29NoGdYHAJaIXA--
