Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaKMJhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:37:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52691 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaKMJhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:37:15 -0500
Message-ID: <54647BDC.6050804@arm.com>
Date: Thu, 13 Nov 2014 09:37:32 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched/deadline: fix start high-res preemption tick
 for a non-running task
References: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com> <1415670747-58726-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1415670747-58726-2-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 13 Nov 2014 09:37:13.0108 (UTC) FILETIME=[676CA540:01CFFF25]
X-MC-Unique: 114111309371303701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

not sure I understand what the problem is here.

On 11/11/14 01:52, Wanpeng Li wrote:
> Queued ticks are scheduled to match the budget, which means the budget 
> is overall consumed and the dl task should be throttled.

... enforce the budget? It means that when the budget is consumed the
task has to be throttled...

> Dl task will 
> be replenished immediately if fail to start a dl timer. 
> 
> However, the curr maybe not the left most dl task in the rb tree any 
> more after this immediately replenished and reschedule is needed. 
> Start high-res preemption tick for this upcoming rescheduled dl task 
> is not correct. 
> 

So, the task that is going to preempt curr is picked by
pick_next_task_dl(), that correctly starts the hrtick for this new task.

Maybe you can add more information about what you are seeing? A callpath
maybe?

Thanks,

- Juri

> This patch fix it by not starting high-res preemption tick for a 
> non-running dl task.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 56674f6..2a6a5bb 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1090,7 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
>  {
>  	update_curr_dl(rq);
>  
> -	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
> +	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0 &&
> +	    is_leftmost(p, &rq->dl))
>  		start_hrtick_dl(rq, p);
>  }
>  
> 

