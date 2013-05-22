Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3EVH6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:58:49 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35745 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3EVH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:58:45 -0400
Message-ID: <519C7AAC.1010707@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 15:58:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: Re: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
References: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052207-5816-0000-0000-00000814EE6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

On 05/22/2013 05:30 AM, Peter Boonstoppel wrote:
> RT throttling aims to prevent starvation of non-SCHED_FIFO threads
> when a rogue RT thread is hogging the CPU. It does so by piggybacking
> on the rt_bandwidth system and allocating at most rt_runtime per
> rt_period to SCHED_FIFO tasks (e.g. 950ms out of every second,
> allowing 'regular' tasks to run for at least 50ms every second).
> 
> However, when multiple cores are available, rt_bandwidth allows cores
> to borrow rt_runtime from one another. This means that a core with a
> rogue RT thread, consuming 100% CPU cycles, can borrow enough runtime
> from other cores to allow the RT thread to run continuously, with no
> runtime for regular tasks on this core.

IMHO, such kind of starving should attributed to the Admin...

Reserve cpu will make realtime misnomer, then Admin will blame the
scheduler when his RT task got a higher latency...

Regards,
Michael Wang

> 
> Although regular tasks can get scheduled on other available cores
> (which are guaranteed to have some non-RT runtime avaible, since they
> just lent some RT time to us), tasks that are specifically affined to
> a particular core may not be able to make progress (e.g. workqueues,
> timer functions). This can break e.g. watchdog-like functionality that
> is supposed to kill the rogue RT thread.
> 
> This patch changes do_balance_runtime() in such a way that no core can
> aquire (borrow) more runtime than the globally set rt_runtime /
> rt_period ratio. This guarantees there will always be some non-RT
> runtime available on every individual core.
> 
> Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> ---
>  kernel/sched/rt.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 127a2c4..5ec4eab 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -571,11 +571,25 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
>  	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
>  	int i, weight, more = 0;
>  	u64 rt_period;
> +	u64 max_runtime;
> 
>  	weight = cpumask_weight(rd->span);
> 
>  	raw_spin_lock(&rt_b->rt_runtime_lock);
>  	rt_period = ktime_to_ns(rt_b->rt_period);
> +
> +	/* Don't allow more runtime than global ratio */
> +	if (global_rt_runtime() == RUNTIME_INF)
> +		max_runtime = rt_period;
> +	else
> +		max_runtime = div64_u64(global_rt_runtime() * rt_period,
> +					global_rt_period());
> +
> +	if (rt_rq->rt_runtime >= max_runtime) {
> +		raw_spin_unlock(&rt_b->rt_runtime_lock);
> +		return more;
> +	}
> +
>  	for_each_cpu(i, rd->span) {
>  		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
>  		s64 diff;
> @@ -592,6 +606,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
>  		if (iter->rt_runtime == RUNTIME_INF)
>  			goto next;
> 
> +
>  		/*
>  		 * From runqueues with spare time, take 1/n part of their
>  		 * spare time, but no more than our period.
> @@ -599,12 +614,12 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
>  		diff = iter->rt_runtime - iter->rt_time;
>  		if (diff > 0) {
>  			diff = div_u64((u64)diff, weight);
> -			if (rt_rq->rt_runtime + diff > rt_period)
> -				diff = rt_period - rt_rq->rt_runtime;
> +			if (rt_rq->rt_runtime + diff > max_runtime)
> +				diff = max_runtime - rt_rq->rt_runtime;
>  			iter->rt_runtime -= diff;
>  			rt_rq->rt_runtime += diff;
>  			more = 1;
> -			if (rt_rq->rt_runtime == rt_period) {
> +			if (rt_rq->rt_runtime == max_runtime) {
>  				raw_spin_unlock(&iter->rt_runtime_lock);
>  				break;
>  			}
> 

