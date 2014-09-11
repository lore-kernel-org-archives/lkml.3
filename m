Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaIKNIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:08:17 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:48763 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaIKNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140911123412.GY3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org> <20140911123412.GY3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 15:07:52 +0200
Message-ID: <CAKfTPtBbjpCFifoyFSh8Hb3nBZFFTjjxdfxnpMk=CHy5aX1qpg@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] sched: get CPU's utilization statistic
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

On 11 September 2014 14:34, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:53PM +0200, Vincent Guittot wrote:
>> Monitor the utilization level of each group of each sched_domain level. The
>> utilization is the amount of cpu_capacity that is currently used on a CPU or
>> group of CPUs. We use the usage_load_avg to evaluate this utilization level.
>> In the special use case where the CPU is fully loaded by more than 1 task,
>> the activity level is set above the cpu_capacity in order to reflect the overload
>> of the CPU
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 1fd2131..2f95d1c 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4126,6 +4126,11 @@ static unsigned long capacity_of(int cpu)
>>       return cpu_rq(cpu)->cpu_capacity;
>>  }
>>
>> +static unsigned long capacity_orig_of(int cpu)
>> +{
>> +     return cpu_rq(cpu)->cpu_capacity_orig;
>> +}
>> +
>>  static unsigned long cpu_avg_load_per_task(int cpu)
>>  {
>>       struct rq *rq = cpu_rq(cpu);
>
> This hunk should probably go into patch 6.
>
>> @@ -4514,6 +4519,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
>>       return target;
>>  }
>>
>> +static int get_cpu_utilization(int cpu)
>> +{
>> +     unsigned long usage = cpu_rq(cpu)->cfs.usage_load_avg;
>> +     unsigned long capacity = capacity_of(cpu);
>> +
>> +     if (usage >= SCHED_LOAD_SCALE)
>> +             return capacity + 1;
>> +
>> +     return (usage * capacity) >> SCHED_LOAD_SHIFT;
>> +}
>
> So if I understood patch 9 correct, your changelog is iffy.
> usage_load_avg should never get > 1 (of whatever unit), no matter how
> many tasks are on the rq. You can only maximally run all the time.
>
> Therefore I can only interpret the if (usage >= SCHED_LOAD_SCALE) as
> numerical error handling, nothing more.

yes

>
> Also I'm not entirely sure I like the usage, utilization names/metrics.
> I would suggest to reverse them. Call the pure running number
> 'utilization' and this scaled with capacity 'usage' or so.

ok. i can invert 'usage' and 'utilization', which will give

s/get_cpu_utilization/get_cpu_usage/
s/sgs->group_utilization/sgs->group_usage/
s/cfs.usage_load_avg/cfs.utilization_load_avg/
s/se->avg.usage_avg_contrib/se->avg.utilization_avg_contrib
s/__update_task_entity_usage/__update_task_entity_utilization
s/__update_entity_usage_avg_contrib/__update_entity_utilization_avg_contrib

>
>> @@ -6188,7 +6206,6 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>>               /* Now, start updating sd_lb_stats */
>>               sds->total_load += sgs->group_load;
>>               sds->total_capacity += sgs->group_capacity;
>> -
>>               sg = sg->next;
>>       } while (sg != env->sd->groups);
>>
>
> I like that extra line of whitespace, it separates the body from the
> loop itself.

Sorry, i don't know why i remove it
