Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaFFQ54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:57:56 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54534 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFFQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:57:54 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:61b0:c77e:e905:5cc9]
In-Reply-To: <1402006750.9207.267.camel@ul30vt.home>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-18-git-send-email-a.motakis@virtualopensystems.com> <1402006750.9207.267.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 6 Jun 2014 18:57:33 +0200
Message-ID: <CAG8rG2wmDep0yDw5xKJf2oNX0SSVts1yAm5tmWe=gr5GfD=8bw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 17/20] vfio: add local lock in virqfd instead of
 depending on VFIO PCI
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
        Eric Auger <eric.auger@linaro.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 12:19 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu, 2014-06-05 at 19:03 +0200, Antonios Motakis wrote:
>> Sharing the same spinlock with the VFIO bus driver is not necessary for
>> the virqfd code, so remove that dependency.
>
> I like the idea of consolidating this code, but I need more
> justification for why the use of the lock here is independent of the bus
> driver and why it's ok to move from a per-device lock to a global lock.
> Thanks,

In the bus driver we use the lock when working with IRQs (for example
when masking/unmasking). VFIO_PCI will use a global lock for all IRQs
of a device, VFIO_PLATFORM will use a different lock for each IRQ.

The virqfd code, as decoupled here from the VFIO_PCI code will not
touch this directly, but a lock is used to keep  any *virqfds
variables consistent. In fact, virqfd is not married to IRQs in
particular, in theory you could register a handler for any eventfd. So
the lock here is used only when creating and destroying eventfds.

I believe the virqfd code should not be particularly aware of what is
behind an eventfd, and what the right lock(s) to use would be - if
any. Any sensitive variables will be accessed only from he handler
registered from the bus driver, who can still hold the spinlock to do
it safely.

Virqfd just needs to keep accesses to any struct *virqfd safe, but
this comes into play only when creating or destroying eventfds, so the
global lock should not be a bottleneck.

>
> Alex
>
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
>> index 9cf2842..4528450 100644
>> --- a/drivers/vfio/virqfd.c
>> +++ b/drivers/vfio/virqfd.c
>> @@ -17,6 +17,7 @@
>>  #include "pci/vfio_pci_private.h"
>>
>>  static struct workqueue_struct *vfio_irqfd_cleanup_wq;
>> +static spinlock_t lock;
>>
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
>> @@ -189,19 +192,18 @@ err_fd:
>>       return ret;
>>  }
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
>> index 43968e8..44c9808 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -123,7 +123,6 @@ extern int virqfd_enable(struct vfio_pci_device *vdev,
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



-- 
Antonios Motakis
Virtual Open Systems
