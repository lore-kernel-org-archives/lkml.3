Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaCCRet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:34:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:40364 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754289AbaCCRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:34:45 -0500
Date: Mon, 3 Mar 2014 12:34:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.32-rt31
Message-ID: <20140303123440.7fb211a6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.32-rt31 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: 7ae9a11fb0f3913687d9b586979261437aeb6550


Or to build 3.10.32-rt31 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.32.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.32-rt31.patch.xz



You can also build from 3.10.32-rt30 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.32-rt30-rt31.patch.xz



Enjoy,

-- Steve


Changes from v3.10.32-rt30:

---

Nicholas Mc Guire (1):
      net: ip_send_unicast_reply: add missing local serialization

Paul E. McKenney (2):
      rcu: Don't activate RCU core on NO_HZ_FULL CPUs
      rcu: Eliminate softirq processing from rcutree

Sebastian Andrzej Siewior (5):
      Revert "x86: Disable IST stacks for debug/int 3/stack fault for PREEMPT_RT"
      kernel/hrtimer: be non-freezeable in cpu_chill()
      irq_work: allow certain work in hard irq context
      arm/unwind: use a raw_spin_lock
      leds: trigger: disable CPU trigger on -RT

Steven Rostedt (3):
      timer: Raise softirq if there's irq_work
      timer/rt: Always raise the softirq if there's irq_work to be done
      rt: Make cpu_chill() use hrtimer instead of msleep()

Steven Rostedt (Red Hat) (1):
      Linux 3.10.32-rt31

Thomas Gleixner (1):
      timers: do not raise softirq unconditionally

Tiejun Chen (1):
      rcutree/rcu_bh_qs: disable irq while calling rcu_preempt_qs()

----
 arch/arm/kernel/unwind.c             |  14 ++--
 arch/powerpc/kernel/time.c           |   2 +-
 arch/sparc/kernel/pcr.c              |   2 +
 arch/x86/include/asm/page_64_types.h |  21 ++---
 arch/x86/kernel/cpu/common.c         |   2 -
 arch/x86/kernel/dumpstack_64.c       |   4 -
 drivers/leds/trigger/Kconfig         |   2 +-
 include/linux/delay.h                |   2 +-
 include/linux/hrtimer.h              |   3 +-
 include/linux/irq_work.h             |   1 +
 kernel/hrtimer.c                     |  50 ++++++------
 kernel/irq_work.c                    |  22 ++++-
 kernel/rcutree.c                     | 122 +++++++++++++++++++++++----
 kernel/rcutree.h                     |   4 +-
 kernel/rcutree_plugin.h              | 154 ++++++++---------------------------
 kernel/time/tick-sched.c             |   1 +
 kernel/timer.c                       |  37 ++++++++-
 localversion-rt                      |   2 +-
 net/ipv4/ip_output.c                 |   9 +-
 19 files changed, 249 insertions(+), 205 deletions(-)
---------------------------
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..bbafc67 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -87,7 +87,7 @@ extern const struct unwind_idx __start_unwind_idx[];
 static const struct unwind_idx *__origin_unwind_idx;
 extern const struct unwind_idx __stop_unwind_idx[];
 
-static DEFINE_SPINLOCK(unwind_lock);
+static DEFINE_RAW_SPINLOCK(unwind_lock);
 static LIST_HEAD(unwind_tables);
 
 /* Convert a prel31 symbol to an absolute address */
@@ -195,7 +195,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
-		spin_lock_irqsave(&unwind_lock, flags);
+		raw_spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
 			    addr < table->end_addr) {
@@ -207,7 +207,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&unwind_lock, flags);
+		raw_spin_unlock_irqrestore(&unwind_lock, flags);
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
@@ -469,9 +469,9 @@ struct unwind_table *unwind_table_add(unsigned long start, unsigned long size,
 	tab->begin_addr = text_addr;
 	tab->end_addr = text_addr + text_size;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_add_tail(&tab->list, &unwind_tables);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	return tab;
 }
