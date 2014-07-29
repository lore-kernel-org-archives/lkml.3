Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaG2JMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:12:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:48524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaG2JMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:12:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="scan'208";a="568818837"
Date: Tue, 29 Jul 2014 09:09:45 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729010945.GB5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728113939.GR6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728113939.GR6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 01:39:39PM +0200, Peter Zijlstra wrote:
> > -static inline void __update_group_entity_contrib(struct sched_entity *se)
> > +static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
> >  {
> > +	long delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
> >  
> > +	if (delta) {
> > +		atomic_long_add(delta, &cfs_rq->tg->load_avg);
> > +		cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
> >  	}
> >  }
> 
> We talked about this before, you made that an unconditional atomic op on
> an already hot line.
> 
> You need some words on why this isn't a problem. Either in a comment or
> in the Changelog. You cannot leave such changes undocumented.
 
I am all for not updating trivial delta, e.g., 1 or 2. I just had no theory
in selecting a "good" threshold.

The current code uses 1/8 or 1/64 of contrib. Though it is not fair comparison,
because how current tg load is calculated is a big story (no offense), I choose
1/64 as the threshold.

> > +#define subtract_until_zero(minuend, subtrahend)	\
> > +	(subtrahend < minuend ? minuend - subtrahend : 0)
> 
> WTH is a minuend or subtrahend? Are you a wordsmith in your spare time
> and like to make up your own words?
> 
> Also, isn't writing: x = max(0, x-y), far more readable to begin with?
> 

Ok. IIUC, max() does not handle minus number super good, and we don't need the type
overhead in max(), so still use my macro, but won't be wordsmith again, :)

> > +/*
> > + * Group cfs_rq's load_avg is used for task_h_load and update_cfs_share
> > + * calc.
> > + */
> > +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
> >  {
> > +	int decayed;
> >  
> > +	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> > +		long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> > +		cfs_rq->avg.load_avg = subtract_until_zero(cfs_rq->avg.load_avg, r);
> > +		r *= LOAD_AVG_MAX;
> > +		cfs_rq->avg.load_sum = subtract_until_zero(cfs_rq->avg.load_sum, r);
> >  	}
> >  
> > +	decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> >  
> > +#ifndef CONFIG_64BIT
> > +	if (cfs_rq->avg.last_update_time != cfs_rq->load_last_update_time_copy) {
> > +		smp_wmb();
> > +		cfs_rq->load_last_update_time_copy = cfs_rq->avg.last_update_time;
> > +	}
> > +#endif
> >  
> > +	return decayed;
> > +}
> 
> Its a bit unfortunate that we update the copy in another function than
> the original, but I think I see why you did that. But is it at all
> likely that we do not need to update? That is, does that compare make
> any sense?

I think we can assume last_update_time will mostly be changed, because it won't be
changed only in two cases: 1) minus delta time, 2) within a period, 1ms, these two
cases seemingly are minority. So yes, we can save the compare.

