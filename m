Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbaGAK55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:57:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60199 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbaGAK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:57:50 -0400
Subject: [PATCH v2 2/9] fence: dma-buf cross-device synchronization (v18)
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:14 +0200
Message-ID: <20140701105714.12718.76942.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fence can be attached to a buffer which is being filled or consumed
by hw, to allow userspace to pass the buffer without waiting to another
device.  For example, userspace can call page_flip ioctl to display the
next frame of graphics after kicking the GPU but while the GPU is still
rendering.  The display device sharing the buffer with the GPU would
attach a callback to get notified when the GPU's rendering-complete IRQ
fires, to update the scan-out address of the display, without having to
wake up userspace.

A driver must allocate a fence context for each execution ring that can
run in parallel. The function for this takes an argument with how many
contexts to allocate:
  + fence_context_alloc()

A fence is transient, one-shot deal.  It is allocated and attached
to one or more dma-buf's.  When the one that attached it is done, with
the pending operation, it can signal the fence:
  + fence_signal()

To have a rough approximation whether a fence is fired, call:
  + fence_is_signaled()

The dma-buf-mgr handles tracking, and waiting on, the fences associated
with a dma-buf.

The one pending on the fence can add an async callback:
  + fence_add_callback()

The callback can optionally be cancelled with:
  + fence_remove_callback()

To wait synchronously, optionally with a timeout:
  + fence_wait()
  + fence_wait_timeout()

When emitting a fence, call:
  + trace_fence_emit()

To annotate that a fence is blocking on another fence, call:
  + trace_fence_annotate_wait_on(fence, on_fence)

