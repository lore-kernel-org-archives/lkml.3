Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaK2Qad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:30:33 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39872 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaK2Qac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:30:32 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 17:30:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <5479F328.7080304@roeck-us.net>
In-Reply-To: <5479F328.7080304@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4584992.fzicd7Q3PI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291730.28743@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4584992.fzicd7Q3PI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 29 November 2014 17:24:08 Guenter Roeck wrote:
> On 11/29/2014 08:04 AM, Pali Roh=C3=A1r wrote:
> > +static bool __init i8k_check_temp(int sensor)
> > +{
> > +	int err;
> > +
> > +	/*
> > +	 * Check if temperature sensor type is valid.
> > +	 *
> > +	 * If it is valid then sensor should work. But some
> > sensors are not +	 * available at any time. E.g GPU sensor
> > on Optimus/PowerExpress/Enduro +	 * card does not work (or
> > return bogus value) when card is turned off. +	 * So this
> > function should not fail in this case. +	 */
> > +	err =3D i8k_get_temp_type(sensor);
> > +	if (err >=3D 0)
> > +		return true;
> > +
>=20
> Are you sure this function is provided for all systems ?
> I am a bit concerned that we may wrongly disable sensors this
> way, especially on older systems.
>=20

I do not know if that function is provided on all systems. But=20
this code does not disable sensors. If function fail, then we=20
fallback to temperature read down. Return true means that we=20
enable sensor.

> It might be safer to create another set of flags and enable
> the labels only if the sensor is known to exist and if
> reading its type (label) works.
>=20
> > +	/*
> > +	 * Check if temperatrue reading does not fail.
> > +	 *
>=20
> temperature
>=20
> > +	 * Sometimes detection of temperature sensor type does not
> > work but +	 * reading temperature working fine. Sometimes
> > temperature value is too +	 * high and i8k_get_temp()
> > returns -ERANGE. But there is no reason to +	 * ignore
> > these temperature sensors.
> > +	 */
> > +	err =3D i8k_get_temp(sensor);
> > +	if (err >=3D 0 || err =3D=3D -ERANGE)
> > +		return true;
> > +
>=20
> Please simplify to
> 	return err >=3D 0 || err =3D=3D -ERANGE;
>=20

I'm using style:

check_function_1();
if (not_failed)
	return true;

check_function_2();
if (not_failed)
	return true;

return false; // disable sensor

So I think it is better to have same style for both checks...

> > +	return false;
> > +}
> > +
> >=20
> >   static int __init i8k_init_hwmon(void)
> >   {
> >  =20
> >   	int err;
> >=20
> > @@ -613,18 +684,13 @@ static int __init i8k_init_hwmon(void)
> >=20
> >   	i8k_hwmon_flags =3D 0;
> >   =09
> >   	/* CPU temperature attributes, if temperature reading is
> >   	OK */
> >=20
> > -	err =3D i8k_get_temp(0);
> > -	if (err >=3D 0 || err =3D=3D -ERANGE)
> > +	if (i8k_check_temp(0))
>=20
> The introduction of i8k_check_temp() should be a separate
> patch.
>=20
> Thanks,
> Guenter
>=20

Ok.

> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP1;
> >=20
> > -	/* check for additional temperature sensors */
> > -	err =3D i8k_get_temp(1);
> > -	if (err >=3D 0 || err =3D=3D -ERANGE)
> > +	if (i8k_check_temp(1))
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP2;
> >=20
> > -	err =3D i8k_get_temp(2);
> > -	if (err >=3D 0 || err =3D=3D -ERANGE)
> > +	if (i8k_check_temp(2))
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP3;
> >=20
> > -	err =3D i8k_get_temp(3);
> > -	if (err >=3D 0 || err =3D=3D -ERANGE)
> > +	if (i8k_check_temp(3))
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP4;
> >   =09
> >   	/* Left fan attributes, if left fan is present */

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4584992.fzicd7Q3PI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR59KQACgkQi/DJPQPkQ1K89ACgya1c9omUY0A3BdQ8LCYVxCWB
1wwAn1+VGdS/GRr/yFEiim/HM4jJM82L
=obWz
-----END PGP SIGNATURE-----

--nextPart4584992.fzicd7Q3PI--
