Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaIXRsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:48:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48990 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIXRr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:47:58 -0400
Message-ID: <542303DF.8010606@arm.com>
Date: Wed, 24 Sep 2014 18:48:15 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org> <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 24 Sep 2014 17:47:53.0245 (UTC) FILETIME=[AA758CD0:01CFD81F]
X-MC-Unique: 114092418475509101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 17:08, Vincent Guittot wrote:

[...]

> 
> Finally, the sched_group->sched_group_capacity->capacity_orig has been removed
> because it's more used during load balance.

So you're not forced to call it rq->cpu_capacity_orig any more, you
could use rq->cpu_capacity_max instead.

[...]

This review (by PeterZ) during v5 of your patch-set recommended some
renaming (e.g. s/group_has_free_capacity/group_has_capacity and
s/group_out_of_capacity/group_no_capacity as well as reordering of the
parameters which I agree with:

https://lkml.org/lkml/2014/9/11/706

> 
> -/*
> - * Compute the group capacity factor.
> - *
> - * Avoid the issue where N*frac(smt_capacity) >= 1 creates 'phantom' cores by
> - * first dividing out the smt factor and computing the actual number of cores
> - * and limit unit capacity with that.
> - */
> -static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *group)
> +static inline int group_has_free_capacity(struct sg_lb_stats *sgs,

s/static inline int/static inline bool

> +                       struct lb_env *env)
>  {
> -       unsigned int capacity_factor, smt, cpus;
> -       unsigned int capacity, capacity_orig;
> +       if ((sgs->group_capacity * 100) >
> +                       (sgs->group_usage * env->sd->imbalance_pct))
> +               return true;
> 
> -       capacity = group->sgc->capacity;
> -       capacity_orig = group->sgc->capacity_orig;
> -       cpus = group->group_weight;
> +       if (sgs->sum_nr_running < sgs->group_weight)
> +               return true;
> 
> -       /* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
> -       smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
> -       capacity_factor = cpus / smt; /* cores */
> +       return false;
> +}
> 
> -       capacity_factor = min_t(unsigned,
> -               capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
> -       if (!capacity_factor)
> -               capacity_factor = fix_small_capacity(env->sd, group);
> +static inline int group_is_overloaded(struct sg_lb_stats *sgs,

s/static inline int/static inline bool

> +                       struct lb_env *env)
> +{
> +       if (sgs->sum_nr_running <= sgs->group_weight)
> +               return false;
> 
> -       return capacity_factor;
> +       if ((sgs->group_capacity * 100) <
> +                       (sgs->group_usage * env->sd->imbalance_pct))
> +               return true;
> +
> +       return false;
>  }
> 
>  static enum group_type
> -group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
> +group_classify(struct sched_group *group, struct sg_lb_stats *sgs,
> +                       struct lb_env *env)
>  {
> -       if (sgs->sum_nr_running > sgs->group_capacity_factor)
> +       if (group_is_overloaded(sgs, env))
>                 return group_overloaded;
> 
>         if (sg_imbalanced(group))
> @@ -6072,11 +6038,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>                 sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
> 
>         sgs->group_weight = group->group_weight;
> -       sgs->group_capacity_factor = sg_capacity_factor(env, group);
> -       sgs->group_type = group_classify(group, sgs);
> 
> -       if (sgs->group_capacity_factor > sgs->sum_nr_running)
> -               sgs->group_has_free_capacity = 1;
> +       sgs->group_type = group_classify(group, sgs, env);
> +
> +       sgs->group_out_of_capacity = group_is_overloaded(sgs, env);

In case sgs->group_type is group_overloaded you could set
sgs->group_out_of_capacity to 1 without calling group_is_overloaded again.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7cdf271e8e52..52d441c92a4f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6037,7 +6037,8 @@ static inline void update_sg_lb_stats(struct
lb_env *env,

        sgs->group_type = group_classify(group, sgs, env);

-       sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
+       if (sgs->group_type == group_overloaded)
+               sgs->group_out_of_capacity = 1;
 }

>  }
> 
>  /**
> @@ -6198,17 +6163,21 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd

[...]

