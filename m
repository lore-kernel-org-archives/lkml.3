Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3AaMSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:18:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:55971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3AaML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:28 -0500
Message-Id: <20130131120742.725208782@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 18/40] s390: perf: Convert the hotplug notifier to state
 machine callbacks
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=s390-perf-cpu-hotplug.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/kernel/perf_cpum_cf.c |   37 +++++++++++++++----------------------
 include/linux/cpuhotplug.h      |    1 +
 2 files changed, 16 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/s390/kernel/perf_cpum_cf.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/perf_cpum_cf.c
+++ linux-2.6/arch/s390/kernel/perf_cpum_cf.c
@@ -640,26 +640,20 @@ static struct pmu cpumf_pmu = {
 	.cancel_txn   = cpumf_pmu_cancel_txn,
 };
 
-static int __cpuinit cpumf_pmu_notifier(struct notifier_block *self,
-					unsigned long action, void *hcpu)
+static int __cpuinit cpumf_pmf_setup(unsigned int cpu, int flags)
 {
-	unsigned int cpu = (long) hcpu;
-	int flags;
+	smp_call_function_single(cpu, setup_pmc_cpu, &flags, 1);
+	return 0;
+}
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
-		flags = PMC_INIT;
-		smp_call_function_single(cpu, setup_pmc_cpu, &flags, 1);
-		break;
-	case CPU_DOWN_PREPARE:
-		flags = PMC_RELEASE;
-		smp_call_function_single(cpu, setup_pmc_cpu, &flags, 1);
-		break;
-	default:
-		break;
-	}
+static int __cpuinit s390_pmu_online_cpu(unsigned int cpu)
+{
+	return cpumf_pmf_setup(cpu, PMC_INIT);
+}
 
-	return NOTIFY_OK;
+static int __cpuinit s390_pmu_offline_cpu(unsigned int cpu)
+{
+	return cpumf_pmf_setup(cpu, PMC_RELEASE);
 }
 
 static int __init cpumf_pmu_init(void)
@@ -678,17 +672,16 @@ static int __init cpumf_pmu_init(void)
 	if (rc) {
 		pr_err("Registering for CPU-measurement alerts "
 		       "failed with rc=%i\n", rc);
-		goto out;
+		return rc;
 	}
 
 	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
 	if (rc) {
 		pr_err("Registering the cpum_cf PMU failed with rc=%i\n", rc);
 		unregister_external_interrupt(0x1407, cpumf_measurement_alert);
-		goto out;
+		return rc;
 	}
-	perf_cpu_notifier(cpumf_pmu_notifier);
-out:
-	return rc;
+	return cpuhp_setup_state(CPUHP_PERF_S390_ONLINE, s390_pmu_online_cpu,
+				 s390_pmu_offline_cpu);
 }
 early_initcall(cpumf_pmu_init);
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -29,6 +29,7 @@ enum cpuhp_states {
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
 	CPUHP_PERF_X86_ONLINE,
+	CPUHP_PERF_S390_ONLINE,
 	CPUHP_MAX,
 };
 


