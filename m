Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaIOVWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:22:36 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35545 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaIOVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1409111455320.16533@knanqh.ubzr>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org> <alpine.LFD.2.11.1409111455320.16533@knanqh.ubzr>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 15 Sep 2014 23:22:14 +0200
Message-ID: <CAKfTPtA7AwMS5VcbM_CUCMq2N+zE0teaxkpYvoRhbQzgdK8J-Q@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] sched: add per rq cpu_capacity_orig
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 21:02, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 26 Aug 2014, Vincent Guittot wrote:
>
>> This new field cpu_capacity_orig reflects the available capacity of a CPUs
>
> s/a CPUs/a CPU/

good catch

>
>> unlike the cpu_capacity which reflects the current capacity that can be altered
>> by frequency and rt tasks.
>
> Shouldn't this be described as the "highest possible capacity" instead
> of only "available capacity" to make it clearer?  In which case,
> shouldn't it be called capacity_max instead of capacity_orig?  With
> "orig" we may think "origin" as the capacity that was available at boot
> time or the like.  If for example the CPU was booted with a low P-state
> then its max capacity is different from the original one.

I have use the orig suffix to be aligned with the capacity_orig which
is a sum of cpu_capacity_orig.
I agree that orig is standing for original in the sense that it's the
original capacity befor being altered by scale_freq and scale_rt

Vincent
>
>
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c  | 2 +-
>>  kernel/sched/fair.c  | 1 +
>>  kernel/sched/sched.h | 1 +
>>  3 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index a394f99..7c3b237 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -7003,7 +7003,7 @@ void __init sched_init(void)
>>  #ifdef CONFIG_SMP
>>               rq->sd = NULL;
>>               rq->rd = NULL;
>> -             rq->cpu_capacity = SCHED_CAPACITY_SCALE;
>> +             rq->cpu_capacity = rq->cpu_capacity_orig = SCHED_CAPACITY_SCALE;
>>               rq->post_schedule = 0;
>>               rq->active_balance = 0;
>>               rq->next_balance = jiffies;
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 8176bda..17c16cc 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5756,6 +5756,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
>>
>>       capacity >>= SCHED_CAPACITY_SHIFT;
>>
>> +     cpu_rq(cpu)->cpu_capacity_orig = capacity;
>>       sdg->sgc->capacity_orig = capacity;
>>
>>       if (sched_feat(ARCH_CAPACITY))
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index aa0f73b..7c0a74e 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -575,6 +575,7 @@ struct rq {
>>       struct sched_domain *sd;
>>
>>       unsigned long cpu_capacity;
>> +     unsigned long cpu_capacity_orig;
>>
>>       unsigned char idle_balance;
>>       /* For active balancing */
>> --
>> 1.9.1
>>
>>
