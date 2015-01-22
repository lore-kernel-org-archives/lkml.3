Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbbAVRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:49:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:44968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbbAVRtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:49:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="674285732"
Message-ID: <1421948918.2399.42.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH] Repost sched-rt: Reduce rq lock contention by
 eliminating locking of non-feasible target
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 09:48:38 -0800
In-Reply-To: <1421430374.2399.27.camel@schen9-desk2.jf.intel.com>
References: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
	 <20150115205837.22075a58@grimm.local.home>
	 <1421430374.2399.27.camel@schen9-desk2.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 09:46 -0800, Tim Chen wrote:
> On Thu, 2015-01-15 at 20:58 -0500, Steven Rostedt wrote:
> 
> > 
> > Please add a comment here that says something like:
> > 
> > 		/*
> > 		 * Don't bother moving it if the destination CPU is
> > 		 * not running a lower priority task.
> > 		 */
> > 
> Okay.  Updated in patch below.
> 
> > > -		if (target != -1)
> > > +		if (target != -1 &&
> > > +		    p->prio < cpu_rq(target)->rt.highest_prio.curr)
> > >  			cpu = target;
> > >  	}
> > >  	rcu_read_unlock();
> > > @@ -1613,6 +1614,12 @@ static struct rq *find_lock_lowest_rq(struct
> > > task_struct *task, struct rq *rq) break;
> > >  
> > >  		lowest_rq = cpu_rq(cpu);
> > > +		
> > > +		if (lowest_rq->rt.highest_prio.curr <= task->prio) {
> > > +		/* target rq has tasks of equal or higher priority,
> > > try again */
> > > +			lowest_rq = NULL;
> > > +			continue;
> > 
> > This should just break out and not try again. The reason for the other
> > try again is because of the double_lock which can release the locks
> > which can cause a process waiting for the lock to sneak in and
> > change the priorities. But this case, a try again is highly unlikely to
> > do anything differently (no locks are released) and just waste cycles.
> 
> Agree.  Updated in updated patch below.
> 
> Thanks.
> 
> Tim
> 

Steven and Peter, are you okay with the updated patch?

Thanks.

Tim


> ---->8------
> 
> From 5f676f7a351e85eb5cc64f1971dd03eca43b5271 Mon Sep 17 00:00:00 2001
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Date: Fri, 12 Dec 2014 15:38:12 -0800
> Subject: [PATCH] sched-rt: Reduce rq lock contention by eliminating
> locking of
>  non-feasible target
> To: Peter Zijlstra <peterz@infradead.org>
> Cc: Andi Kleen <andi@firstfloor.org>,  Ingo Molnar <mingo@elte.hu>,
> Shawn Bohrer <sbohrer@rgmadvisors.com>, Steven Rostedt
> <rostedt@goodmis.org>, Suruchi Kadu <suruchi.a.kadu@intel.com>, Doug
> Nelson <doug.nelson@intel.com>,  linux-kernel@vger.kernel.org
> 
> This patch added checks that prevent futile attempts to move rt tasks
> to cpu with active tasks of equal or higher priority.  This reduces
> run queue lock contention and improves the performance of a well
> known OLTP benchmark by 0.7%.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  kernel/sched/rt.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index ee15f5a..46ebcb1 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1337,7 +1337,12 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	     curr->prio <= p->prio)) {
>  		int target = find_lowest_rq(p);
>  
> -		if (target != -1)
> +		/*
> +		 * Don't bother moving it if the destination CPU is
> +		 * not running a lower priority task.
> +		 */
> +		if (target != -1 &&
> +		    p->prio < cpu_rq(target)->rt.highest_prio.curr)
>  			cpu = target;
>  	}
>  	rcu_read_unlock();
> @@ -1614,6 +1619,16 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  
>  		lowest_rq = cpu_rq(cpu);
>  
> +		if (lowest_rq->rt.highest_prio.curr <= task->prio) {
> +			/*
> +			 * Target rq has tasks of equal or higher priority,
> +			 * retrying does not release any lock and is unlikely
> +			 * to yield a different result.
> +			 */
> +			lowest_rq = NULL;
> +			break;
> +		}
> +
>  		/* if the prio of this runqueue changed, try again */
>  		if (double_lock_balance(rq, lowest_rq)) {
>  			/*


