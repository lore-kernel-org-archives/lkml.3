Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbaKUMgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:36:33 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36613 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaKUMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:36:31 -0500
Date: Fri, 21 Nov 2014 12:37:19 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 08/10] sched: replace capacity_factor by usage
Message-ID: <20141121123719.GH23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:45PM +0000, Vincent Guittot wrote:
> The scheduler tries to compute how many tasks a group of CPUs can handle by
> assuming that a task's load is SCHED_LOAD_SCALE and a CPU's capacity is
> SCHED_CAPACITY_SCALE. group_capacity_factor divides the capacity of the group
> by SCHED_LOAD_SCALE to estimate how many task can run in the group. Then, it
> compares this value with the sum of nr_running to decide if the group is
> overloaded or not. But the group_capacity_factor is hardly working for SMT
>  system, it sometimes works for big cores but fails to do the right thing for
>  little cores.
> 
> Below are two examples to illustrate the problem that this patch solves:
> 
> 1- If the original capacity of a CPU is less than SCHED_CAPACITY_SCALE
> (640 as an example), a group of 3 CPUS will have a max capacity_factor of 2
> (div_round_closest(3x640/1024) = 2) which means that it will be seen as
> overloaded even if we have only one task per CPU.
> 
> 2 - If the original capacity of a CPU is greater than SCHED_CAPACITY_SCALE
> (1512 as an example), a group of 4 CPUs will have a capacity_factor of 4
> (at max and thanks to the fix [0] for SMT system that prevent the apparition
> of ghost CPUs) but if one CPU is fully used by rt tasks (and its capacity is
> reduced to nearly nothing), the capacity factor of the group will still be 4
> (div_round_closest(3*1512/1024) = 5 which is cap to 4 with [0]).
> 
> So, this patch tries to solve this issue by removing capacity_factor and
> replacing it with the 2 following metrics :
> -The available CPU's capacity for CFS tasks which is already used by
>  load_balance.
> -The usage of the CPU by the CFS tasks. For the latter, utilization_avg_contrib
> has been re-introduced to compute the usage of a CPU by CFS tasks.
> 
> group_capacity_factor and group_has_free_capacity has been removed and replaced
> by group_no_capacity. We compare the number of task with the number of CPUs and
> we evaluate the level of utilization of the CPUs to define if a group is
> overloaded or if a group has capacity to handle more tasks.
> 
> For SD_PREFER_SIBLING, a group is tagged overloaded if it has more than 1 task
> so it will be selected in priority (among the overloaded groups). Since [1],
> SD_PREFER_SIBLING is no more concerned by the computation of load_above_capacity
> because local is not overloaded.

[...]

> @@ -6213,17 +6207,20 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
> 
>                 /*
>                  * In case the child domain prefers tasks go to siblings
> -                * first, lower the sg capacity factor to one so that we'll try
> +                * first, lower the sg capacity so that we'll try
>                  * and move all the excess tasks away. We lower the capacity
>                  * of a group only if the local group has the capacity to fit
> -                * these excess tasks, i.e. nr_running < group_capacity_factor. The
> -                * extra check prevents the case where you always pull from the
> -                * heaviest group when it is already under-utilized (possible
> -                * with a large weight task outweighs the tasks on the system).
> +                * these excess tasks. The extra check prevents the case where
> +                * you always pull from the heaviest group when it is already
> +                * under-utilized (possible with a large weight task outweighs
> +                * the tasks on the system).
>                  */
>                 if (prefer_sibling && sds->local &&
> -                   sds->local_stat.group_has_free_capacity)
> -                       sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
> +                   group_has_capacity(env, &sds->local_stat) &&
> +                   (sgs->sum_nr_running > 1)) {
> +                       sgs->group_no_capacity = 1;
> +                       sgs->group_type = group_overloaded;
> +               }

I'm still a bit confused about SD_PREFER_SIBLING. What is the flag
supposed to do and why?

It looks like a weak load balancing bias attempting to consolidate tasks
on domains with spare capacity. It does so by marking non-local groups
as overloaded regardless of their actual load if the local group has
spare capacity. Correct?

In patch 9 this behaviour is enabled for SMT level domains, which
implies that tasks will be consolidated in MC groups, that is we prefer
multiple tasks on sibling cpus (hw threads). I must be missing something
essential. I was convinced that we wanted to avoid using sibling cpus on
SMT systems as much as possible?

