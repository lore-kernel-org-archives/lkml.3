Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBNCN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:13:58 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43657 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNCN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:13:56 -0500
Message-ID: <52FD7BDC.7020509@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 10:13:48 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Push down pre_schedule() and idle_balance
 ()
References: <tip-a8k6vvaebtn64nie345kx1je@git.kernel.org> <52FB1411.1040305@linux.vnet.ibm.com> <20140212102251.GD3545@laptop.programming.kicks-ass.net> <52FC3D5B.7000808@linux.vnet.ibm.com>
In-Reply-To: <52FC3D5B.7000808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021402-2000-0000-0000-00000FB94548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 11:34 AM, Michael wang wrote:
> On 02/12/2014 06:22 PM, Peter Zijlstra wrote:
> [snip]
>>
>> Yes I think there might be a problem here because of how we re-arranged
>> things. Let me brew of pot of tea and try to actually wake up.
>>
>> I suspect we might be good if we clear the need_resched flags before
>> calling pick_next_task. Then any RT/DL task that gets moved here will
>> set need resched, and we'll retry the pick_next_task loop.
> 
> That sounds better, some thing like this?

Hmm... need a little adjustments, will post formal patch with some test
later.

Regards,
Michael Wang

> 
> 
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fb9764f..56a2e1f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2688,8 +2688,8 @@ need_resched:
>  	if (prev->on_rq || rq->skip_clock_update < 0)
>  		update_rq_clock(rq);
>  
> -	next = pick_next_task(rq, prev);
>  	clear_tsk_need_resched(prev);
> +	next = pick_next_task(rq, prev);
>  	clear_preempt_need_resched();
>  	rq->skip_clock_update = 0;
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 235cfa7..48a9500 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4784,7 +4784,18 @@ idle:
>  	rq->idle_stamp = rq_clock(rq);
>  	if (idle_balance(rq)) { /* drops rq->lock */
>  		rq->idle_stamp = 0;
> -		goto again;
> +		/*
> +		 * Before we start to pick one of the pulled fair entities, take
> +		 * care if some RT/DL tasks has been enqueued during the time
> +		 * we release rq-lock inside idle_balance().
> +		 *
> +		 * In such cases, since clear_tsk_need_resched() was done
> +		 * already, need_resched() will imply the request to sched-in
> +		 * the enqueued RT/DL tasks, so don't 'goto again' to make sure
> +		 * the priority.
> +		 */
> +		if (rq->nr_running == rq->cfs.h_nr_running || !need_resched())
> +			goto again;
> 
> 
> 
> I like tea BTW, drink every day :)
> 
> Regards,
> Michael Wang
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

