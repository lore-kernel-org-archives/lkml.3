Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbaDIPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:16:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51015 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDIPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:16:49 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 11:16:49 EDT
Subject: [PATCH 2/2] [RFC] reservation: add suppport for read-only access
 using rcu
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Wed, 09 Apr 2014 16:49:11 +0200
Message-ID: <20140409144831.26648.79163.stgit@patser>
In-Reply-To: <20140409144239.26648.57918.stgit@patser>
References: <20140409144239.26648.57918.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds 3 more functions to deal with rcu.

reservation_object_wait_timeout_rcu() will wait on all fences of the
reservation_object, without obtaining the ww_mutex.

reservation_object_test_signaled_rcu() will test if all fences of the
reservation_object are signaled without using the ww_mutex.

reservation_object_get_excl() is added because touching the fence_excl
member directly will trigger a sparse warning.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/base/dma-buf.c      |   46 +++++++++++--
 drivers/base/reservation.c  |  147 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/fence.h       |   22 ++++++
 include/linux/reservation.h |   40 ++++++++----
 4 files changed, 224 insertions(+), 31 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index d89a98d2c37b..fc2d7546b8b0 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -151,14 +151,22 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	if (!events)
 		return 0;
 
-	ww_mutex_lock(&resv->lock, NULL);
+	rcu_read_lock();
 
-	fobj = resv->fence;
-	if (!fobj)
-		goto out;
+	fobj = rcu_dereference(resv->fence);
+	if (fobj) {
+		shared_count = ACCESS_ONCE(fobj->shared_count);
+		smp_mb(); /* shared_count needs transitivity wrt fence_excl */
+	} else
+		shared_count = 0;
+	fence_excl = rcu_dereference(resv->fence_excl);
 
-	shared_count = fobj->shared_count;
-	fence_excl = resv->fence_excl;
+	/*
+	 * This would have needed a smp_read_barrier_depends()
+	 * because shared_count needs to be read before shared[i], but
+	 * spin_lock_irq and spin_unlock_irq provide even stronger
+	 * guarantees.
+	 */
 
 	if (fence_excl && (!(events & POLLOUT) || shared_count == 0)) {
 		struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_excl;
@@ -176,14 +184,20 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & pevents) {
-			if (!fence_add_callback(fence_excl, &dcb->cb,
+			if (!fence_get_rcu(fence_excl)) {
+				/* force a recheck */
+				events &= ~pevents;
+				dma_buf_poll_cb(NULL, &dcb->cb);
+			} else if (!fence_add_callback(fence_excl, &dcb->cb,
 						       dma_buf_poll_cb)) {
 				events &= ~pevents;
+				fence_put(fence_excl);
 			} else {
 				/*
 				 * No callback queued, wake up any additional
 				 * waiters.
 				 */
+				fence_put(fence_excl);
 				dma_buf_poll_cb(NULL, &dcb->cb);
 			}
 		}
@@ -205,13 +219,25 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 			goto out;
 
 		for (i = 0; i < shared_count; ++i) {
-			struct fence *fence = fobj->shared[i];
-
+			struct fence *fence = fence_get_rcu(fobj->shared[i]);
+			if (!fence) {
+				/*
+				 * fence refcount dropped to zero, this means
+				 * that fobj has been freed
+				 *
+				 * call dma_buf_poll_cb and force a recheck!
+				 */
+				events &= ~POLLOUT;
+				dma_buf_poll_cb(NULL, &dcb->cb);
+				break;
+			}
 			if (!fence_add_callback(fence, &dcb->cb,
 						dma_buf_poll_cb)) {
+				fence_put(fence);
 				events &= ~POLLOUT;
 				break;
 			}
+			fence_put(fence);
 		}
 
 		/* No callback queued, wake up any additional waiters. */
@@ -220,7 +246,7 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	}
 
 out:
-	ww_mutex_unlock(&resv->lock);
+	rcu_read_unlock();
 	return events;
 }
 
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
index b82a5b630a8e..4cdce63140b8 100644
--- a/drivers/base/reservation.c
+++ b/drivers/base/reservation.c
@@ -87,9 +87,13 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 			struct fence *old_fence = fobj->shared[i];
 
 			fence_get(fence);
+			/* for the fence_get() */
+			smp_mb__after_atomic_inc();
 
 			fobj->shared[i] = fence;
 
+			/* for the fence_put() */
+			smp_mb__before_atomic_dec();
 			fence_put(old_fence);
 			return;
 		}
@@ -141,8 +145,9 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
 		fobj->shared[fobj->shared_count++] = fence;
 
 done:
