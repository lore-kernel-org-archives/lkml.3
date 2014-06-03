Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaFCQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:05:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47787 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaFCQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140603140223.GA13658@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org> <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net> <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net> <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
 <20140603104347.GT11096@twins.programming.kicks-ass.net> <20140603140223.GA13658@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Jun 2014 09:05:03 -0700
Message-ID: <CALCETrW3cr_RLnMeMtutM5H+3cJSerUxXuEmiT9miDOEmkpANw@mail.gmail.com>
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

On Tue, Jun 3, 2014 at 7:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 03, 2014 at 12:43:47PM +0200, Peter Zijlstra wrote:
>> We need rq->curr, rq->idle 'sleeps' with polling set and nr clear, but
>> it obviously has no effect setting that if its not actually the current
>> task.
>>
>> Touching rq->curr needs holding rcu_read_lock() though, to make sure the
>> task stays around, still shouldn't be a problem.
>
>> @@ -1581,8 +1604,14 @@ void scheduler_ipi(void)
>>
>>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>>  {
>> -     if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
>> -             smp_send_reschedule(cpu);
>> +     struct rq *rq = cpu_rq(cpu);
>> +
>> +     if (llist_add(&p->wake_entry, &rq->wake_list)) {
>> +             rcu_read_lock();
>> +             if (!set_nr_if_polling(rq->curr))
>> +                     smp_send_reschedule(cpu);
>> +             rcu_read_unlock();
>> +     }
>>  }
>
> Hrmm, I think that is still broken, see how in schedule() we clear NR
> before setting the new ->curr.
>
> So I think I had a loop on rq->curr the last time we talked about this,
> but alternatively we could look at clearing NR after setting a new curr.
>
> I think I once looked at why it was done before, of course I can't
> actually remember the details :/

Wouldn't this be a little simpler and maybe even faster if we just
changed the idle loop to make TIF_POLLING_NRFLAG be a real indication
that the idle task is running and actively polling?  That is, change
the end of cpuidle_idle_loop to:

                preempt_set_need_resched();
                tick_nohz_idle_exit();
                clear_tsk_need_resched(current);
                __current_clr_polling();
                smp_mb__after_clear_bit();
                WARN_ON_ONCE(test_thread_flag(TIF_POLLING_NRFLAG));
                sched_ttwu_pending();
                schedule_preempt_disabled();
                __current_set_polling();

This has the added benefit that the optimistic version of the cmpxchg
loop would be safe again.  I'm about to test this with this variant.
I'll try and send a comprehensible set of patches in a few hours.

Can you remind me what the benefit was of letting polling be set when
the idle thread schedules?  It seems racy to me: it probably prevents
any safe use of the polling bit without holding the rq lock.  I guess
there's some benefit to having polling be set for as long as possible,
but it only helps if there are wakeups in very rapid succession, and
it costs a couple of extra bit ops per idle entry.

-- 
Andy Lutomirski
AMA Capital Management, LLC
