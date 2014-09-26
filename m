Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217AbaIZPES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:04:18 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57858 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaIZPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:04:14 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:aca4:bf5e:39c6:55e8]
In-Reply-To: <1411578009.24563.107.camel@ul30vt.home>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-21-git-send-email-a.motakis@virtualopensystems.com> <1411578009.24563.107.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 26 Sep 2014 17:03:53 +0200
Message-ID: <CAG8rG2zSaKqmZMiEa4W68zvLU4UgW0VHpLxWFqmidPk76FPuaw@mail.gmail.com>
Subject: Re: [PATCHv7 20/26] vfio/platform: trigger an interrupt via eventfd
To: Alex Williamson <alex.williamson@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 7:00 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
>> This patch allows to set an eventfd for a patform device's interrupt,
>> and also to trigger the interrupt eventfd from userspace for testing.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c     | 89 ++++++++++++++++++++++++++-
>>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>>  2 files changed, 89 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 007b386..25a7825 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -45,11 +45,91 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>>       return -EINVAL;
>>  }
>>
>> +static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>> +{
>> +     struct vfio_platform_irq *irq_ctx = dev_id;
>> +
>> +     eventfd_signal(irq_ctx->trigger, 1);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int vfio_set_trigger(struct vfio_platform_device *vdev,
>> +                         int index, int fd)
>> +{
>> +     struct vfio_platform_irq *irq = &vdev->irqs[index];
>> +     struct eventfd_ctx *trigger;
>> +     int ret;
>> +
>> +     if (irq->trigger) {
>> +             free_irq(irq->hwirq, irq);
>> +             kfree(irq->name);
>> +             eventfd_ctx_put(irq->trigger);
>> +             irq->trigger = NULL;
>> +     }
>> +
>> +     if (fd < 0) /* Disable only */
>> +             return 0;
>> +
>> +     irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
>> +                                             irq->hwirq, vdev->name);
>> +     if (!irq->name)
>> +             return -ENOMEM;
>> +
>> +     trigger = eventfd_ctx_fdget(fd);
>> +     if (IS_ERR(trigger)) {
>> +             kfree(irq->name);
>> +             return PTR_ERR(trigger);
>> +     }
>> +
>> +     irq->trigger = trigger;
>> +
>> +     ret = request_irq(irq->hwirq, vfio_irq_handler, 0, irq->name, irq);
>> +     if (ret) {
>> +             kfree(irq->name);
>> +             eventfd_ctx_put(trigger);
>> +             irq->trigger = NULL;
>> +             return ret;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>>  static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>>                                    unsigned index, unsigned start,
>>                                    unsigned count, uint32_t flags, void *data)
>>  {
>> -     return -EINVAL;
>> +     struct vfio_platform_irq *irq = &vdev->irqs[index];
>> +     uint8_t irq_bitmap;
>
> Minor nit here and also present in the next patch, I believe when we
> have DATA_BOOL, it's defined to be a u8 array, where each byte is a
> bool, not each bit.  So it's not actually a bitmap.  The PCI code
> handles any non-zero byte as true, not just bit0.  Thanks,
>

Ok, I will correct this. Thanks for the clarification.

> Alex
>
>> +     int32_t fd;
>> +
>> +     switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
>> +     case VFIO_IRQ_SET_DATA_NONE:
>> +             if (count == 0)
>> +                     return vfio_set_trigger(vdev, index, -1);
>> +
>> +             vfio_irq_handler(irq->hwirq, irq);
>> +             return 0;
>> +
>> +     case VFIO_IRQ_SET_DATA_BOOL:
>> +             if (copy_from_user(&irq_bitmap, data, sizeof(uint8_t)))
>> +                     return -EFAULT;
>> +
>> +             if (irq_bitmap == 0x1) {
>> +                     vfio_irq_handler(irq->hwirq, irq);
>> +                     return 0;
>> +             }
>> +
>> +             return -EINVAL;
>> +
>> +     case VFIO_IRQ_SET_DATA_EVENTFD:
>> +             if (copy_from_user(&fd, data, sizeof(int32_t)))
>> +                     return -EFAULT;
>> +
>> +             return vfio_set_trigger(vdev, index, fd);
>> +     }
>> +
>> +     return -EFAULT;
>>  }
>>
>>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>> @@ -95,7 +175,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>               if (hwirq < 0)
>>                       goto err;
>>
>> -             vdev->irqs[i].flags = 0;
>> +             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
>>               vdev->irqs[i].count = 1;
>>               vdev->irqs[i].hwirq = hwirq;
>>       }
>> @@ -110,6 +190,11 @@ err:
>>
>>  void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>>  {
>> +     int i;
>> +
>> +     for (i = 0; i < vdev->num_irqs; i++)
>> +             vfio_set_trigger(vdev, i, -1);
>> +
>>       vdev->num_irqs = 0;
>>       kfree(vdev->irqs);
>>  }
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 4201b94..765b371 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -28,6 +28,8 @@ struct vfio_platform_irq {
>>       u32                     flags;
>>       u32                     count;
>>       int                     hwirq;
>> +     char                    *name;
>> +     struct eventfd_ctx      *trigger;
>>  };
>>
>>  struct vfio_platform_region {
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
