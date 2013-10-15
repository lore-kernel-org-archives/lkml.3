Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3JOLhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:37:00 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49315 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab3JOLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:36:57 -0400
Message-ID: <525D28D5.70503@gmail.com>
Date: Tue, 15 Oct 2013 13:36:53 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 04/14] sched: SCHED_DEADLINE SMP-related data structures
 & logic.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-5-git-send-email-juri.lelli@gmail.com> <20131014120306.GH3081@twins.programming.kicks-ass.net> <525D0C91.1090700@gmail.com> <20131015103507.GF10651@twins.programming.kicks-ass.net>
In-Reply-To: <20131015103507.GF10651@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 12:35 PM, Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 11:36:17AM +0200, Juri Lelli wrote:
>> On 10/14/2013 02:03 PM, Peter Zijlstra wrote:
>>> On Mon, Oct 14, 2013 at 12:43:36PM +0200, Juri Lelli wrote:
>>>> +static inline void dl_set_overload(struct rq *rq)
>>>> +{
>>>> +	if (!rq->online)
>>>> +		return;
>>>> +
>>>> +	cpumask_set_cpu(rq->cpu, rq->rd->dlo_mask);
>>>> +	/*
>>>> +	 * Must be visible before the overload count is
>>>> +	 * set (as in sched_rt.c).
>>>> +	 */
>>>> +	wmb();
>>>> +	atomic_inc(&rq->rd->dlo_count);
>>>> +}
>>>
>>> Please, make that smp_wmb() and modify the comment to point to the
>>> matching barrier ; I couldn't find one! Which suggests something is
>>> amiss.
>>>
>>> Ideally we'd have something like smp_wmb__after_set_bit() but alas.
>>>
>>
>> The only user of this function is pull_dl_task (that tries to pull only if at
>> least one runqueue of the root_domain is overloaded). Surely makes sense to
>> ensure that changes in the dlo_mask have to be visible before we check if we
>> should look at that mask. Am I right if I say that the matching barrier is
>> constituted by the spin_lock on this_rq acquired by schedule() before calling
>> pre_schedule()?
>>
>> Same thing in rt_set_overload(), do we need to modify the comment also there?
> 
> So I haven't looked at the dl code, but for the RT code the below is
> required.
> 

Same thing for dl code.

Thanks,

- Juri

> Without that smp_rmb() in there we could actually miss seeing the
> rto_mask bit.
> 
> ---
>  kernel/sched/rt.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index e9304cdc26fe..a848f526b941 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -246,8 +246,10 @@ static inline void rt_set_overload(struct rq *rq)
>  	 * if we should look at the mask. It would be a shame
>  	 * if we looked at the mask, but the mask was not
>  	 * updated yet.
> +	 *
> +	 * Matched by the barrier in pull_rt_task().
>  	 */
> -	wmb();
> +	smp_wmb();
>  	atomic_inc(&rq->rd->rto_count);
>  }
>  
> @@ -1626,6 +1628,12 @@ static int pull_rt_task(struct rq *this_rq)
>  	if (likely(!rt_overloaded(this_rq)))
>  		return 0;
>  
> +	/*
> +	 * Match the barrier from rt_set_overloaded; this guarantees that if we
> +	 * see overloaded we must also see the rto_mask bit.
> +	 */
> +	smp_rmb();
> +
>  	for_each_cpu(cpu, this_rq->rd->rto_mask) {
>  		if (this_cpu == cpu)
>  			continue;
> 
