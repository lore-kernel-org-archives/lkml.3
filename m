Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaFCGkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:40:49 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:40969 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaFCGkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140529064827.GI19143@laptop.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org> <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net> <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com> <20140529064827.GI19143@laptop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 23:40:26 -0700
Message-ID: <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
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

On Wed, May 28, 2014 at 11:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 28, 2014 at 05:01:41PM -0700, Andy Lutomirski wrote:
>> On Thu, May 22, 2014 at 6:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, May 22, 2014 at 02:58:18PM +0200, Peter Zijlstra wrote:
>> >> ---
>> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> >> index 4ea7b3f1a087..a5da85fb3570 100644
>> >> --- a/kernel/sched/core.c
>> >> +++ b/kernel/sched/core.c
>> >> @@ -546,12 +546,38 @@ static bool set_nr_and_not_polling(struct task_struct *p)
>> >>       struct thread_info *ti = task_thread_info(p);
>> >>       return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
>> >>  }
>> >> +
>> >> +/*
>> >> + * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
>> >> + */
>> >> +static bool set_nr_if_polling(struct task_struct *p)
>> >> +{
>> >> +     struct thread_info *ti = task_thread_info(p);
>> >> +     typeof(ti->flags) old, val = ti->flags;
>> >> +
>> >> +     for (;;) {
>> >> +             if (!(val & _TIF_POLLING_NRFLAG))
>> >> +                     return false;
>> >> +             if (val & _TIF_NEED_RESCHED)
>> >> +                     return true;
>> >
>> > Hmm, I think this is racy, false would be safer. If its already set we
>> > might already be past the sched_ttwu_pending() invocation, while if its
>> > clear and we're the one to set it, we're guaranteed not.
>> >
>> >> +             old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
>> >> +             if (old == val)
>> >> +                     return true;
>> >> +             val = old;
>> >> +     }
>> >> +}
>>
>> Do you have an updated patch?  After fixing the MIME flow damage
>> (sigh), it doesn't apply to sched/core, which is my best guess for
>> what it's based on.
>
> https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=sched/core&id=c224d4fee677ecc72209903d330b643bcf0793d7

Thanks!

Bugs found so far:

defined(SMP) should be defined(CONFIG_SMP)

You're testing polling on the task being woken, which cannot possibly
succeed: the only tasks that have any business polling are the idle
tasks.  Something like this seems to help:

 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
+       struct rq *rq = cpu_rq(cpu);
+
        if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list)) {
-               if (!set_nr_if_polling(p))
+               if (!set_nr_if_polling(rq->idle))
                        smp_send_reschedule(cpu);
+               else
+                       trace_sched_wake_polling_cpu(cpu);
        }
 }

If you don't beat me to it, I'll send real patches in the morning.
I'll also send some followup patches to make it even better.  Fully
fixed up, this gets rid of almost all of my rescheduling interrupts
except for interrupts from the timer tick.

Also, grr, I still think this would be clearer if polling and
need_resched were per cpu instead of per task -- they only make sense
on a running task.  I guess that need_resched being in
thread_info->flags is helpful because it streamlines the interrupt
exit code.  Oh, well.

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
