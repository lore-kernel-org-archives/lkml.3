Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab3CUV6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:58:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33145 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab3CUVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:12 -0400
Message-Id: <20130321215234.406851909@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [patch 17/34] ia64: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=ia64-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/Kconfig          |    1 
 arch/ia64/kernel/perfmon.c |   13 ++-----
 arch/ia64/kernel/process.c |   83 +++++++++------------------------------------
 arch/ia64/kernel/smpboot.c |    2 -
 4 files changed, 23 insertions(+), 76 deletions(-)

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -35,6 +35,7 @@ config IA64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_INIT_TASK
 	select ARCH_TASK_STRUCT_ALLOCATOR
 	select ARCH_THREAD_INFO_ALLOCATOR
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6/arch/ia64/kernel/perfmon.c
@@ -1322,8 +1322,6 @@ out:
 }
 EXPORT_SYMBOL(pfm_unregister_buffer_fmt);
 
-extern void update_pal_halt_status(int);
-
 static int
 pfm_reserve_session(struct task_struct *task, int is_syswide, unsigned int cpu)
 {
@@ -1371,9 +1369,9 @@ pfm_reserve_session(struct task_struct *
 		cpu));
 
 	/*
-	 * disable default_idle() to go to PAL_HALT
+	 * Force idle() into poll mode
 	 */
-	update_pal_halt_status(0);
+	cpu_idle_poll_ctrl(true);
 
 	UNLOCK_PFS(flags);
 
@@ -1430,11 +1428,8 @@ pfm_unreserve_session(pfm_context_t *ctx
 		is_syswide,
 		cpu));
 
-	/*
-	 * if possible, enable default_idle() to go into PAL_HALT
-	 */
-	if (pfm_sessions.pfs_task_sessions == 0 && pfm_sessions.pfs_sys_sessions == 0)
-		update_pal_halt_status(1);
+	/* Undo forced polling. Last session reenables pal_halt */
+	cpu_idle_poll_ctrl(false);
 
 	UNLOCK_PFS(flags);
 
Index: linux-2.6/arch/ia64/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/process.c
+++ linux-2.6/arch/ia64/kernel/process.c
@@ -209,41 +209,13 @@ do_notify_resume_user(sigset_t *unused, 
 	local_irq_disable();	/* force interrupt disable */
 }
 
-static int pal_halt        = 1;
-static int can_do_pal_halt = 1;
-
 static int __init nohalt_setup(char * str)
 {
-	pal_halt = can_do_pal_halt = 0;
+	cpu_idle_poll_ctrl(true);
 	return 1;
 }
 __setup("nohalt", nohalt_setup);
 
-void
-update_pal_halt_status(int status)
-{
-	can_do_pal_halt = pal_halt && status;
-}
-
-/*
- * We use this if we don't have any better idle routine..
- */
-void
-default_idle (void)
-{
-	local_irq_enable();
-	while (!need_resched()) {
-		if (can_do_pal_halt) {
-			local_irq_disable();
-			if (!need_resched()) {
-				safe_halt();
-			}
-			local_irq_enable();
-		} else
-			cpu_relax();
-	}
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 /* We don't actually take CPU down, just spin without interrupts. */
 static inline void play_dead(void)
@@ -270,50 +242,29 @@ static inline void play_dead(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-void __attribute__((noreturn))
-cpu_idle (void)
+void arch_cpu_idle_dead(void)
 {
-	void (*mark_idle)(int) = ia64_mark_idle;
-  	int cpu = smp_processor_id();
+	play_dead();
+}
 
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		if (can_do_pal_halt) {
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
-		} else {
-			current_thread_info()->status |= TS_POLLING;
-		}
+void arch_cpu_idle(void)
+{
+	void (*mark_idle)(int) = ia64_mark_idle;
 
-		if (!need_resched()) {
-			void (*idle)(void);
 #ifdef CONFIG_SMP
-			min_xtp();
+	min_xtp();
 #endif
-			rmb();
-			if (mark_idle)
-				(*mark_idle)(1);
-
-			if (!idle)
-				idle = default_idle;
-			(*idle)();
-			if (mark_idle)
-				(*mark_idle)(0);
+	rmb();
+	if (mark_idle)
+		(*mark_idle)(1);
+
+	safe_halt();
+
+	if (mark_idle)
+		(*mark_idle)(0);
 #ifdef CONFIG_SMP
-			normal_xtp();
+	normal_xtp();
 #endif
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-		if (cpu_is_offline(cpu))
-			play_dead();
-	}
 }
 
 void
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -455,7 +455,7 @@ start_secondary (void *unused)
 	preempt_disable();
 	smp_callin();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 


