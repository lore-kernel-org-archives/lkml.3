Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaAFWlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbaAFWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 072/129] sched: fix the theoretical signal_wake_up() vs schedule() race
Date: Mon,  6 Jan 2014 14:38:21 -0800
Message-Id: <20140106223901.672069653@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e0acd0a68ec7dbf6b7a81a87a867ebd7ac9b76c4 upstream.

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

Perhaps we can also add smp_mb__before/after_spinunlock() for
prepare_to_wait().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/spinlock.h |    4 ----
 include/linux/spinlock.h        |   14 +++++++++++---
 kernel/sched/core.c             |   14 +++++++++++++-
 3 files changed, 24 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -233,8 +233,4 @@ static inline void arch_write_unlock(arc
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
 
-/* The {read|write|spin}_lock() on x86 are full memory barriers. */
-static inline void smp_mb__after_lock(void) { }
-#define ARCH_HAS_SMP_MB_AFTER_LOCK
-
 #endif /* _ASM_X86_SPINLOCK_H */
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1487,7 +1487,13 @@ try_to_wake_up(struct task_struct *p, un
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
@@ -2966,6 +2972,12 @@ need_resched:
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


