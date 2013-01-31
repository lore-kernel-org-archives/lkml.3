Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3AaMLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:55929 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3AaMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:25 -0500
Message-Id: <20130131120742.443111856@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 14/40] x86: perf: Convert the core to the hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpuhotplug-x86-perf-core-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the perf_notifier() install mechanism, which invokes magically
the callback on the current cpu. Convert the hardware specific
callbacks which are invoked from the x86 perf core to return proper
error codes instead of totally pointless NOTIFY_BAD return values.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event.c       |   78 ++++++++++++++++++---------------
 arch/x86/kernel/cpu/perf_event_amd.c   |    6 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    6 +-
 include/linux/cpuhotplug.h             |    3 +
 4 files changed, 52 insertions(+), 41 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1252,47 +1252,45 @@ perf_event_nmi_handler(unsigned int cmd,
 struct event_constraint emptyconstraint;
 struct event_constraint unconstrained;
 
-static int __cpuinit
-x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+static int __cpuinit x86_pmu_prepare_cpu(unsigned int cpu)
 {
-	unsigned int cpu = (long)hcpu;
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	int ret = NOTIFY_OK;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		cpuc->kfree_on_online = NULL;
-		if (x86_pmu.cpu_prepare)
-			ret = x86_pmu.cpu_prepare(cpu);
-		break;
-
-	case CPU_STARTING:
-		if (x86_pmu.attr_rdpmc)
-			set_in_cr4(X86_CR4_PCE);
-		if (x86_pmu.cpu_starting)
-			x86_pmu.cpu_starting(cpu);
-		break;
+	cpuc->kfree_on_online = NULL;
+	if (x86_pmu.cpu_prepare)
+		return x86_pmu.cpu_prepare(cpu);
+	return 0;
+}
 
-	case CPU_ONLINE:
-		kfree(cpuc->kfree_on_online);
-		break;
+static int __cpuinit x86_pmu_dead_cpu(unsigned int cpu)
+{
+	if (x86_pmu.cpu_dead)
+		x86_pmu.cpu_dead(cpu);
+	return 0;
+}
 
-	case CPU_DYING:
-		if (x86_pmu.cpu_dying)
-			x86_pmu.cpu_dying(cpu);
-		break;
+static int __cpuinit x86_pmu_online_cpu(unsigned int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
-	case CPU_UP_CANCELED:
-	case CPU_DEAD:
-		if (x86_pmu.cpu_dead)
-			x86_pmu.cpu_dead(cpu);
-		break;
+	kfree(cpuc->kfree_on_online);
+	return 0;
+}
 
-	default:
-		break;
-	}
+static int __cpuinit x86_pmu_starting_cpu(unsigned int cpu)
+{
+	if (x86_pmu.attr_rdpmc)
+		set_in_cr4(X86_CR4_PCE);
+	if (x86_pmu.cpu_starting)
+		x86_pmu.cpu_starting(cpu);
+	return 0;
+}
 
-	return ret;
+static int __cpuinit x86_pmu_dying_cpu(unsigned int cpu)
+{
+	if (x86_pmu.cpu_dying)
+		x86_pmu.cpu_dying(cpu);
+	return 0;
 }
 
 static void __init pmu_check_apic(void)
@@ -1485,8 +1483,18 @@ static int __init init_hw_perf_events(vo
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
-	perf_cpu_notifier(x86_pmu_notifier);
-
+	/*
+	 * Install callbacks. Core will call them for each online
+	 * cpu.
+	 *
+	 * FIXME: This should check the return value, but the original
+	 * code did not do that either....
+	 */
+	cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, x86_pmu_prepare_cpu,
+			  x86_pmu_dead_cpu);
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING, x86_pmu_starting_cpu,
+			  x86_pmu_dying_cpu);
+	cpuhp_setup_state(CPUHP_PERF_X86_ONLINE, x86_pmu_online_cpu, NULL);
 	return 0;
 }
 early_initcall(init_hw_perf_events);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -349,13 +349,13 @@ static int amd_pmu_cpu_prepare(int cpu)
 	WARN_ON_ONCE(cpuc->amd_nb);
 
 	if (boot_cpu_data.x86_max_cores < 2)
-		return NOTIFY_OK;
+		return 0;
 
 	cpuc->amd_nb = amd_alloc_nb(cpu);
 	if (!cpuc->amd_nb)
-		return NOTIFY_BAD;
+		return -ENOMEM;
 
-	return NOTIFY_OK;
+	return 0;
 }
 
 static void amd_pmu_cpu_starting(int cpu)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1662,13 +1662,13 @@ static int intel_pmu_cpu_prepare(int cpu
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
 	if (!(x86_pmu.extra_regs || x86_pmu.lbr_sel_map))
-		return NOTIFY_OK;
+		return 0;
 
 	cpuc->shared_regs = allocate_shared_regs(cpu);
 	if (!cpuc->shared_regs)
-		return NOTIFY_BAD;
+		return -ENOMEM;
 
-	return NOTIFY_OK;
+	return 0;
 }
 
 static void intel_pmu_cpu_starting(int cpu)
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -5,6 +5,7 @@ enum cpuhp_states {
 	CPUHP_OFFLINE,
 	CPUHP_CREATE_THREADS,
 	CPUHP_PERF_X86_UNCORE_PREP,
+	CPUHP_PERF_X86_PREPARE,
 	CPUHP_PERF_PREPARE,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
@@ -13,6 +14,7 @@ enum cpuhp_states {
 	CPUHP_AP_OFFLINE,
 	CPUHP_AP_SCHED_STARTING,
 	CPUHP_AP_PERF_X86_UNCORE_STARTING,
+	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_MAX,
@@ -23,6 +25,7 @@ enum cpuhp_states {
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_PERF_X86_UNCORE_ONLINE,
+	CPUHP_PERF_X86_ONLINE,
 	CPUHP_MAX,
 };
 


