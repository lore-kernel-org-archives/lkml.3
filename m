Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaAUSqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:46:16 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:57733 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaAUSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:46:13 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 13:46:13 EST
From: bsegall@google.com
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        pjt@google.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] sched: fix sched_entity avg statistics update
References: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
Date: Tue, 21 Jan 2014 10:38:58 -0800
In-Reply-To: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
	(Vincent Guittot's message of "Tue, 21 Jan 2014 17:12:18 +0100")
Message-ID: <xm26d2jlkwn1.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Guittot <vincent.guittot@linaro.org> writes:

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

... Gah, that's correct, we had this right the first time. Could you do
this as a full revert of 282cf499f03ec1754b6c8c945c9674b02631fb0f (ie
remove the now inaccurate comment, or maybe replace it with a correct one).
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e64b079..5b0ef90 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2370,8 +2370,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>  		 * would have made count negative); we must be careful to avoid
>  		 * double-accounting blocked time after synchronizing decays.
>  		 */
> -		se->avg.last_runnable_update += __synchronize_entity_decay(se)
> -							<< 20;
> +		__synchronize_entity_decay(se);
>  	}
>  
>  	/* migrated tasks did not contribute to our blocked load */
