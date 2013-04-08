Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936000Ab3DHUWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:22:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762769Ab3DHUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:22:10 -0400
Date: Mon, 8 Apr 2013 13:21:17 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-25d67f860f3a29d216f8206092a284cacbc6127e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vapier@gentoo.org, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vapier@gentoo.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.014923303@linutronix.de>
References: <20130321215234.014923303@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] bfin: Use generic idle loop
Git-Commit-ID: 25d67f860f3a29d216f8206092a284cacbc6127e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:21:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25d67f860f3a29d216f8206092a284cacbc6127e
Gitweb:     http://git.kernel.org/tip/25d67f860f3a29d216f8206092a284cacbc6127e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:24 +0200

bfin: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/20130321215234.014923303@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/Kconfig           |  1 +
 arch/blackfin/kernel/process.c  | 32 ++++++--------------------------
 arch/blackfin/mach-common/smp.c |  2 +-
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c3f2e0b..3d769a7 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -41,6 +41,7 @@ config BLACKFIN
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9782c03..f34323a 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -46,15 +46,14 @@ EXPORT_SYMBOL(pm_power_off);
  * The idle loop on BFIN
  */
 #ifdef CONFIG_IDLE_L1
-static void default_idle(void)__attribute__((l1_text));
-void cpu_idle(void)__attribute__((l1_text));
+void arch_cpu_idle(void)__attribute__((l1_text));
 #endif
 
 /*
  * This is our default idle handler.  We need to disable
  * interrupts here to ensure we don't miss a wakeup call.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 #ifdef CONFIG_IPIPE
 	ipipe_suspend_domain();
@@ -66,31 +65,12 @@ static void default_idle(void)
 	hard_local_irq_enable();
 }
 
-/*
- * The idle thread.  We try to conserve power, while trying to keep
- * overall latency low.  The architecture specific idle is passed
- * a value to indicate the level of "idleness" of the system.
- */
-void cpu_idle(void)
+#ufdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-
-#ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(smp_processor_id()))
-			cpu_die();
-#endif
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+	cpu_die();
 }
+#endif
 
 /*
  * Do necessary setup to start up a newly executed thread.
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index bb61ae4..1bc2ce6 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -335,7 +335,7 @@ void __cpuinit secondary_start_kernel(void)
 	 */
 	calibrate_delay();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_prepare_boot_cpu(void)
