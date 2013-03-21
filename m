Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3CUVxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:33308 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3CUVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:25 -0400
Message-Id: <20130321215235.415426466@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 32/34] unicore: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=unicore-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig          |    1 +
 arch/unicore32/kernel/process.c |   21 +++------------------
 2 files changed, 4 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/unicore32/Kconfig
===================================================================
--- linux-2.6.orig/arch/unicore32/Kconfig
+++ linux-2.6/arch/unicore32/Kconfig
@@ -17,6 +17,7 @@ config UNICORE32
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
 	select MODULES_USE_ELF_REL
+	select GENERIC_IDLE_LOOP
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
Index: linux-2.6/arch/unicore32/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/unicore32/kernel/process.c
+++ linux-2.6/arch/unicore32/kernel/process.c
@@ -45,25 +45,10 @@ static const char * const processor_mode
 	"UK18", "UK19", "UK1A", "EXTN", "UK1C", "UK1D", "UK1E", "SUSR"
 };
 
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-			local_irq_disable();
-			stop_critical_timings();
-			cpu_do_idle();
-			local_irq_enable();
-			start_critical_timings();
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+	cpu_do_idle();
+	local_irq_enable();
 }
 
 static char reboot_mode = 'h';


