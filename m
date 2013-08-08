Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab3HHGS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:18:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:50233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab3HHGSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:18:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,837,1367996400"; 
   d="scan'208";a="359428598"
Message-ID: <5203382E.10102@intel.com>
Date: Thu, 08 Aug 2013 14:18:22 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com> <20130704124536.GK23916@twins.programming.kicks-ass.net> <51D65B58.1050201@intel.com> <20130705081516.GP18898@dyad.programming.kicks-ass.net> <51D68915.7060901@intel.com> <20130705123158.GR23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130705123158.GR23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 08:31 PM, Peter Zijlstra wrote:
> On Fri, Jul 05, 2013 at 04:51:33PM +0800, Yan, Zheng wrote:
>>>> the LBR is shared resource, can be used by multiple events at the same time.
>>>
>>> Yeah so? There's tons of shared resources in the PMU already.
>>
>> we should restore the LBR callstack only when task schedule in. restoring the LBR
>> callstack at any other time will make the LBR callstack and actual callchain of program
>> mismatch. this property make the LBR different from counters.
> 
> But it doesn't change the fact that the LBR is controlled through
> events.
> 
>> yes，on both sides we'd have the LBR running. but there is no need to save/restore
>> the LBR stack in this case. we should save the LBR stack only when task schedule out,
>> and restore the LBR stack when task schedule in. So I think it's more natural to
>> manage the LBR state when switching perf task context.
> 
> And I never said we shouldn't, I just said we should push it down into the PMU
> driver and not have a hook out into the generic code. The generic code should
> ideally not know anything about LBR, it should only care about events.
> 
> Something like the below... although I'm still not entirely happy with that
> either.

Sorry for the delay.

How about the patch below. It introduces a pmu sched_ctx() callback and uses the callback
to flush LBR stack. The sched_ctx() callback can also be used to save/restore the lBR stack.

Thanks.
Yan, Zheng

---
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8355c84..e5cb20d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1846,10 +1846,10 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
-static void x86_pmu_flush_branch_stack(void)
+static void x86_pmu_sched_ctx(struct perf_event_context *ctx, bool sched_in)
 {
-	if (x86_pmu.flush_branch_stack)
-		x86_pmu.flush_branch_stack();
+	if (x86_pmu.sched_ctx)
+		x86_pmu.sched_ctx(ctx, sched_in);
 }
 
 void perf_check_microcode(void)
