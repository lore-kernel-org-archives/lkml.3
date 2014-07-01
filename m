Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaGAK6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:58:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60366 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbaGAK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:58:35 -0400
Subject: [PATCH v2 9/9] reservation: add suppport for read-only access using
 rcu
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:58:00 +0200
Message-ID: <20140701105800.12718.18636.stgit@patser>
In-Reply-To: <20140701103432.12718.82795.stgit@patser>
References: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some extra functions to deal with rcu.

reservation_object_get_fences_rcu() will obtain the list of shared
and exclusive fences without obtaining the ww_mutex.

reservation_object_wait_timeout_rcu() will wait on all fences of the
reservation_object, without obtaining the ww_mutex.

reservation_object_test_signaled_rcu() will test if all fences of the
reservation_object are signaled without using the ww_mutex.

reservation_object_get_excl and reservation_object_get_list require
the reservation object to be held, updating requires
write_seqcount_begin/end. If only the exclusive fence is needed,
rcu_dereference followed by fence_get_rcu can be used, if the shared
fences are needed it's recommended to use the supplied functions.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Reviewed-By: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/dma-buf/dma-buf.c     |   47 ++++--
 drivers/dma-buf/fence.c       |    2 
 drivers/dma-buf/reservation.c |  336 ++++++++++++++++++++++++++++++++++++++---
 include/linux/fence.h         |   17 ++
 include/linux/reservation.h   |   52 ++++--
 5 files changed, 400 insertions(+), 54 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index cb8379dfeed5..f3014c448e1e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -137,7 +137,7 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	struct reservation_object_list *fobj;
 	struct fence *fence_excl;
 	unsigned long events;
-	unsigned shared_count;
+	unsigned shared_count, seq;
 
 	dmabuf = file->private_data;
 	if (!dmabuf || !dmabuf->resv)
@@ -151,14 +151,20 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	if (!events)
 		return 0;
 
-	ww_mutex_lock(&resv->lock, NULL);
+retry:
+	seq = read_seqcount_begin(&resv->seq);
+	rcu_read_lock();
 
-	fobj = resv->fence;
-	if (!fobj)
-		goto out;
-
-	shared_count = fobj->shared_count;
-	fence_excl = resv->fence_excl;
+	fobj = rcu_dereference(resv->fence);
+	if (fobj)
+		shared_count = fobj->shared_count;
+	else
+		shared_count = 0;
+	fence_excl = rcu_dereference(resv->fence_excl);
+	if (read_seqcount_retry(&resv->seq, seq)) {
+		rcu_read_unlock();
+		goto retry;
+	}
 
 	if (fence_excl && (!(events & POLLOUT) || shared_count == 0)) {
 		struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_excl;
@@ -176,14 +182,20 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
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
@@ -205,13 +217,26 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 			goto out;
 
 		for (i = 0; i < shared_count; ++i) {
-			struct fence *fence = fobj->shared[i];
+			struct fence *fence = rcu_dereference(fobj->shared[i]);
 
+			if (!fence_get_rcu(fence)) {
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
@@ -220,7 +245,7 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	}
 
 out:
-	ww_mutex_unlock(&resv->lock);
+	rcu_read_unlock();
 	return events;
 }
 
diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
index 948bf00d955e..4222cb2aa96a 100644
--- a/drivers/dma-buf/fence.c
+++ b/drivers/dma-buf/fence.c
@@ -184,7 +184,7 @@ EXPORT_SYMBOL(fence_release);
 
 void fence_free(struct fence *fence)
 {
-	kfree(fence);
+	kfree_rcu(fence, rcu);
 }
 EXPORT_SYMBOL(fence_free);
 
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index e6166723a9ae..3c97c8fa8d02 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -38,6 +38,11 @@
 DEFINE_WW_CLASS(reservation_ww_class);
 EXPORT_SYMBOL(reservation_ww_class);
 
+struct lock_class_key reservation_seqcount_class;
+EXPORT_SYMBOL(reservation_seqcount_class);
+
+const char reservation_seqcount_string[] = "reservation_seqcount";
+EXPORT_SYMBOL(reservation_seqcount_string);
 /*
  * Reserve space to add a shared fence to a reservation_object,
  * must be called with obj->lock held.
@@ -82,27 +87,37 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 {
 	u32 i;
 
+	fence_get(fence);
+
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
+
 	for (i = 0; i < fobj->shared_count; ++i) {
-		if (fobj->shared[i]->context == fence->context) {
-			struct fence *old_fence = fobj->shared[i];
+		struct fence *old_fence;
 
-			fence_get(fence);
+		old_fence = rcu_dereference_protected(fobj->shared[i],
+						reservation_object_held(obj));
 
-			fobj->shared[i] = fence;
+		if (old_fence->context == fence->context) {
+			/* memory barrier is added by write_seqcount_begin */
+			RCU_INIT_POINTER(fobj->shared[i], fence);
+			write_seqcount_end(&obj->seq);
+			preempt_enable();
 
 			fence_put(old_fence);
 			return;
 		}
 	}
 
