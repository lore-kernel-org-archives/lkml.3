Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaAOAde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:33:34 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45399 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaAOAda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:33:30 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Subject: [RFC 2/3] mutex: Modify the way optimistic spinners are queued
Date: Tue, 14 Jan 2014 16:33:09 -0800
Message-Id: <1389745990-7069-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is needed for patch 3, but should also be beneficial in general.

The mutex->spin_mlock was introduced in order to ensure that only 1 thread
loops on lock->owner field at a time to reduce cache line contention. When
lock->owner is NULL and the lock->count is still not 1, the spinner(s) will
continually release and obtain the lock->spin_mlock. This can generate
quite a bit of overhead/contention, and also might just delay the spinner
from getting the lock.

This patch modifies the way optimistic spinners are queued by queuing before
entering the optimistic spinning loop as oppose to acquiring before every
call to mutex_spin_on_owner(). So in situations where the spinner requires
extra spins before obtaining the lock, then there will only be 1 spinner
trying to get the lock and it will avoid the overhead from unnecessarily
unlocking and locking the spin_mlock.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 85c6be1..b500cc7 100644
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
@@ -465,15 +466,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			 * As such, when deadlock detection needs to be
 			 * performed the optimistic spinning cannot be done.
 			 */
-			if (ACCESS_ONCE(ww->ctx))
+			if (ACCESS_ONCE(ww->ctx)) {
+				mspin_unlock(MLOCK(lock), &node);
 				goto slowpath;
+			}
 		}
 
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		mspin_lock(MLOCK(lock), &node);
 		owner = ACCESS_ONCE(lock->owner);
 		if (owner && !mutex_spin_on_owner(lock, owner)) {
 			mspin_unlock(MLOCK(lock), &node);
@@ -495,7 +497,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			preempt_enable();
 			return 0;
 		}
-		mspin_unlock(MLOCK(lock), &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -503,8 +504,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner && (need_resched() || rt_task(task))) {
+			mspin_unlock(MLOCK(lock), &node);
 			goto slowpath;
+		}
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
-- 
1.7.1

