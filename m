Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbaJUOiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaJUOiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:38:15 -0400
Message-ID: <1413902274.4202.113.camel@ul30vt.home>
Subject: Re: [PATCH 5/5] vfio/iommu_type1: implement the
 VFIO_DMA_MAP_FLAG_NOEXEC flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 08:37:54 -0600
In-Reply-To: <CAG8rG2wca4w8LaDSVbgNwfd=e077UaVdpaFhFkMphmyH62Dm3w@mail.gmail.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205748-6300-6-git-send-email-a.motakis@virtualopensystems.com>
	 <1413839603.4202.108.camel@ul30vt.home>
	 <CAG8rG2wca4w8LaDSVbgNwfd=e077UaVdpaFhFkMphmyH62Dm3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 14:40 +0200, Antonios Motakis wrote:
> On Mon, Oct 20, 2014 at 11:13 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Mon, 2014-10-13 at 15:09 +0200, Antonios Motakis wrote:
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
> >>  drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
> >>  1 file changed, 24 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 8b4202a..e225e8f 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -569,6 +569,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>       if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> >>               prot |= IOMMU_READ;
> >>
> >> +     if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
> >> +             if (!vfio_domains_have_iommu_cap(iommu, IOMMU_CAP_NOEXEC))
> >> +                     return -EINVAL;
> >> +             prot |= IOMMU_NOEXEC;
> >> +     }
> >> +
> >>       if (!prot || !size || (size | iova | vaddr) & mask)
> >>               return -EINVAL;
> >
> > I think this test needs to move above adding the NOEXEC flag, otherwise
> > we now allow mappings without read or write, which is an ABI change.
> >
> 
> Ack.
> 
> >>
> >> @@ -662,6 +668,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> >>               dma = rb_entry(n, struct vfio_dma, node);
> >>               iova = dma->iova;
> >>
> >> +             /*
> >> +              * if any of the mappings to be replayed has the NOEXEC flag
> >> +              * set, then the new iommu domain must support it
> >> +              */
> >> +             if ((dma->prot | IOMMU_NOEXEC) &&
> >
> > I think you mean
> >
> > & IOMMU_NOEXEC
> 
> Ack.
> 
> >
> >> +                             !(domain->caps & IOMMU_CAP_NOEXEC))
> >> +                     return -EINVAL;
> >> +
> >
> > In patch 2/5 you stated:
> >
> >         The IOMMU_NOEXEC flag needs to be available for all the IOMMUs
> >         of the container used.
> >
> > But here you'll create heterogeneous containers so long as there are no
> > NOEXEC mappings.  Is that intentional or a side effect of the above
> > masking bug?
> >
> 
> Yeah, my intention was to not stop the user of having heterogeneous
> containers, as long as he doesn't care about using the NOEXEC flag. As
> soon as the user tries to apply this flag however, then it should be
> supported by all the IOMMUs behind the container - otherwise it is not
> enforceable.
> 
> Do you think we should change this behavior? I think most users will
> not care about using this flag, and we should not stop them from
> mixing containers.

I think that's a reasonable way to go, but let's add a comment in uapi
vfio.h describing that expectation.  Thanks,

Alex

> >>               while (iova < dma->iova + dma->size) {
> >>                       phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
> >>                       size_t size;
> >> @@ -749,6 +763,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>       if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> >>               domain->caps |= IOMMU_CAP_CACHE_COHERENCY;
> >>
> >> +     if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
> >> +             domain->caps |= IOMMU_CAP_NOEXEC;
> >> +
> >>       /*
> >>        * Try to match an existing compatible domain.  We don't want to
> >>        * preclude an IOMMU driver supporting multiple bus_types and being
> >> @@ -900,6 +917,11 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>                               return 0;
> >>                       return vfio_domains_have_iommu_cap(iommu,
> >>                                                 IOMMU_CAP_CACHE_COHERENCY);
> >> +             case VFIO_DMA_NOEXEC_IOMMU:
> >> +                     if (!iommu)
> >> +                             return 0;
> >> +                     return vfio_domains_have_iommu_cap(iommu,
> >> +                                                        IOMMU_CAP_NOEXEC);
> >>               default:
> >>                       return 0;
> >>               }
> >> @@ -923,7 +945,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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



