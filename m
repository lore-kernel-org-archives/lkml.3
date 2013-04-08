Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936092Ab3DHUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:33:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935818Ab3DHUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:33:43 -0400
Date: Mon, 8 Apr 2013 13:33:18 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e962bb9e9cf73b8c8893c95903e791dd5ec19fb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, monstr@monstr.eu, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, monstr@monstr.eu, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.687590459@linutronix.de>
References: <20130321215234.687590459@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] microblaze: Use generic idle loop
Git-Commit-ID: e962bb9e9cf73b8c8893c95903e791dd5ec19fb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:33:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e962bb9e9cf73b8c8893c95903e791dd5ec19fb4
Gitweb:     http://git.kernel.org/tip/e962bb9e9cf73b8c8893c95903e791dd5ec19fb4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:51 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:26 +0200

microblaze: Use generic idle loop

The microblaze idle loop provides a polling and a non polling version,
which are suprisingly both polling, just with slightly different
instrumentation. Remove them and use the generic poller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Link: http://lkml.kernel.org/r/20130321215234.687590459@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/Kconfig                 |  2 ++
 arch/microblaze/include/asm/processor.h |  3 --
 arch/microblaze/kernel/process.c        | 53 ---------------------------------
 3 files changed, 2 insertions(+), 56 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 1323fa2..0bb0d51 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -26,6 +26,8 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index f576fe0..d6e0ffe 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -22,7 +22,6 @@
 extern const struct seq_operations cpuinfo_op;
 
 # define cpu_relax()		barrier()
-# define cpu_sleep()		do {} while (0)
 
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
@@ -160,8 +159,6 @@ unsigned long get_wchan(struct task_struct *p);
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
-void default_idle(void);
-
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *of_debugfs_root;
 #endif
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 7c36171..7cce2e9 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -44,59 +44,6 @@ void show_regs(struct pt_regs *regs)
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-static int hlt_counter = 1;
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-__setup("nohlt", nohlt_setup);
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-__setup("hlt", hlt_setup);
-
-void default_idle(void)
-{
-	if (likely(hlt_counter)) {
-		local_irq_disable();
-		stop_critical_timings();
-		cpu_relax();
-		start_critical_timings();
-		local_irq_enable();
-	} else {
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb__after_clear_bit();
-		local_irq_disable();
-		while (!need_resched())
-			cpu_sleep();
-		local_irq_enable();
-		set_thread_flag(TIF_POLLING_NRFLAG);
-	}
-}
-
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched())
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
 void flush_thread(void)
 {
 }