@@ -1878,7 +1878,7 @@ static struct pmu pmu = {
 	.commit_txn		= x86_pmu_commit_txn,
 
 	.event_idx		= x86_pmu_event_idx,
-	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.sched_ctx		= x86_pmu_sched_ctx,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 97e557b..1320376 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -150,6 +150,7 @@ struct cpu_hw_events {
 	 * Intel LBR bits
 	 */
 	int				lbr_users;
+	int				lbr_sys_users;
 	void				*lbr_context;
 	struct perf_branch_stack	lbr_stack;
 	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
@@ -411,7 +412,8 @@ struct x86_pmu {
 	void		(*cpu_dead)(int cpu);
 
 	void		(*check_microcode)(void);
-	void		(*flush_branch_stack)(void);
+	void		(*sched_ctx)(struct perf_event_context *ctx,
+				     bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
@@ -663,6 +665,8 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_ds_init(void);
 
+void intel_pmu_lbr_sched_ctx(struct perf_event_context *ctx, bool sched_in);
+
 void intel_pmu_lbr_reset(void);
 
 void intel_pmu_lbr_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fbc9210..c8f0318 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1849,16 +1849,15 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
-static void intel_pmu_flush_branch_stack(void)
+static void intel_pmu_sched_ctx(struct perf_event_context *ctx, bool sched_in)
 {
 	/*
 	 * Intel LBR does not tag entries with the
 	 * PID of the current task, then we need to
 	 * flush it on ctxsw
-	 * For now, we simply reset it
 	 */
 	if (x86_pmu.lbr_nr)
-		intel_pmu_lbr_reset();
+		intel_pmu_lbr_sched_ctx(ctx, sched_in);
 }
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
@@ -1912,7 +1911,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
-	.flush_branch_stack	= intel_pmu_flush_branch_stack,
+	.sched_ctx		= intel_pmu_sched_ctx,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d5be06a..99b00a8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -181,6 +181,12 @@ void intel_pmu_lbr_reset(void)
 		intel_pmu_lbr_reset_64();
 }
 
+void intel_pmu_lbr_sched_ctx(struct perf_event_context *ctx, bool sched_in)
+{
+	if (sched_in)
+		intel_pmu_lbr_reset();
+}
+
 void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -199,6 +205,11 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
 	cpuc->lbr_users++;
+	if (!(event->attach_state & PERF_ATTACH_TASK)) {
+		cpuc->lbr_sys_users++;
+		if (cpuc->lbr_sys_users == 1)
+			event->ctx->pmu->flags |= PERF_PF_CTXS;
+	}
 }
 
 void intel_pmu_lbr_disable(struct perf_event *event)
@@ -209,6 +220,12 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 		return;
 
 	cpuc->lbr_users--;
+	if (!(event->attach_state & PERF_ATTACH_TASK)) {
+		cpuc->lbr_sys_users--;
+		if (cpuc->lbr_sys_users == 0)
+			event->ctx->pmu->flags &= ~PERF_PF_CTXS;
+	}
+
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
 	if (cpuc->enabled && !cpuc->lbr_users) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..afdfc5a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -189,6 +189,12 @@ struct perf_event;
  */
 #define PERF_EVENT_TXN 0x1
 
+/*
+ * pmu::flags
+ */
+#define PERF_PF_CTXS	0x01 /* call pmu->sched_ctx on context-switches */
+
+
 /**
  * struct pmu - generic performance monitoring unit
  */
@@ -199,11 +205,12 @@ struct pmu {
 	const struct attribute_group	**attr_groups;
 	const char			*name;
 	int				type;
+	unsigned int			flags;
+	int				task_ctx_nr;
+	int				hrtimer_interval_ms;
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
-	int				task_ctx_nr;
-	int				hrtimer_interval_ms;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
@@ -271,9 +278,10 @@ struct pmu {
 	int (*event_idx)		(struct perf_event *event); /*optional */
 
 	/*
-	 * flush branch stack on context-switches (needed in cpu-wide mode)
+	 * PMU callback for context-switches. optional
 	 */
-	void (*flush_branch_stack)	(void);
+	void (*sched_ctx)		(struct perf_event_context *ctx,
+					 bool sched_in); /*optional */
 };
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1274114..8678e73 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -140,7 +140,6 @@ enum event_type_t {
  */
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
-static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -2130,6 +2129,10 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		return;
 
 	perf_pmu_disable(ctx->pmu);
+
+	if (ctx->pmu->flags & PERF_PF_CTXS)
+		ctx->pmu->sched_ctx(ctx, false);
+
 	if ((is_active & EVENT_PINNED) && (event_type & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
@@ -2269,6 +2272,12 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock(&ctx->lock);
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
+			if (ctx->pmu->flags & PERF_PF_CTXS) {
+				perf_pmu_disable(ctx->pmu);
+				ctx->pmu->sched_ctx(ctx, false);
+				ctx->pmu->sched_ctx(next_ctx, true);
+				perf_pmu_enable(ctx->pmu);
+			}
 			/*
 			 * XXX do we need a memory barrier of sorts
 			 * wrt to rcu_dereference() of perf_event_ctxp
@@ -2467,6 +2476,9 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
 
+	if (ctx->pmu->flags & PERF_PF_CTXS)
+		ctx->pmu->sched_ctx(ctx, true);
+
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
 
@@ -2478,66 +2490,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 }
 
 /*
- * When sampling the branck stack in system-wide, it may be necessary
- * to flush the stack on context switch. This happens when the branch
- * stack does not tag its entries with the pid of the current task.
- * Otherwise it becomes impossible to associate a branch entry with a
- * task. This ambiguity is more likely to appear when the branch stack
- * supports priv level filtering and the user sets it to monitor only
- * at the user level (which could be a useful measurement in system-wide
- * mode). In that case, the risk is high of having a branch stack with
- * branch from multiple tasks. Flushing may mean dropping the existing
- * entries or stashing them somewhere in the PMU specific code layer.
- *
- * This function provides the context switch callback to the lower code
- * layer. It is invoked ONLY when there is at least one system-wide context
- * with at least one active event using taken branch sampling.
- */
-static void perf_branch_stack_sched_in(struct task_struct *prev,
-				       struct task_struct *task)
-{
-	struct perf_cpu_context *cpuctx;
-	struct pmu *pmu;
-	unsigned long flags;
-
-	/* no need to flush branch stack if not changing task */
-	if (prev == task)
-		return;
-
-	local_irq_save(flags);
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-
-		/*
-		 * check if the context has at least one
-		 * event using PERF_SAMPLE_BRANCH_STACK
-		 */
-		if (cpuctx->ctx.nr_branch_stack > 0
-		    && pmu->flush_branch_stack) {
-
-			pmu = cpuctx->ctx.pmu;
-
-			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-
-			perf_pmu_disable(pmu);
-
-			pmu->flush_branch_stack();
-
-			perf_pmu_enable(pmu);
-
-			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-		}
-	}
-
-	rcu_read_unlock();
-
-	local_irq_restore(flags);
-}
-
-/*
  * Called from scheduler to add the events of the current task
  * with interrupts disabled.
  *
@@ -2568,10 +2520,6 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
-
-	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
-		perf_branch_stack_sched_in(prev, task);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -3148,14 +3096,8 @@ static void free_event(struct perf_event *event)
 			static_key_slow_dec_deferred(&perf_sched_events);
 		}
 
-		if (has_branch_stack(event)) {
+		if (has_branch_stack(event))
 			static_key_slow_dec_deferred(&perf_sched_events);
-			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK)) {
-				atomic_dec(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-			}
-		}
 	}
 
 	if (event->rb) {
@@ -6574,12 +6516,8 @@ done:
 				return ERR_PTR(err);
 			}
 		}
-		if (has_branch_stack(event)) {
+		if (has_branch_stack(event))
 			static_key_slow_inc(&perf_sched_events.key);
-			if (!(event->attach_state & PERF_ATTACH_TASK))
-				atomic_inc(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-		}
 	}
 
 	return event;

> 
> Completely untested, never even seen compiler.
> 
> ---
>  arch/x86/kernel/cpu/perf_event.c           |  5 ++
>  arch/x86/kernel/cpu/perf_event.h           |  8 ++-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 24 ++++++--
>  include/linux/perf_event.h                 | 11 +++-
>  kernel/events/core.c                       | 92 +++---------------------------
>  5 files changed, 47 insertions(+), 93 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 9e581c5..6516ce0 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -519,6 +519,11 @@ static void x86_pmu_disable(struct pmu *pmu)
>  	if (!cpuc->enabled)
>  		return;
>  
> +	if (cpuc->current != current) {
> +		cpuc->current = current;
> +		cpuc->ctxs_seq++;
> +	}
> +
>  	cpuc->n_added = 0;
>  	cpuc->enabled = 0;
>  	barrier();
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 97e557b..e1ee365 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -141,6 +141,12 @@ struct cpu_hw_events {
>  	int			is_fake;
>  
>  	/*
> +	 * Context switch tracking
> +	 */
> +	void			*current;
> +	u64			ctxs_seq;
> +
> +	/*
>  	 * Intel DebugStore bits
>  	 */
>  	struct debug_store	*ds;
> @@ -150,11 +156,11 @@ struct cpu_hw_events {
>  	 * Intel LBR bits
>  	 */
>  	int				lbr_users;
> -	void				*lbr_context;
>  	struct perf_branch_stack	lbr_stack;
>  	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
>  	struct er_account		*lbr_sel;
>  	u64				br_sel;
> +	u64				lbr_flush_seq;
>  
>  	/*
>  	 * Intel host/guest exclude bits
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index d5be06a..aa34fa3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -189,15 +189,20 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>  		return;
>  
>  	/*
> -	 * Reset the LBR stack if we changed task context to
> -	 * avoid data leaks.
> +	 * If we're a task event and observe a context switch; flush the LBR
> +	 * since we don't want to leak LBR entries from the previous task into
> +	 * this one.
>  	 */
> -	if (event->ctx->task && cpuc->lbr_context != event->ctx) {
> +	if (event->ctx->task && cpuc->ctxs_seq != cpuc->lbr_flush_seq) {
>  		intel_pmu_lbr_reset();
> -		cpuc->lbr_context = event->ctx;
> +		cpuc->lbr_flush_seq = cpuc->ctxs_seq;
>  	}
> +
>  	cpuc->br_sel = event->hw.branch_reg.reg;
>  
> +	if (!cpuc->lbr_users)
> +		event->ctx->pmu->flags |= PERF_PF_CTXS;
> +
>  	cpuc->lbr_users++;
>  }
>  
> @@ -209,6 +214,9 @@ void intel_pmu_lbr_disable(struct perf_event *event)
>  		return;
>  
>  	cpuc->lbr_users--;
> +	if (!cpuc->lbr_users)
> +		event->ctx->pmu->flags &= ~PERF_PF_CTXS;
> +
>  	WARN_ON_ONCE(cpuc->lbr_users < 0);
>  
>  	if (cpuc->enabled && !cpuc->lbr_users) {
> @@ -222,8 +230,14 @@ void intel_pmu_lbr_enable_all(void)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  
> -	if (cpuc->lbr_users)
> +	if (cpuc->lbr_users) {
> +		if (cpuc->lbr_flush_seq != cpuc->ctxs_seq) {
> +			intel_pmu_lbr_reset();
> +			cpuc->lbr_flush_seq = cpuc->ctxs_seq;
> +		}
> +
>  		__intel_pmu_lbr_enable();
> +	}
>  }
>  
>  void intel_pmu_lbr_disable_all(void)
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8873f82..837f6e3 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -189,6 +189,11 @@ struct perf_event;
>   */
>  #define PERF_EVENT_TXN 0x1
>  
> +/*
> + * pmu::flags
> + */
> +#define PERF_PF_CTXS	0x01 /* require pmu_disable/enable on context_sched_in */
> +
>  /**
>   * struct pmu - generic performance monitoring unit
>   */
> @@ -200,10 +205,11 @@ struct pmu {
>  	const char			*name;
>  	int				type;
>  
> -	int * __percpu			pmu_disable_count;
> -	struct perf_cpu_context * __percpu pmu_cpu_context;
> +	unsigned int			flags;
>  	int				task_ctx_nr;
>  	int				hrtimer_interval_ms;
> +	int * __percpu			pmu_disable_count;
> +	struct perf_cpu_context * __percpu pmu_cpu_context;
>  
>  	/*
>  	 * Fully disable/enable this PMU, can be used to protect from the PMI
> @@ -492,7 +498,6 @@ struct perf_event_context {
>  	u64				generation;
>  	int				pin_count;
>  	int				nr_cgroups;	 /* cgroup evts */
> -	int				nr_branch_stack; /* branch_stack evt */
>  	struct rcu_head			rcu_head;
>  };
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1db3af9..d49b4ea 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -140,7 +140,6 @@ enum event_type_t {
>   */
>  struct static_key_deferred perf_sched_events __read_mostly;
>  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
> -static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
>  
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
> @@ -1114,9 +1113,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
>  	if (is_cgroup_event(event))
>  		ctx->nr_cgroups++;
>  
> -	if (has_branch_stack(event))
> -		ctx->nr_branch_stack++;
> -
>  	list_add_rcu(&event->event_entry, &ctx->event_list);
>  	if (!ctx->nr_events)
>  		perf_pmu_rotate_start(ctx->pmu);
> @@ -1271,9 +1267,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
>  			cpuctx->cgrp = NULL;
>  	}
>  
> -	if (has_branch_stack(event))
> -		ctx->nr_branch_stack--;
> -
>  	ctx->nr_events--;
>  	if (event->attr.inherit_stat)
>  		ctx->nr_stat--;
> @@ -2428,8 +2421,13 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
>  	struct perf_cpu_context *cpuctx;
>  
>  	cpuctx = __get_cpu_context(ctx);
> -	if (cpuctx->task_ctx == ctx)
> +	if (cpuctx->task_ctx == ctx) {
> +		if (ctx->pmu->flags & PERF_PF_CTXS) {
> +			perf_pmu_disable(ctx->pmu);
> +			perf_pmu_enable(ctx->pmu);
> +		}
>  		return;
> +	}
>  
>  	perf_ctx_lock(cpuctx, ctx);
>  	perf_pmu_disable(ctx->pmu);
> @@ -2456,66 +2454,6 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
>  }
>  
>  /*
> - * When sampling the branck stack in system-wide, it may be necessary
> - * to flush the stack on context switch. This happens when the branch
> - * stack does not tag its entries with the pid of the current task.
> - * Otherwise it becomes impossible to associate a branch entry with a
> - * task. This ambiguity is more likely to appear when the branch stack
> - * supports priv level filtering and the user sets it to monitor only
> - * at the user level (which could be a useful measurement in system-wide
> - * mode). In that case, the risk is high of having a branch stack with
> - * branch from multiple tasks. Flushing may mean dropping the existing
> - * entries or stashing them somewhere in the PMU specific code layer.
> - *
> - * This function provides the context switch callback to the lower code
> - * layer. It is invoked ONLY when there is at least one system-wide context
> - * with at least one active event using taken branch sampling.
> - */
> -static void perf_branch_stack_sched_in(struct task_struct *prev,
> -				       struct task_struct *task)
> -{
> -	struct perf_cpu_context *cpuctx;
> -	struct pmu *pmu;
> -	unsigned long flags;
> -
> -	/* no need to flush branch stack if not changing task */
> -	if (prev == task)
> -		return;
> -
> -	local_irq_save(flags);
> -
> -	rcu_read_lock();
> -
> -	list_for_each_entry_rcu(pmu, &pmus, entry) {
> -		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> -
> -		/*
> -		 * check if the context has at least one
> -		 * event using PERF_SAMPLE_BRANCH_STACK
> -		 */
> -		if (cpuctx->ctx.nr_branch_stack > 0
> -		    && pmu->flush_branch_stack) {
> -
> -			pmu = cpuctx->ctx.pmu;
> -
> -			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> -
> -			perf_pmu_disable(pmu);
> -
> -			pmu->flush_branch_stack();
> -
> -			perf_pmu_enable(pmu);
> -
> -			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> -		}
> -	}
> -
> -	rcu_read_unlock();
> -
> -	local_irq_restore(flags);
> -}
> -
> -/*
>   * Called from scheduler to add the events of the current task
>   * with interrupts disabled.
>   *
> @@ -2546,10 +2484,6 @@ void __perf_event_task_sched_in(struct task_struct *prev,
>  	 */
>  	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
>  		perf_cgroup_sched_in(prev, task);
> -
> -	/* check for system-wide branch_stack events */
> -	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
> -		perf_branch_stack_sched_in(prev, task);
>  }
>  
>  static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
> @@ -3126,14 +3060,8 @@ static void free_event(struct perf_event *event)
>  			static_key_slow_dec_deferred(&perf_sched_events);
>  		}
>  
> -		if (has_branch_stack(event)) {
> +		if (has_branch_stack(event))
>  			static_key_slow_dec_deferred(&perf_sched_events);
> -			/* is system-wide event */
> -			if (!(event->attach_state & PERF_ATTACH_TASK)) {
> -				atomic_dec(&per_cpu(perf_branch_stack_events,
> -						    event->cpu));
> -			}
> -		}
>  	}
>  
>  	if (event->rb) {
> @@ -6554,12 +6482,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  				return ERR_PTR(err);
>  			}
>  		}
> -		if (has_branch_stack(event)) {
> +		if (has_branch_stack(event))
>  			static_key_slow_inc(&perf_sched_events.key);
> -			if (!(event->attach_state & PERF_ATTACH_TASK))
> -				atomic_inc(&per_cpu(perf_branch_stack_events,
> -						    event->cpu));
> -		}
>  	}
>  
>  	return event;
> 

