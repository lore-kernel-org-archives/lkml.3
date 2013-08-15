Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3HOLQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:16:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3HOLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:16:29 -0400
Message-ID: <520CB88A.9080401@canonical.com>
Date: Thu, 15 Aug 2013 13:16:26 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] fence: dma-buf cross-device synchronization (v12)
References: <20130729140519.25868.86479.stgit@patser> <CAF6AEGtTB05-Jf1sN9RxSak6EW77Et2HM1xr=gzLHLyc9VLYOQ@mail.gmail.com>
In-Reply-To: <CAF6AEGtTB05-Jf1sN9RxSak6EW77Et2HM1xr=gzLHLyc9VLYOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-08-13 17:43, Rob Clark schreef:
> On Mon, Jul 29, 2013 at 10:05 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> A fence can be attached to a buffer which is being filled or consumed
>> by hw, to allow userspace to pass the buffer without waiting to another
>> device.  For example, userspace can call page_flip ioctl to display the
>> next frame of graphics after kicking the GPU but while the GPU is still
>> rendering.  The display device sharing the buffer with the GPU would
>> attach a callback to get notified when the GPU's rendering-complete IRQ
>> fires, to update the scan-out address of the display, without having to
>> wake up userspace.
>>
>> A driver must allocate a fence context for each execution ring that can
>> run in parallel. The function for this takes an argument with how many
>> contexts to allocate:
>>   + fence_context_alloc()
>>
>> A fence is transient, one-shot deal.  It is allocated and attached
>> to one or more dma-buf's.  When the one that attached it is done, with
>> the pending operation, it can signal the fence:
>>   + fence_signal()
>>
>> To have a rough approximation whether a fence is fired, call:
>>   + fence_is_signaled()
>>
>> The dma-buf-mgr handles tracking, and waiting on, the fences associated
>> with a dma-buf.
>>
>> The one pending on the fence can add an async callback:
>>   + fence_add_callback()
>>
>> The callback can optionally be cancelled with:
>>   + fence_remove_callback()
>>
>> To wait synchronously, optionally with a timeout:
>>   + fence_wait()
>>   + fence_wait_timeout()
>>
>> A default software-only implementation is provided, which can be used
>> by drivers attaching a fence to a buffer when they have no other means
>> for hw sync.  But a memory backed fence is also envisioned, because it
>> is common that GPU's can write to, or poll on some memory location for
>> synchronization.  For example:
>>
>>   fence = custom_get_fence(...);
>>   if ((seqno_fence = to_seqno_fence(fence)) != NULL) {
>>     dma_buf *fence_buf = fence->sync_buf;
>>     get_dma_buf(fence_buf);
>>
>>     ... tell the hw the memory location to wait ...
>>     custom_wait_on(fence_buf, fence->seqno_ofs, fence->seqno);
>>   } else {
>>     /* fall-back to sw sync * /
>>     fence_add_callback(fence, my_cb);
>>   }
>>
>> On SoC platforms, if some other hw mechanism is provided for synchronizing
>> between IP blocks, it could be supported as an alternate implementation
>> with it's own fence ops in a similar way.
>>
>> enable_signaling callback is used to provide sw signaling in case a cpu
>> waiter is requested or no compatible hardware signaling could be used.
>>
>> The intention is to provide a userspace interface (presumably via eventfd)
>> later, to be used in conjunction with dma-buf's mmap support for sw access
>> to buffers (or for userspace apps that would prefer to do their own
>> synchronization).
>>
>> v1: Original
>> v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
>>     that dma-fence didn't need to care about the sw->hw signaling path
>>     (it can be handled same as sw->sw case), and therefore the fence->ops
>>     can be simplified and more handled in the core.  So remove the signal,
>>     add_callback, cancel_callback, and wait ops, and replace with a simple
>>     enable_signaling() op which can be used to inform a fence supporting
>>     hw->hw signaling that one or more devices which do not support hw
>>     signaling are waiting (and therefore it should enable an irq or do
>>     whatever is necessary in order that the CPU is notified when the
>>     fence is passed).
>> v3: Fix locking fail in attach_fence() and get_fence()
>> v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
>>     we decided that we need to be able to attach one fence to N dma-buf's,
>>     so using the list_head in dma-fence struct would be problematic.
>> v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
>> v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
>>     about checking if fence fired or not. This is broken by design.
>>     waitqueue_active during destruction is now fatal, since the signaller
>>     should be holding a reference in enable_signalling until it signalled
>>     the fence. Pass the original dma_fence_cb along, and call __remove_wait
>>     in the dma_fence_callback handler, so that no cleanup needs to be
>>     performed.
>> v7: [ Maarten Lankhorst ] Set cb->func and only enable sw signaling if
>>     fence wasn't signaled yet, for example for hardware fences that may
>>     choose to signal blindly.
>> v8: [ Maarten Lankhorst ] Tons of tiny fixes, moved __dma_fence_init to
>>     header and fixed include mess. dma-fence.h now includes dma-buf.h
>>     All members are now initialized, so kmalloc can be used for
>>     allocating a dma-fence. More documentation added.
>> v9: Change compiler bitfields to flags, change return type of
>>     enable_signaling to bool. Rework dma_fence_wait. Added
>>     dma_fence_is_signaled and dma_fence_wait_timeout.
>>     s/dma// and change exports to non GPL. Added fence_is_signaled and
>>     fence_enable_sw_signaling calls, add ability to override default
>>     wait operation.
>> v10: remove event_queue, use a custom list, export try_to_wake_up from
>>     scheduler. Remove fence lock and use a global spinlock instead,
>>     this should hopefully remove all the locking headaches I was having
>>     on trying to implement this. enable_signaling is called with this
>>     lock held.
>> v11:
>>     Use atomic ops for flags, lifting the need for some spin_lock_irqsaves.
>>     However I kept the guarantee that after fence_signal returns, it is
>>     guaranteed that enable_signaling has either been called to completion,
>>     or will not be called any more.
>>
>>     Add contexts and seqno to base fence implementation. This allows you
>>     to wait for less fences, by testing for seqno + signaled, and then only
>>     wait on the later fence.
>>
>>     Add FENCE_TRACE, FENCE_WARN, and FENCE_ERR. This makes debugging easier.
>>     An CONFIG_DEBUG_FENCE will be added to turn off the FENCE_TRACE
>>     spam, and another runtime option can turn it off at runtime.
>> v12:
>>     Add CONFIG_FENCE_TRACE. Add missing documentation for the fence->context
>>     and fence->seqno members.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Hi, few (mostly minor/superficial comments).. I didn't really spot
> anything major (but then again, I think I've looked at all/most of the
> earlier versions of this too)
>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
>
>> ....
>> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
>> index 5daa259..0ad35df 100644
>> --- a/drivers/base/Kconfig
>> +++ b/drivers/base/Kconfig
>> @@ -200,6 +200,16 @@ config DMA_SHARED_BUFFER
>>           APIs extension; the file's descriptor can then be passed on to other
>>           driver.
>>
>> +config FENCE_TRACE
>> +       bool "Enable verbose FENCE_TRACE messages"
>> +       default n
>> +       depends on DMA_SHARED_BUFFER
>> +       help
>> +         Enable the FENCE_TRACE printks. This will add extra
>> +         spam to the config log, but will make it easier to diagnose
> s/config/console/ I guess?
Yep, thanks!
>> ...
>> +
>> +/**
>> + * fence_add_callback - add a callback to be called when the fence
>> + * is signaled
>> + * @fence:     [in]    the fence to wait on
>> + * @cb:                [in]    the callback to register
>> + * @func:      [in]    the function to call
>> + * @priv:      [in]    the argument to pass to function
>> + *
>> + * cb will be initialized by fence_add_callback, no initialization
>> + * by the caller is required. Any number of callbacks can be registered
>> + * to a fence, but a callback can only be registered to one fence at a time.
>> + *
>> + * Note that the callback can be called from an atomic context.  If
>> + * fence is already signaled, this function will return -ENOENT (and
>> + * *not* call the callback)
>> + *
>> + * Add a software callback to the fence. Same restrictions apply to
>> + * refcount as it does to fence_wait, however the caller doesn't need to
>> + * keep a refcount to fence afterwards: when software access is enabled,
>> + * the creator of the fence is required to keep the fence alive until
>> + * after it signals with fence_signal. The callback itself can be called
>> + * from irq context.
>> + *
>> + */
>> +int fence_add_callback(struct fence *fence, struct fence_cb *cb,
>> +                      fence_func_t func, void *priv)
>> +{
>> +       unsigned long flags;
>> +       int ret = 0;
>> +       bool was_set;
>> +
>> +       if (WARN_ON(!fence || !func))
>> +               return -EINVAL;
>> +
>> +       if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +               return -ENOENT;
>> +
>> +       spin_lock_irqsave(fence->lock, flags);
>> +
>> +       was_set = test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags);
>> +
>> +       if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>> +               ret = -ENOENT;
>> +       else if (!was_set && !fence->ops->enable_signaling(fence)) {
>> +               __fence_signal(fence);
>> +               ret = -ENOENT;
>> +       }
>> +
>> +       if (!ret) {
>> +               cb->func = func;
>> +               cb->priv = priv;
>> +               list_add_tail(&cb->node, &fence->cb_list);
> since the user is providing the 'struct fence_cb', why not drop the
> priv & func args, and have some cb-initialize macro, ie.
>
> INIT_FENCE_CB(&foo->fence, cbfxn);
>
> and I guess we can just drop priv and let the user embed fence in
> whatever structure they like.  Ie. make it look a bit how work_struct
> works.
I don't mind killing priv. But a INIT_FENCE_CB macro is silly, when all it would do is set cb->func.
So passing it as  an argument to fence_add_callback is fine, unless you have a better reason to
do so.

INIT_WORK seems to have a bit more initialization than us, it seems work can be more complicated
than callbacks, because the callbacks can only be called once and work can be rescheduled multiple times.
> maybe also, if (!list_empty(&cb->node) return -EBUSY?
I think checking for list_empty(cb->node) is a terrible idea. This is no different from any other list corruption,
and it's a programming error. Not a runtime error. :-)

cb->node.next/prev may be NULL, which would fail with this check. The contents of cb->node are undefined
before fence_add_callback is called. Calling fence_remove_callback on a fence that hasn't been added is
undefined too. Calling fence_remove_callback works, but I'm thinking of changing the list_del_init to list_del,
which would make calling fence_remove_callback twice a fatal error if CONFIG_DEBUG_LIST is enabled,
and a possible memory corruption otherwise.
>> ...
>> +
>> +/**
>> + * fence_later - return the chronologically later fence
>> + * @f1:        [in]    the first fence from the same context
>> + * @f2:        [in]    the second fence from the same context
>> + *
>> + * Returns NULL if both fences are signaled, otherwise the fence that would be
>> + * signaled last. Both fences must be from the same context, since a seqno is
>> + * not re-used across contexts.
>> + */
>> +static inline struct fence *fence_later(struct fence *f1, struct fence *f2)
> fence_before/fence_after?  (ie. more like time_before()/time_after())
>
>> +{
>> +       bool sig1, sig2;
>> +
>> +       /*
>> +        * can't check just FENCE_FLAG_SIGNALED_BIT here, it may never have been
>> +        * set called if enable_signaling wasn't, and enabling that here is
>> +        * overkill.
>> +        */
>> +       sig1 = fence_is_signaled(f1);
>> +       sig2 = fence_is_signaled(f2);
>> +
>> +       if (sig1 && sig2)
>> +               return NULL;
>> +
>> +       BUG_ON(f1->context != f2->context);
> hmm, I guess I have to see how this is used.. is the user expected to
> check a->context==b->context first?  Seems like it might be a bit
> nicer to just return -EINVAL in this case?  Not sure, would have to
> check how this is used.
This is not similar to time_before/time_after because fences must be of the same context.
For this reason I think changing the name to fence_after is confusing. This function is a helper
to deduce which fence to wait on, if they belong to the same context.

You could make a list of fences to wait on, when a new one gets added belonging to the same
context, then use fence_later to decide which fence to keep.
But this looks like this function can be simplified and call fence_is_signaled only once, so I'll send
a fixed version shortly.

>> +
>> +       if (sig1 || f2->seqno - f1->seqno <= INT_MAX)
>> +               return f2;
>> +       else
>> +               return f1;
>> +}
>> +
>> +/**
>> + * fence_wait_timeout - sleep until the fence gets signaled
>> + * or until timeout elapses
>> + * @fence:     [in]    the fence to wait on
>> + * @intr:      [in]    if true, do an interruptible wait
>> + * @timeout:   [in]    timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
>> + *
>> + * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
>> + * remaining timeout in jiffies on success. Other error values may be
>> + * returned on custom implementations.
>> + *
>> + * Performs a synchronous wait on this fence. It is assumed the caller
>> + * directly or indirectly (buf-mgr between reservation and committing)
>> + * holds a reference to the fence, otherwise the fence might be
>> + * freed before return, resulting in undefined behavior.
>> + */
>> +static inline long
>> +fence_wait_timeout(struct fence *fence, bool intr, signed long timeout)
>> +{
>> +       if (WARN_ON(timeout < 0))
>> +               return -EINVAL;
>> +
>> +       return fence->ops->wait(fence, intr, timeout);
>> +}
>> +
>> +/**
>> + * fence_wait - sleep until the fence gets signaled
>> + * @fence:     [in]    the fence to wait on
>> + * @intr:      [in]    if true, do an interruptible wait
>> + *
>> + * This function will return -ERESTARTSYS if interrupted by a signal,
>> + * or 0 if the fence was signaled. Other error values may be
>> + * returned on custom implementations.
>> + *
>> + * Performs a synchronous wait on this fence. It is assumed the caller
>> + * directly or indirectly (buf-mgr between reservation and committing)
>> + * holds a reference to the fence, otherwise the fence might be
>> + * freed before return, resulting in undefined behavior.
>> + */
>> +static inline long fence_wait(struct fence *fence, bool intr)
>> +{
>> +       long ret;
>> +
>> +       /* Since fence_wait_timeout cannot timeout with
>> +        * MAX_SCHEDULE_TIMEOUT, only valid return values are
>> +        * -ERESTARTSYS and MAX_SCHEDULE_TIMEOUT.
>> +        */
>> +       ret = fence_wait_timeout(fence, intr, MAX_SCHEDULE_TIMEOUT);
>> +
>> +       return ret < 0 ? ret : 0;
>> +}
>> +
>> +/**
>> + * fence context counter: each execution context should have its own
>> + * fence context, this allows checking if fences belong to the same
>> + * context or not. One device can have multiple separate contexts,
>> + * and they're used if some engine can run independently of another.
>> + */
>> +extern atomic_t fence_context_counter;
> context-alloc should not be in the critical path.. I'd think probably
> drop the extern and inline, and make fence_context_counter static
> inside the .c
Shrug, your bikeshed. I'll fix it shortly.
>> +
>> +static inline unsigned fence_context_alloc(unsigned num)
> well, this is actually allocating 'num' contexts, so
> 'fence_context_alloc()' sounds a bit funny.. or at least to me it
> sounds from the name like it allocates a single context
Sorry, max number of bikesheds reached. :P

~Maarten

