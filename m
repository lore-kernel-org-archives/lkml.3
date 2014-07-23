Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaGWHmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:42:23 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49855 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbaGWHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140722144559.382c5243@annuminas.surriel.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 23 Jul 2014 09:41:55 +0200
Message-ID: <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2014 20:45, Rik van Riel <riel@redhat.com> wrote:
> Currently update_sd_pick_busiest only returns true when an sd
> is overloaded, or for SD_ASYM_PACKING when a domain is busier
> than average and a higher numbered domain than the target.
>
> This breaks load balancing between domains that are not overloaded,
> in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
> return true when the busiest sd yet is encountered.
>
> On a 4 node system, this seems to result in the load balancer finally
> putting 1 thread of a 4 thread test run of "perf bench numa mem" on
> each node, where before the load was generally not spread across all
> nodes.
>
> Behaviour for SD_ASYM_PACKING does not seem to match the comment,
> in that groups with below average load average are ignored, but I
> have no hardware to test that so I have left the behaviour of that
> code unchanged.
>
> Cc: mikey@neuling.org
> Cc: peterz@infradead.org
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fea7d33..ff4ddba 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5942,16 +5942,20 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>          * numbered CPUs in the group, therefore mark all groups
>          * higher than ourself as busy.
>          */
> -       if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
> -           env->dst_cpu < group_first_cpu(sg)) {
> -               if (!sds->busiest)
> -                       return true;
> +       if (env->sd->flags & SD_ASYM_PACKING) {
> +               if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
> +                       if (!sds->busiest)
> +                               return true;
>
> -               if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
> -                       return true;
> +                       if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
> +                               return true;
> +               }
> +
> +               return false;
>         }
>
> -       return false;
> +       /* See above: sgs->avg_load > sds->busiest_stat.avg_load */
> +       return true;

Hi Rik,

I can see one issue with a default return set to true.  You increase
the number of time where we will not effectively migrate a task
because we don't ensure that we will take the overloaded group if
there is one. We can be in a situation where a group is overloaded but
the load_balance will select a not overloaded group with an average
load higher than sched_domain average value just because it is checked
after.

Regarding your issue with "perf bench numa mem" that is not spread on
all nodes, SD_PREFER_SIBLING flag (of DIE level) should do the job by
reducing the capacity of  "not local DIE" group at NUMA level to 1
task during the load balance computation. So you should have 1 task
per sched_group at NUMA level.

Vincent


>  }
>
>  #ifdef CONFIG_NUMA_BALANCING
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
