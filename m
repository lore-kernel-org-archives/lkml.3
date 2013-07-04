Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab3GDMqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:46:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab3GDMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:41 -0400
Date: Thu, 4 Jul 2013 14:45:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
Message-ID: <20130704124536.GK23916@twins.programming.kicks-ass.net>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:

> @@ -2488,25 +2508,31 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
>  
>  	list_for_each_entry_rcu(pmu, &pmus, entry) {
>  		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +		task_ctx = cpuctx->task_ctx;
>  
>  		/*
> -		 * check if the context has at least one
> -		 * event using PERF_SAMPLE_BRANCH_STACK
> +		 * force flush the branch stack if there are cpu-wide events
> +		 * using PERF_SAMPLE_BRANCH_STACK
> +		 *
> +		 * save/restore the branch stack if the task context has
> +		 * at least one event using PERF_SAMPLE_BRANCH_STACK
>  		 */
> -		if (cpuctx->ctx.nr_branch_stack > 0
> -		    && pmu->flush_branch_stack) {
> -
> +		bool force_flush = cpuctx->ctx.nr_branch_stack > 0;
> +		if (pmu->branch_stack_sched &&
> +		    (force_flush ||
> +		     (task_ctx && task_ctx->nr_branch_stack > 0))) {
>  			pmu = cpuctx->ctx.pmu;
>  
> -			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +			perf_ctx_lock(cpuctx, task_ctx);
>  
>  			perf_pmu_disable(pmu);
>  
> -			pmu->flush_branch_stack();
> +			pmu->branch_stack_sched(task_ctx,
> +						sched_in, force_flush);
>  
>  			perf_pmu_enable(pmu);
>  
> -			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +			perf_ctx_unlock(cpuctx, task_ctx);
>  		}
>  	}
>  

I never really like this; and yes I know I wrote part of that. Is there
any way we can get rid of this and to it 'properly' through the events
that get scheduled?

After all; the LBR usage is through the events, so scheduling the events
should also manage the LBR state.

What is missing for that to work?
