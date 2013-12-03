Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3LCJp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:45:57 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33695 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3LCJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:45:53 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com,
        davidlohr@hp.com
Subject: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Date: Tue,  3 Dec 2013 01:45:27 -0800
Message-Id: <1386063927-6545-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In futex_wake() there is clearly no point in taking the hb->lock if
we know beforehand that there are no tasks to be woken. This comes
at the smaller cost of doing some atomic operations to keep track of
the list's size. Specifically, increment the counter when an element is
added to the list, and decrement when it is removed. Of course, if the
counter is 0, then there are no tasks blocked on a futex. Some special
considerations:

- increment the counter at queue_lock() as we always end up calling
  queue_me() which adds the element to the list. Upon any error,
  queue_unlock() is called for housekeeping, for which we decrement
  to mach the increment done in queue_lock().

- decrement the counter at __unqueue_me() to reflect when an element is
  removed from the queue for wakeup related purposes.

With the new atomic counter we only enlarge the futex_hash_bucket struct
by 4 bytes on 32bit systems, and it is left the same size for 64bit
ones, at 24 bytes.

More important, we make sure that the futex ordering guarantees are preserved,
ensuring that waiters either observes the changed user space value before
blocking or is woken by a concurrent waker. This is done by relying on the
barriers in atomic_inc() -- for archs that do have implict mb in atomic_inc()
we explicitly add them through a set of new functions that are introduced:
futex_get_mm(), hb_waiters_inc(x) and hb_waiters_dec().
For more details please refer to the updated comments in the code and related
discussion: https://lkml.org/lkml/2013/11/26/556

Furthermore, the overhead of new barriers is trivial. The following are some
results, from a quad-core x86_64 laptop, measuring the latency of nthread
wakeups (1 at a time), for 1000 runs:

+----------+-----------------------------+------------------------------+
| nthreads | baseline time (ms) [stddev] | atomicops time (ms) [stddev] |
+----------+-----------------------------+------------------------------+
|      512 | 2.8360 [0.5168]             | 3.8150 [1.3293]              |
|      256 | 2.5080 [0.6375]             | 2.5980 [0.9079]              |
|      128 | 1.0200 [0.4264]             | 1.5180 [0.4902]              |
|       64 | 0.7890 [0.2667]             | 0.4020 [0.2447]              |
|       32 | 0.1150 [0.0184]             | 0.1490 [0.1156]              |
+----------+-----------------------------+------------------------------+

Special thanks to tglx for careful review and feedback.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 122 insertions(+), 18 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 75719bd..53ce28f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -82,10 +82,12 @@
  * The waker side modifies the user space value of the futex and calls
  * futex_wake(). It computes the hash bucket and acquires the hash
  * bucket lock. Then it looks for waiters on that futex in the hash
- * bucket and wakes them.
- *
- * Note that the spin_lock serializes waiters and wakers, so that the
- * following scenario is avoided:
+ * bucket and wakes them. In scenarios where wakeups are called and no
+ * tasks are blocked on a futex, taking the hb spinlock can be avoided
+ * and simply return. In order for this optimization to work, ordering
+ * guarantees must exist so that the waiter being added to the list is
+ * acknowledged when the list is concurrently being checked by the waker,
+ * avoiding scenarios like the following:
  *
  * CPU 0                               CPU 1
  * val = *futex;
@@ -106,24 +108,40 @@
  * This would cause the waiter on CPU 0 to wait forever because it
  * missed the transition of the user space value from val to newval
  * and the waker did not find the waiter in the hash bucket queue.
- * The spinlock serializes that:
+ * The correct serialization ensures that a waiter either observes
+ * the changed user space value before blocking or is woken by a
+ * concurrent waker:
  *
  * CPU 0                               CPU 1
  * val = *futex;
  * sys_futex(WAIT, futex, val);
  *   futex_wait(futex, val);
- *   lock(hash_bucket(futex));
- *   uval = *futex;
- *                                     *futex = newval;
- *                                     sys_futex(WAKE, futex);
- *                                       futex_wake(futex);
- *                                       lock(hash_bucket(futex));
+ *
+ *   mb(); <-- paired with ------
+ *                              |
+ *   lock(hash_bucket(futex));  |
+ *                              |
+ *   uval = *futex;             |
+ *                              |        *futex = newval;
+ *                              |        sys_futex(WAKE, futex);
+ *                              |          futex_wake(futex);
+ *                              |
+ *                              -------->   mb();
  *   if (uval == val)
- *      queue();
+ *     queue();
  *     unlock(hash_bucket(futex));
- *     schedule();                       if (!queue_empty())
- *                                         wake_waiters(futex);
- *                                       unlock(hash_bucket(futex));
+ *     schedule();                         if (!queue_empty())
+ *                                           lock(hash_bucket(futex));
+ *                                           wake_waiters(futex);
+ *                                           unlock(hash_bucket(futex));
+ *
+ * The length of the list is tracked with atomic ops (hb->waiters),
+ * providing the necessary memory barriers for the waiters. For the
+ * waker side, however, we rely on get_futex_key_refs(), using either
+ * ihold() or the atomic_inc(), for shared futexes. The former provides
+ * a full mb on all architectures. For architectures that do not have an
+ * implicit barrier in atomic_inc/dec, we explicitly add it - please
+ * refer to futex_get_mm() and hb_waiters_inc/dec().
  */
 
 int __read_mostly futex_cmpxchg_enabled;
