Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaFWQlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:41:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:22591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbaFWQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:40:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="532774159"
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
References: <1402948127.2970.578.camel@schen9-DESK>
	 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jun 2014 09:40:45 -0700
Message-ID: <1403541645.2970.599.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:52 +0200, Peter Zijlstra wrote:
> On Mon, Jun 16, 2014 at 12:48:47PM -0700, Tim Chen wrote:
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
> > @@ -6045,6 +6055,13 @@ next_group:
> >  
> >  	if (env->sd->flags & SD_NUMA)
> >  		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
> > +
> > +	if (!env->sd->parent) {
> > +		/* update overload indicator if we are at root domain */
> > +		if (env->dst_rq->rd->overload != overload)
> > +			env->dst_rq->rd->overload = overload;
> > +	}
> > +
> >  }
> >  
> >  /**
> 
> So I don't get why we can't do the below; I think Jason tried to ask the
> same...
> 
> Making that overload thing unconditional makes the code simpler and the
> cost is about the same; it doesn't matter if we test the pointer or
> ->nr_running, which we've already loaded anyhow.
> 
> Also, with only having a single update_sg_lb_stats() callsite GCC can
> more easily inline the lot.
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5886,7 +5886,7 @@ static inline void update_sg_lb_stats(st
>  
>  		sgs->group_load += load;
>  		sgs->sum_nr_running += rq->nr_running;
> -		if (overload && rq->nr_running > 1)
> +		if (rq->nr_running > 1)
>  			*overload = true;
>  #ifdef CONFIG_NUMA_BALANCING
>  		sgs->nr_numa_running += rq->nr_numa_running;
> @@ -6019,13 +6019,7 @@ static inline void update_sd_lb_stats(st
>  				update_group_capacity(env->sd, env->dst_cpu);
>  		}
>  
> -		if (env->sd->parent)
> -			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> -						NULL);
> -		else
> -			/* gather overload info if we are at root domain */
> -			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
> -						&overload);
> +		update_sg_lb_stats(env, sg, load_idx, local_group, sgs, &overload);

With this change, we'll be returning the overload indicator 
that we don't use for non-root domains, which will be
extra work in sg_lb_stats as it loops through each rq checking
the nr_running to update the indicator.  I was hoping to avoid
that if possible.

Tim


