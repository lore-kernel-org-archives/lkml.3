Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaESMz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:55:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaESMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:55:52 -0400
Date: Mon, 19 May 2014 14:53:37 +0200
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
Message-ID: <20140519125336.GA9466@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <4391809.OTRCiJQXS4@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <4391809.OTRCiJQXS4@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This commit introduces a generic device tree binding for IOMMU devices.
> > Only a very minimal subset is described here, but it is enough to cover
> > the requirements of both the Exynos System MMU and Tegra SMMU as
> > discussed here:
> >=20
> >     https://lkml.org/lkml/2014/4/27/346
> >=20
> > More advanced functionality such as the dma-ranges property can easily
> > be added in a backwards-compatible way. In the absence of a dma-ranges
> > property it should be safe to default to the whole address space.
> >=20
>=20
> The basic binding looks fine, but I'd like it to be more explicit
> about dma-ranges. Most importantly, what does "the whole address space"
> mean?

The whole point was to leave out any mention of dma-ranges from the
binding until we've figured out more of the puzzle.

So what I was trying to avoid was another lengthy discussion on the
topic of dma-ranges. Oh well... =3D)

> A lot of IOMMUs have only 32-bit bus addresses when targetted
> by a bus master, it would also be normal for some to be smaller and
> some might even support 64-bit.
>=20
> For the upstream side, I'd hope we always have access to the full
> physical memory, but since this is a brand-new binding, it should
> be straightforward to just ask for upstream dma-ranges properties
> to be set all the way up to the root to confirm that.
>=20
> For downstream, we don't actually have a good place to put the
> dma-ranges property.

I'm not sure I understand what you mean by upstream and downstream in
this context.

> We can't put it into the iommu node, because  that would imply translating
> to the iommu's parent bus, not the iommu's own bus space.

My understanding was that the purpose of dma-ranges was to define a
mapping from one bus to another. So the general form of

	child-address  parent-address  child-size

Would be used to translate a region of size <child-size> from the
<child-address> (the I/O address space created by the IOMMU) to the
<parent-address> (physical address space).

> We also can't put it into the master, because dma-ranges is supposed to be
> in the parent bus.

I don't understand. From the above I would think that the master's node
is precisely where it belongs.

> Finally, it makes no sense to use the dma-ranges property of the master's
> parent bus, because that bus isn't actually involved in the translation.

My understanding here is mostly based on the OpenFirmware working group
proposal for the dma-ranges property[0]. I'll give another example to
try and clarify how I had imagined this to work:

	/ {
		#address-cells =3D <2>;
		#size-cells =3D <2>;

		iommu {
			/*
			 * This is somewhat unusual (or maybe not) in that we
			 * need 2 cells to represent the size of an address
			 * space that is 32 bits long.
			 */
			#address-cells =3D <1>;
			#size-cells =3D <2>;

			#iommu-cells =3D <1>;
		};

		master {
			iommus =3D <&/iommu 42>;
			/*
			 * Map I/O addresses 0 - 4 GiB to physical addresses
			 * 2 GiB - 6 GiB.
			 */
			dma-ranges =3D <0x00000000 0 0x80000000 1 0>;
		};
	};

This is somewhat incompatible with [0] in that #address-cells used to
parse the child address must be taken from the iommu node rather than
the child node. But that seems to me to be the only reasonable thing
to do, because after all the IOMMU creates a completely new address
space for the master.

[0]: http://www.openfirmware.org/ofwg/proposals/Closed/Accepted/410-it.txt

> My preferred option would be to always put the address range into
> the iommu descriptor, using the iommu's #address-cells.

That could become impossible to parse. I'm not sure if such hardware
actually exists, but if for some reason we have to split the address
range into two, then there's no longer any way to determine the size
needed for the specifier.

On the other hand what you propose makes it easy to represent multiple
master interfaces on a device. With a separate dma-ranges property how
can you define which ranges apply to which of the master interfaces?

Then again if address ranges can't be broken up in the first place, then
dma-ranges could be considered to be one entry per IOMMU in the iommus
property.

Thierry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTef7QAAoJEN0jrNd/PrOhEhcP/RnunYI1MsoTF5WgGp40ph4R
LRO8Izry3NaFy/0XHjDeeZw/nuQ8KOQMRX3E8QartFceZokiYXEJuJ/k3xhgA+jI
tpPWunoUkcOKkWJwLFDIh6zuF5T4V+2TxaK4xOv8sxDbnhO984+OcZWpYgrNn4Ho
E8xB0TBVfBomWb5VOvWliPV1s6/KYFKMEGbfRm8HiCg2myAAwgGZcKZ3uE7VgjDY
w3ZMJ7c+XtqyljWAWSFJh6BpH9Xelt6GwP/Qpdw6du/lvn+qfS08WydhbJvWzYpF
gv/RKBzWBPbSrdDOAakX/1xYAtuuM7sxobWvCFUhWBmbRyCLeQLPzb8PEGRyB3x/
1uS0d3ol64yXao94gQycRy3dx1YDQFF6wIrFMnZT9MT0iop8HHrc6f49VCpvEJsz
rwlf4nZAc+C+Duyj1n8Niqbcj122Pa0698aHqJTJK62UNQW5iCFBpluzp9/MerNQ
7QaU7G6nGo8mJIlVDPVrQ16XtA4OiJTtvtpqVDwz/7DIb5sewXwbXXq+GGWzD/Mh
5lTq3bfIeMpvEKnKXp+WJvagAXjvtBix+PuBHivP9hFD0F4cxYooViZk9DksoMPy
Nlrh+Ob0dc8Ya57WVMIhlWHVakB/1fVKRXzoEfZ4nHY62pTAEdFeDfGcQ1jypsMB
+clp4pRKrtHCLLamnU1v
=Aulo
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
