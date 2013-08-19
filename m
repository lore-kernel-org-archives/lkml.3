Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3HSKLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:11:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3HSKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:11:52 -0400
Message-ID: <5211EF65.9050207@canonical.com>
Date: Mon, 19 Aug 2013 12:11:49 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [RFC PATCH] drm/nouveau: rework to new fence interface
References: <20130815124308.14812.58197.stgit@patser>
In-Reply-To: <20130815124308.14812.58197.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nouveau was a bit tricky, it has no support for interrupts on <nv84, so I added
an extra call to nouveau_fence_update in nouveau_fence_emit to increase
the chance slightly that deferred work gets triggered.

This patch depends on the vblank locking fix for the definitions of
nouveau_event_enable_locked and nouveau_event_disable_locked.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index be31499..78714e4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -35,88 +35,115 @@
 
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
+	__fence_signal(&fence->base);
+	list_del(&fence->head);
 
-	list_for_each_entry_safe(work, temp, &fence->work, head) {
-		schedule_work(&work->base);
-		list_del(&work->head);
+	if (fence->base.ops == &nouveau_fence_ops_uevent &&
+	    fence->event.head.next) {
+		struct nouveau_event *event;
+
+		list_del(&fence->event.head);
+		fence->event.head.next = NULL;
+
+		event = container_of(fence->base.lock, typeof(*event), lock);
+		if (!--event->index[0].refs)
+			event->disable(event, 0);
 	}
 
-	fence->channel = NULL;
-	list_del(&fence->head);
+	fence_put(&fence->base);
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
+
+	fctx->lock = &pfifo->uevent->lock;
 	INIT_LIST_HEAD(&fctx->flip);
 	INIT_LIST_HEAD(&fctx->pending);
-	spin_lock_init(&fctx->lock);
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
-	}
-
-	spin_lock(&fctx->lock);
-	if (!fence->channel) {
-		spin_unlock(&fctx->lock);
-		kfree(work);
-		func(data);
-		return;
+		goto err;
 	}
 
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
@@ -125,33 +152,44 @@ nouveau_fence_update(struct nouveau_channel *chan)
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
 	fence->timeout  = jiffies + (15 * DRM_HZ);
-	fence->sequence = ++fctx->sequence;
+
+	if (priv->uevent)
+		__fence_init(&fence->base, &nouveau_fence_ops_uevent,
+			    &pfifo->uevent->lock,
+			    priv->context_base + fifo->chid, ++fctx->sequence);
+	else
+		__fence_init(&fence->base, &nouveau_fence_ops_legacy,
+			    &pfifo->uevent->lock,
+			    priv->context_base + fifo->chid, ++fctx->sequence);
 
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
@@ -160,107 +198,71 @@ nouveau_fence_emit(struct nouveau_fence *fence, struct nouveau_channel *chan)
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
 
-struct nouveau_fence_uevent {
-	struct nouveau_eventh handler;
-	struct nouveau_fence_priv *priv;
-};
-
-static int
-nouveau_fence_wait_uevent_handler(struct nouveau_eventh *event, int index)
+static long
+nouveau_fence_wait_legacy(struct fence *f, bool intr, long wait)
 {
-	struct nouveau_fence_uevent *uevent =
-		container_of(event, struct nouveau_fence_uevent, handler);
-	wake_up_all(&uevent->priv->waiting);
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
-	struct nouveau_fence_uevent uevent = {
-		.handler.func = nouveau_fence_wait_uevent_handler,
-		.priv = priv,
-	};
-	int ret = 0;
+		t = jiffies;
 
-	nouveau_event_get(pfifo->uevent, 0, &uevent.handler);
-
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
+		if (wait != MAX_SCHEDULE_TIMEOUT && time_after_eq(t, timeout)) {
+			__set_current_state(TASK_RUNNING);
+			return 0;
 		}
 
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
+		__set_current_state(intr ? TASK_INTERRUPTIBLE :
+					   TASK_UNINTERRUPTIBLE);
+
+		kt = ktime_set(0, sleep_time);
+		schedule_hrtimeout(&kt, HRTIMER_MODE_REL);
+		sleep_time *= 2;
+		if (sleep_time > NSEC_PER_MSEC)
+			sleep_time = NSEC_PER_MSEC;
+
+		if (intr && signal_pending(current))
+			return -ERESTARTSYS;
 	}
 
-	nouveau_event_put(pfifo->uevent, 0, &uevent.handler);
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
@@ -273,14 +275,31 @@ nouveau_fence_wait(struct nouveau_fence *fence, bool lazy, bool intr)
 }
 
 int
