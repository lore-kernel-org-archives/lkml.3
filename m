Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3CUV6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:58:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:33161 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3CUVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:13 -0400
Message-Id: <20130321215234.470547189@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 18/34] m32r: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=m32r-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the private poller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/Kconfig          |    1 +
 arch/m32r/kernel/process.c |   18 ------------------
 arch/m32r/kernel/smpboot.c |    2 +-
 3 files changed, 2 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/m32r/Kconfig
===================================================================
--- linux-2.6.orig/arch/m32r/Kconfig
+++ linux-2.6/arch/m32r/Kconfig
@@ -13,6 +13,7 @@ config M32R
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
Index: linux-2.6/arch/m32r/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/process.c
+++ linux-2.6/arch/m32r/kernel/process.c
@@ -47,24 +47,6 @@ unsigned long thread_saved_pc(struct tas
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
Index: linux-2.6/arch/m32r/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6/arch/m32r/kernel/smpboot.c
@@ -432,7 +432,7 @@ int __init start_secondary(void *unused)
 	 */
 	local_flush_tlb_all();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 


