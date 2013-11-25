Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3KYU7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:59:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:57365 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KYU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:14 -0500
Message-Id: <20131125203525.921463830@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC patch 3/5] futex: Split out unlock from queue_me()
References: <20131125203358.156292370@linutronix.de>
Content-Disposition: inline;
 filename=futex-split-out-unlock-from-queue-me.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for a lockless empty check of the hash bucket plist
in futex_wake().

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1548,15 +1548,14 @@ static inline void queue_unlock(struct f
  * @q:	The futex_q to enqueue
  * @hb:	The destination hash bucket
  *
- * The hb->lock must be held by the caller, and is released here. A call to
- * queue_me() is typically paired with exactly one call to unqueue_me().  The
- * exceptions involve the PI related operations, which may use unqueue_me_pi()
- * or nothing if the unqueue is done as part of the wake process and the unqueue
- * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
- * an example).
+ * The hb->lock must be held by the caller. A call to queue_me() is
+ * typically paired with exactly one call to unqueue_me(). The
+ * exceptions involve the PI related operations, which may use
+ * unqueue_me_pi() or nothing if the unqueue is done as part of the
+ * wake process and the unqueue state is implicit in the state of
+ * woken task (see futex_wait_requeue_pi() for an example).
  */
 static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
-	__releases(&hb->lock)
 {
 	int prio;
 
@@ -1573,7 +1572,6 @@ static inline void queue_me(struct futex
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
-	spin_unlock(&hb->lock);
 }
 
 /**
@@ -1834,6 +1832,11 @@ static void futex_wait_queue_me(struct f
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	queue_me(q, hb);
+	/*
+	 * Unlock _AFTER_ we queued ourself. See the comment describing
+	 * the futex ordering guarantees on top of this file.
+	 */
+	queue_unlock(hb);
 
 	/* Arm the timer */
 	if (timeout) {
@@ -2085,6 +2088,11 @@ retry_private:
 	 * Only actually queue now that the atomic ops are done:
 	 */
 	queue_me(&q, hb);
+	/*
+	 * Unlock _AFTER_ we queued ourself. See the comment describing
+	 * the futex ordering guarantees on top of this file.
+	 */
+	queue_unlock(hb);
 
 	WARN_ON(!q.pi_state);
 	/*


