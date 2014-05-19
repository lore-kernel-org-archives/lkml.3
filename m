Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaESU7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:59:53 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36515 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaESU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:59:50 -0400
Date: Mon, 19 May 2014 22:59:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140519205945.GE30737@mithrandir>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <4391809.OTRCiJQXS4@wuerfel>
 <20140519125336.GA9466@ulmo>
 <14622654.QO8kH1AoTT@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
Content-Disposition: inline
In-Reply-To: <14622654.QO8kH1AoTT@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 08:34:07PM +0200, Arnd Bergmann wrote:
> On Monday 19 May 2014 14:53:37 Thierry Reding wrote:
> > On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> > > On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >=20
> > > > This commit introduces a generic device tree binding for IOMMU devi=
ces.
> > > > Only a very minimal subset is described here, but it is enough to c=
over
> > > > the requirements of both the Exynos System MMU and Tegra SMMU as
> > > > discussed here:
> > > >=20
> > > >     https://lkml.org/lkml/2014/4/27/346
> > > >=20
> > > > More advanced functionality such as the dma-ranges property can eas=
ily
> > > > be added in a backwards-compatible way. In the absence of a dma-ran=
ges
> > > > property it should be safe to default to the whole address space.
> > > >=20
> > >=20
> > > The basic binding looks fine, but I'd like it to be more explicit
> > > about dma-ranges. Most importantly, what does "the whole address spac=
e"
> > > mean?
> >=20
> > The whole point was to leave out any mention of dma-ranges from the
> > binding until we've figured out more of the puzzle.
> >=20
> > So what I was trying to avoid was another lengthy discussion on the
> > topic of dma-ranges. Oh well... =3D)
>=20
> I think that can't work, because we need a way to specify the
> ranges for some iommu drivers. We have to make sure we at least
> don't prevent it from working.

That was precisely why I wanted to let this out of the binding for now
so that we can actually focus on making existing hardware work rather
than speculate about what we may or may not need.

If you think the current minimal binding will cause future use-cases to
break, then we should change it to avoid that. What you're proposing is
to make the binding more complex on the assumption that we'll get it
right.

Wouldn't it be safer to keep things to the bare minimum necessary to
represent hardware that we have access to and understand now, rather
than speculating about what may be necessary at some point. I'd much
prefer to add complexity on an as-needed basis and when we have a better
understand of where we're headed.

> > > Finally, it makes no sense to use the dma-ranges property of the mast=
er's
> > > parent bus, because that bus isn't actually involved in the translati=
on.
> >=20
> > My understanding here is mostly based on the OpenFirmware working group
> > proposal for the dma-ranges property[0]. I'll give another example to
> > try and clarify how I had imagined this to work:
> >=20
> > 	/ {
> > 		#address-cells =3D <2>;
> > 		#size-cells =3D <2>;
> >=20
> > 		iommu {
> > 			/*
> > 			 * This is somewhat unusual (or maybe not) in that we
> > 			 * need 2 cells to represent the size of an address
> > 			 * space that is 32 bits long.
> > 			 */
> > 			#address-cells =3D <1>;
> > 			#size-cells =3D <2>;
>=20
> You should never need #size-cells > #address-cells

That was always my impression as well. But how then do you represent the
full 4 GiB address space in a 32-bit system? It starts at 0 and ends at
4 GiB - 1, which makes it 4 GiB large. That's:

	<0 1 0>

With #address-cells =3D <1> and #size-cells =3D <1> the best you can do is:

	<0 0xffffffff>

but that's not accurate.

> > 			#iommu-cells =3D <1>;
> > 		};
> >=20
> > 		master {
> > 			iommus =3D <&/iommu 42>;
> > 			/*
> > 			 * Map I/O addresses 0 - 4 GiB to physical addresses
> > 			 * 2 GiB - 6 GiB.
> > 			 */
> > 			dma-ranges =3D <0x00000000 0 0x80000000 1 0>;
> > 		};
> > 	};
> >=20
> > This is somewhat incompatible with [0] in that #address-cells used to
> > parse the child address must be taken from the iommu node rather than
> > the child node. But that seems to me to be the only reasonable thing
> > to do, because after all the IOMMU creates a completely new address
> > space for the master.
> >=20
> > [0]: http://www.openfirmware.org/ofwg/proposals/Closed/Accepted/410-it.=
txt
>=20
> I don't think you can have a dma-ranges without a #address-cells and
> #size-cells property in the same node. In your example, I'd also expect
> a child node below 'master' that then interprets the address space
> made up by dma-ranges.

