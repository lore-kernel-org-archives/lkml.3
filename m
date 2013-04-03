Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab3DCMqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:46:44 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63031 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab3DCMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:46:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] nohz: Rename CONFIG_NO_HZ to CONFIG_NO_HZ_COMMON
Date: Wed,  3 Apr 2013 14:46:28 +0200
Message-Id: <1364993190-13784-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are planning to convert the dynticks Kconfig options layout
into a choice menu. The user must be able to easily pick
any of the following implementations: constant periodic tick,
idle dynticks, full dynticks.

As this implies a mutual exclusion, the two dynticks implementions
need to converge on the selection of a common Kconfig option in order
to ease the sharing of a common infrastructure.

It would thus seem pretty natural to reuse CONFIG_NO_HZ to
that end. It already implements all the idle dynticks code
and the full dynticks depends on all that code for now.
So ideally the choice menu would propose CONFIG_NO_HZ_IDLE and
CONFIG_NO_HZ_EXTENDED then both would select CONFIG_NO_HZ.

On the other hand we want to stay backward compatible: if
CONFIG_NO_HZ is set in an older config file, we want to
enable CONFIG_NO_HZ_IDLE by default.

But we can't afford both at the same time or we run into
a circular dependency:

1) CONFIG_NO_HZ_IDLE and CONFIG_NO_HZ_EXTENDED both select
   CONFIG_NO_HZ
2) If CONFIG_NO_HZ is set, we default to CONFIG_NO_HZ_IDLE

We might be able to support that from Kconfig/Kbuild but it
may not be wise to introduce such a confusing behaviour.

So to solve this, create a new CONFIG_NO_HZ_COMMON option
which gathers the common code between idle and full dynticks
(that common code for now is simply the idle dynticks code)
and select it from their referring Kconfig.

Then we'll later create CONFIG_NO_HZ_IDLE and map CONFIG_NO_HZ
to it for backward compatibility.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/RCU/stallwarn.txt         |    2 +-
 Documentation/cpu-freq/governors.txt    |    4 ++--
 arch/um/include/shared/common-offsets.h |    4 ++--
 arch/um/os-Linux/time.c                 |    2 +-
 include/linux/sched.h                   |    8 ++++----
 include/linux/tick.h                    |    8 ++++----
 init/Kconfig                            |    2 +-
 kernel/hrtimer.c                        |    4 ++--
 kernel/sched/core.c                     |   18 +++++++++---------
 kernel/sched/fair.c                     |   10 +++++-----
 kernel/sched/sched.h                    |    4 ++--
 kernel/softirq.c                        |    2 +-
 kernel/time/Kconfig                     |   13 +++++++++----
 kernel/time/tick-sched.c                |   12 ++++++------
 kernel/timer.c                          |    4 ++--
 15 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 1927151..b336755 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -176,7 +176,7 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 o	A hardware or software issue shuts off the scheduler-clock
 	interrupt on a CPU that is not in dyntick-idle mode.  This
 	problem really has happened, and seems to be most likely to
-	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.
+	result in RCU CPU stall warnings for CONFIG_NO_HZ_COMMON=n kernels.
 
 o	A bug in the RCU implementation.
 
diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index c7a2eb8..e3e5d9a 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -131,8 +131,8 @@ sampling_rate_min:
 The sampling rate is limited by the HW transition latency:
 transition_latency * 100
 Or by kernel restrictions:
-If CONFIG_NO_HZ is set, the limit is 10ms fixed.
-If CONFIG_NO_HZ is not set or nohz=off boot parameter is used, the
+If CONFIG_NO_HZ_COMMON is set, the limit is 10ms fixed.
+If CONFIG_NO_HZ_COMMON is not set or nohz=off boot parameter is used, the
 limits depend on the CONFIG_HZ option:
 HZ=1000: min=20000us  (20ms)
 HZ=250:  min=80000us  (80ms)
diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 2df313b..c923068 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -30,8 +30,8 @@ DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
 #ifdef CONFIG_PRINTK
 DEFINE(UML_CONFIG_PRINTK, CONFIG_PRINTK);
 #endif
