Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936044Ab3DHUb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:31:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935818Ab3DHUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:31:25 -0400
Date: Mon, 8 Apr 2013 13:30:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-dfa174dcf841d0665065dedec2bc133227da56ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.535485189@linutronix.de>
References: <20130321215234.535485189@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m68k: Use generic idle loop
Git-Commit-ID: dfa174dcf841d0665065dedec2bc133227da56ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:31:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfa174dcf841d0665065dedec2bc133227da56ef
Gitweb:     http://git.kernel.org/tip/dfa174dcf841d0665065dedec2bc133227da56ef
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:49 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:26 +0200

m68k: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/20130321215234.535485189@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/Kconfig          |  1 +
 arch/m68k/kernel/process.c | 32 ++++----------------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6de8133..41859405 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index d538694..c55ff71 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -51,40 +51,16 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 		return sw->retpc;
 }
 
-/*
- * The idle loop on an m68k..
- */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	if (!need_resched())
 #if defined(MACH_ATARI_ONLY)
-		/* block out HSYNC on the atari (falcon) */
-		__asm__("stop #0x2200" : : : "cc");
+	/* block out HSYNC on the atari (falcon) */
+	__asm__("stop #0x2200" : : : "cc");
 #else
-		__asm__("stop #0x2000" : : : "cc");
+	__asm__("stop #0x2000" : : : "cc");
 #endif
 }
 
-void (*idle)(void) = default_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void machine_restart(char * __unused)
 {
 	if (mach_reset)
