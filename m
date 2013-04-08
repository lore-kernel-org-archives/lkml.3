Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141Ab3DHUlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:41:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935919Ab3DHUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:40:59 -0400
Date: Mon, 8 Apr 2013 13:40:32 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-52c0065947b7f78a3d9808b421006a3d870d1f92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215235.090816526@linutronix.de>
References: <20130321215235.090816526@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] s390: Use generic idle loop
Git-Commit-ID: 52c0065947b7f78a3d9808b421006a3d870d1f92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52c0065947b7f78a3d9808b421006a3d870d1f92
Gitweb:     http://git.kernel.org/tip/52c0065947b7f78a3d9808b421006a3d870d1f92
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:27 +0200

s390: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Link: http://lkml.kernel.org/r/20130321215235.090816526@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/Kconfig          |  1 +
 arch/s390/kernel/process.c | 32 +++++++++-----------------------
 arch/s390/kernel/smp.c     |  3 +--
 arch/s390/kernel/vtime.c   |  5 -----
 4 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index eb8fb62..749513d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -97,6 +97,7 @@ config S390
 	select CLONE_BACKWARDS2
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CPU_DEVICES if !SMP
+	select GENERIC_IDLE_LOOP
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL_OLD
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 536d645..2bc3edd 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -61,18 +61,8 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return sf->gprs[8];
 }
 
-/*
- * The idle loop on a S390...
- */
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	if (cpu_is_offline(smp_processor_id()))
-		cpu_die();
-	local_irq_disable();
-	if (need_resched()) {
-		local_irq_enable();
-		return;
-	}
 	local_mcck_disable();
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
@@ -83,19 +73,15 @@ static void default_idle(void)
 	vtime_stop_cpu();
 }
 
-void cpu_idle(void)
+void arch_cpu_idle_exit(void)
 {
-	for (;;) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched() && !test_thread_flag(TIF_MCCK_PENDING))
-			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		if (test_thread_flag(TIF_MCCK_PENDING))
-			s390_handle_mcck();
-		schedule_preempt_disabled();
-	}
+	if (test_thread_flag(TIF_MCCK_PENDING))
+		s390_handle_mcck();
+}
+
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
 }
 
 extern void __kprobes kernel_thread_starter(void);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 549c9d1..6ff5845 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -711,8 +711,7 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 	set_cpu_online(smp_processor_id(), true);
 	inc_irq_stat(CPU_RST);
 	local_irq_enable();
-	/* cpu_idle will call schedule for us */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Upping and downing of CPUs */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index a0042ac..3fb0935 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -158,8 +158,6 @@ void __kprobes vtime_stop_cpu(void)
 	unsigned long psw_mask;
 
 	trace_hardirqs_on();
-	/* Don't trace preempt off for idle. */
-	stop_critical_timings();
 
 	/* Wait for external, I/O or machine check interrupt. */
 	psw_mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_DAT |
@@ -169,9 +167,6 @@ void __kprobes vtime_stop_cpu(void)
 	/* Call the assembler magic in entry.S */
 	psw_idle(idle, psw_mask);
 
-	/* Reenable preemption tracer. */
-	start_critical_timings();
-
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	idle->sequence++;
 	smp_wmb();
