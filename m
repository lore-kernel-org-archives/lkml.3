Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaIBQGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:06:40 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64755 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaIBQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:06:38 -0400
MIME-Version: 1.0
X-Originating-IP: [80.15.154.113]
In-Reply-To: <20140608101703.GB3279@lvm>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-16-git-send-email-a.motakis@virtualopensystems.com> <20140608101703.GB3279@lvm>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Tue, 2 Sep 2014 18:06:17 +0200
Message-ID: <CAG8rG2z02JPE+D-Bo1puuMPCR=wETciLaBgKT+i1XKQ55U-kYg@mail.gmail.com>
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

On Sun, Jun 8, 2014 at 12:17 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Thu, Jun 05, 2014 at 07:03:23PM +0200, Antonios Motakis wrote:
>> Adds support to mask interrupts, and also for automasked interrupts.
>> Level sensitive interrupts are exposed as automasked interrupts and
>> are masked and disabled automatically when they fire.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c     | 112 ++++++++++++++++++++++++--
>>  drivers/vfio/platform/vfio_platform_private.h |   2 +
>>  2 files changed, 109 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index d79f5af..10dfbf0 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -51,9 +51,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>               if (hwirq < 0)
>>                       goto err;
>>
>> -             vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
>> +             spin_lock_init(&vdev->irq[i].lock);
>> +
>> +             vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD
>> +                                     | VFIO_IRQ_INFO_MASKABLE;
>> +
>> +             if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
>> +                     vdev->irq[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;
>
> This seems to rely on the fact that you had actually loaded a driver for
> your device to set the right type.  Is this assumption always correct?
>
> It seems to me that this configuration bit should now be up to your user
> space drive who is the best candidate to know details about your device
> at this point?
>

Hm, I see this type being set usually either in a device tree source,
or in the support code for a specific platform. Are there any
situations where this is actually set by the driver? If I understand
right this is not the case for the PL330, but if it is possible that
it is the case for another device then I need to rethink this. Though
as far as I understand this should not be the case.

>> +
>>               vdev->irq[i].count = 1;
>>               vdev->irq[i].hwirq = hwirq;
>> +             vdev->irq[i].masked = false;
>>       }
>>
>>       vdev->num_irqs = cnt;
>> @@ -77,11 +85,27 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>>
>>  static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>>  {
>> -     struct eventfd_ctx *trigger = dev_id;
>> +     struct vfio_platform_irq *irq_ctx = dev_id;
>> +     unsigned long flags;
>> +     int ret = IRQ_NONE;
>> +
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
>> -     eventfd_signal(trigger, 1);
>> +     spin_unlock_irqrestore(&irq_ctx->lock, flags);
>>
>> -     return IRQ_HANDLED;
>> +     if (ret == IRQ_HANDLED)
>> +             eventfd_signal(irq_ctx->trigger, 1);
>> +
>> +     return ret;
>>  }
>>
>>  static int vfio_set_trigger(struct vfio_platform_device *vdev,
>> @@ -162,6 +186,82 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>>       return -EFAULT;
>>  }
>>
>> +static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>> +                                 unsigned index, unsigned start,
>> +                                 unsigned count, uint32_t flags, void *data)
>> +{
>> +     uint8_t arr;
>
>
> arr?

arr for array! As in, the VFIO API allows an array of IRQs. However
for platform devices we don't use this, each IRQ is exposed
independently as an array of 1 IRQ.

>
>> +
>> +     if (start != 0 || count != 1)
>> +             return -EINVAL;
>> +
>> +     switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
>> +     case VFIO_IRQ_SET_DATA_BOOL:
>> +             if (copy_from_user(&arr, data, sizeof(uint8_t)))
>> +                     return -EFAULT;
>> +
>> +             if (arr != 0x1)
>> +                     return -EINVAL;
>
> why the fallthrough, what's this about?

The VFIO API allows to unmask/mask an array of IRQs, however with
platform devices we only have arrays of 1 IRQ (so not really arrays).

So if the user uses VFIO_IRQ_SET_DATA_BOOL, we need to check that arr
== 0x1. When that is the case, a fallthrough to the same code for
VFIO_IRQ_SET_DATA_NONE is safe.

If that is not readable enough, then I can add a comment or duplicate
the code that does the unmasking. I realize that if you don't know the
VFIO API well, then this can look confusing.

>
>> +
>> +     case VFIO_IRQ_SET_DATA_NONE:
>> +
>> +             spin_lock_irq(&vdev->irq[index].lock);
>> +
>> +             if (vdev->irq[index].masked) {
>> +                     enable_irq(vdev->irq[index].hwirq);
>> +                     vdev->irq[index].masked = false;
>> +             }
>> +
>> +             spin_unlock_irq(&vdev->irq[index].lock);
>> +
>> +             return 0;
>> +
>> +     case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
>> +     default:
>> +             return -ENOTTY;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
>> +                                 unsigned index, unsigned start,
>> +                                 unsigned count, uint32_t flags, void *data)
>> +{
>> +     uint8_t arr;
>> +
>> +     if (start != 0 || count != 1)
>> +             return -EINVAL;
>> +
>> +     switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
>> +     case VFIO_IRQ_SET_DATA_BOOL:
>> +             if (copy_from_user(&arr, data, sizeof(uint8_t)))
>> +                     return -EFAULT;
>> +
>> +             if (arr != 0x1)
>> +                     return -EINVAL;
>> +
>> +     case VFIO_IRQ_SET_DATA_NONE:
>> +
>> +             spin_lock_irq(&vdev->irq[index].lock);
>> +
>> +             if (!vdev->irq[index].masked) {
>> +                     disable_irq(vdev->irq[index].hwirq);
>> +                     vdev->irq[index].masked = true;
>> +             }
>> +
>> +             spin_unlock_irq(&vdev->irq[index].lock);
>> +
>> +             return 0;
>> +
>> +     case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
>> +     default:
>> +             return -ENOTTY;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>                                uint32_t flags, unsigned index, unsigned start,
>>                                unsigned count, void *data)
>> @@ -172,8 +272,10 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>
>>       switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>>       case VFIO_IRQ_SET_ACTION_MASK:
>> +             func = vfio_platform_set_irq_mask;
>> +             break;
>>       case VFIO_IRQ_SET_ACTION_UNMASK:
>> -             /* XXX not implemented */
>> +             func = vfio_platform_set_irq_unmask;
>>               break;
>>       case VFIO_IRQ_SET_ACTION_TRIGGER:
>>               func = vfio_platform_set_irq_trigger;
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index d6200df..4d887fd 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -30,6 +30,8 @@ struct vfio_platform_irq {
>>       u32                     count;
>>       int                     hwirq;
>>       char                    *name;
>> +     bool                    masked;
>> +     spinlock_t              lock;
>>  };
>>
>>  struct vfio_platform_region {
>> --
>> 1.8.3.2
>>



-- 
Antonios Motakis
Virtual Open Systems
