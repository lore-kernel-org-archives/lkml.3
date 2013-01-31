Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3AaMLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:55907 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3AaMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:23 -0500
Message-Id: <20130131120742.311854364@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 12/40] x86: uncore: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpuhotplug-convert-intel-uncore.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the notifiers to state machine states and let the core code do
the setup for the already online cpus. This notifier has a completely
undocumented ordering requirement versus perf hardcoded in the
notifier priority. Move the callback to the proper place in the state
machine.

Note, the original code did not check the return values of the setup
functions and I could not be bothered to twist my brain around undoing
the previous steps. Marked with a FIXME.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  109 ++++++--------------------
 include/linux/cpuhotplug.h                    |    3 
 2 files changed, 30 insertions(+), 82 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_uncore.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2622,7 +2622,7 @@ static void __init uncore_pci_exit(void)
 	}
 }
 
-static void __cpuinit uncore_cpu_dead(int cpu)
+static int __cpuinit uncore_dead_cpu(unsigned int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -2639,9 +2639,11 @@ static void __cpuinit uncore_cpu_dead(in
 				kfree(box);
 		}
 	}
+	return 0;
 }
 
-static int __cpuinit uncore_cpu_starting(int cpu)
+/* Must run on the target cpu */
+static int __cpuinit uncore_starting_cpu(unsigned int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -2681,12 +2683,12 @@ static int __cpuinit uncore_cpu_starting
 	return 0;
 }
 
-static int __cpuinit uncore_cpu_prepare(int cpu, int phys_id)
+static int __cpuinit uncore_prepare_cpu(unsigned int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, j;
+	int i, j, phys_id = -1;
 
 	for (i = 0; msr_uncores[i]; i++) {
 		type = msr_uncores[i];
@@ -2745,13 +2747,13 @@ uncore_change_context(struct intel_uncor
 	}
 }
 
-static void __cpuinit uncore_event_exit_cpu(int cpu)
+static int __cpuinit uncore_offline_cpu(unsigned int cpu)
 {
 	int i, phys_id, target;
 
 	/* if exiting cpu is used for collecting uncore events */
 	if (!cpumask_test_and_clear_cpu(cpu, &uncore_cpu_mask))
-		return;
+		return 0;
 
 	/* find a new cpu to collect uncore events */
 	phys_id = topology_physical_package_id(cpu);
@@ -2771,78 +2773,29 @@ static void __cpuinit uncore_event_exit_
 
 	uncore_change_context(msr_uncores, cpu, target);
 	uncore_change_context(pci_uncores, cpu, target);
+	return 0;
 }
 
-static void __cpuinit uncore_event_init_cpu(int cpu)
+static int __cpuinit uncore_online_cpu(unsigned int cpu)
 {
 	int i, phys_id;
 
 	phys_id = topology_physical_package_id(cpu);
 	for_each_cpu(i, &uncore_cpu_mask) {
 		if (phys_id == topology_physical_package_id(i))
-			return;
+			return 0;
 	}
 
 	cpumask_set_cpu(cpu, &uncore_cpu_mask);
 
 	uncore_change_context(msr_uncores, -1, cpu);
 	uncore_change_context(pci_uncores, -1, cpu);
-}
-
-static int
- __cpuinit uncore_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (long)hcpu;
-
-	/* allocate/free data structure for uncore box */
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		uncore_cpu_prepare(cpu, -1);
-		break;
-	case CPU_STARTING:
-		uncore_cpu_starting(cpu);
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_DEAD:
-		uncore_cpu_dead(cpu);
-		break;
-	default:
-		break;
-	}
-
-	/* select the cpu that collects uncore events */
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_DOWN_FAILED:
-	case CPU_STARTING:
-		uncore_event_init_cpu(cpu);
-		break;
-	case CPU_DOWN_PREPARE:
-		uncore_event_exit_cpu(cpu);
-		break;
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block uncore_cpu_nb __cpuinitdata = {
-	.notifier_call	= uncore_cpu_notifier,
-	/*
-	 * to migrate uncore events, our notifier should be executed
-	 * before perf core's notifier.
-	 */
-	.priority	= CPU_PRI_PERF + 1,
-};
-
-static void __init uncore_cpu_setup(void *dummy)
-{
-	uncore_cpu_starting(smp_processor_id());
+	return 0;
 }
 
 static int __init uncore_cpu_init(void)
 {
-	int ret, cpu, max_cores;
+	int ret, max_cores;
 
 	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
@@ -2879,28 +2832,20 @@ static int __init uncore_cpu_init(void)
 	if (ret)
 		return ret;
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu) {
-		int i, phys_id = topology_physical_package_id(cpu);
-
-		for_each_cpu(i, &uncore_cpu_mask) {
-			if (phys_id == topology_physical_package_id(i)) {
-				phys_id = -1;
-				break;
-			}
-		}
-		if (phys_id < 0)
-			continue;
-
-		uncore_cpu_prepare(cpu, phys_id);
-		uncore_event_init_cpu(cpu);
-	}
-	on_each_cpu(uncore_cpu_setup, NULL, 1);
-
-	register_cpu_notifier(&uncore_cpu_nb);
-
-	put_online_cpus();
+	/*
+	 * Install callbacks. Core will call them for each online
+	 * cpu.
+	 *
+	 * FIXME: This should check the return value, but the original
+	 * code did not do that either and I have no idea how to undo
+	 * uncore_types_init(). Brilliant stuff that, isn't it ?
+	 */
+	cpuhp_setup_state(CPUHP_PERF_X86_UNCORE_PREP, uncore_prepare_cpu,
+			  uncore_dead_cpu);
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_UNCORE_STARTING,
+			  uncore_starting_cpu, NULL);
+	cpuhp_setup_state(CPUHP_PERF_X86_UNCORE_ONLINE, uncore_online_cpu,
+			  uncore_offline_cpu);
 
 	return 0;
 }
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -4,12 +4,14 @@
 enum cpuhp_states {
 	CPUHP_OFFLINE,
 	CPUHP_CREATE_THREADS,
+	CPUHP_PERF_X86_UNCORE_PREP,
 	CPUHP_NOTIFY_PREPARE,
 	CPUHP_NOTIFY_DEAD,
 	CPUHP_SCHED_DEAD,
 	CPUHP_BRINGUP_CPU,
 	CPUHP_AP_OFFLINE,
 	CPUHP_AP_SCHED_STARTING,
+	CPUHP_AP_PERF_X86_UNCORE_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_MAX,
@@ -18,6 +20,7 @@ enum cpuhp_states {
 	CPUHP_SCHED_ONLINE,
 	CPUHP_NOTIFY_ONLINE,
 	CPUHP_NOTIFY_DOWN_PREPARE,
+	CPUHP_PERF_X86_UNCORE_ONLINE,
 	CPUHP_MAX,
 };
 


