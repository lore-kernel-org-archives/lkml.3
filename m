Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3AaMNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:13:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:56178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3AaMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:44 -0500
Message-Id: <20130131120744.055991611@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [patch 38/40] smp: Convert core to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0004-cpu-hotplug-convert-smp-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |    5 ++++
 kernel/cpu.c               |    4 +++
 kernel/smp.c               |   50 ++++++++++++++++-----------------------------
 3 files changed, 27 insertions(+), 32 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -17,6 +17,7 @@ enum cpuhp_states {
 	CPUHP_TIMERS_PREPARE,
 	CPUHP_PROFILE_PREPARE,
 	CPUHP_X2APIC_PREPARE,
+	CPUHP_SMPCFD_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,
@@ -199,4 +200,8 @@ int profile_online_cpu(unsigned int cpu)
 #define profile_online_cpu	NULL
 #endif
 
+/* SMP core functions */
+int smpcfd_prepare_cpu(unsigned int cpu);
+int smpcfd_dead_cpu(unsigned int cpu);
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -764,6 +764,10 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup = profile_prepare_cpu,
 		.teardown = profile_dead_cpu,
 	},
+	[CPUHP_SMPCFD_PREPARE] = {
+		.startup = smpcfd_prepare_cpu,
+		.teardown = smpcfd_dead_cpu,
+	},
 	[CPUHP_NOTIFY_PREPARE] = {
 		.startup = notify_prepare,
 		.teardown = NULL,
Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -45,45 +45,32 @@ struct call_single_queue {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
 
-static int
-hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+int __cpuinit smpcfd_prepare_cpu(unsigned int cpu)
 {
-	long cpu = (long)hcpu;
 	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return notifier_from_errno(-ENOMEM);
-		break;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				     cpu_to_node(cpu)))
+		return -ENOMEM;
+	if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				     cpu_to_node(cpu))) {
 		free_cpumask_var(cfd->cpumask);
-		free_cpumask_var(cfd->cpumask_ipi);
-		break;
-#endif
-	};
-
-	return NOTIFY_OK;
+		return -ENOMEM;
+	}
+	return;
 }
 
-static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
-	.notifier_call		= hotplug_cfd,
-};
+int __cpuinit smpcfd_dead_cpu(unsigned int cpu)
+{
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	free_cpumask_var(cfd->cpumask);
+	free_cpumask_var(cfd->cpumask_ipi);
+	return 0;
+}
 
 void __init call_function_init(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -93,8 +80,7 @@ void __init call_function_init(void)
 		INIT_LIST_HEAD(&q->list);
 	}
 
-	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
-	register_cpu_notifier(&hotplug_cfd_notifier);
+	smpcfd_prepare_cpu(smp_processor_id());
 }
 
 /*


