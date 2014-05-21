Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaEUKw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:52:59 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46468 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaEUKw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:52:57 -0400
Date: Wed, 21 May 2014 12:50:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        iommu@lists.linux-foundation.org, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140521105034.GA2014@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <4367469.BqpJyVF8PT@wuerfel>
 <20140521090037.GA19268@ulmo>
 <5371868.4QO1YJ0hU2@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <5371868.4QO1YJ0hU2@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 11:36:32AM +0200, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 11:00:38 Thierry Reding wrote:
> > On Wed, May 21, 2014 at 10:50:38AM +0200, Arnd Bergmann wrote:
> > > On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:
>=20
> > > > > > For determining dma masks, it is the output address that it
> > > > > > important.  Santosh's code can probably be taught to handle thi=
s,
> > > > > > if given an additional traversal rule for following "iommus"
> > > > > > properties.  However, deploying an IOMMU whose output address s=
ize
> > > > > > is smaller than the=20
> > > > >=20
> > > > > Something seems to be missing here. I don't think we want to hand=
le
> > > > > the case where the IOMMU output cannot the entire memory address
> > > > > space. If necessary, that would mean using both an IOMMU driver
> > > > > and swiotlb, but I think it's a reasonable assumption that hardwa=
re
> > > > > isn't /that/ crazy.
> > > >=20
> > > > Similarily, should the IOMMU not be treated like any other device h=
ere?
> > > > Its DMA mask should determine what address range it can access.
> > >=20
> > > Right. But for that we need a dma-ranges property in the parent of the
> > > iommu, just so the mask can be set correctly and we don't have to
> > > rely on the 32-bit fallback case.
> >=20
> > Shouldn't the IOMMU driver be the one to set the DMA mask for the device
> > in exactly the same way that other drivers override the 32-bit default?
>=20
> The IOMMU driver could /ask/ for an appropriate mask based on its internal
> design, but if you have an IOMMU with a 64-bit output address connected
> to a 32-bit bus, that should fail.

Are there real use-cases where that really happens? I guess if we need
that the correct thing would be to bitwise AND both the DMA mask of the
IOMMU device (as set by the driver) with that derived from the IOMMU's
parent bus' dma-ranges property.

> Note that it's not obvious what the IOMMU's DMA mask actually means.
> It clearly has to be the mask that is used for allocating the IO page
> tables, but it wouldn't normally be used in the path that allocates
> pages on behalf of a DMA master attached to the IOMMU, because that
> allocation is performed by the code that looks at the other device's
> dma mask.

Interesting. If a DMA buffer is allocated using the master's DMA mask
wouldn't that cause breakage if the IOMMU and master's DMA masks don't
match. It seems to me like the right thing to do for buffer allocation
is to use the IOMMU's DMA mask if a device uses the IOMMU for
translation and use the device's DMA mask when determining to what I/O
virtual address to map that buffer.

Obviously if we always assume that IOMMU hardware is sane and can always
access at least the whole memory then this isn't an issue. But what if a
device can do DMA to a 64-bit address space, but the IOMMU can only
address 32 bits. If the device's DMA mask is used for allocations, then
buffers could reside beyond the 4 GiB boundary that the IOMMU can
address, so effectively the IOMMU wouldn't be able to write to those
buffers.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfIT6AAoJEN0jrNd/PrOhe+EQAIrfRaMfhOARFFEQ+bHIe9OM
IcY5BO/ZBqqp3Lh82bEflCwWWgmCXhu0x3hs77/6UTbs0+rbe+lymia/B7t9uC4M
pbE1SBD54hXD9K5R7VrgOQIcpfMO1Z+K5wkrDA4qvBI2+BZtTnXTflyNK3OPEF9e
IBwImKNfgfJ/QNAz5/5jbJf7jb1O06AS2gqw/In4vNI1NyYLdWvan8OtZxCXWRT+
V384XzjmdYS0lf6BhcCTCBF2DQZjjNNjFYeK6cZJMdcPLrduvEOCvjsSE7IRqlbP
xUZ1L9dGrt+aFYFCwrjUZn/tIojc5rKWKV+x2Sf4Y7y9MvXlBeA0wnhlIqN4AAvw
kbvB6hdeculGY6CbCZoPkhdxYheR6i9Z9S4/awHIcVna2zHXxFmJvmEB1FjflKRf
c2nI83+Mt7shhZacn0P5v2+mvEnCF8B2rykfe+F5yv7vjcCU53mM0ecbk+ebTYQz
QEJXOIdH73irPrUhEDQ8JVp6KN5WcheBBPxjySJbMn1DN8UxUaXj2y86H6Bhu6HE
q/vrLRue2cE25DLJwWm7+ajSny+xCtqJ1nX0KYhM/Sp/Cleaybwu0wtD9D1R9JPm
6ho/ZotGmhiVUxFmA5oOkdqLUelgUPydePJ5jraLo2wX9DAWYIbyhXh5fVVWs3Mz
rD4OdjkLwapAhMcXnMQm
=gZM1
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
