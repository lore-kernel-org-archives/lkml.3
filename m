Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaFWJm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:42:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFWJm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:42:57 -0400
Date: Mon, 23 Jun 2014 11:42:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
Message-ID: <20140623094251.GS19860@laptop.programming.kicks-ass.net>
References: <53A11A89.5000602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A11A89.5000602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:50:17PM +0800, Michael wang wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fea7d33..e1381cd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4409,6 +4409,62 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  	return idlest;
>  }
>  
> +static inline int tg_idle_cpu(struct task_group *tg, int cpu)
> +{
> +	return !tg->cfs_rq[cpu]->nr_running;
> +}
> +
> +/*
> + * Try and locate an idle CPU in the sched_domain from tg's view.
> + *
> + * Although gathered on same CPU and spread accross CPUs could make
> + * no difference from highest group's view, this will cause the tasks
> + * starving, even they have enough share to fight for CPU, they only
> + * got one battle filed, which means whatever how big their weight is,
> + * they totally got one CPU at maximum.
> + *
> + * Thus when system is busy, we filtered out those tasks which couldn't
> + * gain help from balance routine, and try to balance them internally
> + * by this func, so they could stand a chance to show their power.
> + *
> + */
> +static int tg_idle_sibling(struct task_struct *p, int target)
> +{
> +	struct sched_domain *sd;
> +	struct sched_group *sg;
> +	int i = task_cpu(p);
> +	struct task_group *tg = task_group(p);
> +
> +	if (tg_idle_cpu(tg, target))
> +		goto done;
> +
> +	sd = rcu_dereference(per_cpu(sd_llc, target));
> +	for_each_lower_domain(sd) {
> +		sg = sd->groups;
> +		do {
> +			if (!cpumask_intersects(sched_group_cpus(sg),
> +						tsk_cpus_allowed(p)))
> +				goto next;
> +
> +			for_each_cpu(i, sched_group_cpus(sg)) {
> +				if (i == target || !tg_idle_cpu(tg, i))
> +					goto next;
> +			}
> +
> +			target = cpumask_first_and(sched_group_cpus(sg),
> +					tsk_cpus_allowed(p));
> +
> +			goto done;
> +next:
> +			sg = sg->next;
> +		} while (sg != sd->groups);
> +	}
> +
> +done:
> +
> +	return target;
> +}

Still completely hate this, it doesn't make sense conceptual sense what
so ever.
