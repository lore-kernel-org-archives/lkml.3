Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbaGWJJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:09:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:13606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588AbaGWJJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,716,1400050800"; 
   d="scan'208";a="565944627"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, peterz@infradead.org,
        toshi.kani@hp.com, mingo@kernel.org, akpm@linux-foundation.org,
        todd.e.brandt@linux.intel.com, fabf@skynet.be,
        srivatsa.bhat@linux.vnet.ibm.com, tianyu.lan@intel.com,
        ego@linux.vnet.ibm.com
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH] PM/CPU: Parallel enabling nonboot cpus with resume devices
Date: Wed, 23 Jul 2014 17:11:34 +0800
Message-Id: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current world, all nonboot cpus are enabled serially during system
resume. System resume sequence is that boot cpu enables nonboot cpu one by
one and then resume devices. Before resuming devices, there are few tasks
assigned to nonboot cpus after they are brought up. This waste cpu usage.

To accelerate S3, this patches adds a new kernel configure
PM_PARALLEL_CPU_UP_FOR_SUSPEND to allow boot cpu to go forward to resume
devices after bringing up one nonboot cpu. The nonboot cpu will be in charge
of bringing up other cpus. This makes enabling cpu2~x parallel with resuming
devices. From the test result on 4 logical core laptop, the time of resume
device almost wasn't affected by enabling nonboot cpus lately while the start
point is almost 30ms earlier than before.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 kernel/cpu.c         | 82 ++++++++++++++++++++++++++++++++++++++++++++++------
 kernel/power/Kconfig | 13 +++++++++
 2 files changed, 86 insertions(+), 9 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a343bde..d4c1353 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -551,9 +551,27 @@ void __weak arch_enable_nonboot_cpus_end(void)
 {
 }
 
+static int _cpu_up_with_trace(int cpu)
+{
+	int error;
+
+	trace_suspend_resume(TPS("CPU_ON"), cpu, true);
+	error = _cpu_up(cpu, 1);
+	trace_suspend_resume(TPS("CPU_ON"), cpu, false);
+	if (error) {
+		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
+		return error;
+	}
+
+	pr_info("CPU%d is up\n", cpu);
+	return 0;
+}
+
+#ifndef CONFIG_PM_PARALLEL_CPU_UP_FOR_SUSPEND
+
 void __ref enable_nonboot_cpus(void)
 {
-	int cpu, error;
+	int cpu;
 
 	/* Allow everyone to use the CPU hotplug again */
 	cpu_maps_update_begin();
@@ -566,14 +584,7 @@ void __ref enable_nonboot_cpus(void)
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
-		trace_suspend_resume(TPS("CPU_ON"), cpu, true);
-		error = _cpu_up(cpu, 1);
-		trace_suspend_resume(TPS("CPU_ON"), cpu, false);
-		if (!error) {
-			pr_info("CPU%d is up\n", cpu);
-			continue;
-		}
-		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
+		_cpu_up_with_trace(cpu);
 	}
 
 	arch_enable_nonboot_cpus_end();
@@ -583,6 +594,59 @@ out:
 	cpu_maps_update_done();
 }
 
+#else
+
+static int async_enable_nonboot_cpus(void *data)
+{
+	int cpu;
+
+	cpu_maps_update_begin();
+
+	for_each_cpu(cpu, frozen_cpus) {
+		_cpu_up_with_trace(cpu);
+	}
+
+	arch_enable_nonboot_cpus_end();
+	cpumask_clear(frozen_cpus);
+	cpu_maps_update_done();
+	return 0;
+}
+
+void __ref enable_nonboot_cpus(void)
+{
+	struct task_struct *tsk;
+	int cpu;
+
+	/* Allow everyone to use the CPU hotplug again */
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	if (cpumask_empty(frozen_cpus))
+		goto out;
+
+	arch_enable_nonboot_cpus_begin();
+
+	cpu = cpumask_first(frozen_cpus);
+	cpumask_clear_cpu(cpu, frozen_cpus);
+
+	_cpu_up_with_trace(cpu);
+
+	if (cpumask_empty(frozen_cpus)) {
+		arch_enable_nonboot_cpus_end();
+	} else {
+		tsk = kthread_create_on_cpu(async_enable_nonboot_cpus,
+				NULL, cpu, "async-enable-nonboot-cpus");
+		if (IS_ERR(tsk)) {
+			pr_err("Failed to create async enable nonboot cpus thread.\n");
+			goto out;
+		}
+
+		kthread_unpark(tsk);
+	}
+out:
+	cpu_maps_update_done();
+}
+#endif
+
 static int __init alloc_frozen_cpus(void)
 {
 	if (!alloc_cpumask_var(&frozen_cpus, GFP_KERNEL|__GFP_ZERO))
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 9a83d78..e5e6671 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -110,6 +110,19 @@ config PM_AUTOSLEEP
 	Allow the kernel to trigger a system transition into a global sleep
 	state automatically whenever there are no active wakeup sources.
 
+config PM_PARALLEL_CPU_UP_FOR_SUSPEND
+	bool "Parallel non-boot cpus up for system suspend"
+	depends on SMP
+	depends on PM_SLEEP
+	default n
+	---help---
+	In the current world, all nonboot cpus are enabled serially during system
+	resume. System resume sequence is that boot cpu enables nonboot cpu one by
+	one and then resume devices. Before resuming devices, there are few tasks
+	assigned to nonboot cpus. To accelerate S3, this option allows boot cpu
+	to go forward to resume devices after bringing up one nonboot cpu. The
+	nonboot cpu will be in charge of bring up other cpus.
+
 config PM_WAKELOCKS
 	bool "User space wakeup sources interface"
 	depends on PM_SLEEP
-- 
1.8.3.1

