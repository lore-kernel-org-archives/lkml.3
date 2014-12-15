Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaLOQcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:32:41 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64217 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaLOQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:32:40 -0500
Date: Mon, 15 Dec 2014 17:32:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] sched: Pull resched loop to __schedule() callers
Message-ID: <20141215163232.GA21962@lerouge>
References: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
 <1418610272-21518-3-git-send-email-fweisbec@gmail.com>
 <CA+55aFwhEkBc899yMY3KugwF0QGF8r7iM_6+DoYa0RgtApv5aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwhEkBc899yMY3KugwF0QGF8r7iM_6+DoYa0RgtApv5aw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 06:46:27PM -0800, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 6:24 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > -need_resched:
> >         preempt_disable();
> >         cpu = smp_processor_id();
> >         rq = cpu_rq(cpu);
> > @@ -2821,8 +2824,6 @@ need_resched:
> >         post_schedule(rq);
> >
> >         sched_preempt_enable_no_resched();
> > -       if (need_resched())
> > -               goto need_resched;
> 
> 
> So my suggestion was to move the
> "preempt_disable()/enable_no_resched()" into the callers too.
> 
> Everybody already does that - except for "schedule()" itself. So that
> would involve adding it here too:
> 
> > @@ -2842,7 +2843,9 @@ asmlinkage __visible void __sched schedule(void)
> >         struct task_struct *tsk = current;
> >
> >         sched_submit_work(tsk);
> > -       __schedule();
> > +       do {
> preempt_disable();
> > +               __schedule();
> sched_preempt_enable_no_resched();
> > +       } while (need_resched());
> >  }
> 
> Hmm?

Indeed!

> 
> That would mean that we have one less preempt update in the
> __sched_preempt() cases. If somebody cares about the preempt counter
> value, we'd have to increemnt the preempt count add values too, ie do
> 
>     __preempt_count_add(PREEMPT_ACTIVE+1);
> 
> there, but I'm not convicned anybody cares about the exact count.

It _looks_ fine to only add PREEMPT_ACTIVE without PREEMPT_OFFSET. I guess
we are only interested in avoiding preemption.

But it may have an impact on some context checkers that rely on in_atomic*()
which ignore the PREEMPT_ACTIVE value. It shouldn't ignore that though but I
guess it's a hack for some specific situation. Now if we do what we plan,
PREEMPT_ACTIVE won't involve PREEMPT_OFFSET anymore, so in_atomic() should
handle PREEMPT_ACTIVE.

schedule_debug() for example relies on in_atomic_preempt_off() which wants
preemption disabled through PREEMPT_OFFSET. But we can tweak that.

This is the only context check I know of, lets hope there are no others lurking.

Ah and there is also the preempt off tracer which ignores the PREEMPT_ACTIVE
counts because they use __preempt_count_add/sub() and they use to be immediately
followed by preempt disable. So we need to use the non-underscored version of
preempt_count_add/sub() on preempt_schedule*() to trace correctly (note though
that ftrace only records preempt_count() & PREEMPT_MASK. So it's going to record
preemption disabled area with a 0 pc.

> As it is, you end up doing the preempt count things twice in the
> __sched_preempt() case: first the PREEMPT_ACTIVE count, and then the
> count inside __schedule().

Indeed so I'm going to split the changes in two steps:

1) disable preemption from schedule(), add PREEMPT_ACTIVE + PREEMPT_OFFSET from
preempt_schedule*() callers, make them use non-underscored preempt_count_add()
and remove the preempt_disable() from __schedule(). That change should be safe
and we remove the overhead of the double preempt_disable.

2) Optional change: remove the PREEMPT_OFFSET from the preempt_schedule*() callers
and tweak schedule_bug(). Having that as a seperate patch so it's easier to ignore,
drop or revert as it looks like a sensitive change.
