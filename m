Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3CUWB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:01:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:33074 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3CUVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:05 -0400
Message-Id: <20130321215233.887563095@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [patch 09/34] arm64: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=arm64-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig          |    1 +
 arch/arm64/kernel/process.c |   43 +++++--------------------------------------
 arch/arm64/kernel/smp.c     |    2 +-
 3 files changed, 7 insertions(+), 39 deletions(-)

Index: linux-2.6/arch/arm64/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm64/Kconfig
+++ linux-2.6/arch/arm64/Kconfig
@@ -14,6 +14,7 @@ config ARM64
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_TRACEHOOK
Index: linux-2.6/arch/arm64/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm64/kernel/process.c
+++ linux-2.6/arch/arm64/kernel/process.c
@@ -84,11 +84,15 @@ EXPORT_SYMBOL_GPL(pm_power_off);
 void (*pm_restart)(const char *cmd);
 EXPORT_SYMBOL_GPL(pm_restart);
 
+void arch_cpu_idle_prepare(void)
+{
+	local_fiq_enable();
+}
 
 /*
  * This is our default idle handler.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 	/*
 	 * This should do all the clock switching and wait for interrupt
@@ -98,43 +102,6 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-/*
- * The idle thread.
- * We always respect 'hlt_counter' to prevent low power idle.
- */
-void cpu_idle(void)
-{
-	local_fiq_enable();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			/*
-			 * We need to disable interrupts here to ensure
-			 * we don't miss a wakeup call.
-			 */
-			local_irq_disable();
-			if (!need_resched()) {
-				stop_critical_timings();
-				default_idle();
-				start_critical_timings();
-				/*
-				 * default_idle functions should always return
-				 * with IRQs enabled.
-				 */
-				WARN_ON(irqs_disabled());
-			} else {
-				local_irq_enable();
-			}
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_shutdown(void)
 {
 #ifdef CONFIG_SMP
Index: linux-2.6/arch/arm64/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm64/kernel/smp.c
+++ linux-2.6/arch/arm64/kernel/smp.c
@@ -216,7 +216,7 @@ asmlinkage void __cpuinit secondary_star
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)


