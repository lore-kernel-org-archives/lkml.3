Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3CUVyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:54:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:33269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CUVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:22 -0400
Message-Id: <20130321215235.216323644@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 29/34] sh: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=sh-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig       |    2 
 arch/sh/kernel/idle.c |  102 ++++----------------------------------------------
 arch/sh/kernel/smp.c  |    2 
 3 files changed, 12 insertions(+), 94 deletions(-)

Index: linux-2.6/arch/sh/Kconfig
===================================================================
--- linux-2.6.orig/arch/sh/Kconfig
+++ linux-2.6/arch/sh/Kconfig
@@ -33,6 +33,8 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
Index: linux-2.6/arch/sh/kernel/idle.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/idle.c
+++ linux-2.6/arch/sh/kernel/idle.c
@@ -24,98 +24,19 @@
 
 static void (*sh_idle)(void);
 
-static int hlt_counter;
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-__setup("nohlt", nohlt_setup);
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-__setup("hlt", hlt_setup);
-
-static inline int hlt_works(void)
-{
-	return !hlt_counter;
-}
-
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-}
-
 void default_idle(void)
 {
-	if (hlt_works()) {
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb__after_clear_bit();
-
-		set_bl_bit();
-		if (!need_resched()) {
-			local_irq_enable();
-			cpu_sleep();
-		} else
-			local_irq_enable();
-
-		set_thread_flag(TIF_POLLING_NRFLAG);
-		clear_bl_bit();
-	} else
-		poll_idle();
+	set_bl_bit();
+	local_irq_enable();
+	/* Isn't this racy ? */
+	cpu_sleep();
+	clear_bl_bit();
 }
 
-/*
- * The idle thread. There's no useful work to be done, so just try to conserve
- * power and have a low exit latency (ie sit in a loop waiting for somebody to
- * say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	unsigned int cpu = smp_processor_id();
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(cpu))
-				play_dead();
-
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (cpuidle_idle_call())
-				sh_idle();
-			/*
-			 * Sanity check to ensure that sh_idle() returns
-			 * with IRQs enabled
-			 */
-			WARN_ON(irqs_disabled());
-			start_critical_timings();
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	if (cpuidle_idle_call())
+		sh_idle();
 }
 
 void __init select_idle_routine(void)
@@ -123,13 +44,8 @@ void __init select_idle_routine(void)
 	/*
 	 * If a platform has set its own idle routine, leave it alone.
 	 */
-	if (sh_idle)
-		return;
-
-	if (hlt_works())
+	if (!sh_idle)
 		sh_idle = default_idle;
-	else
-		sh_idle = poll_idle;
 }
 
 void stop_this_cpu(void *unused)
Index: linux-2.6/arch/sh/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/smp.c
+++ linux-2.6/arch/sh/kernel/smp.c
@@ -203,7 +203,7 @@ asmlinkage void __cpuinit start_secondar
 	set_cpu_online(cpu, true);
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 extern struct {


