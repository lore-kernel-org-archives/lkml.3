Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3DVL76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:59:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3DVL74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:59:56 -0400
Message-ID: <1366631994.4443.13.camel@laptop>
Subject: Re: [PATCH v2 6/6] sched: prevent to re-select dst-cpu in
 load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 13:59:54 +0200
In-Reply-To: <1364277700-7509-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364277700-7509-7-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:01 +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> But, in that, there is no code for preventing to re-select dst-cpu.
> So, same dst-cpu can be selected over and over.
> 
> This patch add functionality to load_balance() in order to exclude
> cpu which is selected once. We prevent to re-select dst_cpu via
> env's cpus, so now, env's cpus is a candidate not only for src_cpus,
> but also dst_cpus.

Changelog forgets to mention that this removes the need for
lb_iterations.

> Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e3f09f4..6f238d2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

> @@ -3898,12 +3898,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
>  		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
>  			return 0;
>  
> -		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
> -						tsk_cpus_allowed(p));
> -		if (new_dst_cpu < nr_cpu_ids) {
> -			env->flags |= LBF_SOME_PINNED;
> -			env->new_dst_cpu = new_dst_cpu;
> -		}
> +		/* Prevent to re-select dst_cpu via env's cpus */
> +		for_each_cpu_and(cpu, env->dst_grpmask, env->cpus)
> +			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) {
> +				env->flags |= LBF_SOME_PINNED;
> +				env->new_dst_cpu = cpu;
> +				break;
> +			}

/me hands you a fresh bucket of curlies.. always use them on multi-line
single statements.

>  		return 0;
>  	}
>  
> @@ -4989,7 +4991,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  			int *balance)
>  {
>  	int ld_moved, cur_ld_moved, active_balance = 0;
> -	int lb_iterations, max_lb_iterations;
>  	struct sched_group *group;
>  	struct rq *busiest;
>  	unsigned long flags;
> @@ -5009,11 +5010,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  	 * other cpus in our group */
>  	if (idle == CPU_NEWLY_IDLE) {
>  		env.dst_grpmask = NULL;
> -		/* we don't care max_lb_iterations in this case,
> -		 * in following patch, this will be removed */
> -		max_lb_iterations = 0;
> -	} else {
> -		max_lb_iterations = cpumask_weight(env.dst_grpmask);
>  	}

And here you leave curlies around a single line single statement (the
only case we do leave them off) -- maybe collect them to replenish your
supply?

>  	cpumask_copy(cpus, cpu_active_mask);
>  


