Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab3DHUab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:30:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936058Ab3DHUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:30:25 -0400
Date: Mon, 8 Apr 2013 13:29:43 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-01436228bfefca77493efa00aa49a8b67167d4c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, takata@linux-m32r.org, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, takata@linux-m32r.org,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.470547189@linutronix.de>
References: <20130321215234.470547189@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m32r: Use generic idle loop
Git-Commit-ID: 01436228bfefca77493efa00aa49a8b67167d4c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:29:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01436228bfefca77493efa00aa49a8b67167d4c5
Gitweb:     http://git.kernel.org/tip/01436228bfefca77493efa00aa49a8b67167d4c5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:26 +0200

m32r: Use generic idle loop

Replace the private poller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Link: http://lkml.kernel.org/r/20130321215234.470547189@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m32r/Kconfig          |  1 +
 arch/m32r/kernel/process.c | 18 ------------------
 arch/m32r/kernel/smpboot.c |  2 +-
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index bcd17b2..af814fe 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -13,6 +13,7 @@ config M32R
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index bde899e..e2d0490 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -47,24 +47,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle (void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_relax();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_restart(char *__unused)
 {
 #if defined(CONFIG_PLAT_MAPPI3)
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 13168a7..0ac558a 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -432,7 +432,7 @@ int __init start_secondary(void *unused)
 	 */
 	local_flush_tlb_all();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
