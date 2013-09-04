Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207Ab3IDHoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:44:19 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47075 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762036Ab3IDHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130828111638.GO10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
	<20130828111638.GO10002@twins.programming.kicks-ass.net>
Date: Wed, 4 Sep 2013 09:44:17 +0200
Message-ID: <CAKfTPtDJ_9jPhx00W3DhYqXNLxhKqVEVe0HyFeb6JVp8yEYd4w@mail.gmail.com>
Subject: Re: [RFC][PATCH 14/10] sched, fair: Fix the group_capacity computation
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 13:16, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Subject: sched, fair: Fix the group_capacity computation
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Aug 28 12:40:38 CEST 2013
>
> Do away with 'phantom' cores due to N*frac(smt_power) >= 1 by limiting
> the capacity to the actual number of cores.
>

Peter,

your patch also solves the 'phantom' big cores that can appear on HMP
system because big cores have a cpu_power >=  SCHED_POWER_SCALE in
order to express a higher capacity than LITTLE cores.

Acked-by Vincent Guittot <vincent.guitto@linaro.org>

Vincent

> The assumption of 1 < smt_power < 2 is an actual requirement because
> of what SMT is so this should work regardless of the SMT
> implementation.
>
> It can still be defeated by creative use of cpu hotplug, but if you're
> one of those freaks, you get to live with it.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/fair.c |   20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4554,18 +4554,24 @@ static inline int sg_imbalanced(struct s
>  /*
>   * Compute the group capacity.
>   *
> - * For now the capacity is simply the number of power units in the group_power.
> - * A power unit represents a full core.
> - *
> - * This has an issue where N*frac(smt_power) >= 1, in that case we'll see extra
> - * 'cores' that aren't actually there.
> + * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
> + * first dividing out the smt factor and computing the actual number of cores
> + * and limit power unit capacity with that.
>   */
>  static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
>  {
> +       unsigned int capacity, smt, cpus;
> +       unsigned int power, power_orig;
> +
> +       power = group->sgp->power;
> +       power_orig = group->sgp->power_orig;
> +       cpus = group->group_weight;
>
> -       unsigned int power = group->sgp->power;
> -       unsigned int capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
> +       /* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
> +       smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
> +       capacity = cpus / smt; /* cores */
>
> +       capacity = min_t(capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
>         if (!capacity)
>                 capacity = fix_small_capacity(env->sd, group);
>
