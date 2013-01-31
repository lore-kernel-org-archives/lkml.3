Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3AaMN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:13:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:56169 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3AaMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:43 -0500
Message-Id: <20130131120743.992876989@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:42 -0000
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
Subject: [patch 37/40] x86: x2apic: Convert to cpu hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=0003-cpu-hotplug-convert-x2apic.patch
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
 arch/x86/kernel/apic/x2apic_cluster.c |   80 ++++++++++++----------------------
 include/linux/cpuhotplug.h            |    1 
 2 files changed, 31 insertions(+), 50 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -145,68 +145,48 @@ static void init_x2apic_ldr(void)
 	}
 }
 
- /*
-  * At CPU state changes, update the x2apic cluster sibling info.
-  */
-static int __cpuinit
-update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
+/*
+ * At CPU state changes, update the x2apic cluster sibling info.
+ */
+int __cpuinit x2apic_prepare_cpu(unsigned int cpu)
 {
-	unsigned int this_cpu = (unsigned long)hcpu;
-	unsigned int cpu;
-	int err = 0;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
-					GFP_KERNEL)) {
-			err = -ENOMEM;
-		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
-					       GFP_KERNEL)) {
-			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-			err = -ENOMEM;
-		}
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-		for_each_online_cpu(cpu) {
-			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
-				continue;
-			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
-			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
-		}
-		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
-		break;
+	if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL))
+		return -ENOMEM;
+
+	if (!zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL)) {
+		free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
+		return -ENOMEM;
 	}
 
-	return notifier_from_errno(err);
+	return 0;
 }
 
-static struct notifier_block __refdata x2apic_cpu_notifier = {
-	.notifier_call = update_clusterinfo,
-};
-
-static int x2apic_init_cpu_notifier(void)
+int __cpuinit x2apic_dead_cpu(unsigned int this_cpu)
 {
-	int cpu = smp_processor_id();
-
-	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
-	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+	int cpu;
 
-	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
-
-	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
-	register_hotcpu_notifier(&x2apic_cpu_notifier);
-	return 1;
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+			continue;
+		__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
+	free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+	free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+	return 0;
 }
 
 static int x2apic_cluster_probe(void)
 {
-	if (x2apic_mode)
-		return x2apic_init_cpu_notifier();
-	else
+	int cpu = smp_processor_id();
+
+	if (!x2apic_mode)
 		return 0;
+
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	cpuhp_setup_state(CPUHP_X2APIC_PREPARE, x2apic_prepare_cpu,
+			  x2apic_dead_cpu);
+	return 1;
 }
 
 static const struct cpumask *x2apic_cluster_target_cpus(void)
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -16,6 +16,7 @@ enum cpuhp_states {
 	CPUHP_HRTIMERS_PREPARE,
 	CPUHP_TIMERS_PREPARE,
 	CPUHP_PROFILE_PREPARE,
+	CPUHP_X2APIC_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_CLOCKEVENTS_DEAD,


