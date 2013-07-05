Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3GEFg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:36:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:40035 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3GEFg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="360796163"
Message-ID: <51D65B58.1050201@intel.com>
Date: Fri, 05 Jul 2013 13:36:24 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com> <20130704124536.GK23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130704124536.GK23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 08:45 PM, Peter Zijlstra wrote:
> On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:
> 
>> @@ -2488,25 +2508,31 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
>>  
>>  	list_for_each_entry_rcu(pmu, &pmus, entry) {
>>  		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
>> +		task_ctx = cpuctx->task_ctx;
>>  
>>  		/*
>> -		 * check if the context has at least one
>> -		 * event using PERF_SAMPLE_BRANCH_STACK
>> +		 * force flush the branch stack if there are cpu-wide events
>> +		 * using PERF_SAMPLE_BRANCH_STACK
>> +		 *
>> +		 * save/restore the branch stack if the task context has
>> +		 * at least one event using PERF_SAMPLE_BRANCH_STACK
>>  		 */
>> -		if (cpuctx->ctx.nr_branch_stack > 0
>> -		    && pmu->flush_branch_stack) {
>> -
>> +		bool force_flush = cpuctx->ctx.nr_branch_stack > 0;
>> +		if (pmu->branch_stack_sched &&
>> +		    (force_flush ||
>> +		     (task_ctx && task_ctx->nr_branch_stack > 0))) {
>>  			pmu = cpuctx->ctx.pmu;
>>  
>> -			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +			perf_ctx_lock(cpuctx, task_ctx);
>>  
>>  			perf_pmu_disable(pmu);
>>  
>> -			pmu->flush_branch_stack();
>> +			pmu->branch_stack_sched(task_ctx,
>> +						sched_in, force_flush);
>>  
>>  			perf_pmu_enable(pmu);
>>  
>> -			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +			perf_ctx_unlock(cpuctx, task_ctx);
>>  		}
>>  	}
>>  
> 
> I never really like this; and yes I know I wrote part of that. Is there
> any way we can get rid of this and to it 'properly' through the events
> that get scheduled?
> 
> After all; the LBR usage is through the events, so scheduling the events
> should also manage the LBR state.
> 
> What is missing for that to work?
> 

the LBR is shared resource, can be used by multiple events at the same time.
Strictly speaking，LBR is associated with task, not event. One example is
there are 5 events using the LBR stack feature, but there are only 4 counters.
So these events need schedule. Saving/restoring LBR on the basis of event is
clearly wrong.

Regards
Yan, Zheng


