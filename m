Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077Ab3DHU3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3DHU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:28:59 -0400
Date: Mon, 8 Apr 2013 13:28:30 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-91d591c387af34db00c39da2d1d25e69a91cf591@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, tony.luck@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        tony.luck@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.406851909@linutronix.de>
References: <20130321215234.406851909@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] ia64: Use generic idle loop
Git-Commit-ID: 91d591c387af34db00c39da2d1d25e69a91cf591
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:28:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91d591c387af34db00c39da2d1d25e69a91cf591
Gitweb:     http://git.kernel.org/tip/91d591c387af34db00c39da2d1d25e69a91cf591
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:47 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:25 +0200

ia64: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20130321215234.406851909@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/Kconfig          |  1 +
 arch/ia64/kernel/perfmon.c | 14 +++------
 arch/ia64/kernel/process.c | 78 ++++++++++------------------------------------
 arch/ia64/kernel/smpboot.c |  2 +-
 4 files changed, 23 insertions(+), 72 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9a02f71..e0b39c3 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -35,6 +35,7 @@ config IA64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_INIT_TASK
 	select ARCH_TASK_STRUCT_ALLOCATOR
 	select ARCH_THREAD_INFO_ALLOCATOR
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 2eda284..9ea25fc 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -42,6 +42,7 @@
 #include <linux/completion.h>
 #include <linux/tracehook.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 #include <asm/errno.h>
 #include <asm/intrinsics.h>
@@ -1322,8 +1323,6 @@ out:
 }
 EXPORT_SYMBOL(pfm_unregister_buffer_fmt);
 
-extern void update_pal_halt_status(int);
-
 static int
 pfm_reserve_session(struct task_struct *task, int is_syswide, unsigned int cpu)
 {
@@ -1371,9 +1370,9 @@ pfm_reserve_session(struct task_struct *task, int is_syswide, unsigned int cpu)
 		cpu));
 
 	/*
-	 * disable default_idle() to go to PAL_HALT
+	 * Force idle() into poll mode
 	 */
-	update_pal_halt_status(0);
+	cpu_idle_poll_ctrl(true);
 
 	UNLOCK_PFS(flags);
 
@@ -1430,11 +1429,8 @@ pfm_unreserve_session(pfm_context_t *ctx, int is_syswide, unsigned int cpu)
 		is_syswide,
 		cpu));
 
-	/*
-	 * if possible, enable default_idle() to go into PAL_HALT
-	 */
-	if (pfm_sessions.pfs_task_sessions == 0 && pfm_sessions.pfs_sys_sessions == 0)
-		update_pal_halt_status(1);
+	/* Undo forced polling. Last session reenables pal_halt */
+	cpu_idle_poll_ctrl(false);
 
 	UNLOCK_PFS(flags);
 
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 6f7dc8b..a26fc64 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -209,41 +209,13 @@ do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long in_syscall)
 	local_irq_disable();	/* force interrupt disable */
 }
 
-static int pal_halt        = 1;
-static int can_do_pal_halt = 1;
-
 static int __init nohalt_setup(char * str)
 {
-	pal_halt = can_do_pal_halt = 0;
+	cpu_idle_poll_ctrl(true);
 	return 1;
 }
 __setup("nohalt", nohalt_setup);
 
-void
-update_pal_halt_status(int status)
-{
-	can_do_pal_halt = pal_halt && status;
-}
-
-/*
- * We use this if we don't have any better idle routine..
- */
-void
-default_idle (void)
-{
-	local_irq_enable();
-	while (!need_resched()) {
-		if (can_do_pal_halt) {
-			local_irq_disable();
-			if (!need_resched()) {
-				safe_halt();
-			}
-			local_irq_enable();
-		} else
-			cpu_relax();
-	}
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 /* We don't actually take CPU down, just spin without interrupts. */
 static inline void play_dead(void)
@@ -270,47 +242,29 @@ static inline void play_dead(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-void __attribute__((noreturn))
-cpu_idle (void)
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
+
+void arch_cpu_idle(void)
 {
 	void (*mark_idle)(int) = ia64_mark_idle;
-  	int cpu = smp_processor_id();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		if (can_do_pal_halt) {
-			current_thread_info()->status &= ~TS_POLLING;
-			/*
-			 * TS_POLLING-cleared state must be visible before we
-			 * test NEED_RESCHED:
-			 */
-			smp_mb();
-		} else {
-			current_thread_info()->status |= TS_POLLING;
-		}
 
-		if (!need_resched()) {
 #ifdef CONFIG_SMP
-			min_xtp();
+	min_xtp();
 #endif
-			rmb();
-			if (mark_idle)
-				(*mark_idle)(1);
+	rmb();
+	if (mark_idle)
+		(*mark_idle)(1);
+
+	safe_halt();
 
-			default_idle();
-			if (mark_idle)
-				(*mark_idle)(0);
+	if (mark_idle)
+		(*mark_idle)(0);
 #ifdef CONFIG_SMP
-			normal_xtp();
+	normal_xtp();
 #endif
-		}
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-		if (cpu_is_offline(cpu))
-			play_dead();
-	}
 }
 
 void
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 500f1e4..8d87168 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -455,7 +455,7 @@ start_secondary (void *unused)
 	preempt_disable();
 	smp_callin();
 
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 	return 0;
 }
 
