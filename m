Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaIYIgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:36:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:61732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaIYIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:36:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="608342368"
From: Lan Tianyu <tianyu.lan@intel.com>
To: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com, akpm@linux-foundation.org, tianyu.lan@intel.com,
        ktkhai@parallels.com, fabf@skynet.be, laijs@cn.fujitsu.com,
        srivatsa.bhat@linux.vnet.ibm.com, srivatsa@mit.edu,
        ego@linux.vnet.ibm.com, viresh.kumar@linaro.org
Cc: todd.e.brandt@linux.intel.com, tipbot@zytor.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH V3 1/3] PM/CPU: Parallel enalbing nonboot cpus with resume devices
Date: Thu, 25 Sep 2014 16:32:03 +0800
Message-Id: <1411633925-9018-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
References: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current world, all nonboot cpus are enalbed serially during system
resume. System resume sequence is that boot cpu enables nonboot cpu one by
one and then resume devices. Before resuming devices, there are few tasks
assigned to nonboot cpus after they are brought up. This waste cpu usage.

To accelerate S3, this patchset is to allow boot cpu to go forward to
resume devices after bringing up one nonboot cpu and starting a thread.
The thread will be in charge of bringing up other frozen cpus. The thread
will be scheduled to the first online cpu to run . This makes enabling
cpu2~x parallel with resuming devices.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 kernel/cpu.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 11 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 356450f..24c4889 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -572,8 +572,41 @@ void __weak arch_enable_nonboot_cpus_end(void)
 {
 }
 
+static int _cpu_up_for_pm(int cpu)
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
+static int async_enable_nonboot_cpus(void *data)
+{
+	int cpu;
+
+	arch_enable_nonboot_cpus_begin();
+
+	for_each_cpu(cpu, frozen_cpus) {
+		_cpu_up_for_pm(cpu);
+	}
+
+	arch_enable_nonboot_cpus_end();
+	cpumask_clear(frozen_cpus);
+	cpu_maps_update_done();
+	return 0;
+}
+
 void __ref enable_nonboot_cpus(void)
 {
+	struct task_struct *tsk;
 	int cpu, error;
 
 	/* Allow everyone to use the CPU hotplug again */
@@ -584,21 +617,33 @@ void __ref enable_nonboot_cpus(void)
 
 	pr_info("Enabling non-boot CPUs ...\n");
 
-	arch_enable_nonboot_cpus_begin();
+	cpu = cpumask_first(frozen_cpus);
+	cpumask_clear_cpu(cpu, frozen_cpus);
+	error = _cpu_up_for_pm(cpu);
+	if (error) {
+		pr_err("Failed to bring up first non-boot cpu.\n");
+		goto fail;
+	}
 
-	for_each_cpu(cpu, frozen_cpus) {
-		trace_suspend_resume(TPS("CPU_ON"), cpu, true);
-		error = _cpu_up(cpu, 1);
-		trace_suspend_resume(TPS("CPU_ON"), cpu, false);
-		if (!error) {
-			pr_info("CPU%d is up\n", cpu);
-			continue;
-		}
-		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
+	tsk = kthread_run(async_enable_nonboot_cpus,
+			NULL, "async-enable-nonboot-cpus");
+	if (IS_ERR(tsk)) {
+		pr_err("Failed to create async enable nonboot cpus thread.\n");
+		goto fail;
 	}
+	return;
 
+fail:
+	/*
+	 * If fail to bring up the first frozen cpu or
+	 * start async thread, enable these rest frozen cpus
+	 * on the boot cpu.
+	 */
+	arch_enable_nonboot_cpus_begin();
+	for_each_cpu(cpu, frozen_cpus) {
+		_cpu_up_for_pm(cpu);
+	}
 	arch_enable_nonboot_cpus_end();
-
 	cpumask_clear(frozen_cpus);
 out:
 	cpu_maps_update_done();
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

