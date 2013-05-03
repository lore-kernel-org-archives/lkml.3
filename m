Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496Ab3ECWfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:35:48 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59365 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753427Ab3ECWfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:35:47 -0400
Date: Fri, 3 May 2013 17:35:44 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Russ Anderson <rja@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpu: Speedup disable_nonboot_cpus()
Message-ID: <20130503223543.GB25937@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine disable_nonboot_cpus() shuts down cpus sequentially
using for_each_online_cpu(cpu) to call cpu_down() one cpu at
a time.  cpu_down() calls __stop_machine() which stops all
the cpus while it disables one.  Then it re-enables the remaining
cpus, only to do it all over again for the next cpu.  The 
result is that it takes 16 minutes on a 1024 cpu system to 
disable 1023 cpus.

This patch changes disable_nonboot_cpus() to pass a bitmask
of cpus to cpu_down() and modifies cpu_down() to only call
__stop_machine() once.

On a 1024 cpu system this reduces the time it takes to disable
all but one cpu from 16 minutes down to 4 minutes.

Signed-off-by: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>

---
 kernel/cpu.c |  104 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 43 deletions(-)

Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2013-05-03 09:56:31.145508321 -0500
+++ linux/kernel/cpu.c	2013-05-03 17:01:20.652959400 -0500
@@ -241,13 +241,13 @@ static inline void check_for_tasks(int c
 
 struct take_cpu_down_param {
 	unsigned long mod;
-	void *hcpu;
 };
 
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	void *hcpu = (void *)(long)smp_processor_id();
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -255,21 +255,21 @@ static int __ref take_cpu_down(void *_pa
 	if (err < 0)
 		return err;
 
-	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	cpu_notify(CPU_DYING | param->mod, hcpu);
 	/* Park the stopper thread */
 	kthread_park(current);
 	return 0;
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(const cpumask_t *cpus_to_offline, int tasks_frozen)
 {
-	int err, nr_calls = 0;
+	int err = 0, cpu = 0, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
+	cpumask_var_t cpus_offlined;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
 		.mod = mod,
-		.hcpu = hcpu,
 	};
 
 	if (num_online_cpus() == 1)
@@ -278,46 +278,67 @@ static int __ref _cpu_down(unsigned int
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&cpus_offlined, GFP_KERNEL))
+		return -ENOMEM;
+
 	cpu_hotplug_begin();
+	cpumask_copy(cpus_offlined, cpus_to_offline);
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (err) {
-		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
+	for_each_cpu_mask(cpu, *cpus_to_offline) {
+		if (!cpu_online(cpu))
+			continue;
+		hcpu = (void *)(long)cpu;
+		err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+		if (err) {
+			nr_calls--;
+			__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
+			pr_err("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
-		goto out_release;
+			goto out_release;
+		}
+		smpboot_park_threads(cpu);
 	}
-	smpboot_park_threads(cpu);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, &tcd_param, cpus_to_offline);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		smpboot_unpark_threads(cpu);
-		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		for_each_cpu_mask(cpu, *cpus_to_offline) {
+			hcpu = (void *)(long)cpu;
+			smpboot_unpark_threads(cpu);
+			cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		}
 		goto out_release;
 	}
-	BUG_ON(cpu_online(cpu));
 
 	/*
 	 * The migration_call() CPU_DYING callback will have removed all
 	 * runnable tasks from the cpu, there's only the idle task left now
 	 * that the migration thread is done doing the stop_machine thing.
-	 *
-	 * Wait for the stop thread to go away.
 	 */
-	while (!idle_cpu(cpu))
-		cpu_relax();
-
-	/* This actually kills the CPU. */
-	__cpu_die(cpu);
+	for_each_cpu_mask(cpu, *cpus_offlined) {
+		BUG_ON(cpu_online(cpu));
 
-	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
-
-	check_for_tasks(cpu);
+		/*
+		 * Wait for the stop thread to go away.
+		 */
+		while (!idle_cpu(cpu))
+			cpu_relax();
+
+		/*
+		 * This actually kills the CPU.
+		 */
+		__cpu_die(cpu);
+
+		/*
+		 * CPU is completely dead: tell everyone.  Too late to complain.
+		 */
+		hcpu = (void *)(long)cpu;
+		cpu_notify_nofail(CPU_DEAD | mod, hcpu);
+		check_for_tasks(cpu);
+	}
 
 out_release:
+	free_cpumask_var(cpus_offlined);
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
@@ -327,6 +348,7 @@ out_release:
 int __ref cpu_down(unsigned int cpu)
 {
 	int err;
+	cpumask_var_t cpumask;
 
 	cpu_maps_update_begin();
 
@@ -335,7 +357,11 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	err = _cpu_down(cpu, 0);
+	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_set_cpu(cpu, cpumask);
+	err = _cpu_down(cpumask, 0);
+	free_cpumask_var(cpumask);
 
 out:
 	cpu_maps_update_done();
@@ -459,7 +485,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error = 0;
+	int first_cpu, error = 0;
 
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
@@ -467,21 +493,13 @@ int disable_nonboot_cpus(void)
 	 * We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
-	cpumask_clear(frozen_cpus);
-
 	printk("Disabling non-boot CPUs ...\n");
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		error = _cpu_down(cpu, 1);
-		if (!error)
-			cpumask_set_cpu(cpu, frozen_cpus);
-		else {
-			printk(KERN_ERR "Error taking CPU%d down: %d\n",
-				cpu, error);
-			break;
-		}
-	}
+	cpumask_copy(frozen_cpus, cpu_online_mask);
+	cpumask_clear_cpu(first_cpu, frozen_cpus);	/* all but one cpu*/
+
+	error = _cpu_down(frozen_cpus, 1);
+	if (error)
+		pr_err("Error %d stopping cpus\n", error);
 
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
