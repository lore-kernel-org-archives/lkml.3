Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3CUVzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:55:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33249 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3CUVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:20 -0400
Message-Id: <20130321215235.090816526@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 27/34] s390: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=s390-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/process.c |   25 +++++++------------------
 arch/s390/kernel/smp.c     |    3 +--
 2 files changed, 8 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/s390/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/process.c
+++ linux-2.6/arch/s390/kernel/process.c
@@ -62,17 +62,15 @@ unsigned long thread_saved_pc(struct tas
 }
 
 /*
- * The idle loop on a S390...
+ * The idle function on a S390...
  */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	if (cpu_is_offline(smp_processor_id()))
-		cpu_die();
-	local_irq_disable();
-	if (need_resched()) {
+	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_irq_enable();
 		return;
 	}
+
 	local_mcck_disable();
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
@@ -83,19 +81,10 @@ static void default_idle(void)
 	vtime_stop_cpu();
 }
 
-void cpu_idle(void)
+void arch_cpu_idle_exit(void)
 {
-	for (;;) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched() && !test_thread_flag(TIF_MCCK_PENDING))
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (test_thread_flag(TIF_MCCK_PENDING))
-			s390_handle_mcck();
-		schedule_preempt_disabled();
-	}
+	if (test_thread_flag(TIF_MCCK_PENDING))
+		s390_handle_mcck();
 }
 
 extern void __kprobes kernel_thread_starter(void);
Index: linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/smp.c
+++ linux-2.6/arch/s390/kernel/smp.c
@@ -711,8 +711,7 @@ static void __cpuinit smp_start_secondar
 	set_cpu_online(smp_processor_id(), true);
 	inc_irq_stat(CPU_RST);
 	local_irq_enable();
-	/* cpu_idle will call schedule for us */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Upping and downing of CPUs */


