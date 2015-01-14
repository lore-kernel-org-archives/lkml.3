Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbbANOVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:21:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:18715 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbbANOVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:21:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="651005550"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mikey@neuling.org" <mikey@neuling.org>,
        "anton@samba.org" <anton@samba.org>
Subject: RE: [PATCH V8 03/14] perf, x86: use context switch callback to
 flush LBR stack
Thread-Topic: [PATCH V8 03/14] perf, x86: use context switch callback to
 flush LBR stack
Thread-Index: AQHQL/4oRduvHNGW5kWjzNwEw2WXUpy/qAzw
Date: Wed, 14 Jan 2015 14:16:08 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770169FC39@SHSMSX103.ccr.corp.intel.com>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
 <1415285671-16894-4-git-send-email-kan.liang@intel.com>
 <20150114132931.GO23965@worktop.programming.kicks-ass.net>
In-Reply-To: <20150114132931.GO23965@worktop.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> On Thu, Nov 06, 2014 at 09:54:20AM -0500, Kan Liang wrote:
> > --- a/kernel/events/core.c
> > @@ -2673,64 +2666,6 @@ static void
> perf_event_context_sched_in(struct
> > perf_event_context *ctx,  }
> >
> >  /*
> > - * When sampling the branck stack in system-wide, it may be necessary
> > - * to flush the stack on context switch. This happens when the branch
> > - * stack does not tag its entries with the pid of the current task.
> > - * Otherwise it becomes impossible to associate a branch entry with a
> > - * task. This ambiguity is more likely to appear when the branch
> > stack
> > - * supports priv level filtering and the user sets it to monitor only
> > - * at the user level (which could be a useful measurement in
> > system-wide
> > - * mode). In that case, the risk is high of having a branch stack
> > with
> > - * branch from multiple tasks. Flushing may mean dropping the
> > existing
> > - * entries or stashing them somewhere in the PMU specific code layer.
> > - *
> > - * This function provides the context switch callback to the lower
> > code
> > - * layer. It is invoked ONLY when there is at least one system-wide
> > context
> > - * with at least one active event using taken branch sampling.
> > - */
> > -static void perf_branch_stack_sched_in(struct task_struct *prev,
> > -				       struct task_struct *task)
> > -{
> > -	struct perf_cpu_context *cpuctx;
> > -	struct pmu *pmu;
> > -	unsigned long flags;
> > -
> > -	/* no need to flush branch stack if not changing task */
> > -	if (prev == task)
> > -		return;
> > -
> > -	local_irq_save(flags);
> > -
> > -	rcu_read_lock();
> > -
> > -	list_for_each_entry_rcu(pmu, &pmus, entry) {
> > -		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> > -
> > -		/*
> > -		 * check if the context has at least one
> > -		 * event using PERF_SAMPLE_BRANCH_STACK
> > -		 */
> > -		if (cpuctx->ctx.nr_branch_stack > 0
> > -		    && pmu->flush_branch_stack) {
> > -
> > -			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> > -
> > -			perf_pmu_disable(pmu);
> > -
> > -			pmu->flush_branch_stack();
> > -
> > -			perf_pmu_enable(pmu);
> > -
> > -			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> > -		}
> > -	}
> > -
> > -	rcu_read_unlock();
> > -
> > -	local_irq_restore(flags);
> > -}
> 
> So while this patch removes almost everything flush_branch_stack related
> it leaves a few rudiments and a broken architecture.

Thanks for providing this patch to fix the issue.

Kan
> 
> ---
> Subject: perf,powerpc: Fix up flush_branch_stack users
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Jan 14 14:15:39 CET 2015
> 
> The recent LBR rework for x86 left a stray flush_branch_stack user in the
> PowerPC code, fix that up.
> 
> Cc: Michael Neuling <mikey@neuling.org>
> Cc: Anton Blanchard <anton@samba.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-
> q4y7je45jtnbp7nhu93by9gs@git.kernel.org
> ---
>  arch/powerpc/perf/core-book3s.c |   13 +++++++++----
>  include/linux/perf_event.h      |    5 -----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -124,7 +124,7 @@ static unsigned long ebb_switch_in(bool
> 
>  static inline void power_pmu_bhrb_enable(struct perf_event *event) {}
> static inline void power_pmu_bhrb_disable(struct perf_event *event) {} -
> static void power_pmu_flush_branch_stack(void) {}
> +static void power_pmu_sched_task(struct perf_event_context *ctx, bool
> +sched_in) {}
>  static inline void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
> {}  static void pmao_restore_workaround(bool ebb) { }  #endif /*
> CONFIG_PPC32 */ @@ -350,6 +350,7 @@ static void
> power_pmu_bhrb_enable(struct
>  		cpuhw->bhrb_context = event->ctx;
>  	}
>  	cpuhw->bhrb_users++;
> +	perf_sched_cb_inc(event->ctx->pmu);
>  }
> 
>  static void power_pmu_bhrb_disable(struct perf_event *event) @@ -
> 361,6 +362,7 @@ static void power_pmu_bhrb_disable(struc
> 
>  	cpuhw->bhrb_users--;
>  	WARN_ON_ONCE(cpuhw->bhrb_users < 0);
> +	perf_sched_cb_dec(event->ctx->pmu);
> 
>  	if (!cpuhw->disabled && !cpuhw->bhrb_users) {
>  		/* BHRB cannot be turned off when other @@ -375,9
> +377,12 @@ static void power_pmu_bhrb_disable(struc
>  /* Called from ctxsw to prevent one process's branch entries to
>   * mingle with the other process's entries during context switch.
>   */
> -static void power_pmu_flush_branch_stack(void)
> +static void power_pmu_sched_task(struct perf_event_context *ctx, bool
> +sched_in)
>  {
> -	if (ppmu->bhrb_nr)
> +	if (!ppmu->bhrb_nr)
> +		return;
> +
> +	if (sched_in)
>  		power_pmu_bhrb_reset();
>  }
>  /* Calculate the to address for a branch */ @@ -1901,7 +1906,7 @@ static
> struct pmu power_pmu = {
>  	.cancel_txn	= power_pmu_cancel_txn,
>  	.commit_txn	= power_pmu_commit_txn,
>  	.event_idx	= power_pmu_event_idx,
> -	.flush_branch_stack = power_pmu_flush_branch_stack,
> +	.sched_task	= power_pmu_sched_task,
>  };
> 
>  /*
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -255,11 +255,6 @@ struct pmu {
>  	int (*event_idx)		(struct perf_event *event);
> /*optional */
> 
>  	/*
> -	 * flush branch stack on context-switches (needed in cpu-wide
> mode)
> -	 */
> -	void (*flush_branch_stack)	(void);
> -
> -	/*
>  	 * context-switches callback
>  	 */
>  	void (*sched_task)		(struct perf_event_context *ctx,
