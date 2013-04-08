Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935929Ab3DHUIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:08:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935850Ab3DHUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:08:40 -0400
Date: Mon, 8 Apr 2013 13:08:08 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-6546327ad187238ac63d2429701b32becb096fd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.377959540@linutronix.de>
References: <20130321215233.377959540@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arch: Cleanup enable/disable_hlt
Git-Commit-ID: 6546327ad187238ac63d2429701b32becb096fd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:08:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6546327ad187238ac63d2429701b32becb096fd8
Gitweb:     http://git.kernel.org/tip/6546327ad187238ac63d2429701b32becb096fd8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:31 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:22 +0200

arch: Cleanup enable/disable_hlt

enable/disable_hlt() does not need to be exported and can be killed on
architectures which do not use it at all.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.377959540@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/process.c               |  4 ----
 arch/cris/arch-v32/kernel/process.c     |  8 +++-----
 arch/cris/include/asm/processor.h       |  7 -------
 arch/cris/kernel/process.c              | 25 -------------------------
 arch/microblaze/include/asm/processor.h |  2 --
 arch/microblaze/kernel/process.c        | 12 ------------
 arch/mn10300/kernel/smp.c               |  5 -----
 7 files changed, 3 insertions(+), 60 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..92884c8 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
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
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 2b23ef0..4857933 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
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
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 675823f..c0a29b9 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -65,13 +65,6 @@ static inline void release_thread(struct task_struct *dead_task)
 
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
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 104ff4d..508c9cd 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
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
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 0759153..f576fe0 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -160,8 +160,6 @@ unsigned long get_wchan(struct task_struct *p);
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
-void disable_hlt(void);
-void enable_hlt(void);
 void default_idle(void);
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index fa0ea60..7c36171 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
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
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 5d7e152..eaef5ad 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -935,8 +935,6 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
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