-#ifdef CONFIG_NO_HZ
-DEFINE(UML_CONFIG_NO_HZ, CONFIG_NO_HZ);
+#ifdef CONFIG_NO_HZ_COMMON
+DEFINE(UML_CONFIG_NO_HZ_COMMON, CONFIG_NO_HZ_COMMON);
 #endif
 #ifdef CONFIG_UML_X86
 DEFINE(UML_CONFIG_UML_X86, CONFIG_UML_X86);
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index fac388c..e9824d5 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -79,7 +79,7 @@ long long os_nsecs(void)
 	return timeval_to_ns(&tv);
 }
 
-#ifdef UML_CONFIG_NO_HZ
+#ifdef UML_CONFIG_NO_HZ_COMMON
 static int after_sleep_interval(struct timespec *ts)
 {
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 10626e2e..1ff9e0a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -230,7 +230,7 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
@@ -1758,13 +1758,13 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 }
 #endif
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 void calc_load_enter_idle(void);
 void calc_load_exit_idle(void);
 #else
 static inline void calc_load_enter_idle(void) { }
 static inline void calc_load_exit_idle(void) { }
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 #ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
@@ -1850,7 +1850,7 @@ extern void idle_task_exit(void);
 static inline void idle_task_exit(void) {}
 #endif
 
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
 extern void wake_up_nohz_cpu(int cpu);
 #else
 static inline void wake_up_nohz_cpu(int cpu) { }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 44bfa8a..5e40333 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -82,7 +82,7 @@ extern int tick_program_event(ktime_t expires, int force);
 extern void tick_setup_sched_timer(void);
 # endif
 
-# if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
+# if defined CONFIG_NO_HZ_COMMON || defined CONFIG_HIGH_RES_TIMERS
 extern void tick_cancel_sched_timer(int cpu);
 # else
 static inline void tick_cancel_sched_timer(int cpu) { }
@@ -123,7 +123,7 @@ static inline void tick_check_idle(int cpu) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-# ifdef CONFIG_NO_HZ
+# ifdef CONFIG_NO_HZ_COMMON
 DECLARE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 static inline int tick_nohz_tick_stopped(void)
@@ -138,7 +138,7 @@ extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 
-# else /* !CONFIG_NO_HZ */
+# else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
 {
 	return 0;
@@ -155,7 +155,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
-# endif /* !NO_HZ */
+# endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_EXTENDED
 extern int tick_nohz_extended_cpu(int cpu);
diff --git a/init/Kconfig b/init/Kconfig
index 8a1dac2..edc8132 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -580,7 +580,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on NO_HZ && SMP
+	depends on NO_HZ_COMMON && SMP
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods in
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..ec60482 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -160,7 +160,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
  */
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
 		return get_nohz_timer_target();
 #endif
@@ -1106,7 +1106,7 @@ ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e91ee58..9bb397d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -549,7 +549,7 @@ void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
  * from an idle cpu.  This is good for power-savings.
@@ -641,14 +641,14 @@ static inline bool got_nohz_idle_kick(void)
 	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
 }
 
-#else /* CONFIG_NO_HZ */
+#else /* CONFIG_NO_HZ_COMMON */
 
 static inline bool got_nohz_idle_kick(void)
 {
 	return false;
 }
 
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 void sched_avg_update(struct rq *rq)
 {
@@ -2139,7 +2139,7 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 	return load >> FSHIFT;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * Handle NO_HZ for the global load-average.
  *
@@ -2365,12 +2365,12 @@ static void calc_global_nohz(void)
 	smp_wmb();
 	calc_load_idx++;
 }
-#else /* !CONFIG_NO_HZ */
+#else /* !CONFIG_NO_HZ_COMMON */
 
 static inline long calc_load_fold_idle(void) { return 0; }
 static inline void calc_global_nohz(void) { }
 
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
@@ -2530,7 +2530,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	sched_avg_update(this_rq);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * There is no sane way to deal with nohz on smp when using jiffies because the
  * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