+nouveau_fence_wait(struct nouveau_fence *fence, bool lazy, bool intr)
+{
+	long ret;
+
+	if (!lazy)
+		return nouveau_fence_wait_busy(fence, intr);
+
+	ret = fence_wait_timeout(&fence->base, intr, 15 * DRM_HZ);
+	if (ret < 0)
+		return ret;
+	else if (!ret)
+		return -EBUSY;
+	else
+		return 0;
+}
+
+int
 nouveau_fence_sync(struct nouveau_fence *fence, struct nouveau_channel *chan)
 {
 	struct nouveau_fence_chan *fctx = chan->fence;
-	struct nouveau_channel *prev;
 	int ret = 0;
 
-	prev = fence ? fence->channel : NULL;
-	if (prev) {
+	if (fence) {
+		struct nouveau_channel *prev = fence->channel;
+
 		if (unlikely(prev != chan && !nouveau_fence_done(fence))) {
 			ret = fctx->sync(fence, prev, chan);
 			if (unlikely(ret))
@@ -291,25 +310,18 @@ nouveau_fence_sync(struct nouveau_fence *fence, struct nouveau_channel *chan)
 	return ret;
 }
 
-static void
-nouveau_fence_del(struct kref *kref)
-{
-	struct nouveau_fence *fence = container_of(kref, typeof(*fence), kref);
-	kfree(fence);
-}
-
 void
 nouveau_fence_unref(struct nouveau_fence **pfence)
 {
 	if (*pfence)
-		kref_put(&(*pfence)->kref, nouveau_fence_del);
+		fence_put(&(*pfence)->base);
 	*pfence = NULL;
 }
 
 struct nouveau_fence *
 nouveau_fence_ref(struct nouveau_fence *fence)
 {
-	kref_get(&fence->kref);
+	fence_get(&fence->base);
 	return fence;
 }
 
@@ -327,9 +339,7 @@ nouveau_fence_new(struct nouveau_channel *chan, bool sysmem,
 	if (!fence)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&fence->work);
 	fence->sysmem = sysmem;
-	kref_init(&fence->kref);
 
 	ret = nouveau_fence_emit(fence, chan);
 	if (ret)
@@ -338,3 +348,64 @@ nouveau_fence_new(struct nouveau_channel *chan, bool sysmem,
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
+static const struct fence_ops nouveau_fence_ops_legacy = {
+	.enable_signaling = nouveau_fence_no_signaling,
+	.signaled = nouveau_fence_is_signaled,
+	.wait = nouveau_fence_wait_legacy,
+	.release = NULL
+};
+
+static int
+nouveau_fence_wait_uevent_handler(struct nouveau_eventh *event, int index)
+{
+	struct nouveau_fence *fence =
+		container_of(event, struct nouveau_fence, event);
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
+	struct nouveau_event *event = container_of(f->lock, struct nouveau_event, lock);
+
+	nouveau_event_enable_locked(event, 0);
+	if (nouveau_fence_is_signaled(f)) {
+		nouveau_event_disable_locked(event, 0, 1);
+		return false;
+	}
+
+	list_add_tail(&fence->event.head, &event->index[0].list);
+	fence->event.func = nouveau_fence_wait_uevent_handler;
+
+	return true;
+}
+
+static const struct fence_ops nouveau_fence_ops_uevent = {
+	.enable_signaling = nouveau_fence_enable_signaling,
+	.signaled = nouveau_fence_is_signaled,
+	.wait = fence_default_wait,
+	.release = NULL
+};
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.h b/drivers/gpu/drm/nouveau/nouveau_fence.h
index c57bb61..1df933c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -1,18 +1,20 @@
 #ifndef __NOUVEAU_FENCE_H__
 #define __NOUVEAU_FENCE_H__
 
+#include <linux/fence.h>
+
 struct nouveau_drm;
 
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
@@ -38,8 +40,9 @@ struct nouveau_fence_chan {
 	int  (*emit32)(struct nouveau_channel *, u64, u32);
 	int  (*sync32)(struct nouveau_channel *, u64, u32);
 
-	spinlock_t lock;
+	spinlock_t *lock;
 	u32 sequence;
+	u32 context;
 };
 
 struct nouveau_fence_priv {
@@ -49,13 +52,14 @@ struct nouveau_fence_priv {
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
diff --git a/drivers/gpu/drm/nouveau/nv04_fence.c b/drivers/gpu/drm/nouveau/nv04_fence.c
index 94eadd1..997c541 100644
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
index 06f434f..e8f73f7 100644
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
index 22aa996..e404bab 100644
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
index 0ee3638..19f6fcc 100644
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
index 9fd475c..8a06727 100644
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