-	fence_get(fence);
-	fobj->shared[fobj->shared_count] = fence;
 	/*
-	 * make the new fence visible before incrementing
-	 * fobj->shared_count
+	 * memory barrier is added by write_seqcount_begin,
+	 * fobj->shared_count is protected by this lock too
 	 */
-	smp_wmb();
+	RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
 	fobj->shared_count++;
+
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
 }
 
 static void
@@ -112,11 +127,12 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
 				      struct fence *fence)
 {
 	unsigned i;
+	struct fence *old_fence = NULL;
 
 	fence_get(fence);
 
 	if (!old) {
-		fobj->shared[0] = fence;
+		RCU_INIT_POINTER(fobj->shared[0], fence);
 		fobj->shared_count = 1;
 		goto done;
 	}
@@ -130,19 +146,38 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
 	fobj->shared_count = old->shared_count;
 
 	for (i = 0; i < old->shared_count; ++i) {
-		if (fence && old->shared[i]->context == fence->context) {
-			fence_put(old->shared[i]);
-			fobj->shared[i] = fence;
-			fence = NULL;
+		struct fence *check;
+
+		check = rcu_dereference_protected(old->shared[i],
+						reservation_object_held(obj));
+
+		if (!old_fence && check->context == fence->context) {
+			old_fence = check;
+			RCU_INIT_POINTER(fobj->shared[i], fence);
 		} else
-			fobj->shared[i] = old->shared[i];
+			RCU_INIT_POINTER(fobj->shared[i], check);
+	}
+	if (!old_fence) {
+		RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
+		fobj->shared_count++;
 	}
-	if (fence)
-		fobj->shared[fobj->shared_count++] = fence;
 
 done:
-	obj->fence = fobj;
-	kfree(old);
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
+	/*
+	 * RCU_INIT_POINTER can be used here,
+	 * seqcount provides the necessary barriers
+	 */
+	RCU_INIT_POINTER(obj->fence, fobj);
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
+
+	if (old)
+		kfree_rcu(old, rcu);
+
+	if (old_fence)
+		fence_put(old_fence);
 }
 
 /*
@@ -158,7 +193,7 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
 	obj->staged = NULL;
 
 	if (!fobj) {
-		BUG_ON(old->shared_count == old->shared_max);
+		BUG_ON(old->shared_count >= old->shared_max);
 		reservation_object_add_shared_inplace(obj, old, fence);
 	} else
 		reservation_object_add_shared_replace(obj, old, fobj, fence);
@@ -168,26 +203,275 @@ EXPORT_SYMBOL(reservation_object_add_shared_fence);
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
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
+	/* write_seqcount_begin provides the necessary memory barrier */
+	RCU_INIT_POINTER(obj->fence_excl, fence);
+	if (old)
+		old->shared_count = 0;
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
 
 	/* inplace update, no shared fences */
 	while (i--)
-		fence_put(old->shared[i]);
+		fence_put(rcu_dereference_protected(old->shared[i],
+						reservation_object_held(obj)));
 
 	if (old_fence)
 		fence_put(old_fence);
 }
 EXPORT_SYMBOL(reservation_object_add_excl_fence);
