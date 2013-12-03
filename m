Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3LCJpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:45:52 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33652 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3LCJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:45:48 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com,
        davidlohr@hp.com
Subject: [PATCH v2 1/4] futex: Misc cleanups
Date: Tue,  3 Dec 2013 01:45:24 -0800
Message-Id: <1386063927-6545-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Low <jason.low2@hp.com>

- Remove unnecessary head variables.
- Delete unused parameter in queue_unlock().

Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
index 80ba086..e6ffe73 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -597,13 +597,10 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
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
@@ -985,7 +982,6 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
 
@@ -998,9 +994,8 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 
 	hb = hash_futex(&key);
 	spin_lock(&hb->lock);
-	head = &hb->chain;
 
-	plist_for_each_entry_safe(this, next, head, list) {
+	plist_for_each_entry_safe(this, next, &hb->chain, list) {
 		if (match_futex (&this->key, &key)) {
 			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
@@ -1033,7 +1028,6 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
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
@@ -1269,7 +1259,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
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
 
@@ -1493,7 +1481,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 }
 
 static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
@@ -1866,7 +1854,7 @@ retry_private:
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (ret) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -1880,7 +1868,7 @@ retry_private:
 	}
 
 	if (uval != val) {
-		queue_unlock(q, *hb);
+		queue_unlock(*hb);
 		ret = -EWOULDBLOCK;
 	}
 
@@ -2028,7 +2016,7 @@ retry_private:
 			 * Task is exiting and we just wait for the
 			 * exit to complete.
 			 */
-			queue_unlock(&q, hb);
+			queue_unlock(hb);
 			put_futex_key(&q.key);
 			cond_resched();
 			goto retry;
@@ -2080,7 +2068,7 @@ retry_private:
 	goto out_put_key;
 
 out_unlock_put_key:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 out_put_key:
 	put_futex_key(&q.key);
@@ -2090,7 +2078,7 @@ out:
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
-	queue_unlock(&q, hb);
+	queue_unlock(hb);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (ret)
@@ -2112,7 +2100,6 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
 	u32 uval, vpid = task_pid_vnr(current);
 	int ret;
@@ -2152,9 +2139,7 @@ retry:
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

