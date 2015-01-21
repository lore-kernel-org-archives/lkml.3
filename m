Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbAUOPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:15:07 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62870 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbAUOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:14:55 -0500
Date: Wed, 21 Jan 2015 01:15:01 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Caesar Wang <wxt@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] thermal: rockchip: make temperature reporting much
 more accurate
Message-ID: <20150121051459.GA13468@developer.hsd1.ca.comcast.net>
References: <1421625349-14101-1-git-send-email-wxt@rock-chips.com>
 <1421625349-14101-2-git-send-email-wxt@rock-chips.com>
 <CAGS+omDiajqKxYFqdBXTeax+eeE-TD1WJ+C5odCbZBg6FELXDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <CAGS+omDiajqKxYFqdBXTeax+eeE-TD1WJ+C5odCbZBg6FELXDA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 12:23:49PM +0800, Daniel Kurtz wrote:
> Hi Caesar,
>=20
> Some drive-by review comments inline...
>=20
> On Mon, Jan 19, 2015 at 7:55 AM, Caesar Wang <wxt@rock-chips.com> wrote:
> > In general, the kernel should report temperature readings exactly as
> > reported by the hardware. The cpu / gpu thermal driver works in 5 degree
> > increments,but we ought to do more accurate. The temperature will do
> > linear interpolation between the entries in the table.
> >
> > Test=3D $md5sum /dev/zero &
> > $while true; do grep "" /sys/class/thermal/thermal_zone[1-2]/temp;
> > sleep .5; done
> >
> > e.g. We can get the result as follows:
> >     /sys/class/thermal/thermal_zone1/temp:39994
> >     /sys/class/thermal/thermal_zone2/temp:39086
> >     /sys/class/thermal/thermal_zone1/temp:39994
> >     /sys/class/thermal/thermal_zone2/temp:39540
> >     /sys/class/thermal/thermal_zone1/temp:39540
> >     /sys/class/thermal/thermal_zone2/temp:39540
> >     /sys/class/thermal/thermal_zone1/temp:39540
> >     /sys/class/thermal/thermal_zone2/temp:39994
> >
> > Signed-off-by: Caesar Wang <wxt@rock-chips.com>
> > Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> > ---
> >
> > Changes in v2:
> > Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> >  drivers/thermal/rockchip_thermal.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockc=
hip_thermal.c
> > index 1bcddfc..a7ae23a 100644
> > --- a/drivers/thermal/rockchip_thermal.c
> > +++ b/drivers/thermal/rockchip_thermal.c
> > @@ -193,19 +193,18 @@ static u32 rk_tsadcv2_temp_to_code(long temp)
> >
> >  static long rk_tsadcv2_code_to_temp(u32 code)
> >  {
> > -       int high, low, mid;
> > -
> > -       low =3D 0;
> > -       high =3D ARRAY_SIZE(v2_code_table) - 1;
> > -       mid =3D (high + low) / 2;
> > +       unsigned int low =3D 0;
> > +       unsigned int high =3D ARRAY_SIZE(v2_code_table) - 1;
> > +       unsigned int mid =3D (low + high) / 2;
> > +       unsigned int scale;
> >
> >         if (code > v2_code_table[low].code || code < v2_code_table[high=
].code)
> >                 return 125000; /* No code available, return max tempera=
ture */
>=20
> I think if the temp sensor reading was invalid we should return an
> error code rather than just silently returning "max temp".
> Returning an error here could then be propagated up by its only
> caller, the ->get_temp() callback.
>=20

Agreed here.

> Note: 'code < v2_code_table[high].code' is always false, since code is
> unsigned, and the last entry is 0.
>=20
> Also, the check above doesn't reject "code =3D=3D 0xfff".
> Even worse, I believe in that case the below algorithm will eventually
> set mid=3D0 and access v2_code_table[-1].code.
>=20

yeah, if that can happen, then it must be fixed.


> >
> >         while (low <=3D high) {
> > -               if (code >=3D v2_code_table[mid].code && code <
> > -                   v2_code_table[mid - 1].code)
> > -                       return v2_code_table[mid].temp;
> > +               if (code >=3D v2_code_table[mid].code &&
> > +                   code < v2_code_table[mid - 1].code)
> > +                       break;
> >                 else if (code < v2_code_table[mid].code)
> >                         low =3D mid + 1;
> >                 else
> > @@ -213,7 +212,16 @@ static long rk_tsadcv2_code_to_temp(u32 code)
> >                 mid =3D (low + high) / 2;
> >         }
> >
> > -       return 125000;
> > +       /*
> > +        * The 5C granularity provided by the table is too much. Let's
> > +        * assume that the relationship between sensor readings and
> > +        * temperature between 2 table entries is linear and extrapolate
>=20
> I think this is "interpolate", not "extrapolate".


in this case yes, agreed too.

>=20
> > +        * to produce less granular result.
> > +        */
> > +       scale =3D (v2_code_table[mid].temp - v2_code_table[mid - 1].tem=
p) /
> > +               (v2_code_table[mid - 1].code - v2_code_table[mid].code);
> > +       return v2_code_table[mid - 1].temp +
> > +                       (v2_code_table[mid - 1].code - code) * scale;
>=20
> Assuming the product fits in an unsigned long (and it will, since code
> is only 12-bits), it is more precise to multiply first and then
> divide, something like this:
>=20
>    num =3D v2_code_table[mid].temp - v2_code_table[mid - 1].temp;
>    num *=3D v2_code_table[mid - 1].code - code;
>    denom =3D v2_code_table[mid - 1].code - v2_code_table[mid].code;
>    return v2_code_table[mid - 1].temp + (num / denom);
>=20
> -Daniel
>=20
> >  }
> >
> >  /**
> > --
> > 1.9.1
> >
> >
> >
> > _______________________________________________
> > Linux-rockchip mailing list
> > Linux-rockchip@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-rockchip

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUvzXKAAoJEMLUO4d9pOJWepgH/1X356E4Xcz1mSQnPOlz3WI6
8UQOV9drl0cSMk4QiKLFDup+q6ZLW3CqAsDuaJvPI99dV5YtY8c7vFYDsPmhR8hg
LL/3F3CMXiU6eMFmwtns9eTPSyR233olJmLLGK31/JwvyDihcUCVB9UTVEpt4rFX
G+KjeKfix0DaGDwC+b2ub+93lyC7ZGrJ1v7aJiYFXfO/RhCQwZ/8ObCwrJjtoQ3T
1ht3IWFoh7WM6ZuuBvvEvjkwjggZXHPZuN6PG0kTwW8bRQ9X9B8MKnhlzS6F0oN5
vwXZPknc89h8n4T2kT2IgwrN1cWAs3LhxeptU2+BZ7kZZ+dXoISg+FSYgOku0nM=
=uRVB
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