+
+int reservation_object_get_fences_rcu(struct reservation_object *obj,
+				      struct fence **pfence_excl,
+				      unsigned *pshared_count,
+				      struct fence ***pshared)
+{
+	unsigned shared_count = 0;
+	unsigned retry = 1;
+	struct fence **shared = NULL, *fence_excl = NULL;
+	int ret = 0;
+
+	while (retry) {
+		struct reservation_object_list *fobj;
+		unsigned seq;
+
+		seq = read_seqcount_begin(&obj->seq);
+
+		rcu_read_lock();
+
+		fobj = rcu_dereference(obj->fence);
+		if (fobj) {
+			struct fence **nshared;
+			size_t sz = sizeof(*shared) * fobj->shared_max;
+
+			nshared = krealloc(shared, sz,
+					   GFP_NOWAIT | __GFP_NOWARN);
+			if (!nshared) {
+				rcu_read_unlock();
+				nshared = krealloc(shared, sz, GFP_KERNEL);
+				if (nshared) {
+					shared = nshared;
+					continue;
+				}
+
+				ret = -ENOMEM;
+				shared_count = 0;
+				break;
+			}
+			shared = nshared;
+			memcpy(shared, fobj->shared, sz);
+			shared_count = fobj->shared_count;
+		} else
+			shared_count = 0;
+		fence_excl = rcu_dereference(obj->fence_excl);
+
+		retry = read_seqcount_retry(&obj->seq, seq);
+		if (retry)
+			goto unlock;
+
+		if (!fence_excl || fence_get_rcu(fence_excl)) {
+			unsigned i;
+
+			for (i = 0; i < shared_count; ++i) {
+				if (fence_get_rcu(shared[i]))
+					continue;
+
+				/* uh oh, refcount failed, abort and retry */
+				while (i--)
+					fence_put(shared[i]);
+
+				if (fence_excl) {
+					fence_put(fence_excl);
+					fence_excl = NULL;
+				}
+
+				retry = 1;
+				break;
+			}
+		} else
+			retry = 1;
+
+unlock:
+		rcu_read_unlock();
+	}
+	*pshared_count = shared_count;
+	if (shared_count)
+		*pshared = shared;
+	else {
+		*pshared = NULL;
+		kfree(shared);
+	}
+	*pfence_excl = fence_excl;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
+
+long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
+					 bool wait_all, bool intr,
+					 unsigned long timeout)
+{
+	struct fence *fence;
+	unsigned seq, shared_count, i = 0;
+	long ret = timeout;
+
+retry:
+	fence = NULL;
+	shared_count = 0;
+	seq = read_seqcount_begin(&obj->seq);
+	rcu_read_lock();
+
+	if (wait_all) {
+		struct reservation_object_list *fobj = rcu_dereference(obj->fence);
+
+		if (fobj)
+			shared_count = fobj->shared_count;
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		for (i = 0; i < shared_count; ++i) {
+			struct fence *lfence = rcu_dereference(fobj->shared[i]);
+
+			if (test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags))
+				continue;
+
+			if (!fence_get_rcu(lfence))
+				goto unlock_retry;
+
+			if (fence_is_signaled(lfence)) {
+				fence_put(lfence);
+				continue;
+			}
+
+			fence = lfence;
+			break;
+		}
+	}
+
+	if (!shared_count) {
+		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		if (fence_excl &&
+		    !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence_excl->flags)) {
+			if (!fence_get_rcu(fence_excl))
+				goto unlock_retry;
+
+			if (fence_is_signaled(fence_excl))
+				fence_put(fence_excl);
+			else
+				fence = fence_excl;
+		}
+	}
+
+	rcu_read_unlock();
+	if (fence) {
+		ret = fence_wait_timeout(fence, intr, ret);
+		fence_put(fence);
+		if (ret > 0 && wait_all && (i + 1 < shared_count))
+			goto retry;
+	}
+	return ret;
+
+unlock_retry:
+	rcu_read_unlock();
+	goto retry;
+}
+EXPORT_SYMBOL_GPL(reservation_object_wait_timeout_rcu);
+
+
+static inline int
+reservation_object_test_signaled_single(struct fence *passed_fence)
+{
+	struct fence *fence, *lfence = passed_fence;
+	int ret = 1;
+
+	if (!test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags)) {
+		int ret;
+
+		fence = fence_get_rcu(lfence);
+		if (!fence)
+			return -1;
+
+		ret = !!fence_is_signaled(fence);
+		fence_put(fence);
+	}
+	return ret;
+}
+
+bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
+					  bool test_all)
+{
+	unsigned seq, shared_count;
+	int ret = true;
+
+retry:
+	shared_count = 0;
+	seq = read_seqcount_begin(&obj->seq);
+	rcu_read_lock();
+
+	if (test_all) {
+		unsigned i;
+
+		struct reservation_object_list *fobj = rcu_dereference(obj->fence);
+
+		if (fobj)
+			shared_count = fobj->shared_count;
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		for (i = 0; i < shared_count; ++i) {
+			struct fence *fence = rcu_dereference(fobj->shared[i]);
+
+			ret = reservation_object_test_signaled_single(fence);
+			if (ret < 0)
+				goto unlock_retry;
+			else if (!ret)
+				break;
+		}
+
+		/*
+		 * There could be a read_seqcount_retry here, but nothing cares
+		 * about whether it's the old or newer fence pointers that are
+		 * signaled. That race could still have happened after checking
+		 * read_seqcount_retry. If you care, use ww_mutex_lock.
+		 */
+	}
+
+	if (!shared_count) {
+		struct fence *fence_excl = rcu_dereference(obj->fence_excl);
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		if (fence_excl) {
+			ret = reservation_object_test_signaled_single(fence_excl);
+			if (ret < 0)
+				goto unlock_retry;
+		}
+	}
+
+	rcu_read_unlock();
+	return ret;
+
+unlock_retry:
+	rcu_read_unlock();
+	goto retry;
+}
+EXPORT_SYMBOL_GPL(reservation_object_test_signaled_rcu);
diff --git a/include/linux/fence.h b/include/linux/fence.h
index b935cc650123..d174585b874b 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -28,6 +28,7 @@
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/printk.h>
+#include <linux/rcupdate.h>
 
 struct fence;
 struct fence_ops;
