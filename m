Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaKEKI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:08:58 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43266 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaKEKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:08:55 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414784174.27420.327.camel@ul30vt.home>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-13-git-send-email-a.motakis@virtualopensystems.com> <1414784174.27420.327.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 11:08:34 +0100
Message-ID: <CAG8rG2wWEjr2ADayuqS9EKQp-2SP=X0QkD152W=jVsOGZVfeHg@mail.gmail.com>
Subject: Re: [PATCH v9 12/19] vfio/platform: trigger an interrupt via eventfd
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

On Fri, Oct 31, 2014 at 8:36 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-27 at 19:07 +0100, Antonios Motakis wrote:
>> This patch allows to set an eventfd for a patform device's interrupt,
>> and also to trigger the interrupt eventfd from userspace for testing.
>> Level sensitive interrupts are marked as maskable and are handled in
>> a later patch. Edge triggered interrupts are not advertised as maskable
>> and are implemented here using a simple and efficient IRQ handler.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c     | 93 ++++++++++++++++++++++++++-
>>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>>  2 files changed, 93 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 007b386..2ac8ed7 100644
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
>> +static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>> +                         int fd, irq_handler_t handler)
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
>> +     ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
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
>> +     irq_handler_t handler;
>> +
>> +     if (vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE)
>> +             return -EINVAL; /* not implemented */
>> +     else
>> +             handler = vfio_irq_handler;
>> +
>> +     if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
>> +             return vfio_set_trigger(vdev, index, -1, handler);
>> +
>> +     if (start != 0 || count != 1)
>> +             return -EINVAL;
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>> +             int32_t fd = *(int32_t *)data;
>> +
>> +             return vfio_set_trigger(vdev, index, fd, handler);
>> +     }
>> +
>> +     if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> +             handler(irq->hwirq, irq);
>> +
>> +     } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>> +             uint8_t trigger = *(uint8_t *)data;
>> +
>> +             if (trigger)
>> +                     handler(irq->hwirq, irq);
>> +     }
>> +
>> +     return 0;
>>  }
>>
>>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>> @@ -95,7 +175,11 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>               if (hwirq < 0)
>>                       goto err;
>>
>> -             vdev->irqs[i].flags = 0;
>> +             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
>> +
>> +             if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
>> +                     vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE;
>
> This is a bit confusing because edge interrupts can support masking, but
> they don't require it.  Level interrupts really must support masking
> because we need to mask them on the host and therefore the user needs to
> be able to unmask them (ignoring the irq prioritization thing you guys
> can do on arm).  So this works, but I would really have expected
> VFIO_IRQ_INFO_AUTOMASKED here and in the above function.

You're right, it will be clearer by using automasked as the defining
property for level sensitive interrupts.

>
>> +
>>               vdev->irqs[i].count = 1;
>>               vdev->irqs[i].hwirq = hwirq;
>>       }
>> @@ -110,6 +194,11 @@ err:
>>
>>  void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>>  {
>> +     int i;
>> +
>> +     for (i = 0; i < vdev->num_irqs; i++)
>> +             vfio_set_trigger(vdev, i, -1, NULL);
>> +
>>       vdev->num_irqs = 0;
>>       kfree(vdev->irqs);
>>  }
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index ffa2459..a3f2411 100644
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
