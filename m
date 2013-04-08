Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936115Ab3DHUdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:33:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935818Ab3DHUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:33:44 -0400
Date: Mon, 8 Apr 2013 13:32:06 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d1dba0fcd3e62f32d5925bcb91eba8757951464c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        james.hogan@imgtec.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        james.hogan@imgtec.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215234.606480852@linutronix.de>
References: <20130321215234.606480852@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] metag: Use generic idle loop
Git-Commit-ID: d1dba0fcd3e62f32d5925bcb91eba8757951464c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:32:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1dba0fcd3e62f32d5925bcb91eba8757951464c
Gitweb:     http://git.kernel.org/tip/d1dba0fcd3e62f32d5925bcb91eba8757951464c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:50 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:26 +0200

metag: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>
Link: http://lkml.kernel.org/r/20130321215234.606480852@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/metag/Kconfig          |  1 +
 arch/metag/kernel/process.c | 35 ++++++-----------------------------
 arch/metag/kernel/smp.c     |  2 +-
 3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index afc8973..3164f6c 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -7,6 +7,7 @@ config METAG
 	select EMBEDDED
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_64BIT_ALIGNED_ACCESS
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
index c6efe62..dc59235 100644
--- a/arch/metag/kernel/process.c
+++ b/arch/metag/kernel/process.c
@@ -22,6 +22,7 @@
 #include <linux/pm.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/smp.h>
 #include <asm/core_reg.h>
 #include <asm/user_gateway.h>
 #include <asm/tcm.h>
@@ -31,7 +32,7 @@
 /*
  * Wait for the next interrupt and enable local interrupts
  */
-static inline void arch_idle(void)
+void arch_cpu_idle(void)
 {
 	int tmp;
 
@@ -59,36 +60,12 @@ static inline void arch_idle(void)
 		      : "r" (get_trigger_mask()));
 }
 
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched()) {
-			/*
-			 * We need to disable interrupts here to ensure we don't
-			 * miss a wakeup call.
-			 */
-			local_irq_disable();
-			if (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
-				if (cpu_is_offline(smp_processor_id()))
-					cpu_die();
-#endif
-				arch_idle();
-			} else {
-				local_irq_enable();
-			}
-		}
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	 }
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
 }
+#endif
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 4b6d1f14..4de8fc8 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -297,7 +297,7 @@ asmlinkage void secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
