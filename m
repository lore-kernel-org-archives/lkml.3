Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbaCTPGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:06:48 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25692 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaCTPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:06:46 -0400
Message-ID: <1395328003.2612.15.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, paulus@samba.org,
        tglx@linutronix.de, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org
Date: Thu, 20 Mar 2014 08:06:43 -0700
In-Reply-To: <20140320100848.GC10406@linux.vnet.ibm.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <20140320100848.GC10406@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 15:38 +0530, Srikar Dronamraju wrote:
> > This problem suggests that we missed a wakeup for a task that was adding
> > itself to the queue in a wait path. And the only place that can happen
> > is with the hb spinlock check for any pending waiters. Just in case we
> > missed some assumption about checking the hash bucket spinlock as a way
> > of detecting any waiters (powerpc?), could you revert this commit and
> > try the original atomic operations variant:
> > 
> > https://lkml.org/lkml/2013/12/19/630
> 
> I think the above url and the commit id that I reverted i.e
> git://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b0c29f79ecea0b6fbcefc999
> are the same.
> 
> Or am I missing something? 

No, please take a closer look, it is a different approaches to the same
end.

diff --git a/kernel/futex.c b/kernel/futex.c
index 34ecd9d..35ff697 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -203,6 +203,7 @@ static const struct futex_q futex_q_init = {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
+	atomic_t waiters;
 	spinlock_t lock;
 	struct plist_head chain;
 } ____cacheline_aligned_in_smp;
@@ -211,6 +212,53 @@ static unsigned long __read_mostly futex_hashsize;
 
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
@@ -245,10 +293,10 @@ static void get_futex_key_refs(union futex_key *key)
 
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
@@ -322,7 +370,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	if (!fshared) {
 		key->private.mm = mm;
 		key->private.address = address;
-		get_futex_key_refs(key);
+		get_futex_key_refs(key); /* implies MB (B) */
 		return 0;
 	}
 
@@ -429,7 +477,7 @@ again:
 		key->shared.pgoff = basepage_index(page);
 	}
 
-	get_futex_key_refs(key);
+	get_futex_key_refs(key); /* implies MB (B) */
 
 out:
 	unlock_page(page_head);
@@ -893,6 +941,7 @@ static void __unqueue_futex(struct futex_q *q)
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
+	hb_waiters_dec(hb);
 }
 
 /*
@@ -1052,6 +1101,11 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
+
+	/* Make sure we really have tasks to wakeup */
+	if (!hb_waiters_pending(hb))
+		goto out_put_key;
+
 	spin_lock(&hb->lock);
 
 	plist_for_each_entry_safe(this, next, &hb->chain, list) {
@@ -1072,6 +1126,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
+out_put_key:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1190,7 +1245,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
 		plist_del(&q->list, &hb1->chain);
+		hb_waiters_dec(hb1);
 		plist_add(&q->list, &hb2->chain);
+		hb_waiters_inc(hb2);
 		q->lock_ptr = &hb2->lock;
 	}
 	get_futex_key_refs(key2);
@@ -1533,6 +1590,17 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
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
@@ -1544,6 +1612,7 @@ queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
+	hb_waiters_dec(hb);
 }
 
 /**
@@ -2275,6 +2344,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &hb->chain);
+		hb_waiters_dec(hb);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -2808,6 +2878,7 @@ static int __init futex_init(void)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < futex_hashsize; i++) {
+		atomic_set(&futex_queues[i].waiters, 0);
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}



