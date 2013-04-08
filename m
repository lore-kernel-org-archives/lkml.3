Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867Ab3DHUYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:24:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762769Ab3DHUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:24:38 -0400
Date: Mon, 8 Apr 2013 13:23:41 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8dc7c5ecd8d0f739728d844ee794c4fae169f9c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215234.148829489@linutronix.de>
References: <20130321215234.148829489@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] cris: Use generic idle loop
Git-Commit-ID: 8dc7c5ecd8d0f739728d844ee794c4fae169f9c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:23:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dc7c5ecd8d0f739728d844ee794c4fae169f9c2
Gitweb:     http://git.kernel.org/tip/8dc7c5ecd8d0f739728d844ee794c4fae169f9c2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:25 +0200

cris: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Link: http://lkml.kernel.org/r/20130321215234.148829489@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/cris/Kconfig                   |  1 +
 arch/cris/arch-v10/kernel/process.c |  3 ++-
 arch/cris/arch-v32/kernel/process.c | 10 +++-------
 arch/cris/arch-v32/kernel/smp.c     |  4 +---
 arch/cris/kernel/process.c          | 24 ++----------------------
 5 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 06dd026..1dd3635 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -48,6 +48,7 @@ config CRIS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS2
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index b101875..2ba23c1 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -30,8 +30,9 @@ void etrax_gpio_wake_up_check(void); /* drivers/gpio.c */
 void default_idle(void)
 {
 #ifdef CONFIG_ETRAX_GPIO
-  etrax_gpio_wake_up_check();
+	etrax_gpio_wake_up_check();
 #endif
+	local_irq_enable();
 }
 
 /*
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 4857933..57451fa 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -23,13 +23,9 @@ extern void stop_watchdog(void);
 /* We use this if we don't have any better idle routine. */
 void default_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched()) {
-		/* Halt until exception. */
-		__asm__ volatile("ei    \n\t"
-				 "halt      ");
-	}
-	local_irq_enable();
+	/* Halt until exception. */
+	__asm__ volatile("ei    \n\t"
+			 "halt      ");
 }
 
 /*
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 04a16ed..cdd1202 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -145,8 +145,6 @@ smp_boot_one_cpu(int cpuid, struct task_struct idle)
  * specific stuff such as the local timer and the MMU. */
 void __init smp_callin(void)
 {
-	extern void cpu_idle(void);
-
 	int cpu = cpu_now_booting;
 	reg_intr_vect_rw_mask vect_mask = {0};
 
@@ -170,7 +168,7 @@ void __init smp_callin(void)
 	local_irq_enable();
 
 	set_cpu_online(cpu, true);
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Stop execution on this CPU.*/
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 508c9cd..b78498e 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -34,29 +34,9 @@ extern void default_idle(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-
-void cpu_idle (void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			/*
-			 * Mark this as an RCU critical section so that
-			 * synchronize_kernel() in the unload path waits
-			 * for our completion.
-			 */
-			default_idle();
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	default_idle();
 }
 
 void hard_reset_now (void);
