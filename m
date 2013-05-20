Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3ETQCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:12 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63769 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab3ETQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:06 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
Date: Mon, 20 May 2013 18:01:50 +0200
Message-Id: <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While computing the cputime delta of dynticks CPUs,
we are mixing up clocks of differents natures:

* local_clock() which takes care of unstable clock
sources and fix these if needed.

* sched_clock() which is the weaker version of
local_clock(). It doesn't compute any fixup in case
of unstable source.

If the clock source is stable, those two clocks are the
same and we can safely compute the difference against
two random points.

Otherwise it results in random deltas as sched_clock()
can randomly drift away, back or forward, from local_clock().

As a consequence, some strange behaviour with unstable tsc
has been observed such as non progressing constant zero cputime.
(The 'top' command showing no load).

Fix this by only using local_clock(), or its irq safe/remote
equivalent, in vtime code.

Reported-by: Mike Galbraith <efault@gmx.de>
Suggested-by: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/vtime.h  |    4 ++--
 kernel/sched/core.c    |    2 +-
 kernel/sched/cputime.c |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 71a5782..b1dd2db 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -34,7 +34,7 @@ static inline void vtime_user_exit(struct task_struct *tsk)
 }
 extern void vtime_guest_enter(struct task_struct *tsk);
 extern void vtime_guest_exit(struct task_struct *tsk);
-extern void vtime_init_idle(struct task_struct *tsk);
+extern void vtime_init_idle(struct task_struct *tsk, int cpu);
 #else
 static inline void vtime_account_irq_exit(struct task_struct *tsk)
 {
@@ -45,7 +45,7 @@ static inline void vtime_user_enter(struct task_struct *tsk) { }
 static inline void vtime_user_exit(struct task_struct *tsk) { }
 static inline void vtime_guest_enter(struct task_struct *tsk) { }
 static inline void vtime_guest_exit(struct task_struct *tsk) { }
-static inline void vtime_init_idle(struct task_struct *tsk) { }
+static inline void vtime_init_idle(struct task_struct *tsk, int cpu) { }
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..e1a27f9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4745,7 +4745,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
-	vtime_init_idle(idle);
+	vtime_init_idle(idle, cpu);
 #if defined(CONFIG_SMP)
 	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cc2dc3ee..b5ccba2 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -747,17 +747,17 @@ void arch_vtime_task_switch(struct task_struct *prev)
 
 	write_seqlock(&current->vtime_seqlock);
 	current->vtime_snap_whence = VTIME_SYS;
-	current->vtime_snap = sched_clock();
+	current->vtime_snap = sched_clock_cpu(smp_processor_id());
 	write_sequnlock(&current->vtime_seqlock);
 }
 
-void vtime_init_idle(struct task_struct *t)
+void vtime_init_idle(struct task_struct *t, int cpu)
 {
 	unsigned long flags;
 
 	write_seqlock_irqsave(&t->vtime_seqlock, flags);
 	t->vtime_snap_whence = VTIME_SYS;
-	t->vtime_snap = sched_clock();
+	t->vtime_snap = sched_clock_cpu(cpu);
 	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
 }
 
-- 
1.7.5.4

