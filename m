Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab3CUWA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:00:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33093 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3CUVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:06 -0400
Message-Id: <20130321215234.014923303@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [patch 11/34] bfin: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=bfin-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig           |    1 +
 arch/blackfin/kernel/process.c  |   30 ++----------------------------
 arch/blackfin/mach-common/smp.c |    2 +-
 3 files changed, 4 insertions(+), 29 deletions(-)

Index: linux-2.6/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.orig/arch/blackfin/Kconfig
+++ linux-2.6/arch/blackfin/Kconfig
@@ -41,6 +41,7 @@ config BLACKFIN
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
Index: linux-2.6/arch/blackfin/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/process.c
+++ linux-2.6/arch/blackfin/kernel/process.c
@@ -47,14 +47,14 @@ EXPORT_SYMBOL(pm_power_off);
  */
 #ifdef CONFIG_IDLE_L1
 static void default_idle(void)__attribute__((l1_text));
-void cpu_idle(void)__attribute__((l1_text));
+void arch_cpu_idle(void)__attribute__((l1_text));
 #endif
 
 /*
  * This is our default idle handler.  We need to disable
  * interrupts here to ensure we don't miss a wakeup call.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 #ifdef CONFIG_IPIPE
 	ipipe_suspend_domain();
@@ -67,32 +67,6 @@ static void default_idle(void)
 }
 
 /*
- * The idle thread.  We try to conserve power, while trying to keep
- * overall latency low.  The architecture specific idle is passed
- * a value to indicate the level of "idleness" of the system.
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-
-#ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(smp_processor_id()))
-			cpu_die();
-#endif
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
-/*
  * Do necessary setup to start up a newly executed thread.
  *
  * pass the data segment into user programs if it exists,
Index: linux-2.6/arch/blackfin/mach-common/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/smp.c
+++ linux-2.6/arch/blackfin/mach-common/smp.c
@@ -335,7 +335,7 @@ void __cpuinit secondary_start_kernel(vo
 	 */
 	calibrate_delay();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_prepare_boot_cpu(void)


