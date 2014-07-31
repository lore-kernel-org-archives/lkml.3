Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaGaPdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:33:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56811 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaGaPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:33:47 -0400
Subject: [PATCH 08/19] drm/nouveau: rework to new fence interface
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:33:33 +0200
Message-ID: <20140731153333.15061.76741.stgit@patser>
In-Reply-To: <20140731153245.15061.63023.stgit@patser>
References: <20140731153245.15061.63023.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@ubuntu.com>

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/core/core/event.c |    4 
 drivers/gpu/drm/nouveau/nouveau_bo.c      |    6 
 drivers/gpu/drm/nouveau/nouveau_display.c |    4 
 drivers/gpu/drm/nouveau/nouveau_fence.c   |  435 ++++++++++++++++++++---------
 drivers/gpu/drm/nouveau/nouveau_fence.h   |   20 +
 drivers/gpu/drm/nouveau/nouveau_gem.c     |   17 -
 drivers/gpu/drm/nouveau/nv04_fence.c      |    4 
 drivers/gpu/drm/nouveau/nv10_fence.c      |    4 
 drivers/gpu/drm/nouveau/nv17_fence.c      |    2 
 drivers/gpu/drm/nouveau/nv50_fence.c      |    2 
 drivers/gpu/drm/nouveau/nv84_fence.c      |   11 -
 11 files changed, 330 insertions(+), 179 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/core/event.c b/drivers/gpu/drm/nouveau/core/core/event.c
