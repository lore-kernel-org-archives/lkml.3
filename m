Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936124Ab3DHUe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:34:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936003Ab3DHUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:34:53 -0400
Date: Mon, 8 Apr 2013 13:34:30 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-cdbedc61c8d0122ad682815936f0d11df1fe5f57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, ralf@linux-mips.org, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, ralf@linux-mips.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.754954871@linutronix.de>
References: <20130321215234.754954871@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mips: Use generic idle loop
Git-Commit-ID: cdbedc61c8d0122ad682815936f0d11df1fe5f57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:34:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdbedc61c8d0122ad682815936f0d11df1fe5f57
Gitweb:     http://git.kernel.org/tip/cdbedc61c8d0122ad682815936f0d11df1fe5f57
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:52 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:26 +0200

mips: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20130321215234.754954871@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/Kconfig          |  1 +
 arch/mips/kernel/process.c | 48 +++++++++++++++-------------------------------
 arch/mips/kernel/smp.c     |  2 +-
 3 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 51244bf..e1a3d02 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -34,6 +34,7 @@ config MIPS
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 3be4405..cfc742d 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -41,44 +41,26 @@
 #include <asm/inst.h>
 #include <asm/stacktrace.h>
 
-/*
- * The idle thread. There's no useful work to be done, so just try to conserve
- * power and have a low exit latency (ie sit in a loop waiting for somebody to
- * say that they'd like to reschedule)
- */
-void __noreturn cpu_idle(void)
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
 {
-	int cpu;
-
-	/* CPU is going idle. */
-	cpu = smp_processor_id();
+	/* What the heck is this check doing ? */
+	if (!cpu_isset(smp_processor_id(), cpu_callin_map))
+		play_dead();
+}
+#endif
 
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched() && cpu_online(cpu)) {
+void arch_cpu_idle(void)
+{
 #ifdef CONFIG_MIPS_MT_SMTC
-			extern void smtc_idle_loop_hook(void);
+	extern void smtc_idle_loop_hook(void);
 
-			smtc_idle_loop_hook();
+	smtc_idle_loop_hook();
 #endif
-
-			if (cpu_wait) {
-				/* Don't trace irqs off for idle */
-				stop_critical_timings();
-				(*cpu_wait)();
-				start_critical_timings();
-			}
-		}
-#ifdef CONFIG_HOTPLUG_CPU
-		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
-			play_dead();
-#endif
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	if (cpu_wait)
+		(*cpu_wait)();
+	else
+		local_irq_enable();
 }
 
 asmlinkage void ret_from_fork(void);
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 66bf4e2..aee04af 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -139,7 +139,7 @@ asmlinkage __cpuinit void start_secondary(void)
 	WARN_ON_ONCE(!irqs_disabled());
 	mp_ops->smp_finish();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /*
