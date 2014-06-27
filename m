Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaF0K6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:58:22 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49615 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaF0K6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:58:20 -0400
Date: Fri, 27 Jun 2014 12:58:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hiroshi DOyu <hdoyu@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 09/10] drm/tegra: Add IOMMU support
Message-ID: <20140627105814.GB2797@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-10-git-send-email-thierry.reding@gmail.com>
 <20140627124614.050be2e406a4b9a02d9fe97c@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20140627124614.050be2e406a4b9a02d9fe97c@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 12:46:14PM +0300, Hiroshi DOyu wrote:
> Thierry Reding <thierry.reding@gmail.com> writes:
[...]
> > diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
[...]
> > +       if (tegra->domain) {
> > +               err =3D iommu_attach_device(tegra->domain, dc->dev);
>=20
> I wanted to keep device drivers iommu-free with the following:
>=20
> http://patchwork.ozlabs.org/patch/354074/

That patch only addresses the probe ordering problem that happens if the
user of an IOMMU is probed before the IOMMU. What this patch does is a
whole lot more.

> > diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
> > index 59736bb810cd..1d2bbafad982 100644
> > --- a/drivers/gpu/drm/tegra/drm.c
> > +++ b/drivers/gpu/drm/tegra/drm.c
> > @@ -8,6 +8,7 @@
> >   */
> >
> >  #include <linux/host1x.h>
> > +#include <linux/iommu.h>
> >
> >  #include "drm.h"
> >  #include "gem.h"
> > @@ -33,6 +34,16 @@ static int tegra_drm_load(struct drm_device *drm, un=
signed long flags)
> >         if (!tegra)
> >                 return -ENOMEM;
> >
> > +       if (iommu_present(&platform_bus_type)) {
> > +               tegra->domain =3D iommu_domain_alloc(&platform_bus_type=
);
>=20
> Can we use "dma_iommu_mapping" instead of domain?
>=20
> I thought that DMA API is on the top of IOMMU API so that it may be
> cleaner to use only DMA API.

Using the DMA API doesn't work for Tegra DRM because it assumes a 1:1
mapping between a device and an IOMMU domain. For Tegra DRM we have two
devices (two display controllers) that need to be able to access the
same buffers, therefore they need to share one IOMMU domain. This can't
be done using the DMA API.

The DMA API is fine to be used by devices that operate on "private" DMA
buffers (SDMMC, USB, ...).

> iommu_map_sg() could be implemented as iommu_ops->map_sg() for the
> better perf since iommu_map() needs some pagetable cache operations. If
> we do those cache operations at once, it would bring some perf benefit.

Yes, I agree that eventually this should be moved into the IOMMU core.
We could add a .map_sg() to IOMMU ops for devices where mapping a whole
sg_table at once would have significant performance benefits and change
this generic implementation to be used by devices that don't implement
=2Emap_sg(). Then the IOMMU core's iommu_map_sg() can call into the driver
directly or fallback to the generic implementation.

> I think that we don't need unmap_sg(), instead normal iommu_unmap() for
> a whole area could do the same at once?

Yes, I suppose that's true. I'll see if it can be safely dropped. It
might give us the same benefit as the iommu_map_sg() regarding cache
maintenance, though.

> > +static int iommu_unmap_sg(struct iommu_domain *domain, struct sg_table=
 *sgt,
> > +                         dma_addr_t iova)
> > +{
> > +       unsigned long offset =3D 0;
> > +       struct scatterlist *sg;
> > +       unsigned int i;
> > +
> > +       for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> > +               dma_addr_t phys =3D sg_phys(sg);
> > +               size_t length =3D sg->offset;
> > +
> > +               phys =3D sg_phys(sg) - sg->offset;
> > +               length =3D sg->length + sg->offset;
> > +
> > +               iommu_unmap(domain, iova + offset, length);
> > +               offset +=3D length;
> > +       }
> > +
> > +       return 0;
> > +}
>=20
> Can the rest of IOMMU API be replaced with DMA API too?

As I explained above, I don't see how it could be done for this driver.
But I don't think it has to. After all the IOMMU API does exist, so we
shouldn't shy away from using it when appropriate.

Thierry

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrU5GAAoJEN0jrNd/PrOh9HUP/jyvHUZ/JFNED5Eq40ROHHG1
CKrteGQAFXoheMvQGCPjPT3H2lOsuKqrgN7Vhi5F1kbeDswBOeC6Anhey+qCiuwD
6nhilO5rVt7UtN0I4BvsfLpDZ3PqzLiC9CMyxsMNVvarsRvFDQghJh6QDOQPGdTG
ag3JOlmX6K5EecehI4Kq8/Pvj5Bb1qsThoO4CdfdHIiubjTZ54OvqeQbNaxZMT5j
4urVajECrwMpMSouujsyrsTI3lZKYttb0uGz9l58BrTvPAZj9kPtQvmMl9yb1RWE
bzh3N4F7Sbl2QS7cawhFdax3FjQ64OizCQ8B+W9VDDcphSPDhotwGXH1P4ZdrvKm
LzQUD04NmN9G/L3PeMA3HfTWN4FRoC7Robz7wJfKO9A6VIiePFiqjsMEZ/dXASY7
J4SVBZdTIkOwUr1nkw0agknpKAkNk52n2MaF3EkJjcHC6PqvC1qRii+2XIP6XvNG
+z5w1SvP1JQa/AVrkZnLNaifak/u6uv1IdbhsQfI/7Gh//CsFl5rprKiRABHgBB/
UsTUIUHJzzpKChjx+r9Q3Qup0Df4k2ayWRvLnP61aL6ohUdjxZjEh7+vWdo1CH9f
dZL4m3sTRa1Psv4v/um12XJmq2JZLMidyjRA2+RjL3zpnQhe75L/b4EvI1pROSi9
VuKboEmwc6jCWvBXcV7y
=D77Y
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
