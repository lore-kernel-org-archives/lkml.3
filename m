Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390AbaDJPAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:00:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44111 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877AbaDJPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:00:39 -0400
Message-ID: <5346B212.8050202@canonical.com>
Date: Thu, 10 Apr 2014 17:00:34 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: [PATCH 2/2] [RFC v2 with seqcount] reservation: add suppport for
 read-only access using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com> <53466D63.8080808@canonical.com> <53467B93.3000402@vmware.com>
In-Reply-To: <53467B93.3000402@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 10-04-14 13:08, Thomas Hellstrom schreef:
> On 04/10/2014 12:07 PM, Maarten Lankhorst wrote:
>> Hey,
>>
>> op 10-04-14 10:46, Thomas Hellstrom schreef:
>>> Hi!
>>>
>>> Ugh. This became more complicated than I thought, but I'm OK with moving
>>> TTM over to fence while we sort out
>>> how / if we're going to use this.
>>>
>>> While reviewing, it struck me that this is kind of error-prone, and hard
>>> to follow since we're operating on a structure that may be
>>> continually updated under us, needing a lot of RCU-specific macros and
>>> barriers.
>> Yeah, but with the exception of dma_buf_poll I don't think there is
>> anything else
>> outside drivers/base/reservation.c has to deal with rcu.
>>
>>> Also the rcu wait appears to not complete until there are no busy fences
>>> left (new ones can be added while we wait) rather than
>>> waiting on a snapshot of busy fences.
>> This has been by design, because 'wait for bo idle' type of functions
>> only care
>> if the bo is completely idle or not.
> No, not when using RCU, because the bo may be busy again before the
> function returns :)
> Complete idleness can only be guaranteed if holding the reservation, or
> otherwise making sure
> that no new rendering is submitted to the buffer, so it's an overkill to
> wait for complete idleness here.
You're probably right, but it makes waiting a lot easier if I don't have to deal with memory allocations. :P
>> It would be easy to make a snapshot even without seqlocks, just copy
>> reservation_object_test_signaled_rcu to return a shared list if
>> test_all is set, or return pointer to exclusive otherwise.
>>
>>> I wonder if these issues can be addressed by having a function that
>>> provides a snapshot of all busy fences: This can be accomplished
>>> either by including the exclusive fence in the fence_list structure and
>>> allocate a new such structure each time it is updated. The RCU reader
>>> could then just make a copy of the current fence_list structure pointed
>>> to by &obj->fence, but I'm not sure we want to reallocate *each* time we
>>> update the fence pointer.
>> No, the most common operation is updating fence pointers, which is why
>> the current design makes that cheap. It's also why doing rcu reads is
>> more expensive.
>>> The other approach uses a seqlock to obtain a consistent snapshot, and
>>> I've attached an incomplete outline, and I'm not 100% whether it's OK to
>>> combine RCU and seqlocks in this way...
>>>
>>> Both these approaches have the benefit of hiding the RCU snapshotting in
>>> a single function, that can then be used by any waiting
>>> or polling function.
>>>
>> I think the middle way with using seqlocks to protect the fence_excl
>> pointer and shared list combination,
>> and using RCU to protect the refcounts for fences and the availability
>> of the list could work for our usecase
>> and might remove a bunch of memory barriers. But yeah that depends on
>> layering rcu and seqlocks.
>> No idea if that is allowed. But I suppose it is.
>>
>> Also, you're being overly paranoid with seqlock reading, we would only
>> need something like this:
>>
>> rcu_read_lock()
>>      preempt_disable()
>>      seq = read_seqcount_begin()
>>      read fence_excl, shared_count = ACCESS_ONCE(fence->shared_count)
>>      copy shared to a struct.
>>      if (read_seqcount_retry()) { unlock and retry }
>>    preempt_enable();
>>    use fence_get_rcu() to bump refcount on everything, if that fails
>> unlock, put, and retry
>> rcu_read_unlock()
>>
>> But the shared list would still need to be RCU'd, to make sure we're
>> not reading freed garbage.
> Ah. OK,
> But I think we should use rcu inside seqcount, because
> read_seqcount_begin() may spin for a long time if there are
> many writers. Also I don't think the preempt_disable() is needed for
> read_seq critical sections other than they might
> decrease the risc of retries..
>
Reading the seqlock code makes me suspect that's the case too. The lockdep code calls
local_irq_disable, so it's probably safe without preemption disabled.