@@ -483,9 +483,9 @@ void unwind_table_del(struct unwind_table *tab)
 	if (!tab)
 		return;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_del(&tab->list);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	kfree(tab);
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 5fc29ad..7cc55b2 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -423,7 +423,7 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifdef CONFIG_IRQ_WORK
+#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
 
 /*
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..dbb51a6 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -43,10 +43,12 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 void arch_irq_work_raise(void)
 {
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
+#endif
 
 const struct pcr_ops *pcr_ops;
 EXPORT_SYMBOL_GPL(pcr_ops);
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 3cedb22..6c896fb 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,21 +14,12 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-# define STACKFAULT_STACK 0
-# define DOUBLEFAULT_STACK 1
-# define NMI_STACK 2
-# define DEBUG_STACK 0
-# define MCE_STACK 3
-# define N_EXCEPTION_STACKS 3  /* hw limit: 7 */
-#else
-# define STACKFAULT_STACK 1
-# define DOUBLEFAULT_STACK 2
-# define NMI_STACK 3
-# define DEBUG_STACK 4
-# define MCE_STACK 5
-# define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-#endif
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d39993b..deeb48d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1109,9 +1109,7 @@ DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
  */
 static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
-#if DEBUG_STACK > 0
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
-#endif
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 52b4bcd..addb207 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -21,14 +21,10 @@
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-#if DEBUG_STACK > 0
 		[ DEBUG_STACK-1			]	= "#DB",
-#endif
 		[ NMI_STACK-1			]	= "NMI",
 		[ DOUBLEFAULT_STACK-1		]	= "#DF",
-#if STACKFAULT_STACK > 0
 		[ STACKFAULT_STACK-1		]	= "#SS",
-#endif
 		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..3d7245d 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -61,7 +61,7 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_CPU
 	bool "LED CPU Trigger"
-	depends on LEDS_TRIGGERS
+	depends on LEDS_TRIGGERS && !PREEMPT_RT_BASE
 	help
 	  This allows LEDs to be controlled by active CPUs. This shows
 	  the active CPUs across an array of LEDs so you can see which
diff --git a/include/linux/delay.h b/include/linux/delay.h
index e23a7c0..37caab3 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -53,7 +53,7 @@ static inline void ssleep(unsigned int seconds)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
-# define cpu_chill()	msleep(1)
+extern void cpu_chill(void);
 #else
 # define cpu_chill()	cpu_relax()
 #endif
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 79a7a35..bdbf77db 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -461,9 +461,8 @@ extern int schedule_hrtimeout_range_clock(ktime_t *expires,
 		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
-/* Soft interrupt function to run the hrtimer queues: */
+/* Called from the periodic timer tick */
 extern void hrtimer_run_queues(void);
-extern void hrtimer_run_pending(void);
 
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..60c19ee 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,6 +16,7 @@
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 #define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+#define IRQ_WORK_HARD_IRQ	8UL /* Run hard IRQ context, even on RT */
 
 struct irq_work {
 	unsigned long flags;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a63cfaf..eb4c8831c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1691,30 +1691,6 @@ static void run_hrtimer_softirq(struct softirq_action *h)
 }
 
 /*
- * Called from timer softirq every jiffy, expire hrtimers:
- *
- * For HRT its the fall back code to run the softirq in the timer
- * softirq context in case the hrtimer initialization failed or has
- * not been done yet.
- */
-void hrtimer_run_pending(void)
-{
-	if (hrtimer_hres_active())
-		return;
-
-	/*
-	 * This _is_ ugly: We have to check in the softirq context,
-	 * whether we can switch to highres and / or nohz mode. The
-	 * clocksource switch happens in the timer interrupt with
-	 * xtime_lock held. Notification from there only sets the
-	 * check bit in the tick_oneshot code, otherwise we might
-	 * deadlock vs. xtime_lock.
-	 */
-	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		hrtimer_switch_to_hres();
-}
-
-/*
  * Called from hardirq context every jiffy
  */
 void hrtimer_run_queues(void)
@@ -1727,6 +1703,13 @@ void hrtimer_run_queues(void)
 	if (hrtimer_hres_active())
 		return;
 
+	/*
+	 * Check whether we can switch to highres mode.
+	 */
+	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled())
+	    && hrtimer_switch_to_hres())
+		return;
+
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
 		base = &cpu_base->clock_base[index];
 		if (!timerqueue_getnext(&base->active))
@@ -1904,6 +1887,25 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * Sleep for 1 ms in hope whoever holds what we want will let it go.
+ */
+void cpu_chill(void)
+{
+	struct timespec tu = {
+		.tv_nsec = NSEC_PER_MSEC,
+	};
+	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
+
+	current->flags |= PF_NOFREEZE;
+	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	if (!freeze_flag)
+		current->flags &= ~PF_NOFREEZE;
+}
+EXPORT_SYMBOL(cpu_chill);
+#endif
+
 /*
  * Functions related to boot-time initialization:
  */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f6e4377..35d21f9 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -20,6 +20,9 @@
 
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+#ifdef CONFIG_PREEMPT_RT_FULL
+static DEFINE_PER_CPU(struct llist_head, hirq_work_list);
+#endif
 static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
