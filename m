Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaHMK6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:58:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaHMK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:58:05 -0400
Date: Wed, 13 Aug 2014 03:56:56 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-f0bab73cb539fb803c4d419951e8d28aa4964f8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        scott.norton@hp.com, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        fengguang.wu@intel.com, maarten.lankhorst@canonical.com
In-Reply-To: <1407345722-61615-2-git-send-email-Waiman.Long@hp.com>
References: <1407345722-61615-2-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/lockdep:
  Restrict the use of recursive read_lock() with qrwlock
Git-Commit-ID: f0bab73cb539fb803c4d419951e8d28aa4964f8f
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

Commit-ID:  f0bab73cb539fb803c4d419951e8d28aa4964f8f
Gitweb:     http://git.kernel.org/tip/f0bab73cb539fb803c4d419951e8d28aa4964f8f
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Wed, 6 Aug 2014 13:22:01 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:33:34 +0200

locking/lockdep: Restrict the use of recursive read_lock() with qrwlock

Unlike the original unfair rwlock implementation, queued rwlock
will grant lock according to the chronological sequence of the lock
requests except when the lock requester is in the interrupt context.
Consequently, recursive read_lock calls will now hang the process if
there is a write_lock call somewhere in between the read_lock calls.

This patch updates the lockdep implementation to look for recursive
read_lock calls. A new read state (3) is used to mark those read_lock
call that cannot be recursively called except in the interrupt
context. The new read state does exhaust the 2 bits available in
held_lock:read bit field. The addition of any new read state in the
future may require a redesign of how all those bits are squeezed
together in the held_lock structure.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407345722-61615-2-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/lockdep.h  | 10 +++++++++-
 kernel/locking/lockdep.c |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f388481..b5a84b62 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -478,16 +478,24 @@ static inline void print_irqtrace_events(struct task_struct *curr)
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
-#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_irecursive(l, s, t, NULL, i)
 #define rwlock_release(l, n, i)			lock_release(l, n, i)
 
 #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 88d0d44..420ba68 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3597,6 +3597,12 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
+	/*
+	 * An interrupt recursive read in interrupt context can be considered
+	 * to be the same as a recursive read from checking perspective.
+	 */
+	if ((read == 3) && in_interrupt())
+		read = 2;
 	current->lockdep_recursion = 1;
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 	__lock_acquire(lock, subclass, trylock, read, check,
