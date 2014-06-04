Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471AbaFDAbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:31:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33326 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaFDAaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:30:07 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 6/6] sched: Optimize ttwu IPI
Date: Tue,  3 Jun 2014 17:29:52 -0700
Message-Id: <e5b520c841ba15e1c9befb5239feadb9177c873c.1401841482.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

When enqueueing tasks on remote LLC domains, we send an IPI to do the
work 'locally' and avoid bouncing all the cachelines over.

However, when the remote CPU is idle (and polling, say x86 mwait), we
don't need to send an IPI, we can simply kick the TIF word to wake it
up and have the 'idle' loop do the work.

So when _TIF_POLLING_NRFLAG is set, but _TIF_NEED_RESCHED is not (yet)
set, set _TIF_NEED_RESCHED and avoid sending the IPI.

[Edited by Andy Lutomirski, but this is mostly Peter Zijlstra's code.]

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Much-requested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/sched/core.c  | 54 ++++++++++++++++++++++++++++++++++++++++++++++------
 kernel/sched/idle.c  |  3 +++
 kernel/sched/sched.h |  6 ++++++
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dfc3e23..af52702 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -519,7 +519,7 @@ static inline void init_hrtick(void)
  	__old;								\
 })
 
-#ifdef TIF_POLLING_NRFLAG
+#if defined(CONFIG_SMP) && defined(TIF_POLLING_NRFLAG)
 /*
  * Atomically set TIF_NEED_RESCHED and test for TIF_POLLING_NRFLAG,
  * this avoids any races wrt polling state changes and thereby avoids
@@ -530,12 +530,44 @@ static bool set_nr_and_not_polling(struct task_struct *p)
 	struct thread_info *ti = task_thread_info(p);
 	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
 }
+
+/*
+ * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
+ *
+ * If this returns true, then the idle task promises to call
+ * sched_ttwu_pending() and reschedule soon.
+ */
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	struct thread_info *ti = task_thread_info(p);
+	typeof(ti->flags) old, val = ACCESS_ONCE(ti->flags);
+
+	for (;;) {
+		if (!(val & _TIF_POLLING_NRFLAG))
+			return false;
+		if (val & _TIF_NEED_RESCHED)
+			return true;
+		old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
+		if (old == val)
+			break;
+		val = old;
+	}
+	return true;
+}
+
 #else
 static bool set_nr_and_not_polling(struct task_struct *p)
 {
 	set_tsk_need_resched(p);
 	return true;
 }
+
+#ifdef CONFIG_SMP
+static bool set_nr_if_polling(struct task_struct *p)
+{
+	return false;
+}
+#endif
 #endif
 
 /*
@@ -1490,13 +1522,17 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
 	struct llist_node *llist = llist_del_all(&rq->wake_list);
 	struct task_struct *p;
+	unsigned long flags;
 
-	raw_spin_lock(&rq->lock);
+	if (!llist)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	while (llist) {
 		p = llist_entry(llist, struct task_struct, wake_entry);
@@ -1504,7 +1540,7 @@ static void sched_ttwu_pending(void)
 		ttwu_do_activate(rq, p, 0);
 	}
 
-	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 void scheduler_ipi(void)
@@ -1550,8 +1586,14 @@ void scheduler_ipi(void)
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+	struct rq *rq = cpu_rq(cpu);
+
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
+		if (!set_nr_if_polling(rq->idle))
+			smp_send_reschedule(cpu);
+		else
+			trace_sched_wake_polling_cpu(cpu);
+	}
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 4de3a24..9d90909 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
 
 #include <trace/events/power.h>
 
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
 
 void cpu_idle_poll_ctrl(bool enable)
@@ -236,6 +238,7 @@ static void cpu_idle_loop(void)
 		tick_nohz_idle_exit();
 		__current_clr_polling();
 		smp_mb__after_clear_bit();
+		sched_ttwu_pending();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 600e229..99d9e81 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -670,6 +670,8 @@ extern int migrate_swap(struct task_struct *, struct task_struct *);
 
 #ifdef CONFIG_SMP
 
+extern void sched_ttwu_pending(void);
+
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -787,6 +789,10 @@ static inline unsigned int group_first_cpu(struct sched_group *group)
 
 extern int group_balance_cpu(struct sched_group *sg);
 
+#else
+
+static inline void sched_ttwu_pending(void) { }
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
-- 
1.9.3

