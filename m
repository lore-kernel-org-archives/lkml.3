Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935954Ab3DHUO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935890Ab3DHUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:14:24 -0400
Date: Mon, 8 Apr 2013 13:14:03 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d166991234347215dc23fc9dc15a63a83a1a54e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.646635455@linutronix.de>
References: <20130321215233.646635455@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] idle: Implement generic idle function
Git-Commit-ID: d166991234347215dc23fc9dc15a63a83a1a54e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:14:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d166991234347215dc23fc9dc15a63a83a1a54e1
Gitweb:     http://git.kernel.org/tip/d166991234347215dc23fc9dc15a63a83a1a54e1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:23 +0200

idle: Implement generic idle function

All idle functions in arch/* are more or less the same, plus minus a
few bugs and extra instrumentation, tickless support and other
optional items.

Implement a generic idle function which resembles the functionality
found in arch/. Provide weak arch_cpu_idle_* functions which can be
overridden by the architecture code if needed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.646635455@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig        |   3 ++
 include/linux/cpu.h |   8 ++++
 kernel/cpu/idle.c   | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1455579..a699f37 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -216,6 +216,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config GENERIC_IDLE_LOOP
+       bool
+
 # Select if arch init_task initializer is different to init/init_task.c
 config ARCH_INIT_TASK
        bool
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 7419e30..c6f6e08 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -220,4 +220,12 @@ enum cpuhp_state {
 void cpu_startup_entry(enum cpuhp_state state);
 void cpu_idle(void);
 
+void cpu_idle_poll_ctrl(bool enable);
+
+void arch_cpu_idle(void);
+void arch_cpu_idle_prepare(void);
+void arch_cpu_idle_enter(void);
+void arch_cpu_idle_exit(void);
+void arch_cpu_idle_dead(void);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 1908f00..54c3203 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -3,8 +3,113 @@
  */
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/tick.h>
+#include <linux/mm.h>
 
+#include <asm/tlb.h>
+
+#include <trace/events/power.h>
+
+#ifndef CONFIG_GENERIC_IDLE_LOOP
 void cpu_startup_entry(enum cpuhp_state state)
 {
 	cpu_idle();
 }
+#else
+
+static int __read_mostly cpu_idle_force_poll;
+
+void cpu_idle_poll_ctrl(bool enable)
+{
+	if (enable) {
+		cpu_idle_force_poll++;
+	} else {
+		cpu_idle_force_poll--;
+		WARN_ON_ONCE(cpu_idle_force_poll < 0);
+	}
+}
+
+#ifdef CONFIG_GENERIC_IDLE_POLL_SETUP
+static int __init cpu_idle_poll_setup(char *__unused)
+{
+	cpu_idle_force_poll = 1;
+	return 1;
+}
+__setup("nohlt", cpu_idle_poll_setup);
+
+static int __init cpu_idle_nopoll_setup(char *__unused)
+{
+	cpu_idle_force_poll = 0;
+	return 1;
+}
+__setup("hlt", cpu_idle_nopoll_setup);
+#endif
+
+static inline int cpu_idle_poll(void)
+{
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	return 1;
+}
+
+/* Weak implementations for optional arch specific functions */
+void __weak arch_cpu_idle_prepare(void) { }
+void __weak arch_cpu_idle_enter(void) { }
+void __weak arch_cpu_idle_exit(void) { }
+void __weak arch_cpu_idle_dead(void) { }
+void __weak arch_cpu_idle(void)
+{
+	cpu_idle_force_poll = 1;
+}
+
+/*
+ * Generic idle loop implementation
+ */
+static void cpu_idle_loop(void)
+{
+	while (1) {
+		tick_nohz_idle_enter();
+
+		while (!need_resched()) {
+			check_pgt_cache();
+			rmb();
+
+			if (cpu_is_offline(smp_processor_id()))
+				arch_cpu_idle_dead();
+
+			local_irq_disable();
+			arch_cpu_idle_enter();
+
+			if (cpu_idle_force_poll) {
+				cpu_idle_poll();
+			} else {
+				current_clr_polling();
+				if (!need_resched()) {
+					stop_critical_timings();
+					rcu_idle_enter();
+					arch_cpu_idle();
+					WARN_ON_ONCE(irqs_disabled());
+					rcu_idle_exit();
+					start_critical_timings();
+				} else {
+					local_irq_enable();
+				}
+				current_set_polling();
+			}
+			arch_cpu_idle_exit();
+		}
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
+	}
+}
+
+void cpu_startup_entry(enum cpuhp_state state)
+{
+	current_set_polling();
+	arch_cpu_idle_prepare();
+	cpu_idle_loop();
+}
+#endif
