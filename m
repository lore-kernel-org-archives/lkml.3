Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaETLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:07:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41994 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETLHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:07:54 -0400
Date: Tue, 20 May 2014 13:05:37 +0200
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
Message-ID: <20140520110536.GA10302@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <14622654.QO8kH1AoTT@wuerfel>
 <20140519205945.GE30737@mithrandir>
 <5759340.gycj7cP1t3@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <5759340.gycj7cP1t3@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 12:04:54PM +0200, Arnd Bergmann wrote:
> On Monday 19 May 2014 22:59:46 Thierry Reding wrote:
> > On Mon, May 19, 2014 at 08:34:07PM +0200, Arnd Bergmann wrote:
> > > On Monday 19 May 2014 14:53:37 Thierry Reding wrote:
> > > > On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> > > > > On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > > > > > From: Thierry Reding <treding@nvidia.com>
[...]
> > > > > Finally, it makes no sense to use the dma-ranges property of the =
master's
> > > > > parent bus, because that bus isn't actually involved in the trans=
lation.
> > > >=20
> > > > My understanding here is mostly based on the OpenFirmware working g=
roup
> > > > proposal for the dma-ranges property[0]. I'll give another example =
to
> > > > try and clarify how I had imagined this to work:
> > > >=20
> > > > 	/ {
> > > > 		#address-cells =3D <2>;
> > > > 		#size-cells =3D <2>;
> > > >=20
> > > > 		iommu {
> > > > 			/*
> > > > 			 * This is somewhat unusual (or maybe not) in that we
> > > > 			 * need 2 cells to represent the size of an address
> > > > 			 * space that is 32 bits long.
> > > > 			 */
> > > > 			#address-cells =3D <1>;
> > > > 			#size-cells =3D <2>;
> > >=20
> > > You should never need #size-cells > #address-cells
> >=20
> > That was always my impression as well. But how then do you represent the
> > full 4 GiB address space in a 32-bit system? It starts at 0 and ends at
> > 4 GiB - 1, which makes it 4 GiB large. That's:
> >=20
> > 	<0 1 0>
> >=20
> > With #address-cells =3D <1> and #size-cells =3D <1> the best you can do=
 is:
> >=20
> > 	<0 0xffffffff>
> >=20
> > but that's not accurate.
>=20
> I think we've done both in the past, either extended #size-cells or
> taken 0xffffffff as a special token. Note that in your example,
> the iommu actually needs #address-cells =3D <2> anyway.

But it needs #address-cells =3D <2> only to encode an ID in addition to
the address. If this was a single-master IOMMU then there'd be no need
for the ID.

This really isn't specific to IOMMUs though. It really applies to all
cases where #address-cells and #size-cells are parsed. While it's way
too late to change the semantics of standard properties, perhaps for
properties that are introduced it would make more sense to encode this
as a <start limit> pair, both of length #address-cells, to avoid this
type of corner case.

On the other hand doing so would make it inconsistent with existing
bindings which may not be desirable either.

But since it seems like we're headed for something completely different
for IOMMUs, perhaps it would be worth considering to describe the IOMMU
range as <start limit>. Since it will likely use #iommu-cells rather
than #address-cells we have an opportunity to change the semantics.

> > > Let me do another example, with the address merged into the iommu
> > > references:
> > >=20
> > > / {
> > > 	#address-cells =3D <2>; // 64-bit address
> > > 	#size-cells =3D <2>;
> > >=20
> > > 	iommu@a {
> > > 		#address-cells =3D <2>; // 1 cell ID, 1 cell address
> > > 		#size-cells =3D <1>;
> > >=20
> > > 		// no need for #iommu-cells
> > > 	};
> > >=20
> > >=20
> > > 	master@b {
> > > 		iommus =3D <&/iommu@a // iommu
> > > 			0x23  	     // ID
> > > 			0x40000000   // window start
> > > 			0x10000000>; //window size
> > > 	};
> > > };
> > >=20
> > > A disadvantage of this model would be that for all ARM SMMU users, we=
'd
> > > have to always list a 4GB address space, which is kind of redundant.
> >=20
> > Isn't that the equivalent of the "whole address space" default that I
> > mentioned in the commit message? Could this be handled with
> > #address-cells =3D <1> and #size-cells =3D <0> in the iommu node? That =
way
> > the only cell that needs to be specified in iommus would be the ID and
> > the redundant address space could be simply omitted from DT since it
> > would be implied by the compatible string.
>=20
> Yes, that's right. After giving it some more thought, I agree that the
> #size-cells case makes sense as an indicator for cases where the master
> doesn't have to care about the address at all and no further translation
> with dma-ranges is possible.
>=20
> Back to my example with dma-ranges, the simplest case would an IOMMU
> that has an ID per bus, with multiple masters sharing that ID:
>=20
> / {
> 	#address-cells =3D <1>;
> 	#size-cells =3D <1>;
>=20
> 	iommu {
> 		#address-cells =3D <2>; // ID, address
> 		#size-cells =3D <2>;
> 	};
>=20
> 	master@a {
> 		iommus =3D <& {/iommu} 0xa 0x0  0x1 0x0>; // 4GB ID '0xa'
> 	}
>=20
> 	bus1 {
> 		#address-cells =3D <1>;
> 		#size-cells =3D <1>;
> 		ranges;
> 		iommus =3D <& {/iommu} 0 0   0x100 0>; // all IDs
> 		dma-ranges =3D <0  0xb 0  1 0>; // child devices use ID '0xb'
>=20
> 		anothermaster {
> 			// no iommus link, implied by dma-ranges above
> 		};
> 	};
> };
>=20
> If you set #size-cells=3D<0>, you can't really do that but instead would
> require an iommus property in each master, which is not a big concern
> either.

I'm not sure I understand the need for 0x100 (all IDs) entry above. If
bus1's iommus property applies to all devices on the bus, why can't the
ID 0xb be listed in the iommus property?

	bus1 {
		#address-cells =3D <1>;
		#size-cells =3D <1>;
		ranges;
		iommus =3D <&{/iommu} 0xb 0  0x1 0x0>; // 4GB ID '0xb'
		dma-ranges =3D <0  0xb 0  0x1 0x0>;

		anothermaster {
			...
		};
	};

In which case I guess dma-ranges would be redundant.

> The main advantage I think would be for IOMMUs that use the PCI b/d/f
> numbers as IDs. These can have #address-cells=3D<3>, #size-cells=3D<2>
> and have an empty dma-ranges property in the PCI host bridge node,
> and interpret this as using the same encoding as the PCI BARs in
> the ranges property.

I'm somewhat confused here, since you said earlier:

> After giving the ranges stuff some more thought, I have come to the
> conclusion that using #iommu-cells should work fine for almost
> all cases, including windowed iommus, because the window is not
> actually needed in the device, but only in the iommu, wihch is of course
> free to interpret the arguments as addresses.

But now you seem to be saying that we should still be using the
#address-cells and #size-cells properties in the IOMMU node to determine
the length of the specifier.

Thierry

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTezcAAAoJEN0jrNd/PrOh6bcP/ih+dF6WJALuoRlabAbr7DQk
o2sHgMsceoNdha7KuPKmjiaprGEuOtbR+FO55i+P6aNyoeiMcKGdJMGkx+ABcsYH
hjaKY1Wgh3TzOPpfMk5GHD9MdwAJBvTTOu/kbC1rfY+eFOkpgIovNFNGwQdZ0SgF
Dbc9NXiUhClauWoQhw3ofpwPVm1I/6deVc1jV4Tc5VPKY6AtMInbiNCuUwQ6JTeG
F33pUTq8iroLengI6lBYTc7tnBLwjxvLhVA49FOhTOJl0b/kd0l86Er6vgAVYaka
8LluvBMQ8SQLKWDT9w/8b2oqK7P7zeBtcZg3dQpyHnJqqW3Qyeptvhfz95Vs13Ik
tLc/V9FIIPW+5JTwpuAtYL10jRmEpM6Qa3z4TddLaj5zHcKS2BMtu2I4rZ/iZofs
4tCmyk03OgLN/rULYtW66elrzcELZ7x8gR4cvo4tyN1NXNNhcrp94/eWovcTEmk+
/pmZnuadX0vtSiZb89lZ3ekE/fVQEsU+IDh3HFD985R+Q86K0MO4/+kpDA8o79dx
bTuJBgeO75zVu6TLVliNyshHSpJWX3C9+zQZzpFR8ljd8RC4ij7eKzE8Nwp3bEK1
nHdnABX0NsTK2rOgoUTKGOUsw5H5OlhTDNn4wz/J5sBcxflI5UqA+n08Yh3W/oqd
J8rlBndVnXPLlCob1eSv
=5lQh
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
