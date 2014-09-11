Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaIKR1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:27:11 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59741 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaIKR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:27:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140911161517.GA3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org> <20140911161517.GA3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 19:26:48 +0200
Message-ID: <CAKfTPtDFuzxzGBKi_n6v_F8FUkQ84MW+dQBX4WNXo-o54mksGA@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] sched: replace capacity_factor by utilization
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 18:15, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:54PM +0200, Vincent Guittot wrote:
>> +static inline int group_has_free_capacity(struct sg_lb_stats *sgs,
>> +                     struct lb_env *env)
>>  {
>> +     if ((sgs->group_capacity_orig * 100) >
>> +                     (sgs->group_utilization * env->sd->imbalance_pct))
>> +             return 1;
>> +
>> +     if (sgs->sum_nr_running < sgs->group_weight)
>> +             return 1;
>>
>> +     return 0;
>> +}
>>
>> +static inline int group_is_overloaded(struct sg_lb_stats *sgs,
>> +                     struct lb_env *env)
>> +{
>> +     if (sgs->sum_nr_running <= sgs->group_weight)
>> +             return 0;
>>
>> +     if ((sgs->group_capacity_orig * 100) <
>> +                     (sgs->group_utilization * env->sd->imbalance_pct))
>> +             return 1;
>>
>> +     return 0;
>>  }
>
> I'm confused about the utilization vs capacity_orig. I see how we should

1st point is that I should compare utilization vs capacity and not
capacity_orig.
I should have replaced capacity_orig by capacity in the functions
above when i move the utilization statistic from
rq->avg.runnable_avg_sum to cfs.usage_load_avg.
rq->avg.runnable_avg_sum was measuring all activity on the cpu whereas
cfs.usage_load_avg integrates only cfs tasks

With this change, we don't need sgs->group_capacity_orig anymore but
only sgs->group_capacity. So sgs->group_capacity_orig can be removed
as it's no more used in the code as sg_capacity_factor has been
removed

> maybe scale things with the capacity when comparing between CPUs/groups,
> but not on the same CPU/group.
>
> I would have expected something simple like:
>
> static inline bool group_has_capacity()
> {
>         /* Is there a spare cycle? */
>         if (sgs->group_utilization < sgs->group_weight * SCHED_LOAD_SCALE)
>                 return true;
>
>         /* Are there less tasks than logical CPUs? */
>         if (sgs->sum_nr_running < sgs->group_weight)
>                 return true;
>
>         return false;
> }
>
> Where group_utilization a pure sum of running_avg.
>
> Now this has a hole when there are RT tasks on the system, in that case
> the utilization will never hit 1, but we could fix that another way. I
> don't think the capacity_orig thing is right.
