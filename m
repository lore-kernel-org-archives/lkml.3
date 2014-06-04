Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaFDO53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:57:29 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:35952 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaFDO52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140604074416.GH30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net> <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
 <20140604074416.GH30445@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Jun 2014 07:57:07 -0700
Message-ID: <CALCETrV3EQg0t_nvBZcsPKXiT2mrkDd_8AbVkJ=vADSToc6bKg@mail.gmail.com>
Subject: Re: [PATCH 4/6] sched,idle: Clear polling before descheduling the
 idle thread
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 12:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 03, 2014 at 05:29:50PM -0700, Andy Lutomirski wrote:
>> Currently, the only real guarantee provided by the polling bit is
>> that, if you hold rq->lock and the polling bit is set, then you can
>> set need_resched to force a reschedule.
>>
>> The only reason the lock is needed is that the idle thread might not
>> be running at all when setting its need_resched bit, and rq->lock
>> keeps it pinned.
>>
>> This is easy to fix: just clear the polling bit before scheduling.
>> Now the polling bit is only ever set when rq->curr == rq->idle.
>
> Yah, except of course:
>
>   lkml.kernel.org/r/20131120162736.508462614@infradead.org

Wow, that code was ugly.

Can you be persuaded to hold off on that patch until after this series
is done?  I think the cpu_startup_entry change will just muddy the
waters for now.

>
> which I really need to rebase and post again :/
>
> In any case, this is useful even with that, although then we really must
> do something like:
>
>   rcu_read_lock();
>   if (!set_nr_if_polling(rq->curr))
>         smp_send_reschedule(rq->cpu);
>   rcu_read_unlock();
>
> Because there's other tasks than rq->idle which might be 'idle', joy!

Is this really a problem?

It's certainly the case that a non-idle (in the sense of != rq->idle)
task can have the polling bit set, but so what?  I'm perfectly happy
to wake these ersatz idle things via IPI instead of via
TIF_NEED_RESCHED.  I think that all of the code that plays with the
polling bit after all these patches are applied either holds rq->lock
(which prevents the task from going away) or acts directly on
rq->idle, which really has no business being deallocated.

I think that the RCU solution is actually racy, too.  Consider:

If rq->curr is one some thermal sort-of-idle thing that has polling
set, and no one has made those tasks respect the new polling semantics
from this patch, then this could happen:

CPU A:
rcu_read_lock();
load rq->curr

                           CPU B:
                           deschedule rq->curr and schedule somthing else

CPU A:
set_nr_if_polling(rq->curr) returns true
no IPI sent
rcu_read_unlock()

RCU prevents us from a use-after-free, but we can still fail to send
the required IPI.

Using rq->idle in combination with this patch should prevent that
race.  It's possible for there to be weird timing things that cause
unnecessary IPIs to be sent, but my workload (which, I suspect, is
unusually heavy on remote wakeups from idle) sees something like 99%
of them avoiding the IPI.

--Andy
