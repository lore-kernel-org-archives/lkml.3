Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3CUV5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:57:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:33207 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3CUVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:16 -0400
Message-Id: <20130321215234.822656036@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [patch 23/34] mn10300: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=mn10300-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_idle() boils down to safe_halt() and the other option is idle
polling. Use the core functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/Kconfig          |    1 
 arch/mn10300/kernel/process.c |   70 +++---------------------------------------
 arch/mn10300/kernel/smp.c     |    2 -
 3 files changed, 8 insertions(+), 65 deletions(-)

Index: linux-2.6/arch/mn10300/Kconfig
===================================================================
--- linux-2.6.orig/arch/mn10300/Kconfig
+++ linux-2.6/arch/mn10300/Kconfig
@@ -13,6 +13,7 @@ config MN10300
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select GENERIC_IDLE_LOOP
 
 config AM33_2
 	def_bool n
Index: linux-2.6/arch/mn10300/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/process.c
+++ linux-2.6/arch/mn10300/kernel/process.c
@@ -50,77 +50,19 @@ unsigned long thread_saved_pc(struct tas
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-#if !defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
-/*
- * we use this if we don't have any better idle routine
- */
-static void default_idle(void)
-{
-	local_irq_disable();
-	if (!need_resched())
-		safe_halt();
-	else
-		local_irq_enable();
-}
-
-#else /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU  */
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
  * cross-CPU IPI to arrive. Use this option with caution.
+ *
+ * tglx: No idea why this depends on HOTPLUG_CPU !?!
  */
-static inline void poll_idle(void)
-{
-	int oldval;
-
-	local_irq_enable();
-
-	/*
-	 * Deal with another CPU just having chosen a thread to
-	 * run here:
-	 */
-	oldval = test_and_clear_thread_flag(TIF_NEED_RESCHED);
-
-	if (!oldval) {
-		set_thread_flag(TIF_POLLING_NRFLAG);
-		while (!need_resched())
-			cpu_relax();
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-	} else {
-		set_need_resched();
-	}
-}
-#endif /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU */
-
-/*
- * the idle thread
- * - there's no useful work to be done, so just try to conserve power and have
- *   a low exit latency (ie sit in a loop waiting for somebody to say that
- *   they'd like to reschedule)
- */
-void cpu_idle(void)
+#if !defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	for (;;) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			void (*idle)(void);
-
-			smp_rmb();
-			if (!idle) {
-#if defined(CONFIG_SMP) && !defined(CONFIG_HOTPLUG_CPU)
-				idle = poll_idle;
-#else  /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
-				idle = default_idle;
-#endif /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
-			}
-			idle();
-		}
-		rcu_idle_exit();
-
-		schedule_preempt_disabled();
-	}
+	safe_halt();
 }
+#endif
 
 void release_segments(struct mm_struct *mm)
 {
Index: linux-2.6/arch/mn10300/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/smp.c
+++ linux-2.6/arch/mn10300/kernel/smp.c
@@ -675,7 +675,7 @@ int __init start_secondary(void *unused)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	init_clockevents();
 #endif
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 


