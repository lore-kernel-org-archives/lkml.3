Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3AaMLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:55940 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AaMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:25 -0500
Message-Id: <20130131120742.507792549@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 15/40] x86: perf: Convert AMD IBS to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=x86-perf-amd-ibs-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Install the callbacks via the state machine and let the core invoke
the callbacks on the already online cpus.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   54 +++++++++++--------------------
 include/linux/cpuhotplug.h               |    1 
 2 files changed, 21 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd_ibs.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -637,13 +637,10 @@ static __init int perf_ibs_pmu_init(stru
 	return ret;
 }
 
-static __init int perf_event_ibs_init(void)
+static __init void perf_event_ibs_init(void)
 {
 	struct attribute **attr = ibs_op_format_attrs;
 
-	if (!ibs_caps)
-		return -ENODEV;	/* ibs not supported by the cpu */
-
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
@@ -654,13 +651,11 @@ static __init int perf_event_ibs_init(vo
 
 	register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
-
-	return 0;
 }
 
 #else /* defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD) */
 
-static __init int perf_event_ibs_init(void) { return 0; }
+static __init void perf_event_ibs_init(void) { }
 
 #endif
 
@@ -827,11 +822,10 @@ static inline int get_ibs_lvt_offset(voi
 	return val & IBSCTL_LVT_OFFSET_MASK;
 }
 
-static void setup_APIC_ibs(void *dummy)
+static void setup_APIC_ibs(void)
 {
-	int offset;
+	int offset = get_ibs_lvt_offset();
 
-	offset = get_ibs_lvt_offset();
 	if (offset < 0)
 		goto failed;
 
@@ -842,30 +836,19 @@ failed:
 		smp_processor_id());
 }
 
-static void clear_APIC_ibs(void *dummy)
+static int __cpuinit x86_pmu_amd_ibs_starting_cpu(unsigned int cpu)
 {
-	int offset;
-
-	offset = get_ibs_lvt_offset();
-	if (offset >= 0)
-		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+	setup_APIC_ibs();
+	return 0;
 }
 
-static int __cpuinit
-perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+static int __cpuinit x86_pmu_amd_ibs_dying_cpu(unsigned int cpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
-		setup_APIC_ibs(NULL);
-		break;
-	case CPU_DYING:
-		clear_APIC_ibs(NULL);
-		break;
-	default:
-		break;
-	}
+	int offset = get_ibs_lvt_offset();
 
-	return NOTIFY_OK;
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+	return 0;
 }
 
 static __init int amd_ibs_init(void)
@@ -889,15 +872,18 @@ static __init int amd_ibs_init(void)
 	if (!ibs_eilvt_valid())
 		goto out;
 
-	get_online_cpus();
 	ibs_caps = caps;
 	/* make ibs_caps visible to other cpus: */
 	smp_mb();
-	perf_cpu_notifier(perf_ibs_cpu_notifier);
-	smp_call_function(setup_APIC_ibs, NULL, 1);
-	put_online_cpus();
+	/*
+	 * x86_pmu_amd_ibs_starting_cpu will be called from core on
+	 * all online cpus.
+	 */
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  x86_pmu_amd_ibs_starting_cpu,
+			  x86_pmu_amd_ibs_dying_cpu);
 
-	ret = perf_event_ibs_init();
+	perf_event_ibs_init();
 out:
 	if (ret)
 		pr_err("Failed to setup IBS, %d\n", ret);
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -14,6 +14,7 @@ enum cpuhp_states {
 	CPUHP_AP_OFFLINE,
 	CPUHP_AP_SCHED_STARTING,
 	CPUHP_AP_PERF_X86_UNCORE_STARTING,
+	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,


