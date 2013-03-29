Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3C2U3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:29:30 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17577 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab3C2U33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:29:29 -0400
Date: Fri, 29 Mar 2013 21:29:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] sparc: Use generic idle loop
Message-ID: <20130329202926.GA9484@merkur.ravnborg.org>
References: <20130321214930.752934102@linutronix.de> <20130329161905.GC6201@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329161905.GC6201@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic cpu_idle support

sparc32:
- replace call to cpu_idle() with cpu_startup_entry()
- add arch_cpu_idle()

sparc64:
- smp_callin() includes cpu_startup_entry() call so we can
  skip calling cpu_idle from assembler
- add arch_cpu_idle_enter() and arch_cpu_idle_dead()

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>

---
This patch is on top of smp/testing in the tip tree.
It is build tested on sparc32 + sparc64

	Sam


diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..5f22169 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -39,6 +39,7 @@ config SPARC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select GENERIC_IDLE_LOOP
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
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
index 62eede1..ec92959 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -64,23 +64,13 @@ extern void fpsave(unsigned long *, unsigned long *, void *, unsigned long *);
 struct task_struct *last_task_used_math = NULL;
 struct thread_info *current_set[NR_CPUS];
 
-/*
- * the idle loop on a Sparc... ;)
- */
-void cpu_idle(void)
+/* the idle loop on a Sparc... ;) */
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
+	else
+		cpu_relax();
 }
 
 /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..5ed6b02 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -52,8 +52,13 @@
 
 #include "kstack.h"
 
-static void sparc64_yield(int cpu)
+/* The idle loop on sparc64. */
+void arch_cpu_idle_enter()
 {
+	int cpu;
+
+	cpu = smp_processor_id();
+
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
 		return;
@@ -88,31 +93,10 @@ static void sparc64_yield(int cpu)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 }
 
-/* The idle loop on sparc64. */
-void cpu_idle(void)
+void arch_cpu_idle_dead()
 {
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
-#ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(cpu)) {
-			sched_preempt_enable_no_resched();
-			cpu_play_dead();
-		}
-#endif
-		schedule_preempt_disabled();
-	}
+	sched_preempt_enable_no_resched();
+	cpu_play_dead();
 }
 
 #ifdef CONFIG_COMPAT
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
