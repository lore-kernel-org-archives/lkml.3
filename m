Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936099Ab3DHUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:36:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936030Ab3DHUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:36:16 -0400
Date: Mon, 8 Apr 2013 13:35:43 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-af695cd931edab7f202fb616d69d4b746c5d6912@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.822656036@linutronix.de>
References: <20130321215234.822656036@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mn10300: Use generic idle loop
Git-Commit-ID: af695cd931edab7f202fb616d69d4b746c5d6912
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:35:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af695cd931edab7f202fb616d69d4b746c5d6912
Gitweb:     http://git.kernel.org/tip/af695cd931edab7f202fb616d69d4b746c5d6912
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:53 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:27 +0200

mn10300: Use generic idle loop

default_idle() boils down to safe_halt() and the other option is idle
polling. Use the core functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20130321215234.822656036@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/Kconfig          |  1 +
 arch/mn10300/kernel/process.c | 70 ++++---------------------------------------
 arch/mn10300/kernel/smp.c     |  2 +-
 3 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 428da17..ae7158b6 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -13,6 +13,7 @@ config MN10300
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select GENERIC_IDLE_LOOP
 
 config AM33_2
 	def_bool n
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 84f4e97..2da39fb 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -50,77 +50,19 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
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
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index eaef5ad..a17f9c9 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -675,7 +675,7 @@ int __init start_secondary(void *unused)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	init_clockevents();
 #endif
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
