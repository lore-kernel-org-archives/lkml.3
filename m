Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaGKT5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:57:25 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:52453 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaGKT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:57:24 -0400
Date: Fri, 11 Jul 2014 15:57:19 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: Re: [PATCH 15/83] hsa/radeon: Add interrupt handling module
Message-ID: <20140711195717.GQ1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-14-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405029027-6085-14-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:50:15AM +0300, Oded Gabbay wrote:
> This patch adds the interrupt handling module, in kfd_interrupt.c,
> and its related members in different data structures to the KFD
> driver.
> 
> The KFD interrupt module maintains an internal interrupt ring per kfd
> device. The internal interrupt ring contains interrupts that needs further
> handling.The extra handling is deferred to a later time through a workqueue.
> 
> There's no acknowledgment for the interrupts we use. The hardware simply queues a new interrupt each time without waiting.
> 
> The fixed-size internal queue means that it's possible for us to lose interrupts because we have no back-pressure to the hardware.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/hsa/radeon/Makefile        |   2 +-
>  drivers/gpu/hsa/radeon/kfd_device.c    |   1 +
>  drivers/gpu/hsa/radeon/kfd_interrupt.c | 179 +++++++++++++++++++++++++++++++++
>  drivers/gpu/hsa/radeon/kfd_priv.h      |  18 ++++
>  drivers/gpu/hsa/radeon/kfd_scheduler.h |   3 +
>  5 files changed, 202 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/hsa/radeon/kfd_interrupt.c
> 
> diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
> index 28da10c..5422e6a 100644
> --- a/drivers/gpu/hsa/radeon/Makefile
> +++ b/drivers/gpu/hsa/radeon/Makefile
> @@ -5,6 +5,6 @@
>  radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
>  		kfd_pasid.o kfd_topology.o kfd_process.o \
>  		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
> -		kfd_vidmem.o
> +		kfd_vidmem.o kfd_interrupt.o
>  
>  obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
> diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
> index 465c822..b2d2861 100644
> --- a/drivers/gpu/hsa/radeon/kfd_device.c
> +++ b/drivers/gpu/hsa/radeon/kfd_device.c
> @@ -30,6 +30,7 @@
>  static const struct kfd_device_info bonaire_device_info = {
>  	.scheduler_class = &radeon_kfd_cik_static_scheduler_class,
>  	.max_pasid_bits = 16,
> +	.ih_ring_entry_size = 4 * sizeof(uint32_t)
>  };
>  
>  struct kfd_deviceid {
> diff --git a/drivers/gpu/hsa/radeon/kfd_interrupt.c b/drivers/gpu/hsa/radeon/kfd_interrupt.c
> new file mode 100644
> index 0000000..2179780
> --- /dev/null
> +++ b/drivers/gpu/hsa/radeon/kfd_interrupt.c
> @@ -0,0 +1,179 @@
> +/*
> + * Copyright 2014 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +/*
> + * KFD Interrupts.
> + *
> + * AMD GPUs deliver interrupts by pushing an interrupt description onto the
> + * interrupt ring and then sending an interrupt. KGD receives the interrupt
> + * in ISR and sends us a pointer to each new entry on the interrupt ring.
> + *
> + * We generally can't process interrupt-signaled events from ISR, so we call
> + * out to each interrupt client module (currently only the scheduler) to ask if
> + * each interrupt is interesting. If they return true, then it requires further
> + * processing so we copy it to an internal interrupt ring and call each
> + * interrupt client again from a work-queue.
> + *
> + * There's no acknowledgment for the interrupts we use. The hardware simply
> + * queues a new interrupt each time without waiting.
> + *
> + * The fixed-size internal queue means that it's possible for us to lose
> + * interrupts because we have no back-pressure to the hardware.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include "kfd_priv.h"
> +#include "kfd_scheduler.h"
> +
> +#define KFD_INTERRUPT_RING_SIZE 256
> +
> +static void interrupt_wq(struct work_struct *);
> +
> +int
> +radeon_kfd_interrupt_init(struct kfd_dev *kfd)
> +{
> +	void *interrupt_ring = kmalloc_array(KFD_INTERRUPT_RING_SIZE,
> +					kfd->device_info->ih_ring_entry_size,
> +					GFP_KERNEL);
> +	if (!interrupt_ring)
> +		return -ENOMEM;
> +
> +	kfd->interrupt_ring = interrupt_ring;
> +	kfd->interrupt_ring_size =
> +		KFD_INTERRUPT_RING_SIZE * kfd->device_info->ih_ring_entry_size;
> +	atomic_set(&kfd->interrupt_ring_wptr, 0);
> +	atomic_set(&kfd->interrupt_ring_rptr, 0);
> +
> +	spin_lock_init(&kfd->interrupt_lock);
> +
> +	INIT_WORK(&kfd->interrupt_work, interrupt_wq);
> +
> +	kfd->interrupts_active = true;
> +
> +	/*
> +	 * After this function returns, the interrupt will be enabled. This
> +	 * barrier ensures that the interrupt running on a different processor
> +	 * sees all the above writes.
> +	 */
> +	smp_wmb();
> +
> +	return 0;
> +}
> +
> +void
> +radeon_kfd_interrupt_exit(struct kfd_dev *kfd)
> +{
> +	/*
> +	 * Stop the interrupt handler from writing to the ring and scheduling
> +	 * workqueue items. The spinlock ensures that any interrupt running
> +	 * after we have unlocked sees interrupts_active = false.
> +	 */
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&kfd->interrupt_lock, flags);
> +	kfd->interrupts_active = false;
> +	spin_unlock_irqrestore(&kfd->interrupt_lock, flags);
> +
> +	/*
> +	 * Flush_scheduled_work ensures that there are no outstanding work-queue
> +	 * items that will access interrupt_ring. New work items can't be
> +	 * created because we stopped interrupt handling above.
> +	 */
> +	flush_scheduled_work();
> +
> +	kfree(kfd->interrupt_ring);
> +}
> +
> +/*
> + * This assumes that it can't be called concurrently with itself
> + * but only with dequeue_ih_ring_entry.
> + */
> +static bool
> +enqueue_ih_ring_entry(struct kfd_dev *kfd, const void *ih_ring_entry)
> +{
> +	unsigned int rptr = atomic_read(&kfd->interrupt_ring_rptr);
> +	unsigned int wptr = atomic_read(&kfd->interrupt_ring_wptr);
> +
> +	if ((rptr - wptr) % kfd->interrupt_ring_size == kfd->device_info->ih_ring_entry_size) {
> +		/* This is very bad, the system is likely to hang. */
> +		dev_err_ratelimited(radeon_kfd_chardev(),
> +			"Interrupt ring overflow, dropping interrupt.\n");

Why is it that bad ? What are those interrupt use for ? I would assume that
worst case some queue do not see there job progressing but isn't there is a
way for them to manualy pull information after some time out ?

Because afaict there is way to trigger interrupt from shader and i assume
those can reach this hsa code and thus rogue userspace can irq bomb hsa.
Hence i would like to understand what could go wrong.

Cheers,
Jérôme

> +		return false;
> +	}
> +
> +	memcpy(kfd->interrupt_ring + wptr, ih_ring_entry, kfd->device_info->ih_ring_entry_size);
> +	wptr = (wptr + kfd->device_info->ih_ring_entry_size) % kfd->interrupt_ring_size;
> +	smp_wmb(); /* Ensure memcpy'd data is visible before wptr update. */
> +	atomic_set(&kfd->interrupt_ring_wptr, wptr);
> +
> +	return true;
> +}
> +
> +/*
> + * This assumes that it can't be called concurrently with itself
> + * but only with enqueue_ih_ring_entry.
> + */
> +static bool
> +dequeue_ih_ring_entry(struct kfd_dev *kfd, void *ih_ring_entry)
> +{
> +	/*
> +	 * Assume that wait queues have an implicit barrier, i.e. anything that
> +	 * happened in the ISR before it queued work is visible.
> +	 */
> +
> +	unsigned int wptr = atomic_read(&kfd->interrupt_ring_wptr);
> +	unsigned int rptr = atomic_read(&kfd->interrupt_ring_rptr);
> +
> +	if (rptr == wptr)
> +		return false;
> +
> +	memcpy(ih_ring_entry, kfd->interrupt_ring + rptr, kfd->device_info->ih_ring_entry_size);
> +	rptr = (rptr + kfd->device_info->ih_ring_entry_size) % kfd->interrupt_ring_size;
> +	smp_mb(); /* Ensure the rptr write update is not visible until memcpy has finished reading. */
> +	atomic_set(&kfd->interrupt_ring_rptr, rptr);
> +
> +	return true;
> +}
> +
> +static void interrupt_wq(struct work_struct *work)
> +{
> +	struct kfd_dev *dev = container_of(work, struct kfd_dev, interrupt_work);
> +
> +	uint32_t ih_ring_entry[DIV_ROUND_UP(dev->device_info->ih_ring_entry_size, sizeof(uint32_t))];
> +
> +	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
> +		dev->device_info->scheduler_class->interrupt_wq(dev->scheduler, ih_ring_entry);
> +}
> +
> +/* This is called directly from KGD at ISR. */
> +void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
> +{
> +	spin_lock(&kfd->interrupt_lock);
> +
> +	if (kfd->interrupts_active
> +	    && kfd->device_info->scheduler_class->interrupt_isr(kfd->scheduler, ih_ring_entry)
> +	    && enqueue_ih_ring_entry(kfd, ih_ring_entry))
> +		schedule_work(&kfd->interrupt_work);
> +
> +	spin_unlock(&kfd->interrupt_lock);
> +}
> diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
> index 1d1dbcf..5b6611f 100644
> --- a/drivers/gpu/hsa/radeon/kfd_priv.h
> +++ b/drivers/gpu/hsa/radeon/kfd_priv.h
> @@ -28,6 +28,9 @@
>  #include <linux/mutex.h>
>  #include <linux/radeon_kfd.h>
>  #include <linux/types.h>
> +#include <linux/atomic.h>
> +#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
>  
>  struct kfd_scheduler_class;
>  
> @@ -63,6 +66,7 @@ typedef u32 doorbell_t;
>  struct kfd_device_info {
>  	const struct kfd_scheduler_class *scheduler_class;
>  	unsigned int max_pasid_bits;
> +	size_t ih_ring_entry_size;
>  };
>  
>  struct kfd_dev {
> @@ -90,6 +94,15 @@ struct kfd_dev {
>  	struct kgd2kfd_shared_resources shared_resources;
>  
>  	struct kfd_scheduler *scheduler;
> +
> +	/* Interrupts of interest to KFD are copied from the HW ring into a SW ring. */
> +	bool interrupts_active;
> +	void *interrupt_ring;
> +	size_t interrupt_ring_size;
> +	atomic_t interrupt_ring_rptr;
> +	atomic_t interrupt_ring_wptr;
> +	struct work_struct interrupt_work;
> +	spinlock_t interrupt_lock;
>  };
>  
>  /* KGD2KFD callbacks */
> @@ -229,4 +242,9 @@ struct kfd_dev *radeon_kfd_device_by_pci_dev(const struct pci_dev *pdev);
>  void radeon_kfd_write_reg(struct kfd_dev *dev, uint32_t reg, uint32_t value);
>  uint32_t radeon_kfd_read_reg(struct kfd_dev *dev, uint32_t reg);
>  
> +/* Interrupts */
> +int radeon_kfd_interrupt_init(struct kfd_dev *dev);
> +void radeon_kfd_interrupt_exit(struct kfd_dev *dev);
> +void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
> +
>  #endif
> diff --git a/drivers/gpu/hsa/radeon/kfd_scheduler.h b/drivers/gpu/hsa/radeon/kfd_scheduler.h
> index 48a032f..e5a93c4 100644
> --- a/drivers/gpu/hsa/radeon/kfd_scheduler.h
> +++ b/drivers/gpu/hsa/radeon/kfd_scheduler.h
> @@ -55,6 +55,9 @@ struct kfd_scheduler_class {
>  			    unsigned int doorbell);
>  
>  	void (*destroy_queue)(struct kfd_scheduler *, struct kfd_scheduler_queue *);
> +
> +	bool (*interrupt_isr)(struct kfd_scheduler *, const void *ih_ring_entry);
> +	void (*interrupt_wq)(struct kfd_scheduler *, const void *ih_ring_entry);
>  };
>  
>  extern const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class;
> -- 
> 1.9.1
> 
