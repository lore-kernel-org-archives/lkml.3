Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaFSBXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:23:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53352 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaFSBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140619011327.GC10921@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
Date: Wed, 18 Jun 2014 21:23:06 -0400
Message-ID: <CAF6AEGvXp-bBSaU2o-ix+M4+zX24je=y_csz49g_zNn0YPpDYg@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Rob Clark <robdclark@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 9:13 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 18, 2014 at 12:36:54PM +0200, Maarten Lankhorst wrote:
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/fence.h>
>> +
>> +EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
>> +EXPORT_TRACEPOINT_SYMBOL(fence_emit);
>
> Are you really willing to live with these as tracepoints for forever?
> What is the use of them in debugging?  Was it just for debugging the
> fence code, or for something else?

fwiw, the goal is something like this:

http://people.freedesktop.org/~robclark/perf-supertuxkart.svg

but without needing to make perf understand each driver's custom trace events

(from: http://bloggingthemonkey.blogspot.com/2013/09/freedreno-update-moar-fps.html
)

BR,
-R


>> +/**
>> + * fence_context_alloc - allocate an array of fence contexts
>> + * @num:     [in]    amount of contexts to allocate
>> + *
>> + * This function will return the first index of the number of fences allocated.
>> + * The fence context is used for setting fence->context to a unique number.
>> + */
>> +unsigned fence_context_alloc(unsigned num)
>> +{
>> +     BUG_ON(!num);
>> +     return atomic_add_return(num, &fence_context_counter) - num;
>> +}
>> +EXPORT_SYMBOL(fence_context_alloc);
>
> EXPORT_SYMBOL_GPL()?  Same goes for all of the exports in here.
> Traditionally all of the driver core exports have been with this
> marking, any objection to making that change here as well?
>
>> +int __fence_signal(struct fence *fence)
>> +{
>> +     struct fence_cb *cur, *tmp;
>> +     int ret = 0;
>> +
>> +     if (WARN_ON(!fence))
>> +             return -EINVAL;
>> +
>> +     if (!ktime_to_ns(fence->timestamp)) {
>> +             fence->timestamp = ktime_get();
>> +             smp_mb__before_atomic();
>> +     }
>> +
>> +     if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
>> +             ret = -EINVAL;
>> +
>> +             /*
>> +              * we might have raced with the unlocked fence_signal,
>> +              * still run through all callbacks
>> +              */
>> +     } else
>> +             trace_fence_signaled(fence);
>> +
>> +     list_for_each_entry_safe(cur, tmp, &fence->cb_list, node) {
>> +             list_del_init(&cur->node);
>> +             cur->func(fence, cur);
>> +     }
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(__fence_signal);
>
> Don't export a function with __ in front of it, you are saying that an
> internal function is somehow "valid" for everyone else to call?  Why?
> You aren't even documenting the function, so who knows how to use it?
>
>> +/**
>> + * fence_signal - signal completion of a fence
>> + * @fence: the fence to signal
>> + *
>> + * Signal completion for software callbacks on a fence, this will unblock
>> + * fence_wait() calls and run all the callbacks added with
>> + * fence_add_callback(). Can be called multiple times, but since a fence
>> + * can only go from unsignaled to signaled state, it will only be effective
>> + * the first time.
>> + */
>> +int fence_signal(struct fence *fence)
>> +{
>> +     unsigned long flags;
>> +
>> +     if (!fence)
>> +             return -EINVAL;
>> +
>> +     if (!ktime_to_ns(fence->timestamp)) {
>> +             fence->timestamp = ktime_get();
>> +             smp_mb__before_atomic();
>> +     }
>> +
>> +     if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +             return -EINVAL;
>> +
>> +     trace_fence_signaled(fence);
>> +
>> +     if (test_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags)) {
>> +             struct fence_cb *cur, *tmp;
>> +
>> +             spin_lock_irqsave(fence->lock, flags);
>> +             list_for_each_entry_safe(cur, tmp, &fence->cb_list, node) {
>> +                     list_del_init(&cur->node);
>> +                     cur->func(fence, cur);
>> +             }
>> +             spin_unlock_irqrestore(fence->lock, flags);
>> +     }
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(fence_signal);
>
> So, why should I use this over __fence_signal?  What is the difference?
> Am I missing some documentation somewhere?
>
>> +void release_fence(struct kref *kref)
>> +{
>> +     struct fence *fence =
>> +                     container_of(kref, struct fence, refcount);
>> +
>> +     trace_fence_destroy(fence);
>> +
>> +     BUG_ON(!list_empty(&fence->cb_list));
>> +
>> +     if (fence->ops->release)
>> +             fence->ops->release(fence);
>> +     else
>> +             kfree(fence);
>> +}
>> +EXPORT_SYMBOL(release_fence);
>
> fence_release() makes it more unified with the other functions in this
> file, right?
>
>> +/**
>> + * fence_default_wait - default sleep until the fence gets signaled
>> + * or until timeout elapses
>> + * @fence:   [in]    the fence to wait on
>> + * @intr:    [in]    if true, do an interruptible wait
>> + * @timeout: [in]    timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
>> + *
>> + * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
>> + * remaining timeout in jiffies on success.
>> + */
>> +long
>
> Shouldn't this be signed to be explicit?
>
>> +fence_default_wait(struct fence *fence, bool intr, signed long timeout)
>> +{
>> +     struct default_wait_cb cb;
>> +     unsigned long flags;
>> +     long ret = timeout;
>> +     bool was_set;
>> +
>> +     if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +             return timeout;
>> +
>> +     spin_lock_irqsave(fence->lock, flags);
>> +
>> +     if (intr && signal_pending(current)) {
>> +             ret = -ERESTARTSYS;
>> +             goto out;
>> +     }
>> +
>> +     was_set = test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags);
>> +
>> +     if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +             goto out;
>> +
>> +     if (!was_set) {
>> +             trace_fence_enable_signal(fence);
>> +
>> +             if (!fence->ops->enable_signaling(fence)) {
>> +                     __fence_signal(fence);
>> +                     goto out;
>> +             }
>> +     }
>> +
>> +     cb.base.func = fence_default_wait_cb;
>> +     cb.task = current;
>> +     list_add(&cb.base.node, &fence->cb_list);
>> +
>> +     while (!test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
>> +             if (intr)
>> +                     __set_current_state(TASK_INTERRUPTIBLE);
>> +             else
>> +                     __set_current_state(TASK_UNINTERRUPTIBLE);
>> +             spin_unlock_irqrestore(fence->lock, flags);
>> +
>> +             ret = schedule_timeout(ret);
>> +
>> +             spin_lock_irqsave(fence->lock, flags);
>> +             if (ret > 0 && intr && signal_pending(current))
>> +                     ret = -ERESTARTSYS;
>> +     }
>> +
>> +     if (!list_empty(&cb.base.node))
>> +             list_del(&cb.base.node);
>> +     __set_current_state(TASK_RUNNING);
>> +
>> +out:
>> +     spin_unlock_irqrestore(fence->lock, flags);
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(fence_default_wait);
>> +
>> +/**
>> + * __fence_init - Initialize a custom fence.
>> + * @fence:   [in]    the fence to initialize
>> + * @ops:     [in]    the fence_ops for operations on this fence
>> + * @lock:    [in]    the irqsafe spinlock to use for locking this fence
>> + * @context: [in]    the execution context this fence is run on
>> + * @seqno:   [in]    a linear increasing sequence number for this context
>> + *
>> + * Initializes an allocated fence, the caller doesn't have to keep its
>> + * refcount after committing with this fence, but it will need to hold a
>> + * refcount again if fence_ops.enable_signaling gets called. This can
>> + * be used for other implementing other types of fence.
>> + *
>> + * context and seqno are used for easy comparison between fences, allowing
>> + * to check which fence is later by simply using fence_later.
>> + */
>> +void
>> +__fence_init(struct fence *fence, const struct fence_ops *ops,
>> +          spinlock_t *lock, unsigned context, unsigned seqno)
>> +{
>> +     BUG_ON(!lock);
>> +     BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
>> +            !ops->get_driver_name || !ops->get_timeline_name);
>> +
>> +     kref_init(&fence->refcount);
>> +     fence->ops = ops;
>> +     INIT_LIST_HEAD(&fence->cb_list);
>> +     fence->lock = lock;
>> +     fence->context = context;
>> +     fence->seqno = seqno;
>> +     fence->flags = 0UL;
>> +
>> +     trace_fence_init(fence);
>> +}
>> +EXPORT_SYMBOL(__fence_init);
>
> Again with the __ exported function...
>
> I don't even see a fence_init() function anywhere, why the __ ?
>
>
>> diff --git a/include/linux/fence.h b/include/linux/fence.h
>> new file mode 100644
>> index 000000000000..65f2a01ee7e4
>> --- /dev/null
>> +++ b/include/linux/fence.h
>> @@ -0,0 +1,333 @@
>> +/*
>> + * Fence mechanism for dma-buf to allow for asynchronous dma access
>> + *
>> + * Copyright (C) 2012 Canonical Ltd
>> + * Copyright (C) 2012 Texas Instruments
>> + *
>> + * Authors:
>> + * Rob Clark <robdclark@gmail.com>
>> + * Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __LINUX_FENCE_H
>> +#define __LINUX_FENCE_H
>> +
>> +#include <linux/err.h>
>> +#include <linux/wait.h>
>> +#include <linux/list.h>
>> +#include <linux/bitops.h>
>> +#include <linux/kref.h>
>> +#include <linux/sched.h>
>> +#include <linux/printk.h>
>> +
>> +struct fence;
>> +struct fence_ops;
>> +struct fence_cb;
>> +
>> +/**
>> + * struct fence - software synchronization primitive
>> + * @refcount: refcount for this fence
>> + * @ops: fence_ops associated with this fence
>> + * @cb_list: list of all callbacks to call
>> + * @lock: spin_lock_irqsave used for locking
>> + * @context: execution context this fence belongs to, returned by
>> + *           fence_context_alloc()
>> + * @seqno: the sequence number of this fence inside the execution context,
>> + * can be compared to decide which fence would be signaled later.
>> + * @flags: A mask of FENCE_FLAG_* defined below
>> + * @timestamp: Timestamp when the fence was signaled.
>> + * @status: Optional, only valid if < 0, must be set before calling
>> + * fence_signal, indicates that the fence has completed with an error.
>> + *
>> + * the flags member must be manipulated and read using the appropriate
>> + * atomic ops (bit_*), so taking the spinlock will not be needed most
>> + * of the time.
>> + *
>> + * FENCE_FLAG_SIGNALED_BIT - fence is already signaled
>> + * FENCE_FLAG_ENABLE_SIGNAL_BIT - enable_signaling might have been called*
>> + * FENCE_FLAG_USER_BITS - start of the unused bits, can be used by the
>> + * implementer of the fence for its own purposes. Can be used in different
>> + * ways by different fence implementers, so do not rely on this.
>> + *
>> + * *) Since atomic bitops are used, this is not guaranteed to be the case.
>> + * Particularly, if the bit was set, but fence_signal was called right
>> + * before this bit was set, it would have been able to set the
>> + * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
>> + * Adding a check for FENCE_FLAG_SIGNALED_BIT after setting
>> + * FENCE_FLAG_ENABLE_SIGNAL_BIT closes this race, and makes sure that
>> + * after fence_signal was called, any enable_signaling call will have either
>> + * been completed, or never called at all.
>> + */
>> +struct fence {
>> +     struct kref refcount;
>> +     const struct fence_ops *ops;
>> +     struct list_head cb_list;
>> +     spinlock_t *lock;
>> +     unsigned context, seqno;
>> +     unsigned long flags;
>> +     ktime_t timestamp;
>> +     int status;
>> +};
>> +
>> +enum fence_flag_bits {
>> +     FENCE_FLAG_SIGNALED_BIT,
>> +     FENCE_FLAG_ENABLE_SIGNAL_BIT,
>> +     FENCE_FLAG_USER_BITS, /* must always be last member */
>> +};
>> +
>> +typedef void (*fence_func_t)(struct fence *fence, struct fence_cb *cb);
>> +
>> +/**
>> + * struct fence_cb - callback for fence_add_callback
>> + * @node: used by fence_add_callback to append this struct to fence::cb_list
>> + * @func: fence_func_t to call
>> + *
>> + * This struct will be initialized by fence_add_callback, additional
>> + * data can be passed along by embedding fence_cb in another struct.
>> + */
>> +struct fence_cb {
>> +     struct list_head node;
>> +     fence_func_t func;
>> +};
>> +
>> +/**
>> + * struct fence_ops - operations implemented for fence
>> + * @get_driver_name: returns the driver name.
>> + * @get_timeline_name: return the name of the context this fence belongs to.
>> + * @enable_signaling: enable software signaling of fence.
>> + * @signaled: [optional] peek whether the fence is signaled, can be null.
>> + * @wait: custom wait implementation, or fence_default_wait.
>> + * @release: [optional] called on destruction of fence, can be null
>> + * @fill_driver_data: [optional] callback to fill in free-form debug info
>> + * Returns amount of bytes filled, or -errno.
>> + * @fence_value_str: [optional] fills in the value of the fence as a string
>> + * @timeline_value_str: [optional] fills in the current value of the timeline
>> + * as a string
>> + *
>> + * Notes on enable_signaling:
>> + * For fence implementations that have the capability for hw->hw
>> + * signaling, they can implement this op to enable the necessary
>> + * irqs, or insert commands into cmdstream, etc.  This is called
>> + * in the first wait() or add_callback() path to let the fence
>> + * implementation know that there is another driver waiting on
>> + * the signal (ie. hw->sw case).
>> + *
>> + * This function can be called called from atomic context, but not
>> + * from irq context, so normal spinlocks can be used.
>> + *
>> + * A return value of false indicates the fence already passed,
>> + * or some failure occured that made it impossible to enable
>> + * signaling. True indicates succesful enabling.
>> + *
>> + * fence->status may be set in enable_signaling, but only when false is
>> + * returned.
>> + *
>> + * Calling fence_signal before enable_signaling is called allows
>> + * for a tiny race window in which enable_signaling is called during,
>> + * before, or after fence_signal. To fight this, it is recommended
>> + * that before enable_signaling returns true an extra reference is
>> + * taken on the fence, to be released when the fence is signaled.
>> + * This will mean fence_signal will still be called twice, but
>> + * the second time will be a noop since it was already signaled.
>> + *
>> + * Notes on signaled:
>> + * May set fence->status if returning true.
>> + *
>> + * Notes on wait:
>> + * Must not be NULL, set to fence_default_wait for default implementation.
>> + * the fence_default_wait implementation should work for any fence, as long
>> + * as enable_signaling works correctly.
>> + *
>> + * Must return -ERESTARTSYS if the wait is intr = true and the wait was
>> + * interrupted, and remaining jiffies if fence has signaled, or 0 if wait
>> + * timed out. Can also return other error values on custom implementations,
>> + * which should be treated as if the fence is signaled. For example a hardware
>> + * lockup could be reported like that.
>> + *
>> + * Notes on release:
>> + * Can be NULL, this function allows additional commands to run on
>> + * destruction of the fence. Can be called from irq context.
>> + * If pointer is set to NULL, kfree will get called instead.
>> + */
>> +
>> +struct fence_ops {
>> +     const char * (*get_driver_name)(struct fence *fence);
>> +     const char * (*get_timeline_name)(struct fence *fence);
>> +     bool (*enable_signaling)(struct fence *fence);
>> +     bool (*signaled)(struct fence *fence);
>> +     long (*wait)(struct fence *fence, bool intr, signed long timeout);
>> +     void (*release)(struct fence *fence);
>> +
>> +     int (*fill_driver_data)(struct fence *fence, void *data, int size);
>> +     void (*fence_value_str)(struct fence *fence, char *str, int size);
>> +     void (*timeline_value_str)(struct fence *fence, char *str, int size);
>> +};
>> +
>> +void __fence_init(struct fence *fence, const struct fence_ops *ops,
>> +               spinlock_t *lock, unsigned context, unsigned seqno);
>> +
>> +/**
>> + * fence_get - increases refcount of the fence
>> + * @fence:   [in]    fence to increase refcount of
>> + */
>> +static inline void fence_get(struct fence *fence)
>> +{
>> +     if (WARN_ON(!fence))
>> +             return;
>
> Why warn?
>
>> +     kref_get(&fence->refcount);
>> +}
>
> Why is this inline?
>
>> +
>> +extern void release_fence(struct kref *kref);
>> +
>> +/**
>> + * fence_put - decreases refcount of the fence
>> + * @fence:   [in]    fence to reduce refcount of
>> + */
>> +static inline void fence_put(struct fence *fence)
>> +{
>> +     if (WARN_ON(!fence))
>> +             return;
>
> Same as above.
>
>> +     kref_put(&fence->refcount, release_fence);
>> +}
>
> Why inline?
>
>> +int fence_signal(struct fence *fence);
>> +int __fence_signal(struct fence *fence);
>
> Let's randomly pick a function to call... :)
>
>> +static inline bool
>> +__fence_is_signaled(struct fence *fence)
>> +{
>> +     if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +             return true;
>> +
>> +     if (fence->ops->signaled && fence->ops->signaled(fence)) {
>> +             __fence_signal(fence);
>> +             return true;
>> +     }
>> +
>> +     return false;
>> +}
>
> Oh nice, another __ function :(
>
>> +
>> +/**
>> + * fence_is_signaled - Return an indication if the fence is signaled yet.
>> + * @fence:   [in]    the fence to check
>> + *
>> + * Returns true if the fence was already signaled, false if not. Since this
>> + * function doesn't enable signaling, it is not guaranteed to ever return true
>> + * If fence_add_callback, fence_wait or fence_enable_sw_signaling
>> + * haven't been called before.
>> + *
>> + * It's recommended for seqno fences to call fence_signal when the
>> + * operation is complete, it makes it possible to prevent issues from
>> + * wraparound between time of issue and time of use by checking the return
>> + * value of this function before calling hardware-specific wait instructions.
>> + */
>> +static inline bool
>> +fence_is_signaled(struct fence *fence)
>> +{
>> +     if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +             return true;
>> +
>> +     if (fence->ops->signaled && fence->ops->signaled(fence)) {
>> +             fence_signal(fence);
>> +             return true;
>> +     }
>> +
>> +     return false;
>> +}
>
>
> Why inline for all of these, does it really matter for speed?
>
>> +/**
>> + * fence_later - return the chronologically later fence
>> + * @f1:      [in]    the first fence from the same context
>> + * @f2:      [in]    the second fence from the same context
>> + *
>> + * Returns NULL if both fences are signaled, otherwise the fence that would be
>> + * signaled last. Both fences must be from the same context, since a seqno is
>> + * not re-used across contexts.
>> + */
>> +static inline struct fence *fence_later(struct fence *f1, struct fence *f2)
>> +{
>> +     BUG_ON(f1->context != f2->context);
>
> Nice, you just crashed the kernel, making it impossible to debug or
> recover :(
>
> Don't do that.
>
> thanks,
>
> greg k-h
