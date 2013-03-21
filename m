Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CUV7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:59:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:33135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab3CUVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:11 -0400
Message-Id: <20130321215234.277153345@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [patch 15/34] h8300: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=h8300-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the core idle poll function instead of the private one

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/Kconfig          |    1 +
 arch/h8300/kernel/process.c |   35 ++++-------------------------------
 2 files changed, 5 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/h8300/Kconfig
===================================================================
--- linux-2.6.orig/arch/h8300/Kconfig
+++ linux-2.6/arch/h8300/Kconfig
@@ -8,6 +8,7 @@ config H8300
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
Index: linux-2.6/arch/h8300/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/process.c
+++ linux-2.6/arch/h8300/kernel/process.c
@@ -53,40 +53,13 @@ asmlinkage void ret_from_kernel_thread(v
  * The idle loop on an H8/300..
  */
 #if !defined(CONFIG_H8300H_SIM) && !defined(CONFIG_H8S_SIM)
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched()) {
-		local_irq_enable();
-		/* XXX: race here! What if need_resched() gets set now? */
-		__asm__("sleep");
-	} else
-		local_irq_enable();
-}
-#else
-static void default_idle(void)
-{
-	cpu_relax();
+	local_irq_enable();
+	/* XXX: race here! What if need_resched() gets set now? */
+	__asm__("sleep");
 }
 #endif
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
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
 
 void machine_restart(char * __unused)
 {


