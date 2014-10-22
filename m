Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaJVM3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:29:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50179 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:29:11 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Ignore temperature sensors which report invalid values
Date: Wed, 22 Oct 2014 14:29:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
References: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com> <201410201846.00586@pali> <5445E0AB.1090306@roeck-us.net>
In-Reply-To: <5445E0AB.1090306@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3254563.PlLTq8gDJe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410221429.06699@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3254563.PlLTq8gDJe
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 21 October 2014 06:27:23 Guenter Roeck wrote:
> On 10/20/2014 09:46 AM, Pali Roh=C3=A1r wrote:
> > Ok, I will describe my problem. Guenter, maybe you can find
> > another solution/fix for it.
> >=20
> > Calling i8k_get_temp(3) on my laptop without
> > I8K_TEMPERATURE_BUG always returns value 193 (which is
> > above I8K_MAX_TEMP).
> >=20
> > When I8K_TEMPERATURE_BUG is enabled (by default) then
> > i8k_get_temp(3) returns value from prev[3] and store new
> > value I8K_TEMPERATURE_BUG to prev[3]. Value in prev[3] is
> > initialized to 0.
> >=20
> > What I want to achieve is: when i8k_get_temp() for
> > particular sensor id always returns invalid value (>
> > I8K_MAX_TEMP) then we should totally ignore sensor with
> > that id and do not export it via hwmon.
> >=20
> > My solution is: initialize prev[id] to I8K_MAX_TEMP, so on
> > invalid data first call to i8k_get_temp(id) returns
> > I8K_MAX_TEMP. Then in i8k_init_hwmon check if value is <
> > I8K_MAX_TEMP and if not ignore sensor id.
> >=20
> > Guenter, it is clear now? Are you ok that we should ignore
> > sensor if always report value above I8K_MAX_TEMP? If you do
> > not like my solution/patch for it, can you specify how
> > other can it be fixed?
>=20
> I still don't see the point in initializing prev[].
>=20

Now prev[] is initialized to 0. It means that first call=20
i8k_get_temp() (with sensor id which return value > I8K_MAX_TEMP)=20
returns 0. Second and other calls returns I8K_MAX_TEMP.

So point is to return same value for first and other calls.

> Yes, I am ok with ignoring sensor values if the reported
> temperature is above I8K_MAX_TEMP. I am just not sure if we
> should check against I8K_MAX_TEMP or against, say, 192.
> Reason is that we do know that the sensor can erroneously
> return 0x99 on some systems once in a while. We would not
> want to ignore those sensors just because they happen to
> report 0x99 during initialization.
>=20
> So maybe make it
> 	if (err >=3D 0 && err < 192)
> and add a note before the first if(), explaining that higher
> values suggest that there is no sensor attached.
>=20
> Thanks,
> Guenter
>=20

Right, now we need to decide which magic constant to use...

And now I found another problem :-)

On my laptop i8k_get_temp(3) not always return value 193. It is=20
only when AMD graphics card is turned off. When card is on=20
i8k_get_temp(3) returns same value as temperature hwmon part from=20
radeon DRM driver.

So it looks like that on my laptop i8k sensor with id 3 reports=20
GPU temperature.

When card is turned off radeon driver reports -EINVAL for=20
temperature hwmon sysnode.

So now I think i8k could not ignore sensor totally as it can be=20
mapped to some HW which can be dynamically turned on/off (like my=20
graphics card).

So what do you think about reporting -EINVAL instead I8K_MAX_TEMP=20
when dell SMM returns value above I8K_MAX_TEMP?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3254563.PlLTq8gDJe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRHoxIACgkQi/DJPQPkQ1IT0wCgvC9IuRHG5h7+UJBZHqxOK00N
qcYAnirgLAto+j/wMWBgTMlfqemPFw1q
=FupQ
-----END PGP SIGNATURE-----

--nextPart3254563.PlLTq8gDJe--
