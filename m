Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaJTQqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:46:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35018 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaJTQqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:46:04 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Ignore temperature sensors which report invalid values
Date: Mon, 20 Oct 2014 18:46:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
References: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com> <5443D519.1090408@roeck-us.net>
In-Reply-To: <5443D519.1090408@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2411996.bfefM0gB7K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410201846.00586@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2411996.bfefM0gB7K
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ok, I will describe my problem. Guenter, maybe you can find=20
another solution/fix for it.

Calling i8k_get_temp(3) on my laptop without I8K_TEMPERATURE_BUG=20
always returns value 193 (which is above I8K_MAX_TEMP).

When I8K_TEMPERATURE_BUG is enabled (by default) then=20
i8k_get_temp(3) returns value from prev[3] and store new value=20
I8K_TEMPERATURE_BUG to prev[3]. Value in prev[3] is initialized=20
to 0.

What I want to achieve is: when i8k_get_temp() for particular=20
sensor id always returns invalid value (> I8K_MAX_TEMP) then we=20
should totally ignore sensor with that id and do not export it=20
via hwmon.

My solution is: initialize prev[id] to I8K_MAX_TEMP, so on=20
invalid data first call to i8k_get_temp(id) returns I8K_MAX_TEMP.=20
Then in i8k_init_hwmon check if value is < I8K_MAX_TEMP and if=20
not ignore sensor id.

Guenter, it is clear now? Are you ok that we should ignore sensor=20
if always report value above I8K_MAX_TEMP? If you do not like my=20
solution/patch for it, can you specify how other can it be fixed?

On Sunday 19 October 2014 17:13:29 Guenter Roeck wrote:
> On 10/19/2014 07:46 AM, Pali Roh=C3=A1r wrote:
> > On some machines some temperature sensors report too high
> > values which are
>=20
> What is "too high", and what is "some machines" ?
> Would be great if you can be more specific.
>=20
> > invalid. When value is invalid function i8k_get_temp()
> > returns previous value and at next call it returns
> > I8K_MAX_TEMP.
> >=20
> > With this patch also firt i8k_get_temp() call returns
> > I8K_MAX_TEMP and
>=20
> fix ? Also, I am not entirely sure I understand what exactly
> you are fixing here.
>=20
> > i8k_init_hwmon() will ignore all sensor ids which report
> > incorrect values.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >   drivers/char/i8k.c |   10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index 7272b08..bc327fa 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
> >=20
> >   	int temp;
> >  =20
> >   #ifdef I8K_TEMPERATURE_BUG
> >=20
> > -	static int prev[4];
> > +	static int prev[4] =3D { I8K_MAX_TEMP, I8K_MAX_TEMP,
> > I8K_MAX_TEMP, I8K_MAX_TEMP };
>=20
> I am not sure I understand what this change is expected to
> accomplish. Please explain.
>=20
> >   #endif
> >  =20
> >   	regs.ebx =3D sensor & 0xff;
> >   	rc =3D i8k_smm(&regs);
> >=20
> > @@ -610,17 +610,17 @@ static int __init i8k_init_hwmon(void)
> >=20
> >   	/* CPU temperature attributes, if temperature reading is
> >   	OK */ err =3D i8k_get_temp(0);
> >=20
> > -	if (err >=3D 0)
> > +	if (err >=3D 0 && err < I8K_MAX_TEMP)
>=20
> I8K_MAX_TEMP is, at least in theory, a valid temperature, so
> this should be "<=3D".
>=20
> It would be important to understand what the "too high"
> temperature is to possibly be able to distinguish it from the
> buggy temperature that the code is trying to fix.
>=20
> Thanks,
> Guenter
>=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP1;
> >   =09
> >   	/* check for additional temperature sensors */
> >   	err =3D i8k_get_temp(1);
> >=20
> > -	if (err >=3D 0)
> > +	if (err >=3D 0 && err < I8K_MAX_TEMP)
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP2;
> >   =09
> >   	err =3D i8k_get_temp(2);
> >=20
> > -	if (err >=3D 0)
> > +	if (err >=3D 0 && err < I8K_MAX_TEMP)
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP3;
> >   =09
> >   	err =3D i8k_get_temp(3);
> >=20
> > -	if (err >=3D 0)
> > +	if (err >=3D 0 && err < I8K_MAX_TEMP)
> >=20
> >   		i8k_hwmon_flags |=3D I8K_HWMON_HAVE_TEMP4;
> >   =09
> >   	/* Left fan attributes, if left fan is present */

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2411996.bfefM0gB7K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRFPEgACgkQi/DJPQPkQ1LM4gCgkBuIR3wzH5RcewE4knKjpLOI
VaYAoK0Kmxi4e3v42zO/1Vz84v1dTYKT
=H9ny
-----END PGP SIGNATURE-----

--nextPart2411996.bfefM0gB7K--
