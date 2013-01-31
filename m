Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3AaMQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:16:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:56058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3AaMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:34 -0500
Message-Id: <20130131120743.251829934@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 26/40] arm: perf: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=arm-perf-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward conversion w/o bells and whistles.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/perf_event_cpu.c |   28 +++++-----------------------
 include/linux/cpuhotplug.h       |    1 +
 2 files changed, 6 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event_cpu.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event_cpu.c
+++ linux-2.6/arch/arm/kernel/perf_event_cpu.c
@@ -157,24 +157,13 @@ static void cpu_pmu_init(struct arm_pmu 
  * UNKNOWN at reset, the PMU must be explicitly reset to avoid reading
  * junk values out of them.
  */
-static int __cpuinit cpu_pmu_notify(struct notifier_block *b,
-				    unsigned long action, void *hcpu)
+static int __cpuinit arm_perf_starting_cpu(unsigned int cpu)
 {
-	if ((action & ~CPU_TASKS_FROZEN) != CPU_STARTING)
-		return NOTIFY_DONE;
-
 	if (cpu_pmu && cpu_pmu->reset)
 		cpu_pmu->reset(cpu_pmu);
-	else
-		return NOTIFY_DONE;
-
-	return NOTIFY_OK;
+	return 0;
 }
 
-static struct notifier_block __cpuinitdata cpu_pmu_hotplug_notifier = {
-	.notifier_call = cpu_pmu_notify,
-};
-
 /*
  * PMU platform driver and devicetree bindings.
  */
@@ -304,16 +293,9 @@ static struct platform_driver cpu_pmu_dr
 
 static int __init register_pmu_driver(void)
 {
-	int err;
-
-	err = register_cpu_notifier(&cpu_pmu_hotplug_notifier);
-	if (err)
-		return err;
-
-	err = platform_driver_register(&cpu_pmu_driver);
-	if (err)
-		unregister_cpu_notifier(&cpu_pmu_hotplug_notifier);
+	int err = platform_driver_register(&cpu_pmu_driver);
 
-	return err;
+	return err ? err : cpuhp_setup_state_nocalls(CPUHP_AP_PERF_ARM_STARTING,
+						     arm_perf_starting_cpu, NULL);
 }
 device_initcall(register_pmu_driver);
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -22,6 +22,7 @@ enum cpuhp_states {
 	CPUHP_AP_PERF_X86_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
+	CPUHP_AP_PERF_ARM_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,


