Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBLKNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:13:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaBLKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:13:33 -0500
Date: Wed, 12 Feb 2014 11:13:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Too many rescheduling interrupts (still!)
Message-ID: <20140212101324.GC3545@laptop.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 02:34:11PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> A small number of reschedule interrupts appear to be due to a race:
> >> both resched_task and wake_up_idle_cpu do, essentially:
> >>
> >> set_tsk_need_resched(t);
> >> smb_mb();
> >> if (!tsk_is_polling(t))
> >>   smp_send_reschedule(cpu);
> >>
> >> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
> >> is too quick (which isn't surprising if it was in C0 or C1), then it
> >> could *clear* TS_POLLING before tsk_is_polling is read.

Yeah we have the wrong default for the idle loops.. it should default to
polling and only switch to !polling at the very last moment if it really
needs an interrupt to wake.

Changing this requires someone (probably me again :/) to audit all arch
cpu idle drivers/functions.

> >> Is there a good reason that TIF_NEED_RESCHED is in thread->flags and
> >> TS_POLLING is in thread->status?  Couldn't both of these be in the
> >> same field in something like struct rq?  That would allow a real
> >> atomic op here.

I don't see the value of an atomic op there; but many archs already have
this, grep for TIF_POLLING.

> >> The more serious issue is that AFAICS default_wake_function is
> >> completely missing the polling check.  It goes through
> >> ttwu_queue_remote, which unconditionally sends an interrupt.

Yah, because it does more than just wake the CPU; at the time we didn't
have a generic idle path, we could cure things now though.

> There would be an extra benefit of moving the resched-related bits to
> some per-cpu structure: it would allow lockless wakeups.
> ttwu_queue_remote, and probably all of the other reschedule-a-cpu
> functions, could do something like:
> 
> if (...) {
>   old = atomic_read(resched_flags(cpu));
>   while(true) {
>       if (old & RESCHED_NEED_RESCHED)
>         return;
>       if (!(old & RESCHED_POLLING)) {
>         smp_send_reschedule(cpu);
>         return;
>       }
>       new = old | RESCHED_NEED_RESCHED;
>       old = atomic_cmpxchg(resched_flags(cpu), old, new);
>   }
> }

That looks hideously expensive.. for no apparent reason.

Sending that IPI isn't _that_ bad, esp if we get the false-positive
window smaller than it is now (its far too wide because of the wrong
default state).

> The point being that, with the current location of the flags, either
> an interrupt needs to be sent or something needs to be done to prevent
> rq->curr from disappearing.  (It probably doesn't matter if the
> current task changes, because TS_POLLING will be clear, but what if
> the task goes away entirely?)

It can't we're holding its rq->lock.

> All that being said, it looks like ttwu_queue_remote doesn't actually
> work if the IPI isn't sent.  The attached patch appears to work (and
> reduces total rescheduling IPIs by a large amount for my workload),
> but I don't really think it's worthy of being applied...

We can do something similar though; we can move sched_ttwu_pending()
into the generic idle loop, right next to set_preempt_need_resched().
