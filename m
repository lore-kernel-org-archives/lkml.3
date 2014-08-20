Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaHTPiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:38:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37217 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHTPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:38:09 -0400
Date: Wed, 20 Aug 2014 17:38:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140820153801.GB3427@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-2-git-send-email-dianders@chromium.org>
 <20140819071011.GC12859@ulmo>
 <CAD=FV=Xr4ywGT_pPK=r6f6tfVpwbduUY7D5LK61HVtc8=JmkaA@mail.gmail.com>
 <20140820060759.GD13793@ulmo>
 <CAD=FV=Uqm43x0N=eOCQkY_MXviiD2WMw55pOZmC=WVRbD2+veg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Uqm43x0N=eOCQkY_MXviiD2WMw55pOZmC=WVRbD2+veg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 08:20:53AM -0700, Doug Anderson wrote:
> Thierry,
>=20
> On Tue, Aug 19, 2014 at 11:08 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Tue, Aug 19, 2014 at 08:18:54AM -0700, Doug Anderson wrote:
> >> Thierry,
> >>
> >> On Tue, Aug 19, 2014 at 12:10 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrote:
> >> >> The rk3288 SoC has an option to switch all of the PWMs in the system
> >> >> between the old IP block and the new IP block.  The new IP block is
> >> >> working and tested and the suggested PWM to use, so setup the SoC to
> >> >> use it and then we can pretend that the other IP block doesn't exis=
t.
> >
> > A few more questions as to how this actually works. Does it mean there
> > are two physically separate blocks (with different physical addresses)
> > to control the same PWM? And this register simply causes some of the
> > pins to be routed to one or another? As far as I recall there are a
> > number of instances of the PWM block, so the above would need to count
> > for all of them. Or are there separate bits for each of them?
>=20
> All I have is the TRM (technical reference manual) which doesn't give
> me much more info than I've provided you.  But I can answer some of
> your questoins:
>=20
> 1. If there are two physically separate blocks then the "old" block is
> not documented in my TRM.
>=20
> 1a) It's entirely possible it's located at some memory address that is
> marked "Reserved" in the TRM, but I have no idea.
>=20
> 1b) It's entirely possible that the old IP block and the new IP block
> are supposed to be "compatible" but that the old block is broken and
> thus isn't behaving properly.
>=20
> 1c) It's entirely possible that the old IP block and the new IP block
> are located at the same physical addresses but somehow work
> differently.  If so, the old IP block isn't documented.
>=20
>=20
> 2. As per the patch description, there is a single bit that controls
> all of the PWMs.  My guess is that there's actually a single IP block
> that implements all 4 PWMs.

Looking at the register offsets in the device tree that seems likely. At
least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
same IP block. Their placement in the register map is somewhat strange:

	pwm0: pwm@20030000 {
		...
		reg =3D <0x20030000 0x10>;
		...
		clocks =3D <&cru PCLK_PWM01>;
		...
	};

	pwm1: pwm@20030010 {
		...
		reg =3D <0x20030010 0x10>;
		...
		clocks =3D <&cru PCLK_PWM01>;
		...
	};

	...

	pwm2: pwm@20050020 {
		...
		reg =3D <0x20050020 0x10>;
		...
		clocks =3D <&cru PCLK_PWM23>;
		...
	};

	pwm3: pwm@20050030 {
		...
		reg =3D <0x20050030 0x10>;
		...
		clocks =3D <&cru PCLK_PWM23>;
		...
	};

The clocks would also indicate that there are actually two blocks. I
seem to remember a discussion about whether to handle them as a single
block or two/four, but I can't seem to find a reference to it. Maybe I'm
confusing it with another driver.

> >> >> This code could go lots of other places, but we've put it here.  Wh=
y?
> >> >> - Pushing it to the bootloader just makes the code harder to update=
 in
> >> >>   the field.  If we later find a bug in the new IP block and want to
> >> >>   change our mind about what to use we want it to be easy to update.
> >
> > Depending on how this muxing works you won't be able to change your mind
> > anyway. If the IP blocks are different then the device tree will
> > effectively make the decision for you. So if you really want to be safe
> > you'd need to have code in the kernel that parses the device tree and
> > checks that all PWM instances are of the new type, then set this
> > register accordingly.
>=20
> Since there is no documentation about how you would instantiate the
> "old" type in the TRM and no good reason I can think of why someone
> would want to do this, it doesn't seem super fruitful.

Okay, so if it's not at all documented and never used then yes, we'd
better just ignore it.

