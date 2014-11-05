Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaKEKEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:04:45 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59345 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaKEKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:04:42 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414784583.27420.330.camel@ul30vt.home>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-16-git-send-email-a.motakis@virtualopensystems.com> <1414784583.27420.330.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 11:04:21 +0100
Message-ID: <CAG8rG2waTCCpL4eRy9aNd36Psd+7M1pmTZpOvhKi_iOzBer+YQ@mail.gmail.com>
Subject: Re: [PATCH v9 15/19] vfio: add local lock in virqfd instead of
 depending on VFIO PCI
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 8:43 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-27 at 19:08 +0100, Antonios Motakis wrote:
>> Virqfd just needs to keep accesses to any struct *virqfd safe, but this
>> comes into play only when creating or destroying eventfds, so sharing
>> the same spinlock with the VFIO bus driver is not necessary.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++-----
>>  drivers/vfio/virqfd.c             | 24 +++++++++++++-----------
>>  include/linux/vfio.h              |  3 +--
>>  3 files changed, 19 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 3f909bb..e56c814 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -226,8 +226,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
>>  static void vfio_intx_disable(struct vfio_pci_device *vdev)
>>  {
>>       vfio_intx_set_signal(vdev, -1);
>> -     virqfd_disable(vdev, &vdev->ctx[0].unmask);
>> -     virqfd_disable(vdev, &vdev->ctx[0].mask);
>> +     virqfd_disable(&vdev->ctx[0].unmask);
>> +     virqfd_disable(&vdev->ctx[0].mask);
>>       vdev->irq_type = VFIO_PCI_NUM_IRQS;
>>       vdev->num_ctx = 0;
>>       kfree(vdev->ctx);
>> @@ -377,8 +377,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
>>       vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
>>
>>       for (i = 0; i < vdev->num_ctx; i++) {
>> -             virqfd_disable(vdev, &vdev->ctx[i].unmask);
>> -             virqfd_disable(vdev, &vdev->ctx[i].mask);
>> +             virqfd_disable(&vdev->ctx[i].unmask);
>> +             virqfd_disable(&vdev->ctx[i].mask);
>>       }
>>
>>       if (msix) {
>> @@ -415,7 +415,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
>>                                            vfio_send_intx_eventfd, NULL,
>>                                            &vdev->ctx[0].unmask, fd);
>>
>> -             virqfd_disable(vdev, &vdev->ctx[0].unmask);
>> +             virqfd_disable(&vdev->ctx[0].unmask);
>>       }
>>
>>       return 0;
>> diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
>> index 243eb61..27fa2f0 100644
>> --- a/drivers/vfio/virqfd.c
>> +++ b/drivers/vfio/virqfd.c
>> @@ -17,6 +17,7 @@
>>  #include "pci/vfio_pci_private.h"
>>
>>  static struct workqueue_struct *vfio_irqfd_cleanup_wq;
>> +static spinlock_t lock;
>
> Define this as:
>
> DEFINE_SPINLOCK(lock);
>
> and we can avoid needing the init.

Ack, thanks.

>
>>  int __init vfio_pci_virqfd_init(void)
>>  {
>> @@ -25,6 +26,8 @@ int __init vfio_pci_virqfd_init(void)
>>       if (!vfio_irqfd_cleanup_wq)
>>               return -ENOMEM;
>>
>> +     spin_lock_init(&lock);
>> +
>>       return 0;
>>  }
>>
>> @@ -53,21 +56,21 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>
>>       if (flags & POLLHUP) {
>>               unsigned long flags;
>> -             spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
>> +             spin_lock_irqsave(&lock, flags);
>>
>>               /*
>>                * The eventfd is closing, if the virqfd has not yet been
>>                * queued for release, as determined by testing whether the
>> -              * vdev pointer to it is still valid, queue it now.  As
>> +              * virqfd pointer to it is still valid, queue it now.  As
>>                * with kvm irqfds, we know we won't race against the virqfd
>> -              * going away because we hold wqh->lock to get here.
>> +              * going away because we hold the lock to get here.
>>                */
>>               if (*(virqfd->pvirqfd) == virqfd) {
>>                       *(virqfd->pvirqfd) = NULL;
>>                       virqfd_deactivate(virqfd);
>>               }
>>
>> -             spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
>> +             spin_unlock_irqrestore(&lock, flags);
>>       }
>>
>>       return 0;
>> @@ -143,16 +146,16 @@ int virqfd_enable(struct vfio_pci_device *vdev,
>>        * we update the pointer to the virqfd under lock to avoid
>>        * pushing multiple jobs to release the same virqfd.
>>        */
>> -     spin_lock_irq(&vdev->irqlock);
>> +     spin_lock_irq(&lock);
>>
>>       if (*pvirqfd) {
>> -             spin_unlock_irq(&vdev->irqlock);
>> +             spin_unlock_irq(&lock);
>>               ret = -EBUSY;
>>               goto err_busy;
>>       }
>>       *pvirqfd = virqfd;
>>
>> -     spin_unlock_irq(&vdev->irqlock);
>> +     spin_unlock_irq(&lock);
>>
>>       /*
>>        * Install our own custom wake-up handling so we are notified via
>> @@ -190,19 +193,18 @@ err_fd:
>>  }
>>  EXPORT_SYMBOL_GPL(virqfd_enable);
>>
>> -void virqfd_disable(struct vfio_pci_device *vdev,
>> -                        struct virqfd **pvirqfd)
>> +void virqfd_disable(struct virqfd **pvirqfd)
>>  {
>>       unsigned long flags;
>>
>> -     spin_lock_irqsave(&vdev->irqlock, flags);
>> +     spin_lock_irqsave(&lock, flags);
>>
>>       if (*pvirqfd) {
>>               virqfd_deactivate(*pvirqfd);
>>               *pvirqfd = NULL;
>>       }
>>
>> -     spin_unlock_irqrestore(&vdev->irqlock, flags);
>> +     spin_unlock_irqrestore(&lock, flags);
>>
>>       /*
>>        * Block until we know all outstanding shutdown jobs have completed.
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index a077c48..fb6037b 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -146,7 +146,6 @@ extern int virqfd_enable(struct vfio_pci_device *vdev,
>>                        int (*handler)(struct vfio_pci_device *, void *),
>>                        void (*thread)(struct vfio_pci_device *, void *),
>>                        void *data, struct virqfd **pvirqfd, int fd);
>> -extern void virqfd_disable(struct vfio_pci_device *vdev,
>> -                        struct virqfd **pvirqfd);
>> +extern void virqfd_disable(struct virqfd **pvirqfd);
>>
>>  #endif /* VFIO_H */
>
>
>