~Maarten

I like the ability of not allocating memory, so I kept reservation_object_wait_timeout_rcu mostly
the way it was. This code appears to fail on nouveau when using the shared members,
but I'm not completely sure whether the error is in nouveau or this code yet.

--8<--------
[RFC v2] reservation: add suppport for read-only access using rcu

This adds 4 more functions to deal with rcu.

reservation_object_get_fences_rcu() will obtain the list of shared
and exclusive fences without obtaining the ww_mutex.

reservation_object_wait_timeout_rcu() will wait on all fences of the
reservation_object, without obtaining the ww_mutex.

reservation_object_test_signaled_rcu() will test if all fences of the
reservation_object are signaled without using the ww_mutex.

reservation_object_get_excl() is added because touching the fence_excl
member directly will trigger a sparse warning.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index d89a98d2c37b..ca6ef0c4b358 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
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
+	fobj = ACCESS_ONCE(resv->fence);
+	if (fobj)
+		shared_count = ACCESS_ONCE(fobj->shared_count);
+	else
+		shared_count = 0;
+	fence_excl = ACCESS_ONCE(resv->fence_excl);
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
@@ -205,13 +217,25 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
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
@@ -220,7 +244,7 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
  	}
  
  out:
-	ww_mutex_unlock(&resv->lock);
+	rcu_read_unlock();
  	return events;
  }
  
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
index b82a5b630a8e..3417382643df 100644
--- a/drivers/base/reservation.c
+++ b/drivers/base/reservation.c
@@ -38,6 +38,9 @@
  DEFINE_WW_CLASS(reservation_ww_class);
  EXPORT_SYMBOL(reservation_ww_class);
  
+struct lock_class_key reservation_seqcount_class;
+EXPORT_SYMBOL(reservation_seqcount_class);
+
  /*
   * Reserve space to add a shared fence to a reservation_object,
   * must be called with obj->lock held.
@@ -82,27 +85,28 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
  {
  	u32 i;
  
+	fence_get(fence);
+
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
+
  	for (i = 0; i < fobj->shared_count; ++i) {
  		if (fobj->shared[i]->context == fence->context) {
  			struct fence *old_fence = fobj->shared[i];
  
-			fence_get(fence);
-
  			fobj->shared[i] = fence;
+			write_seqcount_end(&obj->seq);
+			preempt_enable();
  
  			fence_put(old_fence);
  			return;
  		}
  	}
  
-	fence_get(fence);
-	fobj->shared[fobj->shared_count] = fence;
-	/*
-	 * make the new fence visible before incrementing
-	 * fobj->shared_count
-	 */
-	smp_wmb();
-	fobj->shared_count++;
+	fobj->shared[fobj->shared_count++] = fence;
+
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
  }
  
  static void
