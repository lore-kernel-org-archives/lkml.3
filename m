Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBLPtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:49:31 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:63578 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaBLPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140212101324.GC3545@laptop.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com> <20140212101324.GC3545@laptop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Feb 2014 07:49:07 -0800
Message-ID: <CALCETrW-GCNuqSTO=p==0gPE2c8wZKSe98Gi4PP2NRdgk5iKag@mail.gmail.com>
Subject: Re: Too many rescheduling interrupts (still!)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 2:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 11, 2014 at 02:34:11PM -0800, Andy Lutomirski wrote:
>> On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> A small number of reschedule interrupts appear to be due to a race:
>> >> both resched_task and wake_up_idle_cpu do, essentially:
>> >>
>> >> set_tsk_need_resched(t);
>> >> smb_mb();
>> >> if (!tsk_is_polling(t))
>> >>   smp_send_reschedule(cpu);
>> >>
>> >> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
>> >> is too quick (which isn't surprising if it was in C0 or C1), then it
>> >> could *clear* TS_POLLING before tsk_is_polling is read.
>
> Yeah we have the wrong default for the idle loops.. it should default to
> polling and only switch to !polling at the very last moment if it really
> needs an interrupt to wake.

I might be missing something, but won't that break the scheduler?  If
tsk_is_polling always returns true on mwait-capable systems, then
other cpus won't be able to use the polling bit to distinguish between
the idle state (where setting need_resched is enough) and the non-idle
state (where the IPI is needed to preempt whatever task is running).

Since rq->lock is held, the resched calls could check the rq state
(curr == idle, maybe) to distinguish these cases.


>
>> There would be an extra benefit of moving the resched-related bits to
>> some per-cpu structure: it would allow lockless wakeups.
>> ttwu_queue_remote, and probably all of the other reschedule-a-cpu
>> functions, could do something like:
>>
>> if (...) {
>>   old = atomic_read(resched_flags(cpu));
>>   while(true) {
>>       if (old & RESCHED_NEED_RESCHED)
>>         return;
>>       if (!(old & RESCHED_POLLING)) {
>>         smp_send_reschedule(cpu);
>>         return;
>>       }
>>       new = old | RESCHED_NEED_RESCHED;
>>       old = atomic_cmpxchg(resched_flags(cpu), old, new);
>>   }
>> }
>
> That looks hideously expensive.. for no apparent reason.
>
> Sending that IPI isn't _that_ bad, esp if we get the false-positive
> window smaller than it is now (its far too wide because of the wrong
> default state).
>
>> The point being that, with the current location of the flags, either
>> an interrupt needs to be sent or something needs to be done to prevent
>> rq->curr from disappearing.  (It probably doesn't matter if the
>> current task changes, because TS_POLLING will be clear, but what if
>> the task goes away entirely?)
>
> It can't we're holding its rq->lock.

Exactly.  AFAICT the only reason that any of this code holds rq->lock
(especially ttwu_queue_remote, which I seem to call a few thousand
times per second) is because the only way to make a cpu reschedule
involves playing with per-task flags.  If the flags were per-rq or
per-cpu instead, then rq->lock wouldn't be needed.  If this were all
done locklessly, then I think either a full cmpxchg or some fairly
careful use of full barriers would be needed, but I bet that cmpxchg
is still considerably faster than a spinlock plus a set_bit.

>
>> All that being said, it looks like ttwu_queue_remote doesn't actually
>> work if the IPI isn't sent.  The attached patch appears to work (and
>> reduces total rescheduling IPIs by a large amount for my workload),
>> but I don't really think it's worthy of being applied...
>
> We can do something similar though; we can move sched_ttwu_pending()
> into the generic idle loop, right next to set_preempt_need_resched().

Oh, right -- either the IPI or the idle code is guaranteed to happen
soon.  (But wouldn't setting TS_POLLING always break this, too?)

--Andy
