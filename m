Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaLUJNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 04:13:48 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33977 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLUJNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 04:13:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 10:13:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <5495C228.4030400@roeck-us.net>
In-Reply-To: <5495C228.4030400@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1922320.sDH3ffGhEt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412211013.36508@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1922320.sDH3ffGhEt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 December 2014 19:38:32 Guenter Roeck wrote:
> > +	if (fan_mult <=3D 0) {
>=20
> Wonder what to do in the < 0 case. It might be better to make
> the variable and the module parameter an unsigned int to
> cover that case, since a negative multiplier doesn't really
> make sense. Same for fan_max.
>=20

In some other kernel modules negative value means autodetect. I=20
think we can do that too.

> > +		/*
> > +		 * Autodetect fan multiplier for each fan based on
> > nominal rpm +		 * First set default fan multiplier for each
> > fan +		 * And if it reports rpm value too high then set
> > multiplier to 1 +		 *
> > +		 * Try also setting multiplier from current rpm, but=20
this
> > will +		 * work only in case when fan is not turned off. It
> > is better +		 * then nothing for machines which does not
> > support nominal rpm +		 * SMM function.
> > +		 */
> > +		for (fan =3D 0; fan < ARRAY_SIZE(i8k_fan_mult); ++fan) {
> > +			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
> > +			if (i8k_get_fan_speed(fan) > I8K_FAN_MAX_RPM) {
> > +				i8k_fan_mult[fan] =3D 1;
> > +				continue;
> > +			}
>=20
> What if i8k_get_fan_speed(fan) returns an error ? Doesn't that
> imply that the fan does not exist, and that you would not
> need the second loop in the first place ?
>=20

See my other email "[PATCH] i8k: Add support for fan labels". DOS=20
binary check for fan presence by another function. I bet it is=20
because fan could have same problem as temperature sensors. If=20
fan is on GPU and GPU is turned off reading fan rpm will fail.=20
But my laptop (with GPU which can be turned on/off) does not have=20
GPU fan so this is just my assumption.

> > +			for (val =3D 0; val < 256; ++val) {
> > +				ret =3D i8k_get_fan_nominal_speed(fan, val);
> > +				if (ret > I8K_FAN_MAX_RPM) {
> > +					i8k_fan_mult[fan] =3D 1;
> > +					break;
> > +				} else if (ret < 0) {
> > +					break;
> > +				}
>=20
> Traditionally error checks come first.
>=20

Ok.

> > +		for (fan =3D 0; fan < ARRAY_SIZE(i8k_fan_max); ++fan) {
> > +			for (val =3D 0; val < 256; ++val) {
> > +				if (i8k_get_fan_nominal_speed(fan, val) < 0)
> > +					break;
> > +			}
> > +			--val; /* set last value which not failed */
> > +			if (val <=3D 0) /* Must not be 0 (and non negative)=20
*/
> > +				val =3D I8K_FAN_HIGH;
> > +			i8k_fan_max[fan] =3D val;
>=20
> I kind of dislike that you are (at least potentially) looping
> through all the nominal speeds twice; not sure how long that
> will delay the boot process. I don't know if or how that can
> be solved easily, though. Either case, I would prefer
> something like
> 			i8k_fan_max =3D I8K_FAN_HIGH;
> 			for (val =3D 0; val < 256; ++val) {
> 				if (i8k_get_fan_nominal_speed(fan, val) < 0)
> 					break;
> 				i8k_fan_max =3D val;
> 			}
>=20
> since that would take care of all the meddling at the end.
>=20

Ok, I will change code.

> > +		}
> > +	} else {
> > +		/* Maximal fan speed was specified in module param or=20
in
> > dmi */ +		for (fan =3D 0; fan < ARRAY_SIZE(i8k_fan_max);
> > ++fan) +			i8k_fan_max[fan] =3D fan_max;
> >=20
> >   	}
>=20
> Overall I think it would make sense to move the auto-detection
> code to a separate function. This is getting a bit large to
> have it all in a single function.
>=20

Now when I reduced fan detection for first available fan code is=20
smaller.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1922320.sDH3ffGhEt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSWj0AACgkQi/DJPQPkQ1IPTACfZb0x9m+3GLqXzxXP1ILs5LFD
odsAoIIOYU6Rl3tsC3XABSgxiCqSWwdV
=Wph1
-----END PGP SIGNATURE-----

--nextPart1922320.sDH3ffGhEt--
