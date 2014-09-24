Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaIXLX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:23:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaIXLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:23:27 -0400
Date: Wed, 24 Sep 2014 13:23:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140924112318.GX6758@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:08:59AM -0400, kan.liang@intel.com wrote:
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

Same broken attribution and SoB chain.


> +void perf_sched_cb_disable(struct pmu *pmu)
> +{
> +	this_cpu_dec(perf_sched_cb_usages);
> +}
> +
> +void perf_sched_cb_enable(struct pmu *pmu)
> +{
> +	this_cpu_inc(perf_sched_cb_usages);
> +}

lkml.kernel.org/r/20140715113957.GD9918@twins.programming.kicks-ass.net

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
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	local_irq_restore(flags);
> +}

lkml.kernel.org/r/20140702084833.GT6758@twins.programming.kicks-ass.net

Maybe you should have read back the previous postings before taking over
this series :-)
