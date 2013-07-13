Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3GMPp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 11:45:56 -0400
Received: from forward5.mail.yandex.net ([77.88.46.21]:45443 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GMPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 11:45:55 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of the same task
MIME-Version: 1.0
Message-Id: <1517081373730349@web23d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 13 Jul 2013 19:45:49 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds optimization of try_to_wake_up() function
for cases when the system is doing parallel wake_up
of the same task on the different cpus. Also it adds
accounting the statistics of these situations.

We check the status of the task we want to wake up.
If it is TASK_WAKING then the task is manipulated
by try_to_wake_up() on another cpu. And after this
check it will be a moment when the task is queued
and his status is TASK_RUNNING. We just return
earlier when we are sure the task will be TASK_RUNNING
in the future (maybe right after the check). The profit is
we don't loop while we are waiting the spinlock.

There mustn't be any problems connected with
we return earlier, besause scheduler allready does
the same, when he queues a task in wake_list to be
waked up on another cpu.

Parallel wake up is not unreal situation. Here is
statistics from my 2-cpu laptop:

~# grep 'nr_wakeups_parallel.*[1-9]' -B100 -h /proc/*/sched | grep 'threads\|parallel\|wakeups ' | sed 's/(.*)//g'

rcu_sched 
se.statistics.nr_wakeups                     :                  102
se.statistics.nr_wakeups_parallel            :                    2
Xorg 
se.statistics.nr_wakeups                     :                36030
se.statistics.nr_wakeups_parallel            :                   56
gnome-terminal 
se.statistics.nr_wakeups                     :                70573
se.statistics.nr_wakeups_parallel            :                   55
rcu_preempt 
se.statistics.nr_wakeups                     :                68101
se.statistics.nr_wakeups_parallel            :                 1368

It's the moment after boot (5-10 minutes uptime). Later the ratio
goes down:

rcu_sched 
se.statistics.nr_wakeups                     :                  102
se.statistics.nr_wakeups_parallel            :                    2
Xorg 
se.statistics.nr_wakeups                     :                49057
se.statistics.nr_wakeups_parallel            :                   74
gnome-terminal 
se.statistics.nr_wakeups                     :              1495463
se.statistics.nr_wakeups_parallel            :                   99
rcu_preempt 
se.statistics.nr_wakeups                     :              2015010
se.statistics.nr_wakeups_parallel            :                 3738

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   29 +++++++++++++++++++++++++----
 kernel/sched/debug.c  |    7 +++++++
 kernel/sched/stats.h  |   16 ++++++++++++++++
 4 files changed, 49 insertions(+), 4 deletions(-)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fc09d21..235a466 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -964,6 +964,7 @@ struct sched_statistics {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+	atomic_t		nr_wakeups_parallel;
 };
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9d06ad6..1e1475f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1336,6 +1336,11 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
+	/*
+	 * Pair bracket with TASK_WAKING check it try_to_wake_up()
+	 */
+	smp_wmb();
+
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 
@@ -1487,20 +1492,37 @@ static int
 try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
 	unsigned long flags;
-	int cpu, success = 0;
+	int cpu, success = 1;
 
+	/*
+	 * See commentary for commit 04e2f1741d235ba599037734878d72e57cb302b5.
+	 */
 	smp_wmb();
+#ifdef CONFIG_SMP
+	if (p->state == TASK_WAKING) {
+		/*
+		 * Pairs with sets of p->state: below and in ttwu_do_wakeup().
+		 */
+		smp_rmb();
+		inc_nr_parallel_wakeups(p);
+		return success;
+	}
+#endif
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	if (!(p->state & state))
+	if (!(p->state & state)) {
+		success = 0;
 		goto out;
+	}
 
-	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
 	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
+	p->state = TASK_WAKING;
+	smp_wmb();
+
 	/*
 	 * If the owning (remote) cpu is still in the middle of schedule() with
 	 * this task as prev, wait until its done referencing the task.
@@ -1513,7 +1535,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	smp_rmb();
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
-	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e076bdd..f18736d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -542,6 +542,13 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.nr_wakeups_idle);
 
 	{
+		int nr = get_nr_parallel_wakeups(p);
+
+		SEQ_printf(m, "%-45s:%21d\n",
+			      "se.statistics.nr_wakeups_parallel", nr);
+	}
+
+	{
 		u64 avg_atom, avg_per_cpu;
 
 		avg_atom = p->se.sum_exec_runtime;
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 5aef494..dbbc6e9 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -155,6 +155,22 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 #define sched_info_switch(t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_SMP)
+static inline void
+inc_nr_parallel_wakeups(struct task_struct *t)
+{
+	atomic_inc(&t->se.statistics.nr_wakeups_parallel);
+}
+static inline int
+get_nr_parallel_wakeups(struct task_struct *t)
+{
+	return atomic_read(&t->se.statistics.nr_wakeups_parallel);
+}
+#else
+#define inc_nr_parallel_wakeups(t)		do { } while (0)
+#define get_nr_parallel_wakeups(t)		(0)
+#endif /* CONFIG_SCHEDSTATS && CONFIG_SMP */
+
 /*
  * The following are functions that support scheduler-internal time accounting.
  * These functions are generally called at the timer tick.  None of this depends
