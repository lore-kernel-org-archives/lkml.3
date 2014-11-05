Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaKEK1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:27:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58580 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaKEK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:27:05 -0500
Date: Wed, 5 Nov 2014 11:26:59 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sean Paul <seanpaul@google.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@google.com>
Subject: Re: [RFC 09/10] drm/tegra: Add IOMMU support
Message-ID: <20141105102657.GB12458@ulmo.nvidia.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-10-git-send-email-thierry.reding@gmail.com>
 <CAOw6vbJy6oy7cibH4f332UM=kS56KUMcnYdUTG0pEYXyQkFDoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <CAOw6vbJy6oy7cibH4f332UM=kS56KUMcnYdUTG0pEYXyQkFDoQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 02:48:35PM -0400, Sean Paul wrote:
> On Thu, Jun 26, 2014 at 4:49 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > When an IOMMU device is available on the platform bus, allocate an IOMMU
> > domain and attach the display controllers to it. The display controllers
> > can then scan out non-contiguous buffers by mapping them through the
> > IOMMU.
> >
>=20
> Hi Thierry,
> A few comments from St=C3=A9phane and myself that came up while we were
> reviewing this for our tree.

I just realized that I hadn't integrated these comments completely yet,
but I've done so now in my local tree. I'm running a couple of tests to
verify that it's all handled correctly.

> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/gpu/drm/tegra/dc.c  |  21 ++++
> >  drivers/gpu/drm/tegra/drm.c |  17 ++++
> >  drivers/gpu/drm/tegra/drm.h |   3 +
> >  drivers/gpu/drm/tegra/fb.c  |  16 ++-
> >  drivers/gpu/drm/tegra/gem.c | 236 ++++++++++++++++++++++++++++++++++++=
+++-----
> >  drivers/gpu/drm/tegra/gem.h |   4 +
> >  6 files changed, 273 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> > index afcca04f5367..0f7452d04811 100644
> > --- a/drivers/gpu/drm/tegra/dc.c
> > +++ b/drivers/gpu/drm/tegra/dc.c
> > @@ -9,6 +9,7 @@
> >
> >  #include <linux/clk.h>
> >  #include <linux/debugfs.h>
> > +#include <linux/iommu.h>
> >  #include <linux/reset.h>
> >
> >  #include "dc.h"
> > @@ -1283,8 +1284,18 @@ static int tegra_dc_init(struct host1x_client *c=
lient)
> >  {
> >         struct drm_device *drm =3D dev_get_drvdata(client->parent);
> >         struct tegra_dc *dc =3D host1x_client_to_dc(client);
> > +       struct tegra_drm *tegra =3D drm->dev_private;
> >         int err;
> >
> > +       if (tegra->domain) {
> > +               err =3D iommu_attach_device(tegra->domain, dc->dev);
> > +               if (err < 0) {
> > +                       dev_err(dc->dev, "failed to attach to IOMMU: %d=
\n",
> > +                               err);
> > +                       return err;
> > +               }
>=20
> [from St=C3=A9phane]
>=20
> shouldn't we call detach in the error paths below?

This was mostly rewritten for universal plane support, but I've made
sure that the DC properly detaches from the IOMMU in case of failure
during the code below.

> > diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
[...]
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
> > +               if (IS_ERR(tegra->domain)) {
> > +                       kfree(tegra);
> > +                       return PTR_ERR(tegra->domain);
> > +               }
> > +
> > +               drm_mm_init(&tegra->mm, 0, SZ_2G);
>=20
>=20
> [from St=C3=A9phane]:
>=20
> none of these are freed in the error path below (iommu_domain_free and
> drm_mm_takedown)
>=20
> also |tegra| isn't freed either?

None of the resources were actually being cleaned up, but I think I have
it all handled properly now.

> > @@ -108,22 +240,33 @@ struct tegra_bo *tegra_bo_create(struct drm_devic=
e *drm, unsigned int size,
> >         host1x_bo_init(&bo->base, &tegra_bo_ops);
> >         size =3D round_up(size, PAGE_SIZE);
> >
> > -       bo->vaddr =3D dma_alloc_writecombine(drm->dev, size, &bo->paddr,
> > -                                          GFP_KERNEL | __GFP_NOWARN);
> > -       if (!bo->vaddr) {
> > -               dev_err(drm->dev, "failed to allocate buffer with size =
%u\n",
> > -                       size);
> > -               err =3D -ENOMEM;
> > -               goto err_dma;
> > -       }
> > -
> >         err =3D drm_gem_object_init(drm, &bo->gem, size);
> >         if (err)
> > -               goto err_init;
> > +               goto free;
> >
> >         err =3D drm_gem_create_mmap_offset(&bo->gem);
>=20
> We need to call drm_gem_free_mmap_offset if one of the calls below
> fails, otherwise we'll try to free the mmap_offset on an already
> destroyed bo.

drm_gem_object_release() (below) already calls drm_gem_free_mmap_offset()
for us implicitly.

Thierry

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWftxAAoJEN0jrNd/PrOhKrMP/RtRTVZ8WPiMpDpeOkQNJHP/
lVlWCiev/lXnsRrYLpZJ+1I2fNsprZZ9P3wkoBXY9pBYHeAbjUuat5kKuh45dsOd
poUVVpZHVagFD6rVrsfR3IKUFPgFcwQObggbDBP4GyY3KkyTmL/Kbuj1rvnqzxoI
N8HZwSWUMzkWqRujIl8qSkO12ulXArYR4KOlUfeKKP2DylyBSRtfmt+SgT+Z9ztT
r7Bm1ddx+kHkEgOICkEzDEccmaiLY+m+6qVxNtZrkOWDvS7OAKo5wvNOddsxX4bQ
07r3FwjBPGvsMsKNloVMc/ZdbOm9ch7lfy907RwWr7APA5flatAlFm+HpuBemY9v
mCEhV2v9l+zrt6cu4xIl2ArN7jU1sTFGCfXTeVZKZB/6bnKFR0uiyY1fvC55f9pB
tqxf9/2JiaKSePenJfuTyOuMZfbMj8TEY2/Rdl62SqBrR5pKqE1pPG7Ua4xQGdvy
VRb+SuvswSdfRCh+UgbpGSy7XAS/bP7RavJ3BhUgi9r6I3XJOeLZtD3y6L0Ka9ym
8ScEypIWB3L0/R3x52YiJBND7W8Mfvn+BiyAPl5rHI4AXU91yo83aQvTw/vIuwyM
5ar7L9i82XKIh8eFQ+NOCZFf4SwXbHDHOyiqKhwlyCc+PSXFn8du1l4726XJFFZU
2nWtMnH1dkWLV7rQ5Vhi
=XtvN
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
