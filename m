Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJVN4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:56:19 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60375 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaJVN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:56:17 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:389c:cfae:9fd8:91b0]
In-Reply-To: <1413913638.4202.153.camel@ul30vt.home>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205825-6370-14-git-send-email-a.motakis@virtualopensystems.com> <1413913638.4202.153.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 22 Oct 2014 15:55:56 +0200
Message-ID: <CAG8rG2wuRusF6DxEr0aNP1AJq6==WfN-4jX7MXwVuRkgm2scVQ@mail.gmail.com>
Subject: Re: [PATCH v8 13/18] vfio/platform: support for maskable and
 automasked interrupts
To: Alex Williamson <alex.williamson@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 7:47 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
>> Adds support to mask interrupts, and also for automasked interrupts.
>> Level sensitive interrupts are exposed as automasked interrupts and
>> are masked and disabled automatically when they fire.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c     | 94 +++++++++++++++++++++++++--
>>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>>  2 files changed, 91 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 4359b9c..7620a17 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -31,27 +31,103 @@
>>
>>  #include "vfio_platform_private.h"
>>
>> +static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
>> +{
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&irq_ctx->lock, flags);
>> +
>> +     if (!irq_ctx->masked) {
>> +             disable_irq(irq_ctx->hwirq);
>> +             irq_ctx->masked = true;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> +}
>> +
>>  static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
>>                                   unsigned index, unsigned start,
>>                                   unsigned count, uint32_t flags, void *data)
>>  {
>> -     return -EINVAL;
>> +     if (start != 0 || count != 1)
>> +             return -EINVAL;
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
>> +             return -EINVAL; /* not implemented yet */
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> +             vfio_platform_mask(&vdev->irqs[index]);
>> +
>> +     } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>> +             uint8_t mask = *(uint8_t *)data;
>> +
>> +             if (mask)
>> +                     vfio_platform_mask(&vdev->irqs[index]);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
>> +{
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&irq_ctx->lock, flags);
>> +
>> +     if (irq_ctx->masked) {
>> +             enable_irq(irq_ctx->hwirq);
>> +             irq_ctx->masked = false;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&irq_ctx->lock, flags);
>>  }
>>
>>  static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>>                                   unsigned index, unsigned start,
>>                                   unsigned count, uint32_t flags, void *data)
>>  {
>> -     return -EINVAL;
>> +     if (start != 0 || count != 1)
>> +             return -EINVAL;
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
>> +             return -EINVAL; /* not implemented yet */
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> +             vfio_platform_unmask(&vdev->irqs[index]);
>> +
>> +     } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>> +             uint8_t unmask = *(uint8_t *)data;
>> +
>> +             if (unmask)
>> +                     vfio_platform_unmask(&vdev->irqs[index]);
>> +     }
>> +
>> +     return 0;
>>  }
>>
>>  static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>>  {
>>       struct vfio_platform_irq *irq_ctx = dev_id;
>> +     unsigned long flags;
>> +     int ret = IRQ_NONE;
>>
>> -     eventfd_signal(irq_ctx->trigger, 1);
>> +     spin_lock_irqsave(&irq_ctx->lock, flags);
>> +
>> +     if (!irq_ctx->masked) {
>> +             ret = IRQ_HANDLED;
>> +
>> +             if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
>> +                     disable_irq_nosync(irq_ctx->hwirq);
>> +                     irq_ctx->masked = true;
>> +             }
>> +     }
>>
>> -     return IRQ_HANDLED;
>> +     spin_unlock_irqrestore(&irq_ctx->lock, flags);
>> +
>> +     if (ret == IRQ_HANDLED)
>> +             eventfd_signal(irq_ctx->trigger, 1);
>> +
>> +     return ret;
>>  }
>
> If you actually have edge interrupts, you're unnecessarily penalizing
> them with the spinlock here.  You could do like vfio-pci and only
> advertise level interrupts as maskable then use separate edge vs level
> handlers.
>

Ok, I shall implement separate handlers then.

>>
>>  static int vfio_set_trigger(struct vfio_platform_device *vdev,
>> @@ -169,9 +245,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>               if (hwirq < 0)
>>                       goto err;
>>
>> -             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
>> +             spin_lock_init(&vdev->irqs[i].lock);
>> +
>> +             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD
>> +                                     | VFIO_IRQ_INFO_MASKABLE;
>> +
>> +             if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
>> +                     vdev->irqs[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;
>> +
>>               vdev->irqs[i].count = 1;
>>               vdev->irqs[i].hwirq = hwirq;
>> +             vdev->irqs[i].masked = false;
>>       }
>>
>>       vdev->num_irqs = cnt;
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 47af6e0..65e80e7 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -30,6 +30,8 @@ struct vfio_platform_irq {
>>       int                     hwirq;
>>       char                    *name;
>>       struct eventfd_ctx      *trigger;
>> +     bool                    masked;
>> +     spinlock_t              lock;
>>  };
>>
>>  struct vfio_platform_region {
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
