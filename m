Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3CTINC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:13:02 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52366 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CTIM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:12:58 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-7b-51496f8721b8
Date: Wed, 20 Mar 2013 17:13:21 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] sched: reset lb_env when redo in load_balance()
Message-ID: <20130320081321.GF11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-9-git-send-email-iamjoonsoo.kim@lge.com>
 <1363706483.22553.67.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363706483.22553.67.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 04:21:23PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> > So, now, When we redo in load_balance(), we should reset some fields of
> > lb_env to ensure that load_balance() works for initial cpu, not for other
> > cpus in its group. So correct it.
> > 
> > Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 70631e8..25c798c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5014,14 +5014,20 @@ static int load_balance(int this_cpu, struct rq *this_rq,
> >  
> >  	struct lb_env env = {
> >  		.sd		= sd,
> > -		.dst_cpu	= this_cpu,
> > -		.dst_rq		= this_rq,
> >  		.dst_grpmask    = dst_grp,
> >  		.idle		= idle,
> > -		.loop_break	= sched_nr_migrate_break,
> >  		.cpus		= cpus,
> >  	};
> >  
> > +	schedstat_inc(sd, lb_count[idle]);
> > +	cpumask_copy(cpus, cpu_active_mask);
> > +
> > +redo:
> > +	env.dst_cpu = this_cpu;
> > +	env.dst_rq = this_rq;
> > +	env.loop = 0;
> > +	env.loop_break = sched_nr_migrate_break;
> > +
> >  	/* For NEWLY_IDLE load_balancing, we don't need to consider
> >  	 * other cpus in our group */
> >  	if (idle == CPU_NEWLY_IDLE) {
> 
> OK, so this is the case where we tried to balance !this_cpu and found
> ALL_PINNED, right?
> 
> You can only get here in very weird cases where people love their
> sched_setaffinity() waaaaay too much, do we care? Why not give up?

Now that you mentioned it, I have no enough reason for this patch.
I think that giving up is more preferable to me.
I will omit this patch for next spin.

> 
> Also, looking at this, shouldn't we consider env->cpus in
> can_migrate_task() where we compute new_dst_cpu?

As previously stated, env-cpus is for src cpus, so when we decide dst_cpu,
it doesn't matter.

Really thanks for detailed review to all this patchset.
Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
