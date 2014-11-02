Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKBHb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:31:56 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47828 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaKBHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:31:51 -0500
Message-ID: <1414913507.5380.117.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - softirq: resurrect softirq threads
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:31:47 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sirqs suck, this makes them suck less for some boxen/loads)

Subject: softirq: resurrect softirq threads
From: Mike Galbraith <mgalbraith@suse.de>
Date: Mon Jan  6 08:42:11 CET 2014

Some loads cannot tolerate the jitter induced by all softirqs being processed
at the same priority.  Let the user prioritize them again.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
---
 Documentation/kernel-parameters.txt |    3 
 include/linux/interrupt.h           |    9 -
 include/linux/sched.h               |    6 +
 kernel/sched/cputime.c              |    4 
 kernel/softirq.c                    |  182 +++++++++++++++++++++++++++++++-----
 5 files changed, 173 insertions(+), 31 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3187,6 +3187,9 @@ bytes respectively. Such letter suffixes
 			Force threading of all interrupt handlers except those
 			marked explicitly IRQF_NO_THREAD.
 
+	threadsirqs	[KNL]
+			Enable or disable threading of all softirqs for -rt.
+
 	tmem		[KNL,XEN]
 			Enable the Transcendent memory driver if built-in.
 
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -425,6 +425,7 @@ struct softirq_action
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 static inline void thread_do_softirq(void) { do_softirq(); }
+#define NR_SOFTIRQ_THREADS 1
 #ifdef __ARCH_HAS_DO_SOFTIRQ
 void do_softirq_own_stack(void);
 #else
@@ -435,6 +436,7 @@ static inline void do_softirq_own_stack(
 #endif
 #else
 extern void thread_do_softirq(void);
+#define NR_SOFTIRQ_THREADS NR_SOFTIRQS
 #endif
 
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
@@ -445,12 +447,7 @@ extern void raise_softirq_irqoff(unsigne
 extern void raise_softirq(unsigned int nr);
 extern void softirq_check_pending_idle(void);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
-
-static inline struct task_struct *this_cpu_ksoftirqd(void)
-{
-	return this_cpu_read(ksoftirqd);
-}
+DECLARE_PER_CPU(struct task_struct * [NR_SOFTIRQ_THREADS], ksoftirqd);
 
 /* Tasklets --- multithreaded analogue of BHs.
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1263,6 +1263,7 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+	unsigned sched_is_softirqd:1;
 
 	pid_t pid;
 	pid_t tgid;
@@ -1678,6 +1679,11 @@ static inline struct pid *task_tgid(stru
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
+static inline bool task_is_softirqd(struct task_struct *task)
+{
+	return task->sched_is_softirqd;
+}
+
 /*
  * Without tasklist or rcu lock it is not safe to dereference
  * the result of task_pgrp/task_session even if task == current,
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -68,7 +68,7 @@ void irqtime_account_irq(struct task_str
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+	else if (in_serving_softirq() && !task_is_softirqd(curr))
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
@@ -342,7 +342,7 @@ static void irqtime_account_process_tick
 		cpustat[CPUTIME_IRQ] += cputime;
 	} else if (irqtime_account_si_update()) {
 		cpustat[CPUTIME_SOFTIRQ] += cputime;
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (task_is_softirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -56,7 +56,14 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct * [NR_SOFTIRQ_THREADS], ksoftirqd);
+
+static unsigned int __read_mostly threadsirqs;
+
+static struct task_struct *__this_cpu_ksoftirqd(int nr)
+{
+	return  __this_cpu_read(ksoftirqd[nr && threadsirqs ? nr : 0]);
+}
 
 const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -161,10 +168,10 @@ static inline void softirq_clr_runner(un
  * to the pending events, so lets the scheduler to balance
  * the softirq load for us.
  */
-static void wakeup_softirqd(void)
+static void wakeup_softirqd(int nr)
 {
 	/* Interrupts are disabled: no need to stop preemption */
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
+	struct task_struct *tsk =  __this_cpu_ksoftirqd(nr);
 
 	if (tsk && tsk->state != TASK_RUNNING)
 		wake_up_process(tsk);
@@ -413,7 +420,7 @@ asmlinkage void __do_softirq(void)
 		    --max_restart)
 			goto restart;
 
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 	}
 
 	lockdep_softirq_end(in_hardirq);
@@ -458,7 +465,7 @@ void raise_softirq_irqoff(unsigned int n
 	 * schedule the softirq soon.
 	 */
 	if (!in_interrupt())
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 }
 
 void __raise_softirq_irqoff(unsigned int nr)
@@ -469,8 +476,18 @@ void __raise_softirq_irqoff(unsigned int
 
 static inline void local_bh_disable_nort(void) { local_bh_disable(); }
 static inline void _local_bh_enable_nort(void) { _local_bh_enable(); }
-static void ksoftirqd_set_sched_params(unsigned int cpu) { }
-static void ksoftirqd_clr_sched_params(unsigned int cpu, bool online) { }
+static void ksoftirqd_set_sched_params(unsigned int cpu)
+{
+	local_irq_disable();
+	current->sched_is_softirqd = 1;
+	local_irq_enable();
+}
+static void ksoftirqd_clr_sched_params(unsigned int cpu, bool online)
+{
+	local_irq_disable();
+	current->sched_is_softirqd = 0;
+	local_irq_enable();
+}
 
 #else /* !PREEMPT_RT_FULL */
 
@@ -656,15 +673,15 @@ static void do_raise_softirq_irqoff(unsi
 
 	if (!in_irq() && current->softirq_nestcnt)
 		current->softirqs_raised |= (1U << nr);
-	else if (__this_cpu_read(ksoftirqd))
-		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
+	else if (__this_cpu_ksoftirqd(nr))
+		__this_cpu_ksoftirqd(nr)->softirqs_raised |= (1U << nr);
 }
 
 void __raise_softirq_irqoff(unsigned int nr)
 {
 	do_raise_softirq_irqoff(nr);
 	if (!in_irq() && !current->softirq_nestcnt)
-		wakeup_softirqd();
+		wakeup_softirqd(nr);
 }
 
 /*
@@ -691,7 +708,7 @@ void raise_softirq_irqoff(unsigned int n
 	 *
 	 */
 	if (!current->softirq_nestcnt)
-		wakeup_softirqd();
+		wakeup_softirqd(nr);
 }
 
 static inline int ksoftirqd_softirq_pending(void)
@@ -709,6 +726,7 @@ static inline void ksoftirqd_set_sched_p
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	/* Take over all pending softirqs when starting */
 	local_irq_disable();
+	current->sched_is_softirqd = 1;
 	current->softirqs_raised = local_softirq_pending();
 	local_irq_enable();
 }
