Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3IZPKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:10:07 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55659 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3IZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:10:02 -0400
Message-ID: <52444E3A.5070503@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 23:09:46 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>
CC: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
References: <20130925075341.GB3081@twins.programming.kicks-ass.net> <1380099377.8523.9.camel@marge.simpson.net> <20130926095812.GR3081@twins.programming.kicks-ass.net>
In-Reply-To: <20130926095812.GR3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092615-5816-0000-0000-00000A17A8A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

On 09/26/2013 05:58 PM, Peter Zijlstra wrote:
[snip]
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2b89cd2..47b0d0f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2913,6 +2913,17 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	struct sched_entity *se = &p->se;
>  	int task_sleep = flags & DEQUEUE_SLEEP;
> 
> +	if (se->last_sync_wakeup) {
> +		u64 overlap;
> +		s64 diff;
> +	       
> +		overlap = rq->clock - se->last_sync_wakeup;
> +		se->last_sync_wakeup = 0;
> +
> +		diff = overlap - se->avg_overlap;
> +		se->avg_overlap += diff >> 8;
> +	}
> +
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
>  		dequeue_entity(cfs_rq, se, flags);
> @@ -3429,6 +3440,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	int want_affine = 0;
>  	int sync = wake_flags & WF_SYNC;
> 
> +	if (sync)
> +		p->se.last_sync_wakeup = sched_clock_cpu(cpu);

Forgive me but I'm trying to understand it... why not 'current' but 'p'
here? we want the get off speed of waker or the working time of wakee?

Regards,
Michael Wang

> +
>  	if (p->nr_cpus_allowed == 1)
>  		return prev_cpu;
> 
> @@ -3461,6 +3475,17 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
> 
> +		/*
> +		 * Don't bother with select_idle_sibling() in the case of a sync wakeup
> +		 * where we know the only running task will soon go-away. Going
> +		 * through select_idle_sibling will only lead to pointless ping-pong.
> +		 */
> +		if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1 &&
> +		    current->se.avg_overlap < 10000) {
> +			new_cpu = cpu;
> +			goto unlock;
> +		}
> +
>  		new_cpu = select_idle_sibling(p, prev_cpu);
>  		goto unlock;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

