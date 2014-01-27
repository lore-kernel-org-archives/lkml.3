Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaA0JOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:14:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaA0JO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:14:29 -0500
Message-ID: <1390814053.5425.145.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
From: Mike Galbraith <bitbucket@online.de>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Mon, 27 Jan 2014 10:14:13 +0100
In-Reply-To: <52E5E687.1090808@osadl.org>
References: <20140125134519.GA9845@linutronix.de>
	 <52E5E687.1090808@osadl.org>
Content-Type: multipart/mixed; boundary="=-s0N2UdcHZD6s9QsFOfUK"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
X-Provags-ID: V02:K0:YzpybTQv2Dh4lg5bb3nlcbVDzebUAOObswpOclkX6b9
 ZWomGd/PohvzviKRPZ02qeDAMeWeCL7tuibUbSTE/iu6VOh5G2
 Pyx5EgHVTJMxAgCDqXyk98rVoi7TF4+yssmP2n4nz9ja1ELhPA
 z5FCUeCj3kxUqF5gZSdrIhvj/DhO0VjdwhPhldogrEi+9KnXm5
 wZoaOdyuMd3Un/h66OgYZ/TRxPfksy65ak/R6acVCzijXRzRo+
 Io/ZBTnFqM82kZYehW3irbjofMW/0dcgEKM5Y1dEXJaeqIHdW5
 0vyFfLdtdAhCWhJdyFufX/SmS2WFwiqLgsO/FNY9+QgqfQu8AY
 G6uNsW3R1+TlEklQhu1ssJ+yqFvyqbfu4xyUUw4qGdv7r32SKe
 K/brHecL+xg3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s0N2UdcHZD6s9QsFOfUK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2014-01-27 at 05:54 +0100, Carsten Emde wrote: 
> It is well conceivable that this or one of the next 3.12.X-rtY 
> versions will remind us of the legendary 2.6.33 RT kernel.

Hm.  I wonder if HRTIMER_SOFTIRQ being processed alone, and at maxed out
priority wouldn't beat 2.6.33-rt on your boxen.  My 64 core box running
-rt9 (minus nohz_full patches) does beat it.

Two hacks attached if you're curious too, one to optionally resurrect
sirq threads, another to kick obnoxious idle_balance().. below the belt.

-Mike

--=-s0N2UdcHZD6s9QsFOfUK
Content-Disposition: attachment; filename="softirq-resurrect-threads.patch"
Content-Type: text/x-patch; name="softirq-resurrect-threads.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

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
@@ -3086,6 +3086,9 @@ bytes respectively. Such letter suffixes
 			Force threading of all interrupt handlers except those
 			marked explicitly IRQF_NO_THREAD.
 
+	threadsirqs	[KNL]
+			Enable or disable threading of all softirqs for -rt.
+
 	tmem		[KNL,XEN]
 			Enable the Transcendent memory driver if built-in.
 
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -383,8 +383,10 @@ struct softirq_action
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 static inline void thread_do_softirq(void) { do_softirq(); }
+#define NR_SOFTIRQ_THREADS 1
 #else
 extern void thread_do_softirq(void);
+#define NR_SOFTIRQ_THREADS NR_SOFTIRQS
 #endif
 
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
@@ -405,12 +407,7 @@ extern void softirq_check_pending_idle(v
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
-
-static inline struct task_struct *this_cpu_ksoftirqd(void)
-{
-	return this_cpu_read(ksoftirqd);
-}
+DECLARE_PER_CPU(struct task_struct * [NR_SOFTIRQ_THREADS], ksoftirqd);
 
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1121,6 +1121,7 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+	unsigned sched_is_softirqd:1;
 
 	pid_t pid;
 	pid_t tgid;
@@ -1484,6 +1485,11 @@ static inline struct pid *task_tgid(stru
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
@@ -338,7 +338,7 @@ static void irqtime_account_process_tick
 		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
 	} else if (irqtime_account_si_update()) {
 		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
-	} else if (this_cpu_ksoftirqd() == p) {
+	} else if (task_is_softirqd(p)) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -57,7 +57,14 @@ EXPORT_SYMBOL(irq_stat);
 
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
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -162,10 +169,10 @@ static inline void softirq_clr_runner(un
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
@@ -426,7 +433,7 @@ asmlinkage void __do_softirq(void)
 		    --max_restart)
 			goto restart;
 
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 	}
 
 	lockdep_softirq_end();
@@ -474,7 +481,7 @@ void raise_softirq_irqoff(unsigned int n
 	 * schedule the softirq soon.
 	 */
 	if (!in_interrupt())
-		wakeup_softirqd();
+		wakeup_softirqd(0);
 }
 
 void __raise_softirq_irqoff(unsigned int nr)
@@ -485,8 +492,18 @@ void __raise_softirq_irqoff(unsigned int
 
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
 
@@ -647,15 +664,15 @@ static void do_raise_softirq_irqoff(unsi
 	 */
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
@@ -682,7 +699,7 @@ void raise_softirq_irqoff(unsigned int n
 	 * raise a WARN() if the condition is met.
 	 */
 	if (!current->softirq_nestcnt)
-		wakeup_softirqd();
+		wakeup_softirqd(nr);
 }
 
 static inline int ksoftirqd_softirq_pending(void)
@@ -700,6 +717,7 @@ static inline void ksoftirqd_set_sched_p
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	/* Take over all pending softirqs when starting */
 	local_irq_disable();
+	current->sched_is_softirqd = 1;
 	current->softirqs_raised = local_softirq_pending();
 	local_irq_enable();
 }
@@ -708,9 +726,26 @@ static inline void ksoftirqd_clr_sched_p
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
@@ -748,15 +783,25 @@ static inline void invoke_softirq(void)
 		 */
 		do_softirq();
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
@@ -1328,20 +1373,111 @@ static struct notifier_block cpu_nfb = {
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

--=-s0N2UdcHZD6s9QsFOfUK
Content-Disposition: attachment; filename="sched-further-limit-idle_balance.patch"
Content-Type: text/x-patch; name="sched-further-limit-idle_balance.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Mike Galbraith <mgalbraith@suse.de>
Date: Mon Dec  5 10:01:47 CET 2011
Subject: sched: further limit idle_balance()

Move all restrictions into schedule(), no sense in making a function call
unless we're going to do something.

In the case of isolated cores, there's no point at all in dropping/re-taking
the lock to do nothing else but update the time stamp.  Neither rt tasks nor
kthreads need to be banging on locks either, they have more important things
to do than play load balancer, possibly being delayed, or causing delay for
others.  Just say no, and in the right spot.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>

---
 kernel/sched/core.c |    9 +++++++--
 kernel/sched/fair.c |    5 -----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2615,8 +2615,13 @@ static void __sched __schedule(void)
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+	if (unlikely(!rq->nr_running)) {
+		rq->idle_stamp = rq->clock;
+
+		 if (rq->avg_idle >= sysctl_sched_migration_cost &&
+				rq->sd && prev->mm && !rt_task(prev))
+			idle_balance(cpu, rq);
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5420,11 +5420,6 @@ void idle_balance(int this_cpu, struct r
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
-	this_rq->idle_stamp = rq_clock(this_rq);
-
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
-
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */

--=-s0N2UdcHZD6s9QsFOfUK--

