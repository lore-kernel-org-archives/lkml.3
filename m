Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3KYU7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:59:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:57358 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3KYU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:13 -0500
Message-Id: <20131125203525.664205555@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:09 -0000
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
Subject: [RFC patch 1/5] futex: Misc cleanups
References: <20131125203358.156292370@linutronix.de>
Content-Disposition: inline; filename=futex-misc-cleanups.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Low <jason.low2@hp.com>

- Remove unnecessary head variables.
- Delete unused parameter in queue_unlock().

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Link: http://lkml.kernel.org/r/1385168197-8612-2-git-send-email-davidlohr@hp.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -597,13 +597,10 @@ lookup_pi_state(u32 uval, struct futex_h
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	struct task_struct *p;
 	pid_t pid = uval & FUTEX_TID_MASK;
 
-	head = &hb->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex(&this->key, key)) {
 			/*
 			 * Another waiter already exists - bump up
@@ -985,7 +982,6 @@ futex_wake(u32 __user *uaddr, unsigned i
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
 
@@ -998,9 +994,8 @@ futex_wake(u32 __user *uaddr, unsigned i
 
 	hb = hash_futex(&key);
 	spin_lock(&hb->lock);
-	head = &hb->chain;
 
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex (&this->key, &key)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1033,7 +1028,6 @@ futex_wake_op(u32 __user *uaddr1, unsign
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret;
 
@@ -1081,9 +1075,7 @@ retry_private:
 		goto retry;
 	}
 
-	head = &hb1->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (match_futex (&this->key, &key1)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1096,10 +1088,8 @@ retry_private:
 	}
 
 	if (op_ret > 0) {
-		head = &hb2->chain;
-
 		op_ret = 0;
-		plist_for_each_entry_safe(this, next, head, list) {
+		plist_for_each_entry_safe(this, next, &hb2->chain, list) {
 			if (match_futex (&this->key, &key2)) {
 				if (this->pi_state || this->rt_waiter) {
 					ret = -EINVAL;
@@ -1269,7 +1259,6 @@ static int futex_requeue(u32 __user *uad
 	int drop_count = 0, task_count = 0, ret;
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head1;
 	struct futex_q *this, *next;
 	u32 curval2;
 
@@ -1392,8 +1381,7 @@ retry_private:
 		}
 	}
 
-	head1 = &hb1->chain;
-	plist_for_each_entry_safe(this, next, head1, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (task_count - nr_wake >= nr_requeue)
 			break;
 
@@ -1492,8 +1480,7 @@ static inline struct futex_hash_bucket *
 	return hb;
 }
 
-static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+static inline void queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
@@ -1866,7 +1853,7 @@ retry_private:
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (ret) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -1880,7 +1867,7 @@ retry_private:
 	}
 
 	if (uval != val) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 		ret = -EWOULDBLOCK;
 	}
 
@@ -2028,7 +2015,7 @@ retry_private:
 			 * Task is exiting and we just wait for the
 			 * exit to complete.
 			 */
-			queue_unlock(&q, hb);
+			queue_unlock(hb);
 			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
@@ -2080,7 +2067,7 @@ retry_private:
 	goto out_put_key;
 
 out_unlock_put_key:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 out_put_key:
 	put_futex_key(&q.key);
@@ -2090,7 +2077,7 @@ out:
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (ret)
@@ -2112,7 +2099,6 @@ static int futex_unlock_pi(u32 __user *u
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	u32 uval, vpid = task_pid_vnr(current);
 	int ret;
@@ -2152,9 +2138,7 @@ retry:
 	 * Ok, other tasks may need to be woken up - check waiters
 	 * and do the wakeup if necessary:
 	 */
-	head = &hb->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (!match_futex (&this->key, &key))
 			continue;
 		ret = wake_futex_pi(uaddr, uval, this);


