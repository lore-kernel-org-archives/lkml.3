Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaAUTYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:24:47 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46497 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaAUTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:24:42 -0500
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
References: <20140121111754.580142558@infradead.org>
	<20140121112258.708117448@infradead.org>
Date: Tue, 21 Jan 2014 11:24:39 -0800
In-Reply-To: <20140121112258.708117448@infradead.org> (Peter Zijlstra's
	message of "Tue, 21 Jan 2014 12:18:02 +0100")
Message-ID: <xm2661pdkuiw.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>  static struct task_struct *
>  pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  {
> +	struct sched_entity *se, __maybe_unused *pse;
>  	struct task_struct *p;
> -	struct cfs_rq *cfs_rq = &rq->cfs;
> -	struct sched_entity *se;
> +	struct cfs_rq *cfs_rq;
> +
> +again: __maybe_unused
> +	cfs_rq = &rq->cfs;
> +
> +	if (prev) {
> +		if (!IS_ENABLED(CONFIG_FAIR_GROUP_SCHED) ||
> +		    (prev->sched_class != &fair_sched_class)) {
> +			prev->sched_class->put_prev_task(rq, prev);
> +			prev = NULL;
> +		}
> +	}
>  
>  	if (!cfs_rq->nr_running)
>  		return NULL;
>  
> -	if (prev)
> -		prev->sched_class->put_prev_task(rq, prev);
> -
>  	do {
>  		se = pick_next_entity(cfs_rq);
> -		set_next_entity(cfs_rq, se);
> +		if (!prev)
> +			set_next_entity(cfs_rq, se);
>  		cfs_rq = group_cfs_rq(se);
>  	} while (cfs_rq);
>  
>  	p = task_of(se);
> -	if (hrtick_enabled(rq))
> -		hrtick_start_fair(rq, p);
>  
> -	return p;
> -}
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	/*
> +	 * If we haven't yet done put_prev_entity and the selected task is
> +	 * a different task than we started out with, try and touch the least
> +	 * amount of cfs_rq trees.
> +	 */
> +	if (prev) {
> +		if (prev != p) {
> +			pse = &prev->se;
> +
> +			while (!(cfs_rq = is_same_group(se, pse))) {
> +				int se_depth = se->depth;
> +				int pse_depth = pse->depth;
> +
> +				if (se_depth <= pse_depth) {
> +					put_prev_entity(cfs_rq_of(pse), pse);
> +					pse = parent_entity(pse);
> +				}
> +				if (se_depth >= pse_depth) {
> +					set_next_entity(cfs_rq_of(se), se);
> +					se = parent_entity(se);
> +				}
> +			}
>  
> -/*
> - * Account for a descheduled task:
> - */
> -static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
> -{
> -	struct sched_entity *se = &prev->se;
> -	struct cfs_rq *cfs_rq;
> +			put_prev_entity(cfs_rq, pse);
> +			set_next_entity(cfs_rq, se);
> +		}
>  
> -	for_each_sched_entity(se) {
> -		cfs_rq = cfs_rq_of(se);
> -		put_prev_entity(cfs_rq, se);
> +		/*
> +		 * In case the common cfs_rq got throttled, just give up and
> +		 * put the stack and retry.
> +		 */
> +		if (unlikely(check_cfs_rq_runtime(cfs_rq))) {
> +			put_prev_task_fair(rq, p);
> +			prev = NULL;
> +			goto again;
> +		}

This double-calls put_prev_entity on any non-common cfs_rqs and ses,
which means double __enqueue_entity, among other things. Just doing the
put_prev loop from se->parent should fix that.

However, any sort of abort means that we may have already done
set_next_entity on some children, which even with the changes to
pick_next_entity will cause problems, up to and including double
__dequeue_entity I think.

Also, this way we never do check_cfs_rq_runtime on any parents of the
common cfs_rq, which could even have been the reason for the resched to
begin with. I'm not sure if there would be any problem doing it on the
way down or not, I don't see any problems at a glance.



>  	}
> +#endif
> +
> +	if (hrtick_enabled(rq))
> +		hrtick_start_fair(rq, p);
> +
> +	return p;
>  }
>  
>  /*
