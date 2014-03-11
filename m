Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaCKMlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:41:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbaCKMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:41:48 -0400
Date: Tue, 11 Mar 2014 05:41:12 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-47667fa1502e4d759df87e9cc7fbc0f202483361@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1390936396-3962-3-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-3-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutexes:
  Modify the way optimistic spinners are queued
Git-Commit-ID: 47667fa1502e4d759df87e9cc7fbc0f202483361
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47667fa1502e4d759df87e9cc7fbc0f202483361
Gitweb:     http://git.kernel.org/tip/47667fa1502e4d759df87e9cc7fbc0f202483361
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 28 Jan 2014 11:13:13 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:14:53 +0100

locking/mutexes: Modify the way optimistic spinners are queued

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
Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: scott.norton@hp.com
Cc: chegu_vinod@hp.com
Cc: Waiman.Long@hp.com
Cc: paulmck@linux.vnet.ibm.com
Cc: torvalds@linux-foundation.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390936396-3962-3-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index e6d646b..82dad2c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -403,9 +403,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
+	mcs_spin_lock(&lock->mcs_lock, &node);
 	for (;;) {
 		struct task_struct *owner;
-		struct mcs_spinlock  node;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -420,19 +420,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -449,7 +446,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			preempt_enable();
 			return 0;
 		}
-		mcs_spin_unlock(&lock->mcs_lock, &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -458,7 +454,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -468,6 +464,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		arch_mutex_cpu_relax();
 	}
+	mcs_spin_unlock(&lock->mcs_lock, &node);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
