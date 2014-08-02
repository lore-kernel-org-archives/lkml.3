Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaHBTKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 15:10:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754723AbaHBTKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 15:10:04 -0400
Date: Sat, 2 Aug 2014 21:05:15 +0200
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
Message-ID: <20140802190515.GN3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731132223.GK30282@n2100.arm.linux.org.uk>
 <20140731164152.GF3952@lukather>
 <20140801145325.GR30282@n2100.arm.linux.org.uk>
 <20140802151144.GK3952@lukather>
 <20140802152921.GC30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aWauiwyUFlp3+edf"
Content-Disposition: inline
In-Reply-To: <20140802152921.GC30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aWauiwyUFlp3+edf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 02, 2014 at 04:29:21PM +0100, Russell King - ARM Linux wrote:
> On Sat, Aug 02, 2014 at 05:11:44PM +0200, Maxime Ripard wrote:
> > On Fri, Aug 01, 2014 at 03:53:26PM +0100, Russell King - ARM Linux wrot=
e:
> > > > > >   - That might just be my experience, but judging from previous
> > > > > >     commits, DMA_PRIVATE is completely obscure, and we just set=
 it
> > > > > >     because it was making it work, without knowing what it was
> > > > > >     supposed to do.
> > > > >=20
> > > > > DMA_PRIVATE means that the channel is unavailable for async-tx op=
erations
> > > > > - in other words, it's slave-only.  Setting it before registratio=
n results
> > > > > in the private-use count being incremented, disabling the DMA_PRI=
VATE
> > > > > manipulation in the channel request/release APIs (requested chann=
els are
> > > > > unavailable for async-tx operations, which is why that flag is al=
so set
> > > > > there.)
> > > > >=20
> > > > > To put it another way, if a DMA engine driver only provides slave=
 DMA
> > > > > support, it must set DMA_PRIVATE to mark the channel unavailable =
for
> > > > > async-tx operations.  If a DMA engine drivers channels can also b=
e used
> > > > > for async-tx operations, then it should leave the flag clear.
> > > >=20
> > > > What about channels that can be both used for slave operations and
> > > > async-tx (like memcpy) ?
> > >=20
> > > Then you don't set DMA_PRIVATE when the DMA engine driver registers w=
ith
> > > the core.  That then allows the DMA engine core to manage the flag,
> > > setting it when the channel is allocated for slave usage.
> >=20
> > Then I guess we currently have a bug related to this.
> >=20
> > During the development of the A31 driver that recently got merged,
> > during two subsequent channel allocation, the second would fail if
> > DMA_PRIVATE wasn't set.
> >=20
> > I think it was on in dmaengine_get, but I'll have to get back to you
> > on that whenever I'm back from my holydays.
>=20
> I think you mean dma_chan_get().  dmaengine_get() is used to obtain
> references to the async_tx memcpy/crypto channels, and should not be used
> by a driver making use of the slave capabilities.

Like I said, I don't remember where the actual issue was lying, but
ignoring DMA_PRIVATE prevented to allocate two channels at the same
time in my case.

When I'll have access again to my board, I'll try to dig more into it.

> There two systems are slightly competitive between each other.  Slave
> stuff generally want to get hold of specific channels, whereas the
> async_tx stuff can generally do with any channel which provides the
> appropriate capabilities, and can switch between channels if it needs
> to perform a series of operations only supported by separate channels.
>=20
> > You can also add vchan scheduling or descriptor allocations. The atmel
> > guys seem to have hit a performance issue with dma_pool_alloc, so they
> > re-developped a descriptor allocation mechanism in their driver. I
> > don't have much more details on this, but if that was to be true, that
> > would definitely be something that should be in the framework.
>=20
> It is entirely legal for a dmaengine driver to maintain its own list of
> "free" transaction descriptors (that's actually what many async-tx
> drivers do) and is partly why there's the alloc_chan_resources and
> free_chan_resources callbacks.
>=20
> However, they tend to be fairly large structures, and don't always
> match what the hardware wants, so using them to describe the individual
> scatterlist elements of a transaction is not always a good idea.

I was not really claiming it was illegal, but rather that it could be
useful for other drivers too.

> > vchan mapping to physical channels also seem to be quite common in the
> > drivers. That would be a nice addition too.
>=20
> It's intentionally not in the vchan interface because that mapping is
> device specific.
>=20
> For example, there are some DMA engine implementations where certain
> physical DMA channels should not be used because they have slightly
> different properties (for example, they can lock the CPU off the bus
> if they're permanently transferring data, such as in a memcpy or
> device-to-memory transfer where the device always has data available.)
>=20
> In any case, I'm not interested in seeing vchan turning into another
> "layer" - it must remain a library.  Layers are bad news. :)

Yeah, I was assuming there would be such constraints. Still, handling
the trivial case where you can map any vchan to any free physical
channels is very painful, while at least a couple of drivers implement
the same dumb logic.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--aWauiwyUFlp3+edf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3TZrAAoJEBx+YmzsjxAg0uQQALZW9oBjVLypTQynrGGoY7zR
cQ/gKA3PkckZB0f0dorcq7G032ZIU5ZGocJhR4nw5bwJ2zo/qZsw/nD02oSsMx19
3tEiMgFrpaWAjRhh9fOo6aj848ZHRAXdVdIvn6RPSRed7+e0jkS1VEMpNLNrB/lI
WzKVwr6GKZG1GO3Or6lakc4sAahOkJwSzPv1FU36AxL+Ug2bJf+jxA+DX8I/AhsT
G2ee5ShuEwNGVqFCNVaGe8mqJw4VOmqoJHxzEAxrUmAnVY5v68HjcNix3E1jd9dg
EHEue388DTfT0oQbbTVqpZ2kxZrZTDw7zcWIM+kTEWsMF4lTJkx1cotGYUWmfuUc
VGmfDiaNBxEdq8VIrSUgWKZODAunahEsSjjsdm0m6oBDkUABcLNRPKS8qkxmLf+o
Jl5psNuFOD7o6uWBvYssH7UbWYsBrb+nEO1QcGjVDaiXlm8XMJ0kdkWM8bKg85Sf
POMQ6Op7bs89UNdTAT+xz4zfqEHrO9XCTg79xqMgt1aD+3lPrGlTA965w9oRRusb
iZE2Vq4m1vC2q+C7wfxsO8Imrt2E2WaMQ/fjOlwbLUez+v8RHPe7qaqhGZenDIkH
VZbjdbZsoIZ3mzhfNFhxDxj6PGo0DNbdmdtwJtpwY5fqdua88O6GFCRs41MqM5LS
XCpYoCGFIbj0SwhYR/Qi
=XOnT
-----END PGP SIGNATURE-----

--aWauiwyUFlp3+edf--
