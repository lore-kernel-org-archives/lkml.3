Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbbAPU0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:26:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40579 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbbAPU0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:26:01 -0500
Date: Fri, 16 Jan 2015 20:25:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Message-ID: <20150116202516.GL3856@sirena.org.uk>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
 <54B8C933.7020502@redhat.com>
 <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
 <20150116123705.GM3043@sirena.org.uk>
 <54B9629C.9090800@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="L/Qt9NZ8t00Dhfad"
Content-Disposition: inline
In-Reply-To: <54B9629C.9090800@redhat.com>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L/Qt9NZ8t00Dhfad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 08:12:28PM +0100, Hans de Goede wrote:
> On 16-01-15 13:37, Mark Brown wrote:

> >>It is probably a good idea to use regulator-boot-on and
> >>then test things this way, and if that works use
> >>regulator-boot-on.

> >No, it's unlikely that boot-on makes sense here - it's there for cases
> >where we can't read back the hardware state at power on.

> Which we cannot here since we've a gpio driven regulator, with the pin
> in output mode, so we cannot read it back. Or at least the current kernel
> implementation relies on regulator-boot-on rather then reading the
> state back from the hardware.

Right, this always seems like a problem with the GPIO API - not being
able to read the state back is a total pain for boot handover, we should
really have a way of reading back the current output state.  This is one
of the few cases where boot-on can be useful, though ideally it'd be set
by the bootloader rather than as a static thing since otherwise you have
the opposite problem in the case where the disk isn't being used at the
current time.

> While we're discussing this I would also like to advocate to change the
> behavior for regulator-boot-on to be the same as always-on when it comes
> to regulator_init_complete(), iow regulator-boot-on regulators should
> not be touched by regulator_init_complete(). It makes no sense to have
> different behavior for build in versus module drivers here.

Like I say boot-on is *only* intended to support bootstrapping, if you
want the regulator to be always on then mark it as always on.  If you
want some way of marking the end of userspace init so we can defer
cleanup of unused resources then go do that - it's a change I've
advocated before, it'd help with modular drivers in general.

> I believe we should still leave these on once userspace starts running,
> there is a reason they are marked as regulator-boot-on and the fact that
> we're ready to start running userspace does not take away that reason, to
> me regulator-boot-on means "do not turn off until explicitly told so by
> a driver which (hopefully) knows wtf it is doing".

No, that's not it at all - it just means that either the hardware didn't
support readback or we're working around our own limitations in not
being capable of doing that.  Remember, regulators are reference counted
so with a few exceptions drivers aren't saying "turn this off now"
they're saying "this device doesn't need this regulator right now, turn
it off if you like" and there's no guarantee that a driver will ever be
loaded in the first place.

--L/Qt9NZ8t00Dhfad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuXOrAAoJECTWi3JdVIfQz+AH/iTVjM6UoztE8KH6D4cdKvEC
K62qWmJP5la171aLSd1HF9W0NnF+SGQmc0tpeTNnj59pPhORznMcBP0aPzvLFIA+
Qjr19QzdIDo4z8Hd6EHhpJV/N25pLwHQb2Ei3r52vwArIx21TyedAReX73zBiyiX
zSDR/GSJzgOY/HN3Nxu8S+JxVfGseWEzvSubWKID5Lgjia1eLcH5uYjTaJsJM1QG
V14PPLaLXHQE1DUgam7IUstTO0ixeT8swTwZkxYF7lPngpZ2jfme7J3GhUofdaDn
ze7FcKfZY4XqJ/S/LNxo48SuMVSdmyFsTAjVKN5f5CpUZNZo+o7XFJ6r6TLvKTI=
=xv2A
-----END PGP SIGNATURE-----

--L/Qt9NZ8t00Dhfad--
