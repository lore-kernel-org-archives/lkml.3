Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3HPSrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:47:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3HPSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:47:47 -0400
Date: Fri, 16 Aug 2013 11:46:46 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-e4c711cfd32f3c74a699af3121a3b0ff631328a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gaolong@kylinos.com.cn, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gaolong@kylinos.com.cn, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20130813143325.GA5541@redhat.com>
References: <20130813143325.GA5541@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the theoretical signal_wake_up()
  vs. schedule() race
Git-Commit-ID: e4c711cfd32f3c74a699af3121a3b0ff631328a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:46:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4c711cfd32f3c74a699af3121a3b0ff631328a7
Gitweb:     http://git.kernel.org/tip/e4c711cfd32f3c74a699af3121a3b0ff631328a7
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 13 Aug 2013 16:33:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:44:54 +0200

sched: Fix the theoretical signal_wake_up() vs. schedule() race

This is only theoretical, but after try_to_wake_up(p) was changed
to check p->state under p->pi_lock the code like

	__set_current_state(TASK_INTERRUPTIBLE);
	schedule();

can miss a signal. This is the special case of wait-for-condition,
it relies on try_to_wake_up/schedule interaction and thus it does
not need mb() between __set_current_state() and if(signal_pending).

However, this __set_current_state() can move into the critical
section protected by rq->lock, now that try_to_wake_up() takes
another lock we need to ensure that it can't be reordered with
"if (signal_pending(current))" check inside that section.

The patch is actually one-liner, it simply adds smp_wmb() before
spin_lock_irq(rq->lock). This is what try_to_wake_up() already
does by the same reason.

We turn this wmb() into the new helper, smp_mb__before_spinlock(),
for better documentation and to allow the architectures to change
the default implementation.

While at it, kill smp_mb__after_lock(), it has no callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Long Gao <gaolong@kylinos.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130813143325.GA5541@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/spinlock.h |  4 ----
 include/linux/spinlock.h        | 14 +++++++++++---
 kernel/sched/core.c             | 14 +++++++++++++-
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..e3ddd7d 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -233,8 +233,4 @@ static inline void arch_write_unlock(arch_rwlock_t *rw)
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
 
-/* The {read|write|spin}_lock() on x86 are full memory barriers. */
-static inline void smp_mb__after_lock(void) { }
-#define ARCH_HAS_SMP_MB_AFTER_LOCK
-
 #endif /* _ASM_X86_SPINLOCK_H */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7d537ce..75f3494 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -117,9 +117,17 @@ do {								\
 #endif /*arch_spin_is_contended*/
 #endif
 
-/* The lock does not imply full memory barrier. */
-#ifndef ARCH_HAS_SMP_MB_AFTER_LOCK
-static inline void smp_mb__after_lock(void) { smp_mb(); }
+/*
+ * Despite its name it doesn't necessarily has to be a full barrier.
+ * It should only guarantee that a STORE before the critical section
+ * can not be reordered with a LOAD inside this section.
+ * spin_lock() is the one-way barrier, this LOAD can not escape out
+ * of the region. So the default implementation simply ensures that
+ * a STORE can not move into the critical section, smp_wmb() should
+ * serialize it with another STORE done by spin_lock().
+ */
+#ifndef smp_mb__before_spinlock
+#define smp_mb__before_spinlock()	smp_wmb()
 #endif
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cf8f100..d60b325 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1491,7 +1491,13 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	unsigned long flags;
 	int cpu, success = 0;
 
-	smp_wmb();
+	/*
+	 * If we are going to wake up a thread waiting for CONDITION we
+	 * need to ensure that CONDITION=1 done by the caller can not be
+	 * reordered with p->state check below. This pairs with mb() in
+	 * set_current_state() the waiting thread does.
+	 */
+	smp_mb__before_spinlock();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
@@ -2394,6 +2400,12 @@ need_resched:
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
+	/*
+	 * Make sure that signal_pending_state()->signal_pending() below
+	 * can't be reordered with __set_current_state(TASK_INTERRUPTIBLE)
+	 * done by the caller to avoid the race with signal_wake_up().
+	 */
+	smp_mb__before_spinlock();
 	raw_spin_lock_irq(&rq->lock);
 
 	switch_count = &prev->nivcsw;
