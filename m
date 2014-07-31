Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaGaQo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:44:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbaGaQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:44:23 -0400
Date: Thu, 31 Jul 2014 18:41:52 +0200
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
Message-ID: <20140731164152.GF3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731132223.GK30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBYeLQbK9sqbzZRV"
Content-Disposition: inline
In-Reply-To: <20140731132223.GK30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBYeLQbK9sqbzZRV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 02:22:23PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 31, 2014 at 09:44:40AM +0200, Maxime Ripard wrote:
> > I didn't miss it. But I feel like it describes quite nicely the slave
> > API, but doesn't help at all whenever you're writing a DMAengine driver.
>=20
> There's actually two documents:
>=20
> Documentation/crypto/async-tx-api.txt
> Documentation/dmaengine.txt
>=20
> The first is the original DMA engine API for use with offloading things
> like memcpy, as well as the crypto API to hardware crypto DMA engines.
>=20
> The second is documentation for the DMA slave API which modifies some
> of the requirements of the first (like, the ability to call the slave
> DMA prepare functions from within the callback, which are not permitted
> in the async tx API.)
>=20
> Both documents are relevant for writing a DMA engine driver.

They're both relevant, but clearly not enough.

> > Because, for the moment, we're pretty much left in the dark with
> > different drivers doing the same thing in completetely different ways,
> > with basically no way to tell if it's either the framework that
> > requires such behaviour, or if the author was just feeling creative.
>=20
> DMA engine has lacked a lot of infrastructure for common patterns in
> drivers; some of that is solved by my efforts with the virt_dma.c
> support, and also various cleanups to existing drivers, but it's not
> easy to fix this problem after drivers have been merged.
>=20
> > There's numerous examples for this at the moment:
> >   - The GFP flags, with different drivers using either GFP_ATOMIC,
> >     GFP_NOWAIT or GFP_KERNEL in the same functions
>=20
> The slave prepare APIs should be using GFP_ATOMIC to ensure safety.

You prove my point then. Vinod asks for GFP_NOWAIT in his
reviews. Even though it doesn't change anything relative to the
atomicity of the operations, the policy is still not the same.

> >   - Having to set device_slave_caps or not?
>=20
> device_slave_caps is a relatively new invention, so old drivers don't
> implement it.  Newer drivers should, and there probably should be some
> motivation for older drivers to add it.

Yep, just discovered that.

> >   - Some drivers use dma_run_depedencies, some other don't
>=20
> Dependent operations are part of the async-tx API, and aren't really
> applicable to the slave DMA API.  A driver implementing just the slave
> DMA API need not concern itself with dependent operations, but a
> driver implementing the async-tx APIs should do.

Ok.

> >   - That might just be my experience, but judging from previous
> >     commits, DMA_PRIVATE is completely obscure, and we just set it
> >     because it was making it work, without knowing what it was
> >     supposed to do.
>=20
> DMA_PRIVATE means that the channel is unavailable for async-tx operations
> - in other words, it's slave-only.  Setting it before registration results
> in the private-use count being incremented, disabling the DMA_PRIVATE
> manipulation in the channel request/release APIs (requested channels are
> unavailable for async-tx operations, which is why that flag is also set
> there.)
>=20
> To put it another way, if a DMA engine driver only provides slave DMA
> support, it must set DMA_PRIVATE to mark the channel unavailable for
> async-tx operations.  If a DMA engine drivers channels can also be used
> for async-tx operations, then it should leave the flag clear.

What about channels that can be both used for slave operations and
async-tx (like memcpy) ?

> > And basically, we have no way to tell at the moment which one is
> > right and which one needs fixing.
> >=20
> > The corollary being that it cripples the whole community ability to
> > maintain the framework and make it evolve.
>=20
> All respect to Vinod (who looks after the slave side of the DMA engine
> implementations) and Dan, what it needs is someone who knows the *whole*
> DMA engine picture to be in control of the subsystem, and who knows these
> details - not must one bit of it.  Someone who has the time to put into
> reviewing changes to it, and probably more importantly, has the time to
> clean up the existing code.  Finding someone who fits that is a struggle.
>=20
> Dan knows the whole picture (or used to when he was working on it at one
> of his former employers) but I don't think Dan had the available time to
> address various issues with it.

Hence why we should document as much as possible then, to spread the
knowledge and avoid it being lost when someone disappears or isn't
available anymore.

(And hopefully reduce the number of "errors" that might be done by
submitters, hence reducing the number of review iterations, lessening
the maintainers load)

> > > cookie is dma transaction representation which is monotonically incre=
menting
> > > number.
> >=20
> > Ok, and it identifies a unique dma_async_tx_descriptor, right?
>=20
> You really should not be concerned with DMA cookies anymore since one
> of my cleanups - I added a number of helper functions which hide the
> manipulation of DMA cookies, and take away from driver writers the
> semantics of how cookies themselves are operated upon.  virt-dma goes
> a little further and provides descriptor lists and methods to look up
> a descriptor given a cookie.
>=20
> The only thing that a driver writer should concern themselves with is
> making the appropriate cookie management calls at the relevant point in
> the code - in other words, allocating a cookie at in the submit callback,
> completing a cookie when a descriptor is complete, etc.
>=20
> Drivers should have no reason what so ever to be touching the cookie
> directly anymore.

Ok, thanks a lot for this!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UBYeLQbK9sqbzZRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2nHQAAoJEBx+YmzsjxAgPmQP/AlE+oiUohM/ViL5Wph2JtqH
xYAcjYopwgAMUS3sonP1B6InuGas2bah1l6ZtOnUv779OqWOPZNde++6Khz+eEh9
m3y2liasLcPlAwn2eHUYhKp/sngDJwHOU5YQVfuKPZdnOM4ZIYpNSezSw+cEq0TS
HZIZJEh9M2PjDHL9aABiH/Vj9zrt1Dl7A3HlprSqrdvZQ1ZbYOMLPm1nQZnOOvFY
2Zxg8sTZ5d3hIjR6OqF+gzN2SvEfsfV1qFjQvET++uFW9dZWJWeH6MC3SDOd3Du2
6EarvcYfRFB/Cl0qaeTqIqIvsDTIngXdOvLj4So/7M+khvptaSA/5bztEmlozZD+
swIDqIYE30gg/71r2ZQFJyhwenUetqC2R6GVixZbAF+rKlZJnXMSthzUR4NuYBib
cJb76XtYLek8G/owuqQ8nLH3susklmQsoLIU+p8Z6QY99rzQD5OzGXhHEc1Wgpxr
Uzv35QZs+/eDd/T7NKo887LUVTSZq3CXK4nK4wXM2nNO0TaY3lR1HXtcx+GiscYV
hM4ELg2PTiRCoPkN9EU6LEdXabYlXWP8DmC0swb64hqRxXRLwGIEYQhgRvHffScg
nWiQZJTtQ8bmid0N6jNZMz+2BvWQEQCyCA3b5Pt2VTWaeRd1q6NcqcuPx/Krs46L
G2aNrPdi1kkRGckZlXKf
=Bxt+
-----END PGP SIGNATURE-----

--UBYeLQbK9sqbzZRV--
