Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaGQLBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:01:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGQLB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:01:28 -0400
Date: Thu, 17 Jul 2014 04:00:03 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-e0645a111cb44e01adc6bfff34f683323863f4d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        fengguang.wu@intel.com, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        scott.norton@hp.com, maarten.lankhorst@canonical.com
In-Reply-To: <1403804351-405-2-git-send-email-Waiman.Long@hp.com>
References: <1403804351-405-2-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/lockdep:
  Restrict the use of recursive read_lock() with qrwlock
Git-Commit-ID: e0645a111cb44e01adc6bfff34f683323863f4d2
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

Commit-ID:  e0645a111cb44e01adc6bfff34f683323863f4d2
Gitweb:     http://git.kernel.org/tip/e0645a111cb44e01adc6bfff34f683323863f4d2
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Thu, 26 Jun 2014 13:39:10 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Jul 2014 12:32:52 +0200

locking/lockdep: Restrict the use of recursive read_lock() with qrwlock

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1403804351-405-2-git-send-email-Waiman.Long@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/lockdep.h  | 10 +++++++++-
 kernel/locking/lockdep.c |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f9..dadd6ba 100644
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
index 88d0d44..be83c3c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1776,6 +1776,12 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
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
