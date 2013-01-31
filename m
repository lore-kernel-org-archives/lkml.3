Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3AaMRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:17:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:56050 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AaMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:33 -0500
Message-Id: <20130131120743.187288611@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 25/40] arm: Convert VFP hotplug notifiers to state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=arm-vfp-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward conversion plus commentry why code which is executed
in hotplug callbacks needs to be invoked before installing them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/vfp/vfpmodule.c   |   29 +++++++++++++++++------------
 include/linux/cpuhotplug.h |    1 +
 2 files changed, 18 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/arm/vfp/vfpmodule.c
===================================================================
--- linux-2.6.orig/arch/arm/vfp/vfpmodule.c
+++ linux-2.6/arch/arm/vfp/vfpmodule.c
@@ -633,19 +633,19 @@ int vfp_restore_user_hwstate(struct user
  * hardware state at every thread switch.  We clear our held state when
  * a CPU has been killed, indicating that the VFP hardware doesn't contain
  * a threads VFP state.  When a CPU starts up, we re-enable access to the
- * VFP hardware.
- *
- * Both CPU_DYING and CPU_STARTING are called on the CPU which
+ * VFP hardware. The callbacks below are called on the CPU which
  * is being offlined/onlined.
  */
-static int vfp_hotplug(struct notifier_block *b, unsigned long action,
-	void *hcpu)
+static int __cpuinit vfp_dying_cpu(unsigned int cpu)
 {
-	if (action == CPU_DYING || action == CPU_DYING_FROZEN) {
-		vfp_force_reload((long)hcpu, current_thread_info());
-	} else if (action == CPU_STARTING || action == CPU_STARTING_FROZEN)
-		vfp_enable(NULL);
-	return NOTIFY_OK;
+	vfp_force_reload(cpu, current_thread_info());
+	return 0;
+}
+
+static int __cpuinit vfp_starting_cpu(unsigned int unused)
+{
+	vfp_enable(NULL);
+	return 0;
 }
 
 /*
@@ -653,9 +653,13 @@ static int vfp_hotplug(struct notifier_b
  */
 static int __init vfp_init(void)
 {
-	unsigned int vfpsid;
 	unsigned int cpu_arch = cpu_architecture();
+	unsigned int vfpsid;
 
+	/*
+	 * Enable the access to the VFP on all online cpus so the
+	 * following test on FPSID will succeed.
+	 */
 	if (cpu_arch >= CPU_ARCH_ARMv6)
 		on_each_cpu(vfp_enable, NULL, 1);
 
@@ -676,7 +680,8 @@ static int __init vfp_init(void)
 	else if (vfpsid & FPSID_NODOUBLE) {
 		pr_cont("no double precision support\n");
 	} else {
-		hotcpu_notifier(vfp_hotplug, 0);
+		cpuhp_setup_state_nocall(CPUHP_AP_ARM_VFP_STARTING,
+					 vfp_starting_cpu, vfp_dying_cpu);
 
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
 		pr_cont("implementor %02x architecture %d part %02x variant %x rev %x\n",
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -22,6 +22,7 @@ enum cpuhp_states {
 	CPUHP_AP_PERF_X86_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
+	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,


