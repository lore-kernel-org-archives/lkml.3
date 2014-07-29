Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaG2JFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:05:14 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:38532 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaG2JFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:05:11 -0400
MIME-Version: 1.0
In-Reply-To: <1406571388-3227-2-git-send-email-riel@redhat.com>
References: <1406571388-3227-1-git-send-email-riel@redhat.com> <1406571388-3227-2-git-send-email-riel@redhat.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 29 Jul 2014 11:04:50 +0200
Message-ID: <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2014 20:16,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> There are several ways in which update_sd_pick_busiest can end up
> picking an sd as "busiest" that has a below-average per-cpu load.
>
> All of those could use the same correction that was previously only
> applied when the selected group has a group imbalance.
>
> Additionally, the load balancing code will balance out the load between
> domains that are below their maximum capacity. This results in the
> load_above_capacity calculation underflowing, creating a giant unsigned
> number, which is then removed by the min() check below.

The load_above capacity can't underflow with current version. The
underflow that you mention above, could occur with the change you are
doing in patch 2 which can select a group which not overloaded nor
imbalanced.

>
> In situations where all the domains are overloaded, or where only the
> busiest domain is overloaded, that code is also superfluous, since
> the normal env->imbalance calculation will figure out how much to move.
> Remove the load_above_capacity calculation.

IMHO, we should not remove that part which is used by prefer_sibling

Originally, we had 2 type of busiest group: overloaded or imbalanced.
You add a new one which has only a avg_load higher than other so you
should handle this new case and keep the other ones unchanged

>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 33 ++++++++-------------------------
>  1 file changed, 8 insertions(+), 25 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 45943b2..a28bb3b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6221,16 +6221,16 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>   */
>  static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>  {
> -       unsigned long max_pull, load_above_capacity = ~0UL;
>         struct sg_lb_stats *local, *busiest;
>
>         local = &sds->local_stat;
>         busiest = &sds->busiest_stat;
>
> -       if (busiest->group_imb) {
> +       if (busiest->avg_load <= sds->avg_load) {

busiest->avg_load <= sds->avg_load is already handled in the
fix_small_imbalance function, you should probably handle that here

>                 /*
> -                * In the group_imb case we cannot rely on group-wide averages
> -                * to ensure cpu-load equilibrium, look at wider averages. XXX
> +                * Busiest got picked because it is overloaded or imbalanced,
> +                * but does not have an above-average load. Look at wider
> +                * averages.
>                  */
>                 busiest->load_per_task =
>                         min(busiest->load_per_task, sds->avg_load);
> @@ -6247,32 +6247,15 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>                 return fix_small_imbalance(env, sds);
>         }
>
> -       if (!busiest->group_imb) {
> -               /*
> -                * Don't want to pull so many tasks that a group would go idle.
> -                * Except of course for the group_imb case, since then we might
> -                * have to drop below capacity to reach cpu-load equilibrium.
> -                */
> -               load_above_capacity =
> -                       (busiest->sum_nr_running - busiest->group_capacity_factor);
> -
> -               load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
> -               load_above_capacity /= busiest->group_capacity;
> -       }
> -
>         /*
>          * We're trying to get all the cpus to the average_load, so we don't
>          * want to push ourselves above the average load, nor do we wish to
> -        * reduce the max loaded cpu below the average load. At the same time,
> -        * we also don't want to reduce the group load below the group capacity
> -        * (so that we can implement power-savings policies etc). Thus we look
> -        * for the minimum possible imbalance.
> +        * reduce the max loaded cpu below the average load.
> +        * The per-cpu avg_load values and the group capacity determine
> +        * how much load to move to equalise the imbalance.
>          */
> -       max_pull = min(busiest->avg_load - sds->avg_load, load_above_capacity);
> -
> -       /* How much load to actually move to equalise the imbalance */
>         env->imbalance = min(
> -               max_pull * busiest->group_capacity,
> +               (busiest->avg_load - sds->avg_load) * busiest->group_capacity,
>                 (sds->avg_load - local->avg_load) * local->group_capacity
>         ) / SCHED_CAPACITY_SCALE;
>
> --
> 1.9.3
>
