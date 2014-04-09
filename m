Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbaDIPsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:48:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60793 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDIPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:48:22 -0400
Subject: [PATCH 1/2] reservation: update api and add some helpers
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Wed, 09 Apr 2014 16:48:25 +0200
Message-ID: <20140409144819.26648.78350.stgit@patser>
In-Reply-To: <20140409144239.26648.57918.stgit@patser>
References: <20140409144239.26648.57918.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the list of shared fences to a struct, and return it in
reservation_object_get_list().

Add reservation_object_reserve_shared(), which reserves space
in the reservation_object for 1 more shared fence.

reservation_object_add_shared_fence() and
reservation_object_add_excl_fence() are used to assign a new
fence to a reservation_object pointer, to complete a reservation.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/base/dma-buf.c      |   35 +++++++---
 drivers/base/fence.c        |    4 +
 drivers/base/reservation.c  |  154 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fence.h       |    6 ++
 include/linux/reservation.h |   48 +++++++++++--
 kernel/sched/core.c         |    1 
 6 files changed, 228 insertions(+), 20 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 96338bf7f457..d89a98d2c37b 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -134,7 +134,10 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 {
 	struct dma_buf *dmabuf;
 	struct reservation_object *resv;
+	struct reservation_object_list *fobj;
+	struct fence *fence_excl;
 	unsigned long events;
+	unsigned shared_count;
 
 	dmabuf = file->private_data;
 	if (!dmabuf || !dmabuf->resv)
@@ -150,12 +153,18 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 
 	ww_mutex_lock(&resv->lock, NULL);
 
-	if (resv->fence_excl && (!(events & POLLOUT) ||
-				 resv->fence_shared_count == 0)) {
+	fobj = resv->fence;
+	if (!fobj)
+		goto out;
+
+	shared_count = fobj->shared_count;
+	fence_excl = resv->fence_excl;
+
+	if (fence_excl && (!(events & POLLOUT) || shared_count == 0)) {
 		struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_excl;
 		unsigned long pevents = POLLIN;
 
-		if (resv->fence_shared_count == 0)
+		if (shared_count == 0)
 			pevents |= POLLOUT;
 
 		spin_lock_irq(&dmabuf->poll.lock);
@@ -167,19 +176,20 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & pevents) {
-			if (!fence_add_callback(resv->fence_excl,
-						&dcb->cb, dma_buf_poll_cb))
+			if (!fence_add_callback(fence_excl, &dcb->cb,
+						       dma_buf_poll_cb)) {
 				events &= ~pevents;
-			else
+			} else {
 				/*
 				 * No callback queued, wake up any additional
 				 * waiters.
 				 */
 				dma_buf_poll_cb(NULL, &dcb->cb);
+			}
 		}
 	}
 
-	if ((events & POLLOUT) && resv->fence_shared_count > 0) {
+	if ((events & POLLOUT) && shared_count > 0) {
 		struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_shared;
 		int i;
 
@@ -194,15 +204,18 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 		if (!(events & POLLOUT))
 			goto out;
 
-		for (i = 0; i < resv->fence_shared_count; ++i)
-			if (!fence_add_callback(resv->fence_shared[i],
-						&dcb->cb, dma_buf_poll_cb)) {
+		for (i = 0; i < shared_count; ++i) {
+			struct fence *fence = fobj->shared[i];
+
+			if (!fence_add_callback(fence, &dcb->cb,
+						dma_buf_poll_cb)) {
 				events &= ~POLLOUT;
 				break;
 			}
+		}
 
 		/* No callback queued, wake up any additional waiters. */
-		if (i == resv->fence_shared_count)
+		if (i == shared_count)
 			dma_buf_poll_cb(NULL, &dcb->cb);
 	}
 
diff --git a/drivers/base/fence.c b/drivers/base/fence.c
index 8fff13fb86cf..f780f9b3d418 100644
--- a/drivers/base/fence.c
+++ b/drivers/base/fence.c
@@ -170,7 +170,7 @@ void release_fence(struct kref *kref)
 	if (fence->ops->release)
 		fence->ops->release(fence);
 	else
-		kfree(fence);
+		free_fence(fence);
 }
 EXPORT_SYMBOL(release_fence);
 
@@ -448,7 +448,7 @@ static void seqno_release(struct fence *fence)
 	if (f->ops->release)
 		f->ops->release(fence);
 	else
-		kfree(f);
+		free_fence(fence);
 }
 
 static long seqno_wait(struct fence *fence, bool intr, signed long timeout)
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
index a73fbf3b8e56..b82a5b630a8e 100644
--- a/drivers/base/reservation.c
+++ b/drivers/base/reservation.c
@@ -37,3 +37,157 @@
 
 DEFINE_WW_CLASS(reservation_ww_class);
 EXPORT_SYMBOL(reservation_ww_class);
+
+/*
+ * Reserve space to add a shared fence to a reservation_object,
+ * must be called with obj->lock held.
+ */
+int reservation_object_reserve_shared(struct reservation_object *obj)
+{
+	struct reservation_object_list *fobj, *old;
+	u32 max;
+
+	old = reservation_object_get_list(obj);
+
+	if (old && old->shared_max) {
+		if (old->shared_count < old->shared_max) {
+			/* perform an in-place update */
+			kfree(obj->staged);
+			obj->staged = NULL;
+			return 0;
+		}
+		max = old->shared_max * 2;
+	} else
+		max = 4;
+
+	/*
+	 * resize obj->staged or allocate if it doesn't exist,
+	 * noop if already correct size
+	 */
+	fobj = krealloc(obj->staged, offsetof(typeof(*fobj), shared[max]),
+			GFP_KERNEL);
+	if (!fobj)
+		return -ENOMEM;
+
+	obj->staged = fobj;
+	fobj->shared_max = max;
+	return 0;
+}
+EXPORT_SYMBOL(reservation_object_reserve_shared);
+
+static void
+reservation_object_add_shared_inplace(struct reservation_object *obj,
+				      struct reservation_object_list *fobj,
+				      struct fence *fence)
+{
+	u32 i;
+
+	for (i = 0; i < fobj->shared_count; ++i) {
+		if (fobj->shared[i]->context == fence->context) {
+			struct fence *old_fence = fobj->shared[i];
+
+			fence_get(fence);
+
+			fobj->shared[i] = fence;
+
+			fence_put(old_fence);
+			return;
+		}
+	}
+
+	fence_get(fence);
+	fobj->shared[fobj->shared_count] = fence;
+	/*
+	 * make the new fence visible before incrementing
+	 * fobj->shared_count
+	 */
+	smp_wmb();
+	fobj->shared_count++;
+}
+
+static void
+reservation_object_add_shared_replace(struct reservation_object *obj,
+				      struct reservation_object_list *old,
+				      struct reservation_object_list *fobj,
+				      struct fence *fence)
+{
+	unsigned i;
+
+	fence_get(fence);
+
+	if (!old) {
+		fobj->shared[0] = fence;
+		fobj->shared_count = 1;
+		goto done;
+	}
+
+	/*
+	 * no need to bump fence refcounts, rcu_read access
+	 * requires the use of kref_get_unless_zero, and the
+	 * references from the old struct are carried over to
+	 * the new.
+	 */
+	fobj->shared_count = old->shared_count;
+
+	for (i = 0; i < old->shared_count; ++i) {
+		if (fence && old->shared[i]->context == fence->context) {
+			fence_put(old->shared[i]);
+			fobj->shared[i] = fence;
+			fence = NULL;
+		} else
+			fobj->shared[i] = old->shared[i];
+	}
+	if (fence)
+		fobj->shared[fobj->shared_count++] = fence;
+
+done:
+	obj->fence = fobj;
+	kfree(old);
+}
+
+/*
+ * Add a fence to a shared slot, obj->lock must be held, and
+ * reservation_object_reserve_shared_fence has been called.
+ */
+void reservation_object_add_shared_fence(struct reservation_object *obj,
+					 struct fence *fence)
+{
+	struct reservation_object_list *old, *fobj = obj->staged;
+
+	old = reservation_object_get_list(obj);
+	obj->staged = NULL;
+
+	if (!fobj) {
+		BUG_ON(old->shared_count == old->shared_max);
+		reservation_object_add_shared_inplace(obj, old, fence);
+	} else
+		reservation_object_add_shared_replace(obj, old, fobj, fence);
+}
+EXPORT_SYMBOL(reservation_object_add_shared_fence);
+
+void reservation_object_add_excl_fence(struct reservation_object *obj,
+				       struct fence *fence)
+{
+	struct fence *old_fence = obj->fence_excl;
+	struct reservation_object_list *old;
+	u32 i = 0;
+
+	old = reservation_object_get_list(obj);
+	if (old) {
+		i = old->shared_count;
+		old->shared_count = 0;
+	}
+
+	if (fence)
+		fence_get(fence);
+
+	obj->fence_excl = fence;
+
+	/* inplace update, no shared fences */
+	while (i--)
+		fence_put(old->shared[i]);
+
+	if (old_fence)
+		fence_put(old_fence);
+}
+EXPORT_SYMBOL(reservation_object_add_excl_fence);
diff --git a/include/linux/fence.h b/include/linux/fence.h
index 65f2a01ee7e4..d13b5ab61726 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -31,6 +31,7 @@
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 
 struct fence;
 struct fence_ops;
@@ -191,6 +192,11 @@ static inline void fence_get(struct fence *fence)
 
 extern void release_fence(struct kref *kref);
 
+static inline void free_fence(struct fence *fence)
+{
+	kfree(fence);
+}
+
 /**
  * fence_put - decreases refcount of the fence
  * @fence:	[in]	fence to reduce refcount of
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index f3f57460a205..b602365c87f9 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -45,36 +45,70 @@
 
 extern struct ww_class reservation_ww_class;
 
+struct reservation_object_list {
+	u32 shared_count, shared_max;
+	struct fence *shared[];
+};
+
 struct reservation_object {
 	struct ww_mutex lock;
 
 	struct fence *fence_excl;
-	struct fence **fence_shared;
-	u32 fence_shared_count, fence_shared_max;
+	struct reservation_object_list *fence;
+	struct reservation_object_list *staged;
 };
 
+#define reservation_object_assert_held(obj) \
+	lockdep_assert_held(&(obj)->lock.base)
+
 static inline void
 reservation_object_init(struct reservation_object *obj)
 {
 	ww_mutex_init(&obj->lock, &reservation_ww_class);
 
-	obj->fence_shared_count = obj->fence_shared_max = 0;
-	obj->fence_shared = NULL;
 	obj->fence_excl = NULL;
+	obj->fence = NULL;
+	obj->staged = NULL;
 }
 
 static inline void
 reservation_object_fini(struct reservation_object *obj)
 {
 	int i;
+	struct reservation_object_list *fobj;
 
+	/*
+	 * This object should be dead and all references must have
+	 * been released to it.
+	 */
 	if (obj->fence_excl)
 		fence_put(obj->fence_excl);
-	for (i = 0; i < obj->fence_shared_count; ++i)
-		fence_put(obj->fence_shared[i]);
-	kfree(obj->fence_shared);
+
+	fobj = obj->fence;
+	if (fobj) {
+		for (i = 0; i < fobj->shared_count; ++i)
+			fence_put(fobj->shared[i]);
+
+		kfree(fobj);
+	}
+	kfree(obj->staged);
 
 	ww_mutex_destroy(&obj->lock);
 }
 
+static inline struct reservation_object_list *
+reservation_object_get_list(struct reservation_object *obj)
+{
+	reservation_object_assert_held(obj);
+
+	return obj->fence;
+}
+
+int reservation_object_reserve_shared(struct reservation_object *obj);
+void reservation_object_add_shared_fence(struct reservation_object *obj,
+					 struct fence *fence);
+
+void reservation_object_add_excl_fence(struct reservation_object *obj,
+				       struct fence *fence);
+
 #endif /* _LINUX_RESERVATION_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5c6635b806c..b8cfb790e831 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1694,6 +1694,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 {
 	return try_to_wake_up(p, state, 0);
 }
+EXPORT_SYMBOL(wake_up_state);
 
 /*
  * Perform scheduler related setup for a newly forked process p.

