Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaA3QDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:03:36 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42763 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaA3QDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:03:34 -0500
Date: Thu, 30 Jan 2014 11:03:31 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 6/6] cpu/idle.c: move to sched/idle.c
In-Reply-To: <20140130152500.GB5002@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org> <1391017513-12995-7-git-send-email-nicolas.pitre@linaro.org> <20140130152500.GB5002@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Peter Zijlstra wrote:

> On Wed, Jan 29, 2014 at 12:45:13PM -0500, Nicolas Pitre wrote:
> > Integration of cpuidle with the scheduler requires that the idle loop be
> > closely integrated with the scheduler proper. Moving cpu/idle.c into the
> > sched directory will allow for a smoother integration, and eliminate a
> > subdirectory which contained only one source file.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  kernel/Makefile              | 1 -
> >  kernel/cpu/Makefile          | 1 -
> >  kernel/sched/Makefile        | 2 +-
> >  kernel/{cpu => sched}/idle.c | 0
> >  4 files changed, 1 insertion(+), 3 deletions(-)
> >  delete mode 100644 kernel/cpu/Makefile
> >  rename kernel/{cpu => sched}/idle.c (100%)
> 
> > --- a/kernel/sched/Makefile
> > +++ b/kernel/sched/Makefile
> > @@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
> >  CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
> >  endif
> >  
> > -obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
> > +obj-y += core.o proc.o clock.o cputime.o idle_task.o idle.o fair.o rt.o stop_task.o
> >  obj-y += wait.o completion.o
> >  obj-$(CONFIG_SMP) += cpupri.o
> >  obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
> > diff --git a/kernel/cpu/idle.c b/kernel/sched/idle.c
> > similarity index 100%
> > rename from kernel/cpu/idle.c
> > rename to kernel/sched/idle.c
> 
> This is not a valid patch for PATCH(1). Please try again.

Don't you use git?  ;-)

Here's a plain patch:

----- >8

>From 1bf40eb80a44633094e94986a74bd5ffa222f9d4 Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Sun, 26 Jan 2014 23:42:01 -0500
Subject: [PATCH] cpu/idle.c: move to sched/idle.c

Integration of cpuidle with the scheduler requires that the idle loop be
closely integrated with the scheduler proper. Moving cpu/idle.c into the
sched directory will allow for a smoother integration, and eliminate a
subdirectory which contained only one source file.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/Makefile       |   1 -
 kernel/cpu/Makefile   |   1 -
 kernel/cpu/idle.c     | 144 --------------------------------------------------
 kernel/sched/Makefile |   2 +-
 kernel/sched/idle.c   | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 147 deletions(-)
 delete mode 100644 kernel/cpu/Makefile
 delete mode 100644 kernel/cpu/idle.c
 create mode 100644 kernel/sched/idle.c

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee272..6f1c7e5cfc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,7 +22,6 @@ obj-y += sched/
 obj-y += locking/
 obj-y += power/
 obj-y += printk/
