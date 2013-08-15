Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3HOMem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:34:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51982 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3HOMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:34:41 -0400
Date: Thu, 15 Aug 2013 14:34:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130815123422.GT24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:36:42PM +0900, Joonsoo Kim wrote:
> -	if (local_group)
> -		balance_cpu = group_balance_cpu(group);
> -

>  		/* Bias balancing toward cpus of our domain */
> -		if (local_group) {
> -			if (idle_cpu(i) && !first_idle_cpu &&
> -					cpumask_test_cpu(i, sched_group_mask(group))) {
> -				first_idle_cpu = 1;
> -				balance_cpu = i;
> -			}
> -
>  			load = target_load(i, load_idx);
> -		} else {

>  
> -	/*
> -	 * First idle cpu or the first cpu(busiest) in this sched group
> -	 * is eligible for doing load balancing at this and above
> -	 * domains. In the newly idle case, we will allow all the cpu's
> -	 * to do the newly idle load balance.
> -	 */
> -	if (local_group) {
> -		if (env->idle != CPU_NEWLY_IDLE) {
> -			if (balance_cpu != env->dst_cpu) {
> -				*balance = 0;
> -				return;
> -			}
> -			update_group_power(env->sd, env->dst_cpu);
> -		} else if (time_after_eq(jiffies, group->sgp->next_update))
> -			update_group_power(env->sd, env->dst_cpu);
> -	}

>  		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));

> +static int should_we_balance(struct lb_env *env)
> +{
> +	struct sched_group *sg = env->sd->groups;
> +	struct cpumask *sg_cpus, *sg_mask;
> +	int cpu, balance_cpu = -1;
> +
> +	/*
> +	 * In the newly idle case, we will allow all the cpu's
> +	 * to do the newly idle load balance.
> +	 */
> +	if (env->idle == CPU_NEWLY_IDLE)
> +		return 1;
> +
> +	sg_cpus = sched_group_cpus(sg);
> +	sg_mask = sched_group_mask(sg);
> +	/* Try to find first idle cpu */
> +	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
> +		if (!cpumask_test_cpu(cpu, sg_mask) || idle_cpu(cpu))

Did you want to write !idle_cpu() ?

> +			continue;
> +
> +		balance_cpu = cpu;
> +		break;
> +	}
> +
> +	if (balance_cpu == -1)
> +		balance_cpu = group_balance_cpu(sg);
> +
> +	/*
> +	 * First idle cpu or the first cpu(busiest) in this sched group
> +	 * is eligible for doing load balancing at this and above domains.
> +	 */
> +	return balance_cpu != env->dst_cpu;
> +}


