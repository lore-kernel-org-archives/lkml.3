Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaJEU0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaJEU0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:26:34 -0400
Date: Sun, 5 Oct 2014 22:23:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: [PATCH 0/1] stop the unbound recursion in
	preempt_schedule_context()
Message-ID: <20141005202300.GA27962@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003232631.GA3439@redhat.com> <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com> <CA+55aFxBAFMxAsSvgOcVuWy4FWH77E4NT8M3SYvQzxGBJ_qkHw@mail.gmail.com> <20141004003300.GA6297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004003300.GA6297@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Oleg Nesterov wrote:
>
> On 10/03, Linus Torvalds wrote:
> >
> > On Fri, Oct 3, 2014 at 5:01 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > The real fix would appear to be to use
> > > "preempt_enable_no_resched_notrace()", which your patch did, but
> > > without the loop.
> >
> > Actually, the real fix would be to not be stupid, and just make the
> > code do something like
> >
> > >        if (likely(!preemptible()))
> > >                return;
> > >
> > >         __preempt_count_add(PREEMPT_ACTIVE);
> > >         prev_ctx = exception_enter();
> > >
> > >         __schedule();
> > >
> > >         exception_exit(prev_ctx);
> > >         __preempt_count_sub(PREEMPT_ACTIVE);
> >
> > and *not* enable preemption around the scheduling at all.

Yes, I think you are right. And I hate to admit that I didn't think about
this simplification. The only complication is that we should move this
function from context_tracking.c to sched/core.c.

However, I still think we need the need_resched() loop, we can't do this
only once.

And in fact the simplest fix could just turn it into

	local_irq_disable();
	preempt_schedule_irq();
	local_irq_enable();

> Again, it is too late for me... Most probably I am wrong, but somehow
> it seems to me that the real fix should try to kill preempt_schedule_context()
> altogether and teach preempt_schedule() to play well with CONTEXT_TRACKING.

Yes, the very fact that

	preempt_enable() != trace_preempt_on() + preempt_enable_notrace()

looks simply wrong imo. And preempt_enable_notrace() has users outside of
the tracing code which can run in IN_USER state. For example, why should
__perf_sw_event() worry about context_tracking.state?

OTOH, if the caller of preempt_enable_notrace() actually needs to take care
of potential IN_USER state, then it probably has other problems. And indeed,
ftrace_ops_control_func() has to check rcu_is_watching() anyway.

IOW, imho 29bb9e5a75 "tracing/context-tracking: Add preempt_schedule_context()
for tracing" was not a right solution. Perhaps the tracing functions can be
changed to switch to IN_KERNEL mode, or at least perhaps we can add the
special preempt_disable_ftrace() helper. But this needs another discussion.

Either way, I do think that preempt_schedule_context() in its current form
must die.

Oleg.

