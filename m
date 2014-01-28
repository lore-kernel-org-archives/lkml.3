Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaA1TNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:13:38 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4799 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaA1TNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:13:36 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH v2 2/5] mutex: Modify the way optimistic spinners are queued
Date: Tue, 28 Jan 2014 11:13:13 -0800
Message-Id: <1390936396-3962-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex->spin_mlock was introduced in order to ensure that only 1 thread
spins for lock acquisition at a time to reduce cache line contention. When
lock->owner is NULL and the lock->count is still not 1, the spinner(s) will
continually release and obtain the lock->spin_mlock. This can generate
quite a bit of overhead/contention, and also might just delay the spinner
from getting the lock.

This patch modifies the way optimistic spinners are queued by queuing before
entering the optimistic spinning loop as oppose to acquiring before every
call to mutex_spin_on_owner(). So in situations where the spinner requires
a few extra spins before obtaining the lock, then there will only be 1 spinner
trying to get the lock and it will avoid the overhead from unnecessarily
unlocking and locking the spin_mlock.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 85c6be1..7519d27 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -419,6 +419,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct mutex_waiter waiter;
 	unsigned long flags;
 	int ret;
+	struct mspin_node node;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -449,9 +450,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
+	mspin_lock(MLOCK(lock), &node);
 	for (;;) {
 		struct task_struct *owner;
-		struct mspin_node  node;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -466,19 +467,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			 * performed the optimistic spinning cannot be done.
 			 */
 			if (ACCESS_ONCE(ww->ctx))
-				goto slowpath;
+				break;
 		}
 
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		mspin_lock(MLOCK(lock), &node);
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner)) {
-			mspin_unlock(MLOCK(lock), &node);
-			goto slowpath;
-		}
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
 
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
@@ -495,7 +493,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			preempt_enable();
 			return 0;
 		}
-		mspin_unlock(MLOCK(lock), &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -504,7 +501,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -514,6 +511,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		arch_mutex_cpu_relax();
 	}
+	mspin_unlock(MLOCK(lock), &node);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
-- 
1.7.1

