Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaHTGIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:08:07 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56671 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHTGIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:08:05 -0400
Date: Wed, 20 Aug 2014 08:08:01 +0200
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
Message-ID: <20140820060759.GD13793@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-2-git-send-email-dianders@chromium.org>
 <20140819071011.GC12859@ulmo>
 <CAD=FV=Xr4ywGT_pPK=r6f6tfVpwbduUY7D5LK61HVtc8=JmkaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Xr4ywGT_pPK=r6f6tfVpwbduUY7D5LK61HVtc8=JmkaA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 08:18:54AM -0700, Doug Anderson wrote:
> Thierry,
>=20
> On Tue, Aug 19, 2014 at 12:10 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrote:
> >> The rk3288 SoC has an option to switch all of the PWMs in the system
> >> between the old IP block and the new IP block.  The new IP block is
> >> working and tested and the suggested PWM to use, so setup the SoC to
> >> use it and then we can pretend that the other IP block doesn't exist.

A few more questions as to how this actually works. Does it mean there
are two physically separate blocks (with different physical addresses)
to control the same PWM? And this register simply causes some of the
pins to be routed to one or another? As far as I recall there are a
number of instances of the PWM block, so the above would need to count
for all of them. Or are there separate bits for each of them?

> >> This code could go lots of other places, but we've put it here.  Why?
> >> - Pushing it to the bootloader just makes the code harder to update in
> >>   the field.  If we later find a bug in the new IP block and want to
> >>   change our mind about what to use we want it to be easy to update.

Depending on how this muxing works you won't be able to change your mind
anyway. If the IP blocks are different then the device tree will
effectively make the decision for you. So if you really want to be safe
you'd need to have code in the kernel that parses the device tree and
checks that all PWM instances are of the new type, then set this
register accordingly.

Or you don't set the bit from the driver and need to verify that device
tree and syscon match to avoid using the wrong controller.

> >> - Putting this code in the driver for IP block is a lot of extra work,
> >>   device tree bindings, etc.  Now that the new IP block is validated
> >>   it's likely no future SoCs will need this code.  Why pollute the PWM
> >>   driver with this?  This is an rk3288 thing so it should be in rk3288
> >>   code.
> >> - There's a single bit that switches over PWMs, which makes it extra
> >>   hard to put this under the PWM device tree nodes.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  arch/arm/mach-rockchip/rockchip.c | 19 +++++++++++++++++++
> >>  1 file changed, 19 insertions(+)
> >>
> >> diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchi=
p/rockchip.c
> >> index 8ab9e0e..99133b9 100644
> >> --- a/arch/arm/mach-rockchip/rockchip.c
> >> +++ b/arch/arm/mach-rockchip/rockchip.c
> >> @@ -24,6 +24,24 @@
> >>  #include <asm/hardware/cache-l2x0.h>
> >>  #include "core.h"
> >>
> >> +static void __init rk3288_init_machine(void)
> >> +{
> >> +     void *grf =3D ioremap(0xff770000, 0x10000);
> >
> > This region of memory is part of the "grf" "syscon" device (according to
> > arch/arm/boot/dts/rk3288.dtsi) so the register should be accessed from
> > that driver. It looks as if no such driver currently exists, but given
> > the existence of the device tree node it's fair to assume that one will
> > eventually be merged.
>=20
> The "grf" syscon device is the "general register file".  It's a
> collection of totally random registers stuffed together in one address
> space.  Sometimes a single 32-bit register has things you need to
> tweak for completely different subsystems.
>=20
> Most drivers referene the syscon using this in dts:
>   rockchip,grf =3D <&grf>;
>=20
> Then the drivers do:
>   grf =3D syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
>=20
>=20
> See the Rockchip i2c, pinctrl, or clock drivers for examples.

That's one way to do it. But if it's really just a one-time thing, then
you could easily perform the register write from the syscon driver where
the memory is already parsed from device tree and mapped. That way you
don't have to hardcode the physical address in some other random piece
of code and map the memory again.

> I could follow the lead of those subsystem and do the same thing, but
> I haven't because of the reasons talked about in the patch
> description.  To summarize: I thought it was cleaner and would have
> less baggage to carry to put this code in an rk3288-specific function.
>=20
> There was no clean place to put rk3288-specific code such that it used
> the "syscon" interface like i2c/clk/pinctrl.  ...and adding a lot of
> infrastructure for something like that seems like a bit too much to
> me.  As it's written the code will never need to change (the physical
> address of GRF and this bit will always be right on rk3288) and
> hopefully nobody will need to think about it again.  ;)

I understand that it looks cleaner this way. But it's completely the
wrong way around. We're trying to move code out of arch/arm and into
proper drivers.

Thierry

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9Ds/AAoJEN0jrNd/PrOhW4EP/R4Br7hoORj2UWcUk/HaBAQa
y01+BbqYaT9mJJhgoSXcgtaFM6Qz2kKCZhzurlL3qlV3+jXqVu65zxra4qCxmadp
qXZM+f5L23A9zRIKghvQdgWYbRj/irflOOIhHeaL36lZ8cVofuQsP/cWDUQSxKEn
tHa6LGCKBUD+OomcBINe3l5JnPh/IL6FRR2h251e6sb/baL23hyKYJdQYRKROfL4
ZZH/d9WL2JKbWs5A8grM06BdyvgoSQf6zT7Zzdrlx0mGelRVvROYTyk8FkWUEPJp
vG2jG7rJYSjeX1gcIJKsBsHSUSa5rbMwMDDcQ7fXexj2cZsdFEKvmzZ0DKbKW3mL
yrIiHgaBuXre381m4pEnh+Pum9pR3QwITgMHbrWtoKGgWqrntDreUEgGZG+/R5At
h2nhE0kqAl/1piUpq7pMgBTer1nVv3GIL+YG36fc4kgbA3HUWecT7t8OPuPafV7E
UOcoKdggUKc2hdmNs8X2Ry2D+4IV4wZWpp8/LLl863QmKEppMgaTIZ/1v/bXHxCF
gU81VGg7oTVfRzjCKzyUpHjKc6EdCmCk9B+Fptw07b56fHBlKMQTq5QG/0jZxabV
Q19VQY9VIhIzRnJwEq/tp55qfHpfBzsFCqtz7vVxjEPiv5ljLe9NU6NVsMXp3y7r
J+oa4OFJVEeIazOFn5Ev
=2FHj
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