@@ -48,7 +51,11 @@ static bool irq_work_claim(struct irq_work *work)
 	return true;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+void arch_irq_work_raise(void)
+#else
 void __weak arch_irq_work_raise(void)
+#endif
 {
 	/*
 	 * Lame architectures will get the timer tick callback
@@ -70,8 +77,12 @@ void irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (work->flags & IRQ_WORK_HARD_IRQ)
+		llist_add(&work->llnode, &__get_cpu_var(hirq_work_list));
+	else
+#endif
+		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
 	 * work interrupt (if supported by the arch), otherwise, just wait
@@ -115,7 +126,12 @@ static void __irq_work_run(void)
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_irq())
+		this_list = &__get_cpu_var(hirq_work_list);
+	else
+#endif
+		this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 55915b1..f3bc6eb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,11 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/oom.h>
+#include <linux/smpboot.h>
+#include "time/tick-internal.h"
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -128,8 +133,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -139,8 +142,6 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
@@ -187,7 +188,12 @@ static void rcu_preempt_qs(int cpu);
 
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	/* Callers to this function, rcu_preempt_qs(), must disable irqs. */
+	local_irq_save(flags);
 	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 #else
 void rcu_bh_qs(int cpu)
@@ -2307,16 +2313,14 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 /*
  * Do RCU core processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	struct rcu_state *rsp;
 
 	if (cpu_is_offline(smp_processor_id()))
 		return;
-	trace_rcu_utilization("Start RCU core");
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-	trace_rcu_utilization("End RCU core");
 }
 
 /*
@@ -2330,18 +2334,105 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	if (unlikely(!ACCESS_ONCE(rcu_scheduler_fully_active)))
 		return;
-	if (likely(!rsp->boost)) {
-		rcu_do_batch(rsp, rdp);
+	rcu_do_batch(rsp, rdp);
+}
+
+static void rcu_wake_cond(struct task_struct *t, int status)
+{
+	/*
+	 * If the thread is yielding, only wake it when this
+	 * is invoked from idle
+	 */
+	if (t && (status != RCU_KTHREAD_YIELDING || is_idle_task(current)))
+		wake_up_process(t);
+}
+
+/*
+ * Wake up this CPU's rcuc kthread to do RCU core processing.
+ */
+static void invoke_rcu_core(void)
+{
+	unsigned long flags;
+	struct task_struct *t;
+
+	if (!cpu_online(smp_processor_id()))
 		return;
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	t = __this_cpu_read(rcu_cpu_kthread_task);
+	if (t != NULL && current != t)
+		rcu_wake_cond(t, __this_cpu_read(rcu_cpu_kthread_status));
+	local_irq_restore(flags);
+}
+
+static void rcu_cpu_kthread_park(unsigned int cpu)
+{
+	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+}
+
+static int rcu_cpu_kthread_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(rcu_cpu_has_work);
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * RCU softirq used in flavors and configurations of RCU that do not
+ * support RCU priority boosting.
+ */
+static void rcu_cpu_kthread(unsigned int cpu)
+{
+	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
+	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	int spincnt;
+
+	for (spincnt = 0; spincnt < 10; spincnt++) {
+		trace_rcu_utilization("Start CPU kthread@rcu_wait");
+		local_bh_disable();
+		*statusp = RCU_KTHREAD_RUNNING;
+		this_cpu_inc(rcu_cpu_kthread_loops);
+		local_irq_disable();
+		work = *workp;
+		*workp = 0;
+		local_irq_enable();
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp == 0) {
+			trace_rcu_utilization("End CPU kthread@rcu_wait");
+			*statusp = RCU_KTHREAD_WAITING;
+			return;
+		}
 	}
-	invoke_rcu_callbacks_kthread();
+	*statusp = RCU_KTHREAD_YIELDING;
+	trace_rcu_utilization("Start CPU kthread@rcu_yield");
+	schedule_timeout_interruptible(2);
+	trace_rcu_utilization("End CPU kthread@rcu_yield");
+	*statusp = RCU_KTHREAD_WAITING;
 }
 
