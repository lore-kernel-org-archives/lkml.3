Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3AaMLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:55877 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AaMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:20 -0500
Message-Id: <20130131120741.686315164@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 03/40] stop_machine: Use smpboot threads
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=stop-machine-use-smpboot-threads.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the smpboot thread infrastructure. Mark the stopper thread
selfparking and park it after it has finished the take_cpu_down()
work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c          |    2 
 kernel/stop_machine.c |  134 ++++++++++++++++++--------------------------------
 2 files changed, 51 insertions(+), 85 deletions(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -254,6 +254,8 @@ static int __ref take_cpu_down(void *_pa
 		return err;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	/* Park the stopper thread */
+	kthread_park(current);
 	return 0;
 }
 
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -18,7 +18,7 @@
 #include <linux/stop_machine.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
-
+#include <linux/smpboot.h>
 #include <linux/atomic.h>
 
 /*
@@ -245,20 +245,25 @@ int try_stop_cpus(const struct cpumask *
 	return ret;
 }
 
-static int cpu_stopper_thread(void *data)
+static int cpu_stop_should_run(unsigned int cpu)
+{
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
+	unsigned long flags;
+	int run;
+
+	spin_lock_irqsave(&stopper->lock, flags);
+	run = !list_empty(&stopper->works);
+	spin_unlock_irqrestore(&stopper->lock, flags);
+	return run;
+}
+
+static void cpu_stopper_thread(unsigned int cpu)
 {
-	struct cpu_stopper *stopper = data;
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 	struct cpu_stop_work *work;
 	int ret;
 
 repeat:
-	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
-
-	if (kthread_should_stop()) {
-		__set_current_state(TASK_RUNNING);
-		return 0;
-	}
-
 	work = NULL;
 	spin_lock_irq(&stopper->lock);
 	if (!list_empty(&stopper->works)) {
@@ -274,8 +279,6 @@ repeat:
 		struct cpu_stop_done *done = work->done;
 		char ksym_buf[KSYM_NAME_LEN] __maybe_unused;
 
-		__set_current_state(TASK_RUNNING);
-
 		/* cpu stop callbacks are not allowed to sleep */
 		preempt_disable();
 
@@ -291,87 +294,55 @@ repeat:
 					  ksym_buf), arg);
 
 		cpu_stop_signal_done(done, true);
-	} else
-		schedule();
-
-	goto repeat;
+		goto repeat;
+	}
 }
 
 extern void sched_set_stop_task(int cpu, struct task_struct *stop);
 
-/* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
-static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
-					   unsigned long action, void *hcpu)
+static void cpu_stop_create(unsigned int cpu)
+{
+	sched_set_stop_task(cpu, per_cpu(cpu_stopper_task, cpu));
+}
+
+static void cpu_stop_park(unsigned int cpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
-	struct task_struct *p = per_cpu(cpu_stopper_task, cpu);
+	struct cpu_stop_work *work;
+	unsigned long flags;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		BUG_ON(p || stopper->enabled || !list_empty(&stopper->works));
-		p = kthread_create_on_node(cpu_stopper_thread,
-					   stopper,
-					   cpu_to_node(cpu),
-					   "migration/%d", cpu);
-		if (IS_ERR(p))
-			return notifier_from_errno(PTR_ERR(p));
-		get_task_struct(p);
-		kthread_bind(p, cpu);
-		sched_set_stop_task(cpu, p);
-		per_cpu(cpu_stopper_task, cpu) = p;
-		break;
+	/* drain remaining works */
+	spin_lock_irqsave(&stopper->lock, flags);
+	list_for_each_entry(work, &stopper->works, list)
+		cpu_stop_signal_done(work->done, false);
+	stopper->enabled = false;
+	spin_unlock_irqrestore(&stopper->lock, flags);
+}
 
-	case CPU_ONLINE:
-		/* strictly unnecessary, as first user will wake it */
-		wake_up_process(p);
-		/* mark enabled */
-		spin_lock_irq(&stopper->lock);
-		stopper->enabled = true;
-		spin_unlock_irq(&stopper->lock);
-		break;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_POST_DEAD:
-	{
-		struct cpu_stop_work *work;
-
-		sched_set_stop_task(cpu, NULL);
-		/* kill the stopper */
-		kthread_stop(p);
-		/* drain remaining works */
-		spin_lock_irq(&stopper->lock);
-		list_for_each_entry(work, &stopper->works, list)
-			cpu_stop_signal_done(work->done, false);
-		stopper->enabled = false;
-		spin_unlock_irq(&stopper->lock);
-		/* release the stopper */
-		put_task_struct(p);
-		per_cpu(cpu_stopper_task, cpu) = NULL;
-		break;
-	}
-#endif
-	}
+static void cpu_stop_unpark(unsigned int cpu)
+{
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 
-	return NOTIFY_OK;
+	spin_lock_irq(&stopper->lock);
+	stopper->enabled = true;
+	spin_unlock_irq(&stopper->lock);
 }
 
-/*
- * Give it a higher priority so that cpu stopper is available to other
- * cpu notifiers.  It currently shares the same priority as sched
- * migration_notifier.
- */
-static struct notifier_block __cpuinitdata cpu_stop_cpu_notifier = {
-	.notifier_call	= cpu_stop_cpu_callback,
-	.priority	= 10,
+static struct smp_hotplug_thread cpu_stop_threads = {
+	.store			= &cpu_stopper_task,
+	.thread_should_run	= cpu_stop_should_run,
+	.thread_fn		= cpu_stopper_thread,
+	.thread_comm		= "migration/%u",
+	.create			= cpu_stop_create,
+	.setup			= cpu_stop_unpark,
+	.park			= cpu_stop_park,
+	.unpark			= cpu_stop_unpark,
+	.selfparking		= true,
 };
 
 static int __init cpu_stop_init(void)
 {
-	void *bcpu = (void *)(long)smp_processor_id();
 	unsigned int cpu;
-	int err;
 
 	for_each_possible_cpu(cpu) {
 		struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
@@ -380,15 +351,8 @@ static int __init cpu_stop_init(void)
 		INIT_LIST_HEAD(&stopper->works);
 	}
 
-	/* start one for the boot cpu */
-	err = cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_UP_PREPARE,
-				    bcpu);
-	BUG_ON(err != NOTIFY_OK);
-	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
-	register_cpu_notifier(&cpu_stop_cpu_notifier);
-
+	BUG_ON(smpboot_register_percpu_thread(&cpu_stop_threads));
 	stop_machine_initialized = true;
-
 	return 0;
 }
 early_initcall(cpu_stop_init);


