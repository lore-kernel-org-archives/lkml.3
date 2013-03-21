Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab3CUV6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:58:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33169 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab3CUVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:13 -0400
Message-Id: <20130321215234.535485189@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 19/34] m68k: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=m68k-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig          |    1 +
 arch/m68k/kernel/process.c |   32 ++++----------------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/m68k/Kconfig
===================================================================
--- linux-2.6.orig/arch/m68k/Kconfig
+++ linux-2.6/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
Index: linux-2.6/arch/m68k/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/process.c
+++ linux-2.6/arch/m68k/kernel/process.c
@@ -51,40 +51,16 @@ unsigned long thread_saved_pc(struct tas
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


