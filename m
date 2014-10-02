Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaJBHCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:02:06 -0400
Received: from ozlabs.org ([103.22.144.67]:54800 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaJBHCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:02:03 -0400
In-Reply-To: <1412073306-13812-15-git-send-email-mikey@neuling.org>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        benh@kernel.crashing.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 14/17] cxl: Driver code for powernv PCIe based cards for userspace access
Message-Id: <20141002070202.2A061140188@ozlabs.org>
Date: Thu,  2 Oct 2014 17:02:01 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-30-09 at 10:35:03 UTC, Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This is the core of the cxl driver.
> 
> It adds support for using cxl cards in the powernv environment only (no guest
> support). 

Which means on bare metal on power8 for the peanut gallery.

> It allows access to cxl accelerators by userspace using
> /dev/cxl/afu0.0 char device.

devices ?

> The kernel driver has no knowledge of the acceleration function.  

.. has no knowledge of the function implemented by the accelerator ?

> It only provides services to userspace via the /dev/cxl/afu0.0 device.

Provides what services?

> This will compile to two modules.  cxl.ko provides the core cxl functionality
> and userspace API.  cxl-pci.ko provides the PCI driver driver functionality the
> powernv environment.

Last sentence doesn't hold together.

> Documentation of the cxl hardware architecture and userspace API is provided in
> subsequent patches.

Partial review below.

So some meta comments.

Can you get rid of all the foo_t's. That should just be a search and replace.

Can we drop the indirection layers for now. They make it quite a bit harder to
follow the code, and it sounds like you're not 100% sure they're the right
abstraction anyway. When you add another backend/driver/whatever you can readd
just the abstractions you need.

/*
 * Block comments look like this.
 */

> diff --git a/drivers/misc/cxl/context.c b/drivers/misc/cxl/context.c
> new file mode 100644
> index 0000000..9206ca4
> --- /dev/null
> +++ b/drivers/misc/cxl/context.c
> @@ -0,0 +1,171 @@
> +/*
> + * Copyright 2014 IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#undef DEBUG

Drop this please.

Instead can you add:

#define pr_fmt(fmt)        "cxl: " fmt

To each file, so it's clear where your pr_xxxs() come from.

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/bitmap.h>
> +#include <linux/sched.h>
> +#include <linux/pid.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/debugfs.h>
> +#include <linux/slab.h>
> +#include <linux/idr.h>
> +#include <asm/cputable.h>
> +#include <asm/current.h>
> +#include <asm/copro.h>
> +
> +#include "cxl.h"
> +
> +/*
> + * Allocates space for a CXL context.
> + */
> +struct cxl_context_t *cxl_context_alloc(void)
> +{
> +	return kzalloc(sizeof(struct cxl_context_t), GFP_KERNEL);
> +}

