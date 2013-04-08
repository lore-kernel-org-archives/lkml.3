Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936048Ab3DHU1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:27:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762703Ab3DHU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:27:43 -0400
Date: Mon, 8 Apr 2013 13:27:18 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-4e0fcc567239ef4b3f80bba778c30b0a4b624eff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com,
        rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com,
        rkuo@codeaurora.org
In-Reply-To: <20130321215234.338692935@linutronix.de>
References: <20130321215234.338692935@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] hexagon: Use generic idle loop
Git-Commit-ID: 4e0fcc567239ef4b3f80bba778c30b0a4b624eff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:27:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e0fcc567239ef4b3f80bba778c30b0a4b624eff
Gitweb:     http://git.kernel.org/tip/4e0fcc567239ef4b3f80bba778c30b0a4b624eff
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:46 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:25 +0200

hexagon: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Link: http://lkml.kernel.org/r/20130321215234.338692935@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/hexagon/Kconfig          |  1 +
 arch/hexagon/kernel/process.c | 23 +++--------------------
 arch/hexagon/kernel/smp.c     |  2 +-
 3 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index e4decc6..6e3710e 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -24,6 +24,7 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select STACKTRACE_SUPPORT
 	select KTIME_SCALAR
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 06ae9ff..9b948c6 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -51,28 +51,11 @@ void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long sp)
  *  If hardware or VM offer wait termination even though interrupts
  *  are disabled.
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
 	__vmwait();
-}
-
-void (*idle_sleep)(void) = default_idle;
-
-void cpu_idle(void)
-{
-	while (1) {
-		tick_nohz_idle_enter();
-		local_irq_disable();
-		while (!need_resched()) {
-			idle_sleep();
-			/*  interrupts wake us up, but aren't serviced  */
-			local_irq_enable();	/* service interrupt   */
-			local_irq_disable();
-		}
-		local_irq_enable();
-		tick_nohz_idle_exit();
-		schedule();
-	}
+	/*  interrupts wake us up, but irqs are still disabled */
+	local_irq_enable();
 }
 
 /*
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 8e095df..0e364ca 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -184,7 +184,7 @@ void __cpuinit start_secondary(void)
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 
