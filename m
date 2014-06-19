Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbaFSE2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:28:00 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64408 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaFSE14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGtzv0+PoMwSfK=NTYAO=bxsnS2BcwLxLNmLqnGTEUV8ng@mail.gmail.com>
References: <20140618102957.15728.43525.stgit@patser> <20140618103653.15728.4942.stgit@patser>
 <20140619011653.GF10921@kroah.com> <CAF6AEGtzv0+PoMwSfK=NTYAO=bxsnS2BcwLxLNmLqnGTEUV8ng@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 19 Jun 2014 09:57:35 +0530
Message-ID: <CAO_48GF_hb5PZFwEmx8vsy+gW=Mq=cnEq8H4W74hCdz9qg0+SQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
To: Rob Clark <robdclark@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 19 June 2014 06:55, Rob Clark <robdclark@gmail.com> wrote:
> On Wed, Jun 18, 2014 at 9:16 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Wed, Jun 18, 2014 at 12:36:54PM +0200, Maarten Lankhorst wrote:
>>> A fence can be attached to a buffer which is being filled or consumed
>>> by hw, to allow userspace to pass the buffer without waiting to another
>>> device.  For example, userspace can call page_flip ioctl to display the
>>> next frame of graphics after kicking the GPU but while the GPU is still
>>> rendering.  The display device sharing the buffer with the GPU would
>>> attach a callback to get notified when the GPU's rendering-complete IRQ
>>> fires, to update the scan-out address of the display, without having to
>>> wake up userspace.
>>>
>>> A driver must allocate a fence context for each execution ring that can
>>> run in parallel. The function for this takes an argument with how many
>>> contexts to allocate:
>>>   + fence_context_alloc()
>>>
>>> A fence is transient, one-shot deal.  It is allocated and attached
>>> to one or more dma-buf's.  When the one that attached it is done, with
>>> the pending operation, it can signal the fence:
>>>   + fence_signal()
>>>
>>> To have a rough approximation whether a fence is fired, call:
>>>   + fence_is_signaled()
>>>
>>> The dma-buf-mgr handles tracking, and waiting on, the fences associated
>>> with a dma-buf.
>>>
>>> The one pending on the fence can add an async callback:
>>>   + fence_add_callback()
>>>
>>> The callback can optionally be cancelled with:
>>>   + fence_remove_callback()
>>>
>>> To wait synchronously, optionally with a timeout:
>>>   + fence_wait()
>>>   + fence_wait_timeout()
>>>
>>> When emitting a fence, call:
>>>   + trace_fence_emit()
>>>
>>> To annotate that a fence is blocking on another fence, call:
>>>   + trace_fence_annotate_wait_on(fence, on_fence)
>>>
>>> A default software-only implementation is provided, which can be used
>>> by drivers attaching a fence to a buffer when they have no other means
>>> for hw sync.  But a memory backed fence is also envisioned, because it
>>> is common that GPU's can write to, or poll on some memory location for
>>> synchronization.  For example:
>>>
>>>   fence = custom_get_fence(...);
>>>   if ((seqno_fence = to_seqno_fence(fence)) != NULL) {
>>>     dma_buf *fence_buf = seqno_fence->sync_buf;
>>>     get_dma_buf(fence_buf);
>>>
>>>     ... tell the hw the memory location to wait ...
>>>     custom_wait_on(fence_buf, seqno_fence->seqno_ofs, fence->seqno);
>>>   } else {
>>>     /* fall-back to sw sync * /
>>>     fence_add_callback(fence, my_cb);
>>>   }
>>>
>>> On SoC platforms, if some other hw mechanism is provided for synchronizing
>>> between IP blocks, it could be supported as an alternate implementation
>>> with it's own fence ops in a similar way.
>>>
>>> enable_signaling callback is used to provide sw signaling in case a cpu
>>> waiter is requested or no compatible hardware signaling could be used.
>>>
>>> The intention is to provide a userspace interface (presumably via eventfd)
>>> later, to be used in conjunction with dma-buf's mmap support for sw access
>>> to buffers (or for userspace apps that would prefer to do their own
>>> synchronization).
>>>
>>> v1: Original
>>> v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
>>>     that dma-fence didn't need to care about the sw->hw signaling path
>>>     (it can be handled same as sw->sw case), and therefore the fence->ops
>>>     can be simplified and more handled in the core.  So remove the signal,
>>>     add_callback, cancel_callback, and wait ops, and replace with a simple
>>>     enable_signaling() op which can be used to inform a fence supporting
>>>     hw->hw signaling that one or more devices which do not support hw
>>>     signaling are waiting (and therefore it should enable an irq or do
>>>     whatever is necessary in order that the CPU is notified when the
>>>     fence is passed).
>>> v3: Fix locking fail in attach_fence() and get_fence()
>>> v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
>>>     we decided that we need to be able to attach one fence to N dma-buf's,
>>>     so using the list_head in dma-fence struct would be problematic.
>>> v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
>>> v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
>>>     about checking if fence fired or not. This is broken by design.
>>>     waitqueue_active during destruction is now fatal, since the signaller
>>>     should be holding a reference in enable_signalling until it signalled
>>>     the fence. Pass the original dma_fence_cb along, and call __remove_wait
>>>     in the dma_fence_callback handler, so that no cleanup needs to be
>>>     performed.
>>> v7: [ Maarten Lankhorst ] Set cb->func and only enable sw signaling if
>>>     fence wasn't signaled yet, for example for hardware fences that may
>>>     choose to signal blindly.
>>> v8: [ Maarten Lankhorst ] Tons of tiny fixes, moved __dma_fence_init to
>>>     header and fixed include mess. dma-fence.h now includes dma-buf.h
>>>     All members are now initialized, so kmalloc can be used for
>>>     allocating a dma-fence. More documentation added.
>>> v9: Change compiler bitfields to flags, change return type of
>>>     enable_signaling to bool. Rework dma_fence_wait. Added
>>>     dma_fence_is_signaled and dma_fence_wait_timeout.
>>>     s/dma// and change exports to non GPL. Added fence_is_signaled and
>>>     fence_enable_sw_signaling calls, add ability to override default
>>>     wait operation.
>>> v10: remove event_queue, use a custom list, export try_to_wake_up from
>>>     scheduler. Remove fence lock and use a global spinlock instead,
>>>     this should hopefully remove all the locking headaches I was having
>>>     on trying to implement this. enable_signaling is called with this
>>>     lock held.
>>> v11:
>>>     Use atomic ops for flags, lifting the need for some spin_lock_irqsaves.
>>>     However I kept the guarantee that after fence_signal returns, it is
>>>     guaranteed that enable_signaling has either been called to completion,
>>>     or will not be called any more.
>>>
>>>     Add contexts and seqno to base fence implementation. This allows you
>>>     to wait for less fences, by testing for seqno + signaled, and then only
>>>     wait on the later fence.
>>>
>>>     Add FENCE_TRACE, FENCE_WARN, and FENCE_ERR. This makes debugging easier.
>>>     An CONFIG_DEBUG_FENCE will be added to turn off the FENCE_TRACE
>>>     spam, and another runtime option can turn it off at runtime.
>>> v12:
>>>     Add CONFIG_FENCE_TRACE. Add missing documentation for the fence->context
>>>     and fence->seqno members.
>>> v13:
>>>     Fixup CONFIG_FENCE_TRACE kconfig description.
>>>     Move fence_context_alloc to fence.
>>>     Simplify fence_later.
>>>     Kill priv member to fence_cb.
>>> v14:
>>>     Remove priv argument from fence_add_callback, oops!
>>> v15:
>>>     Remove priv from documentation.
>>>     Explicitly include linux/atomic.h.
>>> v16:
>>>     Add trace events.
>>>     Import changes required by android syncpoints.
>>> v17:
>>>     Use wake_up_state instead of try_to_wake_up. (Colin Cross)
>>>     Fix up commit description for seqno_fence. (Rob Clark)
>>>
>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>> Signed-off-by: Thierry Reding <thierry.reding@gmail.com> #use smp_mb__before_atomic()
>>> Reviewed-by: Rob Clark <robdclark@gmail.com>
>>> ---
>>>  Documentation/DocBook/device-drivers.tmpl |    2
>>>  drivers/base/Kconfig                      |    9 +
>>>  drivers/base/Makefile                     |    2
>>>  drivers/base/fence.c                      |  416 +++++++++++++++++++++++++++++
>>>  include/linux/fence.h                     |  333 +++++++++++++++++++++++
>>>  include/trace/events/fence.h              |  128 +++++++++
>>>  6 files changed, 889 insertions(+), 1 deletion(-)
>>>  create mode 100644 drivers/base/fence.c
>>>  create mode 100644 include/linux/fence.h
>>>  create mode 100644 include/trace/events/fence.h
>>
>> Who is going to sign up to maintain this code?  (hint, it's not me...)
>
> that would be Sumit (dma-buf tree)..
>
> probably we should move fence/reservation/dma-buf into drivers/dma-buf
> (or something approximately like that)
Yes, that would be me - it might be better to create a new directory
as suggested above (drivers/dma-buf).
>
> BR,
> -R
>
>
>> thanks,
>>
>> greg k-h
Best regards,
~Sumit.


-- 
Thanks and regards,

Sumit Semwal
Graphics Engineer - Graphics working group
Linaro.org │ Open source software for ARM SoCs
