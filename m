Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3BFR4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:56:43 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:42284 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3BFR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:56:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Date: Wed, 6 Feb 2013 18:56:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-23-generic; KDE/4.9.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com> <201302032101.54487@pali> <20130203200557.GA15430@lizard.gateway.2wire.net>
In-Reply-To: <20130203200557.GA15430@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2346359.ABUyHrso7C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302061856.35366@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2346359.ABUyHrso7C
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 03 February 2013 21:05:57 Anton Vorontsov wrote:
> On Sun, Feb 03, 2013 at 09:01:54PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 03 February 2013 04:44:51 Anton Vorontsov wrote:
> > > On Sat, Feb 02, 2013 at 11:06:09AM +0100, Pali Roh=C3=A1r wrote:
> > > > Reported temperature can be also negative, so cache
> > > > value in non negative Kelvin degree.
> > > >=20
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > ---
> > >=20
> > > Applied, thanks!
> >=20
> > Now I looked at bq27x00_battery and rx51_battery drivers and
> > I see that both drivers reporting temperature in different
> > units. bq27x00_battery in 1/10 =C2=B0C and rx51_battery in 1/100
> > =C2=B0C. What is correct degree for kernel power power supply
> > API? Maybe other kernel drivers have different units too...
> > Note that my above patch did not changed anything units,
> > only fixed reporting (possible) negative temperature.
>=20
> Per Documentation/power/power_supply_class.txt and
> power_supply.h:
>=20
> /*
>  * All voltages, currents, charges, energies, time and
> temperatures in uV, * =C2=B5A, =C2=B5Ah, =C2=B5Wh, seconds and tenths of
> degree Celsius unless otherwise * stated. It's driver's job
> to convert its raw values to units in which * this class
> operates.
>  */
>=20
> Feel free to fix the offending drivers.
>=20
> Thanks,
>=20
> Anton

Ok, here is small patch which fixing it in bq27x00_battery driver.
Tested on Nokia N900 with patched 3.8-rc3 kernel.
bq27x00_battery reporting "POWER_SUPPLY_TEMP=3D2700"
and rx51_battery reporting "POWER_SUPPLY_TEMP=3D3590"

=46rom 43a99615d6d7375770736303f1e000f3d85d75cb Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali.rohar@gmail.com>
Date: Sun, 3 Feb 2013 22:06:20 +0100
Subject: [PATCH] bq27x00_battery: Report temperature in 1/100 degree Celsius
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

* Documentation/power/power_supply_class.txt say that temperature must be r=
eported in tenths of degree=20
Celsius

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
=2D--
 drivers/power/bq27x00_battery.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_batter=
y.c
index 5b077af..482755f 100644
=2D-- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -312,8 +312,10 @@ static int bq27x00_battery_read_temperature(struct bq2=
7x00_device_info *di)
 		return temp;
 	}
=20
=2D	if (!bq27xxx_is_chip_version_higher(di))
=2D		temp =3D 5 * temp / 2;
+	if (bq27xxx_is_chip_version_higher(di))
+		temp *=3D 10;
+	else
+		temp *=3D 25;
=20
 	return temp;
 }
@@ -640,7 +642,7 @@ static int bq27x00_battery_get_property(struct power_su=
pply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		ret =3D bq27x00_simple_value(di->cache.temperature, val);
 		if (ret =3D=3D 0)
=2D			val->intval -=3D 2731;
+			val->intval -=3D 27310;
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		ret =3D bq27x00_simple_value(di->cache.time_to_empty, val);
=2D-=20
1.7.10.4

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2346359.ABUyHrso7C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlESmVMACgkQi/DJPQPkQ1IlngCfbVwX6TgXL7tQLY2wZqUZI/s8
11kAoLe7BkINK0WUprvwxwsEHdyhzpOH
=1KQ+
-----END PGP SIGNATURE-----

--nextPart2346359.ABUyHrso7C--
