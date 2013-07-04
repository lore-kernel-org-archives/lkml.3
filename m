Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3GDMoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:44:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3GDMoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:44:13 -0400
Date: Thu, 4 Jul 2013 14:44:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
Message-ID: <20130704124408.GJ23916@twins.programming.kicks-ass.net>
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
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> When the LBR call stack is enabled, it is necessary to save/restore
> the LBR stack on context switch. The solution is saving/restoring
> the LBR stack to/from task's perf event context.
> 
> If there are cpu-wide events that use LBR, do not save/restore the
> LBR stack on context switches, flush it instead.

Again inadequate changelog; it fails to explain wtf this is:

> +	if (event->ctx->task &&
> +	    branch_user_callstack(event->hw.branch_reg.reg)) {
> +		struct x86_perf_event_context *task_ctx = (void *)event->ctx;
> +		/*
> +		 * Reset the LBR stack if the call stack is not
> +		 * continuous enabled
> +		 */
> +		if (task_ctx->lbr_callstack_users == 0 &&
> +		    task_ctx->lbr_stack_gen + 1 < event->ctx->sched_gen)
> +			intel_pmu_lbr_reset();
> +
> +		task_ctx->lbr_callstack_users++;
> +		task_ctx->lbr_stack_gen = event->ctx->sched_gen;
> +	}
>  }

And what this parent_ctx nonsense is about:

> +void intel_pmu_lbr_init_context(struct perf_event_context *child_ctx,
> +				struct perf_event_context *parent_ctx)
> +{
> +	struct x86_perf_event_context *task_ctx, *parent_task_ctx;
> +
> +	if (!x86_pmu.lbr_nr)
> +		return;
> +
> +	task_ctx = (struct x86_perf_event_context *)child_ctx;
> +	parent_task_ctx = (struct x86_perf_event_context *)parent_ctx;
> +
> +	if (parent_task_ctx->lbr_callstack_users)
> +		__intel_pmu_lbr_save(task_ctx);
> +	else
> +		task_ctx->lbr_stack_saved = false;
> +}
