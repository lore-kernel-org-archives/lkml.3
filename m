Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaFJJht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:37:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56848 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaFJJhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:37:46 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [RFC PATCH] perf/amd: Try to fix some mem allocation failure handling
Date: Tue, 10 Jun 2014 17:37:09 +0800
Message-Id: <1402393029-11561-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2.0 of "[PATCH 1/1] perf/amd: NULL return of kzalloc_node should be handled"
(http://www.spinics.net/lists/kernel/msg1760689.html),

Try to correctly handle mem allocation failure in perf_event_amd_uncore.c

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |   36 ++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 3bbdf4c..bdc8e49 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -294,12 +294,14 @@ static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
 			cpu_to_node(cpu));
 }
 
-static void amd_uncore_cpu_up_prepare(unsigned int cpu)
+static int amd_uncore_cpu_up_prepare(unsigned int cpu)
 {
 	struct amd_uncore *uncore;
 
 	if (amd_uncore_nb) {
 		uncore = amd_uncore_alloc(cpu);
+		if (!uncore)
+			return 1;
 		uncore->cpu = cpu;
 		uncore->num_counters = NUM_COUNTERS_NB;
 		uncore->rdpmc_base = RDPMC_BASE_NB;
@@ -311,6 +313,11 @@ static void amd_uncore_cpu_up_prepare(unsigned int cpu)
 
 	if (amd_uncore_l2) {
 		uncore = amd_uncore_alloc(cpu);
+		if (!uncore) {
+			if (amd_uncore_nb)
+				kfree(*per_cpu_ptr(amd_uncore_nb, cpu));
+			return 1;
+		}
 		uncore->cpu = cpu;
 		uncore->num_counters = NUM_COUNTERS_L2;
 		uncore->rdpmc_base = RDPMC_BASE_L2;
@@ -319,6 +326,8 @@ static void amd_uncore_cpu_up_prepare(unsigned int cpu)
 		uncore->pmu = &amd_l2_pmu;
 		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
 	}
+
+	return 0;
 }
 
 static struct amd_uncore *
@@ -461,7 +470,8 @@ amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		amd_uncore_cpu_up_prepare(cpu);
+		if (amd_uncore_cpu_up_prepare(cpu))
+			return notifier_from_errno(-ENOMEM),
 		break;
 
 	case CPU_STARTING:
@@ -514,6 +524,8 @@ static int __init amd_uncore_init(void)
 
 	if (cpu_has_perfctr_nb) {
 		amd_uncore_nb = alloc_percpu(struct amd_uncore *);
+		if (!amd_uncore_nb)
+			return -ENOMEM;
 		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
 
 		printk(KERN_INFO "perf: AMD NB counters detected\n");
@@ -522,6 +534,13 @@ static int __init amd_uncore_init(void)
 
 	if (cpu_has_perfctr_l2) {
 		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
+		if (!amd_uncore_l2) {
+			if (cpu_has_perfctr_nb) {
+				perf_pmu_unregister(&amd_nb_pmu);
+				free_percpu(amd_uncore_nb);
+			}
+			return -ENOMEM;
+		}
 		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
 
 		printk(KERN_INFO "perf: AMD L2I counters detected\n");
@@ -535,7 +554,18 @@ static int __init amd_uncore_init(void)
 
 	/* init cpus already online before registering for hotplug notifier */
 	for_each_online_cpu(cpu) {
-		amd_uncore_cpu_up_prepare(cpu);
+		if (amd_uncore_cpu_up_prepare(cpu)) {
+			if (cpu_has_perfctr_nb) {
+				perf_pmu_unregister(&amd_nb_pmu);
+				free_percpu(amd_uncore_nb);
+			}
+			if (cpu_has_perfctr_l2) {
+				perf_pmu_unregister(&amd_l2_pmu);
+				free_percpu(amd_uncore_l2);
+			}
+			cpu_notifier_register_done();
+			return -ENOMEM;
+		}
 		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
 	}
 
-- 
1.7.10.4

