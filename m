Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3AVPMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:12:51 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:55053 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3AVPMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:12:48 -0500
Message-ID: <50FEAC87.7090702@gmail.com>
Date: Tue, 22 Jan 2013 16:13:11 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/7] fence: dma-buf cross-device synchronization
 (v11)
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com> <1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
In-Reply-To: <1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/15/2013 01:34 PM, Maarten Lankhorst wrote:
[...]
> diff --git a/include/linux/fence.h b/include/linux/fence.h
> new file mode 100644
> index 0000000..d9f091d
> --- /dev/null
> +++ b/include/linux/fence.h
> @@ -0,0 +1,347 @@
> +/*
> + * Fence mechanism for dma-buf to allow for asynchronous dma access
> + *
> + * Copyright (C) 2012 Canonical Ltd
> + * Copyright (C) 2012 Texas Instruments
> + *
> + * Authors:
> + * Rob Clark <rob.clark@linaro.org>
> + * Maarten Lankhorst <maarten.lankhorst@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __LINUX_FENCE_H
> +#define __LINUX_FENCE_H
> +
> +#include <linux/err.h>
> +#include <linux/wait.h>
> +#include <linux/list.h>
> +#include <linux/bitops.h>
> +#include <linux/kref.h>
> +#include <linux/sched.h>
> +#include <linux/printk.h>
> +
> +struct fence;
> +struct fence_ops;
> +struct fence_cb;
> +
> +/**
> + * struct fence - software synchronization primitive
> + * @refcount: refcount for this fence
> + * @ops: fence_ops associated with this fence
> + * @cb_list: list of all callbacks to call
> + * @lock: spin_lock_irqsave used for locking
> + * @priv: fence specific private data
> + * @flags: A mask of FENCE_FLAG_* defined below
> + *
> + * the flags member must be manipulated and read using the appropriate
> + * atomic ops (bit_*), so taking the spinlock will not be needed most
> + * of the time.
> + *
> + * FENCE_FLAG_SIGNALED_BIT - fence is already signaled
> + * FENCE_FLAG_ENABLE_SIGNAL_BIT - enable_signaling might have been called*
> + * FENCE_FLAG_USER_BITS - start of the unused bits, can be used by the
> + * implementer of the fence for its own purposes. Can be used in different
> + * ways by different fence implementers, so do not rely on this.
> + *
> + * *) Since atomic bitops are used, this is not guaranteed to be the case.
> + * Particularly, if the bit was set, but fence_signal was called right
> + * before this bit was set, it would have been able to set the
> + * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
> + * Adding a check for FENCE_FLAG_SIGNALED_BIT after setting
> + * FENCE_FLAG_ENABLE_SIGNAL_BIT closes this race, and makes sure that
> + * after fence_signal was called, any enable_signaling call will have either
> + * been completed, or never called at all.
> + */
> +struct fence {
> +	struct kref refcount;
> +	const struct fence_ops *ops;
> +	struct list_head cb_list;
> +	spinlock_t *lock;
> +	unsigned context, seqno;
> +	unsigned long flags;
> +};

The documentation above should be updated with the new structure members
context and seqno.

> +
> +enum fence_flag_bits {
> +	FENCE_FLAG_SIGNALED_BIT,
> +	FENCE_FLAG_ENABLE_SIGNAL_BIT,
> +	FENCE_FLAG_USER_BITS, /* must always be last member */
> +};
> +
> +typedef void (*fence_func_t)(struct fence *fence, struct fence_cb *cb, void *priv);
> +
> +/**
> + * struct fence_cb - callback for fence_add_callback
> + * @func: fence_func_t to call
> + * @priv: value of priv to pass to function
> + *
> + * This struct will be initialized by fence_add_callback, additional
> + * data can be passed along by embedding fence_cb in another struct.
> + */
> +struct fence_cb {
> +	struct list_head node;
> +	fence_func_t func;
> +	void *priv;
> +};

Documentation should be updated here too.

> +
> +/**
> + * struct fence_ops - operations implemented for fence
> + * @enable_signaling: enable software signaling of fence
> + * @signaled: [optional] peek whether the fence is signaled
> + * @release: [optional] called on destruction of fence
> + *
> + * Notes on enable_signaling:
> + * For fence implementations that have the capability for hw->hw
> + * signaling, they can implement this op to enable the necessary
> + * irqs, or insert commands into cmdstream, etc.  This is called
> + * in the first wait() or add_callback() path to let the fence
> + * implementation know that there is another driver waiting on
> + * the signal (ie. hw->sw case).
> + *
> + * This function can be called called from atomic context, but not
> + * from irq context, so normal spinlocks can be used.
> + *
> + * A return value of false indicates the fence already passed,
> + * or some failure occured that made it impossible to enable
> + * signaling. True indicates succesful enabling.
> + *
> + * Calling fence_signal before enable_signaling is called allows
> + * for a tiny race window in which enable_signaling is called during,
> + * before, or after fence_signal. To fight this, it is recommended
> + * that before enable_signaling returns true an extra reference is
> + * taken on the fence, to be released when the fence is signaled.
> + * This will mean fence_signal will still be called twice, but
> + * the second time will be a noop since it was already signaled.
> + *
> + * Notes on release:
> + * Can be NULL, this function allows additional commands to run on
> + * destruction of the fence. Can be called from irq context.
> + * If pointer is set to NULL, kfree will get called instead.
> + */
> +
> +struct fence_ops {
> +	bool (*enable_signaling)(struct fence *fence);
> +	bool (*signaled)(struct fence *fence);
> +	long (*wait)(struct fence *fence, bool intr, signed long);
> +	void (*release)(struct fence *fence);
> +};

