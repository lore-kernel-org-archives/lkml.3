Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3CUV7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:59:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33110 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3CUVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:08 -0400
Message-Id: <20130321215234.148829489@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 13/34] cris: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=cris-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Kconfig                   |    1 +
 arch/cris/arch-v10/kernel/process.c |    3 ++-
 arch/cris/arch-v32/kernel/process.c |   10 ++++------
 arch/cris/arch-v32/kernel/smp.c     |    4 +---
 arch/cris/kernel/process.c          |   24 ++----------------------
 5 files changed, 10 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/cris/Kconfig
===================================================================
--- linux-2.6.orig/arch/cris/Kconfig
+++ linux-2.6/arch/cris/Kconfig
@@ -48,6 +48,7 @@ config CRIS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS2
Index: linux-2.6/arch/cris/arch-v10/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/process.c
+++ linux-2.6/arch/cris/arch-v10/kernel/process.c
@@ -30,8 +30,9 @@ void etrax_gpio_wake_up_check(void); /* 
 void default_idle(void)
 {
 #ifdef CONFIG_ETRAX_GPIO
-  etrax_gpio_wake_up_check();
+	etrax_gpio_wake_up_check();
 #endif
+	local_irq_enable();
 }
 
 /*
Index: linux-2.6/arch/cris/arch-v32/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/process.c
+++ linux-2.6/arch/cris/arch-v32/kernel/process.c
@@ -23,12 +23,10 @@ extern void stop_watchdog(void);
 /* We use this if we don't have any better idle routine. */
 void default_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched()) {
-		/* Halt until exception. */
-		__asm__ volatile("ei    \n\t"
-				 "halt      ");
-	}
+	/* Halt until exception. */
+	__asm__ volatile("ei    \n\t"
+			 "halt      ");
+	/* CHECKME: Is this really needed ?? */
 	local_irq_enable();
 }
 
Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -145,8 +145,6 @@ smp_boot_one_cpu(int cpuid, struct task_
  * specific stuff such as the local timer and the MMU. */
 void __init smp_callin(void)
 {
-	extern void cpu_idle(void);
-
 	int cpu = cpu_now_booting;
 	reg_intr_vect_rw_mask vect_mask = {0};
 
@@ -170,7 +168,7 @@ void __init smp_callin(void)
 	local_irq_enable();
 
 	set_cpu_online(cpu, true);
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Stop execution on this CPU.*/
Index: linux-2.6/arch/cris/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/process.c
+++ linux-2.6/arch/cris/kernel/process.c
@@ -34,29 +34,9 @@ extern void default_idle(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-
-void cpu_idle (void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			/*
-			 * Mark this as an RCU critical section so that
-			 * synchronize_kernel() in the unload path waits
-			 * for our completion.
-			 */
-			default_idle();
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	default_idle();
 }
 
 void hard_reset_now (void);


