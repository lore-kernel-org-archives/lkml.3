Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaA1TOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:14:08 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32701 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaA1TOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:14:06 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to spin_on_owner if need_resched() triggered while queued
Date: Tue, 28 Jan 2014 11:13:16 -0800
Message-Id: <1390936396-3962-6-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before a thread attempts mutex spin on owner, it is first added to a queue
using an MCS lock so that only 1 thread spins on owner at a time. However, when
the spinner is queued, it is unable to check if it needs to reschedule and
will remain on the queue. This could cause the spinner to spin longer
than its allocated time. However, once it is the spinner's turn to spin on
owner, it would immediately go to slowpath if it need_resched() and gets no spin
time. In these situations, not only does the spinner take up more time for a
chance to spin for the mutex, it also ends up not getting to spin once it
gets its turn.

One solution would be to exit the MCS queue and go to mutex slowpath if
need_resched(). However, that may require a lot of overhead. For instance, if a
thread at the end of the queue need_resched(), in order to remove it from the
queue, we would have to unqueue and requeue all other spinners in front of it.

This RFC patch tries to address the issue in another context by avoiding
situations where spinners immediately get sent to the slowpath on
need_resched() upon getting to spin. We will first check for need_resched()
right after acquiring the MCS lock. If need_resched() is true, then
need_resched() triggered while the thread is waiting in the MCS queue (since
patch 1 makes the spinner check for need_resched() before entering the queue).
In this case, we will allow the thread to have at least 1 try to do
mutex_spin_on_owner() regardless of need_resched(). This patch also removes
the need_resched() in the outer loop in case we require a few extra spins to
observe lock->count == 1, and patch 4 ensures we won't be spinning with
lock owner preempted.

And if the need_resched() check after acquiring the MCS lock is false, then
we won't give the spinner any extra spinning.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index cfaaf53..2281a48 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -187,11 +187,11 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
  * access and not reliable.
  */
 static noinline
-int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner, int spin_grace_period)
 {
 	rcu_read_lock();
 	while (owner_running(lock, owner)) {
-		if (need_resched())
+		if (need_resched() && !spin_grace_period)
 			break;
 
 		arch_mutex_cpu_relax();
@@ -428,7 +428,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
-	int ret;
+	int ret, spin_grace_period;
 	struct mspin_node node;
 
 	preempt_disable();
@@ -461,6 +461,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		goto slowpath;
 
 	mspin_lock(MLOCK(lock), &node);
+	/*
+	 * If need_resched() triggered while queued, then we will still give
+	 * this spinner a chance to spin for the mutex, rather than send this
+	 * immediately to slowpath after waiting for its turn.
+	 */
+	spin_grace_period = (need_resched()) ? 1 : 0;
 	for (;;) {
 		struct task_struct *owner;
 
@@ -485,8 +491,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * release the lock or go to sleep.
 		 */
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
-			break;
+		if (owner) {
+			if (!mutex_spin_on_owner(lock, owner, spin_grace_period))
+				break;
+
+			spin_grace_period = 0;
+		}
 
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
@@ -510,7 +520,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && rt_task(task))
 			break;
 
 		/*
-- 
1.7.1

