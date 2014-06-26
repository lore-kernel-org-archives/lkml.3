Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaFZRjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:39:37 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:3992 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbaFZRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:39:35 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 1/2] lockdep: restrict the use of recursive read_lock with qrwlock
Date: Thu, 26 Jun 2014 13:39:10 -0400
Message-Id: <1403804351-405-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
References: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the original unfair rwlock implementation, queued rwlock
will grant lock according to the chronological sequence of the lock
requests except when the lock requester is in the interrupt context.
Consequently, recursive read_lock calls will now hang the process if
there is a write_lock call somewhere in between the read_lock calls.

This patch updates the lockdep implementation to look for recursive
read_lock calls when queued rwlock is being used. A new read state (3)
is used to mark those read_lock call that cannot be recursively called
except in the interrupt context. The new read state does exhaust the
2 bits available in held_lock:read bit field. The addition of any new
read state in the future may require a redesign of how all those bits
are squeezed together in the held_lock structure.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/lockdep.h  |   12 ++++++++++++
 kernel/locking/lockdep.c |    6 ++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f..c7fd62d 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -478,16 +478,28 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
+/*
+ * Read states in the 2-bit held_lock:read field:
+ *  0: Exclusive lock
+ *  1: Shareable lock, cannot be recursively called
+ *  2: Shareable lock, can be recursively called
+ *  3: Shareable lock, cannot be recursively called except in interrupt context
+ */
 #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
 #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
 #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
+#define lock_acquire_shared_irecursive(l, s, t, n, i)	lock_acquire(l, s, t, 3, 1, n, i)
 
 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
 #define spin_release(l, n, i)			lock_release(l, n, i)
 
 #define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#ifdef CONFIG_QUEUE_RWLOCK
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_irecursive(l, s, t, NULL, i)
+#else
 #define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#endif
 #define rwlock_release(l, n, i)			lock_release(l, n, i)
 
 #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..879bb4c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1774,6 +1774,12 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 			return 2;
 
 		/*
+		 * Recursive read-lock allowed only in interrupt context
+		 */
+		if ((read == 3) && prev->read && in_interrupt())
+			return 2;
+
+		/*
 		 * We're holding the nest_lock, which serializes this lock's
 		 * nesting behaviour.
 		 */
-- 
1.7.1

