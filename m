Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3KAFDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:03:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab3KAFDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:03:43 -0400
Date: Fri, 1 Nov 2013 16:03:29 +1100
From: NeilBrown <neilb@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
Message-ID: <20131101160329.37f3707b@notabene.brown>
In-Reply-To: <1383280054.28909.30.camel@pasglop>
References: <20131101145925.66e22f73@notabene.brown>
	<1383279744.28909.26.camel@pasglop>
	<1383280054.28909.30.camel@pasglop>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RPGacO5Bz0VqzRh=oC1K5vN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RPGacO5Bz0VqzRh=oC1K5vN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Nov 2013 15:27:34 +1100 Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

> On Fri, 2013-11-01 at 15:22 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2013-11-01 at 14:59 +1100, NeilBrown wrote:
> > > and I wonder how relevant it still is in this context.  As platform d=
evices
> > > are all in the root of the device-tree and hence are siblings, they m=
ust have
> > > unique names in the device-tree and  so the platform devices created =
from
> > > them will also have unique names -- won't they?
> >=20
> > I agree about /sys/devices -> /sys/devices/platform, that makes more
> > sense
> >=20
> > The problem with names is that we don't *know* that your devices are
> > at the root and unique. They don't have to be. I have platforms that
> > have several "chips" each containing all the same devices. They need to
> > be de-duped.
> >=20
> > Maybe the right approach is to build the de-duplication in sysfs
> > itself ?

Do you mean we could allow multiple devices on the one bus to have the same
name, but get sysfs to notice and de-duplicate by mangling one name?  I don=
't
think I like that but I might have misunderstood.

On my device I seem to have some platform devices registered through
device-tree, and some registered through platform_device_add (e.g.
'alarmtimer').  Guaranteeing they remain disjoint sets if the kernel is
allowed to evolve independently of the devicetree might be tricky....
Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform" ??

Hoping someone who understands the device model better than me will help.

>=20
> BTW. How come you have devices at the root of the tree without "reg" ?
> It's fairly fishy ...=20
>=20
> The root of the tree is supposed to represent the processor address
> space, and has #address-cells/#size-cells set appropriately. Any MMIO
> mapped device shall thus have a "reg" property and a unit address.
>=20
> Only "container" nodes (such as /cpus or /chosen) or virtual devices
> (such as a node used to representing the collection of bits & pieces
> that makes the audio infrastructure) and are thus not per-se MMIO mapped
> entities can ommit the "reg" properties.
>=20
> In the case of pwm, it looks like there's another device providing a pwm
> capability, in which case your backlight would indeed be a "virtual
> device" (basically non-mmio device not hanging off any bus). Or it could
> have been represented as a child of pwm if that had been defined that
> way, I am not familiar with the pwm bindings.

The  'backlight' device is a virtual device.  It uses a 'pwm' device to
provide the variable brightness to the back light.

The 'pwm' device itself is virtual, making use of a 'dmtimer' to provide the
timing...  The timer device (timer11 in omap3.dtsi) has a 'reg' property.

A random example from current mainline is=20
  arch/arm/boot/dts/am335x-evmsk.dts
which has 'backlight' as a virtual device compatible with pwm-backlight.
It also has  'gpio-keys', 'gpio-leds', and 'regulator-fixed' compatible
virtual devices.  They seem fairly common.

Thanks,
NeilBrown


>=20
> Cheers,
> Ben.
>=20
> > Cheers,
> > Ben.
> >=20
> > > Any help understanding and/or fixing this discrepancy greatly appreci=
ated.
> > >=20
> > > The change of name is particularly annoying to me because one of my p=
latform
> > > devices is a pwm_bl.c backlight.  With a boardfile I
> > > get /sys/class/pwm_backlight.  With devicetree the best I can get
> > > is /sys/class/pwm_backlight.23 (or similar).  It would be really nice=
 to have
> > > a more stable and sensible name here.
> >=20
>=20


--Sig_/RPGacO5Bz0VqzRh=oC1K5vN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnM2ITnsnt1WYoG5AQLTbhAAuP2+H9KMaoDuVuC5LGtiWKcoEKR3t+Iw
+dd43omJwP+2u3nREzho3Ywhin9CP4PvxWkvIJxJ8/0ZK8Gf6KZNw8ATjXMh4jAU
daeSaLNVEQ5rO/Due4LLaSgAP6EorBuAsOwxS/N96yLTO3aLCCXacp+52F42GV+W
PpNm4ZVqUABLrqlFnHEBer6q1Z6VzwgA5XUMs3OUdaJBEax4bYs8w/eHcxi5Ju0B
scAwVXDPdiQ80TlS2A1UL4OXy3eSNzqvwUbScDIXmrvtKjiEvSHtj0Wtw6Pha1Ww
D6Jpy9PqUnU3CXgO2Y3zVjYWIMdbAqzrhMTSTUpetppz1JOywVRKo6ZlwfSMc4M0
Sa7eeicYwZ7pVmXOLAxQvm64vy0/9C3T6uam3u7R1TRJcneB15QTMaGEjY/9e+SB
ATk60mrNspAPC8Xw00DEF4zJScUoCuPWga5uxtFu8X+/qSOvUnRsu7Fk7l3GSrEw
e46wYssyKAg1seHluupi1g9YMxvBE/x6ly/nfbl+i+JjRGTeM1GDCxO1oxR9J38C
UTdOOb3RAbqVFdnDh6OiFlZy+L2yHg5b0653afHhZNRbBDlGh89VHpBQDHiGkkT3
Mm7bsvZd6/w7jB62p5l0HYIcx9CWirUFNTTP/PemdyBYEi2iG6J36M4bMvE13b1B
mnaxUWwZT5w=
=U6ao
-----END PGP SIGNATURE-----

--Sig_/RPGacO5Bz0VqzRh=oC1K5vN--
