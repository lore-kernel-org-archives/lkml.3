Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaLUKiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:38:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47126 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaLUKin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:38:43 -0500
Subject: [RFC PATCH] drivers/intel_powerclamp : Redesign implementation of
 idle injection
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: peterz@infradead.org, tglx@linutronix.de, jacob.jun.pan@intel.com
Cc: fweisbec@gmail.com, frederic@kernel.org, linux-kernel@vger.kernel.org,
        edubezval@gmail.com, viresh.kumar@linaro.org, rui.zhang@intel.com,
        fengguang.wu@intel.com, lkp@01.org
Date: Sun, 21 Dec 2014 16:08:25 +0530
Message-ID: <20141221103717.23372.45259.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122110-0033-0000-0000-0000031725E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerclamp driver injects idle periods to stay within the thermal constraints.
The driver does a fake idle by spawning per-cpu threads that call the mwait
instruction. This behavior of fake idle can confuse the other kernel subsystems.
For instance it calls into the nohz tick handlers, which are meant to be called
only by the idle thread. It sets the state of the tick in each cpu to idle and
stops the tick, when there are tasks on the runqueue. As a result the callers of
idle_cpu()/ tick_nohz_tick_stopped() see different states of the cpu; while the
former thinks that the cpu is busy, the latter thinks that it is idle. The outcome
may be  inconsistency in the scheduler/nohz states which can lead to serious
consequences. One of them was reported on this thread:
https://lkml.org/lkml/2014/12/11/365.

Thomas posted out a patch to disable the powerclamp driver from calling into the
tick nohz code which has taken care of the above regression for the moment. However
powerclamp driver as a result, will not be able to inject idle periods due to the
presence of periodic ticks. With the current design of fake idle, we cannot move
towards a better solution.
https://lkml.org/lkml/2014/12/18/169

This patch aims at removing the concept of fake idle and instead makes the cpus
truly idle by throttling the runqueues during the idle injection periods. The situation
is in fact very similar to throttling cfs_rqs when they exceed their bandwidths.
The exception here is that the root cfs_rq is throttled in the presence of available
bandwidth, due to the need to force idle. The runqueues automatically get unthrottled
at all other times and call to reschedule is made. Per-cpu timers are queued to expire
after every active/idle periods of powerclamp driver, which decide whether to throttle
or unthrottle the runqueues. This way, the tick nohz state and the scheduler states of
the cpus are sane during the idle injection periods because they naturally fall in place.

Another point to note is that the scheduler_tick() is called after the timers are
serviced. This means that soon after the runqueue is throttled by the powerclamp timer,
the idle task will get scheduled in. IOW, the request of the powerclamp timer to inject
idle is honored almost immediately. The same holds for unthrottling as well.

This patch is compile tested only. The goal is to get a consensus on the design first.
There are some points that need to be given a thought as far as I can see:

1. The idle task chosen during the idle injection period needs to enter a specific mwait
state. The cpuidle governors cannot choose any idle state like they do generally for idle
tasks.

2. We throttle runqueue when the bandwidth is available. We do not touch any parameters
around the cfs_rq bandwidth in this patch. It is supposed to bypass the bandwidth checks
entirely. But will there be any serious consequence as a result?

3. There can be cases when the runqueues are throttled when bandwidths are exceeded too.
What are the consequences of the powerclamp driver running parallely?

4. The idle periods should stand synchronized across all cpus because the change in the
design is to start timers to expire immediately instead of waking up kthreads. The only
concern is cpu hotplug operations when the cpu coming online can go out of sync with
the idle periods. But that situation exists today as well.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Missed Ccing LKML on the previous mail.

 drivers/thermal/intel_powerclamp.c |  227 ++++++++++++++----------------------
 include/linux/sched.h              |    2 
 kernel/sched/fair.c                |   29 ++++-
 3 files changed, 117 insertions(+), 141 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 95cb7fc..a6fd453 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -87,7 +87,7 @@ static unsigned int control_cpu; /* The cpu assigned to collect stat and update
 static bool clamping;
 
 
-static struct task_struct * __percpu *powerclamp_thread;
+DEFINE_PER_CPU(struct timer_list, powerclamp_timer);
 static struct thermal_cooling_device *cooling_dev;
 static unsigned long *cpu_clamping_mask;  /* bit map for tracking per cpu
 					   * clamping thread
@@ -256,11 +256,6 @@ static u64 pkg_state_counter(void)
 	return count;
 }
 
-static void noop_timer(unsigned long foo)
-{
-	/* empty... just the fact that we get the interrupt wakes us up */
-}
-
 static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
