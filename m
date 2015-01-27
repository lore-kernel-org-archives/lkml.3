Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbbA0OSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:18:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbbA0OSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:18:13 -0500
Date: Tue, 27 Jan 2015 15:18:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] sched/rt: Consider deadline tasks in cpupri_find()
Message-ID: <20150127141804.GB24151@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-4-git-send-email-pang.xunlei@linaro.org>
 <20150127125859.GD21418@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127125859.GD21418@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 01:58:59PM +0100, Peter Zijlstra wrote:
> > @@ -103,24 +104,11 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
> >  		if (skip)
> >  			continue;
> >  
> > -		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
> > +		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
> > +		cpumask_and(lowest_mask, lowest_mask, cp->cpudl->free_cpus);
> > +		if (cpumask_any(lowest_mask) >= nr_cpu_ids)
> >  			continue;
> >  


> > +++ b/kernel/sched/rt.c
> > @@ -1349,14 +1349,17 @@ out:
> >  	return cpu;
> >  }
> >  
> > +static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
> >  static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
> >  {
> > +	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
> > +
> >  	/*
> >  	 * Current can't be migrated, useless to reschedule,
> >  	 * let's hope p can move out.
> >  	 */
> >  	if (rq->curr->nr_cpus_allowed == 1 ||
> > -	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
> > +	    !cpupri_find(&rq->rd->cpupri, rq->curr, lowest_mask))
> >  		return;
> >  
> >  	/*
> 
> 
> Again; should you not put something useful in the mask before you pass
> it to cpupri_find()?

Similar to the other case; I can't read today. I only saw the
_and(lowest_mask, lowest_mask, ...) and figured it ought to be populated
before that.