-	obj->fence = fobj;
-	kfree(old);
+	rcu_assign_pointer(obj->fence, fobj);
+	if (old)
+		kfree_rcu(old, rcu);
 }
 
 /*
@@ -168,20 +173,25 @@ EXPORT_SYMBOL(reservation_object_add_shared_fence);
 void reservation_object_add_excl_fence(struct reservation_object *obj,
 				       struct fence *fence)
 {
-	struct fence *old_fence = obj->fence_excl;
+	struct fence *old_fence = reservation_object_get_excl(obj);
 	struct reservation_object_list *old;
 	u32 i = 0;
 
 	old = reservation_object_get_list(obj);
-	if (old) {
+	if (old)
 		i = old->shared_count;
-		old->shared_count = 0;
-	}
 
 	if (fence)
 		fence_get(fence);
 
-	obj->fence_excl = fence;
+	rcu_assign_pointer(obj->fence_excl, fence);
+
+	if (old) {
+		smp_wmb();
+		old->shared_count = 0;
+	}
+
+	smp_mb__before_atomic_dec();
 
 	/* inplace update, no shared fences */
 	while (i--)
@@ -191,3 +201,126 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
 		fence_put(old_fence);
 }
 EXPORT_SYMBOL(reservation_object_add_excl_fence);
