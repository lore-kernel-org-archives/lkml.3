Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaE1HB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:01:26 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50594 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaE1HBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140527173229.GF19143@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org> <20140527173229.GF19143@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 28 May 2014 09:01:04 +0200
Message-ID: <CAKfTPtBVuoXKa02OCGgzNZ0Dx5gwY6AywYNP=i5izcBxpuzM1A@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
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
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2014 19:32, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 23, 2014 at 05:53:02PM +0200, Vincent Guittot wrote:
>> Monitor the activity level of each group of each sched_domain level. The
>> activity is the amount of cpu_power that is currently used on a CPU or group
>> of CPUs. We use the runnable_avg_sum and _period to evaluate this activity
>> level. In the special use case where the CPU is fully loaded by more than 1
>> task, the activity level is set above the cpu_power in order to reflect the
>> overload of the CPU
>>
>
>> +static int get_cpu_activity(int cpu)
>> +{
>> +     struct rq *rq = cpu_rq(cpu);
>> +     u32 sum = rq->avg.runnable_avg_sum;
>> +     u32 period = rq->avg.runnable_avg_period;
>> +
>> +     if (sum >= period)
>> +             return power_orig_of(cpu) + rq->nr_running - 1;
>> +
>> +     return (sum * power_orig_of(cpu)) / period;
>> +}
>
> While I appreciate the need to signify the overload situation, I don't
> think adding nr_running makes sense. The amount of tasks has no bearing
> on the amount of overload.

I agree that it's not the best way to evaluate overload but it's the
only simple one that is available without additional computation. I'm
going to try to find a better metric or come back the solution which
only adds +1  and compute the overload somewhere else

>
> Also, and note I've not yet seen the use, it strikes me as odd to use
> the orig power here. I would've thought the current capacity (not the
> max capacity) is relevant to balancing.

activity also measures the non cfs tasks activity whereas current
capacity removes the capacity used by non cfs tasks. So as long as
arch_scale_cpu_freq is not used (which is the case for now), original
capacity is ok but we might need a 3rd metric so we would have:
original capacity (max capacity that can provide a CPU)
usable capacity (new value that reflects current capacity available
for any kind of processing rt tasks, irq, cfs tasks)
current capacity (capacity available for cfs tasks)

Vincent
