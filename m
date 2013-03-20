Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3CTGwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:52:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57123 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3CTGv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:51:59 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-15-51495c89323c
Date: Wed, 20 Mar 2013 15:52:18 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] sched: don't consider other cpus in our group in
 case of NEWLY_IDLE
Message-ID: <20130320065218.GB11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-4-git-send-email-iamjoonsoo.kim@lge.com>
 <1363702857.22553.50.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363702857.22553.50.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:20:57PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > Commit 88b8dac0 makes load_balance() consider other cpus in its group,
> > regardless of idle type. When we do NEWLY_IDLE balancing, we should not
> > consider it, because a motivation of NEWLY_IDLE balancing is to turn
> > this cpu to non idle state if needed. This is not the case of other cpus.
> > So, change code not to consider other cpus for NEWLY_IDLE balancing.
> > 
> > With this patch, assign 'if (pulled_task) this_rq->idle_stamp = 0'
> > in idle_balance() is corrected, because NEWLY_IDLE balancing doesn't
> > consider other cpus. Assigning to 'this_rq->idle_stamp' is now valid.
> > 
> > Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Fair enough, good catch.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 0c6aaf6..97498f4 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5016,8 +5016,15 @@ static int load_balance(int this_cpu, struct rq *this_rq,
> >  		.cpus		= cpus,
> >  	};
> >  
> > +	/* For NEWLY_IDLE load_balancing, we don't need to consider
> > +	 * other cpus in our group */
> > +	if (idle == CPU_NEWLY_IDLE) {
> > +		env.dst_grpmask = NULL;
> > +		max_lb_iterations = 0;
> 
> Just a small nit; I don't think we'll ever get to evaluate
> max_lb_iterations when !dst_grpmask. So strictly speaking its
> superfluous to touch it.

Okay. In next spin, I will remove it and add a comment here.

Thanks.

> 
> > +	} else {
> > +		max_lb_iterations = cpumask_weight(env.dst_grpmask);
> > +	}
> >  	cpumask_copy(cpus, cpu_active_mask);
> > -	max_lb_iterations = cpumask_weight(env.dst_grpmask);
> >  
> >  	schedstat_inc(sd, lb_count[idle]);
> >  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
