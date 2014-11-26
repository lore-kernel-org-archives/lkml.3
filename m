Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKZFST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:18:19 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62164 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaKZFSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:18:18 -0500
Message-ID: <5475628D.2080301@gmail.com>
Date: Wed, 26 Nov 2014 13:18:05 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 05/10] sched: make scale_rt invariant with frequency
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org> <1415033687-23294-6-git-send-email-vincent.guittot@linaro.org> <5473E867.6030607@gmail.com> <CAKfTPtCSJhTR2=1_g2UVxeEEKocBs+ouco4Z5SRO2oRSJ-O2mA@mail.gmail.com>
In-Reply-To: <CAKfTPtCSJhTR2=1_g2UVxeEEKocBs+ouco4Z5SRO2oRSJ-O2mA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,
On 11/25/14, 9:52 PM, Vincent Guittot wrote:
> On 25 November 2014 at 03:24, Wanpeng Li <kernellwp@gmail.com> wrote:
>> Hi Vincent,
>> On 11/4/14, 12:54 AM, Vincent Guittot wrote:
>>> The average running time of RT tasks is used to estimate the remaining
>>> compute
>>> capacity for CFS tasks. This remaining capacity is the original capacity
>>> scaled
>>> down by a factor (aka scale_rt_capacity). This estimation of available
>>> capacity
>>> must also be invariant with frequency scaling.
>>>
>>> A frequency scaling factor is applied on the running time of the RT tasks
>>> for
>>> computing scale_rt_capacity.
>>>
>>> In sched_rt_avg_update, we scale the RT execution time like below:
>>> rq->rt_avg += rt_delta * arch_scale_freq_capacity() >>
>>> SCHED_CAPACITY_SHIFT
>>>
>>> Then, scale_rt_capacity can be summarized by:
>>> scale_rt_capacity = SCHED_CAPACITY_SCALE -
>>>                  ((rq->rt_avg << SCHED_CAPACITY_SHIFT) / period)
>>
>> The 'period' aka 'total' in the scale_rt_capacity(), why it is
>> sched_avg_period() + delta instead of sched_avg_period()?
> The default value of sched_avg_period is 1sec which is "long" so we
> take into account the time consumed by RT tasks in the ongoing period
> .

Do you mean 'sched_avg_period() + delta' should be replaced by 'delta' 
since sched_avg_period() is "long"?

Regards,
Wanpeng Li

>
>> Regards,
>> Wanpeng Li
>>
>>
>>> We can optimize by removing right and left shift in the computation of
>>> rq->rt_avg
>>> and scale_rt_capacity
>>>
>>> The call to arch_scale_frequency_capacity in the rt scheduling path might
>>> be
>>> a concern for RT folks because I'm not sure whether we can rely on
>>> arch_scale_freq_capacity to be short and efficient ?
>>>
>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>> ---
>>>    kernel/sched/fair.c  | 17 +++++------------
>>>    kernel/sched/sched.h |  4 +++-
>>>    2 files changed, 8 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index a5039da..b37c27b 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -5785,7 +5785,7 @@ unsigned long __weak arch_scale_cpu_capacity(struct
>>> sched_domain *sd, int cpu)
>>>    static unsigned long scale_rt_capacity(int cpu)
>>>    {
>>>          struct rq *rq = cpu_rq(cpu);
>>> -       u64 total, available, age_stamp, avg;
>>> +       u64 total, used, age_stamp, avg;
>>>          s64 delta;
>>>          /*
>>> @@ -5801,19 +5801,12 @@ static unsigned long scale_rt_capacity(int cpu)
>>>          total = sched_avg_period() + delta;
>>>    -     if (unlikely(total < avg)) {
>>> -               /* Ensures that capacity won't end up being negative */
>>> -               available = 0;
>>> -       } else {
>>> -               available = total - avg;
>>> -       }
>>> +       used = div_u64(avg, total);
>>>    -     if (unlikely((s64)total < SCHED_CAPACITY_SCALE))
>>> -               total = SCHED_CAPACITY_SCALE;
>>> +       if (likely(used < SCHED_CAPACITY_SCALE))
>>> +               return SCHED_CAPACITY_SCALE - used;
>>>    -     total >>= SCHED_CAPACITY_SHIFT;
>>> -
>>> -       return div_u64(available, total);
>>> +       return 1;
>>>    }
>>>      static void update_cpu_capacity(struct sched_domain *sd, int cpu)
>>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>>> index c34bd11..fc5b152 100644
>>> --- a/kernel/sched/sched.h
>>> +++ b/kernel/sched/sched.h
>>> @@ -1312,9 +1312,11 @@ static inline int hrtick_enabled(struct rq *rq)
>>>      #ifdef CONFIG_SMP
>>>    extern void sched_avg_update(struct rq *rq);
>>> +extern unsigned long arch_scale_freq_capacity(struct sched_domain *sd,
>>> int cpu);
>>> +
>>>    static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
>>>    {
>>> -       rq->rt_avg += rt_delta;
>>> +       rq->rt_avg += rt_delta * arch_scale_freq_capacity(NULL,
>>> cpu_of(rq));
>>>          sched_avg_update(rq);
>>>    }
>>>    #else
>>

