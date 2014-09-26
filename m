Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaIZU15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbaIZU14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:27:56 -0400
Message-ID: <1411763257.7360.49.camel@ul30vt.home>
Subject: Re: [PATCHv7 06/26] vfio/iommu_type1: implement the
 VFIO_DMA_MAP_FLAG_NOEXEC flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 26 Sep 2014 14:27:37 -0600
In-Reply-To: <CAG8rG2z14gT28jec66o3UQ=z-omNv+bC43moJT-FhdUtd2OJDg@mail.gmail.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-7-git-send-email-a.motakis@virtualopensystems.com>
	 <1411512059.24563.57.camel@ul30vt.home>
	 <CAG8rG2z14gT28jec66o3UQ=z-omNv+bC43moJT-FhdUtd2OJDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 17:39 +0200, Antonios Motakis wrote:
> On Wed, Sep 24, 2014 at 12:40 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
> >> Some IOMMU drivers, such as the ARM SMMU driver, make available the
> >> IOMMU_NOEXEC flag, to set the page tables for a device as XN (execute never).
> >> This affects devices such as the ARM PL330 DMA Controller, which respects
> >> this flag and will refuse to fetch DMA instructions from memory where the
> >> XN flag has been set.
> >>
> >> The flag can be used only if all IOMMU domains behind the container support
> >> the IOMMU_NOEXEC flag. Also, if any mappings are created with the flag, any
> >> new domains with devices will have to support it as well.
> >>
> >> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 37 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 0734fbe..09e5064 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -81,6 +81,26 @@ struct vfio_group {
> >>  };
> >>
> >>  /*
> >> + * This function returns true only if _all_ domains support the capability.
> >> + */
> >> +static int vfio_all_domains_have_iommu_noexec(struct vfio_iommu *iommu)
> >
> > Rename to vfio_domains_have_iommu_noexec() for consistency with the
> > cache version.
> >
> 
> The logic here is a slightly different logic between the two. For
> IOMMU_CACHE we generally check if any domain includes it,

Not true, all the domains must support IOMMU_CACHE for the function to
return 1.  In fact, the code is so identical that if we were to cache
IOMMU_CAP_NOEXEC into domain->prot, we should probably only have one
function:

static int vfio_domains_have_iommu_flag(struct vfio_iommu *iommu, int flag);

>  for NOEXEC
> in contract we need all domains to support it, otherwise we can't
> expose the capability. Hence the _all_ addition in the name of the
> function.
> 
> >> +{
> >> +     struct vfio_domain *d;
> >> +     int ret = 1;
> >> +
> >> +     mutex_lock(&iommu->lock);
> >> +     list_for_each_entry(d, &iommu->domain_list, next) {
> >> +             if (!iommu_domain_has_cap(d->domain, IOMMU_CAP_NOEXEC)) {
> >
> > Should we cache this in domain->prot like we do for IOMMU_CACHE?
> >
> >> +                     ret = 0;
> >> +                     break;
> >> +             }
> >> +     }
> >> +     mutex_unlock(&iommu->lock);
> >> +
> >> +     return ret;
> >> +}
> >> +
> >> +/*
> >>   * This code handles mapping and unmapping of user data buffers
> >>   * into DMA'ble space using the IOMMU
> >>   */
> >> @@ -546,6 +566,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>               prot |= IOMMU_WRITE;
> >>       if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> >>               prot |= IOMMU_READ;
> >> +     if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
> >> +             if (!vfio_all_domains_have_iommu_noexec(iommu))
> >> +                     return -EINVAL;
> >> +             prot |= IOMMU_NOEXEC;
> >> +     }
> >>
> >>       if (!prot || !size || (size | iova | vaddr) & mask)
> >>               return -EINVAL;
> >> @@ -636,6 +661,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> >>               dma = rb_entry(n, struct vfio_dma, node);
> >>               iova = dma->iova;
> >>
> >> +             /* if any of the mappings to be replayed has the NOEXEC flag
> >> +              * set, then the new iommu domain must support it */
> >
> > nit, please fix the comment style to match the rest of the file.
> >
> 
> Ack
> 
> >> +             if ((dma->prot | IOMMU_NOEXEC) &&
> >> +                 !iommu_domain_has_cap(domain->domain, IOMMU_CAP_NOEXEC))
> >> +                     return -EINVAL;
> >> +
> >>               while (iova < dma->iova + dma->size) {
> >>                       phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
> >>                       size_t size;
> >> @@ -890,6 +921,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>                       if (!iommu)
> >>                               return 0;
> >>                       return vfio_domains_have_iommu_cache(iommu);
> >> +             case VFIO_IOMMU_PROT_NOEXEC:
> >> +                     if (!iommu)
> >> +                             return 0;
> >> +                     return vfio_all_domains_have_iommu_noexec(iommu);
> >>               default:
> >>                       return 0;
> >>               }
> >> @@ -913,7 +948,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>       } else if (cmd == VFIO_IOMMU_MAP_DMA) {
> >>               struct vfio_iommu_type1_dma_map map;
> >>               uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
> >> -                             VFIO_DMA_MAP_FLAG_WRITE;
> >> +                             VFIO_DMA_MAP_FLAG_WRITE |
> >> +                             VFIO_DMA_MAP_FLAG_NOEXEC;
> >>
> >>               minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
> >>
> >
> >
> >
> 
> 
> 



