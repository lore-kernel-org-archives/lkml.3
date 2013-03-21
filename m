Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3CUV4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:56:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:33232 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3CUVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:18 -0400
Message-Id: <20130321215234.956305981@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [patch 25/34] parisc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=parisc-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/Kconfig          |    1 +
 arch/parisc/kernel/process.c |   22 ----------------------
 arch/parisc/kernel/smp.c     |    2 +-
 3 files changed, 2 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -18,6 +18,7 @@ config PARISC
 	select GENERIC_PCI_IOMAP
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_STRNCPY_FROM_USER
 	select SYSCTL_ARCH_UNALIGN_ALLOW
 	select HAVE_MOD_ARCH_SPECIFIC
Index: linux-2.6/arch/parisc/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/process.c
+++ linux-2.6/arch/parisc/kernel/process.c
@@ -59,28 +59,6 @@
 #include <asm/unwind.h>
 #include <asm/sections.h>
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
-
 #define COMMAND_GLOBAL  F_EXTEND(0xfffe0030)
 #define CMD_RESET       5       /* reset any module */
 
Index: linux-2.6/arch/parisc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/smp.c
+++ linux-2.6/arch/parisc/kernel/smp.c
@@ -329,7 +329,7 @@ void __init smp_callin(void)
 
 	local_irq_enable();  /* Interrupts have been off until now */
 
-	cpu_idle();      /* Wait for timer to schedule some work */
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* NOTREACHED */
 	panic("smp_callin() AAAAaaaaahhhh....\n");


