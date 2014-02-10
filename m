Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaBJUne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:43:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBJUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:27 -0500
Message-Id: <20140210203659.532019477@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 3/8] mutex: Modify the way optimistic spinners are queued
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=jason_low-mutex-modify_the_way_optimistic_spinners_are_queued.patch
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

Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: mingo@kernel.org
Cc: scott.norton@hp.com
Cc: chegu_vinod@hp.com
Cc: Waiman.Long@hp.com
Cc: paulmck@linux.vnet.ibm.com
Cc: torvalds@linux-foundation.org
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390936396-3962-3-git-send-email-jason.low2@hp.com
---
 kernel/locking/mutex.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -403,9 +403,9 @@ __mutex_lock_common(struct mutex *lock,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
+	mcs_spin_lock(&lock->mcs_lock);
 	for (;;) {
 		struct task_struct *owner;
-		struct mcs_spinlock  node;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -420,19 +420,16 @@ __mutex_lock_common(struct mutex *lock,
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
-		mcs_spin_lock(&lock->mcs_lock, &node);
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner)) {
-			mcs_spin_unlock(&lock->mcs_lock, &node);
-			goto slowpath;
-		}
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
 
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
@@ -445,11 +442,10 @@ __mutex_lock_common(struct mutex *lock,
 			}
 
 			mutex_set_owner(lock);
-			mcs_spin_unlock(&lock->mcs_lock, &node);
+			mcs_spin_unlock(&lock->mcs_lock);
 			preempt_enable();
 			return 0;
 		}
-		mcs_spin_unlock(&lock->mcs_lock, &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -458,7 +454,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -468,6 +464,7 @@ __mutex_lock_common(struct mutex *lock,
 		 */
 		arch_mutex_cpu_relax();
 	}
+	mcs_spin_unlock(&lock->mcs_lock);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);


