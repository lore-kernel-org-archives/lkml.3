Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaEBR0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:26:02 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61795 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaEBR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:26:00 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:3173:f70d:e7d6:1f24]
In-Reply-To: <1398707198.24318.293.camel@ul30vt.home>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
 <1398700371-20096-12-git-send-email-a.motakis@virtualopensystems.com> <1398707198.24318.293.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 2 May 2014 19:25:39 +0200
Message-ID: <CAG8rG2xZd2VnAbw=-V_cd76Zv0ZJkdpYyJ-GWA5C-kkHfZ_ZiQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 11/11] VFIO_PLATFORM: Support for maskable and
 automasked interrupts
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        alvise rigo <a.rigo@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 7:46 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> > Adds support to mask interrupts, and also for automasked interrupts.
> > Level sensitive interrupts are exposed as automasked interrupts and
> > are masked and disabled automatically when they fire.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_irq.c     | 117 ++++++++++++++++++++++++--
> >  drivers/vfio/platform/vfio_platform_private.h |   2 +
> >  2 files changed, 113 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> > index 433edc1..e38982f 100644
> > --- a/drivers/vfio/platform/vfio_platform_irq.c
> > +++ b/drivers/vfio/platform/vfio_platform_irq.c
> > @@ -52,9 +52,16 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
> >               struct vfio_platform_irq irq;
> >               int hwirq = platform_get_irq(vdev->pdev, i);
> >
> > -             irq.flags = VFIO_IRQ_INFO_EVENTFD;
> > +             spin_lock_init(&irq.lock);
> > +
> > +             irq.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_MASKABLE;
> > +
> > +             if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
> > +                     irq.flags |= VFIO_IRQ_INFO_AUTOMASKED;
> > +
> >               irq.count = 1;
> >               irq.hwirq = hwirq;
> > +             irq.masked = false;
> >
> >               vdev->irq[i] = irq;
> >       }
> > @@ -66,19 +73,39 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
> >  {
> >       int i;
> >
> > -     for (i = 0; i < vdev->num_irqs; i++)
> > +     for (i = 0; i < vdev->num_irqs; i++) {
> >               vfio_set_trigger(vdev, i, -1);
> >
> > +             if (vdev->irq[i].masked)
> > +                     enable_irq(vdev->irq[i].hwirq);
>
> This looks suspicious.  set_trigger(,, -1) calls free_irq() and here we
> enable_irq().  Shouldn't the nexe user's call to request_irq() be
> sufficient to re-enable it?  Thanks,
>

This is actually called when we unbind from the device, so it is
indeed not needed.

> Alex
>
