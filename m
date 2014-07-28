Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaG1IX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:23:28 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:65166 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1IX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:23:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140725153210.47c09bfe@annuminas.surriel.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <20140725152728.GB6758@twins.programming.kicks-ass.net> <53D27B7E.8090404@redhat.com>
 <20140725160549.GD6758@twins.programming.kicks-ass.net> <53D28457.202@redhat.com>
 <CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com> <20140725153210.47c09bfe@annuminas.surriel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 28 Jul 2014 10:23:06 +0200
Message-ID: <CAKfTPtCoH00jdz-Qkns_j7LNyorWc+GQXj-WSmdDGcooWOMW7w@mail.gmail.com>
Subject: Re: [PATCH v2] sched: make update_sd_pick_busiest return true on a
 busier sd
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 21:32, Rik van Riel <riel@redhat.com> wrote:
> Subject: sched: make update_sd_pick_busiest return true on a busier sd
>
> Currently update_sd_pick_busiest only identifies the busiest sd
> that is either overloaded, or has a group imbalance. When no
> sd is imbalanced or overloaded, the load balancer fails to find
> the busiest domain.
>
> This breaks load balancing between domains that are not overloaded,
> in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
> return true when the busiest sd yet is encountered.
>
> Behaviour for SD_ASYM_PACKING does not seem to match the comment,
> but I have no hardware to test that so I have left the behaviour
> of that code unchanged.
>
> It is unclear what to do with the group_imb condition.
> Should group_imb override a busier load? If so, should we fix

IMHO, group_imb should have a lower priority compared to overloaded
group because it generates active migration whereas the use of
overloaded group could solve the imbalance with normal migration
Then, AFAICT, we already have a special way to compute imbalance when
group_imb is set

> calculate_imbalance to return a sensible number when the "busiest"
> node found has a below average load? We probably need to fix
> calculate_imbalance anyway, to deal with an overloaded group that
> happens to have a below average load...
>
> Cc: mikey@neuling.org
> Cc: peterz@infradead.org
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 45943b2..c96044f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5949,6 +5949,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>                 sgs->group_has_free_capacity = 1;
>  }
>
> +static bool group_overloaded(struct sg_lb_stats *sgs)
> +{
> +       return sgs->sum_nr_running > sgs->group_capacity_factor;
> +}
> +
>  /**
>   * update_sd_pick_busiest - return 1 on busiest group
>   * @env: The load balancing environment.
> @@ -5957,7 +5962,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>   * @sgs: sched_group statistics
>   *
>   * Determine if @sg is a busier group than the previously selected
> - * busiest group.
> + * busiest group.
>   *
>   * Return: %true if @sg is a busier group than the previously selected
>   * busiest group. %false otherwise.
> @@ -5967,13 +5972,17 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>                                    struct sched_group *sg,
>                                    struct sg_lb_stats *sgs)
>  {
> +       if (group_overloaded(sgs) && !group_overloaded(&sds->busiest_stat))

The 1st time you run update_sd_pick_busiest, group_capacity_factor and
sum_nr_running of sds->busiest_stat are uninitialized.

> +               return true;
> +

IIUC your new test sequence, you haven't solved the following use case:

group A has 3 tasks and is overloaded
group B has 2 tasks and is not overloaded but its avg_load is higher
than group B (either because of nice priority or because of average
runnable time)

The test of group A will return true because it is overloaded and not
the empty busiest_stat
But, the test of group B will also return true because of
!(env->sd->flags & SD_ASYM_PACKING)

So at the end you are selecting the group B which is  not overloaded

>         if (sgs->avg_load <= sds->busiest_stat.avg_load)
>                 return false;
>
> -       if (sgs->sum_nr_running > sgs->group_capacity_factor)
> +       if (sgs->group_imb)
>                 return true;
>
> -       if (sgs->group_imb)
> +       /* This is the busiest node. */
> +       if (!(env->sd->flags & SD_ASYM_PACKING))
>                 return true;
>
>         /*
> @@ -5981,8 +5990,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>          * numbered CPUs in the group, therefore mark all groups
>          * higher than ourself as busy.
>          */
> -       if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
> -           env->dst_cpu < group_first_cpu(sg)) {
> +       if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
>                 if (!sds->busiest)
>                         return true;
>
>
