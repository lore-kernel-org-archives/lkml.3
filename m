Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3HEGp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:45:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3HEGpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:45:54 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] omapfb: In omapfb_probe return -EPROBE_DEFER when display driver is not loaded yet
Date: Sun, 4 Aug 2013 10:36:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc7+radeon+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
References: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com> <20130713182733.GA25019@amd.pavel.ucw.cz> <51EE5483.7000201@ti.com>
In-Reply-To: <51EE5483.7000201@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart39307278.AbkrUebWic";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308041036.12471@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart39307278.AbkrUebWic
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Tuesday 23 July 2013 12:01:39 Tomi Valkeinen wrote:
> On 13/07/13 21:27, Pavel Machek wrote:
> > On Wed 2013-07-10 15:08:59, Pali Roh=C3=A1r wrote:
> >> * On RX-51 probing for acx565akm driver is later then for
> >> omapfb which cause that omapfb probe fail and framebuffer
> >> is not working * EPROBE_DEFER causing that kernel try to
> >> probe for omapfb later again which fixing this problem
> >>=20
> >> * Without this patch display on Nokia RX-51 (N900) phone
> >> not working
> >>=20
> >> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >=20
> > Tested-by: Pavel Machek <pavel@ucw.cz>
>=20
> Which kernel version is this? Does it have
> dfbc32316c6991010328c21e6046b05bac57eb84 (OMAPFB: defer probe
> if no displays)?
>=20

Kernel 3.10, so it have above commit.

> Then again, rx51 has tv-output, which probably gets probed
> early. So omapfb does see one functional display, and starts,
> even if the LCD is not available yet.
>=20
> > (Actually, do we know which commit broke the ordering? We
> > may want to simply revert that one...)
>=20
> Well, my understand that this is how it's supposed to work.
> There's no defined order with the driver probes, and the
> drivers just have to deal with their dependencies not being
> there yet.
>=20
> I don't have a perfect solution for this problem for omapfb.
> omapfb doesn't support dynamically adding displays, so all
> the displays it uses have to be probed before omapfb. And
> omapfb doesn't know which displays will be probed.
>=20
> The patch below was added for 3.11. Does it fix the issue for
> you? Perhaps it should be added for 3.10 also.
>=20
>  Tomi
>=20

I tested patch below and it fixing our problem too. So it could be=20
added to 3.10.

> commit e9f322b4913e5d3e5c5d21dc462ca6f8a86e1df1
> Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Date:   Thu May 23 16:41:25 2013 +0300
>=20
>     OMAPFB: use EPROBE_DEFER if default display is not present
>=20
>     Currently omapfb returns EPROBE_DEFER if no displays have
> been probed at the time omapfb is probed. However, sometimes
> some of the displays have been probed at that time, but not
> all. We can't return EPROBE_DEFER in that case, because then
> one missing driver would cause omapfb to defer always,
> preventing any display from working.
>=20
>     However, if the user has defined a default display, we can
> presume that the driver for that display is eventually
> loaded. Thus, this patch changes omapfb to return
> EPROBE_DEFER in case default display is not found.
>=20
>     Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>=20
> diff --git a/drivers/video/omap2/omapfb/omapfb-main.c
> b/drivers/video/omap2/omapfb/omapfb-main.c index
> 528e453..27d6905 100644
> --- a/drivers/video/omap2/omapfb/omapfb-main.c
> +++ b/drivers/video/omap2/omapfb/omapfb-main.c
> @@ -2503,7 +2503,7 @@ static int omapfb_probe(struct
> platform_device *pdev)
>=20
>         if (def_display =3D=3D NULL) {
>                 dev_err(fbdev->dev, "failed to find default
> display\n"); -               r =3D -EINVAL;
> +               r =3D -EPROBE_DEFER;
>                 goto cleanup;
>         }

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart39307278.AbkrUebWic
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlH+EnwACgkQi/DJPQPkQ1KKVQCdEP5e/YUZhlXs3iDd03EKjRAz
U6UAn1WHoj1Lbz2ZFLPRYCY7ohw1OfPU
=1bAz
-----END PGP SIGNATURE-----

--nextPart39307278.AbkrUebWic--
