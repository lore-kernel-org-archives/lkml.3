Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaFDQ5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:57:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:33125 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaFDQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:57:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,974,1392192000"; 
   d="scan'208";a="522707140"
Date: Wed, 4 Jun 2014 01:58:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, arjan@linux.intel.com,
        rui.zhang@intel.com, luto@amacapital.net
Subject: Re: [PATCH] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20140604015812.140a00d1@jacob-desktop>
In-Reply-To: <20140604085418.GA11096@twins.programming.kicks-ass.net>
References: <20140604085418.GA11096@twins.programming.kicks-ass.net>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 10:54:18 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> I'm still sitting on this patch. Jacub you were going to make it play
> nice with QoS?
> 
I had a patchset to work through system PM QOS and still maintain the
idle injection efficiency. When I saw you did not merge the patch
below, I thought you have abandoned it :)

The only issue as per our last discussion is the lack of notification
when PM QOS cannot be met. But that is intrinsic to PM QOS itself.

I also consulted with Arjan and looked at directly intercept with
intel_idle since both intel_powerclamp and intel_idle are arch specific
drivers. But I think that is hard to do at per idle period basis,
since we should still allow "natural" idle during the forced idle time.

So, I think we can take a two stepped approach,
1. integrate your patch with a
updated version of https://lkml.org/lkml/2013/11/26/534 such that there
is no performance/efficiency regression.
2. add notification mechanism to system qos when constraints cannot be
met.


Thanks,

