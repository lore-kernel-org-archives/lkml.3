Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab3DHUu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:50:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3DHUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:50:54 -0400
Date: Mon, 8 Apr 2013 13:47:44 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-7d1a941731fabf27e5fb6edbebb79fe856edb4e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215235.486594473@linutronix.de>
References: <20130321215235.486594473@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] x86: Use generic idle loop
Git-Commit-ID: 7d1a941731fabf27e5fb6edbebb79fe856edb4e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:47:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d1a941731fabf27e5fb6edbebb79fe856edb4e5
Gitweb:     http://git.kernel.org/tip/7d1a941731fabf27e5fb6edbebb79fe856edb4e5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:50:03 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:29 +0200

x86: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215235.486594473@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/Kconfig          |   1 +
 arch/x86/kernel/process.c | 105 ++++++++++++----------------------------------
 arch/x86/kernel/smpboot.c |   2 +-
 arch/x86/xen/smp.c        |   2 +-
 4 files changed, 30 insertions(+), 80 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..422a72b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 	select HAVE_ARCH_SECCOMP_FILTER
 	select BUILDTIME_EXTABLE_SORT
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..6833bff 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -301,13 +301,7 @@ void exit_idle(void)
 }
 #endif
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle_prepare(void)
 {
 	/*
 	 * If we're the non-boot CPU, nothing set the stack canary up
@@ -317,71 +311,40 @@ void cpu_idle(void)
 	 * canaries already on the stack wont ever trigger).
 	 */
 	boot_init_stack_canary();
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		tick_nohz_idle_enter();
-
-		while (!need_resched()) {
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-
-			/*
-			 * Idle routines should keep interrupts disabled
-			 * from here on, until they go to idle.
-			 * Otherwise, idle callbacks can misfire.
-			 */
-			local_touch_nmi();
-			local_irq_disable();
-
-			enter_idle();
-
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
+}
 
-			if (cpuidle_idle_call())
-				x86_idle();
+void arch_cpu_idle_enter(void)
+{
+	local_touch_nmi();
+	enter_idle();
+}
 
-			rcu_idle_exit();
-			start_critical_timings();
+void arch_cpu_idle_exit(void)
+{
+	__exit_idle();
+}
 
-			/* In many cases the interrupt that ended idle
-			   has already called exit_idle. But some idle
-			   loops can be woken up without interrupt. */
-			__exit_idle();
-		}
+void arch_cpu_idle_dead(void)
+{
+	play_dead();
+}
 
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
+/*
+ * Called from the generic idle code.
+ */
+void arch_cpu_idle(void)
+{
+	if (cpuidle_idle_call())
+		x86_idle();
 }
 
 /*
- * We use this if we don't have any better
- * idle routine..
+ * We use this if we don't have any better idle routine..
  */
 void default_idle(void)
 {
 	trace_cpu_idle_rcuidle(1, smp_processor_id());
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-
-	if (!need_resched())
-		safe_halt();	/* enables interrupts racelessly */
-	else
-		local_irq_enable();
-	current_thread_info()->status |= TS_POLLING;
+	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
@@ -411,20 +374,6 @@ void stop_this_cpu(void *dummy)
 		halt();
 }
 
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-}
-
 bool amd_e400_c1e_detected;
 EXPORT_SYMBOL(amd_e400_c1e_detected);
 
@@ -489,10 +438,10 @@ static void amd_e400_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	if (x86_idle == poll_idle && smp_num_siblings > 1)
+	if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
 		pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
 #endif
-	if (x86_idle)
+	if (x86_idle || boot_option_idle_override == IDLE_POLL)
 		return;
 
 	if (cpu_has_amd_erratum(amd_erratum_400)) {
@@ -517,8 +466,8 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads\n");
-		x86_idle = poll_idle;
 		boot_option_idle_override = IDLE_POLL;
+		cpu_idle_poll_ctrl(true);
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f190a2..9c73b51 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -284,7 +284,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_store_boot_cpu_info(void)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 09ea61d..73642e9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -95,7 +95,7 @@ static void __cpuinit cpu_bringup(void)
 static void __cpuinit cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 static int xen_smp_intr_init(unsigned int cpu)
