Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3LJRPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:15:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3LJRPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:15:51 -0500
Date: Tue, 10 Dec 2013 18:15:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131210171530.GO12849@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386063927-6545-5-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -82,12 +82,13 @@
  * The waker side modifies the user space value of the futex and calls
  * futex_wake(). It computes the hash bucket and acquires the hash
  * bucket lock. Then it looks for waiters on that futex in the hash
- * bucket and wakes them. In scenarios where wakeups are called and no
- * tasks are blocked on a futex, taking the hb spinlock can be avoided
- * and simply return. In order for this optimization to work, ordering
- * guarantees must exist so that the waiter being added to the list is
- * acknowledged when the list is concurrently being checked by the waker,
- * avoiding scenarios like the following:
+ * bucket and wakes them.
+ *
+ * In scenarios where wakeups are called and no tasks are blocked on a futex,
+ * taking the hb spinlock can be avoided and simply return. In order for this
+ * optimization to work, ordering guarantees must exist so that the waiter
+ * being added to the list is acknowledged when the list is concurrently being
+ * checked by the waker, avoiding scenarios like the following:
  *
  * CPU 0                               CPU 1
  * val = *futex;
@@ -108,6 +109,7 @@
  * This would cause the waiter on CPU 0 to wait forever because it
  * missed the transition of the user space value from val to newval
  * and the waker did not find the waiter in the hash bucket queue.
+ *
  * The correct serialization ensures that a waiter either observes
  * the changed user space value before blocking or is woken by a
  * concurrent waker:
@@ -117,7 +119,8 @@
  * sys_futex(WAIT, futex, val);
  *   futex_wait(futex, val);
  *
- *   mb(); <-- paired with ------
+ *   waiters++;
+ *   mb(); (A) <-- paired with -.
  *                              |
  *   lock(hash_bucket(futex));  |
  *                              |
@@ -126,22 +129,29 @@
  *                              |        sys_futex(WAKE, futex);
  *                              |          futex_wake(futex);
  *                              |
- *                              -------->   mb();
+ *                              `------->   mb(); (B)
  *   if (uval == val)
  *     queue();
  *     unlock(hash_bucket(futex));
- *     schedule();                         if (!queue_empty())
+ *     schedule();                         if (waiters)
  *                                           lock(hash_bucket(futex));
  *                                           wake_waiters(futex);
  *                                           unlock(hash_bucket(futex));
  *
- * The length of the list is tracked with atomic ops (hb->waiters),
- * providing the necessary memory barriers for the waiters. For the
- * waker side, however, we rely on get_futex_key_refs(), using either
- * ihold() or the atomic_inc(), for shared futexes. The former provides
- * a full mb on all architectures. For architectures that do not have an
- * implicit barrier in atomic_inc/dec, we explicitly add it - please
- * refer to futex_get_mm() and hb_waiters_inc/dec().
+ * Where (A) orders the waiters increment and the futex value read; and
+ * where (B) orders the write to futex and the waiters read.
+ *
+ * This yields the following case (where X:=waiters, Y:=futex):
+ *
+ * 	X = Y = 0
+ *
+ *  	w[X]=1		w[Y]=1
+ * 	MB		MB
+ * 	r[Y]=y		r[X]=x
+ *
+ * Which guarantees that x==0 && y==0 is impossible; which translates back into
+ * the guarantee that we cannot both miss the futex variable change and the
+ * enqueue.
  */
 
 int __read_mostly futex_cmpxchg_enabled;
@@ -221,9 +231,7 @@ static const struct futex_q futex_q_init
  * waiting on a futex.
  */
 struct futex_hash_bucket {
-#ifdef CONFIG_SMP
 	atomic_t waiters;
-#endif
 	spinlock_t lock;
 	struct plist_head chain;
 } ____cacheline_aligned_in_smp;
@@ -237,8 +245,9 @@ static inline void futex_get_mm(union fu
 	atomic_inc(&key->private.mm->mm_count);
 #ifdef CONFIG_SMP
 	/*
-	 * Reduced to a simple barrier() where the atomic_inc
-	 * has an implicit mb().
+	 * Ensure futex_get_mm() implies a full barrier such that
+	 * get_futex_key() implies a full barrier. This is relied upon as full
+	 * barrier (B), see the ordering comment above.
 	 */
 	smp_mb__after_atomic_inc();
 #endif
@@ -252,8 +261,7 @@ static inline void hb_waiters_inc(struct
 #ifdef CONFIG_SMP
 	atomic_inc(&hb->waiters);
 	/*
-	 * Reduced to a simple barrier() where the atomic_inc
-	 * has an implicit mb().
+	 * Full barrier (A), see the ordering comment above.
 	 */
 	smp_mb__after_atomic_inc();
 #endif
@@ -267,18 +275,6 @@ static inline void hb_waiters_dec(struct
 {
 #ifdef CONFIG_SMP
 	atomic_dec(&hb->waiters);
-	/*
-	 * Reduced to a simple barrier() where the atomic_inc
-	 * has an implicit mb().
-	 *
-	 * For non-x86 archs it's debatable whether this has
-	 * a hard requirement to be guarded. The optimized
-	 * hb_waiters_pending() check for pending wakers might
-	 * fail in rare cases, but just for the cost of a
-	 * spinlock/unlock. The consistency of hb->waiters itself
-	 * is always guaranteed, i.e. it can't go below 0.
-	 */
-	smp_mb__after_atomic_dec();
 #endif
 }
 
@@ -317,6 +313,8 @@ static inline int match_futex(union fute
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
+ * Implies a full memory barrier; relied upon as (B), see the comment above
+ * about ordering.
  */
 static void get_futex_key_refs(union futex_key *key)
 {
@@ -325,10 +323,10 @@ static void get_futex_key_refs(union fut
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode);
+		ihold(key->shared.inode); /* implies MB */
 		break;
 	case FUT_OFF_MMSHARED:
-		futex_get_mm(key);
+		futex_get_mm(key); /* implies MB */
 		break;
 	}
 }
@@ -372,6 +370,8 @@ static void drop_futex_key_refs(union fu
  * We can usually work out the index without swapping in the page.
  *
  * lock_page() might sleep, the caller should not hold a spinlock.
+ *
+ * Implies a full memory barrier (B).
  */
 static int
 get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
@@ -401,7 +401,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
-		get_futex_key_refs(key);
+		get_futex_key_refs(key); /* implies MB (B) */
 		return 0;
 	}
 
@@ -508,7 +508,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 		key->shared.pgoff = basepage_index(page);
 	}
 
-	get_futex_key_refs(key);
+	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
 	unlock_page(page_head);
@@ -2904,11 +2904,9 @@ static int __init futex_init(void)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < futex_hashsize; i++) {
-		plist_head_init(&futex_queues[i].chain);
-		spin_lock_init(&futex_queues[i].lock);
-#ifdef CONFIG_SMP
 		atomic_set(&futex_queues[i].waiters, 0);
-#endif
+		spin_lock_init(&futex_queues[i].lock);
+		plist_head_init(&futex_queues[i].chain);
 	}
 
 	return 0;