@@ -37,6 +38,7 @@ struct fence_cb;
  * struct fence - software synchronization primitive
  * @refcount: refcount for this fence
  * @ops: fence_ops associated with this fence
+ * @rcu: used for releasing fence with kfree_rcu
  * @cb_list: list of all callbacks to call
  * @lock: spin_lock_irqsave used for locking
  * @context: execution context this fence belongs to, returned by
@@ -70,6 +72,7 @@ struct fence_cb;
 struct fence {
 	struct kref refcount;
 	const struct fence_ops *ops;
+	struct rcu_head rcu;
 	struct list_head cb_list;
 	spinlock_t *lock;
 	unsigned context, seqno;
@@ -192,6 +195,20 @@ static inline struct fence *fence_get(struct fence *fence)
 }
 
 /**
+ * fence_get_rcu - get a fence from a reservation_object_list with rcu read lock
+ * @fence:	[in]	fence to increase refcount of
+ *
+ * Function returns NULL if no refcount could be obtained, or the fence.
+ */
+static inline struct fence *fence_get_rcu(struct fence *fence)
+{
+	if (kref_get_unless_zero(&fence->refcount))
+		return fence;
+	else
+		return NULL;
+}
+
+/**
  * fence_put - decreases refcount of the fence
  * @fence:	[in]	fence to reduce refcount of
  */
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index 2affe67dea6e..5a0b64cf68b4 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -42,22 +42,29 @@
 #include <linux/ww_mutex.h>
 #include <linux/fence.h>
 #include <linux/slab.h>
+#include <linux/seqlock.h>
+#include <linux/rcupdate.h>
 
 extern struct ww_class reservation_ww_class;
+extern struct lock_class_key reservation_seqcount_class;
+extern const char reservation_seqcount_string[];
 
 struct reservation_object_list {
+	struct rcu_head rcu;
 	u32 shared_count, shared_max;
-	struct fence *shared[];
+	struct fence __rcu *shared[];
 };
 
 struct reservation_object {
 	struct ww_mutex lock;
+	seqcount_t seq;
 
-	struct fence *fence_excl;
-	struct reservation_object_list *fence;
+	struct fence __rcu *fence_excl;
+	struct reservation_object_list __rcu *fence;
 	struct reservation_object_list *staged;
 };
 
+#define reservation_object_held(obj) lockdep_is_held(&(obj)->lock.base)
 #define reservation_object_assert_held(obj) \
 	lockdep_assert_held(&(obj)->lock.base)
 
@@ -66,8 +73,9 @@ reservation_object_init(struct reservation_object *obj)
 {
 	ww_mutex_init(&obj->lock, &reservation_ww_class);
 
-	obj->fence_excl = NULL;
-	obj->fence = NULL;
+	__seqcount_init(&obj->seq, reservation_seqcount_string, &reservation_seqcount_class);
+	RCU_INIT_POINTER(obj->fence, NULL);
+	RCU_INIT_POINTER(obj->fence_excl, NULL);
 	obj->staged = NULL;
 }
 
@@ -76,18 +84,20 @@ reservation_object_fini(struct reservation_object *obj)
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
-			fence_put(fobj->shared[i]);
+			fence_put(rcu_dereference_protected(fobj->shared[i], 1));
 
 		kfree(fobj);
 	}
@@ -99,17 +109,15 @@ reservation_object_fini(struct reservation_object *obj)
 static inline struct reservation_object_list *
 reservation_object_get_list(struct reservation_object *obj)
 {
-	reservation_object_assert_held(obj);
-
-	return obj->fence;
+	return rcu_dereference_protected(obj->fence,
+					 reservation_object_held(obj));
 }
 
 static inline struct fence *
 reservation_object_get_excl(struct reservation_object *obj)
 {
-	reservation_object_assert_held(obj);
-
-	return obj->fence_excl;
+	return rcu_dereference_protected(obj->fence_excl,
+					 reservation_object_held(obj));
 }
 
 int reservation_object_reserve_shared(struct reservation_object *obj);
@@ -119,4 +127,16 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
 void reservation_object_add_excl_fence(struct reservation_object *obj,
 				       struct fence *fence);
 
+int reservation_object_get_fences_rcu(struct reservation_object *obj,
+				      struct fence **pfence_excl,
+				      unsigned *pshared_count,
+				      struct fence ***pshared);
+
+long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
+					 bool wait_all, bool intr,
+					 unsigned long timeout);
+
+bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
+					  bool test_all);
+
 #endif /* _LINUX_RESERVATION_H */

