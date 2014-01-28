Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaA1TXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:23:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbaA1TXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:23:41 -0500
Date: Tue, 28 Jan 2014 11:23:07 -0800
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-5faeb8adb956a5ad6579c4e309e8689943ad8294@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <1390347365.3138.64.camel@schen9-DESK>
References: <1390347365.3138.64.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mcs: Micro-optimize the MCS code,
  add extra comments
Git-Commit-ID: 5faeb8adb956a5ad6579c4e309e8689943ad8294
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:23:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5faeb8adb956a5ad6579c4e309e8689943ad8294
Gitweb:     http://git.kernel.org/tip/5faeb8adb956a5ad6579c4e309e8689943ad8294
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 21 Jan 2014 15:36:05 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:13:28 +0100

locking/mcs: Micro-optimize the MCS code, add extra comments

Remove unnecessary operation to assign locked status to 1 if lock is
acquired without contention. Lock status will not be checked by lock
holder again once it is acquired and any lock
contenders will not be looking at the lock holder's lock status.

Make the cmpxchg(lock, node, NULL) == node check in mcs_spin_unlock()
likely() as it is likely that a race did not occur most of the time.

Also add in more comments describing how the local node is used in MCS locks.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1390347365.3138.64.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mcs_spinlock.h | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index 9578ef8..143fa42 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -25,6 +25,17 @@ struct mcs_spinlock {
  * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
  * used after mcs_lock.
  */
+
+/*
+ * In order to acquire the lock, the caller should declare a local node and
+ * pass a reference of the node to this function in addition to the lock.
+ * If the lock has already been acquired, then this will proceed to spin
+ * on this node->locked until the previous lock holder sets the node->locked
+ * in mcs_spin_unlock().
+ *
+ * We don't inline mcs_spin_lock() so that perf can correctly account for the
+ * time spent in this lock function.
+ */
 static inline
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
@@ -36,8 +47,14 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 
 	prev = xchg(lock, node);
 	if (likely(prev == NULL)) {
-		/* Lock acquired */
-		node->locked = 1;
+		/*
+		 * Lock acquired, don't need to set node->locked to 1. Threads
+		 * only spin on its own node->locked value for lock acquisition.
+		 * However, since this thread can immediately acquire the lock
+		 * and does not proceed to spin on its own node->locked, this
+		 * value won't be used. If a debug mode is needed to
+		 * audit lock status, then set node->locked value here.
+		 */
 		return;
 	}
 	ACCESS_ONCE(prev->next) = node;
@@ -50,6 +67,10 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		arch_mutex_cpu_relax();
 }
 
+/*
+ * Releases the lock. The caller should pass in the corresponding node that
+ * was used to acquire the lock.
+ */
 static inline
 void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
@@ -59,7 +80,7 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		/*
 		 * Release the lock by setting it to NULL
 		 */
-		if (cmpxchg(lock, node, NULL) == node)
+		if (likely(cmpxchg(lock, node, NULL) == node))
 			return;
 		/* Wait until the next pointer is set */
 		while (!(next = ACCESS_ONCE(node->next)))