@@ -2590,7 +2590,7 @@ void update_cpu_load_nohz(void)
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from scheduler_tick()
@@ -7023,7 +7023,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
 		rq_attach_root(rq, &def_root_domain);
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 		rq->nohz_flags = 0;
 #endif
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 539760e..5c97fca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5331,7 +5331,7 @@ out_unlock:
 	return 0;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * idle load balancing details
  * - When one of the busy CPUs notice that there may be an idle rebalancing
@@ -5541,9 +5541,9 @@ out:
 		rq->next_balance = next_balance;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
- * In CONFIG_NO_HZ case, the idle balance kickee will do the
+ * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
@@ -5686,7 +5686,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
@@ -6156,7 +6156,7 @@ __init void init_sched_fair_class(void)
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3bd15a4..889904d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -404,7 +404,7 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	u64 nohz_stamp;
 	unsigned long nohz_flags;
 #endif
@@ -1333,7 +1333,7 @@ extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b4d252f..de15813 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -348,7 +348,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
 		tick_nohz_irq_exit();
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 726c33e..c88fc43 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -64,16 +64,21 @@ config GENERIC_CMOS_UPDATE
 if GENERIC_CLOCKEVENTS
 menu "Timers subsystem"
 
-# Core internal switch. Selected by NO_HZ / HIGH_RES_TIMERS. This is
+# Core internal switch. Selected by NO_HZ_COMMON / HIGH_RES_TIMERS. This is
 # only related to the tick functionality. Oneshot clockevent devices
 # are supported independ of this.
 config TICK_ONESHOT
 	bool
 
+config NO_HZ_COMMON
+	bool
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-	select TICK_ONESHOT
+	select NO_HZ_COMMON
 	help
 	  This option enables a tickless system: timer interrupts will
 	  only trigger on an as-needed basis both when the system is
@@ -81,14 +86,14 @@ config NO_HZ
 
 config NO_HZ_EXTENDED
 	bool "Full dynticks system"
-	# NO_HZ dependency
+	# NO_HZ_COMMON dependency
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	# RCU_USER_QS
 	depends on HAVE_CONTEXT_TRACKING && SMP
 	# RCU_NOCB_CPU dependency
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	depends on VIRT_CPU_ACCOUNTING_GEN
-	select NO_HZ
+	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
 	select CONTEXT_TRACKING_FORCE
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 57bb3fe..ccfc208 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -104,7 +104,7 @@ static void tick_sched_do_timer(ktime_t now)
 {
 	int cpu = smp_processor_id();
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	/*
 	 * Check if the do_timer duty was dropped. We don't care about
 	 * concurrency: This happens only when the cpu in charge went
@@ -124,7 +124,7 @@ static void tick_sched_do_timer(ktime_t now)
 
 static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 {
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
 	 * the watchdog as we might not schedule for a really long
@@ -235,7 +235,7 @@ core_initcall(init_tick_nohz_extended);
 /*
  * NOHZ - aka dynamic tick functionality
  */
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * NO HZ enabled ?
  */
@@ -907,7 +907,7 @@ static inline void tick_check_nohz(int cpu)
 static inline void tick_nohz_switch_to_nohz(void) { }
 static inline void tick_check_nohz(int cpu) { }
 
-#endif /* NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
@@ -992,14 +992,14 @@ void tick_setup_sched_timer(void)
 		now = ktime_get();
 	}
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (tick_nohz_enabled)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
 
-#if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
+#if defined CONFIG_NO_HZ_COMMON || defined CONFIG_HIGH_RES_TIMERS
 void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
diff --git a/kernel/timer.c b/kernel/timer.c
index 4e3040b..1b7489f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -738,7 +738,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	cpu = smp_processor_id();
 
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
 		cpu = get_nohz_timer_target();
 #endif
@@ -1188,7 +1188,7 @@ static inline void __run_timers(struct tvec_base *base)
 	spin_unlock_irq(&base->lock);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a CPU is idle.
-- 
1.7.5.4

