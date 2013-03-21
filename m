Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3CUWAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:00:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:33083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3CUVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:06 -0400
Message-Id: <20130321215233.950290809@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [patch 10/34] avr32: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=avr32-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also replace the idle poll enforcement by the generic functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/Kconfig                       |    1 +
 arch/avr32/kernel/process.c              |   13 ++-----------
 arch/avr32/kernel/time.c                 |    8 ++++++--
 arch/avr32/mach-at32ap/include/mach/pm.h |   24 ------------------------
 arch/avr32/mach-at32ap/pm-at32ap700x.S   |    7 -------
 5 files changed, 9 insertions(+), 44 deletions(-)

Index: linux-2.6/arch/avr32/Kconfig
===================================================================
--- linux-2.6.orig/arch/avr32/Kconfig
+++ linux-2.6/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
+	seletc GENERIC_IDLE_LOOP
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_CUSTOM_GPIO_H
Index: linux-2.6/arch/avr32/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/process.c
+++ linux-2.6/arch/avr32/kernel/process.c
@@ -30,18 +30,9 @@ EXPORT_SYMBOL(pm_power_off);
  * This file handles the architecture-dependent parts of process handling..
  */
 
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_idle_sleep();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+	cpu_enter_idle();
 }
 
 void machine_halt(void)
Index: linux-2.6/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/time.c
+++ linux-2.6/arch/avr32/kernel/time.c
@@ -87,13 +87,17 @@ static void comparator_mode(enum clock_e
 		pr_debug("%s: start\n", evdev->name);
 		/* FALLTHROUGH */
 	case CLOCK_EVT_MODE_RESUME:
-		cpu_disable_idle_sleep();
+		/*
+		 * If we're using the COUNT and COMPARE registers we
+		 * need to force idle poll.
+		 */
+		cpu_idle_poll_ctrl(true);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		sysreg_write(COMPARE, 0);
 		pr_debug("%s: stop\n", evdev->name);
-		cpu_enable_idle_sleep();
+		cpu_idle_poll_ctrl(false);
 		break;
 	default:
 		BUG();
Index: linux-2.6/arch/avr32/mach-at32ap/include/mach/pm.h
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/include/mach/pm.h
+++ linux-2.6/arch/avr32/mach-at32ap/include/mach/pm.h
@@ -21,30 +21,6 @@
 extern void cpu_enter_idle(void);
 extern void cpu_enter_standby(unsigned long sdramc_base);
 
-extern bool disable_idle_sleep;
-
-static inline void cpu_disable_idle_sleep(void)
-{
-	disable_idle_sleep = true;
-}
-
-static inline void cpu_enable_idle_sleep(void)
-{
-	disable_idle_sleep = false;
-}
-
-static inline void cpu_idle_sleep(void)
-{
-	/*
-	 * If we're using the COUNT and COMPARE registers for
-	 * timekeeping, we can't use the IDLE state.
-	 */
-	if (disable_idle_sleep)
-		cpu_relax();
-	else
-		cpu_enter_idle();
-}
-
 void intc_set_suspend_handler(unsigned long offset);
 #endif
 
Index: linux-2.6/arch/avr32/mach-at32ap/pm-at32ap700x.S
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ linux-2.6/arch/avr32/mach-at32ap/pm-at32ap700x.S
@@ -18,13 +18,6 @@
 /* Same as 0xfff00000 but fits in a 21 bit signed immediate */
 #define PM_BASE	-0x100000
 
-	.section .bss, "wa", @nobits
-	.global	disable_idle_sleep
-	.type	disable_idle_sleep, @object
-disable_idle_sleep:
-	.int	4
-	.size	disable_idle_sleep, . - disable_idle_sleep
-
 	/* Keep this close to the irq handlers */
 	.section .irq.text, "ax", @progbits
 


