Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaK3OsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:48:19 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34384 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaK3OsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:48:18 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
Date: Sun, 30 Nov 2014 15:48:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201411181546.51284@pali> <1416322614-10308-1-git-send-email-pali.rohar@gmail.com> <547ADC90.8000507@roeck-us.net>
In-Reply-To: <547ADC90.8000507@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1444827.rVWXqk8muN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301548.16031@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1444827.rVWXqk8muN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 10:00:00 Guenter Roeck wrote:
> On 11/18/2014 06:56 AM, Pali Roh=C3=A1r wrote:
> > Static array prev[] was incorrectly initialized. It should
> > be initialized to some "invalid" temperature value (above
> > I8K_MAX_TEMP).
> >=20
> > Next, function should store "invalid" value to prev[] (above
> > I8K_MAX_TEMP), not valid (=3D I8K_MAX_TEMP) because whole
> > temperature bug handling will not work.
> >=20
> > And last part, to not break existing detection of
> > temperature sensors, register them also if i8k report too
> > high temperature (above I8K_MAX_TEMP). This is needed
> > because some sensors are sometimes turned off (e.g sensor
> > on GPU which can be turned off/on) and in this case SMM
> > report too high value.
> >=20
> > To prevent reporting "invalid" values to userspace, return
> > -EINVAL. In this case sensors which are currently turned
> > off (e.g optimus/powerexpress/enduro gpu) are reported as
> > "N/A" by lm-sensors package.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >   drivers/char/i8k.c |   16 ++++++++++------
> >   1 file changed, 10 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index 7272b08..e34a019 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
> >=20
> >   	int temp;
> >  =20
> >   #ifdef I8K_TEMPERATURE_BUG
> >=20
> > -	static int prev[4];
> > +	static int prev[4] =3D { I8K_MAX_TEMP+1, I8K_MAX_TEMP+1,
> > I8K_MAX_TEMP+1, I8K_MAX_TEMP+1 };
> >=20
> >   #endif
> >  =20
> >   	regs.ebx =3D sensor & 0xff;
> >   	rc =3D i8k_smm(&regs);
> >=20
> > @@ -317,10 +317,12 @@ static int i8k_get_temp(int sensor)
> >=20
> >   	 */
> >   =09
> >   	if (temp > I8K_MAX_TEMP) {
> >   =09
> >   		temp =3D prev[sensor];
> >=20
> > -		prev[sensor] =3D I8K_MAX_TEMP;
> > +		prev[sensor] =3D I8K_MAX_TEMP+1;
> >=20
> >   	} else {
> >   =09
> >   		prev[sensor] =3D temp;
> >   =09
> >   	}
> >=20
> > +	if (temp > I8K_MAX_TEMP)
> > +		return -ERANGE;
>=20
> Can we return -ENODATA in this case ? I think that would be
> more appropriate.
>=20

This is internal kernel function, no problem. If you prefer=20
NODATA instead RANGE I will change it.

> >   #endif
> >  =20
> >   	return temp;
> >=20
> > @@ -499,6 +501,8 @@ static ssize_t
> > i8k_hwmon_show_temp(struct device *dev,
> >=20
> >   	int temp;
> >   =09
> >   	temp =3D i8k_get_temp(index);
> >=20
> > +	if (temp =3D=3D -ERANGE)
> > +		return -EINVAL;
>=20
> and can we also return -ENODATA to user space ?
> This would make the code a bit cleaner.
>=20
> Thanks,
> Guenter

There was some problems when I tested similar patch for radeon.ko=20
(do not report temperature to userspace when card is turned off).

I can test lm-sensors which is in Ubuntu 12.04 LTS (there is=20
probably some older version) what happens with -ENODATA from i8k.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1444827.rVWXqk8muN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR7LjAACgkQi/DJPQPkQ1JIfwCfXlOM1iQlA9oOy1sumD4Ht5HV
gy4AoKm8TigX5ZMfYbNF1/tt838qmV9q
=CN2R
-----END PGP SIGNATURE-----

--nextPart1444827.rVWXqk8muN--
