Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab3DHUnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:43:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935865Ab3DHUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:43:29 -0400
Date: Mon, 8 Apr 2013 13:42:56 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-dc775dd886618a1ea6f092bfb3ddc78660aa1a19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        lethal@linux-sh.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215235.216323644@linutronix.de>
References: <20130321215235.216323644@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sh: Use generic idle loop
Git-Commit-ID: dc775dd886618a1ea6f092bfb3ddc78660aa1a19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:43:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc775dd886618a1ea6f092bfb3ddc78660aa1a19
Gitweb:     http://git.kernel.org/tip/dc775dd886618a1ea6f092bfb3ddc78660aa1a19
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:59 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:28 +0200

sh: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20130321215235.216323644@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sh/Kconfig       |   2 +
 arch/sh/kernel/idle.c | 101 ++++++--------------------------------------------
 arch/sh/kernel/smp.c  |   2 +-
 3 files changed, 14 insertions(+), 91 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5e85963..853cbc9 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -33,6 +33,8 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 3d5a1b3..2ea4483 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -24,98 +24,24 @@
 
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
+void default_idle(void)
 {
+	set_bl_bit();
 	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
+	/* Isn't this racy ? */
+	cpu_sleep();
+	clear_bl_bit();
 }
 
-void default_idle(void)
+void arch_cpu_idle_dead(void)
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
+	play_dead();
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
@@ -123,13 +49,8 @@ void __init select_idle_routine(void)
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
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 2062aa8..4569645 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -203,7 +203,7 @@ asmlinkage void __cpuinit start_secondary(void)
 	set_cpu_online(cpu, true);
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 extern struct {
