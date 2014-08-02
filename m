Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaHBPPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 11:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47683 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbaHBPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 11:15:04 -0400
Date: Sat, 2 Aug 2014 17:11:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140802151144.GK3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731132223.GK30282@n2100.arm.linux.org.uk>
 <20140731164152.GF3952@lukather>
 <20140801145325.GR30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x/TyKPcLwmKZr+b7"
Content-Disposition: inline
In-Reply-To: <20140801145325.GR30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x/TyKPcLwmKZr+b7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 03:53:26PM +0100, Russell King - ARM Linux wrote:
> > > >   - That might just be my experience, but judging from previous
> > > >     commits, DMA_PRIVATE is completely obscure, and we just set it
> > > >     because it was making it work, without knowing what it was
> > > >     supposed to do.
> > >=20
> > > DMA_PRIVATE means that the channel is unavailable for async-tx operat=
ions
> > > - in other words, it's slave-only.  Setting it before registration re=
sults
> > > in the private-use count being incremented, disabling the DMA_PRIVATE
> > > manipulation in the channel request/release APIs (requested channels =
are
> > > unavailable for async-tx operations, which is why that flag is also s=
et
> > > there.)
> > >=20
> > > To put it another way, if a DMA engine driver only provides slave DMA
> > > support, it must set DMA_PRIVATE to mark the channel unavailable for
> > > async-tx operations.  If a DMA engine drivers channels can also be us=
ed
> > > for async-tx operations, then it should leave the flag clear.
> >=20
> > What about channels that can be both used for slave operations and
> > async-tx (like memcpy) ?
>=20
> Then you don't set DMA_PRIVATE when the DMA engine driver registers with
> the core.  That then allows the DMA engine core to manage the flag,
> setting it when the channel is allocated for slave usage.

Then I guess we currently have a bug related to this.

During the development of the A31 driver that recently got merged,
during two subsequent channel allocation, the second would fail if
DMA_PRIVATE wasn't set.

I think it was on in dmaengine_get, but I'll have to get back to you
on that whenever I'm back from my holydays.

> One important point here is that async_tx does not have the idea of
> channel allocation - a channel which is registered into the DMA engine
> core without DMA_PRIVATE set is a candidate for use by the async_tx
> API.
>=20
> > Hence why we should document as much as possible then, to spread the
> > knowledge and avoid it being lost when someone disappears or isn't
> > available anymore.
> >=20
> > (And hopefully reduce the number of "errors" that might be done by
> > submitters, hence reducing the number of review iterations, lessening
> > the maintainers load)
>=20
> The bigger issue in the longer run is being able to maintain and improve
> the DMA engine implementations and API.  One of the blockers to that is
> properly understanding all the async_tx API stuff, something which even
> I have been unable to do despite knowing a fair amount about DMA engine
> itself.
>=20
> Where I fall down is the exact meaning of the ACK stuff, how the chaining
> is supposed to work, how the dependency between two DMA channels are
> handled.
>=20
> This is why I was unable to resolve DMA engine's multiple mapping of the
> same DMA buffers, which has caused problems for ARM.
>=20
> I've discussed this point in the past with Dan, making the point that
> each DMA engine driver should not be that concerned about things like
> descriptor list management, cookies, dependent transfers, but we seem
> to be ultimately doomed to re-implementing much of that infrastructure
> in every single DMA engine driver that comes along.

You can also add vchan scheduling or descriptor allocations. The atmel
guys seem to have hit a performance issue with dma_pool_alloc, so they
re-developped a descriptor allocation mechanism in their driver. I
don't have much more details on this, but if that was to be true, that
would definitely be something that should be in the framework.

vchan mapping to physical channels also seem to be quite common in the
drivers. That would be a nice addition too.

> Each DMA engine driver which gets accepted into mainline makes this
> problem worse - it's another driver which does something slightly
> differently that if we were to ever clean this stuff up, would need
> to be fixed.  This remains my biggest concern with the DMA engine
> code today, and I'm one of the few people who have put effort into
> trying to sort that out.

Yep. It's one of mine too, I'm willing to help if possible.

> > > Drivers should have no reason what so ever to be touching the cookie
> > > directly anymore.
> >=20
> > Ok, thanks a lot for this!
>=20
> I notice that drivers/dma/sirf-dma.c directly touches it and the
> completed cookie as well:
>=20
> drivers/dma/sirf-dma.c: dma_cookie_t last_cookie =3D 0;
> drivers/dma/sirf-dma.c:                         last_cookie =3D desc->coo=
kie;
> drivers/dma/sirf-dma.c:                 schan->chan.completed_cookie =3D =
last_cookie;
>=20
> That's something which should be fixed.  I haven't looked too hard
> because it's not something I want to get involved with again right
> now.

By quickly looking at the code, it looks like dead code. I guess it
could just be removed.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--x/TyKPcLwmKZr+b7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3P+wAAoJEBx+YmzsjxAgLXEP/i+UszIzVEzJ1C4jE7qsFQjx
7cQTFcF2Z8oMYYfun3ULCEeN5Og6pd/MYU01U9muozl8F54xisLJKBXion0U3FGF
Q9JKHM1WqfdbkdE4oFtjnk25mXSkFxXU1tQF0mSV1aF2JEaPabirgx9II2PEqVQy
nqiJTHKVqND6xTl6ipm8S+7BephdphZ7nbiYHeelanYXk0Lc1wn9Nye7WEcD7eXP
2oe6Kuwcgpj91Jno3QLlo9GCxbX4UUX8MuLm5SIUzrFsQz85gDyQW3yn8au2tnhD
EIosdYqCH3mkODQ33BKqW0T09VtVhwPJz/VC2PPa3UmFmh4rAQIcZthYMkgTI6p5
ba6rtBRBwy8E+Z9+0TPh8AwLgVRDBNfdHkFXo88DcBvVioz5g+AHPKJTS1AuN2k3
qOFBuAolJjddVfwPDWmDsV8VLJgr+LLscrQ/RIcEIMZ3BbvVqjaxFcGQLyd1j1H4
h6r5d93syBMT7Lj0qkpwUKnaCaTtcFksf2OW4GetDdSqPqy9xoUXpuOIdwI3AeWS
NCpd82z6DWoYJ6Ih1leScdvHSsDTkLQXqfCOf5Xgca+jjl/oDFVV/8f8RmEEKkD2
Vkf+tYl7zA375Nx05rRGkHPXIqFbDD9BmVU5DaqpgqdrRmMly9nTU0Rv0q3rtPg0
PdZaFXHut9O1QDetpQsR
=R536
-----END PGP SIGNATURE-----

--x/TyKPcLwmKZr+b7--
