Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3FNTal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:30:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3FNTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:30:39 -0400
Date: Fri, 14 Jun 2013 21:30:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.8.13-rt11
Message-ID: <20130614193037.GC8597@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt11 release.

changes since v3.8.13-rt10:
- use wakeup_timer_waiters() in wake_up() so we do nothing on nort
  kernel. Sent by Zhao Hongjiang
- a fix for a cpu down problem. If kthread is pinned to the same CPU
  which is going down we will spin for ever and wait until kthread
  leaves the CPU. This does not trigger on v3.6-rt because the workqueue
  code there does not create a new process in the notfier callback.
  Reported by Qiang Huang.
- a check if we lose PF_THREAD_BOUND in the workqueue code. Shouldn't
  happen yet it seems it happens from time to time.
- save the cpu mask of the application which disables a CPU. Prior this
  change the application which put a CPU down was allowed to run on any
  CPU if it was restricted to a specifc one. Reported by Zhao Chenhui.

- the SLxB PowerPC, e500 problem is removed from the list without a
  change. The problem triggers even on a v3.6 non-RT kernel after 1-2
  days of runtime on my MPC8572DS. I don't see any problem so far on
  MPC8536 which is mostly the same HW except it is UP but MPC8572DS
  crashes also in UP mode so I belive it is a HW problem.

Known issues:

    - Steven reported a missing acpi from the v3.6 release.
    - a "fix" for i915 leads to high latencies due to wbinvd(). Not sure
      what is the best thing to do here.

The delta patch against v3.8.13-rt10 is appended below and can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt10-rt11.patch.xz

The RT patch against 3.8.11 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt11.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt11.tar.xz

Sebastian

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d44dea3..f5ad8e1 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -83,6 +83,7 @@ struct hotplug_pcp {
 	int refcount;
 	int grab_lock;
 	struct completion synced;
+	struct completion unplug_wait;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	spinlock_t lock;
 #else
@@ -180,6 +181,7 @@ static int sync_unplug_thread(void *data)
 {
 	struct hotplug_pcp *hp = data;
 
+	wait_for_completion(&hp->unplug_wait);
 	preempt_disable();
 	hp->unplug = current;
 	wait_for_pinned_cpus(hp);
@@ -245,6 +247,14 @@ static void __cpu_unplug_sync(struct hotplug_pcp *hp)
 	wait_for_completion(&hp->synced);
 }
 
+static void __cpu_unplug_wait(unsigned int cpu)
+{
+	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
+
+	complete(&hp->unplug_wait);
+	wait_for_completion(&hp->synced);
+}
+
 /*
  * Start the sync_unplug_thread on the target cpu and wait for it to
  * complete.
@@ -268,6 +278,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	tell_sched_cpu_down_begin(cpu);
 
 	init_completion(&hp->synced);
+	init_completion(&hp->unplug_wait);
 
 	hp->sync_tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
 	if (IS_ERR(hp->sync_tsk)) {
@@ -283,8 +294,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	 * wait for tasks that are going to enter these sections and
 	 * we must not have them block.
 	 */
-	__cpu_unplug_sync(hp);
-
+	wake_up_process(hp->sync_tsk);
 	return 0;
 }
 
@@ -535,6 +545,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		.hcpu = hcpu,
 	};
 	cpumask_var_t cpumask;
+	cpumask_var_t cpumask_org;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -545,6 +556,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	/* Move the downtaker off the unplug cpu */
 	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
 		return -ENOMEM;
+	if (!alloc_cpumask_var(&cpumask_org, GFP_KERNEL))  {
+		free_cpumask_var(cpumask);
+		return -ENOMEM;
+	}
+
+	cpumask_copy(cpumask_org, tsk_cpus_allowed(current));
 	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
 	set_cpus_allowed_ptr(current, cpumask);
 	free_cpumask_var(cpumask);
@@ -553,7 +570,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (mycpu == cpu) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
 		migrate_enable();
-		return -EBUSY;
+		err = -EBUSY;
+		goto restore_cpus;
 	}
 
 	cpu_hotplug_begin();
@@ -571,6 +589,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
+
+	__cpu_unplug_wait(cpu);
 	smpboot_park_threads(cpu);
 
 	/* Notifiers are done. Don't let any more tasks pin this CPU. */
@@ -610,6 +630,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+restore_cpus:
+	set_cpus_allowed_ptr(current, cpumask_org);
+	free_cpumask_var(cpumask_org);
 	return err;
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1fba5cb..81a28dd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -849,9 +849,6 @@ static void irq_thread_dtor(struct callback_head *unused)
 static int irq_thread(void *data)
 {
 	struct callback_head on_exit_work;
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -863,8 +860,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
@@ -965,6 +960,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
@@ -972,6 +970,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			ret = PTR_ERR(t);
 			goto out_mput;
 		}
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
diff --git a/kernel/timer.c b/kernel/timer.c
index 374e7b1..2f1c8d3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -76,7 +76,9 @@ struct tvec_root {
 struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
+#ifdef CONFIG_PREEMPT_RT_FULL
 	wait_queue_head_t wait_for_running_timer;
+#endif
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
 	unsigned long active_timers;
@@ -982,7 +984,7 @@ static void wait_for_running_timer(struct timer_list *timer)
 			   base->running_timer != timer);
 }
 
-# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_tunning_timer)
+# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_running_timer)
 #else
 static inline void wait_for_running_timer(struct timer_list *timer)
 {
@@ -1236,7 +1238,7 @@ static inline void __run_timers(struct tvec_base *base)
 			}
 		}
 	}
-	wake_up(&base->wait_for_running_timer);
+	wakeup_timer_waiters(base);
 	spin_unlock_irq(&base->lock);
 }
 
@@ -1755,7 +1757,9 @@ static int __cpuinit init_timers_cpu(int cpu)
 	}
 
 	spin_lock_init(&base->lock);
+#ifdef CONFIG_PREEMPT_RT_FULL
 	init_waitqueue_head(&base->wait_for_running_timer);
+#endif
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11285e4..0d49ddf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1637,8 +1637,11 @@ __acquires(&gcwq->lock)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
 			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+			if (WARN_ON(!(task->flags & PF_THREAD_BOUND)))
+				task->flags |= PF_THREAD_BOUND;
+		}
 
 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
diff --git a/localversion-rt b/localversion-rt
index d79dde6..05c35cb 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt10
+-rt11
