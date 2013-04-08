Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029Ab3DHUT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:19:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935951Ab3DHUT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:19:26 -0400
Date: Mon, 8 Apr 2013 13:18:53 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-0087298f68a726493a637c4f68d148b31102b0d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        catalin.marinas@arm.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.887563095@linutronix.de>
References: <20130321215233.887563095@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arm64: Use generic idle loop
Git-Commit-ID: 0087298f68a726493a637c4f68d148b31102b0d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0087298f68a726493a637c4f68d148b31102b0d9
Gitweb:     http://git.kernel.org/tip/0087298f68a726493a637c4f68d148b31102b0d9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:24 +0200

arm64: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: http://lkml.kernel.org/r/20130321215233.887563095@linutronix.de
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/process.c | 43 +++++--------------------------------------
 arch/arm64/kernel/smp.c     |  2 +-
 3 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b6d19f..ca2c871 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -9,6 +9,7 @@ config ARM64
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0337cdb..83a0ad5 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
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
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index bdd3459..261445c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -216,7 +216,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
