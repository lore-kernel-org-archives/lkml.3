Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaLRJmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:42:15 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:58557 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaLRJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <1417529192-11579-3-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com> <1417529192-11579-3-git-send-email-morten.rasmussen@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 18 Dec 2014 10:41:51 +0100
Message-ID: <CAKfTPtDO-SiY0VQ83SwULnDsR0cGtPgAPaL+PLHha74Xh7_APw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/10] sched: Make usage and load tracking cpu scale-invariant
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Michael Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 15:06, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
>
> Besides the existing frequency scale-invariance correction factor, apply
> cpu scale-invariance correction factor to usage and load tracking.
>
> Cpu scale-invariance takes cpu performance deviations due to
> micro-architectural differences (i.e. instructions per seconds) between
> cpus in HMP systems (e.g. big.LITTLE) and differences in the frequency
> value of the highest OPP between cpus in SMP systems into consideration.
>
> Each segment of the sched_avg::{running_avg_sum, runnable_avg_sum}
> geometric series is now scaled by the cpu performance factor too so the
> sched_avg::{utilization_avg_contrib, load_avg_contrib} of each entity will
> be invariant from the particular cpu of the HMP/SMP system it is gathered
> on. As a result, cfs_rq::runnable_load_avg which is the sum of
> sched_avg::load_avg_contrib, becomes cpu scale-invariant too.
>
> So the {usage, load} level that is returned by {get_cpu_usage,
> weighted_cpuload} stays relative to the max cpu performance of the system.

Having a load/utilization that is invariant across the system is a
good thing but your patch only do part of the job. The load is
invariant so they can be directly compared across system but you
haven't updated the load balance code that also scales the load with
capacity.

Then, the task load is now cap by the max capacity of the CPU on which
it runs. Let use an example made of 3 CPUs with the following
topology:
-CPU0 and CPU1 are in the same cluster 0 (share cache) and have a
capacity of 512 each
-CPU2 is in its own cluster (don't share cache with other) and have a
capacity of 1024
Each cluster have thee same compute capacity of 1024

Then, let consider that we have 7 always running tasks with the
following placement:
-tasks A and B on CPU0
-tasks C, D on CPU1
-tasks F, G and H on CPU2

At cluster level with have the following statistic:
-On cluster 0, compute capacity budget for each task is 256 (2 * 512 /
4) and the cluster load is 4096 with current implementation and 2048
with cpu invariant load tracking
-On custer 1, compute capacity budget for each task is 341 (1024 / 3)
and the cluster load is 3072 with both implementation

The cluster 0 is more loaded than cluster 1 as the compute capacity
available for each task is lower than on cluster 1. The trends is
similar with current implementation of load tracking as we have a load
of 4096 for cluster 0 vs 3072 for cluster 1 but the cpu invariant load
tracking shows an different trend with a load of 2048 for cluster 0 vs
3072 for cluster 1

Considering that adding cpu invariance in the load tracking implies
more modification of the load balance, it might be worth reordering
your patchset and move this patch at the end instead of the beginning
so other patches might be merged while fixing the load balance

Regards,
Vincent

>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> ---
>  kernel/sched/fair.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b41f03d..5c4c989 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2473,6 +2473,21 @@ static u32 __compute_runnable_contrib(u64 n)
>  }
>
>  unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu);
> +unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu);
> +
> +static unsigned long contrib_scale_factor(int cpu)
> +{
> +       unsigned long scale_factor;
> +
> +       scale_factor = arch_scale_freq_capacity(NULL, cpu);
> +       scale_factor *= arch_scale_cpu_capacity(NULL, cpu);
> +       scale_factor >>= SCHED_CAPACITY_SHIFT;
> +
> +       return scale_factor;
> +}
> +
> +#define scale_contrib(contrib, scale_factor) \
> +       ((contrib * scale_factor) >> SCHED_CAPACITY_SHIFT)
>
>  /*
>   * We can represent the historical contribution to runnable average as the
> @@ -2510,7 +2525,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>         u64 delta, scaled_delta, periods;
>         u32 runnable_contrib, scaled_runnable_contrib;
>         int delta_w, scaled_delta_w, decayed = 0;
> -       unsigned long scale_freq = arch_scale_freq_capacity(NULL, cpu);
> +       unsigned long scale_factor;
>
>         delta = now - sa->last_runnable_update;
>         /*
> @@ -2531,6 +2546,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>                 return 0;
>         sa->last_runnable_update = now;
>
> +       scale_factor = contrib_scale_factor(cpu);
> +
>         /* delta_w is the amount already accumulated against our next period */
>         delta_w = sa->avg_period % 1024;
>         if (delta + delta_w >= 1024) {
> @@ -2543,7 +2560,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>                  * period and accrue it.
>                  */
>                 delta_w = 1024 - delta_w;
> -               scaled_delta_w = (delta_w * scale_freq) >> SCHED_CAPACITY_SHIFT;
> +               scaled_delta_w = scale_contrib(delta_w, scale_factor);
>
>                 if (runnable)
>                         sa->runnable_avg_sum += scaled_delta_w;
> @@ -2566,8 +2583,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>
>                 /* Efficiently calculate \sum (1..n_period) 1024*y^i */
>                 runnable_contrib = __compute_runnable_contrib(periods);
> -               scaled_runnable_contrib = (runnable_contrib * scale_freq)
> -                                               >> SCHED_CAPACITY_SHIFT;
> +               scaled_runnable_contrib =
> +                       scale_contrib(runnable_contrib, scale_factor);
>
>                 if (runnable)
>                         sa->runnable_avg_sum += scaled_runnable_contrib;
> @@ -2577,7 +2594,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>         }
>
>         /* Remainder of delta accrued against u_0` */
> -       scaled_delta = (delta * scale_freq) >> SCHED_CAPACITY_SHIFT;
> +       scaled_delta = scale_contrib(delta, scale_factor);
>
>         if (runnable)
>                 sa->runnable_avg_sum += scaled_delta;
> --
> 1.9.1
>
>