index ae81d3b5d8b7..5ddc28ec7660 100644
--- a/drivers/gpu/drm/nouveau/core/core/event.c
+++ b/drivers/gpu/drm/nouveau/core/core/event.c
@@ -139,14 +139,14 @@ nouveau_event_ref(struct nouveau_eventh *handler, struct nouveau_eventh **ref)
 void
 nouveau_event_trigger(struct nouveau_event *event, u32 types, int index)
 {
-	struct nouveau_eventh *handler;
+	struct nouveau_eventh *handler, *next;
 	unsigned long flags;
 
 	if (WARN_ON(index >= event->index_nr))
 		return;
 
 	spin_lock_irqsave(&event->list_lock, flags);
-	list_for_each_entry(handler, &event->list[index], head) {
+	list_for_each_entry_safe(handler, next, &event->list[index], head) {
 		if (!test_bit(NVKM_EVENT_ENABLE, &handler->flags))
 			continue;
 		if (!(handler->types & types))
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 2cf5b0572f66..6e71d3dc2d87 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -959,7 +959,7 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict, bool intr,
 	}
 
 	mutex_lock_nested(&chan->cli->mutex, SINGLE_DEPTH_NESTING);
-	ret = nouveau_fence_sync(bo->sync_obj, chan);
+	ret = nouveau_fence_sync(nouveau_bo(bo), chan);
 	if (ret == 0) {
 		ret = drm->ttm.move(chan, bo, &bo->mem, new_mem);
 		if (ret == 0) {
@@ -1432,10 +1432,12 @@ nouveau_bo_fence_unref(void **sync_obj)
 void
 nouveau_bo_fence(struct nouveau_bo *nvbo, struct nouveau_fence *fence)
 {
-	lockdep_assert_held(&nvbo->bo.resv->lock.base);
+	struct reservation_object *resv = nvbo->bo.resv;
 
 	nouveau_bo_fence_unref(&nvbo->bo.sync_obj);
 	nvbo->bo.sync_obj = nouveau_fence_ref(fence);
+
+	reservation_object_add_excl_fence(resv, &fence->base);
 }
 
 static void *
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 7928f8f07334..2c4798750b20 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -660,7 +660,7 @@ nouveau_page_flip_emit(struct nouveau_channel *chan,
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
 	/* Synchronize with the old framebuffer */
-	ret = nouveau_fence_sync(old_bo->bo.sync_obj, chan);
+	ret = nouveau_fence_sync(old_bo, chan);
 	if (ret)
 		goto fail;
 
@@ -721,7 +721,7 @@ nouveau_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		goto fail_unpin;
 
 	/* synchronise rendering channel with the kernel's channel */
-	ret = nouveau_fence_sync(new_bo->bo.sync_obj, chan);
+	ret = nouveau_fence_sync(new_bo, chan);
 	if (ret) {
 		ttm_bo_unreserve(&new_bo->bo);
 		goto fail_unpin;
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index ab5ea3b0d666..d24f8ce4341a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -32,91 +32,139 @@
 #include "nouveau_drm.h"
 #include "nouveau_dma.h"
 #include "nouveau_fence.h"
+#include <trace/events/fence.h>
 
 #include <engine/fifo.h>
 
-struct fence_work {
-	struct work_struct base;
-	struct list_head head;
-	void (*func)(void *);
-	void *data;
-};
+static const struct fence_ops nouveau_fence_ops_uevent;
+static const struct fence_ops nouveau_fence_ops_legacy;
 
 static void
 nouveau_fence_signal(struct nouveau_fence *fence)
 {
-	struct fence_work *work, *temp;
+	fence_signal_locked(&fence->base);
+	list_del(&fence->head);
+
+	if (fence->base.ops == &nouveau_fence_ops_uevent &&
+	    fence->event.head.next) {
+		struct nouveau_event *event;
 
-	list_for_each_entry_safe(work, temp, &fence->work, head) {
-		schedule_work(&work->base);
-		list_del(&work->head);
+		list_del(&fence->event.head);
+		fence->event.head.next = NULL;
+
+		event = container_of(fence->base.lock, typeof(*event), list_lock);
+		nouveau_event_put(&fence->event);
 	}
 
-	fence->channel = NULL;
-	list_del(&fence->head);
+	fence_put(&fence->base);
+}
+
+static struct nouveau_fence *
+nouveau_local_fence(struct fence *fence, struct nouveau_drm *drm) {
+	struct nouveau_fence_priv *priv = (void*)drm->fence;
+	struct nouveau_fence *f = container_of(fence,
+					       struct nouveau_fence,
+					       base);
+
+	if (fence->ops != &nouveau_fence_ops_legacy &&
+	    fence->ops != &nouveau_fence_ops_uevent)
+		return NULL;
+
+	if (fence->context < priv->context_base ||
+	    fence->context >= priv->context_base + priv->contexts)
+		return NULL;
+
+	return f;
 }
 
 void
 nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
 {
 	struct nouveau_fence *fence, *fnext;
-	spin_lock(&fctx->lock);
-	list_for_each_entry_safe(fence, fnext, &fctx->pending, head) {
+
+	spin_lock_irq(fctx->lock);
+	list_for_each_entry_safe(fence, fnext, &fctx->pending, head)
 		nouveau_fence_signal(fence);
-	}
-	spin_unlock(&fctx->lock);
+	spin_unlock_irq(fctx->lock);
 }
 
 void
-nouveau_fence_context_new(struct nouveau_fence_chan *fctx)
+nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_chan *fctx)
 {
+	struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);
+	struct nouveau_fifo_chan *fifo = (void*)chan->object;
+
+	fctx->lock = &pfifo->uevent->list_lock;
 	INIT_LIST_HEAD(&fctx->flip);
 	INIT_LIST_HEAD(&fctx->pending);
-	spin_lock_init(&fctx->lock);
+
+	snprintf(fctx->name, sizeof(fctx->name) - 1, "nouveau channel %i", fifo->chid);
 }
 
+struct nouveau_fence_work {
+	struct work_struct work;
+	struct fence_cb cb;
+	void (*func)(void *);
+	void *data;
+};
+
 static void
 nouveau_fence_work_handler(struct work_struct *kwork)
 {
-	struct fence_work *work = container_of(kwork, typeof(*work), base);
+	struct nouveau_fence_work *work = container_of(kwork, typeof(*work), work);
 	work->func(work->data);
 	kfree(work);
 }
 
+static void nouveau_fence_work_cb(struct fence *fence, struct fence_cb *cb)
+{
+	struct nouveau_fence_work *work = container_of(cb, typeof(*work), cb);
+
+	schedule_work(&work->work);
+}
+
+/*
+ * In an ideal world, read would not assume the channel context is still alive.
+ * This function may be called from another device, running into free memory as a
+ * result. The drm node should still be there, so we can derive the index from
+ * the fence context.
+ */
+static bool nouveau_fence_is_signaled(struct fence *f)
+{
+	struct nouveau_fence *fence = container_of(f, struct nouveau_fence, base);
+	struct nouveau_channel *chan = fence->channel;
+	struct nouveau_fence_chan *fctx = chan->fence;
+
+	return (int)(fctx->read(chan) - fence->base.seqno) >= 0;
+}
+
 void
 nouveau_fence_work(struct nouveau_fence *fence,
 		   void (*func)(void *), void *data)
 {
-	struct nouveau_channel *chan = fence->channel;
-	struct nouveau_fence_chan *fctx;
-	struct fence_work *work = NULL;
+	struct nouveau_fence_work *work;
 
-	if (nouveau_fence_done(fence)) {
-		func(data);
-		return;
-	}
+	if (fence_is_signaled(&fence->base))
+		goto err;
 
-	fctx = chan->fence;
 	work = kmalloc(sizeof(*work), GFP_KERNEL);
 	if (!work) {
 		WARN_ON(nouveau_fence_wait(fence, false, false));
-		func(data);
-		return;
+		goto err;
 	}
 
-	spin_lock(&fctx->lock);
-	if (!fence->channel) {
-		spin_unlock(&fctx->lock);
-		kfree(work);
-		func(data);
-		return;
-	}
-
-	INIT_WORK(&work->base, nouveau_fence_work_handler);
+	INIT_WORK(&work->work, nouveau_fence_work_handler);
 	work->func = func;
 	work->data = data;
-	list_add(&work->head, &fence->work);
-	spin_unlock(&fctx->lock);
+
+	if (fence_add_callback(&fence->base, &work->cb, nouveau_fence_work_cb) < 0)
+		goto err_free;
+	return;
+
+err_free:
+	kfree(work);
+err:
+	func(data);
 }
 
 static void
@@ -125,33 +173,45 @@ nouveau_fence_update(struct nouveau_channel *chan)
 	struct nouveau_fence_chan *fctx = chan->fence;
 	struct nouveau_fence *fence, *fnext;
 
-	spin_lock(&fctx->lock);
+	u32 seq = fctx->read(chan);
+
 	list_for_each_entry_safe(fence, fnext, &fctx->pending, head) {
-		if (fctx->read(chan) < fence->sequence)
+		if ((int)(seq - fence->base.seqno) < 0)
 			break;
 
 		nouveau_fence_signal(fence);
-		nouveau_fence_unref(&fence);
 	}
-	spin_unlock(&fctx->lock);
 }
 
 int
 nouveau_fence_emit(struct nouveau_fence *fence, struct nouveau_channel *chan)
 {
 	struct nouveau_fence_chan *fctx = chan->fence;
+	struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);
+	struct nouveau_fifo_chan *fifo = (void*)chan->object;
+	struct nouveau_fence_priv *priv = (void*)chan->drm->fence;
 	int ret;
 
 	fence->channel  = chan;
 	fence->timeout  = jiffies + (15 * HZ);
-	fence->sequence = ++fctx->sequence;
 
+	if (priv->uevent)
+		fence_init(&fence->base, &nouveau_fence_ops_uevent,
+			   &pfifo->uevent->list_lock,
+			   priv->context_base + fifo->chid, ++fctx->sequence);
+	else
+		fence_init(&fence->base, &nouveau_fence_ops_legacy,
+			   &pfifo->uevent->list_lock,
+			   priv->context_base + fifo->chid, ++fctx->sequence);
+
+	trace_fence_emit(&fence->base);
 	ret = fctx->emit(fence);
 	if (!ret) {
-		kref_get(&fence->kref);
-		spin_lock(&fctx->lock);
+		fence_get(&fence->base);
+		spin_lock_irq(fctx->lock);
+		nouveau_fence_update(chan);
 		list_add_tail(&fence->head, &fctx->pending);
-		spin_unlock(&fctx->lock);
+		spin_unlock_irq(fctx->lock);
 	}
 
 	return ret;
@@ -160,104 +220,71 @@ nouveau_fence_emit(struct nouveau_fence *fence, struct nouveau_channel *chan)
 bool
 nouveau_fence_done(struct nouveau_fence *fence)
 {
-	if (fence->channel)
+	if (fence->base.ops == &nouveau_fence_ops_legacy ||
+	    fence->base.ops == &nouveau_fence_ops_uevent) {
+		struct nouveau_fence_chan *fctx;
+		unsigned long flags;
+
+		if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
+			return true;
+
+		fctx = fence->channel->fence;
+		spin_lock_irqsave(fctx->lock, flags);
 		nouveau_fence_update(fence->channel);
-	return !fence->channel;
+		spin_unlock_irqrestore(fctx->lock, flags);
+	}
+	return fence_is_signaled(&fence->base);
 }
 
-static int
-nouveau_fence_wait_uevent_handler(void *data, u32 type, int index)
+static long
+nouveau_fence_wait_legacy(struct fence *f, bool intr, long wait)
 {
-	struct nouveau_fence_priv *priv = data;
-	wake_up_all(&priv->waiting);
-	return NVKM_EVENT_KEEP;
-}
+	struct nouveau_fence *fence = container_of(f, typeof(*fence), base);
+	unsigned long sleep_time = NSEC_PER_MSEC / 1000;
+	unsigned long t = jiffies, timeout = t + wait;
 
-static int
-nouveau_fence_wait_uevent(struct nouveau_fence *fence, bool intr)
+	while (!nouveau_fence_done(fence)) {
+		ktime_t kt;
 
-{
-	struct nouveau_channel *chan = fence->channel;
-	struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);
-	struct nouveau_fence_priv *priv = chan->drm->fence;
-	struct nouveau_eventh *handler;
-	int ret = 0;
+		t = jiffies;
 
-	ret = nouveau_event_new(pfifo->uevent, 1, 0,
-				nouveau_fence_wait_uevent_handler,
-				priv, &handler);
-	if (ret)
-		return ret;
+		if (wait != MAX_SCHEDULE_TIMEOUT && time_after_eq(t, timeout)) {
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		}
 
-	nouveau_event_get(handler);
+		__set_current_state(intr ? TASK_INTERRUPTIBLE :
+					   TASK_UNINTERRUPTIBLE);
 
-	if (fence->timeout) {
-		unsigned long timeout = fence->timeout - jiffies;
-
-		if (time_before(jiffies, fence->timeout)) {
-			if (intr) {
-				ret = wait_event_interruptible_timeout(
-						priv->waiting,
-						nouveau_fence_done(fence),
-						timeout);
-			} else {
-				ret = wait_event_timeout(priv->waiting,
-						nouveau_fence_done(fence),
-						timeout);
-			}
-		}
+		kt = ktime_set(0, sleep_time);
+		schedule_hrtimeout(&kt, HRTIMER_MODE_REL);
+		sleep_time *= 2;
+		if (sleep_time > NSEC_PER_MSEC)
+			sleep_time = NSEC_PER_MSEC;
 
-		if (ret >= 0) {
-			fence->timeout = jiffies + ret;
-			if (time_after_eq(jiffies, fence->timeout))
-				ret = -EBUSY;
-		}
-	} else {
-		if (intr) {
-			ret = wait_event_interruptible(priv->waiting,
-					nouveau_fence_done(fence));
-		} else {
-			wait_event(priv->waiting, nouveau_fence_done(fence));
-		}
+		if (intr && signal_pending(current))
+			return -ERESTARTSYS;
 	}
 
-	nouveau_event_ref(NULL, &handler);
-	if (unlikely(ret < 0))
-		return ret;
+	__set_current_state(TASK_RUNNING);
 
-	return 0;
+	return timeout - t;
 }
 
-int
-nouveau_fence_wait(struct nouveau_fence *fence, bool lazy, bool intr)
+static int
+nouveau_fence_wait_busy(struct nouveau_fence *fence, bool intr)
 {
-	struct nouveau_channel *chan = fence->channel;
-	struct nouveau_fence_priv *priv = chan ? chan->drm->fence : NULL;
-	unsigned long sleep_time = NSEC_PER_MSEC / 1000;
-	ktime_t t;
 	int ret = 0;
 
-	while (priv && priv->uevent && lazy && !nouveau_fence_done(fence)) {
-		ret = nouveau_fence_wait_uevent(fence, intr);
-		if (ret < 0)
-			return ret;
-	}
-
 	while (!nouveau_fence_done(fence)) {
-		if (fence->timeout && time_after_eq(jiffies, fence->timeout)) {
+		if (time_after_eq(jiffies, fence->timeout)) {
 			ret = -EBUSY;
 			break;
 		}
 
-		__set_current_state(intr ? TASK_INTERRUPTIBLE :
-					   TASK_UNINTERRUPTIBLE);
-		if (lazy) {
-			t = ktime_set(0, sleep_time);
-			schedule_hrtimeout(&t, HRTIMER_MODE_REL);
-			sleep_time *= 2;
-			if (sleep_time > NSEC_PER_MSEC)
-				sleep_time = NSEC_PER_MSEC;
-		}
+		__set_current_state(intr ?
+				    TASK_INTERRUPTIBLE :
+				    TASK_UNINTERRUPTIBLE);
 
 		if (intr && signal_pending(current)) {
 			ret = -ERESTARTSYS;
@@ -270,36 +297,79 @@ nouveau_fence_wait(struct nouveau_fence *fence, bool lazy, bool intr)
 }
 
 int
-nouveau_fence_sync(struct nouveau_fence *fence, struct nouveau_channel *chan)
+nouveau_fence_wait(struct nouveau_fence *fence, bool lazy, bool intr)
+{
+	long ret;
+
+	if (!lazy)
+		return nouveau_fence_wait_busy(fence, intr);
+
+	ret = fence_wait_timeout(&fence->base, intr, 15 * HZ);
+	if (ret < 0)
+		return ret;
+	else if (!ret)
+		return -EBUSY;
+	else
+		return 0;
+}
+
+int
+nouveau_fence_sync(struct nouveau_bo *nvbo, struct nouveau_channel *chan)
 {
 	struct nouveau_fence_chan *fctx = chan->fence;
-	struct nouveau_channel *prev;
-	int ret = 0;
+	struct fence *fence = NULL;
+	struct reservation_object *resv = nvbo->bo.resv;
+	struct reservation_object_list *fobj;
+	int ret = 0, i;
+
+	fence = nvbo->bo.sync_obj;
+	if (fence && fence_is_signaled(fence)) {
+		nouveau_fence_unref((struct nouveau_fence **)
+				    &nvbo->bo.sync_obj);
+		fence = NULL;
+	}
+
+	if (fence) {
+		struct nouveau_fence *f = container_of(fence,
+						       struct nouveau_fence,
+						       base);
+		struct nouveau_channel *prev = f->channel;
 
-	prev = fence ? fence->channel : NULL;
-	if (prev) {
-		if (unlikely(prev != chan && !nouveau_fence_done(fence))) {
-			ret = fctx->sync(fence, prev, chan);
+		if (prev != chan) {
+			ret = fctx->sync(f, prev, chan);
 			if (unlikely(ret))
-				ret = nouveau_fence_wait(fence, true, false);
+				ret = nouveau_fence_wait(f, true, true);
 		}
 	}
 
-	return ret;
-}
+	if (ret)
+		return ret;
 
-static void
-nouveau_fence_del(struct kref *kref)
-{
-	struct nouveau_fence *fence = container_of(kref, typeof(*fence), kref);
-	kfree(fence);
+	fence = reservation_object_get_excl(resv);
+	if (fence && !nouveau_local_fence(fence, chan->drm))
+		ret = fence_wait(fence, true);
+
+	fobj = reservation_object_get_list(resv);
+	if (!fobj || ret)
+		return ret;
+
+	for (i = 0; i < fobj->shared_count && !ret; ++i) {
+		fence = rcu_dereference_protected(fobj->shared[i],
+						reservation_object_held(resv));
+
+		/* should always be true, for now */
+		if (!nouveau_local_fence(fence, chan->drm))
+			ret = fence_wait(fence, true);
+	}
+
+	return ret;
 }
 
 void
 nouveau_fence_unref(struct nouveau_fence **pfence)
 {
 	if (*pfence)
-		kref_put(&(*pfence)->kref, nouveau_fence_del);
+		fence_put(&(*pfence)->base);
 	*pfence = NULL;
 }
 
@@ -307,7 +377,7 @@ struct nouveau_fence *
 nouveau_fence_ref(struct nouveau_fence *fence)
 {
 	if (fence)
-		kref_get(&fence->kref);
+		fence_get(&fence->base);
 	return fence;
 }
 
@@ -325,9 +395,7 @@ nouveau_fence_new(struct nouveau_channel *chan, bool sysmem,
 	if (!fence)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&fence->work);
 	fence->sysmem = sysmem;
-	kref_init(&fence->kref);
 
 	ret = nouveau_fence_emit(fence, chan);
 	if (ret)
@@ -336,3 +404,86 @@ nouveau_fence_new(struct nouveau_channel *chan, bool sysmem,
 	*pfence = fence;
 	return ret;
 }
+
+
+static bool nouveau_fence_no_signaling(struct fence *f)
+{
+	/*
+	 * This needs uevents to work correctly, but fence_add_callback relies on
+	 * being able to enable signaling. It will still get signaled eventually,
+	 * just not right away.
+	 */
+	if (nouveau_fence_is_signaled(f))
+		return false;
+
+	return true;
+}
+
+static const char *nouveau_fence_get_get_driver_name(struct fence *fence)
+{
+	return "nouveau";
+}
+
+static const char *nouveau_fence_get_timeline_name(struct fence *f)
+{
+	struct nouveau_fence *fence =
+		container_of(f, struct nouveau_fence, base);
+	struct nouveau_fence_chan *fctx = fence->channel->fence;
+
+	return fctx ? fctx->name : "dead channel";
+}
+
+static const struct fence_ops nouveau_fence_ops_legacy = {
+	.get_driver_name = nouveau_fence_get_get_driver_name,
+	.get_timeline_name = nouveau_fence_get_timeline_name,
+	.enable_signaling = nouveau_fence_no_signaling,
+	.signaled = nouveau_fence_is_signaled,
+	.wait = nouveau_fence_wait_legacy,
+	.release = NULL
+};
+
+static int
+nouveau_fence_wait_uevent_handler(void *priv, u32 types, int index)
+{
+	struct nouveau_fence *fence = priv;
+
+	if (nouveau_fence_is_signaled(&fence->base))
+		nouveau_fence_signal(fence);
+
+	/*
+	 * NVKM_EVENT_DROP is never appropriate here, nouveau_fence_signal
+	 * will unlink and free the event if needed.
+	 */
+	return NVKM_EVENT_KEEP;
+}
+
+static bool nouveau_fence_enable_signaling(struct fence *f)
+{
+	struct nouveau_fence *fence = container_of(f, struct nouveau_fence, base);
+	struct nouveau_event *event = container_of(f->lock, struct nouveau_event, list_lock);
+	struct nouveau_eventh *handler = &fence->event;
+
+	handler->event = event;
+	handler->func = nouveau_fence_wait_uevent_handler;
+	handler->priv = fence;
+	handler->types = 1;
+
+	nouveau_event_get(handler);
+	if (nouveau_fence_is_signaled(f)) {
+		nouveau_event_put(handler);
+		return false;
+	}
+
+	list_add_tail(&handler->head, &event->list[0]);
+
+	return true;
+}
+
+static const struct fence_ops nouveau_fence_ops_uevent = {
+	.get_driver_name = nouveau_fence_get_get_driver_name,
+	.get_timeline_name = nouveau_fence_get_timeline_name,
+	.enable_signaling = nouveau_fence_enable_signaling,
+	.signaled = nouveau_fence_is_signaled,
+	.wait = fence_default_wait,
+	.release = NULL
+};
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.h b/drivers/gpu/drm/nouveau/nouveau_fence.h
index c57bb61da58c..1989ec22e66e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -1,18 +1,21 @@
 #ifndef __NOUVEAU_FENCE_H__
 #define __NOUVEAU_FENCE_H__
 
+#include <linux/fence.h>
+
 struct nouveau_drm;
+struct nouveau_bo;
 
 struct nouveau_fence {
+	struct fence base;
+
 	struct list_head head;
-	struct list_head work;
-	struct kref kref;
+	struct nouveau_eventh event;
 
 	bool sysmem;
 
 	struct nouveau_channel *channel;
 	unsigned long timeout;
-	u32 sequence;
 };
 
 int  nouveau_fence_new(struct nouveau_channel *, bool sysmem,
@@ -25,7 +28,7 @@ int  nouveau_fence_emit(struct nouveau_fence *, struct nouveau_channel *);
 bool nouveau_fence_done(struct nouveau_fence *);
 void nouveau_fence_work(struct nouveau_fence *, void (*)(void *), void *);
 int  nouveau_fence_wait(struct nouveau_fence *, bool lazy, bool intr);
-int  nouveau_fence_sync(struct nouveau_fence *, struct nouveau_channel *);
+int  nouveau_fence_sync(struct nouveau_bo *, struct nouveau_channel *);
 
 struct nouveau_fence_chan {
 	struct list_head pending;
@@ -38,8 +41,10 @@ struct nouveau_fence_chan {
 	int  (*emit32)(struct nouveau_channel *, u64, u32);
 	int  (*sync32)(struct nouveau_channel *, u64, u32);
 
-	spinlock_t lock;
+	spinlock_t *lock;
 	u32 sequence;
+	u32 context;
+	char name[24];
 };
 
 struct nouveau_fence_priv {
@@ -49,13 +54,14 @@ struct nouveau_fence_priv {
 	int  (*context_new)(struct nouveau_channel *);
 	void (*context_del)(struct nouveau_channel *);
 
-	wait_queue_head_t waiting;
 	bool uevent;
+
+	u32 contexts, context_base;
 };
 
 #define nouveau_fence(drm) ((struct nouveau_fence_priv *)(drm)->fence)
 
-void nouveau_fence_context_new(struct nouveau_fence_chan *);
+void nouveau_fence_context_new(struct nouveau_channel *, struct nouveau_fence_chan *);
 void nouveau_fence_context_del(struct nouveau_fence_chan *);
 
 int nv04_fence_create(struct nouveau_drm *);
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 474f67238cef..2bd62f4ecf6a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -428,18 +428,6 @@ retry:
 }
 
 static int
-validate_sync(struct nouveau_channel *chan, struct nouveau_bo *nvbo)
-{
-	struct nouveau_fence *fence = nvbo->bo.sync_obj;
-	int ret = 0;
-
-	if (fence)
-		ret = nouveau_fence_sync(fence, chan);
-
-	return ret;
-}
-
-static int
 validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
 	      struct list_head *list, struct drm_nouveau_gem_pushbuf_bo *pbbo,
 	      uint64_t user_pbbo_ptr)
@@ -468,9 +456,10 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
 			return ret;
 		}
 
-		ret = validate_sync(chan, nvbo);
+		ret = nouveau_fence_sync(nvbo, chan);
 		if (unlikely(ret)) {
-			NV_ERROR(cli, "fail post-validate sync\n");
+			if (ret != -ERESTARTSYS)
+				NV_ERROR(cli, "fail post-validate sync\n");
 			return ret;
 		}
 
diff --git a/drivers/gpu/drm/nouveau/nv04_fence.c b/drivers/gpu/drm/nouveau/nv04_fence.c
index 94eadd1dd10a..997c54122ed9 100644
--- a/drivers/gpu/drm/nouveau/nv04_fence.c
+++ b/drivers/gpu/drm/nouveau/nv04_fence.c
@@ -43,7 +43,7 @@ nv04_fence_emit(struct nouveau_fence *fence)
 	int ret = RING_SPACE(chan, 2);
 	if (ret == 0) {
 		BEGIN_NV04(chan, NvSubSw, 0x0150, 1);
-		OUT_RING  (chan, fence->sequence);
+		OUT_RING  (chan, fence->base.seqno);
 		FIRE_RING (chan);
 	}
 	return ret;
@@ -77,7 +77,7 @@ nv04_fence_context_new(struct nouveau_channel *chan)
 {
 	struct nv04_fence_chan *fctx = kzalloc(sizeof(*fctx), GFP_KERNEL);
 	if (fctx) {
-		nouveau_fence_context_new(&fctx->base);
+		nouveau_fence_context_new(chan, &fctx->base);
 		fctx->base.emit = nv04_fence_emit;
 		fctx->base.sync = nv04_fence_sync;
 		fctx->base.read = nv04_fence_read;
diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
index 06f434f03fba..e8f73f7f31ef 100644
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -36,7 +36,7 @@ nv10_fence_emit(struct nouveau_fence *fence)
 	int ret = RING_SPACE(chan, 2);
 	if (ret == 0) {
 		BEGIN_NV04(chan, 0, NV10_SUBCHAN_REF_CNT, 1);
-		OUT_RING  (chan, fence->sequence);
+		OUT_RING  (chan, fence->base.seqno);
 		FIRE_RING (chan);
 	}
 	return ret;
@@ -74,7 +74,7 @@ nv10_fence_context_new(struct nouveau_channel *chan)
 	if (!fctx)
 		return -ENOMEM;
 
-	nouveau_fence_context_new(&fctx->base);
+	nouveau_fence_context_new(chan, &fctx->base);
 	fctx->base.emit = nv10_fence_emit;
 	fctx->base.read = nv10_fence_read;
 	fctx->base.sync = nv10_fence_sync;
diff --git a/drivers/gpu/drm/nouveau/nv17_fence.c b/drivers/gpu/drm/nouveau/nv17_fence.c
index 22aa9963ea6f..e404bab31e9d 100644
--- a/drivers/gpu/drm/nouveau/nv17_fence.c
+++ b/drivers/gpu/drm/nouveau/nv17_fence.c
@@ -83,7 +83,7 @@ nv17_fence_context_new(struct nouveau_channel *chan)
 	if (!fctx)
 		return -ENOMEM;
 
-	nouveau_fence_context_new(&fctx->base);
+	nouveau_fence_context_new(chan, &fctx->base);
 	fctx->base.emit = nv10_fence_emit;
 	fctx->base.read = nv10_fence_read;
 	fctx->base.sync = nv17_fence_sync;
diff --git a/drivers/gpu/drm/nouveau/nv50_fence.c b/drivers/gpu/drm/nouveau/nv50_fence.c
index 0ee363840035..19f6fccb84a1 100644
--- a/drivers/gpu/drm/nouveau/nv50_fence.c
+++ b/drivers/gpu/drm/nouveau/nv50_fence.c
@@ -47,7 +47,7 @@ nv50_fence_context_new(struct nouveau_channel *chan)
 	if (!fctx)
 		return -ENOMEM;
 
-	nouveau_fence_context_new(&fctx->base);
+	nouveau_fence_context_new(chan, &fctx->base);
 	fctx->base.emit = nv10_fence_emit;
 	fctx->base.read = nv10_fence_read;
 	fctx->base.sync = nv17_fence_sync;
diff --git a/drivers/gpu/drm/nouveau/nv84_fence.c b/drivers/gpu/drm/nouveau/nv84_fence.c
index 9fd475c89820..8a06727b23d1 100644
--- a/drivers/gpu/drm/nouveau/nv84_fence.c
+++ b/drivers/gpu/drm/nouveau/nv84_fence.c
@@ -89,7 +89,7 @@ nv84_fence_emit(struct nouveau_fence *fence)
 	else
 		addr += fctx->vma.offset;
 
-	return fctx->base.emit32(chan, addr, fence->sequence);
+	return fctx->base.emit32(chan, addr, fence->base.seqno);
 }
 
 static int
@@ -105,7 +105,7 @@ nv84_fence_sync(struct nouveau_fence *fence,
 	else
 		addr += fctx->vma.offset;
 
-	return fctx->base.sync32(chan, addr, fence->sequence);
+	return fctx->base.sync32(chan, addr, fence->base.seqno);
 }
 
 static u32
@@ -149,12 +149,14 @@ nv84_fence_context_new(struct nouveau_channel *chan)
 	if (!fctx)
 		return -ENOMEM;
 
-	nouveau_fence_context_new(&fctx->base);
+	nouveau_fence_context_new(chan, &fctx->base);
 	fctx->base.emit = nv84_fence_emit;
 	fctx->base.sync = nv84_fence_sync;
 	fctx->base.read = nv84_fence_read;
 	fctx->base.emit32 = nv84_fence_emit32;
 	fctx->base.sync32 = nv84_fence_sync32;
+	fctx->base.sequence = nv84_fence_read(chan);
+	fctx->base.context = priv->base.context_base + fifo->chid;
 
 	ret = nouveau_bo_vma_add(priv->bo, client->vm, &fctx->vma);
 	if (ret == 0) {
@@ -239,7 +241,8 @@ nv84_fence_create(struct nouveau_drm *drm)
 	priv->base.context_new = nv84_fence_context_new;
 	priv->base.context_del = nv84_fence_context_del;
 
-	init_waitqueue_head(&priv->base.waiting);
+	priv->base.contexts = pfifo->max + 1;
+	priv->base.context_base = fence_context_alloc(priv->base.contexts);
 	priv->base.uevent = true;
 
 	ret = nouveau_bo_new(drm->dev, 16 * (pfifo->max + 1), 0,

