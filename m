Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbbAPB6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:58:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:49184 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752711AbbAPB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:58:24 -0500
Date: Thu, 15 Jan 2015 20:58:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Repost sched-rt: Reduce rq lock contention by
 eliminating locking of non-feasible target
Message-ID: <20150115205837.22075a58@grimm.local.home>
In-Reply-To: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
References: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 11:01:51 -0800
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Didn't get any response for this patch probably due to the holidays.
> Reposting it as we will like to get it merged to help our database
> workload.
> 
> This patch added checks that prevent futile attempts to move rt tasks
> to cpu with active tasks of equal or higher priority.  This reduces
> run queue lock contention and improves the performance of a well
> known OLTP benchmark by 0.7%.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  kernel/sched/rt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index ee15f5a..0e4382e 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1337,7 +1337,8 @@ select_task_rq_rt(struct task_struct *p, int
> cpu, int sd_flag, int flags) curr->prio <= p->prio)) {
>  		int target = find_lowest_rq(p);
> 

Please add a comment here that says something like:

		/*
		 * Don't bother moving it if the destination CPU is
		 * not running a lower priority task.
		 */

> -		if (target != -1)
> +		if (target != -1 &&
> +		    p->prio < cpu_rq(target)->rt.highest_prio.curr)
>  			cpu = target;
>  	}
>  	rcu_read_unlock();
> @@ -1613,6 +1614,12 @@ static struct rq *find_lock_lowest_rq(struct
> task_struct *task, struct rq *rq) break;
>  
>  		lowest_rq = cpu_rq(cpu);
> +		
> +		if (lowest_rq->rt.highest_prio.curr <= task->prio) {
> +		/* target rq has tasks of equal or higher priority,
> try again */
> +			lowest_rq = NULL;
> +			continue;

This should just break out and not try again. The reason for the other
try again is because of the double_lock which can release the locks
which can cause a process waiting for the lock to sneak in and
change the priorities. But this case, a try again is highly unlikely to
do anything differently (no locks are released) and just waste cycles.

-- Steve


> +		}
>  
>  		/* if the prio of this runqueue changed, try again */
>  		if (double_lock_balance(rq, lowest_rq)) {

