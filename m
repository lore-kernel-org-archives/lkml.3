Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaJBIjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:39:52 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40499 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaJBIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:39:46 -0400
Date: Thu, 2 Oct 2014 10:39:42 +0200
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
Message-ID: <20141002083941.GE30167@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-10-git-send-email-thierry.reding@gmail.com>
 <CAOw6vbJy6oy7cibH4f332UM=kS56KUMcnYdUTG0pEYXyQkFDoQ@mail.gmail.com>
 <CAOw6vbLFLrqWYB-4N50G7oucgMD+xd+QtdcMSzX4z7xRiU-vPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7CZp05NP8/gJM8Cl"
Content-Disposition: inline
In-Reply-To: <CAOw6vbLFLrqWYB-4N50G7oucgMD+xd+QtdcMSzX4z7xRiU-vPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7CZp05NP8/gJM8Cl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 11:54:11AM -0400, Sean Paul wrote:
> On Tue, Sep 30, 2014 at 2:48 PM, Sean Paul <seanpaul@google.com> wrote:
> > On Thu, Jun 26, 2014 at 4:49 PM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> When an IOMMU device is available on the platform bus, allocate an IOM=
MU
> >> domain and attach the display controllers to it. The display controlle=
rs
> >> can then scan out non-contiguous buffers by mapping them through the
> >> IOMMU.
> >>
> >
> > Hi Thierry,
> > A few comments from St=C3=A9phane and myself that came up while we were
> > reviewing this for our tree.
> >
> >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >> ---
> >>  drivers/gpu/drm/tegra/dc.c  |  21 ++++
> >>  drivers/gpu/drm/tegra/drm.c |  17 ++++
> >>  drivers/gpu/drm/tegra/drm.h |   3 +
> >>  drivers/gpu/drm/tegra/fb.c  |  16 ++-
> >>  drivers/gpu/drm/tegra/gem.c | 236 +++++++++++++++++++++++++++++++++++=
++++-----
> >>  drivers/gpu/drm/tegra/gem.h |   4 +
> >>  6 files changed, 273 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> >> index afcca04f5367..0f7452d04811 100644
> >> --- a/drivers/gpu/drm/tegra/dc.c
> >> +++ b/drivers/gpu/drm/tegra/dc.c
> >> @@ -9,6 +9,7 @@
> >>
> >>  #include <linux/clk.h>
> >>  #include <linux/debugfs.h>
> >> +#include <linux/iommu.h>
> >>  #include <linux/reset.h>
> >>
> >>  #include "dc.h"
> >> @@ -1283,8 +1284,18 @@ static int tegra_dc_init(struct host1x_client *=
client)
> >>  {
> >>         struct drm_device *drm =3D dev_get_drvdata(client->parent);
> >>         struct tegra_dc *dc =3D host1x_client_to_dc(client);
> >> +       struct tegra_drm *tegra =3D drm->dev_private;
> >>         int err;
> >>
> >> +       if (tegra->domain) {
> >> +               err =3D iommu_attach_device(tegra->domain, dc->dev);
> >> +               if (err < 0) {
> >> +                       dev_err(dc->dev, "failed to attach to IOMMU: %=
d\n",
> >> +                               err);
> >> +                       return err;
> >> +               }
> >
> > [from St=C3=A9phane]
> >
> > shouldn't we call detach in the error paths below?
> >
> >
> >> +       }
> >> +
> >>         drm_crtc_init(drm, &dc->base, &tegra_crtc_funcs);
> >>         drm_mode_crtc_set_gamma_size(&dc->base, 256);
> >>         drm_crtc_helper_add(&dc->base, &tegra_crtc_helper_funcs);
> >> @@ -1318,7 +1329,9 @@ static int tegra_dc_init(struct host1x_client *c=
lient)
> >>
> >>  static int tegra_dc_exit(struct host1x_client *client)
> >>  {
> >> +       struct drm_device *drm =3D dev_get_drvdata(client->parent);
> >>         struct tegra_dc *dc =3D host1x_client_to_dc(client);
> >> +       struct tegra_drm *tegra =3D drm->dev_private;
> >>         int err;
> >>
> >>         devm_free_irq(dc->dev, dc->irq, dc);
> >> @@ -1335,6 +1348,8 @@ static int tegra_dc_exit(struct host1x_client *c=
lient)
> >>                 return err;
> >>         }
> >>
> >> +       iommu_detach_device(tegra->domain, dc->dev);
> >> +
> >>         return 0;
> >>  }
> >>
> >> @@ -1462,6 +1477,12 @@ static int tegra_dc_probe(struct platform_devic=
e *pdev)
> >>                 return -ENXIO;
> >>         }
> >>
> >> +       err =3D iommu_attach(&pdev->dev);
> >> +       if (err < 0) {
> >> +               dev_err(&pdev->dev, "failed to attach to IOMMU: %d\n",=
 err);
> >> +               return err;
> >> +       }
> >> +
> >>         INIT_LIST_HEAD(&dc->client.list);
> >>         dc->client.ops =3D &dc_client_ops;
> >>         dc->client.dev =3D &pdev->dev;
> >> diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
> >> index 59736bb810cd..1d2bbafad982 100644
> >> --- a/drivers/gpu/drm/tegra/drm.c
> >> +++ b/drivers/gpu/drm/tegra/drm.c
> >> @@ -8,6 +8,7 @@
> >>   */
> >>
> >>  #include <linux/host1x.h>
> >> +#include <linux/iommu.h>
> >>
> >>  #include "drm.h"
> >>  #include "gem.h"
> >> @@ -33,6 +34,16 @@ static int tegra_drm_load(struct drm_device *drm, u=
nsigned long flags)
> >>         if (!tegra)
> >>                 return -ENOMEM;
> >>
> >> +       if (iommu_present(&platform_bus_type)) {
> >> +               tegra->domain =3D iommu_domain_alloc(&platform_bus_typ=
e);
> >> +               if (IS_ERR(tegra->domain)) {
> >> +                       kfree(tegra);
> >> +                       return PTR_ERR(tegra->domain);
> >> +               }
> >> +
> >> +               drm_mm_init(&tegra->mm, 0, SZ_2G);
> >
> >
> > [from St=C3=A9phane]:
> >
> > none of these are freed in the error path below (iommu_domain_free and
> > drm_mm_takedown)
> >
> > also |tegra| isn't freed either?
> >
> >
> >
> >> +       }
> >> +
> >>         mutex_init(&tegra->clients_lock);
> >>         INIT_LIST_HEAD(&tegra->clients);
> >>         drm->dev_private =3D tegra;
> >> @@ -71,6 +82,7 @@ static int tegra_drm_load(struct drm_device *drm, un=
signed long flags)
> >>  static int tegra_drm_unload(struct drm_device *drm)
> >>  {
> >>         struct host1x_device *device =3D to_host1x_device(drm->dev);
> >> +       struct tegra_drm *tegra =3D drm->dev_private;
> >>         int err;
> >>
> >>         drm_kms_helper_poll_fini(drm);
> >> @@ -82,6 +94,11 @@ static int tegra_drm_unload(struct drm_device *drm)
> >>         if (err < 0)
> >>                 return err;
> >>
> >> +       if (tegra->domain) {
> >> +               iommu_domain_free(tegra->domain);
> >> +               drm_mm_takedown(&tegra->mm);
> >> +       }
> >> +
> >>         return 0;
> >>  }
> >>
> >> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> >> index 96d754e7b3eb..a07c796b7edc 100644
> >> --- a/drivers/gpu/drm/tegra/drm.h
> >> +++ b/drivers/gpu/drm/tegra/drm.h
> >> @@ -39,6 +39,9 @@ struct tegra_fbdev {
> >>  struct tegra_drm {
> >>         struct drm_device *drm;
> >>
> >> +       struct iommu_domain *domain;
> >> +       struct drm_mm mm;
> >> +
> >>         struct mutex clients_lock;
> >>         struct list_head clients;
> >>
> >> diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
> >> index 7790d43ad082..21c65dd817c3 100644
> >> --- a/drivers/gpu/drm/tegra/fb.c
> >> +++ b/drivers/gpu/drm/tegra/fb.c
> >> @@ -65,8 +65,12 @@ static void tegra_fb_destroy(struct drm_framebuffer=
 *framebuffer)
> >>         for (i =3D 0; i < fb->num_planes; i++) {
> >>                 struct tegra_bo *bo =3D fb->planes[i];
> >>
> >> -               if (bo)
> >> +               if (bo) {
> >> +                       if (bo->pages && bo->virt)
> >> +                               vunmap(bo->virt);
> >> +
> >>                         drm_gem_object_unreference_unlocked(&bo->gem);
> >> +               }
> >>         }
> >>
> >>         drm_framebuffer_cleanup(framebuffer);
> >> @@ -252,6 +256,16 @@ static int tegra_fbdev_probe(struct drm_fb_helper=
 *helper,
> >>         offset =3D info->var.xoffset * bytes_per_pixel +
> >>                  info->var.yoffset * fb->pitches[0];
> >>
> >> +       if (bo->pages) {
> >> +               bo->vaddr =3D vmap(bo->pages, bo->num_pages, VM_MAP,
> >> +                                pgprot_writecombine(PAGE_KERNEL));
> >> +               if (!bo->vaddr) {
> >> +                       dev_err(drm->dev, "failed to vmap() framebuffe=
r\n");
> >> +                       err =3D -ENOMEM;
> >> +                       goto destroy;
> >> +               }
> >> +       }
> >> +
> >>         drm->mode_config.fb_base =3D (resource_size_t)bo->paddr;
> >>         info->screen_base =3D (void __iomem *)bo->vaddr + offset;
> >>         info->screen_size =3D size;
> >> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> >> index c1e4e8b6e5ca..2912e61a2599 100644
> >> --- a/drivers/gpu/drm/tegra/gem.c
> >> +++ b/drivers/gpu/drm/tegra/gem.c
> >> @@ -14,8 +14,10 @@
> >>   */
> >>
> >>  #include <linux/dma-buf.h>
> >> +#include <linux/iommu.h>
> >>  #include <drm/tegra_drm.h>
> >>
> >> +#include "drm.h"
> >>  #include "gem.h"
> >>
> >>  static inline struct tegra_bo *host1x_to_tegra_bo(struct host1x_bo *b=
o)
> >> @@ -90,14 +92,144 @@ static const struct host1x_bo_ops tegra_bo_ops =
=3D {
> >>         .kunmap =3D tegra_bo_kunmap,
> >>  };
> >>
> >> +static int iommu_map_sg(struct iommu_domain *domain, struct sg_table =
*sgt,
> >> +                       dma_addr_t iova, int prot)
> >> +{
> >> +       unsigned long offset =3D 0;
> >> +       struct scatterlist *sg;
> >> +       unsigned int i, j;
> >> +       int err;
> >> +
> >> +       for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> >> +               dma_addr_t phys =3D sg_phys(sg);
> >> +               size_t length =3D sg->offset;
> >> +
> >> +               phys =3D sg_phys(sg) - sg->offset;
> >> +               length =3D sg->length + sg->offset;
> >> +
> >> +               err =3D iommu_map(domain, iova + offset, phys, length,=
 prot);
> >> +               if (err < 0)
> >> +                       goto unmap;
> >> +
> >> +               offset +=3D length;
> >> +       }
> >> +
> >> +       return 0;
> >> +
> >> +unmap:
> >> +       offset =3D 0;
> >> +
> >> +       for_each_sg(sgt->sgl, sg, i, j) {
> >> +               size_t length =3D sg->length + sg->offset;
> >> +               iommu_unmap(domain, iova + offset, length);
> >> +               offset +=3D length;
> >> +       }
> >> +
> >> +       return err;
> >> +}
> >> +
> >> +static int iommu_unmap_sg(struct iommu_domain *domain, struct sg_tabl=
e *sgt,
> >> +                         dma_addr_t iova)
> >> +{
> >> +       unsigned long offset =3D 0;
> >> +       struct scatterlist *sg;
> >> +       unsigned int i;
> >> +
> >> +       for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> >> +               dma_addr_t phys =3D sg_phys(sg);
> >> +               size_t length =3D sg->offset;
> >> +
> >> +               phys =3D sg_phys(sg) - sg->offset;
> >> +               length =3D sg->length + sg->offset;
> >> +
> >> +               iommu_unmap(domain, iova + offset, length);
> >> +               offset +=3D length;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_b=
o *bo)
> >> +{
> >> +       int prot =3D IOMMU_READ | IOMMU_WRITE;
> >> +       int err;
> >> +
> >> +       if (bo->mm)
> >> +               return -EBUSY;
> >> +
> >> +       bo->mm =3D kzalloc(sizeof(*bo->mm), GFP_KERNEL);
> >> +       if (!bo->mm)
> >> +               return -ENOMEM;
> >> +
> >> +       err =3D drm_mm_insert_node_generic(&tegra->mm, bo->mm, bo->gem=
=2Esize,
> >> +                                        PAGE_SIZE, 0, 0, 0);
> >> +       if (err < 0) {
> >> +               dev_err(tegra->drm->dev, "out of virtual memory: %d\n"=
, err);
> >> +               return err;
> >> +       }
> >> +
> >> +       bo->paddr =3D bo->mm->start;
> >> +
> >> +       err =3D iommu_map_sg(tegra->domain, bo->sgt, bo->paddr, prot);
> >> +       if (err < 0) {
> >> +               dev_err(tegra->drm->dev, "failed to map buffer: %d\n",=
 err);
> >> +               return err;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int tegra_bo_iommu_unmap(struct tegra_drm *tegra, struct tegra=
_bo *bo)
> >> +{
> >> +       if (!bo->mm)
> >> +               return 0;
> >> +
> >> +       iommu_unmap_sg(tegra->domain, bo->sgt, bo->paddr);
> >> +       drm_mm_remove_node(bo->mm);
> >> +
> >> +       kfree(bo->mm);
> >> +       return 0;
> >> +}
> >> +
> >>  static void tegra_bo_destroy(struct drm_device *drm, struct tegra_bo =
*bo)
> >>  {
> >> -       dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr, bo->p=
addr);
> >> +       if (!bo->pages)
> >> +               dma_free_writecombine(drm->dev, bo->gem.size, bo->vadd=
r,
> >> +                                     bo->paddr);
>=20
> One more thing. If tegra_bo_alloc fails, we'll have bo->vaddr =3D=3D NULL
> and bo->paddr =3D=3D ~0 here, which causes a crash.
>=20
> I posted https://lkml.org/lkml/2014/9/30/659 to check for the error
> condition in the mm code, but it seems like reviewer consensus is to
> check for this before calling free.
>=20
> As such, we'll need to make sure bo->vaddr !=3D NULL before calling
> dma_free_writecombine to avoid this situation.
>=20
> Would you prefer I send a patch up to fix this separately, or would
> you like to roll this into your next version?

Thanks for pointing all of these out. I'm going to trace the failure
code path anyway since there seem to be a couple of loose ends here and
there, so I'll probably roll in a fix for this anyway.

Thierry

--7CZp05NP8/gJM8Cl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULQ9NAAoJEN0jrNd/PrOhj0cP/0V0PzqOgD0t9JYK2d4v41R9
TYkwg7w8uwFxOJIzYpIKpyGt7Wq1UbHyuhREstPw6lJzy0eCClqGUOWjT1aSSTKs
KNrgW01YdHkTZZCswhtColxj0BR8WRfcuxRIjlr68/6zEgrjLDnC50SwXKOv4urY
5jv58YxC2NW5f68y+qqkM1mang+3tm8YKC0TsHWDlLwLPRzRg7c9w/7sLd82diUQ
wKgY5Q+UvcHdT9DEAAGQ4L5bjW3hPS2682yGMF3UduLuB/B8/Ts7//ZrjtVJ+lGJ
49Zf3/cB1Qv1YPdJmyypmwwHHNYZZGqsd+g66eP3WjHwMn1uCI++WO65b8nPaend
dvt5vw6t2kG0DyRPO5RYDCWFrwzEDn1gnj0f50scNl/LOiRlDHcPvzmidTvcyPPQ
jU5XhYDZPnsNvMa6AgMmKbew21TikCx4B9RwWoY9Q5jhRGpowuho1WfVxyPzMPpi
oCAIhNthoCOobcK3Gone4/Ym5BCUX4DU5xU4Tzcd51g7OxC7GjVdovjfCQ73hWes
FPWn3WBfSnoUhF4uQ8N68jdAiX0uTbRe63ZJ8qO0H9oYflLPdEPslUmQP+7NfC9j
Jg8ciPmVc7K/CiOAGEtG36GBKx08iqRbk4TZoDrGTWMLXol61UdX37gTIUuhxA0+
390Bb8MAA7Qykz0krHgZ
=KVNT
-----END PGP SIGNATURE-----

--7CZp05NP8/gJM8Cl--
