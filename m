Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaI0Qrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:47:45 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44208 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaI0Qrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:47:43 -0400
Date: Sat, 27 Sep 2014 18:47:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: kan.liang@intel.com
Cc: a.p.zijlstra@chello.nl, eranian@google.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, acme@kernel.org,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140927164738.GA21729@lerouge>
References: <978920978-30191-1-git-send-email-kan.liang@intel.com>
 <978920978-30191-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <978920978-30191-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 07, 2001 at 09:29:31PM -0500, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> The callback is invoked when process is scheduled in or out.
> It provides mechanism for later patches to save/store the LBR
> stack. For the schedule in case, the callback is invoked at
> the same place that flush branch stack callback is invoked.
> So it also can replace the flush branch stack callback. To
> avoid unnecessary overhead, the callback is enabled only when
> there are events use the LBR stack.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |  7 +++++
>  arch/x86/kernel/cpu/perf_event.h |  2 ++
>  include/linux/perf_event.h       | 10 +++++++
>  kernel/events/core.c             | 59 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 78 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 0646d3b..4c572e8 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1877,6 +1877,12 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
>  	NULL,
>  };
>  
> +static void x86_pmu_sched_task(struct perf_event_context *ctx, bool sched_in)
> +{
> +	if (x86_pmu.sched_task)
> +		x86_pmu.sched_task(ctx, sched_in);
> +}
> +
>  static void x86_pmu_flush_branch_stack(void)
>  {
>  	if (x86_pmu.flush_branch_stack)
> @@ -1910,6 +1916,7 @@ static struct pmu pmu = {
>  
>  	.event_idx		= x86_pmu_event_idx,
>  	.flush_branch_stack	= x86_pmu_flush_branch_stack,
> +	.sched_task		= x86_pmu_sched_task,
>  };
>  
>  void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 86c675c..0617abb 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -467,6 +467,8 @@ struct x86_pmu {
>  
>  	void		(*check_microcode)(void);
>  	void		(*flush_branch_stack)(void);
> +	void		(*sched_task)(struct perf_event_context *ctx,
> +				      bool sched_in);
>  
>  	/*
>  	 * Intel Arch Perfmon v2+
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 893a0d0..be0e870 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -263,6 +263,14 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * context-switches callback for CPU PMU. Other PMUs shouldn't set
> +	 * this callback
> +	 */
> +	void (*sched_task)		(struct perf_event_context *ctx,
> +					bool sched_in);
> +
>  };
>  
>  /**
> @@ -562,6 +570,8 @@ extern void perf_event_delayed_put(struct task_struct *task);
>  extern void perf_event_print_debug(void);
>  extern void perf_pmu_disable(struct pmu *pmu);
>  extern void perf_pmu_enable(struct pmu *pmu);
> +extern void perf_sched_cb_disable(struct pmu *pmu);
> +extern void perf_sched_cb_enable(struct pmu *pmu);
>  extern int perf_event_task_disable(void);
>  extern int perf_event_task_enable(void);
>  extern int perf_event_refresh(struct perf_event *event, int refresh);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1212cc4..15d640e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -154,6 +154,7 @@ enum event_type_t {
>  struct static_key_deferred perf_sched_events __read_mostly;
>  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
>  static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
> +static DEFINE_PER_CPU(int, perf_sched_cb_usages);
>  
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
> @@ -2427,6 +2428,58 @@ unlock:
>  	}
>  }
>  
> +void perf_sched_cb_disable(struct pmu *pmu)
> +{
> +	this_cpu_dec(perf_sched_cb_usages);
> +}
> +
> +void perf_sched_cb_enable(struct pmu *pmu)
> +{
> +	this_cpu_inc(perf_sched_cb_usages);
> +}
> +
> +/*
> + * This function provides the context switch callback to the lower code
> + * layer. It is invoked ONLY when the context switch callback is enabled.
> + */
> +static void perf_pmu_sched_task(struct task_struct *prev,
> +				struct task_struct *next,
> +				bool sched_in)
> +{
> +	struct perf_cpu_context *cpuctx;
> +	struct pmu *pmu;
> +	unsigned long flags;
> +
> +	if (prev == next)
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +		if (pmu->sched_task) {
> +			cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +
> +			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +			perf_pmu_disable(pmu);
> +
> +			pmu->sched_task(cpuctx->task_ctx, sched_in);
> +
> +			perf_pmu_enable(pmu);
> +
> +			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +			/* only CPU PMU has context switch callback */
> +			break;

I wonder if it's worth to create such an arch callback and core corner case.
How about just scheduling out then in the events that have lbr, wouldn't we
have more simple code in the end?

Besides, BTS would benefit from that too. I can't seem to find where it is
flushed when a task context switches inside a same perf context. It seems
that it doesn't happen, BTS traces are flushed only on event stop (and overflow IRQ)
and events aren't stopped if a context switch happens in the same perf context.
Having Y task bts traces from task X event is probably not what we want.
