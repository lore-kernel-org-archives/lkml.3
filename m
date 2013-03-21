Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab3CUV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:59:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:33136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3CUVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:11 -0400
Message-Id: <20130321215234.338692935@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Richard Kuo <rkuo@codeaurora.org>
Subject: [patch 16/34] hexagon: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=hexagon-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/Kconfig          |    1 +
 arch/hexagon/kernel/process.c |   23 +++--------------------
 arch/hexagon/kernel/smp.c     |    2 +-
 3 files changed, 5 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/hexagon/Kconfig
===================================================================
--- linux-2.6.orig/arch/hexagon/Kconfig
+++ linux-2.6/arch/hexagon/Kconfig
@@ -24,6 +24,7 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select STACKTRACE_SUPPORT
 	select KTIME_SCALAR
 	select GENERIC_CLOCKEVENTS
Index: linux-2.6/arch/hexagon/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/hexagon/kernel/process.c
+++ linux-2.6/arch/hexagon/kernel/process.c
@@ -51,28 +51,11 @@ void start_thread(struct pt_regs *regs, 
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
Index: linux-2.6/arch/hexagon/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/hexagon/kernel/smp.c
+++ linux-2.6/arch/hexagon/kernel/smp.c
@@ -184,7 +184,7 @@ void __cpuinit start_secondary(void)
 
 	local_irq_enable();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 


