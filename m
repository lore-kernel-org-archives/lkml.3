Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaGAK6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:58:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60314 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbaGAK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:58:29 -0400
Subject: [PATCH v2 8/9] reservation: update api and add some helpers
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:54 +0200
Message-ID: <20140701105754.12718.20892.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the list of shared fences to a struct, and return it in
reservation_object_get_list().
Add reservation_object_get_excl to get the exclusive fence.

Add reservation_object_reserve_shared(), which reserves space
in the reservation_object for 1 more shared fence.

reservation_object_add_shared_fence() and
reservation_object_add_excl_fence() are used to assign a new
fence to a reservation_object pointer, to complete a reservation.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Changes since v1:
- Add reservation_object_get_excl, reorder code a bit.
---
 Documentation/DocBook/device-drivers.tmpl |    1 
 drivers/dma-buf/dma-buf.c                 |   35 ++++---
 drivers/dma-buf/reservation.c             |  156 +++++++++++++++++++++++++++++
 include/linux/reservation.h               |   56 +++++++++-
 4 files changed, 229 insertions(+), 19 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index ed0ef00cd7bc..dd3f278faa8a 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -133,6 +133,7 @@ X!Edrivers/base/interface.c
 !Edrivers/dma-buf/seqno-fence.c
 !Iinclude/linux/fence.h
 !Iinclude/linux/seqno-fence.h
+!Edrivers/dma-buf/reservation.c
 !Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 25e8c4165936..cb8379dfeed5 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
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
 
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index a73fbf3b8e56..e6166723a9ae 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012-2013 Canonical Ltd
+ * Copyright (C) 2012-2014 Canonical Ltd (Maarten Lankhorst)
  *
  * Based on bo.c which bears the following copyright notice,
  * but is dual licensed:
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
+		} else
+			max = old->shared_max * 2;
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
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index f3f57460a205..2affe67dea6e 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -45,36 +45,78 @@
 
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
+static inline struct fence *
+reservation_object_get_excl(struct reservation_object *obj)
+{
+	reservation_object_assert_held(obj);
+
+	return obj->fence_excl;
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