@@ -112,6 +116,7 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
  				      struct fence *fence)
  {
  	unsigned i;
+	struct fence *old_fence = NULL;
  
  	fence_get(fence);
  
@@ -130,19 +135,27 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
  	fobj->shared_count = old->shared_count;
  
  	for (i = 0; i < old->shared_count; ++i) {
-		if (fence && old->shared[i]->context == fence->context) {
-			fence_put(old->shared[i]);
+		if (!old_fence && old->shared[i]->context == fence->context) {
+			old_fence = old->shared[i];
  			fobj->shared[i] = fence;
-			fence = NULL;
  		} else
  			fobj->shared[i] = old->shared[i];
  	}
-	if (fence)
+	if (!old_fence)
  		fobj->shared[fobj->shared_count++] = fence;
  
  done:
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
  	obj->fence = fobj;
-	kfree(old);
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
@@ -168,20 +181,24 @@ EXPORT_SYMBOL(reservation_object_add_shared_fence);
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
  
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
  	obj->fence_excl = fence;
+	if (old)
+		old->shared_count = 0;
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
  
  	/* inplace update, no shared fences */
  	while (i--)
@@ -191,3 +208,236 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
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
+		unsigned seq, retry;
+
+		seq = read_seqcount_begin(&obj->seq);
+
+		rcu_read_lock();
+
+		fobj = ACCESS_ONCE(obj->fence);
+		if (fobj) {
+			struct fence **nshared;
+
+			shared_count = ACCESS_ONCE(fobj->shared_count);
+			nshared = krealloc(shared, sizeof(*shared) * shared_count, GFP_KERNEL);
+			if (!nshared) {
+				ret = -ENOMEM;
+				shared_count = retry = 0;
+				goto unlock;
+			}
+			shared = nshared;
+			memcpy(shared, fobj->shared, sizeof(*shared) * shared_count);
+		} else
+			shared_count = 0;
+		fence_excl = obj->fence_excl;
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
+		struct reservation_object_list *fobj = ACCESS_ONCE(obj->fence);
+
+		if (fobj)
+			shared_count = ACCESS_ONCE(fobj->shared_count);
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		for (i = 0; i < shared_count; ++i) {
+			struct fence *lfence = ACCESS_ONCE(fobj->shared[i]);
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
+		struct fence *fence_excl = ACCESS_ONCE(obj->fence_excl);
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
+	struct fence *fence, *lfence = ACCESS_ONCE(passed_fence);
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
+	struct fence *fence_excl;
+	struct reservation_object_list *fobj;
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
+		fobj = ACCESS_ONCE(obj->fence);
+
+		if (fobj)
+			shared_count = ACCESS_ONCE(fobj->shared_count);
+
+		if (read_seqcount_retry(&obj->seq, seq))
+			goto unlock_retry;
+
+		for (i = 0; i < shared_count; ++i) {
+			ret = reservation_object_test_signaled_single(fobj->shared[i]);
+			if (ret < 0)
+				goto unlock_retry;
+			else if (!ret)
+				break;
+		}
+
+		/*
+		 * There could be a read_seqcount_retry here, but nothing cares
+		 * about whether it's the old or newer fence pointers that are
+		 * signale. That race could still have happened after checking
+		 * read_seqcount_retry. If you care, use ww_mutex_lock.
+		 */
+	}
+
+	if (!shared_count) {
+		fence_excl = ACCESS_ONCE(obj->fence_excl);
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
index b602365c87f9..d6e1f620d1d0 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -42,16 +42,21 @@
  #include <linux/ww_mutex.h>
  #include <linux/fence.h>
  #include <linux/slab.h>
+#include <linux/seqlock.h>
+#include <linux/rcupdate.h>
  
  extern struct ww_class reservation_ww_class;
+extern struct lock_class_key reservation_seqcount_class;
  
  struct reservation_object_list {
+	struct rcu_head rcu;
  	u32 shared_count, shared_max;
  	struct fence *shared[];
  };
  
  struct reservation_object {
  	struct ww_mutex lock;
+	seqcount_t seq;
  
  	struct fence *fence_excl;
  	struct reservation_object_list *fence;
@@ -66,8 +71,9 @@ reservation_object_init(struct reservation_object *obj)
  {
  	ww_mutex_init(&obj->lock, &reservation_ww_class);
  
-	obj->fence_excl = NULL;
+	__seqcount_init(&obj->seq, "reservation_seqcount", &reservation_seqcount_class);
  	obj->fence = NULL;
+	obj->fence_excl = NULL;
  	obj->staged = NULL;
  }
  
@@ -76,13 +82,15 @@ reservation_object_fini(struct reservation_object *obj)
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
+	excl = obj->fence_excl;
+	if (excl)
+		fence_put(excl);
  
  	fobj = obj->fence;
  	if (fobj) {
@@ -104,6 +112,14 @@ reservation_object_get_list(struct reservation_object *obj)
  	return obj->fence;
  }
  
+static inline struct fence *
+reservation_object_get_excl(struct reservation_object *obj)
+{
+	reservation_object_assert_held(obj);
+
+	return obj->fence_excl;
+}
+
  int reservation_object_reserve_shared(struct reservation_object *obj);
  void reservation_object_add_shared_fence(struct reservation_object *obj,
  					 struct fence *fence);
@@ -111,4 +127,16 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
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

