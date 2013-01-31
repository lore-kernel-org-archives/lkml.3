Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3AaMTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:19:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:55963 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3AaML1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:27 -0500
Message-Id: <20130131120742.652428223@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 17/40] powerpc: perf: Convert book3s notifier to state machine
 callbacks
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=power-cpu-perf-hotplug-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/perf/core-book3s.c |   29 ++++++-----------------------
 include/linux/cpuhotplug.h      |    1 +
 2 files changed, 7 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/powerpc/perf/core-book3s.c
===================================================================
--- linux-2.6.orig/arch/powerpc/perf/core-book3s.c
+++ linux-2.6/arch/powerpc/perf/core-book3s.c
@@ -1501,31 +1501,15 @@ static void perf_event_interrupt(struct 
 		irq_exit();
 }
 
-static void power_pmu_setup(int cpu)
+int __cpuinit power_pmu_prepare_cpu(unsigned int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
-	if (!ppmu)
-		return;
-	memset(cpuhw, 0, sizeof(*cpuhw));
-	cpuhw->mmcr[0] = MMCR0_FC;
-}
-
-static int __cpuinit
-power_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (long)hcpu;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		power_pmu_setup(cpu);
-		break;
-
-	default:
-		break;
+	if (ppmu) {
+		memset(cpuhw, 0, sizeof(*cpuhw));
+		cpuhw->mmcr[0] = MMCR0_FC;
 	}
-
-	return NOTIFY_OK;
+	return 0;
 }
 
 int __cpuinit register_power_pmu(struct power_pmu *pmu)
@@ -1546,7 +1530,6 @@ int __cpuinit register_power_pmu(struct 
 #endif /* CONFIG_PPC64 */
 
 	perf_pmu_register(&power_pmu, "cpu", PERF_TYPE_RAW);
-	perf_cpu_notifier(power_pmu_notifier);
-
+	cpuhp_setup_state(CPUHP_PERF_POWER, power_pmu_prepare_cpu, NULL);
 	return 0;
 }
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -7,6 +7,7 @@ enum cpuhp_states {
 	CPUHP_PERF_X86_UNCORE_PREP,
 	CPUHP_PERF_X86_PREPARE,
 	CPUHP_PERF_BFIN,
+	CPUHP_PERF_POWER,
 	CPUHP_PERF_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,