@@ -203,6 +221,9 @@ static const struct futex_q futex_q_init = {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
+#ifdef CONFIG_SMP
+	atomic_t waiters;
+#endif
 	spinlock_t lock;
 	struct plist_head chain;
 } ____cacheline_aligned_in_smp;
@@ -211,6 +232,65 @@ static unsigned long __read_mostly futex_hashsize;
 
 static struct futex_hash_bucket *futex_queues;
 
+static inline void futex_get_mm(union futex_key *key)
+{
+	atomic_inc(&key->private.mm->mm_count);
+#ifdef CONFIG_SMP
+	/*
+	 * Reduced to a simple barrier() where the atomic_inc
+	 * has an implicit mb().
+	 */
+	smp_mb__after_atomic_inc();
+#endif
+}
+
+/*
+ * Reflects a new waiter being added to the waitqueue.
+ */
+static inline void hb_waiters_inc(struct futex_hash_bucket *hb)
+{
+#ifdef CONFIG_SMP
+	atomic_inc(&hb->waiters);
+	/*
+	 * Reduced to a simple barrier() where the atomic_inc
+	 * has an implicit mb().
+	 */
+	smp_mb__after_atomic_inc();
+#endif
+}
+
+/*
+ * Reflects a waiter being removed from the waitqueue by wakeup
+ * paths.
+ */
+static inline void hb_waiters_dec(struct futex_hash_bucket *hb)
+{
+#ifdef CONFIG_SMP
+	atomic_dec(&hb->waiters);
+	/*
+	 * Reduced to a simple barrier() where the atomic_inc
+	 * has an implicit mb().
+	 *
+	 * For non-x86 archs it's debatable whether this has
+	 * a hard requirement to be guarded. The optimized
+	 * hb_waiters_pending() check for pending wakers might
+	 * fail in rare cases, but just for the cost of a
+	 * spinlock/unlock. The consistency of hb->waiters itself
+	 * is always guaranteed, i.e. it can't go below 0.
+	 */
+	smp_mb__after_atomic_dec();
+#endif
+}
+
+static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
+{
+#ifdef CONFIG_SMP
+	return atomic_read(&hb->waiters);
+#else
+	return 1;
+#endif
+}
+
 /*
  * We hash on the keys returned from get_futex_key (see below).
  */
@@ -248,7 +328,7 @@ static void get_futex_key_refs(union futex_key *key)
 		ihold(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
-		atomic_inc(&key->private.mm->mm_count);
+		futex_get_mm(key);
 		break;
 	}
 }
@@ -892,6 +972,7 @@ static void __unqueue_futex(struct futex_q *q)
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
+	hb_waiters_dec(hb);
 }
 
 /*
@@ -1051,6 +1132,11 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
+
+	/* Make sure we really have tasks to wakeup */
+	if (!hb_waiters_pending(hb))
+		goto out_put_key;
+
 	spin_lock(&hb->lock);
 
 	plist_for_each_entry_safe(this, next, &hb->chain, list) {
@@ -1071,6 +1157,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
+out_put_key:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1189,7 +1276,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
 		plist_del(&q->list, &hb1->chain);
+		hb_waiters_dec(hb1);
 		plist_add(&q->list, &hb2->chain);
+		hb_waiters_inc(hb2);
 		q->lock_ptr = &hb2->lock;
 	}
 	get_futex_key_refs(key2);
@@ -1532,17 +1621,28 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	struct futex_hash_bucket *hb;
 
 	hb = hash_futex(&q->key);
+
+	/*
+	 * Increment the counter before taking the lock so that
+	 * a potential waker won't miss a to-be-slept task that is
+	 * waiting for the spinlock. This is safe as all queue_lock()
+	 * users end up calling queue_me(). Similarly, for housekeeping,
+	 * decrement the counter at queue_unlock() when some error has
+	 * occurred and we don't end up adding the task to the list.
+	 */
+	hb_waiters_inc(hb);
+
 	q->lock_ptr = &hb->lock;
 
 	spin_lock(&hb->lock);
 	return hb;
 }
 
-static inline void
-queue_unlock(struct futex_hash_bucket *hb)
+static inline void queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
+	hb_waiters_dec(hb);
 }
 
 /**
@@ -2274,6 +2374,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &hb->chain);
+		hb_waiters_dec(hb);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -2805,6 +2906,9 @@ static int __init futex_init(void)
 	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
+#ifdef CONFIG_SMP
+		atomic_set(&futex_queues[i].waiters, 0);
+#endif
 	}
 
 	return 0;
-- 
1.8.1.4