Ditto.

> +
> +/**
> + * __fence_init - Initialize a custom fence.
> + * @fence:	[in]	the fence to initialize
> + * @ops:	[in]	the fence_ops for operations on this fence
> + * @lock:	[in]	the irqsafe spinlock to use for locking this fence
> + * @context:	[in]	the execution context this fence is run on
> + * @seqno:	[in]	a linear increasing sequence number for this context
> + *
> + * Initializes an allocated fence, the caller doesn't have to keep its
> + * refcount after committing with this fence, but it will need to hold a
> + * refcount again if fence_ops.enable_signaling gets called. This can
> + * be used for other implementing other types of fence.
> + *
> + * context and seqno are used for easy comparison between fences, allowing
> + * to check which fence is later by simply using fence_later.
> + */
> +static inline void
> +__fence_init(struct fence *fence, const struct fence_ops *ops,
> +	     spinlock_t *lock, unsigned context, unsigned seqno)
> +{
> +	BUG_ON(!ops || !lock || !ops->enable_signaling || !ops->wait);
> +
> +	kref_init(&fence->refcount);
> +	fence->ops = ops;
> +	INIT_LIST_HEAD(&fence->cb_list);
> +	fence->lock = lock;
> +	fence->context = context;
> +	fence->seqno = seqno;
> +	fence->flags = 0UL;
> +}
> +
> +/**
> + * fence_get - increases refcount of the fence
> + * @fence:	[in]	fence to increase refcount of
> + */
> +static inline void fence_get(struct fence *fence)
> +{
> +	if (WARN_ON(!fence))
> +		return;
> +	kref_get(&fence->refcount);
> +}
> +
> +extern void release_fence(struct kref *kref);
> +
> +/**
> + * fence_put - decreases refcount of the fence
> + * @fence:	[in]	fence to reduce refcount of
> + */
> +static inline void fence_put(struct fence *fence)
> +{
> +	if (WARN_ON(!fence))
> +		return;
> +	kref_put(&fence->refcount, release_fence);
> +}
> +
> +int fence_signal(struct fence *fence);
> +int __fence_signal(struct fence *fence);
> +long fence_default_wait(struct fence *fence, bool intr, signed long);

In the parameter list the first two parameters are named, and the last
one isn't. Feels a bit odd...

> +int fence_add_callback(struct fence *fence, struct fence_cb *cb,
> +		       fence_func_t func, void *priv);
> +bool fence_remove_callback(struct fence *fence, struct fence_cb *cb);
> +void fence_enable_sw_signaling(struct fence *fence);
> +
> +/**
> + * fence_is_signaled - Return an indication if the fence is signaled yet.
> + * @fence:	[in]	the fence to check
> + *
> + * Returns true if the fence was already signaled, false if not. Since this
> + * function doesn't enable signaling, it is not guaranteed to ever return true
> + * If fence_add_callback, fence_wait or fence_enable_sw_signaling
> + * haven't been called before.
> + *
> + * It's recommended for seqno fences to call fence_signal when the
> + * operation is complete, it makes it possible to prevent issues from
> + * wraparound between time of issue and time of use by checking the return
> + * value of this function before calling hardware-specific wait instructions.
> + */
> +static inline bool
> +fence_is_signaled(struct fence *fence)
> +{
> +	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> +		return true;
> +
> +	if (fence->ops->signaled && fence->ops->signaled(fence)) {
> +		fence_signal(fence);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/**
> + * fence_later - return the chronologically later fence
> + * @f1:	[in]	the first fence from the same context
> + * @f2:	[in]	the second fence from the same context
> + *
> + * Returns NULL if both fences are signaled, otherwise the fence that would be
> + * signaled last. Both fences must be from the same context, since a seqno is
> + * not re-used across contexts.
> + */
> +static inline struct fence *fence_later(struct fence *f1, struct fence *f2)
> +{
> +	bool sig1, sig2;
> +
> +	/*
> +	 * can't check just FENCE_FLAG_SIGNALED_BIT here, it may never have been
> +	 * set called if enable_signaling wasn't, and enabling that here is
> +	 * overkill.
> +	 */
> +	sig1 = fence_is_signaled(f1);
> +	sig2 = fence_is_signaled(f2);
> +
> +	if (sig1 && sig2)
> +		return NULL;
> +
> +	BUG_ON(f1->context != f2->context);
> +
> +	if (sig1 || f2->seqno - f2->seqno <= INT_MAX)

I guess you meant (f2->seqno - f1->seqno).

> +		return f2;
> +	else
> +		return f1;
> +}

Regards,
Francesco
