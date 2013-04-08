Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab3DHUrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:47:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896Ab3DHUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:47:18 -0400
Date: Mon, 8 Apr 2013 13:45:20 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-0dc8153cfebac68c9523b8852b14f10b31209f08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, cmetcalf@tilera.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, cmetcalf@tilera.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215235.348460344@linutronix.de>
References: <20130321215235.348460344@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] tile: Use generic idle loop
Git-Commit-ID: 0dc8153cfebac68c9523b8852b14f10b31209f08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:45:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dc8153cfebac68c9523b8852b14f10b31209f08
Gitweb:     http://git.kernel.org/tip/0dc8153cfebac68c9523b8852b14f10b31209f08
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:50:01 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:28 +0200

tile: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20130321215235.348460344@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/Kconfig          |  1 +
 arch/tile/kernel/process.c | 65 +++++++---------------------------------------
 arch/tile/kernel/smpboot.c |  2 +-
 3 files changed, 11 insertions(+), 57 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 25877ae..85b2ede 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -22,6 +22,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select GENERIC_IDLE_LOOP
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index caf93ae..80b2a18 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
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
@@ -54,64 +52,19 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads.\n");
-		no_idle_nap = 1;
-	} else if (!strcmp(str, "halt"))
-		no_idle_nap = 0;
-	else
-		return -1;
-
-	return 0;
+		cpu_idle_poll_ctrl(true);
+		return 0;
+	} else if (!strcmp(str, "halt")) {
+		return 0;
+	}
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
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 11c0190..44bab29 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -207,7 +207,7 @@ void __cpuinit online_secondary(void)
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