-static void invoke_rcu_core(void)
+static struct smp_hotplug_thread rcu_cpu_thread_spec = {
+	.store			= &rcu_cpu_kthread_task,
+	.thread_should_run	= rcu_cpu_kthread_should_run,
+	.thread_fn		= rcu_cpu_kthread,
+	.thread_comm		= "rcuc/%u",
+	.setup			= rcu_cpu_kthread_setup,
+	.park			= rcu_cpu_kthread_park,
+};
+
+/*
+ * Spawn per-CPU RCU core processing kthreads.
+ */
+static int __init rcu_spawn_core_kthreads(void)
 {
-	if (cpu_online(smp_processor_id()))
-		raise_softirq(RCU_SOFTIRQ);
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
+	return 0;
 }
+early_initcall(rcu_spawn_core_kthreads);
 
 /*
  * Handle any core-RCU processing required by a call_rcu() invocation.
@@ -2749,6 +2840,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
@@ -3346,7 +3441,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8491f47..75035be 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -513,10 +513,9 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
-static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
+static void rcu_cpu_kthread_setup(unsigned int cpu);
 #ifdef CONFIG_RCU_BOOST
-static void rcu_preempt_do_callbacks(void);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -541,6 +540,7 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dc0c4b2..e2d68e5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,12 +24,6 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
-#include <linux/delay.h>
-#include <linux/gfp.h>
-#include <linux/oom.h>
-#include <linux/smpboot.h>
-#include <linux/tick.h>
-
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
@@ -659,15 +653,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-#ifdef CONFIG_RCU_BOOST
-
-static void rcu_preempt_do_callbacks(void)
-{
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
-}
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -1103,6 +1088,19 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+/*
+ * If boosting, set rcuc kthreads to realtime priority.
+ */
+static void rcu_cpu_kthread_setup(unsigned int cpu)
+{
+#ifdef CONFIG_RCU_BOOST
+	struct sched_param sp;
+
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+}
+
 #ifdef CONFIG_RCU_BOOST
 
 #include "rtmutex_common.h"
@@ -1134,16 +1132,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static void rcu_wake_cond(struct task_struct *t, int status)
-{
-	/*
-	 * If the thread is yielding, only wake it when this
-	 * is invoked from idle
-	 */
-	if (status != RCU_KTHREAD_YIELDING || is_idle_task(current))
-		wake_up_process(t);
-}
-
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1287,23 +1275,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
- * Wake up the per-CPU kthread to invoke RCU callbacks.
- */
-static void invoke_rcu_callbacks_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
-	    current != __this_cpu_read(rcu_cpu_kthread_task)) {
-		rcu_wake_cond(__this_cpu_read(rcu_cpu_kthread_task),
-			      __this_cpu_read(rcu_cpu_kthread_status));
-	}
-	local_irq_restore(flags);
-}
-
-/*
  * Is the current CPU running the RCU-callbacks kthread?
  * Caller must have preemption disabled.
  */
