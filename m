Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3DWJBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:01:43 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47446 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3DWJBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:01:42 -0400
MIME-Version: 1.0
In-Reply-To: <1366707006.8337.33.camel@laptop>
References: <1366645086-20345-1-git-send-email-vincent.guittot@linaro.org>
	<1366661437.6454.20.camel@laptop>
	<CAKfTPtD5rxB29t1mCDBVTVv-RVFv9xMjhRaUeaxCU6znZGPJrw@mail.gmail.com>
	<1366707006.8337.33.camel@laptop>
Date: Tue, 23 Apr 2013 11:01:40 +0200
Message-ID: <CAKfTPtA-z2fR+8gMGr2pVgHEYU2=OJqZD_8HJz0m_0BoR-Yoiw@mail.gmail.com>
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

On 23 April 2013 10:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2013-04-23 at 09:52 +0200, Vincent Guittot wrote:
>
>> > static inline unsigned long *rq_nohz_flags(int cpu)
>> > {
>> >         return rcu_dereference(cpu_rq(cpu)->sd)->nohz_flags;
>> > }
>> >
>> >         if (!test_bit(0, rq_nohz_flags(cpu)))
>> >                 return;
>> >         clear_bit(0, rq_nohz_flags(cpu));
>> >
>>
>> AFAICT, if we use different rcu_dereferences for modifying nohz_flags
>> and for updating the nr_busy_cpus, we open a time window for
>> desynchronization, isn't it ?
>
> Oh right, we need to call rq_nohz_flags() once and use the pointer
> twice.
>
>> >> +unlock:
>> >>       rcu_read_unlock();
>> >>  }
>> >>
>> >> @@ -5409,14 +5416,21 @@ void set_cpu_sd_state_idle(void)
>> >>  {
>> >>       struct sched_domain *sd;
>> >>       int cpu = smp_processor_id();
>> >> -
>> >> -     if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
>> >> -             return;
>> >> -     set_bit(NOHZ_IDLE, nohz_flags(cpu));
>> >> +     int first_nohz_idle = 1;
>> >>
>> >>       rcu_read_lock();
>> >> -     for_each_domain(cpu, sd)
>> >> +     for_each_domain(cpu, sd) {
>> >> +             if (first_nohz_idle) {
>> >> +                     if (test_bit(NOHZ_IDLE, &sd->nohz_flags))
>> >> +                             goto unlock;
>> >> +
>> >> +                     set_bit(NOHZ_IDLE, &sd->nohz_flags);
>> >> +                     first_nohz_idle = 0;
>> >> +             }
>> >> +
>> >>               atomic_dec(&sd->groups->sgp->nr_busy_cpus);
>> >> +     }
>> >> +unlock:
>> >
>> > Same here, .. why on earth do it for every sched_domain for that
>> cpu?
>>
>> The update of rq_nohz_flags is done only once on the top level
>> sched_domain and the nr_busy_cpus is updated on each sched_domain
>> level in order to have a quick access to the number of busy cpu when
>> we check for the need to kick an idle load balance
>
> Ah, I didn't see the whole first_nohz_idle thing.. but why did you
> place it inside the loop in the first place? Wouldn't GCC be able to

My goal was to keep for_each_domain that is a normally used for
accessing sched_domain tree

> avoid the double cpu_rq(cpu)->sd dereference using CSE? Argh no,.. its
> got an ACCESS_ONCE in it that defeats GCC.
>
> Bothersome..
>
> I'd almost write it like:
>
>         struct sched_domain *sd;
>
>         rcu_read_lock();
>         sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
>
>         if (sd->nohz_idle)
>                 goto unlock;
>         xchg(&sd->nohz_idle, 1); /* do we actually need atomics here? */
>
>         for (; sd; sd = sd->parent)
>                 atomic_dec(&sd->groups->sgp->nr_busy_cpus);
>   unlock:
>         rcu_read_unlock();
>

ok, i'm going to modify the patch and follow the sequence above

Vincent

>
>
>