-obj-y += cpu/
 obj-y += irq/
 obj-y += rcu/
 
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
deleted file mode 100644
index 59ab052ef7..0000000000
--- a/kernel/cpu/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-y	= idle.o
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
deleted file mode 100644
index 14ca43430a..0000000000
--- a/kernel/cpu/idle.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * Generic entry point for the idle threads
- */
-#include <linux/sched.h>
-#include <linux/cpu.h>
-#include <linux/cpuidle.h>
-#include <linux/tick.h>
-#include <linux/mm.h>
-#include <linux/stackprotector.h>
-
-#include <asm/tlb.h>
-
-#include <trace/events/power.h>
-
-static int __read_mostly cpu_idle_force_poll;
-
-void cpu_idle_poll_ctrl(bool enable)
-{
-	if (enable) {
-		cpu_idle_force_poll++;
-	} else {
-		cpu_idle_force_poll--;
-		WARN_ON_ONCE(cpu_idle_force_poll < 0);
-	}
-}
-
-#ifdef CONFIG_GENERIC_IDLE_POLL_SETUP
-static int __init cpu_idle_poll_setup(char *__unused)
-{
-	cpu_idle_force_poll = 1;
-	return 1;
-}
-__setup("nohlt", cpu_idle_poll_setup);
-
-static int __init cpu_idle_nopoll_setup(char *__unused)
-{
-	cpu_idle_force_poll = 0;
-	return 1;
-}
-__setup("hlt", cpu_idle_nopoll_setup);
-#endif
-
-static inline int cpu_idle_poll(void)
-{
-	rcu_idle_enter();
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!tif_need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	rcu_idle_exit();
-	return 1;
-}
-
-/* Weak implementations for optional arch specific functions */
-void __weak arch_cpu_idle_prepare(void) { }
-void __weak arch_cpu_idle_enter(void) { }
-void __weak arch_cpu_idle_exit(void) { }
-void __weak arch_cpu_idle_dead(void) { }
-void __weak arch_cpu_idle(void)
-{
-	cpu_idle_force_poll = 1;
-	local_irq_enable();
-}
-
-/*
- * Generic idle loop implementation
- */
-static void cpu_idle_loop(void)
-{
-	while (1) {
-		tick_nohz_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				arch_cpu_idle_dead();
-
-			local_irq_disable();
-			arch_cpu_idle_enter();
-
-			/*
-			 * In poll mode we reenable interrupts and spin.
-			 *
-			 * Also if we detected in the wakeup from idle
-			 * path that the tick broadcast device expired
-			 * for us, we don't want to go deep idle as we
-			 * know that the IPI is going to arrive right
-			 * away
-			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
-				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					stop_critical_timings();
-					rcu_idle_enter();
-					if (cpuidle_idle_call())
-						arch_cpu_idle();
-					if (WARN_ON_ONCE(irqs_disabled()))
-						local_irq_enable();
-					rcu_idle_exit();
-					start_critical_timings();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
-			arch_cpu_idle_exit();
-			/*
-			 * We need to test and propagate the TIF_NEED_RESCHED
-			 * bit here because we might not have send the
-			 * reschedule IPI to idle tasks.
-			 */
-			if (tif_need_resched())
-				set_preempt_need_resched();
-		}
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
-void cpu_startup_entry(enum cpuhp_state state)
-{
-	/*
-	 * This #ifdef needs to die, but it's too late in the cycle to
-	 * make this generic (arm and sh have never invoked the canary
-	 * init for the non boot cpus!). Will be fixed in 3.11
-	 */
-#ifdef CONFIG_X86
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us. The boot CPU already has it initialized but no harm
-	 * in doing it again. This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-#endif
-	__current_set_polling();
-	arch_cpu_idle_prepare();
-	cpu_idle_loop();
-}
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 7b621409cf..ac3e0ea68f 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o proc.o clock.o cputime.o idle_task.o idle.o fair.o rt.o stop_task.o
 obj-y += wait.o completion.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
new file mode 100644
index 0000000000..14ca43430a
--- /dev/null
+++ b/kernel/sched/idle.c
@@ -0,0 +1,144 @@
+/*
+ * Generic entry point for the idle threads
+ */
+#include <linux/sched.h>
+#include <linux/cpu.h>
+#include <linux/cpuidle.h>
+#include <linux/tick.h>
+#include <linux/mm.h>
+#include <linux/stackprotector.h>
+
+#include <asm/tlb.h>
+
+#include <trace/events/power.h>
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
+	rcu_idle_enter();
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
+	local_irq_enable();
+	while (!tif_need_resched())
+		cpu_relax();
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	rcu_idle_exit();
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
+	local_irq_enable();
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
+			/*
+			 * In poll mode we reenable interrupts and spin.
+			 *
+			 * Also if we detected in the wakeup from idle
+			 * path that the tick broadcast device expired
+			 * for us, we don't want to go deep idle as we
+			 * know that the IPI is going to arrive right
+			 * away
+			 */
+			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
+				cpu_idle_poll();
+			} else {
+				if (!current_clr_polling_and_test()) {
+					stop_critical_timings();
+					rcu_idle_enter();
+					if (cpuidle_idle_call())
+						arch_cpu_idle();
+					if (WARN_ON_ONCE(irqs_disabled()))
+						local_irq_enable();
+					rcu_idle_exit();
+					start_critical_timings();
+				} else {
+					local_irq_enable();
+				}
+				__current_set_polling();
+			}
+			arch_cpu_idle_exit();
+			/*
+			 * We need to test and propagate the TIF_NEED_RESCHED
+			 * bit here because we might not have send the
+			 * reschedule IPI to idle tasks.
+			 */
+			if (tif_need_resched())
+				set_preempt_need_resched();
+		}
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
+	}
+}
+
+void cpu_startup_entry(enum cpuhp_state state)
+{
+	/*
+	 * This #ifdef needs to die, but it's too late in the cycle to
+	 * make this generic (arm and sh have never invoked the canary
+	 * init for the non boot cpus!). Will be fixed in 3.11
+	 */
+#ifdef CONFIG_X86
+	/*
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us. The boot CPU already has it initialized but no harm
+	 * in doing it again. This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
+	 */
+	boot_init_stack_canary();
+#endif
+	__current_set_polling();
+	arch_cpu_idle_prepare();
+	cpu_idle_loop();
+}
-- 
1.8.4.108.g55ea5f6

