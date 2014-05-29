Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaE2ACF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:02:05 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:38260 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaE2ACD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140522130931.GV13658@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org> <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net> <20140522130931.GV13658@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 17:01:41 -0700
Message-ID: <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 6:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 22, 2014 at 02:58:18PM +0200, Peter Zijlstra wrote:
>> ---
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 4ea7b3f1a087..a5da85fb3570 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -546,12 +546,38 @@ static bool set_nr_and_not_polling(struct task_struct *p)
>>       struct thread_info *ti = task_thread_info(p);
>>       return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
>>  }
>> +
>> +/*
>> + * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
>> + */
>> +static bool set_nr_if_polling(struct task_struct *p)
>> +{
>> +     struct thread_info *ti = task_thread_info(p);
>> +     typeof(ti->flags) old, val = ti->flags;
>> +
>> +     for (;;) {
>> +             if (!(val & _TIF_POLLING_NRFLAG))
>> +                     return false;
>> +             if (val & _TIF_NEED_RESCHED)
>> +                     return true;
>
> Hmm, I think this is racy, false would be safer. If its already set we
> might already be past the sched_ttwu_pending() invocation, while if its
> clear and we're the one to set it, we're guaranteed not.
>
>> +             old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
>> +             if (old == val)
>> +                     return true;
>> +             val = old;
>> +     }
>> +}

Do you have an updated patch?  After fixing the MIME flow damage
(sigh), it doesn't apply to sched/core, which is my best guess for
what it's based on.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