> +/*
> + * Initialises a CXL context.
> + */
> +int cxl_context_init(struct cxl_context_t *ctx, struct cxl_afu_t *afu, bool master)
> +{
> +	int i;
> +
> +	spin_lock_init(&ctx->sst_lock);
> +	ctx->sstp = NULL;
> +	ctx->afu = afu;
> +	ctx->master = master;
> +	ctx->pid = get_pid(get_task_pid(current, PIDTYPE_PID));
> +
> +	INIT_WORK(&ctx->fault_work, cxl_handle_fault);
> +
> +	init_waitqueue_head(&ctx->wq);
> +	spin_lock_init(&ctx->lock);
> +
> +	ctx->irq_bitmap = NULL;
> +	ctx->pending_irq = false;
> +	ctx->pending_fault = false;
> +	ctx->pending_afu_err = false;
> +
> +	ctx->status = OPENED;
> +
> +	idr_preload(GFP_KERNEL);
> +	spin_lock(&afu->contexts_lock);
> +	i = idr_alloc(&ctx->afu->contexts_idr, ctx, 0,
> +		      ctx->afu->num_procs, GFP_NOWAIT);
> +	spin_unlock(&afu->contexts_lock);
> +	idr_preload_end();
> +	if (i < 0)
> +		return i;
> +
> +	ctx->ph = i;
> +	ctx->elem = &ctx->afu->spa[i];
> +	ctx->pe_inserted = false;
> +	return 0;
> +}
> +
> +/*
> + * Map a per-context mmio space into the given vma.
> + */
> +int cxl_context_iomap(struct cxl_context_t *ctx, struct vm_area_struct *vma)
> +{
> +	u64 len = vma->vm_end - vma->vm_start;
> +	len = min(len, ctx->psn_size);
> +
> +	if (ctx->afu->current_model == CXL_MODEL_DEDICATED) {
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +		return vm_iomap_memory(vma, ctx->afu->psn_phys, ctx->afu->adapter->ps_size);

Why don't we use len here?

> +	}
> +
> +	/* make sure there is a valid per process space for this AFU */
> +	if ((ctx->master && !ctx->afu->psa) || (!ctx->afu->pp_psa)) {

What the hell are psa and pp_psa ?

> +		pr_devel("AFU doesn't support mmio space\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Can't mmap until the AFU is enabled */
> +	if (!ctx->afu->enabled)
> +		return -EBUSY;

afu_mmap() already checked status == STARTED.

Is EBUSY the right return code?

> +	pr_devel("%s: mmio physical: %llx pe: %i master:%i\n", __func__,
> +		 ctx->psn_phys, ctx->ph , ctx->master);
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	return vm_iomap_memory(vma, ctx->psn_phys, len);
> +}
> +
> +/*
> + * Detach a context from the hardware. This disables interrupts and doesn't
> + * return until all outstanding interrupts for this context have completed. The
> + * hardware should no longer access *ctx after this has returned.
> + */
> +static void __detach_context(struct cxl_context_t *ctx)
> +{
> +	unsigned long flags;
> +	enum cxl_context_status status;
> +
> +	spin_lock_irqsave(&ctx->sst_lock, flags);
> +	status = ctx->status;
> +	ctx->status = CLOSED;
> +	spin_unlock_irqrestore(&ctx->sst_lock, flags);

You take sst_lock here, before manipulating ctx->status. But I see lots of
places where you check status without taking any lock. So I'm a bit confused by
that.

At first glance it looks like we could race with afu_ioctl_start_work(), which
sets status to STARTED. But the only place we're called from is
cxl_context_detach(), from afu_release(), and that should only run once the
ioctl is finished AIUI. So that looks OK.

But some commentary would be good, especially if this is ever called via a
different path.

> +	if (status != STARTED)
> +		return;
> +
> +	WARN_ON(cxl_ops->detach_process(ctx));

As discussed offline, this can fail, and the device might continue generating
interrupts even though we asked it not to.

Once you release the irqs below you'll get warnings from the xics code. Until
those virq numbers are handed out to someone else, at which point hilarity will
ensue.

It might be better to just warn and bail if detach fails, and leave the ctx
lying around?

> +	afu_release_irqs(ctx);
> +	flush_work(&ctx->fault_work); /* Only needed for dedicated process */
> +	wake_up_all(&ctx->wq);
> +}
> +
> +/*
> + * Detach the given context from the AFU. This doesn't actually
> + * free the context but it should stop the context running in hardware
> + * (ie. prevent this context from generating any further interrupts
> + * so that it can be freed).
> + */
> +void cxl_context_detach(struct cxl_context_t *ctx)
> +{
> +	__detach_context(ctx);
> +}

Why does this exist, or why does __detach_context() exist?

> +
> +/*
> + * Detach all contexts on the given AFU.
> + */
> +void cxl_context_detach_all(struct cxl_afu_t *afu)
> +{
> +	struct cxl_context_t *ctx;
> +	int tmp;
> +

Some commentary on why you're using rcu_read_lock() would be good. I know, but
I'll have forgotten by next week.

> +	rcu_read_lock();
> +	idr_for_each_entry(&afu->contexts_idr, ctx, tmp)
> +		__detach_context(ctx);
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(cxl_context_detach_all);


> +static int afu_release(struct inode *inode, struct file *file)
> +{
> +	struct cxl_context_t *ctx = file->private_data;
> +
> +	pr_devel("%s: closing cxl file descriptor. pe: %i\n",
> +		 __func__, ctx->ph);
> +	cxl_context_detach(ctx);
> +
> +	module_put(ctx->afu->adapter->driver->module);

This potentially drops the last reference on cxl-pci.ko.

cxl_remove() (in cxl-pci.ko) calls back into cxl_remove_afu() and
cxl_remove_adapter(). 

I *think* that's OK, because you won't be able to finish cxl_remove() until you
remove the afu cdev, and presumably that can't happen until you return from
release.

> +	put_device(&ctx->afu->dev);
> +
> +	/* It should be safe to remove the context now */
> +	cxl_context_free(ctx);

My other worry is that it's not until here that you remove the ctx from the
idr. And so up until this point the ctx could be found in the idr and used by
someone.

I think it would be better to remove the ctx from the idr earlier, before you
start tearing things down. Perhaps even in cxl_context_detach().

> +	cxl_ctx_put();
> +	return 0;
> +}


> +static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
> +			loff_t *off)
> +{
> +	struct cxl_context_t *ctx = file->private_data;
> +	struct cxl_event event;
> +	unsigned long flags;
> +	ssize_t size;
> +	DEFINE_WAIT(wait);
> +
> +	if (count < sizeof(struct cxl_event_header))
> +		return -EINVAL;

This could use some love. The locking in here is pretty funky, and not good
funky.

> +	while (1) {
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		if (ctx->pending_irq || ctx->pending_fault ||
> +		    ctx->pending_afu_err || (ctx->status == CLOSED))
> +			break;
> +		spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +
> +		prepare_to_wait(&ctx->wq, &wait, TASK_INTERRUPTIBLE);
> +		if (!(ctx->pending_irq || ctx->pending_fault ||
> +		      ctx->pending_afu_err || (ctx->status == CLOSED))) {
> +			pr_devel("afu_read going to sleep...\n");
> +			schedule();
> +			pr_devel("afu_read woken up\n");
> +		}
> +		finish_wait(&ctx->wq, &wait);
> +
> +		if (signal_pending(current))
> +			return -ERESTARTSYS;
> +	}
> +
> +	memset(&event, 0, sizeof(event));
> +	event.header.process_element = ctx->ph;
> +	if (ctx->pending_irq) {
> +		pr_devel("afu_read delivering AFU interrupt\n");
> +		event.header.size = sizeof(struct cxl_event_afu_interrupt);
> +		event.header.type = CXL_EVENT_AFU_INTERRUPT;
> +		event.irq.irq = find_first_bit(ctx->irq_bitmap, ctx->irq_count) + 1;
> +
> +		/* Only clear the IRQ if we can send the whole event: */
> +		if (count >= event.header.size) {
> +			clear_bit(event.irq.irq - 1, ctx->irq_bitmap);
> +			if (bitmap_empty(ctx->irq_bitmap, ctx->irq_count))
> +				ctx->pending_irq = false;
> +		}
> +	} else if (ctx->pending_fault) {
> +		pr_devel("afu_read delivering data storage fault\n");
> +		event.header.size = sizeof(struct cxl_event_data_storage);
> +		event.header.type = CXL_EVENT_DATA_STORAGE;
> +		event.fault.addr = ctx->fault_addr;
> +
> +		/* Only clear the fault if we can send the whole event: */
> +		if (count >= event.header.size)
> +			ctx->pending_fault = false;
> +	} else if (ctx->pending_afu_err) {
> +		pr_devel("afu_read delivering afu error\n");
> +		event.header.size = sizeof(struct cxl_event_afu_error);
> +		event.header.type = CXL_EVENT_AFU_ERROR;
> +		event.afu_err.err = ctx->afu_err;
> +
> +		/* Only clear the fault if we can send the whole event: */
> +		if (count >= event.header.size)
> +			ctx->pending_afu_err = false;
> +	} else if (ctx->status == CLOSED) {
> +		pr_devel("afu_read fatal error\n");
> +		spin_unlock_irqrestore(&ctx->lock, flags);
> +		return -EIO;
> +	} else
> +		WARN(1, "afu_read must be buggy\n");
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	size = min_t(size_t, count, event.header.size);
> +	copy_to_user(buf, &event, size);
> +
> +	return size;
> +}

> diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
> new file mode 100644
> index 0000000..3e01e1d
> --- /dev/null
> +++ b/drivers/misc/cxl/irq.c
...
> +
> +void afu_release_irqs(struct cxl_context_t *ctx)
> +{
> +	irq_hw_number_t hwirq;
> +	unsigned int virq;
> +	int r, i;
> +
> +	for (r = 1; r < CXL_IRQ_RANGES; r++) {
> +		hwirq = ctx->irqs.offset[r];
> +		for (i = 0; i < ctx->irqs.range[r]; hwirq++, i++) {
> +			virq = irq_find_mapping(NULL, hwirq);
> +			if (virq)
> +				cxl_unmap_irq(virq, ctx);
> +		}
> +	}
> +
> +	ctx->afu->adapter->driver->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);

Do we need this many levels of indirection?

cheers
