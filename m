Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaFTTXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:23:05 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1424 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaFTTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:23:03 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3] lockdep: restrict the use of recursive read_lock with qrwlock
Date: Fri, 20 Jun 2014 15:22:46 -0400
Message-Id: <1403292166-35530-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
 - Add a new read mode (3) for rwlock (used in
   lock_acquire_shared_cond_recursive()) to avoid conflict with other
   use cases of lock_acquire_shared_recursive().

v1->v2:
 - Use less conditional & make it easier to read

Unlike the original unfair rwlock implementation, queued rwlock
will grant lock according to the chronological sequence of the lock
requests except when the lock requester is in the interrupt context.
As a result, recursive read_lock calls will hang the process if there
is a write_lock call somewhere in between the read_lock calls.

This patch updates the lockdep implementation to look for recursive
read_lock calls when queued rwlock is being used.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/lockdep.h  |    4 +++-
 kernel/locking/lockdep.c |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f..0a53d88 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -481,13 +481,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
 #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
 #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
+#define lock_acquire_shared_cond_recursive(l, s, t, n, i)	\
+	lock_acquire(l, s, t, 3, 1, n, i)
 
 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
 #define spin_release(l, n, i)			lock_release(l, n, i)
 
 #define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_cond_recursive(l, s, t, NULL, i)
 #define rwlock_release(l, n, i)			lock_release(l, n, i)
 
 #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..7d90ebc 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -67,6 +67,16 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+#ifdef CONFIG_QUEUE_RWLOCK
+/*
+* Queue rwlock only allows read-after-read recursion of the same lock class
+* when the latter read is in an interrupt context.
+*/
+#define allow_recursive_read	in_interrupt()
+#else
+#define allow_recursive_read	true
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -1774,6 +1784,12 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 			return 2;
 
 		/*
+		 * Conditionally recursive read-lock check
+		 */
+		if ((read == 3) && prev->read && allow_recursive_read)
+			return 2;
+
+		/*
 		 * We're holding the nest_lock, which serializes this lock's
 		 * nesting behaviour.
 		 */
-- 
1.7.1

