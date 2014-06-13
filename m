Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaFMQ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:28:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:34395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaFMQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:28:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,472,1400050800"; 
   d="scan'208";a="557082779"
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1402639311.9617.84.camel@j-VirtualBox>
References: <1402608359.2970.548.camel@schen9-DESK>
	 <1402639311.9617.84.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 09:28:02 -0700
Message-ID: <1402676882.2970.564.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 23:01 -0700, Jason Low wrote:
> On Thu, 2014-06-12 at 14:25 -0700, Tim Chen wrote:
> 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> >  kernel/sched/core.c  | 12 ++++++++----
> >  kernel/sched/fair.c  | 23 +++++++++++++++++++++--
> >  kernel/sched/sched.h | 10 ++++++++--
> >  3 files changed, 37 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index c6b9879..4f57221 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
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
> 
> Hi Tim,
> 
> If it is skipping if no cpu has more than 1 task, should the
> above have the additional check for (rq->nr_running > 1) instead
> of (rq->nr_running > 0)?

If you have a job on your local cpu, you do want to have the scheduler
pick the task to run.

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
> 
> Would it make the code cleaner if we always call:
> 
> +	update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> 				   &overload);
> 
> and in update_sg_lb_stats():
> 
> +	bool is_root_domain = (env->sd->parent == NULL)
> 
> 
> +		/* gather overload info if we are at root domain */
> +		if (is_root_domain && rq->nr_running > 1)
> +			*overload = true;
> 

I want to have the caller to update_sg_lb_stats make the decision
on whether there's a need to calculate the indicator, and not
make the decision in update_sg_lb_stats.

This allows the flexibility later on if we want such indicator
in a lower sched domain hierarchy.

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
> 
> Perhaps we could just use:
> 
> struct rq *rq = env->dst_rq;
> 

Yes, your suggested change is more concise.  I'll update the code with
this change.

Tim