> >> >> diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rock=
chip/rockchip.c
> >> >> index 8ab9e0e..99133b9 100644
> >> >> --- a/arch/arm/mach-rockchip/rockchip.c
> >> >> +++ b/arch/arm/mach-rockchip/rockchip.c
> >> >> @@ -24,6 +24,24 @@
> >> >>  #include <asm/hardware/cache-l2x0.h>
> >> >>  #include "core.h"
> >> >>
> >> >> +static void __init rk3288_init_machine(void)
> >> >> +{
> >> >> +     void *grf =3D ioremap(0xff770000, 0x10000);
> >> >
> >> > This region of memory is part of the "grf" "syscon" device (accordin=
g to
> >> > arch/arm/boot/dts/rk3288.dtsi) so the register should be accessed fr=
om
> >> > that driver. It looks as if no such driver currently exists, but giv=
en
> >> > the existence of the device tree node it's fair to assume that one w=
ill
> >> > eventually be merged.
> >>
> >> The "grf" syscon device is the "general register file".  It's a
> >> collection of totally random registers stuffed together in one address
> >> space.  Sometimes a single 32-bit register has things you need to
> >> tweak for completely different subsystems.
> >>
> >> Most drivers referene the syscon using this in dts:
> >>   rockchip,grf =3D <&grf>;
> >>
> >> Then the drivers do:
> >>   grf =3D syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
> >>
> >>
> >> See the Rockchip i2c, pinctrl, or clock drivers for examples.
> >
> > That's one way to do it. But if it's really just a one-time thing, then
> > you could easily perform the register write from the syscon driver where
> > the memory is already parsed from device tree and mapped. That way you
> > don't have to hardcode the physical address in some other random piece
> > of code and map the memory again.
>=20
> Well, except that we're using the general "syscon" driver.  I could
> create a whole new driver that "subclasses" this syscon driver I
> suppose.

Ah, I wasn't aware that there was even something like a generic syscon
driver. But yes, subclassing it sounds like a reasonable thing to do.

> >> I could follow the lead of those subsystem and do the same thing, but
> >> I haven't because of the reasons talked about in the patch
> >> description.  To summarize: I thought it was cleaner and would have
> >> less baggage to carry to put this code in an rk3288-specific function.
> >>
> >> There was no clean place to put rk3288-specific code such that it used
> >> the "syscon" interface like i2c/clk/pinctrl.  ...and adding a lot of
> >> infrastructure for something like that seems like a bit too much to
> >> me.  As it's written the code will never need to change (the physical
> >> address of GRF and this bit will always be right on rk3288) and
> >> hopefully nobody will need to think about it again.  ;)
> >
> > I understand that it looks cleaner this way. But it's completely the
> > wrong way around. We're trying to move code out of arch/arm and into
> > proper drivers.
>=20
> Yup, I understand that.  I did ask for some advice before posting this
> and I got the impression that folks thought that it would be fine to
> put it here, though.  I will let those folks clarify their thoughts
> and/or correct my understanding.

Sure.

Thierry

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9MDZAAoJEN0jrNd/PrOhZBQQAJ832usYddA42X6p6TGQJ1iS
joYKxpg9bomQdGVzyxp2yrmSkMi7PUvj7WXrwhWYUnYMebKoEJ3hStKiUxrEHHuZ
aaDFGVs5IN/nrOHrBeZE8s7m0Oc0lX02bfXRRKCgtHeXqCBgfsxn+pFHDGCzWyGp
X/2TVrj0XB+8hbkbyjrHegEyPt1p+7BSErA82cHklWt2DmbCmmF6t0k0e3y60TIP
iGJRvpkujCd7aYEe+BSWW6JUFCMIJtLEF/1N4moJ31Go21iCi6jSC2g+5gNTdLUC
oS/R4C88bc6ysn3Uc91awioA9c3hl/FvE+WVY+BFLFhsNDu/nSXmocJBXWpFgGYA
UNfMjojwSvB/y19/zAiSHVFj74NdBxOIbKN13Dgl25JvAbefRWrbiOJ/pR9KnbC5
b8qBjHWLU4MnyaiAadp+Wf2Ub/AcACio3z0icRhwX8+4cqAl9kDcslfwtbjr0yur
213IEy2E+0oGm+4wuJP3cCMEBWnimaStFV5sp6C+QbRqRHpGnSfByym9wZGDYAnk
j9FtpsTXHHdjgCefnDLIKFQh5dU4N+lhE+BPQzAxMcXHxnHHgMoT8Qo/Ikqp0hw7
JRf+WxNGJyefvvfyZ/Eh043k8JFlY05n6B7HuQ7fMk0rOOFULUrczNx6TKuF0ZiJ
EY6HpHZZiEPrK4VQfr6a
=0duP
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
