Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaIPRtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:49:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49542 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIPRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:49:17 -0400
From: bsegall@google.com
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] sched: Update task group load contributions during active load-balancing
References: <1410826030-26301-1-git-send-email-morten.rasmussen@arm.com>
Date: Tue, 16 Sep 2014 10:49:14 -0700
In-Reply-To: <1410826030-26301-1-git-send-email-morten.rasmussen@arm.com>
	(Morten Rasmussen's message of "Tue, 16 Sep 2014 01:07:10 +0100")
Message-ID: <xm26sijrqwv9.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten Rasmussen <morten.rasmussen@arm.com> writes:

> Task group load-contributions are not updated when tasks belonging to
> task groups are migrated by active load-balancing. If no other task
> belonging to the same task group is already queued at the destination
> cpu the group sched_entity will be enqueued with load_avg_contrib=0.
> Hence, weighted_cpuload() won't reflect the newly added load.
>
> The load may remain invisible until the next tick, when the sched_entity
> load_avg_contrib and task group contributions are reevaluated.
>
> The enqueue loop
>
> 	for_each_entity(se) {
> 	   enqueue_entity(cfs_rq,se)
> 	      ...
> 	      enqueue_entity_load_avg(cfs_rq,se)
> 	         ...
> 	         update_entity_load_avg(se)
> 		    ...
> 		    __update_entity_load_avg_contrib(se)
> 		    ...
> 		 ...
> 	         update_cfs_rq_blocked_load(cfs_rq)
> 		    ...
> 		    __update_cfs_rq_tg_load_contrib(cfs_rq)
> 		    ...
> 	}
>
> currently skips __update_entity_load_avg_contrib() and
> __update_cfs_rq_tg_load_contrib() for group entities for active
> load-balance migrations. The former updates the sched_entity
> load_avg_contrib, and the latter updates the task group contribution
> which is needed by the former. They must both be called to ensure that
> load doesn't temporarily disappear.
>
> cc: Paul Turner <pjt@google.com>
> cc: Ben Segall <bsegall@google.com>
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index be9e97b..2b6e2eb 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2521,7 +2521,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
>  	else
>  		now = cfs_rq_clock_task(group_cfs_rq(se));
>  
> -	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
> +	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq) &&
> +							entity_is_task(se))
>  		return;
>  
>  	contrib_delta = __update_entity_load_avg_contrib(se);
> @@ -2609,6 +2610,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>  	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
>  	/* we force update consideration on load-balancer moves */
>  	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
> +
> +	/* We force update group contributions on load-balancer moves */
> +	if (wakeup && !entity_is_task(se))
> +		__update_cfs_rq_tg_load_contrib(cfs_rq, 0);
>  }
>  
>  /*

It should probably be clearer that what this actually means is that we
always update tg_load_contrib for any group-of-group (which is weird),
so that we update the entire tree on load-balancer moves (which is
sensible and what we care about, because it determines each se.load_avg_contrib).

Wouldn't we need this on dequeue as well?

I believe the reason for both of these ratelimits was performance on
sleep/wake (where blocked_load_avg means tg_load_contrib should not have
changed), it would be good to know how much this hurts. Given the
fast-exit in __update_cfs_rq_tg_load_contrib, it seems like it might be
fine, but the group-entity __update_entity_load_avg_contrib is less
free when div_u64 is expensive, and is currently only called 1/ms.

It seems like it would be a bit of a mess to force an update of the
entire path in migrate, but it would certainly dodge the performance
concerns if they wind up being an issue. (I suppose we could have
ENQUEUE/DEQUEUE_MIGRATE or something...)
