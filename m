Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaFOQT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:19:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaFOQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:19:27 -0400
Date: Sun, 15 Jun 2014 18:19:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially loaded
Message-ID: <20140615161921.GL11371@laptop.programming.kicks-ass.net>
References: <1402608359.2970.548.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402608359.2970.548.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 02:25:59PM -0700, Tim Chen wrote:
> @@ -2630,7 +2630,7 @@ static inline struct task_struct *
>  pick_next_task(struct rq *rq, struct task_struct *prev)
>  {
>  	const struct sched_class *class = &fair_sched_class;
> -	struct task_struct *p;
> +	struct task_struct *p = NULL;
>  
>  	/*
>  	 * Optimization: we know that if all tasks are in
> @@ -2638,9 +2638,13 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
>  	 */
>  	if (likely(prev->sched_class == class &&
>  		   rq->nr_running == rq->cfs.h_nr_running)) {
> -		p = fair_sched_class.pick_next_task(rq, prev);
> -		if (unlikely(p == RETRY_TASK))
> -			goto again;
> +
> +		/* If no cpu has more than 1 task, skip */
> +		if (rq->nr_running > 0 || rq->rd->overload) {
> +			p = fair_sched_class.pick_next_task(rq, prev);
> +			if (unlikely(p == RETRY_TASK))
> +				goto again;
> +		}
>  
>  		/* assumes fair_sched_class->next == idle_sched_class */
>  		if (unlikely(!p))


Please move this into pick_next_task_fair(). You're slowing down the
important fast path of picking a task when there actually is something
to do.

Also, its a layering violation -- the idle balance things you're trying
to avoid is a fair_sched_class affair.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9855e87..00ab38c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5863,7 +5863,8 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
>   */
>  static inline void update_sg_lb_stats(struct lb_env *env,
>  			struct sched_group *group, int load_idx,
> -			int local_group, struct sg_lb_stats *sgs)
> +			int local_group, struct sg_lb_stats *sgs,
> +			bool *overload)
>  {
>  	unsigned long load;
>  	int i;
> @@ -5881,6 +5882,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  
>  		sgs->group_load += load;
>  		sgs->sum_nr_running += rq->nr_running;
> +		if (overload && rq->nr_running > 1)
> +			*overload = true;
>  #ifdef CONFIG_NUMA_BALANCING
>  		sgs->nr_numa_running += rq->nr_numa_running;
>  		sgs->nr_preferred_running += rq->nr_preferred_running;
> @@ -5991,6 +5994,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  	struct sched_group *sg = env->sd->groups;
>  	struct sg_lb_stats tmp_sgs;
>  	int load_idx, prefer_sibling = 0;
> +	bool overload = false;
>  
>  	if (child && child->flags & SD_PREFER_SIBLING)
>  		prefer_sibling = 1;
> @@ -6011,7 +6015,13 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  				update_group_power(env->sd, env->dst_cpu);
>  		}
>  
> -		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
> +		if (env->sd->parent)
> +			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> +						NULL);
> +		else
> +			/* gather overload info if we are at root domain */
> +			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> +						&overload);
>  
>  		if (local_group)
>  			goto next_group;
> @@ -6045,6 +6055,15 @@ next_group:
>  
>  	if (env->sd->flags & SD_NUMA)
>  		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
> +
> +	if (!env->sd->parent) {
> +		/* update overload indicator if we are at root domain */
> +		int i = cpumask_first(sched_domain_span(env->sd));
> +		struct rq *rq = cpu_rq(i);
> +		if (rq->rd->overload != overload)
> +			rq->rd->overload = overload;
> +	}
> +
>  }
>  
>  /**

The worry I have is that this update is 'slow'. We could have grown many
tasks since the last update.