Jacob
> ---
> Subject: idle, thermal, acpi: Remove home grown idle implementations
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Nov 20 14:32:37 CET 2013
> 
> People are starting to grow their own idle implementations in various
> disgusting ways. Collapse the lot and use the generic idle code to
> provide a proper idle cycle implementation.
> 
> This does not fully preseve existing behaviour in that the generic
> idle cycle function calls into the normal cpuidle governed idle
> routines and should thus respect things like QoS parameters and the
> like.
> 
> If people want to over-ride the idle state they should talk to the
> cpuidle folks about extending the interface and attempt to preserve
> QoS guarantees, instead of jumping straight to the deepest possible C
> state -- Jacub Pan said he was going to do this.
> 
> This is reported to work for intel_powerclamp by Jacub Pan, the
> acpi_pad driver is untested.
> 
> Cc: rui.zhang@intel.com
> Cc: jacob.jun.pan@linux.intel.com
> Cc: lenb@kernel.org
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: hpa@zytor.com
> Cc: arjan@linux.intel.com
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  drivers/acpi/acpi_pad.c            |   41 -----------
>  drivers/thermal/intel_powerclamp.c |   38 ----------
>  include/linux/cpu.h                |    2 
>  include/linux/sched.h              |    3 
>  kernel/sched/core.c                |    9 ++
>  kernel/sched/idle.c                |  129
> ++++++++++++++++++++++---------------
> kernel/time/tick-sched.c           |    2 7 files changed, 95
> insertions(+), 129 deletions(-)
> 
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -40,9 +40,7 @@ static DEFINE_MUTEX(round_robin_lock);
>  static unsigned long power_saving_mwait_eax;
>  
>  static unsigned char tsc_detected_unstable;
> -static unsigned char tsc_marked_unstable;
>  static unsigned char lapic_detected_unstable;
> -static unsigned char lapic_marked_unstable;
>  
>  static void power_saving_mwait_init(void)
>  {
> @@ -152,10 +150,9 @@ static int power_saving_thread(void *dat
>  	unsigned int tsk_index = (unsigned long)data;
>  	u64 last_jiffies = 0;
>  
> -	sched_setscheduler(current, SCHED_RR, &param);
> +	sched_setscheduler(current, SCHED_FIFO, &param);
>  
>  	while (!kthread_should_stop()) {
> -		int cpu;
>  		u64 expire_time;
>  
>  		try_to_freeze();
> @@ -170,41 +167,7 @@ static int power_saving_thread(void *dat
>  
>  		expire_time = jiffies + HZ * (100 - idle_pct) / 100;
>  
> -		while (!need_resched()) {
> -			if (tsc_detected_unstable
> && !tsc_marked_unstable) {
> -				/* TSC could halt in idle, so notify
> users */
> -				mark_tsc_unstable("TSC halts in
> idle");
> -				tsc_marked_unstable = 1;
> -			}
> -			if (lapic_detected_unstable
> && !lapic_marked_unstable) {
> -				int i;
> -				/* LAPIC could halt in idle, so
> notify users */
> -				for_each_online_cpu(i)
> -					clockevents_notify(
> -
> CLOCK_EVT_NOTIFY_BROADCAST_ON,
> -						&i);
> -				lapic_marked_unstable = 1;
> -			}
> -			local_irq_disable();
> -			cpu = smp_processor_id();
> -			if (lapic_marked_unstable)
> -				clockevents_notify(
> -
> CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> -			stop_critical_timings();
> -
> -
> mwait_idle_with_hints(power_saving_mwait_eax, 1); -
> -			start_critical_timings();
> -			if (lapic_marked_unstable)
> -				clockevents_notify(
> -
> CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> -			local_irq_enable();
> -
> -			if (jiffies > expire_time) {
> -				do_sleep = 1;
> -				break;
> -			}
> -		}
> +		play_idle(expire_time);
>  
>  		/*
>  		 * current sched_rt has threshold for rt task
> running time. --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -256,11 +256,6 @@ static u64 pkg_state_counter(void)
>  	return count;
>  }
>  
> -static void noop_timer(unsigned long foo)
> -{
> -	/* empty... just the fact that we get the interrupt wakes us
> up */ -}
> -
>  static unsigned int get_compensation(int ratio)
>  {
>  	unsigned int comp = 0;
> @@ -365,7 +360,6 @@ static bool powerclamp_adjust_controls(u
>  static int clamp_thread(void *arg)
>  {
>  	int cpunr = (unsigned long)arg;
> -	DEFINE_TIMER(wakeup_timer, noop_timer, 0, 0);
>  	static const struct sched_param param = {
>  		.sched_priority = MAX_USER_RT_PRIO/2,
>  	};
> @@ -374,11 +368,9 @@ static int clamp_thread(void *arg)
>  
>  	set_bit(cpunr, cpu_clamping_mask);
>  	set_freezable();
> -	init_timer_on_stack(&wakeup_timer);
>  	sched_setscheduler(current, SCHED_FIFO, &param);
>  
> -	while (true == clamping && !kthread_should_stop() &&
> -		cpu_online(cpunr)) {
> +	while (clamping && !kthread_should_stop() &&
> cpu_online(cpunr)) { int sleeptime;
>  		unsigned long target_jiffies;
>  		unsigned int guard;
> @@ -426,35 +418,11 @@ static int clamp_thread(void *arg)
>  		if (should_skip)
>  			continue;
>  
> -		target_jiffies = jiffies + duration_jiffies;
> -		mod_timer(&wakeup_timer, target_jiffies);
>  		if (unlikely(local_softirq_pending()))
>  			continue;
> -		/*
> -		 * stop tick sched during idle time, interrupts are
> still
> -		 * allowed. thus jiffies are updated properly.
> -		 */
> -		preempt_disable();
> -		tick_nohz_idle_enter();
> -		/* mwait until target jiffies is reached */
> -		while (time_before(jiffies, target_jiffies)) {
> -			unsigned long ecx = 1;
> -			unsigned long eax = target_mwait;
> -
> -			/*
> -			 * REVISIT: may call enter_idle() to notify
> drivers who
> -			 * can save power during cpu idle. same for
> exit_idle()
> -			 */
> -			local_touch_nmi();
> -			stop_critical_timings();
> -			mwait_idle_with_hints(eax, ecx);
> -			start_critical_timings();
> -			atomic_inc(&idle_wakeup_counter);
> -		}
> -		tick_nohz_idle_exit();
> -		preempt_enable();
> +
> +		play_idle(duration_jiffies);
>  	}
> -	del_timer_sync(&wakeup_timer);
>  	clear_bit(cpunr, cpu_clamping_mask);
>  
>  	return 0;
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -255,6 +255,8 @@ enum cpuhp_state {
>  	CPUHP_ONLINE,
>  };
>  
> +void play_idle(unsigned long jiffies);
> +
>  void cpu_startup_entry(enum cpuhp_state state);
>  void cpu_idle(void);
>  
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1892,6 +1892,7 @@ extern void thread_group_cputime_adjuste
>  /*
>   * Per process flags
>   */
> +#define PF_IDLE		0x00000002	/* I am an IDLE
> thread */ #define PF_EXITING	0x00000004	/* getting shut
> down */ #define PF_EXITPIDONE	0x00000008	/* pi exit
> done on shut down */ #define PF_VCPU
> 0x00000010	/* I'm a virtual CPU */ @@ -2204,7 +2205,7 @@
> extern struct task_struct *idle_task(int */
>  static inline bool is_idle_task(const struct task_struct *p)
>  {
> -	return p->pid == 0;
> +	return !!(p->flags & PF_IDLE);
>  }
>  extern struct task_struct *curr_task(int cpu);
>  extern void set_curr_task(int cpu, struct task_struct *p);
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -676,10 +676,12 @@ static void wake_up_idle_cpu(int cpu)
>  	if (cpu == smp_processor_id())
>  		return;
>  
> -	if (set_nr_and_not_polling(rq->idle))
> +	rcu_read_lock();
> +	if (set_nr_and_not_polling(rq->curr))
>  		smp_send_reschedule(cpu);
>  	else
>  		trace_sched_wake_polling_cpu(cpu);
> +	rcu_read_unlock();
>  }
>  
>  static bool wake_up_full_nohz_cpu(int cpu)
> @@ -1605,10 +1607,12 @@ static void ttwu_queue_remote(struct tas
>  	struct rq *rq = cpu_rq(cpu);
>  
>  	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
> -		if (!set_nr_if_polling(rq->idle))
> +		rcu_read_lock();
> +		if (!set_nr_if_polling(rq->curr))
>  			smp_send_reschedule(cpu);
>  		else
>  			trace_sched_wake_polling_cpu(cpu);
> +		rcu_read_unlock();
>  	}
>  }
>  
> @@ -4537,6 +4541,7 @@ void init_idle(struct task_struct *idle,
>  	__sched_fork(0, idle);
>  	idle->state = TASK_RUNNING;
>  	idle->se.exec_start = sched_clock();
> +	idle->flags |= PF_IDLE;
>  
>  	do_set_cpus_allowed(idle, cpumask_of(cpu));
>  	/*
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -184,66 +184,94 @@ static void cpuidle_idle_call(void)
>   *
>   * Called with polling cleared.
>   */
> -static void cpu_idle_loop(void)
> +static void do_idle(void)
>  {
> -	while (1) {
> -		/*
> -		 * If the arch has a polling bit, we maintain an
> invariant:
> -		 *
> -		 * The polling bit is clear if we're not scheduled
> (i.e. if
> -		 * rq->curr != rq->idle).  This means that, if
> rq->idle has
> -		 * the polling bit set, then setting need_resched is
> -		 * guaranteed to cause the cpu to reschedule.
> -		 */
> +	/*
> +	 * If the arch has a polling bit, we maintain an invariant:
> +	 *
> +	 * The polling bit is clear if we're not scheduled (i.e. if
> rq->curr !=
> +	 * rq->idle).  This means that, if rq->idle has the polling
> bit set,
> +	 * then setting need_resched is guaranteed to cause the cpu
> to
> +	 * reschedule.
> +	 */
>  
> -		__current_set_polling();
> -		tick_nohz_idle_enter();
> +	__current_set_polling();
> +	tick_nohz_idle_enter();
>  
> -		while (!need_resched()) {
> -			check_pgt_cache();
> -			rmb();
> -
> -			if (cpu_is_offline(smp_processor_id()))
> -				arch_cpu_idle_dead();
> -
> -			local_irq_disable();
> -			arch_cpu_idle_enter();
> -
> -			/*
> -			 * In poll mode we reenable interrupts and
> spin.
> -			 *
> -			 * Also if we detected in the wakeup from
> idle
> -			 * path that the tick broadcast device
> expired
> -			 * for us, we don't want to go deep idle as
> we
> -			 * know that the IPI is going to arrive right
> -			 * away
> -			 */
> -			if (cpu_idle_force_poll ||
> tick_check_broadcast_expired())
> -				cpu_idle_poll();
> -			else
> -				cpuidle_idle_call();
> +	while (!need_resched()) {
> +		check_pgt_cache();
> +		rmb();
>  
> -			arch_cpu_idle_exit();
> -		}
> +		if (cpu_is_offline(smp_processor_id()))
> +			arch_cpu_idle_dead();
> +
> +		local_irq_disable();
> +		arch_cpu_idle_enter();
>  
>  		/*
> -		 * Since we fell out of the loop above, we know
> -		 * TIF_NEED_RESCHED must be set, propagate it into
> -		 * PREEMPT_NEED_RESCHED.
> +		 * In poll mode we reenable interrupts and spin.
>  		 *
> -		 * This is required because for polling idle loops
> we will
> -		 * not have had an IPI to fold the state for us.
> +		 * Also if we detected in the wakeup from idle path
> that the
> +		 * tick broadcast device expired for us, we don't
> want to go
> +		 * deep idle as we know that the IPI is going to
> arrive right
> +		 * away
>  		 */
> -		preempt_set_need_resched();
> -		tick_nohz_idle_exit();
> -		__current_clr_polling();
> -		smp_mb__after_clear_bit();
> -		sched_ttwu_pending();
> -		schedule_preempt_disabled();
> +		if (cpu_idle_force_poll ||
> tick_check_broadcast_expired())
> +			cpu_idle_poll();
> +		else
> +			cpuidle_idle_call();
> +
> +		arch_cpu_idle_exit();
>  	}
> +
> +	/*
> +	 * Since we fell out of the loop above, we know
> TIF_NEED_RESCHED must
> +	 * be set, propagate it into PREEMPT_NEED_RESCHED.
> +	 *
> +	 * This is required because for polling idle loops we will
> not have had
> +	 * an IPI to fold the state for us.
> +	 */
> +	preempt_set_need_resched();
> +	tick_nohz_idle_exit();
> +	__current_clr_polling();
> +	smp_mb__after_clear_bit();
> +	sched_ttwu_pending();
> +	schedule_preempt_disabled();
> +}
> +
> +static void play_idle_timer(unsigned long foo)
> +{
> +	set_tsk_need_resched(current);
> +}
> +
> +void play_idle(unsigned long duration)
> +{
> +	DEFINE_TIMER(wakeup_timer, play_idle_timer, 0, 0);
> +
> +	/*
> +	 * Only FIFO tasks can disable the tick since they don't
> need the forced
> +	 * preemption.
> +	 */
> +	WARN_ON_ONCE(current->policy != SCHED_FIFO);
> +	WARN_ON_ONCE(current->nr_cpus_allowed != 1);
> +	WARN_ON_ONCE(!(current->flags & PF_NO_SETAFFINITY));
> +	WARN_ON_ONCE(!(current->flags & PF_KTHREAD));
> +	rcu_sleep_check();
> +
> +	init_timer_on_stack(&wakeup_timer);
> +	mod_timer_pinned(&wakeup_timer, jiffies + duration);
> +
> +	preempt_disable();
> +	current->flags |= PF_IDLE;
> +	do_idle();
> +	current->flags &= ~PF_IDLE;
> +	del_timer_sync(&wakeup_timer);
> +	preempt_fold_need_resched();
> +	preempt_enable();
>  }
> +EXPORT_SYMBOL_GPL(play_idle);
>  
> -void cpu_startup_entry(enum cpuhp_state state)
> +__noreturn void cpu_startup_entry(enum cpuhp_state state)
>  {
>  	/*
>  	 * This #ifdef needs to die, but it's too late in the cycle
> to @@ -261,5 +289,6 @@ void cpu_startup_entry(enum cpuhp_state
>  	boot_init_stack_canary();
>  #endif
>  	arch_cpu_idle_prepare();
> -	cpu_idle_loop();
> +	while (1)
> +		do_idle();
>  }
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -807,7 +807,6 @@ void tick_nohz_idle_enter(void)
>  
>  	local_irq_enable();
>  }
> -EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
>  
>  /**
>   * tick_nohz_irq_exit - update next tick event from interrupt exit
> @@ -934,7 +933,6 @@ void tick_nohz_idle_exit(void)
>  
>  	local_irq_enable();
>  }
> -EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
>  
>  static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
>  {

[Jacob Pan]
