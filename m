Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3CUVxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:33190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3CUVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:15 -0400
Message-Id: <20130321215234.687590459@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 21/34] microblaze: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=microblaze-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microblaze idle loop provides a polling and a non polling version,
which are suprisingly both polling, just with slightly different
instrumentation. Remove them and use the generic poller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig                 |    2 +
 arch/microblaze/include/asm/processor.h |    3 -
 arch/microblaze/kernel/process.c        |   53 --------------------------------
 3 files changed, 2 insertions(+), 56 deletions(-)

Index: linux-2.6/arch/microblaze/Kconfig
===================================================================
--- linux-2.6.orig/arch/microblaze/Kconfig
+++ linux-2.6/arch/microblaze/Kconfig
@@ -26,6 +26,8 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 
Index: linux-2.6/arch/microblaze/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/processor.h
+++ linux-2.6/arch/microblaze/include/asm/processor.h
@@ -22,7 +22,6 @@
 extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
-# define cpu_sleep()		do {} while (0)
 
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
@@ -160,8 +159,6 @@ unsigned long get_wchan(struct task_stru
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
-void default_idle(void);
-
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *of_debugfs_root;
 #endif
Index: linux-2.6/arch/microblaze/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/process.c
+++ linux-2.6/arch/microblaze/kernel/process.c
@@ -44,59 +44,6 @@ void show_regs(struct pt_regs *regs)
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-static int hlt_counter = 1;
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
-void default_idle(void)
-{
-	if (likely(hlt_counter)) {
-		local_irq_disable();
-		stop_critical_timings();
-		cpu_relax();
-		start_critical_timings();
-		local_irq_enable();
-	} else {
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb__after_clear_bit();
-		local_irq_disable();
-		while (!need_resched())
-			cpu_sleep();
-		local_irq_enable();
-		set_thread_flag(TIF_POLLING_NRFLAG);
-	}
-}
-
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
 void flush_thread(void)
 {
 }


