Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3GEIvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:51:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:44185 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab3GEIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="264385090"
Message-ID: <51D68915.7060901@intel.com>
Date: Fri, 05 Jul 2013 16:51:33 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com> <20130704124536.GK23916@twins.programming.kicks-ass.net> <51D65B58.1050201@intel.com> <20130705081516.GP18898@dyad.programming.kicks-ass.net>
In-Reply-To: <20130705081516.GP18898@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:15 PM, Peter Zijlstra wrote:
> On Fri, Jul 05, 2013 at 01:36:24PM +0800, Yan, Zheng wrote:
>> On 07/04/2013 08:45 PM, Peter Zijlstra wrote:
>>> On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:
>>>
>>>> @@ -2488,25 +2508,31 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
>>>>  
>>>>  	list_for_each_entry_rcu(pmu, &pmus, entry) {
>>>>  		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
>>>> +		task_ctx = cpuctx->task_ctx;
>>>>  
>>>>  		/*
>>>> -		 * check if the context has at least one
>>>> -		 * event using PERF_SAMPLE_BRANCH_STACK
>>>> +		 * force flush the branch stack if there are cpu-wide events
>>>> +		 * using PERF_SAMPLE_BRANCH_STACK
>>>> +		 *
>>>> +		 * save/restore the branch stack if the task context has
>>>> +		 * at least one event using PERF_SAMPLE_BRANCH_STACK
>>>>  		 */
>>>> -		if (cpuctx->ctx.nr_branch_stack > 0
>>>> -		    && pmu->flush_branch_stack) {
>>>> -
>>>> +		bool force_flush = cpuctx->ctx.nr_branch_stack > 0;
>>>> +		if (pmu->branch_stack_sched &&
>>>> +		    (force_flush ||
>>>> +		     (task_ctx && task_ctx->nr_branch_stack > 0))) {
>>>>  			pmu = cpuctx->ctx.pmu;
>>>>  
>>>> -			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>>>> +			perf_ctx_lock(cpuctx, task_ctx);
>>>>  
>>>>  			perf_pmu_disable(pmu);
>>>>  
>>>> -			pmu->flush_branch_stack();
>>>> +			pmu->branch_stack_sched(task_ctx,
>>>> +						sched_in, force_flush);
>>>>  
>>>>  			perf_pmu_enable(pmu);
>>>>  
>>>> -			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>>>> +			perf_ctx_unlock(cpuctx, task_ctx);
>>>>  		}
>>>>  	}
>>>>  
>>>
>>> I never really like this; and yes I know I wrote part of that. Is there
>>> any way we can get rid of this and to it 'properly' through the events
>>> that get scheduled?
>>>
>>> After all; the LBR usage is through the events, so scheduling the events
>>> should also manage the LBR state.
>>>
>>> What is missing for that to work?
>>>
>>
>> the LBR is shared resource, can be used by multiple events at the same time.
> 
> Yeah so? There's tons of shared resources in the PMU already.

we should restore the LBR callstack only when task schedule in. restoring the LBR
callstack at any other time will make the LBR callstack and actual callchain of program
mismatch. this property make the LBR different from counters.

> 
>> Strictly speaking，LBR is associated with task, not event.
> 
> Wrong!, it _is_ associated with events. Events is all there is. Event can be
> associated with tasks, but that's completely irrelevant.
> 
>> One example is
>> there are 5 events using the LBR stack feature, but there are only 4 counters.
>> So these events need schedule. Saving/restoring LBR on the basis of event is
>> clearly wrong.
> 
> Different scheduling and you're wrong. Look at perf_rotate_context(), we'd
> disable everything at perf_pmu_disable() and enable the entire thing at
> perf_pmu_enable(), on both sides we'd have the LBR running.
> 

yes，on both sides we'd have the LBR running. but there is no need to save/restore
the LBR stack in this case. we should save the LBR stack only when task schedule out,
and restore the LBR stack when task schedule in. So I think it's more natural to
manage the LBR state when switching perf task context.

Regards
Yan, Zheng 




