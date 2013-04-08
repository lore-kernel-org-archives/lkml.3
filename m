Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036Ab3DHUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:25:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935708Ab3DHUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:25:54 -0400
Date: Mon, 8 Apr 2013 13:20:05 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-01426478df3a8791ff5c8b6b82d409e699cfaf38@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com,
        egtvedt@samfundet.no
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com,
        egtvedt@samfundet.no
In-Reply-To: <20130321215233.950290809@linutronix.de>
References: <20130321215233.950290809@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] avr32: Use generic idle loop
Git-Commit-ID: 01426478df3a8791ff5c8b6b82d409e699cfaf38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:20:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01426478df3a8791ff5c8b6b82d409e699cfaf38
Gitweb:     http://git.kernel.org/tip/01426478df3a8791ff5c8b6b82d409e699cfaf38
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:24 +0200

avr32: Use generic idle loop

Also replace the idle poll enforcement by the generic functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Link: http://lkml.kernel.org/r/20130321215233.950290809@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/Kconfig                       |  1 +
 arch/avr32/kernel/process.c              | 13 ++-----------
 arch/avr32/kernel/time.c                 |  9 +++++++--
 arch/avr32/mach-at32ap/include/mach/pm.h | 24 ------------------------
 arch/avr32/mach-at32ap/pm-at32ap700x.S   |  7 -------
 5 files changed, 10 insertions(+), 44 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index c1a868d..bbecda4 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
+	select GENERIC_IDLE_LOOP
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_CUSTOM_GPIO_H
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index fd78f58..073c3c2 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
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
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 05ad291..869a1c6 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -12,6 +12,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/time.h>
+#include <linux/cpu.h>
 
 #include <asm/sysreg.h>
 
@@ -87,13 +88,17 @@ static void comparator_mode(enum clock_event_mode mode,
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
diff --git a/arch/avr32/mach-at32ap/include/mach/pm.h b/arch/avr32/mach-at32ap/include/mach/pm.h
index 979b355..f29ff2c 100644
--- a/arch/avr32/mach-at32ap/include/mach/pm.h
+++ b/arch/avr32/mach-at32ap/include/mach/pm.h
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
 
diff --git a/arch/avr32/mach-at32ap/pm-at32ap700x.S b/arch/avr32/mach-at32ap/pm-at32ap700x.S
index f868f4c..1c8e4e6 100644
--- a/arch/avr32/mach-at32ap/pm-at32ap700x.S
+++ b/arch/avr32/mach-at32ap/pm-at32ap700x.S
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
 
