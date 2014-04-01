Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaDALUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:20:43 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55501 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaDALUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <533A9768.6060006@linux.vnet.ibm.com>
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
 <1396012949-6227-2-git-send-email-vincent.guittot@linaro.org> <533A9768.6060006@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 1 Apr 2014 13:20:17 +0200
Message-ID: <CAKfTPtD7Qp4yUoZ+3jV-Me2Xn53zbi8cHRrWyO7X+COzwcy3Tg@mail.gmail.com>
Subject: Re: [RFC 1/4] sched: extend the usage of cpu_power_orig
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2014 12:39, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 03/28/2014 06:52 PM, Vincent Guittot wrote:
>> cpu_power_orig is only changed for SMT system in order to reflect the lower
>> capacity of CPUs. Heterogenous system also have to reflect an original
>> capacity that is different from the default value.
>
> There is no parameter 'cpu_power_orig' till your fourth patch right?
> Why is this term being used in this patch?

It looks like that i have mixed power_orig and cpu_power_orig in my
commit messages

>
> Besides, both parameters power and power_orig are changed for SMT
> systems to reflect the lower capacity of the CPUs.Why is there a mention
> of only power_orig?

Only SMT system is able to change power_orig from default value
whereas all systems can already change power field with
arch_scale_freq_power function. The goal of this patch is to change
the function name that is used to set power_orig value to a more
generic one and to extend the possibility of setting power_orig for
any kind of system. The behavior of the power field is not changed
with this patchset.

>
> IMO, the subject of the patch is not clearly reflecting the main
> intention of the patch. There is nothing done to change the way
> cpu_power is used; rather you are changing the way the cpu_power is
> being set to be flexible, thus allowing for the right power value to be
> set on heterogeneous systems.
>
> 'Allow archs to set the cpu_power instead of falling to default value'
> or something similar would be more appropriate. What do you think?

I can change with : "Allow all archs to set the power_orig"

Thanks

>
> Regards
> Preeti U Murthy
>>
>> Create a more generic function arch_scale_cpu_power that can be also used by
>> non SMT platform to set cpu_power_orig.
>>
>> The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
>> keep backward compatibility in the use of cpu_power_orig.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 7e9bd0b..ed42061 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5559,6 +5559,20 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
>>       return default_scale_smt_power(sd, cpu);
>>  }
>>
>> +unsigned long __weak arch_scale_cpu_power(struct sched_domain *sd, int cpu)
>> +{
>> +     unsigned long weight = sd->span_weight;
>> +
>> +     if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
>> +             if (sched_feat(ARCH_POWER))
>> +                     return arch_scale_smt_power(sd, cpu);
>> +             else
>> +                     return default_scale_smt_power(sd, cpu);
>> +     }
>> +
>> +     return SCHED_POWER_SCALE;
>> +}
>> +
>>  static unsigned long scale_rt_power(int cpu)
>>  {
>>       struct rq *rq = cpu_rq(cpu);
>> @@ -5590,18 +5604,12 @@ static unsigned long scale_rt_power(int cpu)
>>
>>  static void update_cpu_power(struct sched_domain *sd, int cpu)
>>  {
>> -     unsigned long weight = sd->span_weight;
>>       unsigned long power = SCHED_POWER_SCALE;
>>       struct sched_group *sdg = sd->groups;
>>
>> -     if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
>> -             if (sched_feat(ARCH_POWER))
>> -                     power *= arch_scale_smt_power(sd, cpu);
>> -             else
>> -                     power *= default_scale_smt_power(sd, cpu);
>> +     power *= arch_scale_cpu_power(sd, cpu);
>>
>> -             power >>= SCHED_POWER_SHIFT;
>> -     }
>> +     power >>= SCHED_POWER_SHIFT;
>>
>>       sdg->sgp->power_orig = power;
>>
>