@@ -1357,67 +1328,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-static void rcu_kthread_do_work(void)
-{
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
-	rcu_preempt_do_callbacks();
-}
-
-static void rcu_cpu_kthread_setup(unsigned int cpu)
-{
-	struct sched_param sp;
-
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-}
-
-static void rcu_cpu_kthread_park(unsigned int cpu)
-{
-	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-}
-
-static int rcu_cpu_kthread_should_run(unsigned int cpu)
-{
-	return __get_cpu_var(rcu_cpu_has_work);
-}
-
-/*
- * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * RCU softirq used in flavors and configurations of RCU that do not
- * support RCU priority boosting.
- */
-static void rcu_cpu_kthread(unsigned int cpu)
-{
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
-	int spincnt;
-
-	for (spincnt = 0; spincnt < 10; spincnt++) {
-		trace_rcu_utilization("Start CPU kthread@rcu_wait");
-		local_bh_disable();
-		*statusp = RCU_KTHREAD_RUNNING;
-		this_cpu_inc(rcu_cpu_kthread_loops);
-		local_irq_disable();
-		work = *workp;
-		*workp = 0;
-		local_irq_enable();
-		if (work)
-			rcu_kthread_do_work();
-		local_bh_enable();
-		if (*workp == 0) {
-			trace_rcu_utilization("End CPU kthread@rcu_wait");
-			*statusp = RCU_KTHREAD_WAITING;
-			return;
-		}
-	}
-	*statusp = RCU_KTHREAD_YIELDING;
-	trace_rcu_utilization("Start CPU kthread@rcu_yield");
-	schedule_timeout_interruptible(2);
-	trace_rcu_utilization("End CPU kthread@rcu_yield");
-	*statusp = RCU_KTHREAD_WAITING;
-}
-
 /*
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
  * served by the rcu_node in question.  The CPU hotplug lock is still
@@ -1451,27 +1361,14 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	free_cpumask_var(cm);
 }
 
-static struct smp_hotplug_thread rcu_cpu_thread_spec = {
-	.store			= &rcu_cpu_kthread_task,
-	.thread_should_run	= rcu_cpu_kthread_should_run,
-	.thread_fn		= rcu_cpu_kthread,
-	.thread_comm		= "rcuc/%u",
-	.setup			= rcu_cpu_kthread_setup,
-	.park			= rcu_cpu_kthread_park,
-};
-
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
 static int __init rcu_spawn_kthreads(void)
 {
 	struct rcu_node *rnp;
-	int cpu;
 
 	rcu_scheduler_fully_active = 1;
-	for_each_possible_cpu(cpu)
-		per_cpu(rcu_cpu_has_work, cpu) = 0;
-	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 	if (NUM_RCU_NODES > 1) {
@@ -1499,11 +1396,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
-static void invoke_rcu_callbacks_kthread(void)
-{
-	WARN_ON_ONCE(1);
-}
-
 static bool rcu_is_callbacks_kthread(void)
 {
 	return false;
@@ -2356,3 +2248,23 @@ static void rcu_kick_nohz_cpu(int cpu)
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4e657e5..aa1e4b2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -214,6 +214,7 @@ static void nohz_full_kick_work_func(struct irq_work *work)
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 	.func = nohz_full_kick_work_func,
+	.flags = IRQ_WORK_HARD_IRQ,
 };
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 48652cc..76846a1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1425,7 +1425,7 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
+#if defined(CONFIG_IRQ_WORK)
 	if (in_irq())
 		irq_work_run();
 #endif
@@ -1443,8 +1443,6 @@ static void run_timer_softirq(struct softirq_action *h)
 	irq_work_run();
 #endif
 
-	hrtimer_run_pending();
-
 	if (time_after_eq(jiffies, base->timer_jiffies))
 		__run_timers(base);
 }
@@ -1454,8 +1452,39 @@ static void run_timer_softirq(struct softirq_action *h)
  */
 void run_local_timers(void)
 {
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
+
 	hrtimer_run_queues();
-	raise_softirq(TIMER_SOFTIRQ);
+	/*
+	 * We can access this lockless as we are in the timer
+	 * interrupt. If there are no timers queued, nothing to do in
+	 * the timer softirq.
+	 */
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* On RT, irq work runs from softirq */
+	if (irq_work_needs_cpu()) {
+		raise_softirq(TIMER_SOFTIRQ);
+		return;
+	}
+
+	if (!spin_do_trylock(&base->lock)) {
+		raise_softirq(TIMER_SOFTIRQ);
+		return;
+	}
+#endif
+
+	if (!base->active_timers)
+		goto out;
+
+	/* Check whether the next pending timer has expired */
+	if (time_before_eq(base->next_timer, jiffies))
+		raise_softirq(TIMER_SOFTIRQ);
+out:
+#ifdef CONFIG_PREEMPT_RT_FULL
+	rt_spin_unlock_after_trylock_in_irq(&base->lock);
+#endif
+	/* The ; ensures that gcc won't complain in the !RT case */
+	;
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
diff --git a/localversion-rt b/localversion-rt
index b72862e..a68b433 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt30
+-rt31
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2d69b1b..ab674e8 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -79,6 +79,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <linux/locallock.h>
 
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 EXPORT_SYMBOL(sysctl_ip_default_ttl);
@@ -1471,6 +1472,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
 	.uc_ttl		= -1,
 };
 
+/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
+static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
+
 void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 			   __be32 saddr, const struct ip_reply_arg *arg,
 			   unsigned int len)
@@ -1508,8 +1512,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	if (IS_ERR(rt))
 		return;
 
-	get_cpu_light();
-	inet = &__get_cpu_var(unicast_sock);
+	inet = &get_locked_var(unicast_lock, unicast_sock);
 
 	inet->tos = arg->tos;
 	sk = &inet->sk;
@@ -1533,7 +1536,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		ip_push_pending_frames(sk, &fl4);
 	}
 
-	put_cpu_light();
+	put_locked_var(unicast_lock, unicast_sock);
 
 	ip_rt_put(rt);
 }