A default software-only implementation is provided, which can be used
by drivers attaching a fence to a buffer when they have no other means
for hw sync.  But a memory backed fence is also envisioned, because it
is common that GPU's can write to, or poll on some memory location for
synchronization.  For example:

  fence = custom_get_fence(...);
  if ((seqno_fence = to_seqno_fence(fence)) != NULL) {
    dma_buf *fence_buf = seqno_fence->sync_buf;
    get_dma_buf(fence_buf);

    ... tell the hw the memory location to wait ...
    custom_wait_on(fence_buf, seqno_fence->seqno_ofs, fence->seqno);
  } else {
    /* fall-back to sw sync * /
    fence_add_callback(fence, my_cb);
  }

On SoC platforms, if some other hw mechanism is provided for synchronizing
between IP blocks, it could be supported as an alternate implementation
with it's own fence ops in a similar way.

enable_signaling callback is used to provide sw signaling in case a cpu
waiter is requested or no compatible hardware signaling could be used.

The intention is to provide a userspace interface (presumably via eventfd)
later, to be used in conjunction with dma-buf's mmap support for sw access
to buffers (or for userspace apps that would prefer to do their own
synchronization).

v1: Original
v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
    that dma-fence didn't need to care about the sw->hw signaling path
    (it can be handled same as sw->sw case), and therefore the fence->ops
    can be simplified and more handled in the core.  So remove the signal,
    add_callback, cancel_callback, and wait ops, and replace with a simple
    enable_signaling() op which can be used to inform a fence supporting
    hw->hw signaling that one or more devices which do not support hw
    signaling are waiting (and therefore it should enable an irq or do
    whatever is necessary in order that the CPU is notified when the
    fence is passed).
v3: Fix locking fail in attach_fence() and get_fence()
v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
    we decided that we need to be able to attach one fence to N dma-buf's,
    so using the list_head in dma-fence struct would be problematic.
v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
    about checking if fence fired or not. This is broken by design.
    waitqueue_active during destruction is now fatal, since the signaller
    should be holding a reference in enable_signalling until it signalled
    the fence. Pass the original dma_fence_cb along, and call __remove_wait
    in the dma_fence_callback handler, so that no cleanup needs to be
    performed.
v7: [ Maarten Lankhorst ] Set cb->func and only enable sw signaling if
    fence wasn't signaled yet, for example for hardware fences that may
    choose to signal blindly.
v8: [ Maarten Lankhorst ] Tons of tiny fixes, moved __dma_fence_init to
    header and fixed include mess. dma-fence.h now includes dma-buf.h
    All members are now initialized, so kmalloc can be used for
    allocating a dma-fence. More documentation added.
v9: Change compiler bitfields to flags, change return type of
    enable_signaling to bool. Rework dma_fence_wait. Added
    dma_fence_is_signaled and dma_fence_wait_timeout.
    s/dma// and change exports to non GPL. Added fence_is_signaled and
    fence_enable_sw_signaling calls, add ability to override default
    wait operation.
v10: remove event_queue, use a custom list, export try_to_wake_up from
    scheduler. Remove fence lock and use a global spinlock instead,
    this should hopefully remove all the locking headaches I was having
    on trying to implement this. enable_signaling is called with this
    lock held.
v11:
    Use atomic ops for flags, lifting the need for some spin_lock_irqsaves.
    However I kept the guarantee that after fence_signal returns, it is
    guaranteed that enable_signaling has either been called to completion,
    or will not be called any more.

    Add contexts and seqno to base fence implementation. This allows you
    to wait for less fences, by testing for seqno + signaled, and then only
    wait on the later fence.

    Add FENCE_TRACE, FENCE_WARN, and FENCE_ERR. This makes debugging easier.
    An CONFIG_DEBUG_FENCE will be added to turn off the FENCE_TRACE
    spam, and another runtime option can turn it off at runtime.
v12:
    Add CONFIG_FENCE_TRACE. Add missing documentation for the fence->context
    and fence->seqno members.
v13:
    Fixup CONFIG_FENCE_TRACE kconfig description.
    Move fence_context_alloc to fence.
    Simplify fence_later.
    Kill priv member to fence_cb.
v14:
    Remove priv argument from fence_add_callback, oops!
v15:
    Remove priv from documentation.
    Explicitly include linux/atomic.h.
v16:
    Add trace events.
    Import changes required by android syncpoints.
v17:
    Use wake_up_state instead of try_to_wake_up. (Colin Cross)
    Fix up commit description for seqno_fence. (Rob Clark)
v18:
    Rename release_fence to fence_release.
    Move to drivers/dma-buf/.
    Rename __fence_is_signaled and __fence_signal to *_locked.
    Rename __fence_init to fence_init.
    Make fence_default_wait return a signed long, and fix wait ops too.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com> #use smp_mb__before_atomic()
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 Documentation/DocBook/device-drivers.tmpl |    2 
 MAINTAINERS                               |    2 
 drivers/base/Kconfig                      |    9 +
 drivers/dma-buf/Makefile                  |    2 
 drivers/dma-buf/fence.c                   |  431 +++++++++++++++++++++++++++++
 include/linux/fence.h                     |  343 +++++++++++++++++++++++
 include/trace/events/fence.h              |  128 +++++++++
 7 files changed, 915 insertions(+), 2 deletions(-)
 create mode 100644 drivers/dma-buf/fence.c
 create mode 100644 include/linux/fence.h
 create mode 100644 include/trace/events/fence.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index ac61ebd92875..e634657efb52 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -129,6 +129,8 @@ X!Edrivers/base/interface.c
      </sect1>
      <sect1><title>Device Drivers DMA Management</title>
 !Edrivers/dma-buf/dma-buf.c
+!Edrivers/dma-buf/fence.c
+!Iinclude/linux/fence.h
 !Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/MAINTAINERS b/MAINTAINERS
index c948e53a4ee6..ebc1ebf6f542 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2883,7 +2883,7 @@ L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
 F:	drivers/dma-buf/
-F:	include/linux/dma-buf* include/linux/reservation.h
+F:	include/linux/dma-buf* include/linux/reservation.h include/linux/fence.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 23b8726962af..00e13ce5cbbd 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -208,6 +208,15 @@ config DMA_SHARED_BUFFER
 	  APIs extension; the file's descriptor can then be passed on to other
 	  driver.
 
+config FENCE_TRACE
+	bool "Enable verbose FENCE_TRACE messages"
+	depends on DMA_SHARED_BUFFER
+	help
+	  Enable the FENCE_TRACE printks. This will add extra
+	  spam to the console log, but will make it easier to diagnose
+	  lockup related problems for dma-buffers shared across multiple
+	  devices.
+
 config DMA_CMA
 	bool "DMA Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && CMA
diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index 4a4f4c9bacd0..d7825bfe630e 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -1 +1 @@
-obj-y := dma-buf.o reservation.o
+obj-y := dma-buf.o fence.o reservation.o
diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
new file mode 100644
index 000000000000..948bf00d955e
--- /dev/null
+++ b/drivers/dma-buf/fence.c
@@ -0,0 +1,431 @@
+/*
+ * Fence mechanism for dma-buf and to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <robdclark@gmail.com>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/atomic.h>
+#include <linux/fence.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/fence.h>
+
+EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
+EXPORT_TRACEPOINT_SYMBOL(fence_emit);
+
+/**
+ * fence context counter: each execution context should have its own
+ * fence context, this allows checking if fences belong to the same
+ * context or not. One device can have multiple separate contexts,
+ * and they're used if some engine can run independently of another.
+ */
+static atomic_t fence_context_counter = ATOMIC_INIT(0);
+
+/**
+ * fence_context_alloc - allocate an array of fence contexts
+ * @num:	[in]	amount of contexts to allocate
+ *
+ * This function will return the first index of the number of fences allocated.
+ * The fence context is used for setting fence->context to a unique number.
+ */
+unsigned fence_context_alloc(unsigned num)
+{
+	BUG_ON(!num);
+	return atomic_add_return(num, &fence_context_counter) - num;
+}
+EXPORT_SYMBOL(fence_context_alloc);
+
+/**
+ * fence_signal_locked - signal completion of a fence
+ * @fence: the fence to signal
+ *
+ * Signal completion for software callbacks on a fence, this will unblock
+ * fence_wait() calls and run all the callbacks added with
+ * fence_add_callback(). Can be called multiple times, but since a fence
+ * can only go from unsignaled to signaled state, it will only be effective
+ * the first time.
+ *
+ * Unlike fence_signal, this function must be called with fence->lock held.
+ */
+int fence_signal_locked(struct fence *fence)
+{
+	struct fence_cb *cur, *tmp;
+	int ret = 0;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	if (!ktime_to_ns(fence->timestamp)) {
+		fence->timestamp = ktime_get();
+		smp_mb__before_atomic();
+	}
+
+	if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
+		ret = -EINVAL;
+
+		/*
+		 * we might have raced with the unlocked fence_signal,
+		 * still run through all callbacks
+		 */
+	} else
+		trace_fence_signaled(fence);
+
+	list_for_each_entry_safe(cur, tmp, &fence->cb_list, node) {
+		list_del_init(&cur->node);
+		cur->func(fence, cur);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(fence_signal_locked);
+
+/**
+ * fence_signal - signal completion of a fence
+ * @fence: the fence to signal
+ *
+ * Signal completion for software callbacks on a fence, this will unblock
+ * fence_wait() calls and run all the callbacks added with
+ * fence_add_callback(). Can be called multiple times, but since a fence
+ * can only go from unsignaled to signaled state, it will only be effective
+ * the first time.
+ */
+int fence_signal(struct fence *fence)
+{
+	unsigned long flags;
+
+	if (!fence)
+		return -EINVAL;
+
+	if (!ktime_to_ns(fence->timestamp)) {
+		fence->timestamp = ktime_get();
+		smp_mb__before_atomic();
+	}
+
+	if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return -EINVAL;
+
+	trace_fence_signaled(fence);
+
+	if (test_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags)) {
+		struct fence_cb *cur, *tmp;
+
+		spin_lock_irqsave(fence->lock, flags);
+		list_for_each_entry_safe(cur, tmp, &fence->cb_list, node) {
+			list_del_init(&cur->node);
+			cur->func(fence, cur);
+		}
+		spin_unlock_irqrestore(fence->lock, flags);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fence_signal);
+
+/**
+ * fence_wait_timeout - sleep until the fence gets signaled
+ * or until timeout elapses
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ *
+ * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
+ * remaining timeout in jiffies on success. Other error values may be
+ * returned on custom implementations.
+ *
+ * Performs a synchronous wait on this fence. It is assumed the caller
+ * directly or indirectly (buf-mgr between reservation and committing)
+ * holds a reference to the fence, otherwise the fence might be
+ * freed before return, resulting in undefined behavior.
+ */
+signed long
+fence_wait_timeout(struct fence *fence, bool intr, signed long timeout)
+{
+	signed long ret;
+
+	if (WARN_ON(timeout < 0))
+		return -EINVAL;
+
+	trace_fence_wait_start(fence);
+	ret = fence->ops->wait(fence, intr, timeout);
+	trace_fence_wait_end(fence);
+	return ret;
+}
+EXPORT_SYMBOL(fence_wait_timeout);
+
+void fence_release(struct kref *kref)
+{
+	struct fence *fence =
+			container_of(kref, struct fence, refcount);
+
+	trace_fence_destroy(fence);
+
+	BUG_ON(!list_empty(&fence->cb_list));
+
+	if (fence->ops->release)
+		fence->ops->release(fence);
+	else
+		fence_free(fence);
+}
+EXPORT_SYMBOL(fence_release);
+
+void fence_free(struct fence *fence)
+{
+	kfree(fence);
+}
+EXPORT_SYMBOL(fence_free);
+
+/**
+ * fence_enable_sw_signaling - enable signaling on fence
+ * @fence:	[in]	the fence to enable
+ *
+ * this will request for sw signaling to be enabled, to make the fence
+ * complete as soon as possible
+ */
+void fence_enable_sw_signaling(struct fence *fence)
+{
+	unsigned long flags;
+
+	if (!test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags) &&
+	    !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
+		trace_fence_enable_signal(fence);
+
+		spin_lock_irqsave(fence->lock, flags);
+
+		if (!fence->ops->enable_signaling(fence))
+			fence_signal_locked(fence);
+
+		spin_unlock_irqrestore(fence->lock, flags);
+	}
+}
+EXPORT_SYMBOL(fence_enable_sw_signaling);
+
+/**
+ * fence_add_callback - add a callback to be called when the fence
+ * is signaled
+ * @fence:	[in]	the fence to wait on
+ * @cb:		[in]	the callback to register
+ * @func:	[in]	the function to call
+ *
+ * cb will be initialized by fence_add_callback, no initialization
+ * by the caller is required. Any number of callbacks can be registered
+ * to a fence, but a callback can only be registered to one fence at a time.
+ *
+ * Note that the callback can be called from an atomic context.  If
+ * fence is already signaled, this function will return -ENOENT (and
+ * *not* call the callback)
+ *
+ * Add a software callback to the fence. Same restrictions apply to
+ * refcount as it does to fence_wait, however the caller doesn't need to
+ * keep a refcount to fence afterwards: when software access is enabled,
+ * the creator of the fence is required to keep the fence alive until
+ * after it signals with fence_signal. The callback itself can be called
+ * from irq context.
+ *
+ */
+int fence_add_callback(struct fence *fence, struct fence_cb *cb,
+		       fence_func_t func)
+{
+	unsigned long flags;
+	int ret = 0;
+	bool was_set;
+
+	if (WARN_ON(!fence || !func))
+		return -EINVAL;
+
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
+		INIT_LIST_HEAD(&cb->node);
+		return -ENOENT;
+	}
+
+	spin_lock_irqsave(fence->lock, flags);
+
+	was_set = test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags);
+
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		ret = -ENOENT;
+	else if (!was_set) {
+		trace_fence_enable_signal(fence);
+
+		if (!fence->ops->enable_signaling(fence)) {
+			fence_signal_locked(fence);
+			ret = -ENOENT;
+		}
+	}
+
+	if (!ret) {
+		cb->func = func;
+		list_add_tail(&cb->node, &fence->cb_list);
+	} else
+		INIT_LIST_HEAD(&cb->node);
+	spin_unlock_irqrestore(fence->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fence_add_callback);
+
+/**
+ * fence_remove_callback - remove a callback from the signaling list
+ * @fence:	[in]	the fence to wait on
+ * @cb:		[in]	the callback to remove
+ *
+ * Remove a previously queued callback from the fence. This function returns
+ * true if the callback is succesfully removed, or false if the fence has
+ * already been signaled.
+ *
+ * *WARNING*:
+ * Cancelling a callback should only be done if you really know what you're
+ * doing, since deadlocks and race conditions could occur all too easily. For
+ * this reason, it should only ever be done on hardware lockup recovery,
+ * with a reference held to the fence.
+ */
+bool
+fence_remove_callback(struct fence *fence, struct fence_cb *cb)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(fence->lock, flags);
+
+	ret = !list_empty(&cb->node);
+	if (ret)
+		list_del_init(&cb->node);
+
+	spin_unlock_irqrestore(fence->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fence_remove_callback);
+
+struct default_wait_cb {
+	struct fence_cb base;
+	struct task_struct *task;
+};
+
+static void
+fence_default_wait_cb(struct fence *fence, struct fence_cb *cb)
+{
+	struct default_wait_cb *wait =
+		container_of(cb, struct default_wait_cb, base);
+
+	wake_up_state(wait->task, TASK_NORMAL);
+}
+
+/**
+ * fence_default_wait - default sleep until the fence gets signaled
+ * or until timeout elapses
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ *
+ * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
+ * remaining timeout in jiffies on success.
+ */
+signed long
+fence_default_wait(struct fence *fence, bool intr, signed long timeout)
+{
+	struct default_wait_cb cb;
+	unsigned long flags;
+	signed long ret = timeout;
+	bool was_set;
+
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return timeout;
+
+	spin_lock_irqsave(fence->lock, flags);
+
+	if (intr && signal_pending(current)) {
+		ret = -ERESTARTSYS;
+		goto out;
+	}
+
+	was_set = test_and_set_bit(FENCE_FLAG_ENABLE_SIGNAL_BIT, &fence->flags);
+
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		goto out;
+
+	if (!was_set) {
+		trace_fence_enable_signal(fence);
+
+		if (!fence->ops->enable_signaling(fence)) {
+			fence_signal_locked(fence);
+			goto out;
+		}
+	}
+
+	cb.base.func = fence_default_wait_cb;
+	cb.task = current;
+	list_add(&cb.base.node, &fence->cb_list);
+
+	while (!test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
+		if (intr)
+			__set_current_state(TASK_INTERRUPTIBLE);
+		else
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock_irqrestore(fence->lock, flags);
+
+		ret = schedule_timeout(ret);
+
+		spin_lock_irqsave(fence->lock, flags);
+		if (ret > 0 && intr && signal_pending(current))
+			ret = -ERESTARTSYS;
+	}
+
+	if (!list_empty(&cb.base.node))
+		list_del(&cb.base.node);
+	__set_current_state(TASK_RUNNING);
+
+out:
+	spin_unlock_irqrestore(fence->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(fence_default_wait);
+
+/**
+ * fence_init - Initialize a custom fence.
+ * @fence:	[in]	the fence to initialize
+ * @ops:	[in]	the fence_ops for operations on this fence
+ * @lock:	[in]	the irqsafe spinlock to use for locking this fence
+ * @context:	[in]	the execution context this fence is run on
+ * @seqno:	[in]	a linear increasing sequence number for this context
+ *
+ * Initializes an allocated fence, the caller doesn't have to keep its
+ * refcount after committing with this fence, but it will need to hold a
+ * refcount again if fence_ops.enable_signaling gets called. This can
+ * be used for other implementing other types of fence.
+ *
+ * context and seqno are used for easy comparison between fences, allowing
+ * to check which fence is later by simply using fence_later.
+ */
+void
+fence_init(struct fence *fence, const struct fence_ops *ops,
+	     spinlock_t *lock, unsigned context, unsigned seqno)
+{
+	BUG_ON(!lock);
+	BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
+	       !ops->get_driver_name || !ops->get_timeline_name);
+
+	kref_init(&fence->refcount);
+	fence->ops = ops;
+	INIT_LIST_HEAD(&fence->cb_list);
+	fence->lock = lock;
+	fence->context = context;
+	fence->seqno = seqno;
+	fence->flags = 0UL;
+
+	trace_fence_init(fence);
+}
+EXPORT_SYMBOL(fence_init);
diff --git a/include/linux/fence.h b/include/linux/fence.h
new file mode 100644
index 000000000000..b935cc650123
--- /dev/null
+++ b/include/linux/fence.h
@@ -0,0 +1,343 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <robdclark@gmail.com>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __LINUX_FENCE_H
+#define __LINUX_FENCE_H
+
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <linux/kref.h>
+#include <linux/sched.h>
+#include <linux/printk.h>
+
+struct fence;
+struct fence_ops;
+struct fence_cb;
+
+/**
+ * struct fence - software synchronization primitive
+ * @refcount: refcount for this fence
+ * @ops: fence_ops associated with this fence
+ * @cb_list: list of all callbacks to call
+ * @lock: spin_lock_irqsave used for locking
+ * @context: execution context this fence belongs to, returned by
+ *           fence_context_alloc()
+ * @seqno: the sequence number of this fence inside the execution context,
+ * can be compared to decide which fence would be signaled later.
+ * @flags: A mask of FENCE_FLAG_* defined below
+ * @timestamp: Timestamp when the fence was signaled.
+ * @status: Optional, only valid if < 0, must be set before calling
+ * fence_signal, indicates that the fence has completed with an error.
+ *
+ * the flags member must be manipulated and read using the appropriate
+ * atomic ops (bit_*), so taking the spinlock will not be needed most
+ * of the time.
+ *
+ * FENCE_FLAG_SIGNALED_BIT - fence is already signaled
+ * FENCE_FLAG_ENABLE_SIGNAL_BIT - enable_signaling might have been called*
+ * FENCE_FLAG_USER_BITS - start of the unused bits, can be used by the
+ * implementer of the fence for its own purposes. Can be used in different
+ * ways by different fence implementers, so do not rely on this.
+ *
+ * *) Since atomic bitops are used, this is not guaranteed to be the case.
+ * Particularly, if the bit was set, but fence_signal was called right
+ * before this bit was set, it would have been able to set the
+ * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
+ * Adding a check for FENCE_FLAG_SIGNALED_BIT after setting
+ * FENCE_FLAG_ENABLE_SIGNAL_BIT closes this race, and makes sure that
+ * after fence_signal was called, any enable_signaling call will have either
+ * been completed, or never called at all.
+ */
+struct fence {
+	struct kref refcount;
+	const struct fence_ops *ops;
+	struct list_head cb_list;
+	spinlock_t *lock;
+	unsigned context, seqno;
+	unsigned long flags;
+	ktime_t timestamp;
+	int status;
+};
+
+enum fence_flag_bits {
+	FENCE_FLAG_SIGNALED_BIT,
+	FENCE_FLAG_ENABLE_SIGNAL_BIT,
+	FENCE_FLAG_USER_BITS, /* must always be last member */
+};
+
+typedef void (*fence_func_t)(struct fence *fence, struct fence_cb *cb);
+
+/**
+ * struct fence_cb - callback for fence_add_callback
+ * @node: used by fence_add_callback to append this struct to fence::cb_list
+ * @func: fence_func_t to call
+ *
+ * This struct will be initialized by fence_add_callback, additional
+ * data can be passed along by embedding fence_cb in another struct.
+ */
+struct fence_cb {
+	struct list_head node;
+	fence_func_t func;
+};
+
+/**
+ * struct fence_ops - operations implemented for fence
+ * @get_driver_name: returns the driver name.
+ * @get_timeline_name: return the name of the context this fence belongs to.
+ * @enable_signaling: enable software signaling of fence.
+ * @signaled: [optional] peek whether the fence is signaled, can be null.
+ * @wait: custom wait implementation, or fence_default_wait.
+ * @release: [optional] called on destruction of fence, can be null
+ * @fill_driver_data: [optional] callback to fill in free-form debug info
+ * Returns amount of bytes filled, or -errno.
+ * @fence_value_str: [optional] fills in the value of the fence as a string
+ * @timeline_value_str: [optional] fills in the current value of the timeline
+ * as a string
+ *
+ * Notes on enable_signaling:
+ * For fence implementations that have the capability for hw->hw
+ * signaling, they can implement this op to enable the necessary
+ * irqs, or insert commands into cmdstream, etc.  This is called
+ * in the first wait() or add_callback() path to let the fence
+ * implementation know that there is another driver waiting on
+ * the signal (ie. hw->sw case).
+ *
+ * This function can be called called from atomic context, but not
+ * from irq context, so normal spinlocks can be used.
+ *
+ * A return value of false indicates the fence already passed,
+ * or some failure occured that made it impossible to enable
+ * signaling. True indicates succesful enabling.
+ *
+ * fence->status may be set in enable_signaling, but only when false is
+ * returned.
+ *
+ * Calling fence_signal before enable_signaling is called allows
+ * for a tiny race window in which enable_signaling is called during,
+ * before, or after fence_signal. To fight this, it is recommended
+ * that before enable_signaling returns true an extra reference is
+ * taken on the fence, to be released when the fence is signaled.
+ * This will mean fence_signal will still be called twice, but
+ * the second time will be a noop since it was already signaled.
+ *
+ * Notes on signaled:
+ * May set fence->status if returning true.
+ *
+ * Notes on wait:
+ * Must not be NULL, set to fence_default_wait for default implementation.
+ * the fence_default_wait implementation should work for any fence, as long
+ * as enable_signaling works correctly.
+ *
+ * Must return -ERESTARTSYS if the wait is intr = true and the wait was
+ * interrupted, and remaining jiffies if fence has signaled, or 0 if wait
+ * timed out. Can also return other error values on custom implementations,
+ * which should be treated as if the fence is signaled. For example a hardware
+ * lockup could be reported like that.
+ *
+ * Notes on release:
+ * Can be NULL, this function allows additional commands to run on
+ * destruction of the fence. Can be called from irq context.
+ * If pointer is set to NULL, kfree will get called instead.
+ */
+
+struct fence_ops {
+	const char * (*get_driver_name)(struct fence *fence);
+	const char * (*get_timeline_name)(struct fence *fence);
+	bool (*enable_signaling)(struct fence *fence);
+	bool (*signaled)(struct fence *fence);
+	signed long (*wait)(struct fence *fence, bool intr, signed long timeout);
+	void (*release)(struct fence *fence);
+
+	int (*fill_driver_data)(struct fence *fence, void *data, int size);
+	void (*fence_value_str)(struct fence *fence, char *str, int size);
+	void (*timeline_value_str)(struct fence *fence, char *str, int size);
+};
+
+void fence_init(struct fence *fence, const struct fence_ops *ops,
+		spinlock_t *lock, unsigned context, unsigned seqno);
+
+void fence_release(struct kref *kref);
+void fence_free(struct fence *fence);
+
+/**
+ * fence_get - increases refcount of the fence
+ * @fence:	[in]	fence to increase refcount of
+ *
+ * Returns the same fence, with refcount increased by 1.
+ */
+static inline struct fence *fence_get(struct fence *fence)
+{
+	if (fence)
+		kref_get(&fence->refcount);
+	return fence;
+}
+
+/**
+ * fence_put - decreases refcount of the fence
+ * @fence:	[in]	fence to reduce refcount of
+ */
+static inline void fence_put(struct fence *fence)
+{
+	if (fence)
+		kref_put(&fence->refcount, fence_release);
+}
+
+int fence_signal(struct fence *fence);
+int fence_signal_locked(struct fence *fence);
+signed long fence_default_wait(struct fence *fence, bool intr, signed long timeout);
+int fence_add_callback(struct fence *fence, struct fence_cb *cb,
+		       fence_func_t func);
+bool fence_remove_callback(struct fence *fence, struct fence_cb *cb);
+void fence_enable_sw_signaling(struct fence *fence);
+
+/**
+ * fence_is_signaled_locked - Return an indication if the fence is signaled yet.
+ * @fence:	[in]	the fence to check
+ *
+ * Returns true if the fence was already signaled, false if not. Since this
+ * function doesn't enable signaling, it is not guaranteed to ever return
+ * true if fence_add_callback, fence_wait or fence_enable_sw_signaling
+ * haven't been called before.
+ *
+ * This function requires fence->lock to be held.
+ */
+static inline bool
+fence_is_signaled_locked(struct fence *fence)
+{
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return true;
+
+	if (fence->ops->signaled && fence->ops->signaled(fence)) {
+		fence_signal_locked(fence);
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * fence_is_signaled - Return an indication if the fence is signaled yet.
+ * @fence:	[in]	the fence to check
+ *
+ * Returns true if the fence was already signaled, false if not. Since this
+ * function doesn't enable signaling, it is not guaranteed to ever return
+ * true if fence_add_callback, fence_wait or fence_enable_sw_signaling
+ * haven't been called before.
+ *
+ * It's recommended for seqno fences to call fence_signal when the
+ * operation is complete, it makes it possible to prevent issues from
+ * wraparound between time of issue and time of use by checking the return
+ * value of this function before calling hardware-specific wait instructions.
+ */
+static inline bool
+fence_is_signaled(struct fence *fence)
+{
+	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return true;
+
+	if (fence->ops->signaled && fence->ops->signaled(fence)) {
+		fence_signal(fence);
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * fence_later - return the chronologically later fence
+ * @f1:	[in]	the first fence from the same context
+ * @f2:	[in]	the second fence from the same context
+ *
+ * Returns NULL if both fences are signaled, otherwise the fence that would be
+ * signaled last. Both fences must be from the same context, since a seqno is
+ * not re-used across contexts.
+ */
+static inline struct fence *fence_later(struct fence *f1, struct fence *f2)
+{
+	if (WARN_ON(f1->context != f2->context))
+		return NULL;
+
+	/*
+	 * can't check just FENCE_FLAG_SIGNALED_BIT here, it may never have been
+	 * set if enable_signaling wasn't called, and enabling that here is
+	 * overkill.
+	 */
+	if (f2->seqno - f1->seqno <= INT_MAX)
+		return fence_is_signaled(f2) ? NULL : f2;
+	else
+		return fence_is_signaled(f1) ? NULL : f1;
+}
+
+signed long fence_wait_timeout(struct fence *, bool intr, signed long timeout);
+
+
+/**
+ * fence_wait - sleep until the fence gets signaled
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ *
+ * This function will return -ERESTARTSYS if interrupted by a signal,
+ * or 0 if the fence was signaled. Other error values may be
+ * returned on custom implementations.
+ *
+ * Performs a synchronous wait on this fence. It is assumed the caller
+ * directly or indirectly holds a reference to the fence, otherwise the
+ * fence might be freed before return, resulting in undefined behavior.
+ */
+static inline signed long fence_wait(struct fence *fence, bool intr)
+{
+	signed long ret;
+
+	/* Since fence_wait_timeout cannot timeout with
+	 * MAX_SCHEDULE_TIMEOUT, only valid return values are
+	 * -ERESTARTSYS and MAX_SCHEDULE_TIMEOUT.
+	 */
+	ret = fence_wait_timeout(fence, intr, MAX_SCHEDULE_TIMEOUT);
+
+	return ret < 0 ? ret : 0;
+}
+
+unsigned fence_context_alloc(unsigned num);
+
+#define FENCE_TRACE(f, fmt, args...) \
+	do {								\
+		struct fence *__ff = (f);				\
+		if (config_enabled(CONFIG_FENCE_TRACE))			\
+			pr_info("f %u#%u: " fmt,			\
+				__ff->context, __ff->seqno, ##args);	\
+	} while (0)
+
+#define FENCE_WARN(f, fmt, args...) \
+	do {								\
+		struct fence *__ff = (f);				\
+		pr_warn("f %u#%u: " fmt, __ff->context, __ff->seqno,	\
+			 ##args);					\
+	} while (0)
+
+#define FENCE_ERR(f, fmt, args...) \
+	do {								\
+		struct fence *__ff = (f);				\
+		pr_err("f %u#%u: " fmt, __ff->context, __ff->seqno,	\
+			##args);					\
+	} while (0)
+
+#endif /* __LINUX_FENCE_H */
diff --git a/include/trace/events/fence.h b/include/trace/events/fence.h
new file mode 100644
index 000000000000..98feb1b82896
--- /dev/null
+++ b/include/trace/events/fence.h
@@ -0,0 +1,128 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fence
+
+#if !defined(_TRACE_FENCE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FENCE_H
+
+#include <linux/tracepoint.h>
+
+struct fence;
+
+TRACE_EVENT(fence_annotate_wait_on,
+
+	/* fence: the fence waiting on f1, f1: the fence to be waited on. */
+	TP_PROTO(struct fence *fence, struct fence *f1),
+
+	TP_ARGS(fence, f1),
+
+	TP_STRUCT__entry(
+		__string(driver, fence->ops->get_driver_name(fence))
+		__string(timeline, fence->ops->get_driver_name(fence))
+		__field(unsigned int, context)
+		__field(unsigned int, seqno)
+
+		__string(waiting_driver, f1->ops->get_driver_name(f1))
+		__string(waiting_timeline, f1->ops->get_timeline_name(f1))
+		__field(unsigned int, waiting_context)
+		__field(unsigned int, waiting_seqno)
+	),
+
+	TP_fast_assign(
+		__assign_str(driver, fence->ops->get_driver_name(fence))
+		__assign_str(timeline, fence->ops->get_timeline_name(fence))
+		__entry->context = fence->context;
+		__entry->seqno = fence->seqno;
+
+		__assign_str(waiting_driver, f1->ops->get_driver_name(f1))
+		__assign_str(waiting_timeline, f1->ops->get_timeline_name(f1))
+		__entry->waiting_context = f1->context;
+		__entry->waiting_seqno = f1->seqno;
+
+	),
+
+	TP_printk("driver=%s timeline=%s context=%u seqno=%u "	\
+		  "waits on driver=%s timeline=%s context=%u seqno=%u",
+		  __get_str(driver), __get_str(timeline), __entry->context,
+		  __entry->seqno,
+		  __get_str(waiting_driver), __get_str(waiting_timeline),
+		  __entry->waiting_context, __entry->waiting_seqno)
+);
+
+DECLARE_EVENT_CLASS(fence,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence),
+
+	TP_STRUCT__entry(
+		__string(driver, fence->ops->get_driver_name(fence))
+		__string(timeline, fence->ops->get_timeline_name(fence))
+		__field(unsigned int, context)
+		__field(unsigned int, seqno)
+	),
+
+	TP_fast_assign(
+		__assign_str(driver, fence->ops->get_driver_name(fence))
+		__assign_str(timeline, fence->ops->get_timeline_name(fence))
+		__entry->context = fence->context;
+		__entry->seqno = fence->seqno;
+	),
+
+	TP_printk("driver=%s timeline=%s context=%u seqno=%u",
+		  __get_str(driver), __get_str(timeline), __entry->context,
+		  __entry->seqno)
+);
+
+DEFINE_EVENT(fence, fence_emit,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_init,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_destroy,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_enable_signal,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_signaled,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_wait_start,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+DEFINE_EVENT(fence, fence_wait_end,
+
+	TP_PROTO(struct fence *fence),
+
+	TP_ARGS(fence)
+);
+
+#endif /*  _TRACE_FENCE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

