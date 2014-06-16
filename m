Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaFPPuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:50:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:36328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaFPPuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:50:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,487,1400050800"; 
   d="scan'208";a="558300068"
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20140615161921.GL11371@laptop.programming.kicks-ass.net>
References: <1402608359.2970.548.camel@schen9-DESK>
	 <20140615161921.GL11371@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jun 2014 08:50:07 -0700
Message-ID: <1402933807.2970.577.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-15 at 18:19 +0200, Peter Zijlstra wrote:
> On Thu, Jun 12, 2014 at 02:25:59PM -0700, Tim Chen wrote:
> > @@ -2630,7 +2630,7 @@ static inline struct task_struct *
> >  pick_next_task(struct rq *rq, struct task_struct *prev)
> >  {
> >  	const struct sched_class *class = &fair_sched_class;
> > -	struct task_struct *p;
> > +	struct task_struct *p = NULL;
> >  
> >  	/*
> >  	 * Optimization: we know that if all tasks are in
> > @@ -2638,9 +2638,13 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
> >  	 */
> >  	if (likely(prev->sched_class == class &&
> >  		   rq->nr_running == rq->cfs.h_nr_running)) {
> > -		p = fair_sched_class.pick_next_task(rq, prev);
> > -		if (unlikely(p == RETRY_TASK))
> > -			goto again;
> > +
> > +		/* If no cpu has more than 1 task, skip */
> > +		if (rq->nr_running > 0 || rq->rd->overload) {
> > +			p = fair_sched_class.pick_next_task(rq, prev);
> > +			if (unlikely(p == RETRY_TASK))
> > +				goto again;
> > +		}
> >  
> >  		/* assumes fair_sched_class->next == idle_sched_class */
> >  		if (unlikely(!p))
> 
> 
> Please move this into pick_next_task_fair(). You're slowing down the
> important fast path of picking a task when there actually is something
> to do.

Will do.  

> 
> Also, its a layering violation -- the idle balance things you're trying
> to avoid is a fair_sched_class affair.
> 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 9855e87..00ab38c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5863,7 +5863,8 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
> >   */
> >  static inline void update_sg_lb_stats(struct lb_env *env,
> >  			struct sched_group *group, int load_idx,
> > -			int local_group, struct sg_lb_stats *sgs)
> > +			int local_group, struct sg_lb_stats *sgs,
> > +			bool *overload)
> >  {
> >  	unsigned long load;
> >  	int i;
> > @@ -5881,6 +5882,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
> >  
> >  		sgs->group_load += load;
> >  		sgs->sum_nr_running += rq->nr_running;
> > +		if (overload && rq->nr_running > 1)
> > +			*overload = true;
> >  #ifdef CONFIG_NUMA_BALANCING
> >  		sgs->nr_numa_running += rq->nr_numa_running;
> >  		sgs->nr_preferred_running += rq->nr_preferred_running;
> > @@ -5991,6 +5994,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
> >  	struct sched_group *sg = env->sd->groups;
> >  	struct sg_lb_stats tmp_sgs;
> >  	int load_idx, prefer_sibling = 0;
> > +	bool overload = false;
> >  
> >  	if (child && child->flags & SD_PREFER_SIBLING)
> >  		prefer_sibling = 1;
> > @@ -6011,7 +6015,13 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
> >  				update_group_power(env->sd, env->dst_cpu);
> >  		}
> >  
> > -		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
> > +		if (env->sd->parent)
> > +			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> > +						NULL);
> > +		else
> > +			/* gather overload info if we are at root domain */
> > +			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> > +						&overload);
> >  
> >  		if (local_group)
> >  			goto next_group;
> > @@ -6045,6 +6055,15 @@ next_group:
> >  
> >  	if (env->sd->flags & SD_NUMA)
> >  		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
> > +
> > +	if (!env->sd->parent) {
> > +		/* update overload indicator if we are at root domain */
> > +		int i = cpumask_first(sched_domain_span(env->sd));
> > +		struct rq *rq = cpu_rq(i);
> > +		if (rq->rd->overload != overload)
> > +			rq->rd->overload = overload;
> > +	}
> > +
> >  }
> >  
> >  /**
> 
> The worry I have is that this update is 'slow'. We could have grown many
> tasks since the last update.

The update to turn on the indicator is immediate and triggered in
add_nr_running. So if there are more than one tasks on any cpu, 
we start load balancing again right away.  It is only the 
clearing of the indicator in update_sd_lb_stats that takes time.
That does no harm as the cleared indicator is for the skipping of load
balance, which can be delayed.

Thanks.

Tim

