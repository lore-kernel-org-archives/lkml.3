Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936128Ab3DHUjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:39:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935902Ab3DHUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:39:47 -0400
Date: Mon, 8 Apr 2013 13:39:20 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-799fef06123f86ff69cf754f996219e6ad1678f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215235.026838003@linutronix.de>
References: <20130321215235.026838003@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] powerpc: Use generic idle loop
Git-Commit-ID: 799fef06123f86ff69cf754f996219e6ad1678f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:39:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  799fef06123f86ff69cf754f996219e6ad1678f8
Gitweb:     http://git.kernel.org/tip/799fef06123f86ff69cf754f996219e6ad1678f8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:56 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:27 +0200

powerpc: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20130321215235.026838003@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/Kconfig       |  1 +
 arch/powerpc/kernel/idle.c | 89 +++++++++++++++-------------------------------
 arch/powerpc/kernel/smp.c  |  2 +-
 3 files changed, 31 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ea5bb04..19de32c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,6 +133,7 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index ea78761..939ea7e 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -33,11 +33,6 @@
 #include <asm/runlatch.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_HOTPLUG_CPU
-#define cpu_should_die()	cpu_is_offline(smp_processor_id())
-#else
-#define cpu_should_die()	0
-#endif
 
 unsigned long cpuidle_disable = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(cpuidle_disable);
@@ -50,64 +45,38 @@ static int __init powersave_off(char *arg)
 }
 __setup("powersave=off", powersave_off);
 
-/*
- * The body of the idle task.
- */
-void cpu_idle(void)
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
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
+	sched_preempt_enable_no_resched();
+	cpu_die();
+}
+#endif
 
-		HMT_medium();
-		ppc64_runlatch_on();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (cpu_should_die()) {
-			sched_preempt_enable_no_resched();
-			cpu_die();
-		}
-		schedule_preempt_disabled();
+void arch_cpu_idle(void)
+{
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
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 76bd9da..ee7ac5e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -669,7 +669,7 @@ __cpuinit void start_secondary(void *unused)
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	BUG();
 }
