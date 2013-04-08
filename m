Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935978Ab3DHURV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:17:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935933Ab3DHURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:17:20 -0400
Date: Mon, 8 Apr 2013 13:15:15 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-fa35e42a00ec0120db2b5128753206efb288e789@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215233.711253792@linutronix.de>
References: <20130321215233.711253792@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arc: Use generic idle loop
Git-Commit-ID: fa35e42a00ec0120db2b5128753206efb288e789
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:15:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa35e42a00ec0120db2b5128753206efb288e789
Gitweb:     http://git.kernel.org/tip/fa35e42a00ec0120db2b5128753206efb288e789
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:36 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:23 +0200

arc: Use generic idle loop

The generic idle loop implements all functionality. Aside of that it
allows arc to implement the tsk_is_polling() functionality correctly,
despite the patently (now gone) comment in the original arc cpu_idle()
function:
/* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
See kernel/cpu/idle.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Tested-by: Vineet Gupta <vgupta@synopsys.com>
Link: http://lkml.kernel.org/r/20130321215233.711253792@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arc/Kconfig          |  1 +
 arch/arc/kernel/process.c | 27 +--------------------------
 arch/arc/kernel/smp.c     |  2 +-
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index e6f4eca..b006977 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -14,6 +14,7 @@ config ARC
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_IDLE_LOOP
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_KERNEL_EXECVE
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 0a7531d..cad6685 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -41,37 +41,12 @@ SYSCALL_DEFINE0(arc_gettls)
 	return task_thread_info(current)->thr_ptr;
 }
 
-static inline void arch_idle(void)
+void arch_cpu_idle(void)
 {
 	/* sleep, but enable all interrupts before committing */
 	__asm__("sleep 0x3");
 }
 
-void cpu_idle(void)
-{
-	/* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-doze:
-		local_irq_disable();
-		if (!need_resched()) {
-			arch_idle();
-			goto doze;
-		} else {
-			local_irq_enable();
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		schedule_preempt_disabled();
-	}
-}
-
 asmlinkage void ret_from_fork(void);
 
 /* Layout of Child kernel mode stack as setup at the end of this function is
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index 3af3e06..5c7fd60 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -141,7 +141,7 @@ void __cpuinit start_kernel_secondary(void)
 
 	local_irq_enable();
 	preempt_disable();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /*
