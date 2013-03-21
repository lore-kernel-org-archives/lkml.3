Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab3CUVzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:55:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:33250 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab3CUVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:20 -0400
Message-Id: <20130321215235.026838003@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 26/34] powerpc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=powerpc-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig       |    1 
 arch/powerpc/kernel/idle.c |   78 ++++++++++++---------------------------------
 arch/powerpc/kernel/smp.c  |    2 -
 3 files changed, 24 insertions(+), 57 deletions(-)

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -133,6 +133,7 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
Index: linux-2.6/arch/powerpc/kernel/idle.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/idle.c
+++ linux-2.6/arch/powerpc/kernel/idle.c
@@ -50,64 +50,30 @@ static int __init powersave_off(char *ar
 }
 __setup("powersave=off", powersave_off);
 
-/*
- * The body of the idle task.
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched() && !cpu_should_die()) {
-			ppc64_runlatch_off();
-
-			if (ppc_md.power_save) {
-				clear_thread_flag(TIF_POLLING_NRFLAG);
-				/*
-				 * smp_mb is so clearing of TIF_POLLING_NRFLAG
-				 * is ordered w.r.t. need_resched() test.
-				 */
-				smp_mb();
-				local_irq_disable();
-
-				/* Don't trace irqs off for idle */
-				stop_critical_timings();
-
-				/* check again after disabling irqs */
-				if (!need_resched() && !cpu_should_die())
-					ppc_md.power_save();
-
-				start_critical_timings();
-
-				/* Some power_save functions return with
-				 * interrupts enabled, some don't.
-				 */
-				if (irqs_disabled())
-					local_irq_enable();
-				set_thread_flag(TIF_POLLING_NRFLAG);
-
-			} else {
-				/*
-				 * Go into low thread priority and possibly
-				 * low power mode.
-				 */
-				HMT_low();
-				HMT_very_low();
-			}
-		}
-
-		HMT_medium();
-		ppc64_runlatch_on();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (cpu_should_die()) {
-			sched_preempt_enable_no_resched();
-			cpu_die();
-		}
-		schedule_preempt_disabled();
+	ppc64_runlatch_off();
+
+	if (ppc_md.power_save) {
+		ppc_md.power_save();
+		/*
+		 * Some power_save functions return with
+		 * interrupts enabled, some don't.
+		 */
+		if (irqs_disabled())
+			local_irq_enable();
+	} else {
+		local_irq_enable();
+		/*
+		 * Go into low thread priority and possibly
+		 * low power mode.
+		 */
+		HMT_low();
+		HMT_very_low();
 	}
+
+	HMT_medium();
+	ppc64_runlatch_on();
 }
 
 int powersave_nap;
Index: linux-2.6/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6/arch/powerpc/kernel/smp.c
@@ -669,7 +669,7 @@ __cpuinit void start_secondary(void *unu
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	BUG();
 }


