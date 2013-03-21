Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3CUWAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:00:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:33101 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3CUVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:07 -0400
Message-Id: <20130321215234.087033904@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Mark Salter <msalter@redhat.com>
Subject: [patch 12/34] c6x: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=c6x-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Salter <msalter@redhat.com>
---
 arch/c6x/Kconfig          |    1 +
 arch/c6x/kernel/process.c |   28 +---------------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/c6x/Kconfig
===================================================================
--- linux-2.6.orig/arch/c6x/Kconfig
+++ linux-2.6/arch/c6x/Kconfig
@@ -18,6 +18,7 @@ config C6X
 	select OF_EARLY_FLATTREE
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select GENERIC_IDLE_LOOP
 
 config MMU
 	def_bool n
Index: linux-2.6/arch/c6x/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/c6x/kernel/process.c
+++ linux-2.6/arch/c6x/kernel/process.c
@@ -33,7 +33,7 @@ extern asmlinkage void ret_from_kernel_t
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-static void c6x_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long tmp;
 
@@ -49,32 +49,6 @@ static void c6x_idle(void)
 		      : "=b"(tmp));
 }
 
-/*
- * The idle loop for C64x
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (1) {
-			local_irq_disable();
-			if (need_resched()) {
-				local_irq_enable();
-				break;
-			}
-			c6x_idle(); /* enables local irqs */
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
 static void halt_loop(void)
 {
 	printk(KERN_EMERG "System Halted, OK to turn off power\n");


