Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab3CUVyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:54:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:33329 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3CUVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:27 -0400
Message-Id: <20130321215235.486594473@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, x86@kernel.org
Subject: [patch 33/34] x86: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=x86-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/Kconfig          |    1 
 arch/x86/kernel/process.c |  106 ++++++++++++----------------------------------
 arch/x86/kernel/smpboot.c |    2 
 arch/x86/xen/smp.c        |    2 
 4 files changed, 32 insertions(+), 79 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 	select HAVE_ARCH_SECCOMP_FILTER
 	select BUILDTIME_EXTABLE_SORT
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -29,6 +29,8 @@
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
 
+#define POLL_IDLE	(void*) 0x01
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
@@ -301,13 +303,7 @@ void exit_idle(void)
 }
 #endif
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle_prepare(void)
 {
 	/*
 	 * If we're the non-boot CPU, nothing set the stack canary up
@@ -317,71 +313,40 @@ void cpu_idle(void)
 	 * canaries already on the stack wont ever trigger).
 	 */
 	boot_init_stack_canary();
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		tick_nohz_idle_enter();
-
-		while (!need_resched()) {
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-
-			/*
-			 * Idle routines should keep interrupts disabled
-			 * from here on, until they go to idle.
-			 * Otherwise, idle callbacks can misfire.
-			 */
-			local_touch_nmi();
-			local_irq_disable();
-
-			enter_idle();
-
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
+}
 
-			if (cpuidle_idle_call())
-				x86_idle();
+void arch_cpu_idle_enter(void)
+{
+	local_touch_nmi();
+	enter_idle();
+}
 
-			rcu_idle_exit();
-			start_critical_timings();
+void arch_cpu_idle_exit(void)
+{
+	__exit_idle();
+}
 
-			/* In many cases the interrupt that ended idle
-			   has already called exit_idle. But some idle
-			   loops can be woken up without interrupt. */
-			__exit_idle();
-		}
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
 
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+/*
+ * Called from the generic idle code.
+ */
+void arch_cpu_idle(void)
+{
+	if (cpuidle_idle_call())
+		x86_idle();
 }
 
 /*
- * We use this if we don't have any better
- * idle routine..
+ * We use this if we don't have any better idle routine..
  */
 void default_idle(void)
 {
 	trace_cpu_idle_rcuidle(1, smp_processor_id());
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-
-	if (!need_resched())
-		safe_halt();	/* enables interrupts racelessly */
-	else
-		local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
+	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
@@ -411,20 +376,6 @@ void stop_this_cpu(void *dummy)
 		halt();
 }
 
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-}
-
 bool amd_e400_c1e_detected;
 EXPORT_SYMBOL(amd_e400_c1e_detected);
 
@@ -489,7 +440,7 @@ static void amd_e400_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	if (x86_idle == poll_idle && smp_num_siblings > 1)
+	if (x86_idle == POLL_IDLE && smp_num_siblings > 1)
 		pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
 #endif
 	if (x86_idle)
@@ -517,8 +468,9 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads\n");
-		x86_idle = poll_idle;
+		x86_idle = POLL_IDLE;
 		boot_option_idle_override = IDLE_POLL;
+		cpu_idle_poll_ctrl(true);
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -284,7 +284,7 @@ notrace static void __cpuinit start_seco
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_store_boot_cpu_info(void)
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -95,7 +95,7 @@ static void __cpuinit cpu_bringup(void)
 static void __cpuinit cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 static int xen_smp_intr_init(unsigned int cpu)


