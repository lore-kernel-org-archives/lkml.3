Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3KWA46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:56:58 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:41098 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3KWA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:56:54 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com, davidlohr@hp.com
Subject: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
Date: Fri, 22 Nov 2013 16:56:36 -0800
Message-Id: <1385168197-8612-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
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

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
 kernel/futex.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5fa9eb0..2f9dd5d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -152,6 +152,7 @@ static const struct futex_q futex_q_init = {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
+	atomic_t len;
 	spinlock_t lock;
 	struct plist_head chain;
 };
@@ -843,6 +844,7 @@ static void __unqueue_futex(struct futex_q *q)
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
+	atomic_dec(&hb->len);
 }
 
 /*
@@ -999,6 +1001,10 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 		goto out;
 
 	hb = hash_futex(&key);
+	/* make sure we really have tasks to wakeup */
+	if (atomic_read(&hb->len) == 0)
+		goto out_put_key;
+
 	spin_lock(&hb->lock);
 
 	plist_for_each_entry_safe(this, next, &hb->chain, list) {
@@ -1019,6 +1025,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
+out_put_key:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1137,7 +1144,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
 		plist_del(&q->list, &hb1->chain);
+		atomic_dec(&hb1->len);
 		plist_add(&q->list, &hb2->chain);
+		atomic_inc(&hb2->len);
 		q->lock_ptr = &hb2->lock;
 	}
 	get_futex_key_refs(key2);
@@ -1480,6 +1489,8 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	struct futex_hash_bucket *hb;
 
 	hb = hash_futex(&q->key);
+	atomic_inc(&hb->len);
+
 	q->lock_ptr = &hb->lock;
 
 	spin_lock(&hb->lock);
@@ -1491,6 +1502,7 @@ queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
+	atomic_dec(&hb->len);
 }
 
 /**
@@ -2222,6 +2234,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &hb->chain);
+		atomic_dec(&hb->len);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -2749,6 +2762,7 @@ static int __init futex_init(void)
 	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
+		atomic_set(&futex_queues[i].len, 0);
 	}
 
 	return 0;
-- 
1.8.1.4

