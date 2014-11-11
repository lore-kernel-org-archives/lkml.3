Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKKOxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:53:19 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51664 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaKKOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:53:16 -0500
Message-ID: <546222C7.2030000@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2014 20:22:55 +0530
From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        mingo@kernel.org, linaro-kernel@lists.linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC 1/2] sched/fair: Add cumulative average of load_avg_contrib
 to a task
References: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <1415598358-26505-2-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <20141110134911.GG29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141110134911.GG29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111114-0033-0000-0000-0000007D05F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 07:19 PM, Peter Zijlstra wrote:
> On Mon, Nov 10, 2014 at 11:15:57AM +0530, Shilpasri G Bhat wrote:
>> +/**
>> + * task_cumulative_load - return the cumulative load of
>> + * the previous task if cpu is the current cpu OR the
>> + * cumulative load of current task on the cpu. If cpu
>> + * is idle then return 0.
>> + *
>> + * Invoked by the cpufreq governor to calculate the
>> + * load when the CPU is woken from an idle state.
>> + *
>> + */
>> +unsigned int task_cumulative_load(int cpu)
>> +{
>> +	struct rq *rq = cpu_rq(cpu);
>> +	struct task_struct *p;
>> +
>> +	if (cpu == smp_processor_id()) {
>> +		if (rq->prev == rq->idle)
>> +			goto idle;
>> +		p = rq->prev;
>> +	} else {
>> +		if (rq->curr == rq->idle)
>> +			goto idle;
>> +		p = rq->curr;
>> +	}
>> +	/*
>> +	 * Removing the priority as we are interested in CPU
>> +	 * utilization of the task
>> +	 */
>> +	return (100 * p->se.avg.cumulative_avg / p->se.load.weight);
>> +idle:
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(task_cumulative_load);
> 
> This doesn't make any sense, its wrong and also its broken.
> 
> This doesn't make any sense, because the load of a cpu is unrelated to
> whatever task ran there last. You want to look at the task that is
> waking now.

Yes I agree that the task in consideration should be current task on
cpu and not the last task. But the above code is handled by the
cpufreq governor's kworker. So the task in context while executing
'task_cumulative_load()' is kworker and we are not interested in
kworker's load. The task's load which we want to account to is
predecessor of kworker i.e, the task that woke up on the idle cpu.

> 
> It is wrong because dividing out the load.weight doesn't quite work
> right. Also there's patches that introduce unweighted stats like you
> want, you could have used those.

Okay.
> 
> It it broken because who says rq->prev still exists?

'task_cumulative_load()' is handled by the cpufreq governor's kworker.
And the kworker is queued only if there is task running on cpu which
guarantees the existence of rq->prev in a running state.

> 
>> @@ -2476,11 +2478,13 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
>>  static inline void __update_task_entity_contrib(struct sched_entity *se)
>>  {
>>  	u32 contrib;
>> -
>>  	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
>>  	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
>>  	contrib /= (se->avg.runnable_avg_period + 1);
>>  	se->avg.load_avg_contrib = scale_load(contrib);
>> +	se->avg.cumulative_avg *= se->avg.cumulative_avg_count;
>> +	se->avg.cumulative_avg += se->avg.load_avg_contrib;
>> +	se->avg.cumulative_avg /= ++se->avg.cumulative_avg_count;
>>  }
> 
> This is not a numerically stable algorithm. Look what happens when
> cumulative_avg_count gets large. Also, whatever made you choose an
> absolute decay filter like that?
> 

Yes I agree.

The problem I am trying to solve using this metric is: if cpufreq
governor's timer is handled very early when a task wakes up to run
on an idle cpu then the value of 'load_avg_contrib' of that task is
very less, when the governor's kworker is switched in. This happens
because the task did not run for enough time such that it can update
its 'load_avg_contrib' to show considerable amount of load.

Cumulative load was our initial attempt at overcoming this. It is true
that this is not the best solution. We wanted the community's suggestion
on how to get around this issue. What do you propose?

Thanks and Regards,
Shilpa

