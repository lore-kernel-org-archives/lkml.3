Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3LSSqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:46:16 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17881 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3LSSqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:46:10 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, davidlohr@hp.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
Date: Thu, 19 Dec 2013 10:45:46 -0800
Message-Id: <1387478746-5436-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
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

We make sure that the futex ordering guarantees are preserved, ensuring
that waiters either observes the changed user space value before blocking or
is woken by a concurrent waker. This is done by relying on the barriers in
atomic_inc() -- for archs that do have implict mb in atomic_inc() we
explicitly add them through a set of new functions that are introduced:
futex_get_mm(), hb_waiters_inc() and hb_waiters_dec(). For more details
please refer to the updated comments in the code and related discussion:
https://lkml.org/lkml/2013/11/26/556

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
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/futex.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 122 insertions(+), 20 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index af1fc31..201af6b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -84,8 +84,11 @@
  * bucket lock. Then it looks for waiters on that futex in the hash
  * bucket and wakes them.
  *
- * Note that the spin_lock serializes waiters and wakers, so that the
- * following scenario is avoided:
+ * In scenarios where wakeups are called and no tasks are blocked on a futex,
+ * taking the hb spinlock can be avoided and simply return. In order for this
+ * optimization to work, ordering guarantees must exist so that the waiter
+ * being added to the list is acknowledged when the list is concurrently being
+ * checked by the waker, avoiding scenarios like the following:
  *
  * CPU 0                               CPU 1
  * val = *futex;
@@ -106,24 +109,49 @@
  * This would cause the waiter on CPU 0 to wait forever because it
  * missed the transition of the user space value from val to newval
  * and the waker did not find the waiter in the hash bucket queue.
- * The spinlock serializes that:
+ *
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
+ *   waiters++;
+ *   mb(); (A) <-- paired with -.
+ *                              |
+ *   lock(hash_bucket(futex));  |
+ *                              |
+ *   uval = *futex;             |
+ *                              |        *futex = newval;
+ *                              |        sys_futex(WAKE, futex);
+ *                              |          futex_wake(futex);
+ *                              |
+ *                              `------->   mb(); (B)
  *   if (uval == val)
- *      queue();
+ *     queue();
  *     unlock(hash_bucket(futex));
- *     schedule();                       if (!queue_empty())
- *                                         wake_waiters(futex);
- *                                       unlock(hash_bucket(futex));
+ *     schedule();                         if (waiters)
+ *                                           lock(hash_bucket(futex));
+ *                                           wake_waiters(futex);
+ *                                           unlock(hash_bucket(futex));
+ *
+ * Where (A) orders the waiters increment and the futex value read; and
+ * where (B) orders the write to futex and the waiters read.
+ *
+ * This yields the following case (where X:=waiters, Y:=futex):
+ *
+ *	X = Y = 0
+ *
+ *	w[X]=1		w[Y]=1
+ *	MB		MB
+ *	r[Y]=y		r[X]=x
+ *
+ * Which guarantees that x==0 && y==0 is impossible; which translates back into
+ * the guarantee that we cannot both miss the futex variable change and the
+ * enqueue.
  */
 
 int __read_mostly futex_cmpxchg_enabled;
@@ -203,6 +231,7 @@ static const struct futex_q futex_q_init = {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
+	atomic_t waiters;
 	spinlock_t lock;
 	struct plist_head chain;
 } ____cacheline_aligned_in_smp;
@@ -211,6 +240,53 @@ static unsigned long __read_mostly futex_hashsize;
 
 static struct futex_hash_bucket *futex_queues;
 
+static inline void futex_get_mm(union futex_key *key)
+{
+	atomic_inc(&key->private.mm->mm_count);
+#ifdef CONFIG_SMP
+	/*
+	 * Ensure futex_get_mm() implies a full barrier such that
+	 * get_futex_key() implies a full barrier. This is relied upon
+	 * as full barrier (B), see the ordering comment above.
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
+	 * Full barrier (A), see the ordering comment above.
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
@@ -237,6 +313,8 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
+ * Implies a full memory barrier; relied upon as (B), see the comment above
+ * about ordering.
  */
 static void get_futex_key_refs(union futex_key *key)
 {
@@ -245,10 +323,10 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode);
+		ihold(key->shared.inode); /* implies MB */
 		break;
 	case FUT_OFF_MMSHARED:
-		atomic_inc(&key->private.mm->mm_count);
+		futex_get_mm(key); /* implies MB */
 		break;
 	}
 }
@@ -292,6 +370,8 @@ static void drop_futex_key_refs(union futex_key *key)
  * We can usually work out the index without swapping in the page.
  *
  * lock_page() might sleep, the caller should not hold a spinlock.
+ *
+ * Implies a full memory barrier (B).
  */
 static int
 get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
@@ -322,7 +402,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	if (!fshared) {
 		key->private.mm = mm;
 		key->private.address = address;
-		get_futex_key_refs(key);
+		get_futex_key_refs(key); /* implies MB (B) */
 		return 0;
 	}
 
@@ -429,7 +509,7 @@ again:
 		key->shared.pgoff = basepage_index(page);
 	}
 
-	get_futex_key_refs(key);
+	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
 	unlock_page(page_head);
@@ -893,6 +973,7 @@ static void __unqueue_futex(struct futex_q *q)
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
+	hb_waiters_dec(hb);
 }
 
 /*
@@ -1052,6 +1133,11 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
+
+	/* Make sure we really have tasks to wakeup */
+	if (!hb_waiters_pending(hb))
+		goto out_put_key;
+
 	spin_lock(&hb->lock);
 
 	plist_for_each_entry_safe(this, next, &hb->chain, list) {
@@ -1072,6 +1158,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
+out_put_key:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1190,7 +1277,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
 		plist_del(&q->list, &hb1->chain);
+		hb_waiters_dec(hb1);
 		plist_add(&q->list, &hb2->chain);
+		hb_waiters_inc(hb2);
 		q->lock_ptr = &hb2->lock;
 	}
 	get_futex_key_refs(key2);
@@ -1533,17 +1622,28 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
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
@@ -2275,6 +2375,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &hb->chain);
+		hb_waiters_dec(hb);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -2290,7 +2391,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
  * @uaddr:	the futex we initially wait on (non-pi)
  * @flags:	futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, etc.), they must be
- * 		the same type, no requeueing from private to shared, etc.
+ *		the same type, no requeueing from private to shared, etc.
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
  * @bitset:	32 bit wakeup bitset set by userspace, defaults to all
@@ -2804,6 +2905,7 @@ static int __init futex_init(void)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < futex_hashsize; i++) {
+		atomic_set(&futex_queues[i].waiters, 0);
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}
-- 
1.8.1.4

