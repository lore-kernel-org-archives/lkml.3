Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaE0TNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:13:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:20557 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752047AbaE0TNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:13:43 -0400
Date: Tue, 27 May 2014 15:13:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Don't account for cpu idle time with irqsoff
 tracers
Message-ID: <20140527151341.4411f910@gandalf.local.home>
In-Reply-To: <1400527847-28359-1-git-send-email-sboyd@codeaurora.org>
References: <1400527847-28359-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey! I was able to get to this.

On Mon, 19 May 2014 12:30:47 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> The idle loop calls stop_critical_timings() in an attempt to stop
> the irqsoff tracer from tracing a cpu's idle time. Unfortunately,
> stop_critical_timings() doesn't do much besides stop the tracer
> until the point that another irqsoff event happens. This typically
> happens right after in rcu_idle_enter() or later on in the cpuidle
> driver when we take a spinlock to notify the clockevent framework
> about timers that lose state during deep idle (FEAT_C3_STOP).
> This leads to worthless irqsoff traces that show a large amount
> of time spent in idle:
> 
>  # tracer: irqsoff
>  #
>  # irqsoff latency trace v1.1.5 on 3.15.0-rc4-00002-geffda86cfdaa-dirty
>  # --------------------------------------------------------------------
>  # latency: 3997988 us, #88/88, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
>  #    -----------------
>  #    | task: swapper/1-0 (uid:0 nice:0 policy:0 rt_prio:0)
>  #    -----------------
>  #  => started at: rcu_idle_enter
>  #  => ended at:   cpuidle_enter_state
>  #
>  #
>  #                  _------=> CPU#
>  #                 / _-----=> irqs-off
>  #                | / _----=> need-resched
>  #                || / _---=> hardirq/softirq
>  #                ||| / _--=> preempt-depth
>  #                |||| /     delay
>  #  cmd     pid   ||||| time  |   caller
>  #     \   /      |||||  \    |   /
>    <idle>-0       1d..1    2us+: trace_hardirqs_off <-rcu_idle_enter
>    <idle>-0       1d..2    7us+: rcu_eqs_enter_common.isra.48 <-rcu_idle_enter
>    <idle>-0       1d..2   12us+: cpuidle_enabled <-cpu_startup_entry
>    <idle>-0       1d..2   17us+: cpuidle_select <-cpu_startup_entry
>    <idle>-0       1d..2   21us+: menu_select <-cpuidle_select
>    <idle>-0       1d..2   26us+: pm_qos_request <-menu_select
>    <idle>-0       1d..2   30us+: tick_nohz_get_sleep_length <-menu_select
>    <idle>-0       1d..2   34us+: ns_to_timespec <-menu_select
>    <idle>-0       1d..2   39us+: nr_iowait_cpu <-menu_select
>    <idle>-0       1d..2   46us+: this_cpu_load <-menu_select
>    <idle>-0       1d..2   50us+: nr_iowait_cpu <-menu_select
>    <idle>-0       1d..2   55us+: clockevents_notify <-cpu_startup_entry
>    <idle>-0       1d..2   59us+: _raw_spin_lock_irqsave <-clockevents_notify
>    <idle>-0       1d..2   64us+: preempt_count_add <-_raw_spin_lock_irqsave
>    <idle>-0       1d..3   69us+: do_raw_spin_lock <-_raw_spin_lock_irqsave
>    <idle>-0       1d..3   74us+: tick_broadcast_oneshot_control <-clockevents_notify
>    <idle>-0       1d..3   78us+: _raw_spin_lock_irqsave <-tick_broadcast_oneshot_control
>    <idle>-0       1d..3   83us+: preempt_count_add <-_raw_spin_lock_irqsave
>    <idle>-0       1d..4   88us+: do_raw_spin_lock <-_raw_spin_lock_irqsave
>    <idle>-0       1d..4   93us+: clockevents_set_mode <-tick_broadcast_oneshot_control
>    <idle>-0       1d..4   97us+: arch_timer_set_mode_virt <-clockevents_set_mode
>    <idle>-0       1d..4  102us+: broadcast_needs_cpu <-tick_broadcast_oneshot_control
>    <idle>-0       1d..4  106us+: _raw_spin_unlock_irqrestore <-tick_broadcast_oneshot_control
>    <idle>-0       1d..4  110us+: do_raw_spin_unlock <-_raw_spin_unlock_irqrestore
>    <idle>-0       1d..4  115us+: preempt_count_sub <-_raw_spin_unlock_irqrestore
>    <idle>-0       1d..3  120us+: _raw_spin_unlock_irqrestore <-clockevents_notify
>    <idle>-0       1d..3  124us+: do_raw_spin_unlock <-_raw_spin_unlock_irqrestore
>    <idle>-0       1d..3  129us+: preempt_count_sub <-_raw_spin_unlock_irqrestore
>    <idle>-0       1d..2  133us+: cpuidle_enter <-cpu_startup_entry
>    <idle>-0       1d..2  137us+: cpuidle_enter_state <-cpuidle_enter
>    <idle>-0       1d..2  141us+: ktime_get <-cpuidle_enter_state
>    <idle>-0       1d..2  148us+: arch_counter_read <-ktime_get
>    <idle>-0       1d..2  153us+: cpu_enter_idle <-cpuidle_enter_state
>    <idle>-0       1d..2  157us+: cpu_pm_enter <-cpu_enter_idle
>    <idle>-0       1d..2  161us+: _raw_read_lock <-cpu_pm_enter
>    <idle>-0       1d..2  165us+: preempt_count_add <-_raw_read_lock
>    <idle>-0       1d..3  170us+: do_raw_read_lock <-_raw_read_lock
>    <idle>-0       1d..3  175us+: cpu_pm_notify <-cpu_pm_enter
>    <idle>-0       1d..3  179us+: __raw_notifier_call_chain <-cpu_pm_notify
>    <idle>-0       1d..3  183us+: notifier_call_chain <-__raw_notifier_call_chain
>    <idle>-0       1d..3  187us+: gic_notifier <-notifier_call_chain
>    <idle>-0       1d..3  192us+: arch_timer_cpu_pm_notify <-notifier_call_chain
>    <idle>-0       1d..3  197us+: vfp_cpu_pm_notifier <-notifier_call_chain
>    <idle>-0       1d..3  201us+: dbg_cpu_pm_notify <-notifier_call_chain
>    <idle>-0       1d..3  206us+: _raw_read_unlock <-cpu_pm_enter
>    <idle>-0       1d..3  210us+: do_raw_read_unlock <-_raw_read_unlock
>    <idle>-0       1d..3  214us!: preempt_count_sub <-_raw_read_unlock
>    <idle>-0       1d..2 3997820us+: cpu_pm_exit <-cpu_enter_idle
>    <idle>-0       1d..2 3997824us+: _raw_read_lock <-cpu_pm_exit
>    <idle>-0       1d..2 3997828us+: preempt_count_add <-_raw_read_lock
>    <idle>-0       1d..3 3997833us+: do_raw_read_lock <-_raw_read_lock
>    <idle>-0       1d..3 3997838us+: cpu_pm_notify <-cpu_pm_exit
>    <idle>-0       1d..3 3997842us+: __raw_notifier_call_chain <-cpu_pm_notify
>    <idle>-0       1d..3 3997846us+: notifier_call_chain <-__raw_notifier_call_chain
>    <idle>-0       1d..3 3997850us+: gic_notifier <-notifier_call_chain
>    <idle>-0       1d..3 3997856us+: arch_timer_cpu_pm_notify <-notifier_call_chain
>    <idle>-0       1d..3 3997860us+: vfp_cpu_pm_notifier <-notifier_call_chain
>    <idle>-0       1d..3 3997865us+: vfp_enable <-vfp_cpu_pm_notifier
>    <idle>-0       1d..3 3997869us+: dbg_cpu_pm_notify <-notifier_call_chain
>    <idle>-0       1d..3 3997873us+: reset_ctrl_regs <-dbg_cpu_pm_notify
>    <idle>-0       1d..3 3997877us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997882us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997886us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997890us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997894us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997898us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997902us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997906us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997910us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997915us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997919us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997923us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997927us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997931us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997936us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997940us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997944us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997948us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997952us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997956us+: write_wb_reg <-reset_ctrl_regs
>    <idle>-0       1d..3 3997960us+: _raw_read_unlock <-cpu_pm_exit
>    <idle>-0       1d..3 3997965us+: do_raw_read_unlock <-_raw_read_unlock
>    <idle>-0       1d..3 3997969us+: preempt_count_sub <-_raw_read_unlock
>    <idle>-0       1d..2 3997973us+: ktime_get <-cpuidle_enter_state
>    <idle>-0       1d..2 3997980us+: arch_counter_read <-ktime_get
>    <idle>-0       1d..1 3997985us+: trace_hardirqs_on <-cpuidle_enter_state
>    <idle>-0       1d..1 3997994us+: time_hardirqs_on <-cpuidle_enter_state
>    <idle>-0       1d..1 3998053us : <stack trace>
>   => time_hardirqs_on
>   => trace_hardirqs_on_caller
>   => trace_hardirqs_on
>   => cpuidle_enter_state
>   => cpuidle_enter
>   => cpu_startup_entry
>   => secondary_start_kernel
> 
> Let's make stop_critical_timings() actually stop the tracer until
> start_critical_timings() is called. This way we don't have to
> worry about adding more stop_critical_timings() calls deep down
> in cpuidle drivers or later on in the idle loop.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
>  kernel/trace/trace_irqsoff.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 8ff02cbb892f..ea5f5d484150 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -367,6 +367,8 @@ out:
>  	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
>  }
>  
> +static DEFINE_PER_CPU(bool, timings_stopped);
> +
>  static inline void
>  start_critical_timing(unsigned long ip, unsigned long parent_ip)
>  {
> @@ -375,11 +377,12 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
>  	struct trace_array_cpu *data;
>  	unsigned long flags;
>  
> -	if (!tracer_enabled || !tracing_is_enabled())
> -		return;
> -
>  	cpu = raw_smp_processor_id();
>  
> +	if (!tracer_enabled || !tracing_is_enabled() ||
> +			per_cpu(timings_stopped, cpu))
> +		return;

Micro optimization. As this gets called even when not tracing, the
tracer_enabled is what determines if tracing is enabled or not. Can you
keep the first condition the same, and just add your check to the one
below:

if (per_cpu(timings_stop, cpu) || per_cpu(tracing_cpu, cpu))
	return;

> +
>  	if (per_cpu(tracing_cpu, cpu))
>  		return;
>  
> @@ -418,7 +421,8 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
>  	else
>  		return;
>  
> -	if (!tracer_enabled || !tracing_is_enabled())
> +	if (!tracer_enabled || !tracing_is_enabled() ||
> +			per_cpu(timings_stopped, cpu))
>  		return;
>  
>  	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> @@ -439,15 +443,19 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
>  /* start and stop critical timings used to for stoppage (in idle) */
>  void start_critical_timings(void)
>  {
> -	if (preempt_trace() || irq_trace())
> +	if (preempt_trace() || irq_trace()) {
> +		per_cpu(timings_stopped, raw_smp_processor_id()) = false;
>  		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(start_critical_timings);
>  
>  void stop_critical_timings(void)
>  {
> -	if (preempt_trace() || irq_trace())
> +	if (preempt_trace() || irq_trace()) {
>  		stop_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
> +		per_cpu(timings_stopped, raw_smp_processor_id()) = true;
> +	}

Hmm, I think this is racy. If we enter idle with tracing enabled it
will set timings_stopped to true for this cpu. But if we disable
tracing while in idle, it will not turn it off.

Well, this isn't really true, because once we enable tracing the
trace_type that is used to check preempt_trace() and irq_trace() stays
set even when tracing isn't enabled. But this may change soon and that
can make this a problem.

I don't see any reason the setting of timings_stopped can't be set
unconditionally in these functions.

-- Steve


>  }
>  EXPORT_SYMBOL_GPL(stop_critical_timings);
>  

