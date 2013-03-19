Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3CSPVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:21:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55200
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab3CSPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:21:35 -0400
Message-ID: <1363706483.22553.67.camel@laptop>
Subject: Re: [PATCH 8/8] sched: reset lb_env when redo in load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 16:21:23 +0100
In-Reply-To: <1360820921-2513-9-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-9-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> So, now, When we redo in load_balance(), we should reset some fields of
> lb_env to ensure that load_balance() works for initial cpu, not for other
> cpus in its group. So correct it.
> 
> Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 70631e8..25c798c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5014,14 +5014,20 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  
>  	struct lb_env env = {
>  		.sd		= sd,
> -		.dst_cpu	= this_cpu,
> -		.dst_rq		= this_rq,
>  		.dst_grpmask    = dst_grp,
>  		.idle		= idle,
> -		.loop_break	= sched_nr_migrate_break,
>  		.cpus		= cpus,
>  	};
>  
> +	schedstat_inc(sd, lb_count[idle]);
> +	cpumask_copy(cpus, cpu_active_mask);
> +
> +redo:
> +	env.dst_cpu = this_cpu;
> +	env.dst_rq = this_rq;
> +	env.loop = 0;
> +	env.loop_break = sched_nr_migrate_break;
> +
>  	/* For NEWLY_IDLE load_balancing, we don't need to consider
>  	 * other cpus in our group */
>  	if (idle == CPU_NEWLY_IDLE) {

OK, so this is the case where we tried to balance !this_cpu and found
ALL_PINNED, right?

You can only get here in very weird cases where people love their
sched_setaffinity() waaaaay too much, do we care? Why not give up?

Also, looking at this, shouldn't we consider env->cpus in
can_migrate_task() where we compute new_dst_cpu?

