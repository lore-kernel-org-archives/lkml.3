Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaDPGy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:54:29 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51627 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaDPGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140415172243.GP11182@twins.programming.kicks-ass.net>
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
 <1396012949-6227-4-git-send-email-vincent.guittot@linaro.org> <20140415172243.GP11182@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 16 Apr 2014 08:54:06 +0200
Message-ID: <CAKfTPtA-Np2D49CQ-UFuCVaLoXbyD7mKvCPGyiNprk8T+qrWbg@mail.gmail.com>
Subject: Re: [RFC 3/4] sched: fix computed capacity for HMP
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 19:22, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Mar 28, 2014 at 02:22:28PM +0100, Vincent Guittot wrote:
>> The current sg_capacity solves the ghost cores issue for SMT system and
>> cluster made of big cores which have a cpu_power above SCHED_POWER_SCALE at
>> core level. But it still removes some real cores of a cluster made of LITTLE
>> cores which have a cpu_power below SCHED_POWER_SCALE.
>>
>> Instead of using the power_orig to detect SMT system and compute a smt factor
>> that will be used to calculate the real number of cores, we set a core_fct
>> field when building the sched_domain topology. We can detect SMT system thanks
>> to SD_SHARE_CPUPOWER flag and set core_fct to know how many CPUs per core we
>> have. The core_fct will ensure that sg_capacity will return cores capacity of
>> a SMT system and will not remove any real core of LITTLE cluster.
>>
>> This method also fixes a use case where the capacity of a SMT system was
>> overrated.
>> Let take the example of a system made of 8 cores HT system:
>> At CPU level, sg_capacity is cap to a maximum capacity of 8 whereas
>> DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE) returns 9.
>> ((589*16) / 1024) = 9.3
>> Now if 2 CPUs (1 core) are fully loaded by rt tasks, sg_capacity still returns
>> a capacity of 8 whereas it should return a capacity of 7. This happen because
>> DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE) is still above 7.5:
>> ((589*14) / 1024) = 8.05
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c  | 7 +++++++
>>  kernel/sched/fair.c  | 6 ++----
>>  kernel/sched/sched.h | 2 +-
>>  3 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index f9d9776..5b20b27 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5844,6 +5844,13 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>>
>>       WARN_ON(!sg);
>>
>> +     if (!sd->child)
>> +             sg->core_fct = 1;
>> +     else if (sd->child->flags & SD_SHARE_CPUPOWER)
>> +             sg->core_fct = cpumask_weight(sched_group_cpus(sg));
>> +     else
>> +             sg->core_fct = sd->child->groups->core_fct;
>> +
>>       do {
>>               sg->group_weight = cpumask_weight(sched_group_cpus(sg));
>>               sg = sg->next;
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index ed42061..7387c05 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5773,12 +5773,10 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
>>       power = group->sgp->power;
>>       power_orig = group->sgp->power_orig;
>>       cpus = group->group_weight;
>> +     smt = group->core_fct;
>>
>> -     /* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
>> -     smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
>> -     capacity = cpus / smt; /* cores */
>> +     capacity = DIV_ROUND_CLOSEST(power * cpus, power_orig * smt);
>>
>> -     capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
>>       if (!capacity)
>>               capacity = fix_small_capacity(env->sd, group);
>>
>
> So this patch only cures a little problem; the much bigger problem is
> that capacity as exists is completely wrong.
>
> We really should be using utilization here. Until a CPU is fully

ok, I'm goiing to see how to replace capacity with utilization

Thanks

> utilized we shouldn't be moving tasks around (unless packing, but where
> not there yet, and in that case you want to stop, where this starts,
> namely full utilization).
>
> So while I appreciate what you're trying to 'fix' here, its really just
> trying to dress a monkey.
