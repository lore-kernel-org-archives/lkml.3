Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaAVRxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:53:45 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:50718 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:53:42 -0500
X-Greylist: delayed 72607 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 12:53:42 EST
From: bsegall@google.com
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        pjt@google.com, alex.shi@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] Revert "sched: Fix sleep time double accounting in enqueue entity"
References: <CAPM31RLjHnn=Ma7peuDUqK75bANw7Mb-UT-1QmzG0c8LAObQ8g@mail.gmail.com>
	<1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
Date: Wed, 22 Jan 2014 09:53:37 -0800
In-Reply-To: <1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
	(Vincent Guittot's message of "Wed, 22 Jan 2014 08:45:34 +0100")
Message-ID: <xm26lhy7kin2.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Guittot <vincent.guittot@linaro.org> writes:

> This reverts commit 282cf499f03ec1754b6c8c945c9674b02631fb0f.
>
> With the current implementation, the load average statistics of a sched entity
> change according to other activity on the CPU even if this activity is done
> between the running window of the sched entity and have no influence on the
> running duration of the task.
>
> When a task wakes up on the same CPU, we currently update last_runnable_update
> with the return  of __synchronize_entity_decay without updating the
> runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
> the load_contrib of the se with the rq's blocked_load_contrib before removing
> it from the latter (with __synchronize_entity_decay) but we must keep
> last_runnable_update unchanged for updating runnable_avg_sum/period during the
> next update_entity_load_avg.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Unless paul wants to squash this into a possible change to the if
(wakeup) stuff:
Reviewed-by: Ben Segall <bsegall@google.com>

>
> ---
>  kernel/sched/fair.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e64b079..6d61f20 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2365,13 +2365,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>  		}
>  		wakeup = 0;
>  	} else {
> -		/*
> -		 * Task re-woke on same cpu (or else migrate_task_rq_fair()
> -		 * would have made count negative); we must be careful to avoid
> -		 * double-accounting blocked time after synchronizing decays.
> -		 */
> -		se->avg.last_runnable_update += __synchronize_entity_decay(se)
> -							<< 20;
> +		__synchronize_entity_decay(se);
>  	}
>  
>  	/* migrated tasks did not contribute to our blocked load */
