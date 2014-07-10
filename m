Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaGJNmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:42:33 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44823 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaGJNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140709105721.GT19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-5-git-send-email-vincent.guittot@linaro.org> <20140709105721.GT19379@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 10 Jul 2014 15:42:11 +0200
Message-ID: <CAKfTPtCbCOai+8ROiqfKncP70WTGucRgX=HxRi9eRnVSH9rkSQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] sched: Allow all archs to set the power_orig
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
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

On 9 July 2014 12:57, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 06:05:35PM +0200, Vincent Guittot wrote:
>> power_orig is only changed for system with a SMT sched_domain level in order to
>> reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
>> original capacity that is different from the default value.
>>
>> Create a more generic function arch_scale_cpu_power that can be also used by
>> non SMT platform to set power_orig.
>>
>> The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
>> keep backward compatibility in the use of power_orig.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 148b277..f0bba5f 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5614,6 +5614,20 @@ unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
>>       return default_scale_smt_capacity(sd, cpu);
>>  }
>>
>> +unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>> +{
>> +     unsigned long weight = sd->span_weight;
>> +
>> +     if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
>> +             if (sched_feat(ARCH_CAPACITY))
>> +                     return arch_scale_smt_capacity(sd, cpu);
>> +             else
>> +                     return default_scale_smt_capacity(sd, cpu);
>> +     }
>> +
>> +     return SCHED_CAPACITY_SCALE;
>> +}
>
> The only caller of arch_scale_smt_capacity is now an arch_ function
> itself; which makes it entirely redundant, no?
>
> Also, sched_feat() and default_scale_smt_capability() aren't available
> to arch implementations of this function and can thus not retain
> semantics.
>
> Seeing how we currently don't have any arch_scale_smt_capacity
> implementations other than the default we can easily replace it entirely
> with something like:
>
> unsigned long __weak arch_scale_cpu_capacity()
> {
>         if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
>                 return sd->smt_gain / sd->span_weight;
>
>         return SCHED_CAPACITY_SCALE;
> }
>
> Hmm?

That's fair. i'm going to clean up and remove unused function
