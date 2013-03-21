Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab3CUWCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:02:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:33059 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3CUVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:03 -0400
Message-Id: <20130321215233.766017538@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [patch 07/34] alpha: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=alpha-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core provides a generic idle poll loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig          |    1 +
 arch/alpha/kernel/process.c |   19 -------------------
 arch/alpha/kernel/smp.c     |    3 +--
 3 files changed, 2 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/alpha/Kconfig
===================================================================
--- linux-2.6.orig/arch/alpha/Kconfig
+++ linux-2.6/arch/alpha/Kconfig
@@ -17,6 +17,7 @@ config ALPHA
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
Index: linux-2.6/arch/alpha/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/process.c
+++ linux-2.6/arch/alpha/kernel/process.c
@@ -46,25 +46,6 @@
 void (*pm_power_off)(void) = machine_power_off;
 EXPORT_SYMBOL(pm_power_off);
 
-void
-cpu_idle(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		/* FIXME -- EV6 and LCA45 know how to power down
-		   the CPU.  */
-
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_relax();
-
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
-
 struct halt_info {
 	int mode;
 	char *restart_cmd;
Index: linux-2.6/arch/alpha/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/smp.c
+++ linux-2.6/arch/alpha/kernel/smp.c
@@ -167,8 +167,7 @@ smp_callin(void)
 	      cpuid, current, current->active_mm));
 
 	preempt_disable();
-	/* Do nothing.  */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */


