Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaE2Gsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:48:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaE2Gsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:48:33 -0400
Date: Thu, 29 May 2014 08:48:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140529064827.GI19143@laptop.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 05:01:41PM -0700, Andy Lutomirski wrote:
> On Thu, May 22, 2014 at 6:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, May 22, 2014 at 02:58:18PM +0200, Peter Zijlstra wrote:
> >> ---
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index 4ea7b3f1a087..a5da85fb3570 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -546,12 +546,38 @@ static bool set_nr_and_not_polling(struct task_struct *p)
> >>       struct thread_info *ti = task_thread_info(p);
> >>       return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
> >>  }
> >> +
> >> +/*
> >> + * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
> >> + */
> >> +static bool set_nr_if_polling(struct task_struct *p)
> >> +{
> >> +     struct thread_info *ti = task_thread_info(p);
> >> +     typeof(ti->flags) old, val = ti->flags;
> >> +
> >> +     for (;;) {
> >> +             if (!(val & _TIF_POLLING_NRFLAG))
> >> +                     return false;
> >> +             if (val & _TIF_NEED_RESCHED)
> >> +                     return true;
> >
> > Hmm, I think this is racy, false would be safer. If its already set we
> > might already be past the sched_ttwu_pending() invocation, while if its
> > clear and we're the one to set it, we're guaranteed not.
> >
> >> +             old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
> >> +             if (old == val)
> >> +                     return true;
> >> +             val = old;
> >> +     }
> >> +}
> 
> Do you have an updated patch?  After fixing the MIME flow damage
> (sigh), it doesn't apply to sched/core, which is my best guess for
> what it's based on.

https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=sched/core&id=c224d4fee677ecc72209903d330b643bcf0793d7
