Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3CUWC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:02:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:33042 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3CUVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:01 -0400
Message-Id: <20130321215233.646635455@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 05/34] idle: Implement generic idle function
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline;
 filename=smpboot-implement-common-idle-functionality.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All idle functions in arch/* are more or less the same, plus minus a
few bugs and extra instrumentation, tickless support and other
optional items.

Implement a generic idle function which resembles the functionality
found in arch/. Provide weak arch_cpu_idle_* functions which can be
overridden by the architecture code if needed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig        |    3 +
 include/linux/cpu.h |    8 +++
 kernel/cpu/idle.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -216,6 +216,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config GENERIC_IDLE_LOOP
+       bool
+
 # Select if arch init_task initializer is different to init/init_task.c
 config ARCH_INIT_TASK
        bool
Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
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
Index: linux-2.6/kernel/cpu/idle.c
===================================================================
--- linux-2.6.orig/kernel/cpu/idle.c
+++ linux-2.6/kernel/cpu/idle.c
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
+	cpu_idle_poll();
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
+					WARN_ON_ONCE(!irqs_disabled());
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


