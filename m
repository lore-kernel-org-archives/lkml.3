Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3HON56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:57:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab3HON5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:57:55 -0400
Message-ID: <520CDE61.5080106@canonical.com>
Date: Thu, 15 Aug 2013 15:57:53 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?TWFyY2luIMWabHVzYXJ6?= <marcin.slusarz@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robdclark@gmail.com, daniel@ffwll.ch, linux-media@vger.kernel.org
Subject: Re: [PATCH] fence: dma-buf cross-device synchronization (v13)
References: <20130815111630.3926.28372.stgit@patser> <CA+GA0_ucAAa0RLSL-QpUsX8QPQ=5PvqHkS4EUb3zTfCtYo9xqA@mail.gmail.com>
In-Reply-To: <CA+GA0_ucAAa0RLSL-QpUsX8QPQ=5PvqHkS4EUb3zTfCtYo9xqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-08-13 14:45, Marcin Ślusarz schreef:
> 2013/8/15 Maarten Lankhorst <maarten.lankhorst@canonical.com>:
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
>> v13:
>>     Fixup CONFIG_FENCE_TRACE kconfig description.
>>     Move fence_context_alloc to fence.
>>     Simplify fence_later.
>>     Kill priv member to fence_cb.
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>>  Documentation/DocBook/device-drivers.tmpl |    2
>>  drivers/base/Kconfig                      |   10 +
>>  drivers/base/Makefile                     |    2
>>  drivers/base/fence.c                      |  312 ++++++++++++++++++++++++++
>>  include/linux/fence.h                     |  344 +++++++++++++++++++++++++++++
>>  5 files changed, 669 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/base/fence.c
>>  create mode 100644 include/linux/fence.h
>>
>> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
>> index fe397f9..95d0db9 100644
>> --- a/Documentation/DocBook/device-drivers.tmpl
>> +++ b/Documentation/DocBook/device-drivers.tmpl
>> @@ -126,6 +126,8 @@ X!Edrivers/base/interface.c
>>       </sect1>
>>       <sect1><title>Device Drivers DMA Management</title>
>>  !Edrivers/base/dma-buf.c
>> +!Edrivers/base/fence.c
>> +!Iinclude/linux/fence.h
>>  !Edrivers/base/reservation.c
>>  !Iinclude/linux/reservation.h
>>  !Edrivers/base/dma-coherent.c
>> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
>> index 5daa259..2bf0add 100644
>> --- a/drivers/base/Kconfig
>> +++ b/drivers/base/Kconfig
>> @@ -200,6 +200,16 @@ config DMA_SHARED_BUFFER
>>           APIs extension; the file's descriptor can then be passed on to other
>>           driver.
>>
>> +config FENCE_TRACE
>> +       bool "Enable verbose FENCE_TRACE messages"
>> +       default n
> "default n" is superfluous
But it's used a lot in the kernel:

~/linux$ git grep default.y\$ | wc -l
1292
~/linux$ git grep default.n\$ | wc -l
697

>> ...
>> +void release_fence(struct kref *kref)
> All functions, except this one, follow "fence_$something" pattern.
> Passing kref is a bit odd.
This function is not intended to be called directly. It's used by fence_put.
>> ....
>> +/**
>> + * fence_remove_callback - remove a callback from the signaling list
>> + * @fence:     [in]    the fence to wait on
>> + * @cb:                [in]    the callback to remove
>> + *
>> + * Remove a previously queued callback from the fence. This function returns
>> + * true is the callback is succesfully removed, or false if the fence has
> true _if_ the callback is...
Oh wow, I had to read that 3 times to spot that typo after you pointed it out. :P
>> ...
>> +
>> +extern void release_fence(struct kref *kref);
>> +
>> +/**
>> + * fence_put - decreases refcount of the fence
>> + * @fence:     [in]    fence to reduce refcount of
>> + */
>> +static inline void fence_put(struct fence *fence)
>> +{
>> +       if (WARN_ON(!fence))
>> +               return;
>> +       kref_put(&fence->refcount, release_fence);
>> +}
>> +
>> +int fence_signal(struct fence *fence);
>> +int __fence_signal(struct fence *fence);
>> +long fence_default_wait(struct fence *fence, bool intr, signed long timeout);
>> +int fence_add_callback(struct fence *fence, struct fence_cb *cb,
>> +                      fence_func_t func, void *priv);
>> +bool fence_remove_callback(struct fence *fence, struct fence_cb *cb);
>> +void fence_enable_sw_signaling(struct fence *fence);
> Some functions are documented in the header and some only in the source file.
> Why not move all API docs into the header?
The declarations are put next to the code. The inlines are defined in the headers,
so they get documented there.
>> +
>> +/**
>> + * fence_is_signaled - Return an indication if the fence is signaled yet.
>> + * @fence:     [in]    the fence to check
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
> Shouldn't it be "fence_was_signaled"?
No, unless you believe the fence ended up in a state where it is signaled, and now no longer is. ;)

~Maarten