+
+long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
+					 bool wait_all, bool intr,
+					 unsigned long timeout)
+{
+	unsigned shared_count = 0;
+
+	while (1) {
+		struct fence *fence = NULL, *fence_excl;
+		struct reservation_object_list *fobj;
+		long ret;
+
+		rcu_read_lock();
+
+retry:
+		if (wait_all) {
+			unsigned i;
+
+			fobj = rcu_dereference(obj->fence);
+			if (fobj)
+				shared_count = ACCESS_ONCE(fobj->shared_count);
+			else
+				shared_count = 0;
+			smp_mb(); /* shared_count needs transitivity wrt fence_excl */
+
+			for (i = 0; i < shared_count; ++i) {
+				fence = ACCESS_ONCE(fobj->shared[i]);
+
+				if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+					continue;
+
+				if (!fence_get_rcu(fence))
+					goto retry;
+
+				if (fence_is_signaled(fence))
+					fence_put(fence);
+				else
+					break;
+			}
+			if (i == shared_count)
+				fence = NULL;
+		}
+
+		if (shared_count == 0) {
+			fence_excl = rcu_dereference(obj->fence_excl);
+			if (fence_excl && !fence_get_rcu(fence_excl))
+				goto retry;
+
+			if (fence_excl && fence_is_signaled(fence_excl))
+				fence_put(fence_excl);
+			else
+				fence = fence_excl;
+		}
+
+		rcu_read_unlock();
+
+		if (fence == NULL)
+			return timeout;
+
+		ret = fence_wait_timeout(fence, intr, timeout);
+		fence_put(fence);
+
+		if (ret <= 0)
+			return ret;
+		else
+			timeout = ret;
+	}
+}
+EXPORT_SYMBOL_GPL(reservation_object_wait_timeout_rcu);
+
+bool reservation_object_test_signaled_rcu(struct reservation_object *obj, bool test_all)
+{
+	struct fence *fence, *fence_excl;
+	struct reservation_object_list *fobj;
+	unsigned shared_count = 0;
+	bool ret = true;
+
+	rcu_read_lock();
+
+retry:
+	if (test_all) {
+		unsigned i;
+
+		fobj = rcu_dereference(obj->fence);
+		if (fobj)
+			shared_count = ACCESS_ONCE(fobj->shared_count);
+		else
+			shared_count = 0;
+		smp_mb(); /* shared_count needs transitivity wrt fence_excl */
+
+		for (i = 0; i < shared_count; ++i) {
+			fence = ACCESS_ONCE(fobj->shared[i]);
+
+			if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+				continue;
+
+			if (!fence_get_rcu(fence))
+				goto retry;
+
+			ret = fence_is_signaled(fence);
+			fence_put(fence);
+			if (!ret)
+				break;
+		}
+	}
+
+	if (shared_count == 0) {
+		fence_excl = rcu_dereference(obj->fence_excl);
+
+		if (fence_excl && !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence_excl->flags)) {
+			fence = fence_get_rcu(fence_excl);
+			if (!fence)
+				goto retry;
+
+			ret = fence_is_signaled(fence);
+			fence_put(fence);
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(reservation_object_test_signaled_rcu);
diff --git a/include/linux/fence.h b/include/linux/fence.h
index d13b5ab61726..8499ace045da 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -31,7 +31,7 @@
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/printk.h>
-#include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 struct fence;
 struct fence_ops;
@@ -41,6 +41,7 @@ struct fence_cb;
  * struct fence - software synchronization primitive
  * @refcount: refcount for this fence
  * @ops: fence_ops associated with this fence
+ * @rcu: used for releasing fence with kfree_rcu
  * @cb_list: list of all callbacks to call
  * @lock: spin_lock_irqsave used for locking
  * @context: execution context this fence belongs to, returned by
@@ -74,6 +75,7 @@ struct fence_cb;
 struct fence {
 	struct kref refcount;
 	const struct fence_ops *ops;
+	struct rcu_head rcu;
 	struct list_head cb_list;
 	spinlock_t *lock;
 	unsigned context, seqno;
@@ -190,11 +192,27 @@ static inline void fence_get(struct fence *fence)
 	kref_get(&fence->refcount);
 }
 
+/**
+ * fence_get_rcu - get a fence from a reservation_object_list with rcu read lock
+ * @fence:	[in]	fence to increase refcount of
+ *
+ * Function returns NULL if no refcount could be obtained, or the fence.
+ */
+static inline struct fence *fence_get_rcu(struct fence *fence)
+{
+	struct fence *f = ACCESS_ONCE(fence);
+
+	if (kref_get_unless_zero(&f->refcount))
+		return f;
+	else
+		return NULL;
+}
+
 extern void release_fence(struct kref *kref);
 
 static inline void free_fence(struct fence *fence)
 {
-	kfree(fence);
+	kfree_rcu(fence, rcu);
 }
 
 /**
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index b602365c87f9..2a53bfbec6a1 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -42,10 +42,12 @@
 #include <linux/ww_mutex.h>
 #include <linux/fence.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 extern struct ww_class reservation_ww_class;
 
 struct reservation_object_list {
+	struct rcu_head rcu;
 	u32 shared_count, shared_max;
 	struct fence *shared[];
 };
@@ -53,21 +55,20 @@ struct reservation_object_list {
 struct reservation_object {
 	struct ww_mutex lock;
 
-	struct fence *fence_excl;
-	struct reservation_object_list *fence;
+	struct fence __rcu *fence_excl;
+	struct reservation_object_list __rcu *fence;
 	struct reservation_object_list *staged;
 };
 
-#define reservation_object_assert_held(obj) \
-	lockdep_assert_held(&(obj)->lock.base)
+#define reservation_object_held(obj) (lockdep_is_held(&(obj)->lock.base))
 
 static inline void
 reservation_object_init(struct reservation_object *obj)
 {
 	ww_mutex_init(&obj->lock, &reservation_ww_class);
 
-	obj->fence_excl = NULL;
-	obj->fence = NULL;
+	RCU_INIT_POINTER(obj->fence, NULL);
+	RCU_INIT_POINTER(obj->fence_excl, NULL);
 	obj->staged = NULL;
 }
 
@@ -76,15 +77,17 @@ reservation_object_fini(struct reservation_object *obj)
 {
 	int i;
 	struct reservation_object_list *fobj;
+	struct fence *excl;
 
 	/*
 	 * This object should be dead and all references must have
-	 * been released to it.
+	 * been released to it, so no need to be protected with rcu.
 	 */
-	if (obj->fence_excl)
-		fence_put(obj->fence_excl);
+	excl = rcu_dereference_protected(obj->fence_excl, 1);
+	if (excl)
+		fence_put(excl);
 
-	fobj = obj->fence;
+	fobj = rcu_dereference_protected(obj->fence, 1);
 	if (fobj) {
 		for (i = 0; i < fobj->shared_count; ++i)
 			fence_put(fobj->shared[i]);
@@ -99,9 +102,15 @@ reservation_object_fini(struct reservation_object *obj)
 static inline struct reservation_object_list *
 reservation_object_get_list(struct reservation_object *obj)
 {
-	reservation_object_assert_held(obj);
+	return rcu_dereference_protected(obj->fence,
+					 reservation_object_held(obj));
+}
 
-	return obj->fence;
+static inline struct fence *
+reservation_object_get_excl(struct reservation_object *obj)
+{
+	return rcu_dereference_protected(obj->fence_excl,
+					 reservation_object_held(obj));
 }
 
 int reservation_object_reserve_shared(struct reservation_object *obj);
@@ -111,4 +120,11 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
 void reservation_object_add_excl_fence(struct reservation_object *obj,
 				       struct fence *fence);
 
+long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
+					 bool wait_all, bool intr,
+					 unsigned long timeout);
+
+bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
+					  bool test_all);
+
 #endif /* _LINUX_RESERVATION_H */

