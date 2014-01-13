Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaAMPxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:53:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaAMPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:53:37 -0500
Date: Mon, 13 Jan 2014 07:52:30 -0800
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-0d00c7b20c7716ce08399570ea48813ecf001aa8@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, jason.low2@hp.com, Waiman.Long@hp.com,
        akpm@linux-foundation.org, tglx@linutronix.de, scott.norton@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        dvhart@linux.intel.com, paulmck@linux.vnet.ibm.com, tom.vaden@hp.com,
        jeffm@suse.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, efault@gmx.de, jason.low2@hp.com,
        Waiman.Long@hp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        davidlohr@hp.com, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, dvhart@linux.intel.com, paulmck@linux.vnet.ibm.com,
        tom.vaden@hp.com, jeffm@suse.com, aswin@hp.com
In-Reply-To: <1389569486-25487-2-git-send-email-davidlohr@hp.com>
References: <1389569486-25487-2-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futexes: Clean up various details
Git-Commit-ID: 0d00c7b20c7716ce08399570ea48813ecf001aa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:52:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d00c7b20c7716ce08399570ea48813ecf001aa8
Gitweb:     http://git.kernel.org/tip/0d00c7b20c7716ce08399570ea48813ecf001aa8
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Sun, 12 Jan 2014 15:31:22 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 11:45:17 +0100

futexes: Clean up various details

- Remove unnecessary head variables.
- Delete unused parameter in queue_unlock().

Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1389569486-25487-2-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