Okay, so what Dave and you have been saying strongly indicates that
dma-ranges isn't the right thing to use here.

> As a comment on the numbers in your example, I don't expect to ever
> see a 4GB IOMMU address space that doesn't start at an offset. Instead
> I'd expect either addresses that encode a device ID, or those that
> are just a subset of the parent address space, with non-overlapping
> bus addresses for each master.

As I understand the Tegra SMMU allows each of the clients to be assigned
a separate address space (4 GiB on earlier generations and 16 GiB on new
generations) and all addresses in each address space can be mapped to
arbitrary physical addresses.

> > > My preferred option would be to always put the address range into
> > > the iommu descriptor, using the iommu's #address-cells.
> >=20
> > That could become impossible to parse. I'm not sure if such hardware
> > actually exists, but if for some reason we have to split the address
> > range into two, then there's no longer any way to determine the size
> > needed for the specifier.
> >=20
> > On the other hand what you propose makes it easy to represent multiple
> > master interfaces on a device. With a separate dma-ranges property how
> > can you define which ranges apply to which of the master interfaces?
>=20
> Well, you could have multiple links to the same IOMMU if you want to=20
> do that, and define that there must be at least one dma-ranges entry
> for each IOMMU entry (although not necessarily the other way round,
> you could have direct ranges in addition to translated ones.
>=20
> > Then again if address ranges can't be broken up in the first place, then
> > dma-ranges could be considered to be one entry per IOMMU in the iommus
> > property.
>=20
> Let me do another example, with the address merged into the iommu
> references:
>=20
> / {
> 	#address-cells =3D <2>; // 64-bit address
> 	#size-cells =3D <2>;
>=20
> 	iommu@a {
> 		#address-cells =3D <2>; // 1 cell ID, 1 cell address
> 		#size-cells =3D <1>;
>=20
> 		// no need for #iommu-cells
> 	};
>=20
>=20
> 	master@b {
> 		iommus =3D <&/iommu@a // iommu
> 			0x23  	     // ID
> 			0x40000000   // window start
> 			0x10000000>; //window size
> 	};
> };
>=20
> A disadvantage of this model would be that for all ARM SMMU users, we'd
> have to always list a 4GB address space, which is kind of redundant.

Isn't that the equivalent of the "whole address space" default that I
mentioned in the commit message? Could this be handled with
#address-cells =3D <1> and #size-cells =3D <0> in the iommu node? That way
the only cell that needs to be specified in iommus would be the ID and
the redundant address space could be simply omitted from DT since it
would be implied by the compatible string.

Thierry

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTenDBAAoJEN0jrNd/PrOhyJMQALlqWBD/o11SfVlrp0WiRDpT
gfTikfeG3tYa5lBQNiW5lv2lWyn5MeHxspIwQk2hY3oodAAUTZZLU6EAB4QphYKa
IEFPHkxRdUfa684VUphYbCt6lFjVtwysKEtCUvxyOpeJki9DtpdHBL+x1HB15HBn
gIJFA+gLA2iZpzQc40IwKTrKp4HUq0Pv+jKz+4YJUTthHcojfYuYX8cFTNixyFcE
w61TIhn4JG67qx32rmfz3o1hbUJmZ0ZjawLEhzAG3TCBmxg2jbbVIYygke5qSfcs
o0kt5z7v9zfHFYj6iLB63uIatwKXzKoql5BtLcGxTKeqn8tY/S8N7QZkOm+jBQcA
jtP0WIh7UMuxCNXWLMDG9kZZWlvICC7nDcn/jPbMM5ew2ZxE6K7qrZ7tAMwGtwcP
2abXwLtFl2Fzvz76bADv23mqsJ5Q4v59yWOg+cFx/41DD0mbfRxbXtNecaVRWL0I
wgZgrcJ4pfdEkfcAlULCI1rYjdYTqq8f8eqZQno7L2gUDBlzbdvjBgXK4xzhuEWL
01+jB5pnZGRQXvarNa8krRNyzuNn9jx18RTLV+MuqCODRWcllAeGncf6cdZiYK2w
So2pJ9xuPOPJmmRBf1BSXxSt5KjvPldyGezxtpbw44fxSYBk5IRyH96yJYVxZ+/6
b6NEv2VPguh05Al+XL6k
=M1gh
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
