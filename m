Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3CUVxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:33030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3CUVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:00 -0400
Message-Id: <20130321215233.377959540@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:52:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 01/34] arch: Cleanup enable/disable_hlt
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=arch-cleanup-disable-hlt.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable/disable_hlt() does not need to be exported and can be killed on
architectures which do not use it at all.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/process.c               |    4 ----
 arch/cris/arch-v32/kernel/process.c     |    8 +++-----
 arch/cris/include/asm/processor.h       |    7 -------
 arch/cris/kernel/process.c              |   25 -------------------------
 arch/microblaze/include/asm/processor.h |    2 --
 arch/microblaze/kernel/process.c        |   12 ------------
 arch/mn10300/kernel/smp.c               |    5 -----
 7 files changed, 3 insertions(+), 60 deletions(-)

Index: linux-2.6/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/process.c
+++ linux-2.6/arch/arm/kernel/process.c
@@ -64,16 +64,12 @@ void disable_hlt(void)
 	hlt_counter++;
 }
 
-EXPORT_SYMBOL(disable_hlt);
-
 void enable_hlt(void)
 {
 	hlt_counter--;
 	BUG_ON(hlt_counter < 0);
 }
 
-EXPORT_SYMBOL(enable_hlt);
-
 static int __init nohlt_setup(char *__unused)
 {
 	hlt_counter = 1;
Index: linux-2.6/arch/cris/arch-v32/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/process.c
+++ linux-2.6/arch/cris/arch-v32/kernel/process.c
@@ -20,16 +20,14 @@
 
 extern void stop_watchdog(void);
 
-extern int cris_hlt_counter;
-
 /* We use this if we don't have any better idle routine. */
 void default_idle(void)
 {
 	local_irq_disable();
-	if (!need_resched() && !cris_hlt_counter) {
-	        /* Halt until exception. */
+	if (!need_resched()) {
+		/* Halt until exception. */
 		__asm__ volatile("ei    \n\t"
-                                 "halt      ");
+				 "halt      ");
 	}
 	local_irq_enable();
 }
Index: linux-2.6/arch/cris/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/processor.h
+++ linux-2.6/arch/cris/include/asm/processor.h
@@ -65,13 +65,6 @@ static inline void release_thread(struct
 
 #define cpu_relax()     barrier()
 
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-void disable_hlt(void);
-void enable_hlt(void);
-
 void default_idle(void);
 
 #endif /* __ASM_CRIS_PROCESSOR_H */
Index: linux-2.6/arch/cris/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/process.c
+++ linux-2.6/arch/cris/kernel/process.c
@@ -29,31 +29,6 @@
 
 //#define DEBUG
 
-/*
- * The hlt_counter, disable_hlt and enable_hlt is just here as a hook if
- * there would ever be a halt sequence (for power save when idle) with
- * some largish delay when halting or resuming *and* a driver that can't
- * afford that delay.  The hlt_counter would then be checked before
- * executing the halt sequence, and the driver marks the unhaltable
- * region by enable_hlt/disable_hlt.
- */
-
-int cris_hlt_counter=0;
-
-void disable_hlt(void)
-{
-	cris_hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	cris_hlt_counter--;
-}
-
-EXPORT_SYMBOL(enable_hlt);
- 
 extern void default_idle(void);
 
 void (*pm_power_off)(void);
Index: linux-2.6/arch/microblaze/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/processor.h
+++ linux-2.6/arch/microblaze/include/asm/processor.h
@@ -160,8 +160,6 @@ unsigned long get_wchan(struct task_stru
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
-void disable_hlt(void);
-void enable_hlt(void);
 void default_idle(void);
 
 #ifdef CONFIG_DEBUG_FS
Index: linux-2.6/arch/microblaze/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/process.c
+++ linux-2.6/arch/microblaze/kernel/process.c
@@ -46,18 +46,6 @@ EXPORT_SYMBOL(pm_power_off);
 
 static int hlt_counter = 1;
 
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
 static int __init nohlt_setup(char *__unused)
 {
 	hlt_counter = 1;
Index: linux-2.6/arch/mn10300/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/smp.c
+++ linux-2.6/arch/mn10300/kernel/smp.c
@@ -935,8 +935,6 @@ int __cpu_up(unsigned int cpu, struct ta
 	int timeout;
 
 #ifdef CONFIG_HOTPLUG_CPU
-	if (num_online_cpus() == 1)
-		disable_hlt();
 	if (sleep_mode[cpu])
 		run_wakeup_cpu(cpu);
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -1003,9 +1001,6 @@ int __cpu_disable(void)
 void __cpu_die(unsigned int cpu)
 {
 	run_sleep_cpu(cpu);
-
-	if (num_online_cpus() == 1)
-		enable_hlt();
 }
 
 #ifdef CONFIG_MN10300_CACHE_ENABLED


