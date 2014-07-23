Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaGWCbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:31:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:33700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbaGWCa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573973435"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 01/70] cpu: Restructure FROZEN state handling
Date: Tue, 22 Jul 2014 21:58:37 -0400
Message-Id: <1406080786-3938-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

There are only a few callbacks which really care about FROZEN
vs. !FROZEN. No need to have extra states for this.

Publish the frozen state in an extra variable which is updated under
the hotplug lock and let the users interested deal with it w/o
imposing that extra state checks on everyone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/cpu.c | 66 +++++++++++++++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a343bde..3da7e82 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -27,6 +27,7 @@
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
+static bool cpuhp_tasks_frozen;
 
 /*
  * The following two APIs (cpu_maps_update_begin/done) must be used when
@@ -194,27 +195,30 @@ int __ref __register_cpu_notifier(struct notifier_block *nb)
 	return raw_notifier_chain_register(&cpu_chain, nb);
 }
 
-static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
+static int __cpu_notify(unsigned long val, unsigned int cpu, int nr_to_call,
 			int *nr_calls)
 {
+	unsigned long mod = cpuhp_tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	void *hcpu = (void *)(long)cpu;
+
 	int ret;
 
-	ret = __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+	ret = __raw_notifier_call_chain(&cpu_chain, val | mod, hcpu, nr_to_call,
 					nr_calls);
 
 	return notifier_to_errno(ret);
 }
 
-static int cpu_notify(unsigned long val, void *v)
+static int cpu_notify(unsigned long val, unsigned int cpu)
 {
-	return __cpu_notify(val, v, -1, NULL);
+	return __cpu_notify(val, cpu, -1, NULL);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void cpu_notify_nofail(unsigned long val, void *v)
+static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
 {
-	BUG_ON(cpu_notify(val, v));
+	BUG_ON(cpu_notify(val, cpu));
 }
 EXPORT_SYMBOL(register_cpu_notifier);
 EXPORT_SYMBOL(__register_cpu_notifier);
@@ -291,23 +295,17 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
-struct take_cpu_down_param {
-	unsigned long mod;
-	void *hcpu;
-};
-
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
-	struct take_cpu_down_param *param = _param;
-	int err;
+	int err, cpu = smp_processor_id();
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
 		return err;
 
-	cpu_notify(CPU_DYING | param->mod, param->hcpu);
+	cpu_notify(CPU_DYING, cpu);
 	/* Park the stopper thread */
 	kthread_park(current);
 	return 0;
@@ -317,12 +315,6 @@ static int __ref take_cpu_down(void *_param)
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
-	struct take_cpu_down_param tcd_param = {
-		.mod = mod,
-		.hcpu = hcpu,
-	};
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -332,10 +324,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	cpu_hotplug_begin();
 
-	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpuhp_tasks_frozen = tasks_frozen;
+
+	err = __cpu_notify(CPU_DOWN_PREPARE, cpu, -1, &nr_calls);
 	if (err) {
 		nr_calls--;
-		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_DOWN_FAILED, cpu, nr_calls, NULL);
 		pr_warn("%s: attempt to take down CPU %u failed\n",
 			__func__, cpu);
 		goto out_release;
@@ -362,11 +356,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	 * So now all preempt/rcu users must observe !cpu_active().
 	 */
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, NULL, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		smpboot_unpark_threads(cpu);
-		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
+		cpu_notify_nofail(CPU_DOWN_FAILED, cpu);
 		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
@@ -385,14 +379,14 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	__cpu_die(cpu);
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
+	cpu_notify_nofail(CPU_DEAD, cpu);
 
 	check_for_tasks(cpu);
 
 out_release:
 	cpu_hotplug_done();
 	if (!err)
-		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+		cpu_notify_nofail(CPU_POST_DEAD, cpu);
 	return err;
 }
 
@@ -419,10 +413,8 @@ EXPORT_SYMBOL(cpu_down);
 /* Requires cpu_add_remove_lock to be held */
 static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
-	int ret, nr_calls = 0;
-	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;
+	int ret, nr_calls = 0;
 
 	cpu_hotplug_begin();
 
@@ -441,7 +433,9 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen)
 	if (ret)
 		goto out;
 
-	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
+	cpuhp_tasks_frozen = tasks_frozen;
+
+	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
 		pr_warn("%s: attempt to bring up CPU %u failed\n",
@@ -459,11 +453,11 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen)
 	smpboot_unpark_threads(cpu);
 
 	/* Now call notifier in preparation. */
-	cpu_notify(CPU_ONLINE | mod, hcpu);
+	cpu_notify(CPU_ONLINE, cpu);
 
 out_notify:
 	if (ret != 0)
-		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
 out:
 	cpu_hotplug_done();
 
@@ -650,13 +644,7 @@ core_initcall(cpu_hotplug_pm_sync_init);
  */
 void notify_cpu_starting(unsigned int cpu)
 {
-	unsigned long val = CPU_STARTING;
-
-#ifdef CONFIG_PM_SLEEP_SMP
-	if (frozen_cpus != NULL && cpumask_test_cpu(cpu, frozen_cpus))
-		val = CPU_STARTING_FROZEN;
-#endif /* CONFIG_PM_SLEEP_SMP */
-	cpu_notify(val, (void *)(long)cpu);
+	cpu_notify(CPU_STARTING, cpu);
 }
 
 #endif /* CONFIG_SMP */
-- 
2.0.0.rc2

