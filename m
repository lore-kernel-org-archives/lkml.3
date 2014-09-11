Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaIKRU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:20:56 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46310 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIKRUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:20:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:f125:f3cb:887f:34b9]
In-Reply-To: <20140910101333.GA3002@lvm>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-16-git-send-email-a.motakis@virtualopensystems.com>
 <20140608101703.GB3279@lvm> <CAG8rG2z02JPE+D-Bo1puuMPCR=wETciLaBgKT+i1XKQ55U-kYg@mail.gmail.com>
 <20140910101333.GA3002@lvm>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Thu, 11 Sep 2014 19:20:31 +0200
Message-ID: <CAG8rG2w29=+UCVK+SNUGmDa4Zh0riVt0_u7=6cmvUrcGs9-YFg@mail.gmail.com>
Subject: Re: [RFC PATCH v6 15/20] vfio/platform: support for maskable and
 automasked interrupts
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        alvise rigo <a.rigo@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 12:13 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Tue, Sep 02, 2014 at 06:06:17PM +0200, Antonios Motakis wrote:
>> On Sun, Jun 8, 2014 at 12:17 PM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > On Thu, Jun 05, 2014 at 07:03:23PM +0200, Antonios Motakis wrote:
>> >> Adds support to mask interrupts, and also for automasked interrupts.
>> >> Level sensitive interrupts are exposed as automasked interrupts and
>> >> are masked and disabled automatically when they fire.
>> >>
>> >> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> >> ---
>> >>  drivers/vfio/platform/vfio_platform_irq.c     | 112 ++++++++++++++++++++++++--
>> >>  drivers/vfio/platform/vfio_platform_private.h |   2 +
>> >>  2 files changed, 109 insertions(+), 5 deletions(-)
>> >>
>> >> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> >> index d79f5af..10dfbf0 100644
>> >> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> >> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> >> @@ -51,9 +51,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>> >>               if (hwirq < 0)
>> >>                       goto err;
>> >>
>> >> -             vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
>> >> +             spin_lock_init(&vdev->irq[i].lock);
>> >> +
>> >> +             vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD
>> >> +                                     | VFIO_IRQ_INFO_MASKABLE;
>> >> +
>> >> +             if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
>> >> +                     vdev->irq[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;
>> >
>> > This seems to rely on the fact that you had actually loaded a driver for
>> > your device to set the right type.  Is this assumption always correct?
>> >
>> > It seems to me that this configuration bit should now be up to your user
>> > space drive who is the best candidate to know details about your device
>> > at this point?
>> >
>>
>> Hm, I see this type being set usually either in a device tree source,
>> or in the support code for a specific platform. Are there any
>> situations where this is actually set by the driver? If I understand
>> right this is not the case for the PL330, but if it is possible that
>> it is the case for another device then I need to rethink this. Though
>> as far as I understand this should not be the case.
>>
>
> Wow, this has been incredibly long time since I looked at this code, so
> not sure if I remember my original reasoning anymore, however,
>
> while device properties are set in the DT, they would only be available
> to this code if you actually loaded a device driver for that device,
> right?  I'm just not sure that assumption always holds for devices used
> by VFIO, but I'm really not sure anymore.  Maybe I'm rambling.

The device I'm testing with, the PL330 DMAC, is one of the devices
that exposes level sensitive interrupts, and therefore for it to
properly work VFIO needs to be able to expose it as automasked.

I just tested the code on a kernel that doesn't include the native
PL330 DMA driver. It seems that even so, the unmasked property is
properly detected and exposed by VFIO. So for this scenario at least
the assumptions are true...

I'm afraid I have to admit that if there are any edge cases where this
might not be true, I don't know which they are :(

>
>> >> +
>> >>               vdev->irq[i].count = 1;
>> >>               vdev->irq[i].hwirq = hwirq;
>> >> +             vdev->irq[i].masked = false;
>> >>       }
>> >>
>> >>       vdev->num_irqs = cnt;
>> >> @@ -77,11 +85,27 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>> >>
>> >>  static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>> >>  {
>> >> -     struct eventfd_ctx *trigger = dev_id;
>> >> +     struct vfio_platform_irq *irq_ctx = dev_id;
>> >> +     unsigned long flags;
>> >> +     int ret = IRQ_NONE;
>> >> +
>> >> +     spin_lock_irqsave(&irq_ctx->lock, flags);
>> >> +
>> >> +     if (!irq_ctx->masked) {
>> >> +             ret = IRQ_HANDLED;
>> >> +
>> >> +             if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
>> >> +                     disable_irq_nosync(irq_ctx->hwirq);
>> >> +                     irq_ctx->masked = true;
>> >> +             }
>> >> +     }
>> >>
>> >> -     eventfd_signal(trigger, 1);
>> >> +     spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> >>
>> >> -     return IRQ_HANDLED;
>> >> +     if (ret == IRQ_HANDLED)
>> >> +             eventfd_signal(irq_ctx->trigger, 1);
>> >> +
>> >> +     return ret;
>> >>  }
>> >>
>> >>  static int vfio_set_trigger(struct vfio_platform_device *vdev,
>> >> @@ -162,6 +186,82 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>> >>       return -EFAULT;
>> >>  }
>> >>
>> >> +static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>> >> +                                 unsigned index, unsigned start,
>> >> +                                 unsigned count, uint32_t flags, void *data)
>> >> +{
>> >> +     uint8_t arr;
>> >
>> >
>> > arr?
>>
>> arr for array! As in, the VFIO API allows an array of IRQs. However
>> for platform devices we don't use this, each IRQ is exposed
>> independently as an array of 1 IRQ.
>>
>
> but it's not an array.  If it contains IRQs, call it irqs.  Unless this
> is referring specifically to a field *named* array, I don't remember the
> API at current, but reading the code along it didn't make sense to me to
> have a uint8_t called arr, and code should make as much sense
> independenly as possible.
>
> This reminds me of people writing code like:
>
> String str;
>
> yuck.

You are completely right, the naming is unfortunate. I will change it
to something clearer, (e.g. irq_bitmap?)

>
>> >
>> >> +
>> >> +     if (start != 0 || count != 1)
>> >> +             return -EINVAL;
>> >> +
>> >> +     switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
>> >> +     case VFIO_IRQ_SET_DATA_BOOL:
>> >> +             if (copy_from_user(&arr, data, sizeof(uint8_t)))
>> >> +                     return -EFAULT;
>> >> +
>> >> +             if (arr != 0x1)
>> >> +                     return -EINVAL;
>> >
>> > why the fallthrough, what's this about?
>>
>> The VFIO API allows to unmask/mask an array of IRQs, however with
>> platform devices we only have arrays of 1 IRQ (so not really arrays).
>>
>> So if the user uses VFIO_IRQ_SET_DATA_BOOL, we need to check that arr
>> == 0x1. When that is the case, a fallthrough to the same code for
>> VFIO_IRQ_SET_DATA_NONE is safe.
>>
>> If that is not readable enough, then I can add a comment or duplicate
>> the code that does the unmasking. I realize that if you don't know the
>> VFIO API well, then this can look confusing.
>>
>
> yeah, please put a big fat comment explaining the fallthrough.

Ack.

>
> -Christoffer



-- 
Antonios Motakis
Virtual Open Systems