@@ -717,9 +735,26 @@ static inline void ksoftirqd_clr_sched_p
 {
 	struct sched_param param = { .sched_priority = 0 };
 
+	local_irq_disable();
+	current->sched_is_softirqd = 0;
+	current->softirqs_raised = 0;
+	local_irq_enable();
 	sched_setscheduler(current, SCHED_NORMAL, &param);
 }
 
+static int __init threadsoftirqs(char *str)
+{
+	int thread = 0;
+
+	if (!get_option(&str, &thread))
+		thread = 1;
+
+	threadsirqs = !!thread;
+
+	return 0;
+}
+
+early_param("threadsirqs", threadsoftirqs);
 #endif /* PREEMPT_RT_FULL */
 /*
  * Enter an interrupt context.
@@ -760,15 +795,25 @@ static inline void invoke_softirq(void)
 		do_softirq_own_stack();
 #endif
 	} else {
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 	}
 #else /* PREEMPT_RT_FULL */
+	struct task_struct *tsk;
 	unsigned long flags;
+	u32 pending, nr;
 
 	local_irq_save(flags);
-	if (__this_cpu_read(ksoftirqd) &&
-			__this_cpu_read(ksoftirqd)->softirqs_raised)
-		wakeup_softirqd();
+	pending = local_softirq_pending();
+
+	while (pending) {
+		nr = __ffs(pending);
+		tsk = __this_cpu_ksoftirqd(nr);
+		if (tsk && tsk->softirqs_raised)
+			wakeup_softirqd(nr);
+		if (!threadsirqs)
+			break;
+		pending &= ~(1U << nr);
+	}
 	local_irq_restore(flags);
 #endif
 }
@@ -1201,20 +1246,111 @@ static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
-static struct smp_hotplug_thread softirq_threads = {
-	.store			= &ksoftirqd,
-	.setup			= ksoftirqd_set_sched_params,
-	.cleanup		= ksoftirqd_clr_sched_params,
-	.thread_should_run	= ksoftirqd_should_run,
-	.thread_fn		= run_ksoftirqd,
-	.thread_comm		= "ksoftirqd/%u",
+static struct smp_hotplug_thread softirq_threads[] = {
+	{
+		.store			= &ksoftirqd[0],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "ksoftirqd/%u",
+	},
+#ifdef CONFIG_PREEMPT_RT_FULL
+	{
+		.store			= &ksoftirqd[HI_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-high/%u",
+	},
+	{
+		.store			= &ksoftirqd[TIMER_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-timer/%u",
+	},
+	{
+		.store			= &ksoftirqd[NET_TX_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-net-tx/%u",
+	},
+	{
+		.store			= &ksoftirqd[NET_RX_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-net-rx/%u",
+	},
+	{
+		.store			= &ksoftirqd[BLOCK_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-blk/%u",
+	},
+	{
+		.store			= &ksoftirqd[BLOCK_IOPOLL_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-blk-pol/%u",
+	},
+	{
+		.store			= &ksoftirqd[TASKLET_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-tasklet/%u",
+	},
+	{
+		.store			= &ksoftirqd[SCHED_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-sched/%u",
+	},
+	{
+		.store			= &ksoftirqd[HRTIMER_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-hrtimer/%u",
+	},
+	{
+		.store			= &ksoftirqd[RCU_SOFTIRQ],
+		.setup			= ksoftirqd_set_sched_params,
+		.cleanup		= ksoftirqd_clr_sched_params,
+		.thread_should_run	= ksoftirqd_should_run,
+		.thread_fn		= run_ksoftirqd,
+		.thread_comm		= "sirq-rcu/%u",
+	},
+#endif
 };
 
 static __init int spawn_ksoftirqd(void)
 {
+	struct smp_hotplug_thread *t = &softirq_threads[threadsirqs];
+	int i, threads = NR_SOFTIRQ_THREADS;
+
 	register_cpu_notifier(&cpu_nfb);
 
-	BUG_ON(smpboot_register_percpu_thread(&softirq_threads));
+	for (i = 0; i < threads; i++, t++) {
+		BUG_ON(smpboot_register_percpu_thread(t));
+		if (!threadsirqs)
+			break;
+	}
 
 	return 0;
 }



