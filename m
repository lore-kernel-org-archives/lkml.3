Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaBKUyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:54:53 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36955 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaBKUyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:54:49 -0500
Date: Tue, 11 Feb 2014 21:54:45 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Erik Faye-Lund <kusmabite@gmail.com>
Cc: Dmitry Osipenko <digetx@gmail.com>, tbergstrom@nvidia.com,
        airlied@linux.ie, swarren@wwwdotorg.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/tegra: Add guard to avoid double disable/enable
 of RGB outputs
Message-ID: <20140211205443.GB1895@mithrandir>
References: <1392138747-18198-1-git-send-email-digetx@gmail.com>
 <CABPQNSYNpwf_EQqUc2zpQ1cVQE++2ma-bR-rfQPdNoaJc07W4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <CABPQNSYNpwf_EQqUc2zpQ1cVQE++2ma-bR-rfQPdNoaJc07W4w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 08:13:14PM +0100, Erik Faye-Lund wrote:
> On Tue, Feb 11, 2014 at 6:12 PM, Dmitry Osipenko <digetx@gmail.com> wrote:
> > Add guard to check whether RGB output is already enabled in the way it's
> > done for HDMI output. Fixes possible hang on trying to disable output t=
wice
> > (first time during driver probe and second on fb registering).
> >
> > Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> > ---
> >  drivers/gpu/drm/tegra/rgb.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
> > index 338f7f6..0266fb4 100644
> > --- a/drivers/gpu/drm/tegra/rgb.c
> > +++ b/drivers/gpu/drm/tegra/rgb.c
> > @@ -15,6 +15,7 @@
> >  struct tegra_rgb {
> >         struct tegra_output output;
> >         struct tegra_dc *dc;
> > +       bool enabled;
> >
> >         struct clk *clk_parent;
> >         struct clk *clk;
> > @@ -89,6 +90,9 @@ static int tegra_output_rgb_enable(struct tegra_outpu=
t *output)
> >         struct tegra_rgb *rgb =3D to_rgb(output);
> >         unsigned long value;
> >
> > +       if (rgb->enabled)
> > +               return 0;
> > +
> >         tegra_dc_write_regs(rgb->dc, rgb_enable, ARRAY_SIZE(rgb_enable)=
);
> >
> >         value =3D DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
> > @@ -122,6 +126,8 @@ static int tegra_output_rgb_enable(struct tegra_out=
put *output)
> >         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CON=
TROL);
> >         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
> >
> > +       rgb->enabled =3D true;
> > +
> >         return 0;
> >  }
> >
> > @@ -130,6 +136,9 @@ static int tegra_output_rgb_disable(struct tegra_ou=
tput *output)
> >         struct tegra_rgb *rgb =3D to_rgb(output);
> >         unsigned long value;
> >
> > +       if (!rgb->enabled)
> > +               return 0;
> > +
> >         value =3D tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_POWER_CONTROL);
> >         value &=3D ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
> >                    PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
> > @@ -144,6 +153,8 @@ static int tegra_output_rgb_disable(struct tegra_ou=
tput *output)
> >
> >         tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disabl=
e));
> >
> > +       rgb->enabled =3D false;
> > +
> >         return 0;
> >  }
> >
>=20
> Wouldn't it make more sense to make "enabled" and int that counts how
> many times tegra_output_rgb_enable has been called? That way you can
> have tegra_output_rgb_disable only really disable the display once the
> same amount of disables have been performed...

I don't think that will work. Calls to tegra_output_rgb_enable/disable()
and the .enable/disable for any other outputs aren't guaranteed to be
balanced. Therefore reference counting the enables and disables will
break things.

Thinking about it, maybe the current interface to outputs isn't the best
solution. It's simple and with the guards in place it works pretty well.
Perhaps if I can find some spare time I'll investigate whether something
a little cleaner can be done.

Thierry

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+o4TAAoJEN0jrNd/PrOhwlIQAKL6uGBGYncMSCB6adKyu9ND
d+QBGZnlD65GZDWRbYEuvGDthtdFmVFr7iHFKdSqqocOTt4A6Ycyatc3R+h8LT99
CKaAqlDJALQQoZ1J1JogL7rAnQvLDxj48Y/H728vg7Rsp73IqGJNfjtBzqYZ864q
lGOlhYQFtxIXOPL5nBIuJNNxdHwzP4nsIM8uX8wvy0eZpfZKgVw1c5IcbH8/1Xmu
H38S+59MYzTl4OlCLDSonUk5t6v49U+xyRHh7JdMcRJk/dCtPMUczjj3d71nizwV
ax04UXj5Gyrk/FQmu0DmqCown0yRCqRq/2uAZZBfa199JcNzSonAT3FMvEUj1Hfs
5KOwDBOmrsFfvwL0AC+WzBplfkstZs1HM4GbJg376OcopvQCvXvcovW14063V3+W
DHjsQvIuHjBd6bIW/cervX+Fjn/Lgc9zKFk5ifCW5VWz16uKzmyrW0xfwh93o5Es
PAZd4LZjT05WxLtKcx5MQiENDl2LiTGwg7ySgCtlXAmZLvlrRMOpXERBJCrUzApZ
K7giNFGkWpgmrqVjEr19KSCLaNjav0bP7NF+b2chkw3hXs59ewqKEVZsd4zJq5As
3Kt16cU0oQ+pbpvMB87ygD1zZRvi+GSBG0DYrwHMQzzgBN984wmDe0xZaHBlpWzP
1JnyzoAWsQ7WxypcpkCp
=SSZP
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
