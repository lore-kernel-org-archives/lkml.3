Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaIXNd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:33:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:40955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaIXNdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:33:23 -0400
Date: Wed, 24 Sep 2014 15:33:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 09/16] perf, x86: Save/resotre LBR stack during
 context switch
Message-ID: <20140924133321.GD2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-10-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-10-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:09:06AM -0400, kan.liang@intel.com wrote:
>  void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +	struct x86_perf_task_context *task_ctx;
>  
>  	if (!x86_pmu.lbr_nr)
>  		return;
>  	/*
> +	 * If LBR callstack feature is enabled and the stack was saved when
> +	 * the task was scheduled out, restore the stack. Otherwise flush
> +	 * the LBR stack.
> +	 */
> +	task_ctx = ctx ? ctx->task_ctx_data : NULL;
> +	if (task_ctx) {
> +		if (sched_in) {
> +			__intel_pmu_lbr_restore(task_ctx);
> +			cpuc->lbr_context = ctx;
> +		} else {
> +			__intel_pmu_lbr_save(task_ctx);
> +		}
> +	}
> +
> +	/*
>  	 * When sampling the branck stack in system-wide, it may be
>  	 * necessary to flush the stack on context switch. This happens
>  	 * when the branch stack does not tag its entries with the pid

Why would we still need to reset if we did a save/restore on the branch
stack?
