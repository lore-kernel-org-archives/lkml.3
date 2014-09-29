Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaI2PD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:03:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51366 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI2PD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:03:27 -0400
Message-ID: <542974DE.8050203@arm.com>
Date: Mon, 29 Sep 2014 16:03:58 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 2/2] sched/dl: Cleanup prio_changed_dl()
References: <20140927084044.1634.60573.stgit@localhost> <20140927084104.1634.88783.stgit@localhost>
In-Reply-To: <20140927084104.1634.88783.stgit@localhost>
X-OriginalArrivalTime: 29 Sep 2014 15:03:23.0020 (UTC) FILETIME=[83697CC0:01CFDBF6]
X-MC-Unique: 114092916032504201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 27/09/14 09:41, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> Now rq->curr task can't be dequeued in this function
> (it's possible only in __schedule()).
> 

Could you please detail about "before", with a reference to the commit
that made this further change necessary?

Thanks a lot,

- Juri

> Also, delete "else" branch which is dead code.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/deadline.c |   50 +++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 63f8b4a..38b4f19 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1638,35 +1638,33 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>  static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>  			    int oldprio)
>  {
> -	if (task_on_rq_queued(p) || rq->curr == p) {
> +	if (!task_on_rq_queued(p))
> +		return;
>  #ifdef CONFIG_SMP
> -		/*
> -		 * This might be too much, but unfortunately
> -		 * we don't have the old deadline value, and
> -		 * we can't argue if the task is increasing
> -		 * or lowering its prio, so...
> -		 */
> -		if (!rq->dl.overloaded)
> -			pull_dl_task(rq);
> -
> -		/*
> -		 * If we now have a earlier deadline task than p,
> -		 * then reschedule, provided p is still on this
> -		 * runqueue.
> -		 */
> -		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
> -		    rq->curr == p)
> -			resched_curr(rq);
> -#else
> -		/*
> -		 * Again, we don't know if p has a earlier
> -		 * or later deadline, so let's blindly set a
> -		 * (maybe not needed) rescheduling point.
> -		 */
> +	/*
> +	 * This might be too much, but unfortunately
> +	 * we don't have the old deadline value, and
> +	 * we can't argue if the task is increasing
> +	 * or lowering its prio, so...
> +	 */
> +	if (!rq->dl.overloaded)
> +		pull_dl_task(rq);
> +	/*
> +	 * If we now have a earlier deadline task than p,
> +	 * then reschedule, provided p is still on this
> +	 * runqueue.
> +	 */
> +	if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
> +	    rq->curr == p)
>  		resched_curr(rq);
> +#else
> +	/*
> +	 * Again, we don't know if p has a earlier
> +	 * or later deadline, so let's blindly set a
> +	 * (maybe not needed) rescheduling point.
> +	 */
> +	resched_curr(rq);
>  #endif /* CONFIG_SMP */
> -	} else
> -		switched_to_dl(rq, p);
>  }
>  
>  const struct sched_class dl_sched_class = {
> 
> 

