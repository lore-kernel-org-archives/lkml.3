Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaJVJno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:43:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58689 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaJVJnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:43:42 -0400
Message-ID: <54477C4D.9040502@arm.com>
Date: Wed, 22 Oct 2014 10:43:41 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>, Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [RFC] sched/dl: Fix preemption checks
References: <1413909356.19914.128.camel@tkhai>
In-Reply-To: <1413909356.19914.128.camel@tkhai>
X-OriginalArrivalTime: 22 Oct 2014 09:43:40.0461 (UTC) FILETIME=[A93785D0:01CFEDDC]
X-MC-Unique: 114102210434013601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 21/10/14 17:35, Kirill Tkhai wrote:
> 
> 1)switched_to_dl() check is wrong. We reschedule only
> if rq->curr is deadline task, and we do not reschedule
> if it's a lower priority task. But we must always
> preempt a task of other classes.
> 
> 2)dl_task_timer():
> Policy does not change in case of priority inheritance.
> rt_mutex_setprio() changes prio, while policy remains old.
> 
> So we lose some balancing logic in dl_task_timer() and
> switched_to_dl() when we check policy instead of priority.
> Boosted task may be rq->curr.
> 
> (I didn't change switched_from_dl() because no check is
> necessary there at all).
> 
> I've looked at this place(switched_to_dl) several times
> and even fixed this function, but found just now...
> I suppose some performance tests may work better after this.
> 
> Completely untested, just RFC.
> 
> Juri how about this?
> 

I'll have to give it a spin, but it looks good.

Thanks,

- Juri

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/deadline.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 256e577..937a875 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -532,7 +532,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>  	dl_se->dl_yielded = 0;
>  	if (task_on_rq_queued(p)) {
>  		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
> -		if (task_has_dl_policy(rq->curr))
> +		if (dl_task(rq->curr))
>  			check_preempt_curr_dl(rq, p, 0);
>  		else
>  			resched_curr(rq);
> @@ -1607,8 +1607,12 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>  			/* Only reschedule if pushing failed */
>  			check_resched = 0;
>  #endif /* CONFIG_SMP */
> -		if (check_resched && task_has_dl_policy(rq->curr))
> -			check_preempt_curr_dl(rq, p, 0);
> +		if (check_resched) {
> +			if (dl_task(rq->curr))
> +				check_preempt_curr_dl(rq, p, 0);
> +			else
> +				resched_curr(rq);
> +		}
>  	}
>  }
>  
> 
> 
> 
> 
> 

