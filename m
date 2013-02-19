Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3BSO2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:28:43 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60079 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3BSO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:28:41 -0500
Date: Tue, 19 Feb 2013 15:28:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] smp/hotplug changes for v3.9
Message-ID: <20130219142836.GA13196@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest smp-hotplug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp-hotplug-for-linus

   HEAD: 14e568e78f6f80ca1e27256641ddf524c7dbdc51 stop_machine: Use smpboot threads

Some early preparatory changes for the WIP hotplug rework by 
Thomas Gleixner.

 Thanks,

	Ingo

------------------>
Thomas Gleixner (3):
      smpboot: Allow selfparking per cpu threads
      stop_machine: Store task reference in a separate per cpu variable
      stop_machine: Use smpboot threads


 include/linux/smpboot.h |   5 ++
 kernel/cpu.c            |   2 +
 kernel/smpboot.c        |   5 +-
 kernel/stop_machine.c   | 156 +++++++++++++++++++-----------------------------
 4 files changed, 70 insertions(+), 98 deletions(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index e0106d8..c65dee0 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -14,6 +14,8 @@ struct smpboot_thread_data;
  * @thread_should_run:	Check whether the thread should run or not. Called with
  *			preemption disabled.
  * @thread_fn:		The associated thread function
+ * @create:		Optional setup function, called when the thread gets
+ *			created (Not called from the thread context)
  * @setup:		Optional setup function, called when the thread gets
  *			operational the first time
  * @cleanup:		Optional cleanup function, called when the thread
@@ -22,6 +24,7 @@ struct smpboot_thread_data;
  *			parked (cpu offline)
  * @unpark:		Optional unpark function, called when the thread is
  *			unparked (cpu online)
+ * @selfparking:	Thread is not parked by the park function.
  * @thread_comm:	The base name of the thread
  */
 struct smp_hotplug_thread {
@@ -29,10 +32,12 @@ struct smp_hotplug_thread {
 	struct list_head		list;
 	int				(*thread_should_run)(unsigned int cpu);
 	void				(*thread_fn)(unsigned int cpu);
+	void				(*create)(unsigned int cpu);
 	void				(*setup)(unsigned int cpu);
 	void				(*cleanup)(unsigned int cpu, bool online);
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
+	bool				selfparking;
 	const char			*thread_comm;
 };
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3046a50..c91e30d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -254,6 +254,8 @@ static int __ref take_cpu_down(void *_param)
 		return err;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	/* Park the stopper thread */
+	kthread_park(current);
 	return 0;
 }
 
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d6c5fc0..d4abac2 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -183,9 +183,10 @@ __smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 		kfree(td);
 		return PTR_ERR(tsk);
 	}
-
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
+	if (ht->create)
+		ht->create(cpu);
 	return 0;
 }
 
@@ -225,7 +226,7 @@ static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 {
 	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 
-	if (tsk)
+	if (tsk && !ht->selfparking)
 		kthread_park(tsk);
 }
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 2f194e9..95d178c 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -18,7 +18,7 @@
 #include <linux/stop_machine.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
-
+#include <linux/smpboot.h>
 #include <linux/atomic.h>
 
 /*
@@ -37,10 +37,10 @@ struct cpu_stopper {
 	spinlock_t		lock;
 	bool			enabled;	/* is this stopper enabled? */
 	struct list_head	works;		/* list of pending works */
-	struct task_struct	*thread;	/* stopper thread */
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
 static bool stop_machine_initialized = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
@@ -62,16 +62,18 @@ static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
 }
 
 /* queue @work to @stopper.  if offline, @work is completed immediately */
-static void cpu_stop_queue_work(struct cpu_stopper *stopper,
-				struct cpu_stop_work *work)
+static void cpu_stop_queue_work(unsigned int cpu, struct cpu_stop_work *work)
 {
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
+	struct task_struct *p = per_cpu(cpu_stopper_task, cpu);
+
 	unsigned long flags;
 
 	spin_lock_irqsave(&stopper->lock, flags);
 
 	if (stopper->enabled) {
 		list_add_tail(&work->list, &stopper->works);
-		wake_up_process(stopper->thread);
+		wake_up_process(p);
 	} else
 		cpu_stop_signal_done(work->done, false);
 
@@ -108,7 +110,7 @@ int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
 	struct cpu_stop_work work = { .fn = fn, .arg = arg, .done = &done };
 
 	cpu_stop_init_done(&done, 1);
-	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), &work);
+	cpu_stop_queue_work(cpu, &work);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -130,7 +132,7 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			struct cpu_stop_work *work_buf)
 {
 	*work_buf = (struct cpu_stop_work){ .fn = fn, .arg = arg, };
-	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
+	cpu_stop_queue_work(cpu, work_buf);
 }
 
 /* static data for stop_cpus */
@@ -159,8 +161,7 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 */
 	preempt_disable();
 	for_each_cpu(cpu, cpumask)
-		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
-				    &per_cpu(stop_cpus_work, cpu));
+		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
 }
 
@@ -244,20 +245,25 @@ int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
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
@@ -273,8 +279,6 @@ repeat:
 		struct cpu_stop_done *done = work->done;
 		char ksym_buf[KSYM_NAME_LEN] __maybe_unused;
 
-		__set_current_state(TASK_RUNNING);
-
 		/* cpu stop callbacks are not allowed to sleep */
 		preempt_disable();
 
@@ -290,88 +294,55 @@ repeat:
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
-	struct task_struct *p;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		BUG_ON(stopper->thread || stopper->enabled ||
-		       !list_empty(&stopper->works));
-		p = kthread_create_on_node(cpu_stopper_thread,
-					   stopper,
-					   cpu_to_node(cpu),
-					   "migration/%d", cpu);
-		if (IS_ERR(p))
-			return notifier_from_errno(PTR_ERR(p));
-		get_task_struct(p);
-		kthread_bind(p, cpu);
-		sched_set_stop_task(cpu, p);
-		stopper->thread = p;
-		break;
-
-	case CPU_ONLINE:
-		/* strictly unnecessary, as first user will wake it */
-		wake_up_process(stopper->thread);
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
-		kthread_stop(stopper->thread);
-		/* drain remaining works */
-		spin_lock_irq(&stopper->lock);
-		list_for_each_entry(work, &stopper->works, list)
-			cpu_stop_signal_done(work->done, false);
-		stopper->enabled = false;
-		spin_unlock_irq(&stopper->lock);
-		/* release the stopper */
-		put_task_struct(stopper->thread);
-		stopper->thread = NULL;
-		break;
-	}
-#endif
-	}
+	struct cpu_stop_work *work;
+	unsigned long flags;
 
-	return NOTIFY_OK;
+	/* drain remaining works */
+	spin_lock_irqsave(&stopper->lock, flags);
+	list_for_each_entry(work, &stopper->works, list)
+		cpu_stop_signal_done(work->done, false);
+	stopper->enabled = false;
+	spin_unlock_irqrestore(&stopper->lock, flags);
 }
 
-/*
- * Give it a higher priority so that cpu stopper is available to other
- * cpu notifiers.  It currently shares the same priority as sched
- * migration_notifier.
- */
-static struct notifier_block __cpuinitdata cpu_stop_cpu_notifier = {
-	.notifier_call	= cpu_stop_cpu_callback,
-	.priority	= 10,
+static void cpu_stop_unpark(unsigned int cpu)
+{
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
+
+	spin_lock_irq(&stopper->lock);
+	stopper->enabled = true;
+	spin_unlock_irq(&stopper->lock);
+}
+
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
