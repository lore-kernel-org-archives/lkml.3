Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaKRRak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:30:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33928 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaKRRah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:30:37 -0500
Message-ID: <546B8251.5080805@arm.com>
Date: Tue, 18 Nov 2014 17:30:57 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched/deadline: fix start high-res preemption tick
 for a non-leftmost task
References: <1416277974-11962-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1416277974-11962-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 18 Nov 2014 17:30:32.0754 (UTC) FILETIME=[5AFF7920:01D00355]
X-MC-Unique: 114111817303413701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18/11/14 02:32, Wanpeng Li wrote:
> Queued ticks are scheduled to match the budget, which means the budget
> is overall consumed and the dl task should be throttled. 
> 
> Dl task will be replenished immediately if fail to start a dl timer.
> So the curr maybe not the left most dl task in the rb tree any more 
> after this immediately replenished since reschedule is needed.
> 
> The parameter of task_tick_dl() queued == 1 means that hrtick is fired.
> hrtick() => task_tick_dl( , ,1), so p->dl.runtime should be <= 0 if
> queued == 1. If replenished immediately(fail to start dl timer),
> hrtick is start for task w/ queued == 1 && p->dl.runtime > 0 && p is 
> not the left most task.
> 
> Start high-res preemption tick for this upcoming rescheduled dl task
> is not correct. This patch fix it by not starting high-res preemption 
> tick for a non-leftmost dl task.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v1 -> v2:
>  * add a more explanatory changelog 
>  * add a comment just above the check
> 
>  kernel/sched/deadline.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index e5db8c6..981479a 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1090,7 +1090,18 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
>  {
>  	update_curr_dl(rq);
>  
> -	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
> +	/*
> +	 * Queued tick means that hrtick is fired, when the budget is
> +	 * consumed the task has to be throttled. However, task will
> +	 * be replenished immediately if fail to start a dl timer, in
> +	 * addition, the task maybe not the left most any more. Don't
> +	 * start high-res preemption tick for the task who is not the
> +	 * left most. The high-res preemption tick will be started for
> +	 * this task just when it can be picked in pick_next_task_dl()
> +	 * again.
> +	 */
> +	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0 &&
> +	    is_leftmost(p, &rq->dl))
>  		start_hrtick_dl(rq, p);
>  }
>  
> 

Acked-by: Juri Lelli <juri.lelli@arm.com>

Thanks,

- Juri

