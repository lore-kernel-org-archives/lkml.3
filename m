Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab3CUVyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:54:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:33285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3CUVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:23 -0400
Message-Id: <20130321215235.348460344@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 31/34] tile: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=tile-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c |   61 ++++-----------------------------------------
 arch/tile/kernel/smpboot.c |    2 -
 2 files changed, 7 insertions(+), 56 deletions(-)

Index: linux-2.6/arch/tile/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/process.c
+++ linux-2.6/arch/tile/kernel/process.c
@@ -40,13 +40,11 @@
 #include <arch/abi.h>
 #include <arch/sim_def.h>
 
-
 /*
  * Use the (x86) "idle=poll" option to prefer low latency when leaving the
  * idle loop over low power while in the idle loop, e.g. if we have
  * one thread per core and we want to get threads out of futex waits fast.
  */
-static int no_idle_nap;
 static int __init idle_setup(char *str)
 {
 	if (!str)
@@ -54,64 +52,17 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads.\n");
-		no_idle_nap = 1;
+		cpu_idle_poll_ctrl(true);
 	} else if (!strcmp(str, "halt"))
-		no_idle_nap = 0;
-	else
-		return -1;
-
-	return 0;
+		return 0;
+	return -1;
 }
 early_param("idle", idle_setup);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	int cpu = smp_processor_id();
-
-
-	current_thread_info()->status |= TS_POLLING;
-
-	if (no_idle_nap) {
-		while (1) {
-			while (!need_resched())
-				cpu_relax();
-			schedule();
-		}
-	}
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			if (cpu_is_offline(cpu))
-				BUG();  /* no HOTPLUG_CPU */
-
-			local_irq_disable();
-			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
-
-			if (!need_resched())
-				_cpu_idle();
-			else
-				local_irq_enable();
-			current_thread_info()->status |= TS_POLLING;
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+	_cpu_idle();
 }
 
 /*
Index: linux-2.6/arch/tile/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/smpboot.c
+++ linux-2.6/arch/tile/kernel/smpboot.c
@@ -207,7 +207,7 @@ void __cpuinit online_secondary(void)
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)


