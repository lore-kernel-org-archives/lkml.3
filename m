Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaJVQ4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaJVQ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:56:32 -0400
Message-ID: <1413996975.4202.226.camel@ul30vt.home>
Subject: Re: [PATCH v8 09/18] vfio/platform: support MMAP of MMIO regions
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
Date: Wed, 22 Oct 2014 10:56:15 -0600
In-Reply-To: <CAG8rG2yUmpzzfEYVqA0H+5LcBcLjFY=j43t420Sa7FLnfmG8Ug@mail.gmail.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205825-6370-10-git-send-email-a.motakis@virtualopensystems.com>
	 <1413910307.4202.148.camel@ul30vt.home>
	 <CAG8rG2yUmpzzfEYVqA0H+5LcBcLjFY=j43t420Sa7FLnfmG8Ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 15:55 +0200, Antonios Motakis wrote:
> On Tue, Oct 21, 2014 at 6:51 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> >> Allow to memory map the MMIO regions of the device so userspace can
> >> directly access them. PIO regions are not being handled at this point.
> >>
> >> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> >> ---
> >>  drivers/vfio/platform/vfio_platform_common.c | 57 ++++++++++++++++++++++++++++
> >>  1 file changed, 57 insertions(+)
> >>
> >> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> >> index ac74710..4db7187 100644
> >> --- a/drivers/vfio/platform/vfio_platform_common.c
> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >> @@ -57,6 +57,16 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> >>                       if (!(res->flags & IORESOURCE_READONLY))
> >>                               vdev->regions[i].flags |=
> >>                                       VFIO_REGION_INFO_FLAG_WRITE;
> >> +
> >> +                     /*
> >> +                      * Only regions addressed with PAGE granularity may be
> >> +                      * MMAPed securely.
> >> +                      */
> >> +                     if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
> >> +                                     !(vdev->regions[i].size & ~PAGE_MASK))
> >> +                             vdev->regions[i].flags |=
> >> +                                     VFIO_REGION_INFO_FLAG_MMAP;
> >> +
> >
> > Should this be included in the above !readonly test?  I don't see that
> > we're doing anything below that would prevent writes to the mmap for a
> > readonly resource.  I suspect that just like PCI, it's not all that
> > useful to provide mmap support for read-only regions.  They're not
> > typically performance paths.
> 
> Indeed. Alternatively we could just MMAP the region as read only as
> well. Even if typically they are not performance critical areas, maybe
> it doesn't hurt to allow MMAP when possible.

Sure, we could allow a read-only mmap.  On PCI the only read-only region
is the PCI option ROM.  The PCI spec indicates that devices may use the
same address decoders for the ROM as for BARs, so the ROM and BAR may
not be simultaneously accessible.  QEMU also caches the ROM once the
guest does read it, so it's never been an issue to allow mmap of that
resource.  I would probably only bother to provide read-only mmap if you
know vfio-platform devices are going to make more significant use of
read-only regions.  Thanks,

Alex

