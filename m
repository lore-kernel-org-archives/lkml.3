Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3DMTyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:54:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3DMTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:54:10 -0400
Date: Sat, 13 Apr 2013 12:53:44 -0700
From: tip-bot for Sam Ravnborg <tipbot@zytor.com>
Message-ID: <tip-87fa05aeb3a5e8e21b1a5510eef6983650eff092@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        davem@davemloft.net
In-Reply-To: <20130411193850.GA2330@merkur.ravnborg.org>
References: <20130411193850.GA2330@merkur.ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sparc: Use generic idle loop
Git-Commit-ID: 87fa05aeb3a5e8e21b1a5510eef6983650eff092
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 13 Apr 2013 12:53:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87fa05aeb3a5e8e21b1a5510eef6983650eff092
Gitweb:     http://git.kernel.org/tip/87fa05aeb3a5e8e21b1a5510eef6983650eff092
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Thu, 11 Apr 2013 21:38:50 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Apr 2013 21:36:27 +0200

sparc: Use generic idle loop

Add generic cpu_idle support

sparc32:
- replace call to cpu_idle() with cpu_startup_entry()
- add arch_cpu_idle()

sparc64:
- smp_callin() now include cpu_startup_entry() call so we can
  skip calling cpu_idle from assembler
- add arch_cpu_idle() and arch_cpu_idle_dead()

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org
Cc: rusty@rustcorp.com.au
Cc: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org
Cc: magnus.damm@gmail.com
Acked-by: David Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20130411193850.GA2330@merkur.ravnborg.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/Kconfig                |  1 +
 arch/sparc/kernel/hvtramp.S       |  3 +--
 arch/sparc/kernel/process_32.c    | 21 ++++-------------
 arch/sparc/kernel/process_64.c    | 49 +++++++++++----------------------------
 arch/sparc/kernel/smp_32.c        |  2 +-
 arch/sparc/kernel/smp_64.c        |  2 ++
 arch/sparc/kernel/trampoline_64.S |  3 +--
 7 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..ee5eacc 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -37,6 +37,7 @@ config SPARC
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select MODULES_USE_ELF_RELA
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 9365432..605c960 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -128,8 +128,7 @@ hv_cpu_startup:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 62eede1..c852410 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -64,23 +64,12 @@ extern void fpsave(unsigned long *, unsigned long *, void *, unsigned long *);
 struct task_struct *last_task_used_math = NULL;
 struct thread_info *current_set[NR_CPUS];
 
-/*
- * the idle loop on a Sparc... ;)
- */
-void cpu_idle(void)
+/* Idle loop support. */
+void arch_cpu_idle(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	for (;;) {
-		while (!need_resched()) {
-			if (sparc_idle)
-				(*sparc_idle)();
-			else
-				cpu_relax();
-		}
-		schedule_preempt_disabled();
-	}
+	if (sparc_idle)
+		(*sparc_idle)();
+	local_irq_enable();
 }
 
 /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..9fbf0d1 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -52,20 +52,17 @@
 
 #include "kstack.h"
 
-static void sparc64_yield(int cpu)
+/* Idle loop support on sparc64. */
+void arch_cpu_idle(void)
 {
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
-		return;
-	}
-
-	clear_thread_flag(TIF_POLLING_NRFLAG);
-	smp_mb__after_clear_bit();
-
-	while (!need_resched() && !cpu_is_offline(cpu)) {
+	} else {
 		unsigned long pstate;
 
-		/* Disable interrupts. */
+                /* The sun4v sleeping code requires that we have PSTATE.IE cleared over
+                 * the cpu sleep hypervisor call.
+                 */
 		__asm__ __volatile__(
 			"rdpr %%pstate, %0\n\t"
 			"andn %0, %1, %0\n\t"
@@ -73,7 +70,7 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 
-		if (!need_resched() && !cpu_is_offline(cpu))
+		if (!need_resched() && !cpu_is_offline(smp_processor_id()))
 			sun4v_cpu_yield();
 
 		/* Re-enable interrupts. */
@@ -84,36 +81,16 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 	}
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
+	local_irq_enable();
 }
 
-/* The idle loop on sparc64. */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while(1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched() && !cpu_is_offline(cpu))
-			sparc64_yield(cpu);
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
 #ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(cpu)) {
-			sched_preempt_enable_no_resched();
-			cpu_play_dead();
-		}
-#endif
-		schedule_preempt_disabled();
-	}
+void arch_cpu_idle_dead()
+{
+	sched_preempt_enable_no_resched();
+	cpu_play_dead();
 }
+#endif
 
 #ifdef CONFIG_COMPAT
 static void show_regwindow32(struct pt_regs *regs)
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 9e7e6d7..e3f2b81 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -369,7 +369,7 @@ void __cpuinit sparc_start_secondary(void *arg)
 	local_irq_enable();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* We should never reach here! */
 	BUG();
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 537eb66..c025ffc 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -127,6 +127,8 @@ void __cpuinit smp_callin(void)
 
 	/* idle thread is expected to have preempt disabled */
 	preempt_disable();
+
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void cpu_panic(void)
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..2e973a2 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -407,8 +407,7 @@ after_lock_tlb:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 1:	b,a,pt		%xcc, 1b
