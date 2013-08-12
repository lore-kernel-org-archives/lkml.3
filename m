Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3HLRJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:09:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343Ab3HLRJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:09:19 -0400
Date: Mon, 12 Aug 2013 19:02:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] sched: fix the theoretical signal_wake_up() vs schedule()
	race
Message-ID: <20130812170257.GA32358@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com> <20130808191749.GA12062@redhat.com> <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com> <20130809130457.GA27493@redhat.com> <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/spinlock.h |    4 ----
 include/linux/spinlock.h        |   13 ++++++++++---
 kernel/sched/core.c             |   14 +++++++++++++-
 3 files changed, 23 insertions(+), 8 deletions(-)

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
index 7d537ce..f21551e 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -117,9 +117,16 @@ do {								\
 #endif /*arch_spin_is_contended*/
 #endif
 
-/* The lock does not imply full memory barrier. */
-#ifndef ARCH_HAS_SMP_MB_AFTER_LOCK
-static inline void smp_mb__after_lock(void) { smp_mb(); }
+/*
+ * Despite its name it doesn't necessarily has to be a full barrier.
+ * It should only guarantee that a STORE before the critical section
+ * can not be reordered with a LOAD inside this section.
+ * So the default implementation simply ensures that a STORE can not
+ * move into the critical section, smp_wmb() should serialize it with
+ * another STORE done by spin_lock().
+ */
+#ifndef smp_mb__before_spinlock
+#define smp_mb__before_spinlock()	smp_wmb()
 #endif
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6df0fbe..97dac0e 100644
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
-- 
1.5.5.1


