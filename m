Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbaGOJxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:53:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:50384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbaGOJxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:53:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="561974642"
Date: Tue, 15 Jul 2014 09:51:05 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140715015105.GA2532@intel.com>
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
 <1405293352-9305-3-git-send-email-yuyang.du@intel.com>
 <xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Ben.

On Mon, Jul 14, 2014 at 12:33:53PM -0700, bsegall@google.com wrote:

> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -282,9 +282,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
> >  	return grp->my_q;
> >  }
> >  
> > -static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
> > -				       int force_update);
> > -
> >  static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
> >  {
> >  	if (!cfs_rq->on_list) {
> > @@ -304,8 +301,6 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
> >  		}
> >  
> >  		cfs_rq->on_list = 1;
> > -		/* We should have no load, but we need to update last_decay. */
> > -		update_cfs_rq_blocked_load(cfs_rq, 0);
> 
> AFAICT this call was nonsense before your change, yes (it gets called by
> enqueue_entity_load_avg)?
> 
Yes, I think so.

> > @@ -667,18 +662,17 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  #ifdef CONFIG_SMP
> >  static unsigned long task_h_load(struct task_struct *p);
> >  
> > -static inline void __update_task_entity_contrib(struct sched_entity *se);
> > -
> >  /* Give new task start runnable values to heavy its load in infant time */
> >  void init_task_runnable_average(struct task_struct *p)
> >  {
> >  	u32 slice;
> > +	struct sched_avg *sa = &p->se.avg;
> >  
> > -	p->se.avg.decay_count = 0;
> > +	sa->last_update_time = 0;
> > +	sa->period_contrib = 0;
> 
> sa->period_contrib = slice;

period_contrib should be strictly < 1024. I suppose sched_slice does not guarantee that.
So here I will give it 1023 to heavy the load.
 
> > +static __always_inline u64 decay_load64(u64 val, u64 n)
> > +{
> > +	if (likely(val <= UINT_MAX))
> > +		val = decay_load(val, n);
> > +	else {
> > +		/*
> > +		 * LOAD_AVG_MAX can last ~500ms (=log_2(LOAD_AVG_MAX)*32ms).
> > +		 * Since we have so big runnable load_avg, it is impossible
> > +		 * load_avg has not been updated for such a long time. So
> > +		 * LOAD_AVG_MAX is enough here.
> > +		 */
> 
> I mean, LOAD_AVG_MAX is irrelevant - the constant could just as well be
> 1<<20, or whatever, yes? In fact, if you're going to then turn it into a
> fraction of 1<<10, just do (with whatever temporaries you find most tasteful):
> 
> val *= (u32) decay_load(1 << 10, n);
> val >>= 10;
> 

LOAD_AVG_MAX is selected on purpose. The val arriving here specifies that it is really
big. So the decay_load may not decay it to 0 even period n is not small. If we use 1<<10
here, n=10*32 will decay it to 0, but val (larger than 1<<32) can survive.

But if even LOAD_AVG_MAX will decay to 0, it means in the current code, any runnable_avg_sum
will not survive, sicne LOAD_AVG_MAX is the upperbound.

> > +/*
> > + * Strictly, this se should use its parent cfs_rq's clock_task, but
> > + * here we use its own cfs_rq's for performance matter. But on load_avg
> > + * update, what we really care about is "the difference between two regular
> > + * clock reads", not absolute time, so the variation should be neglectable.
> > + */
> 
> Yes, but the difference between two clock reads can differ vastly
> depending on which clock you read - if cfs_rq was throttled, but
> parent_cfs_rq was not, reading cfs_rq's clock will give you no time
> passing. That said I think that's probably what you want for cfs_rq's
> load_avg, but is wrong for the group se, which probably needs to use its
> parent's.

Yes, then I think I may have to fall back to track group se load_avg alone.

> > +/* Update task and its cfs_rq load average */
> > +static inline void update_load_avg(struct sched_entity *se, int update_tg)
> >  {
> > +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > +	u64 now = cfs_rq_clock_task(cfs_rq);
> > +
> >  	/*
> > +	 * Track task load average for carrying it to new CPU after migrated
> >  	 */
> > +	if (entity_is_task(se))
> > +		__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
> >  
> > +	update_cfs_rq_load_avg(now, cfs_rq);
> >  
> > +	if (update_tg)
> > +		update_tg_load_avg(cfs_rq);
> >  }
> 
> I personally find this very confusing, in that update_load_avg is doing
> more to se->cfs_rq, and in fact on anything other than a task, it isn't
> touching the se at all (instead, it touches _se->parent_ even).
 
What is confusing? The naming?

About the overflow problem, maybe I can just fall back to do load_avg / 47742
for every update, then everything would be in nature the same range with the
current code.
