Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbbAFTag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:30:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:56403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbbAFTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:30:33 -0500
Date: Tue, 6 Jan 2015 20:30:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] Repost sched-rt: Reduce rq lock contention by
 eliminating locking of non-feasible target
Message-ID: <20150106193025.GD23965@worktop.programming.kicks-ass.net>
References: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:01:51AM -0800, Tim Chen wrote:
> Didn't get any response for this patch probably due to the holidays.
> Reposting it as we will like to get it merged to help our database
> workload.
> 
> This patch added checks that prevent futile attempts to move rt tasks
> to cpu with active tasks of equal or higher priority.  This reduces
> run queue lock contention and improves the performance of a well
> known OLTP benchmark by 0.7%.

Don't immediately see anything wrong with this, Steve?

Juri, do we want to do a similar thing to the dl bits?

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  kernel/sched/rt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index ee15f5a..0e4382e 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1337,7 +1337,8 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	     curr->prio <= p->prio)) {
>  		int target = find_lowest_rq(p);
>  
> -		if (target != -1)
> +		if (target != -1 &&
> +		    p->prio < cpu_rq(target)->rt.highest_prio.curr)
>  			cpu = target;
>  	}
>  	rcu_read_unlock();
> @@ -1613,6 +1614,12 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  			break;
>  
>  		lowest_rq = cpu_rq(cpu);
> +		
> +		if (lowest_rq->rt.highest_prio.curr <= task->prio) {
> +		/* target rq has tasks of equal or higher priority, try again */
> +			lowest_rq = NULL;
> +			continue;
> +		}
>  
>  		/* if the prio of this runqueue changed, try again */
>  		if (double_lock_balance(rq, lowest_rq)) {
> -- 
> 1.8.3.1
> 
> 