@@ -362,102 +357,72 @@ static bool powerclamp_adjust_controls(unsigned int target_ratio,
 	return set_target_ratio + guard <= current_ratio;
 }
 
-static int clamp_thread(void *arg)
+static void powerclamp_timer_fn(unsigned long data)
 {
-	int cpunr = (unsigned long)arg;
-	DEFINE_TIMER(wakeup_timer, noop_timer, 0, 0);
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
+	int sleeptime;
+	unsigned long target_jiffies;
+	unsigned int guard;
+	unsigned int compensation = 0;
+	int interval; /* jiffies to sleep for each attempt */
+	unsigned int duration_jiffies = msecs_to_jiffies(duration);
+	unsigned int window_size_now;
+	int clamp = 0, cpu = smp_processor_id();
+	struct timer_list *ts = this_cpu_ptr(&powerclamp_timer);
 	unsigned int count = 0;
 	unsigned int target_ratio;
 
-	set_bit(cpunr, cpu_clamping_mask);
-	set_freezable();
-	init_timer_on_stack(&wakeup_timer);
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
-	while (true == clamping && !kthread_should_stop() &&
-		cpu_online(cpunr)) {
-		int sleeptime;
-		unsigned long target_jiffies;
-		unsigned int guard;
-		unsigned int compensation = 0;
-		int interval; /* jiffies to sleep for each attempt */
-		unsigned int duration_jiffies = msecs_to_jiffies(duration);
-		unsigned int window_size_now;
-
-		try_to_freeze();
-		/*
-		 * make sure user selected ratio does not take effect until
-		 * the next round. adjust target_ratio if user has changed
-		 * target such that we can converge quickly.
-		 */
-		target_ratio = set_target_ratio;
-		guard = 1 + target_ratio/20;
-		window_size_now = window_size;
-		count++;
-
-		/*
-		 * systems may have different ability to enter package level
-		 * c-states, thus we need to compensate the injected idle ratio
-		 * to achieve the actual target reported by the HW.
-		 */
-		compensation = get_compensation(target_ratio);
-		interval = duration_jiffies*100/(target_ratio+compensation);
-
-		/* align idle time */
-		target_jiffies = roundup(jiffies, interval);
-		sleeptime = target_jiffies - jiffies;
-		if (sleeptime <= 0)
-			sleeptime = 1;
-		schedule_timeout_interruptible(sleeptime);
-		/*
-		 * only elected controlling cpu can collect stats and update
-		 * control parameters.
-		 */
-		if (cpunr == control_cpu && !(count%window_size_now)) {
-			should_skip =
-				powerclamp_adjust_controls(target_ratio,
-							guard, window_size_now);
-			smp_mb();
-		}
+again:	if (!clamping) {
+		throttle_rq(cpu, 0);
+		clear_bit(cpu, clamping_mask);
+		return;
+	}
 
-		if (should_skip)
-			continue;
-
-		target_jiffies = jiffies + duration_jiffies;
-		mod_timer(&wakeup_timer, target_jiffies);
-		if (unlikely(local_softirq_pending()))
-			continue;
-		/*
-		 * stop tick sched during idle time, interrupts are still
-		 * allowed. thus jiffies are updated properly.
-		 */
-		preempt_disable();
-		tick_nohz_idle_enter();
-		/* mwait until target jiffies is reached */
-		while (time_before(jiffies, target_jiffies)) {
-			unsigned long ecx = 1;
-			unsigned long eax = target_mwait;
-
-			/*
-			 * REVISIT: may call enter_idle() to notify drivers who
-			 * can save power during cpu idle. same for exit_idle()
-			 */
-			local_touch_nmi();
-			stop_critical_timings();
-			mwait_idle_with_hints(eax, ecx);
-			start_critical_timings();
-			atomic_inc(&idle_wakeup_counter);
-		}
-		tick_nohz_idle_exit();
-		preempt_enable();
+	/*
+	 * make sure user selected ratio does not take effect until
+	 * the next round. adjust target_ratio if user has changed
+	 * target such that we can converge quickly.
+	 */
+	target_ratio = set_target_ratio;
+	guard = 1 + target_ratio/20;
+	window_size_now = window_size;
+	count++;
+
+	/*
+	 * systems may have different ability to enter package level
+	 * c-states, thus we need to compensate the injected idle ratio
+	 * to achieve the actual target reported by the HW.
+	 */
+	compensation = get_compensation(target_ratio);
+	interval = duration_jiffies*100/(target_ratio+compensation);
+
+	/* align idle time */
+	target_jiffies = roundup(jiffies, interval);
+	sleeptime = target_jiffies - jiffies;
+	if (sleeptime > 0)
+		goto queue_timer;
+	/*
+	 * only elected controlling cpu can collect stats and update
+	 * control parameters.
+	 */
+	if (cpu == control_cpu && !(count%window_size_now)) {
+		should_skip =
+			powerclamp_adjust_controls(target_ratio,
+						guard, window_size_now);
+		smp_mb();
 	}
-	del_timer_sync(&wakeup_timer);
-	clear_bit(cpunr, cpu_clamping_mask);
 
-	return 0;
+	if (should_skip)
+		goto again;
+
+	target_jiffies = jiffies + duration_jiffies;
+
+	if (unlikely(local_softirq_pending()))
+		goto again;
+	clamp = 1;
+
+queue_timer:
+	mod_timer(ts, target_jiffies);
+	throttle_rq(cpu, clamp);
 }
 
 /*
@@ -504,7 +469,6 @@ static void poll_pkg_cstate(struct work_struct *dummy)
 static int start_power_clamp(void)
 {
 	unsigned long cpu;
-	struct task_struct *thread;
 
 	/* check if pkg cstate counter is completely 0, abort in this case */
 	if (!has_pkg_state_counter()) {
@@ -526,20 +490,11 @@ static int start_power_clamp(void)
 
 	/* start one thread per online cpu */
 	for_each_online_cpu(cpu) {
-		struct task_struct **p =
-			per_cpu_ptr(powerclamp_thread, cpu);
-
-		thread = kthread_create_on_node(clamp_thread,
-						(void *) cpu,
-						cpu_to_node(cpu),
-						"kidle_inject/%ld", cpu);
-		/* bind to cpu here */
-		if (likely(!IS_ERR(thread))) {
-			kthread_bind(thread, cpu);
-			wake_up_process(thread);
-			*p = thread;
-		}
+		struct timer_list *ts = &per_cpu(powerclamp_timer, cpu);
 
+		set_bit(cpu, cpu_clamping_mask);
+		ts.expires = 0;
+		add_timer_on(ts, cpu);
 	}
 	put_online_cpus();
 
@@ -549,7 +504,7 @@ static int start_power_clamp(void)
 static void end_power_clamp(void)
 {
 	int i;
-	struct task_struct *thread;
+	struct timer_list *ts;
 
 	clamping = false;
 	/*
@@ -560,9 +515,10 @@ static void end_power_clamp(void)
 	msleep(20);
 	if (bitmap_weight(cpu_clamping_mask, num_possible_cpus())) {
 		for_each_set_bit(i, cpu_clamping_mask, num_possible_cpus()) {
-			pr_debug("clamping thread for cpu %d alive, kill\n", i);
-			thread = *per_cpu_ptr(powerclamp_thread, i);
-			kthread_stop(thread);
+			ts = &per_cpu(powerclamp_timer, i);
+			pr_debug("clamping timer for cpu %d alive, delete\n", i);
+			del_timer_sync(ts);
+			throttle_rq(i, 0);
 		}
 	}
 }
@@ -571,36 +527,26 @@ static int powerclamp_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned long cpu = (unsigned long)hcpu;
-	struct task_struct *thread;
-	struct task_struct **percpu_thread =
-		per_cpu_ptr(powerclamp_thread, cpu);
+	struct timer_list *ts = &per_cpu(powerclamp_timer, cpu);
 
 	if (false == clamping)
 		goto exit_ok;
 
 	switch (action) {
 	case CPU_ONLINE:
-		thread = kthread_create_on_node(clamp_thread,
-						(void *) cpu,
-						cpu_to_node(cpu),
-						"kidle_inject/%lu", cpu);
-		if (likely(!IS_ERR(thread))) {
-			kthread_bind(thread, cpu);
-			wake_up_process(thread);
-			*percpu_thread = thread;
-		}
 		/* prefer BSP as controlling CPU */
+		init_timer(ts);
+		ts.function = powerclamp_timer_fn;
+		ts.expires = 0;
+		add_timer_on(ts, cpu);
 		if (cpu == 0) {
 			control_cpu = 0;
 			smp_mb();
 		}
 		break;
 	case CPU_DEAD:
-		if (test_bit(cpu, cpu_clamping_mask)) {
-			pr_err("cpu %lu dead but powerclamping thread is not\n",
-				cpu);
-			kthread_stop(*percpu_thread);
-		}
+		clear_bit(cpu, cpu_clamping_mask);
+		del_timer(ts);
 		if (cpu == control_cpu) {
 			control_cpu = smp_processor_id();
 			smp_mb();
@@ -763,6 +709,8 @@ static int powerclamp_init(void)
 {
 	int retval;
 	int bitmap_size;
+	int cpu;
+	struct timer_list *ts;
 
 	bitmap_size = BITS_TO_LONGS(num_possible_cpus()) * sizeof(long);
 	cpu_clamping_mask = kzalloc(bitmap_size, GFP_KERNEL);
@@ -778,18 +726,20 @@ static int powerclamp_init(void)
 	window_size = 2;
 	register_hotcpu_notifier(&powerclamp_cpu_notifier);
 
-	powerclamp_thread = alloc_percpu(struct task_struct *);
-	if (!powerclamp_thread) {
-		retval = -ENOMEM;
-		goto exit_unregister;
-	}
-
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
 		retval = -ENODEV;
-		goto exit_free_thread;
+		goto exit_unregister;
+	}
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		ts = &per_cpu(powerclamp_timer, cpu);
+		init_timer(ts);
+		ts.function = powerclamp_timer_fn();
 	}
+	put_online_cpus();
 
 	if (!duration)
 		duration = jiffies_to_msecs(DEFAULT_DURATION_JIFFIES);
@@ -798,8 +748,6 @@ static int powerclamp_init(void)
 
 	return 0;
 
-exit_free_thread:
-	free_percpu(powerclamp_thread);
 exit_unregister:
 	unregister_hotcpu_notifier(&powerclamp_cpu_notifier);
 exit_free:
@@ -812,7 +760,6 @@ static void powerclamp_exit(void)
 {
 	unregister_hotcpu_notifier(&powerclamp_cpu_notifier);
 	end_power_clamp();
-	free_percpu(powerclamp_thread);
 	thermal_cooling_device_unregister(cooling_dev);
 	kfree(cpu_clamping_mask);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..5843b7e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2075,9 +2075,11 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 #ifdef CONFIG_NO_HZ_COMMON
 void calc_load_enter_idle(void);
 void calc_load_exit_idle(void);
+void throttle_rq(int cpu, int throttle);
 #else
 static inline void calc_load_enter_idle(void) { }
 static inline void calc_load_exit_idle(void) { }
+static inline void throttle_rq(int cpu, int throttle);
 #endif /* CONFIG_NO_HZ_COMMON */
 
 #ifndef CONFIG_CPUMASK_OFFSTACK
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ef2b104..01785cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3417,8 +3417,15 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	 * distribute_cfs_runtime will not see us
 	 */
 	list_add_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
-	if (!cfs_b->timer_active)
+
+	/*
+	 * Check if the cfs_rq is throttled inspite of having sufficient
+	 * bandwidth. If so, do not meddle with the bandwidth since this
+	 * is a case of forced idle injection
+	 */
+	if (cfs_rq_throttled(cfs_rq) && !cfs_b->timer_active)
 		__start_cfs_bandwidth(cfs_b, false);
+
 	raw_spin_unlock(&cfs_b->lock);
 }
 
@@ -3469,6 +3476,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		resched_curr(rq);
 }
 
+void throttle_rq(int cpu, int throttle)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (throttle && !rq->cfs.throttled)
+		throttle_cfs_rq(&rq->cfs);
+	else if (!throttle && rq->cfs.throttled)
+		unthrottle_cfs_rq(&rq->cfs);
+}
+EXPORT_SYMBOL(throttle_rq);
+
 static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
 		u64 remaining, u64 expires)
 {
@@ -4855,6 +4873,14 @@ again:
 		if (unlikely(check_cfs_rq_runtime(cfs_rq)))
 			goto simple;
 
+		/*
+		 * We may have forced throttling to inject idle.
+		 */
+		if (unlikely(cfs_rq->throttled)) {
+			put_prev_task(rq, prev);
+			goto force_idle;
+		}
+
 		se = pick_next_entity(cfs_rq, curr);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
@@ -4926,6 +4952,7 @@ idle:
 	if (new_tasks > 0)
 		goto again;
 
+force_idle:
 	return NULL;
 }
 

