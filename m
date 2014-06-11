Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaFKEJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:09:39 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37400 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaFKEJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:09:38 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [RFC PATCH v2] perf/amd: Try to fix some mem allocation failure handling
Date: Wed, 11 Jun 2014 12:09:03 +0800
Message-Id: <1402459743-20513-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Peter's advice, put the failure handling to a goto chain.
Compiled in x86_64, could you check if there is anything that I missed.
 
Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |  111 ++++++++++++++++++++-------
 1 file changed, 84 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 3bbdf4c..30790d7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -294,31 +294,41 @@ static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
 			cpu_to_node(cpu));
 }
 
-static void amd_uncore_cpu_up_prepare(unsigned int cpu)
+static int amd_uncore_cpu_up_prepare(unsigned int cpu)
 {
-	struct amd_uncore *uncore;
+	struct amd_uncore *uncore_nb = NULL, *uncore_l2;
 
 	if (amd_uncore_nb) {
-		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_NB;
-		uncore->rdpmc_base = RDPMC_BASE_NB;
-		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
-		uncore->active_mask = &amd_nb_active_mask;
-		uncore->pmu = &amd_nb_pmu;
-		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+		uncore_nb = amd_uncore_alloc(cpu);
+		if (!uncore_nb)
+			goto fail;
+		uncore_nb->cpu = cpu;
+		uncore_nb->num_counters = NUM_COUNTERS_NB;
+		uncore_nb->rdpmc_base = RDPMC_BASE_NB;
+		uncore_nb->msr_base = MSR_F15H_NB_PERF_CTL;
+		uncore_nb->active_mask = &amd_nb_active_mask;
+		uncore_nb->pmu = &amd_nb_pmu;
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore_nb;
 	}
 
 	if (amd_uncore_l2) {
-		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_L2;
-		uncore->rdpmc_base = RDPMC_BASE_L2;
-		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
-		uncore->active_mask = &amd_l2_active_mask;
-		uncore->pmu = &amd_l2_pmu;
-		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+		uncore_l2 = amd_uncore_alloc(cpu);
+		if (!uncore_l2)
+			goto fail;
+		uncore_l2->cpu = cpu;
+		uncore_l2->num_counters = NUM_COUNTERS_L2;
+		uncore_l2->rdpmc_base = RDPMC_BASE_L2;
+		uncore_l2->msr_base = MSR_F16H_L2I_PERF_CTL;
+		uncore_l2->active_mask = &amd_l2_active_mask;
+		uncore_l2->pmu = &amd_l2_pmu;
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore_l2;
 	}
+
+	return 0;
+
+fail:
+	kfree(uncore_nb);
+	return -ENOMEM;
 }
 
 static struct amd_uncore *
@@ -441,7 +451,7 @@ static void uncore_dead(unsigned int cpu, struct amd_uncore * __percpu *uncores)
 
 	if (!--uncore->refcnt)
 		kfree(uncore);
-	*per_cpu_ptr(amd_uncore_nb, cpu) = NULL;
+	*per_cpu_ptr(uncores, cpu) = NULL;
 }
 
 static void amd_uncore_cpu_dead(unsigned int cpu)
@@ -461,7 +471,8 @@ amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		amd_uncore_cpu_up_prepare(cpu);
+		if (amd_uncore_cpu_up_prepare(cpu))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 	case CPU_STARTING:
@@ -501,20 +512,33 @@ static void __init init_cpu_already_online(void *dummy)
 	amd_uncore_cpu_online(cpu);
 }
 
+static void cleanup_cpu_online(void *dummy)
+{
+	unsigned int cpu = smp_processor_id();
+
+	amd_uncore_cpu_dead(cpu);
+}
+
 static int __init amd_uncore_init(void)
 {
-	unsigned int cpu;
+	unsigned int cpu, cpu2;
 	int ret = -ENODEV;
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
-		return -ENODEV;
+		goto fail_nodev;
 
 	if (!cpu_has_topoext)
-		return -ENODEV;
+		goto fail_nodev;
 
 	if (cpu_has_perfctr_nb) {
 		amd_uncore_nb = alloc_percpu(struct amd_uncore *);
-		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+		if (!amd_uncore_nb) {
+			ret = -ENOMEM;
+			goto fail_nb;
+		}
+		ret = perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+		if (ret)
+			goto fail_nb;
 
 		printk(KERN_INFO "perf: AMD NB counters detected\n");
 		ret = 0;
@@ -522,20 +546,28 @@ static int __init amd_uncore_init(void)
 
 	if (cpu_has_perfctr_l2) {
 		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
-		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+		if (!amd_uncore_l2) {
+			ret = -ENOMEM;
+			goto fail_l2;
+		}
+		ret = perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+		if (ret)
+			goto fail_l2;
 
 		printk(KERN_INFO "perf: AMD L2I counters detected\n");
 		ret = 0;
 	}
 
 	if (ret)
-		return -ENODEV;
+		goto fail_nodev;
 
 	cpu_notifier_register_begin();
 
 	/* init cpus already online before registering for hotplug notifier */
 	for_each_online_cpu(cpu) {
-		amd_uncore_cpu_up_prepare(cpu);
+		ret = amd_uncore_cpu_up_prepare(cpu);
+		if (ret)
+			goto fail_online;
 		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
 	}
 
@@ -543,5 +575,30 @@ static int __init amd_uncore_init(void)
 	cpu_notifier_register_done();
 
 	return 0;
+
+
+fail_online:
+	for_each_online_cpu(cpu2) {
+		if (cpu2 == cpu)
+			break;
+		smp_call_function_single(cpu, cleanup_cpu_online, NULL, 1);
+	}
+	cpu_notifier_register_done();
+
+	/* amd_uncore_nb/l2 should have been freed by cleanup_cpu_online */
+	amd_uncore_nb = amd_uncore_l2 = NULL;
+	if (cpu_has_perfctr_l2)
+		perf_pmu_unregister(&amd_l2_pmu);
+fail_l2:
+	if (cpu_has_perfctr_nb)
+		perf_pmu_unregister(&amd_nb_pmu);
+	if (amd_uncore_l2)
+		free_percpu(amd_uncore_l2);
+fail_nb:
+	if (amd_uncore_nb)
+		free_percpu(amd_uncore_nb);
+
+fail_nodev:
+	return ret;
 }
 device_initcall(amd_uncore_init);
-- 
1.7.10.4

