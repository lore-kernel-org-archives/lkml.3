Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab3CUVxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:33181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab3CUVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:14 -0400
Message-Id: <20130321215234.606480852@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [patch 20/34] metag: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=metag-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/Kconfig          |    1 +
 arch/metag/kernel/process.c |   32 +++-----------------------------
 arch/metag/kernel/smp.c     |    2 +-
 3 files changed, 5 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/metag/Kconfig
===================================================================
--- linux-2.6.orig/arch/metag/Kconfig
+++ linux-2.6/arch/metag/Kconfig
@@ -9,6 +9,7 @@ config METAG
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select HAVE_64BIT_ALIGNED_ACCESS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_C_RECORDMCOUNT
Index: linux-2.6/arch/metag/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/metag/kernel/process.c
+++ linux-2.6/arch/metag/kernel/process.c
@@ -31,7 +31,7 @@
 /*
  * Wait for the next interrupt and enable local interrupts
  */
-static inline void arch_idle(void)
+void arch_cpu_idle(void)
 {
 	int tmp;
 
@@ -59,35 +59,9 @@ static inline void arch_idle(void)
 		      : "r" (get_trigger_mask()));
 }
 
-void cpu_idle(void)
+void arch_cpu_idle_dead(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			/*
-			 * We need to disable interrupts here to ensure we don't
-			 * miss a wakeup call.
-			 */
-			local_irq_disable();
-			if (!need_resched()) {
-#ifdef CONFIG_HOTPLUG_CPU
-				if (cpu_is_offline(smp_processor_id()))
-					cpu_die();
-#endif
-				arch_idle();
-			} else {
-				local_irq_enable();
-			}
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	 }
+	cpu_die();
 }
 
 void (*pm_power_off)(void);
Index: linux-2.6/arch/metag/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/metag/kernel/smp.c
+++ linux-2.6/arch/metag/kernel/smp.c
@@ -297,7 +297,7 @@ asmlinkage void secondary_start_kernel(v
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)


