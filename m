Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaALXc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 18:32:27 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25939 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaALXbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 18:31:42 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, davidlohr@hp.com
Subject: [PATCH v6 1/5] futex: Misc cleanups
Date: Sun, 12 Jan 2014 15:31:22 -0800
Message-Id: <1389569486-25487-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
References: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Low <jason.low2@hp.com>

- Remove unnecessary head variables.
- Delete unused parameter in queue_unlock().

Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f6ff019..085f5fa 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -598,13 +598,10 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
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
@@ -986,7 +983,6 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
 
@@ -999,9 +995,8 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 
 	hb = hash_futex(&key);
 	spin_lock(&hb->lock);
-	head = &hb->chain;
 
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex (&this->key, &key)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1034,7 +1029,6 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret;
 
@@ -1082,9 +1076,7 @@ retry_private:
 		goto retry;
 	}
 
-	head = &hb1->chain;
-
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (match_futex (&this->key, &key1)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1097,10 +1089,8 @@ retry_private:
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
@@ -1270,7 +1260,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	int drop_count = 0, task_count = 0, ret;
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
-	struct plist_head *head1;
 	struct futex_q *this, *next;
 	u32 curval2;
 
@@ -1393,8 +1382,7 @@ retry_private:
 		}
 	}
 
-	head1 = &hb1->chain;
-	plist_for_each_entry_safe(this, next, head1, list) {
+	plist_for_each_entry_safe(this, next, &hb1->chain, list) {
 		if (task_count - nr_wake >= nr_requeue)
 			break;
 
@@ -1494,7 +1482,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 }
 
 static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
@@ -1867,7 +1855,7 @@ retry_private:
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (ret) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -1881,7 +1869,7 @@ retry_private:
 	}
 
 	if (uval != val) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 		ret = -EWOULDBLOCK;
 	}
 
@@ -2029,7 +2017,7 @@ retry_private:
 			 * Task is exiting and we just wait for the
 			 * exit to complete.
 			 */
-			queue_unlock(&q, hb);
+			queue_unlock(hb);
 			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
@@ -2081,7 +2069,7 @@ retry_private:
 	goto out_put_key;
 
 out_unlock_put_key:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 out_put_key:
 	put_futex_key(&q.key);
@@ -2091,7 +2079,7 @@ out:
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (ret)
@@ -2113,7 +2101,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	u32 uval, vpid = task_pid_vnr(current);
 	int ret;
@@ -2153,9 +2140,7 @@ retry:
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
-- 
1.8.1.4

