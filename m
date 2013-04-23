Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3DWHxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:53:02 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46697 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3DWHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <1366661437.6454.20.camel@laptop>
References: <1366645086-20345-1-git-send-email-vincent.guittot@linaro.org>
	<1366661437.6454.20.camel@laptop>
Date: Tue, 23 Apr 2013 09:52:58 +0200
Message-ID: <CAKfTPtD5rxB29t1mCDBVTVv-RVFv9xMjhRaUeaxCU6znZGPJrw@mail.gmail.com>
Subject: Re: [PATCH v7] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 22:10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-04-22 at 17:38 +0200, Vincent Guittot wrote:
>
>> ---
>>  include/linux/sched.h |    1 +
>>  kernel/sched/fair.c   |   34 ++++++++++++++++++++++++----------
>>  2 files changed, 25 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d35d2b6..cde4f7f 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -899,6 +899,7 @@ struct sched_domain {
>>       unsigned int wake_idx;
>>       unsigned int forkexec_idx;
>>       unsigned int smt_gain;
>> +     unsigned long nohz_flags;       /* NOHZ_IDLE flag status */
>>       int flags;                      /* See SD_* */
>>       int level;
>
> There was a 4 byte hole here, I'm assuming you used unsigned long and
> not utilized the hole because of the whole atomic bitop interface
> taking unsigned long?
>
> Bit wasteful but ok..
>
> So we're only pulling NOHZ_IDLE out of nohz_flags()? Should we then not
> also amend the rq_nohz_flag_bits enum? And it seems pointless to me to
> set bit 2 our nohz_flags word if all other bits are unused.

Yes, i have been too quick to update the patchset. i'm going to remove
NOHZ_IDLE from the rq_nohz_flag_bits

>
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 7a33e59..09e440f 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5394,14 +5394,21 @@ static inline void set_cpu_sd_state_busy(void)
>>  {
>>       struct sched_domain *sd;
>>       int cpu = smp_processor_id();
>> -
>> -     if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
>> -             return;
>> -     clear_bit(NOHZ_IDLE, nohz_flags(cpu));
>> +     int first_nohz_idle = 1;
>>
>>       rcu_read_lock();
>> -     for_each_domain(cpu, sd)
>> +     for_each_domain(cpu, sd) {
>> +             if (first_nohz_idle) {
>> +                     if (!test_bit(NOHZ_IDLE, &sd->nohz_flags))
>> +                             goto unlock;
>> +
>> +                     clear_bit(NOHZ_IDLE, &sd->nohz_flags);
>> +                     first_nohz_idle = 0;
>> +             }
>> +
>>               atomic_inc(&sd->groups->sgp->nr_busy_cpus);
>> +     }
>
> the mind boggles... what's wrong with something like:
>
> static inline unsigned long *rq_nohz_flags(int cpu)
> {
>         return rcu_dereference(cpu_rq(cpu)->sd)->nohz_flags;
> }
>
>         if (!test_bit(0, rq_nohz_flags(cpu)))
>                 return;
>         clear_bit(0, rq_nohz_flags(cpu));
>

AFAICT, if we use different rcu_dereferences for modifying nohz_flags
and for updating the nr_busy_cpus, we open a time window for
desynchronization, isn't it ?
That why i'm doing the update of rq_nohz_flags with the same
rcu_dereference than nr_busy_cpus

>> +unlock:
>>       rcu_read_unlock();
>>  }
>>
>> @@ -5409,14 +5416,21 @@ void set_cpu_sd_state_idle(void)
>>  {
>>       struct sched_domain *sd;
>>       int cpu = smp_processor_id();
>> -
>> -     if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
>> -             return;
>> -     set_bit(NOHZ_IDLE, nohz_flags(cpu));
>> +     int first_nohz_idle = 1;
>>
>>       rcu_read_lock();
>> -     for_each_domain(cpu, sd)
>> +     for_each_domain(cpu, sd) {
>> +             if (first_nohz_idle) {
>> +                     if (test_bit(NOHZ_IDLE, &sd->nohz_flags))
>> +                             goto unlock;
>> +
>> +                     set_bit(NOHZ_IDLE, &sd->nohz_flags);
>> +                     first_nohz_idle = 0;
>> +             }
>> +
>>               atomic_dec(&sd->groups->sgp->nr_busy_cpus);
>> +     }
>> +unlock:
>
> Same here, .. why on earth do it for every sched_domain for that cpu?

The update of rq_nohz_flags is done only once on the top level
sched_domain and the nr_busy_cpus is updated on each sched_domain
level in order to have a quick access to the number of busy cpu when
we check for the need to kick an idle load balance

>
>>       rcu_read_unlock();
>>  }
>>
>
> And since its now only a single bit in a single word, we can easily
> change it to something like:
>
>   if (*rq_nohz_idle(cpu))
>         return;
>   xchg(rq_nohz_idle(cpu), 1); /* set; use 0 for clear */
>
> which drops the unsigned long nonsense..

that's fair. i'm going to use xchg instead of atomic

>
> Or am I completely missing something obvious here?
>
