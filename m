Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3JAVYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:24:55 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:49669 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3JAVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:24:52 -0400
Date: Tue, 1 Oct 2013 23:23:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] ARM: SAMSUNG: Initialize PWM backlight enable_gpio
 field
Message-ID: <20131001212305.GF9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-6-git-send-email-treding@nvidia.com>
 <524B14E8.5040302@wwwdotorg.org>
 <20131001204335.GB9201@ulmo.nvidia.com>
 <524B376E.6060507@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Content-Disposition: inline
In-Reply-To: <524B376E.6060507@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 02:58:22PM -0600, Stephen Warren wrote:
> On 10/01/2013 02:43 PM, Thierry Reding wrote:
> > On Tue, Oct 01, 2013 at 12:31:04PM -0600, Stephen Warren wrote:
> >> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> >>> The GPIO API defines 0 as being a valid GPIO number, so this
> >>> field needs to be initialized explicitly.
> >>=20
> >>> static void __init smdkv210_map_io(void)
> >>=20
> >>> @@ -70,6 +70,7 @@ static struct samsung_bl_drvdata
> >>> samsung_dfl_bl_data __initdata =3D { .max_brightness =3D 255,=20
> >>> .dft_brightness =3D 255, .pwm_period_ns  =3D 78770, +		.enable_gpio
> >>> =3D -1, .init           =3D samsung_bl_init, .exit           =3D
> >>> samsung_bl_exit, }, @@ -121,6 +122,10 @@ void __init
> >>> samsung_bl_set(struct samsung_bl_gpio_info *gpio_info,=20
> >>> samsung_bl_data->lth_brightness =3D bl_data->lth_brightness; if
> >>> (bl_data->pwm_period_ns) samsung_bl_data->pwm_period_ns =3D
> >>> bl_data->pwm_period_ns; +	if (bl_data->enable_gpio) +
> >>> samsung_bl_data->enable_gpio =3D bl_data->enable_gpio; +	if
> >>> (bl_data->enable_gpio_flags) +
> >>> samsung_bl_data->enable_gpio_flags =3D
> >>> bl_data->enable_gpio_flags;
> >>=20
> >> Won't this cause the core pwm_bl driver to request/manipulate the
> >> GPIO, whereas this driver already does that inside the
> >> samsung_bl_init/exit callbacks? I think you either need to adjust
> >> those callbacks, or not set the new standard GPIO property in
> >> samsung_bl_data.
> >=20
> > I don't think so. The samsung_bl_data is a copy of
> > samsung_dfl_bl_data augmented by board-specific settings. So in
> > fact copying these values here is essential to allow boards to
> > override the enable_gpio and flags fields. Currently no board sets
> > the enable_gpio to a valid GPIO so it's all still handled by the
> > callbacks only.
>=20
> Oh yes, you're right. I was confusing the new enable_gpio field in
> pwm_bl's platform data with some other field in a custom data structure.
>=20
> One minor point though:
>=20
> >>> +	if (bl_data->enable_gpio) +		samsung_bl_data->enable_gpio =3D
> >>> bl_data->enable_gpio;
>=20
> That assumes that enable_gpio=3D=3D0 means "none", whereas you've gone to
> great pains in the rest of the series to allow 0 to be a valid GPIO
> ID. right now, the default value of samsung_bl_data->enable_gpio is
> -1, and if !bl_data->enable_gpio, that value won't be propagated across.

Right, that check should now be:

	if (bl_data->enable_gpio >=3D 0)

Well, it depends. It would be possible for the default to specify a
valid GPIO and for a board to override it with -1 (and provide a set of
corresponding callbacks). In that case the right thing to do here would
be not to check at all.

Then again, I don't think that will ever happen, because no fixed GPIO
will ever be a good default. So changing to >=3D 0 instead of !=3D 0 should
work fine.

Again, starting with 3.13 this should become a lot easier to handle
since the GPIO subsystem will gain functionality to use a per-board
lookup table, similarly to what the regulator and PWM subsystems do.
Once that's in place I plan to make another pass over all users of the
pwm-backlight driver and replace the enable_gpio field with a GPIO
lookup table, so that the driver can uniformly request them using a
simple gpiod_get().

Thierry

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSz05AAoJEN0jrNd/PrOhDz0P/0XJLSooTkwvXGXDUxrOiN2c
m6Drm5c1RR2Nz6rNkax19haIf1WOV05ZFBGbMzKlvI4/oGupIrzFFmIHmWsfZrX5
ZmzR/ebD64/lHfB+I7mABRYJDV76Goibw68xNAKB5pW1cdt/FWOo1djQtC9WLfIS
t7cLhWFUaXdntdYt1gmoqML/mCFCSPCXjRFvXPiph9+H5vQvY+w151GrNsyyHazr
UpGDg54XVky804/QayqnWxXco2vhCCo4KZViqvAts+6+upv0Rn/6b+Gk6KITN7bb
h7pkh7ZwR4Aro0aSKZapDzeGQRk5mRL4QpA1QX+LPbwFxpFhCjltuFSa7hFyFy3k
N0dk2qpC4Pv/SlAFQmF4OISxSBXLy0c6veLg+jCWBjjnabjnIlC/Auxz2DqRctfF
XoaKhreEB3n9njGOdroIsUEfw/DraGFLe+rkC5gqrcl3Dn11GS7lIWnsHFxOIhYe
bt4jtFXA+X6+qDK2Bq9bzhPjkeJpUi0xcle0gh5fC3Pr/fceKYsFf5ENEMFNXKlY
Ib5Pox5ftoUAjZ/+daoPtRbPkAKdDrwDGaZFpTT1FIkElte8DaWLuppgIaI2cB/2
N6qjf3t4cZ9qMiuq+FRUzRSZtRsH/ECQClkyk7hePKd3gPBCNljijZQPEVfqfb1/
wEgttnUyvkFYpczsbqWV
=mP+c
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--
