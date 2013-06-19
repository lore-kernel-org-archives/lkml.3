Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935225Ab3FSU5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:57:06 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51728 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab3FSU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:57:04 -0400
Date: Wed, 19 Jun 2013 22:56:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/8] posix-cpu-timers: fix wrong timer initialization
Message-ID: <20130619205657.GF21522@somewhere.redhat.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
 <1369604149-13016-6-git-send-email-kosaki.motohiro@gmail.com>
 <20130618142050.GF17619@somewhere.redhat.com>
 <CAHGf_=pzYT9-BLfgX-+0jE2H4CbKChxwp45SwqERC6wu_wSzGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=pzYT9-BLfgX-+0jE2H4CbKChxwp45SwqERC6wu_wSzGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:12:17AM -0400, KOSAKI Motohiro wrote:
> On Tue, Jun 18, 2013 at 10:20 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > On Sun, May 26, 2013 at 05:35:44PM -0400, kosaki.motohiro@gmail.com wrote:
> >> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>
> >> Currently glibc's rt/tst-cputimer1 testcase sporadically fails because
> >> a timer created by timer_create() may fire earlier than specified.
> >>
> >> posix_cpu_timer_set() uses "val" as current time for three purpose. 1)
> >> initialize sig->cputimer. 2) calculation "old" val. 3) calculations an
> >> expires.
> >>
> >> (1) and (2) should only use committed time (i.e. without delta_exec)
> >> because run_posix_cpu_timers() don't care of delta_exec and we need
> >> consistency, but (3) need exact current time (aka cpu clock time) because
> >> an expires should be "now + timeout" by definition.
> >>
> >> This patch distinguishes between two kinds of "now".
> >>
> >> Cc: Olivier Langlois <olivier@trillion01.com>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Acked-by: Peter Zijlstra <peterz@infradead.org>
> >> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >> ---
> >>  include/linux/kernel_stat.h |    5 -----
> >>  kernel/posix-cpu-timers.c   |   14 ++++++++++++--
> >>  kernel/sched/core.c         |   13 -------------
> >>  3 files changed, 12 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> >> index ed5f6ed..f5d4fdf 100644
> >> --- a/include/linux/kernel_stat.h
> >> +++ b/include/linux/kernel_stat.h
> >> @@ -117,11 +117,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
> >>       return kstat_cpu(cpu).irqs_sum;
> >>  }
> >>
> >> -/*
> >> - * Lock/unlock the current runqueue - to extract task statistics:
> >> - */
> >> -extern unsigned long long task_delta_exec(struct task_struct *);
> >> -
> >>  extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
> >>  extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
> >>  extern void account_steal_time(cputime_t);
> >> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> >> index 25447c5..d068808 100644
> >> --- a/kernel/posix-cpu-timers.c
> >> +++ b/kernel/posix-cpu-timers.c
> >> @@ -652,7 +652,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
> >>               cpu->cpu = cputime.utime;
> >>               break;
> >>       case CPUCLOCK_SCHED:
> >> -             cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> >> +             cpu->sched = cputime.sum_exec_runtime;
> >
> > Are you sure that all callers of cpu_timer_sample_group() are fine with that change?
> 
> Now, cpu_timer_sample_group() is used from following four points.
> 
> posix_cpu_timer_set(): for timer initialization

Right, so to recall what is in your changelog, here we want to:

1) get initial sample and initialize cputime->running to 1, so here
we don't want to commit pending deltas otherwise they may be
accounted twice

2) to compute old value. I would say that here both kind of samples
work (with or without committed pending deltas)

3) set the new timer. We want committed pending deltas here to
compute now + deltas, otherwise the timer might trigger too early

> posix_cpu_timer_get(): for timer_gettime(2)

Here I would say it doesn't matter whether we include pending delta
or not. But just to stay consistent with clock_gettime(), I'd rather
include the pending deltas.

> posix_cpu_timer_schedule(): timer firing

firing or fired. But rescheduling in any case. I would tend to
think we want to include pending deltas as a base to calculate
the next expiry time on top of interval increments, etc...
Pretty much like posix_cpu_timer_set() in fact.

> set_process_cpu_timer(): for itimer

So here the case seem to be very similar to posix_cpu_timer_set()
again.
We pass a relative expiring time delta to setitimer() so we want
the timer to expire at NOW + timeout. So NOW must be the clock
sample that includes the pending deltas that haven't yet been
committed, otherwise the timer may expire too early.

Shouldn't we use cpu_clock_sample_group() here?

> 
> I think all of them are safe because, the point is, timer firing
> procedure (check_thread_timers and check_process_timers) don't care
> uncommitted delta. Then, other timer functions need to use the same
> timer tick. Otherwise the inconsistency leak to userland sooner or
> later.
> 
> The another solution is, check_{thread/process}_timers take plenty rq
> locks and use accurate time. However, of course, it may make lots
> performance hit. So, I don't want
> to take this way.

If only we could commit the pending deltas on the task stats (like calling update_curr())
everytime we check the timer/clock sample. This way we wouldn't worry about all
these pending sum_exec_runtime stuff to be accounted twice and we could just always read it
without further thoughts.

Also, cpu_timer_sample_group() looks to be fundamentally buggy to begin with.
It may add task_delta_exec(p) twice if thread_group_timer() is called with cputimer_running == 0.

> 
> 
> > Looking at set_process_cpu_timer() it seems we want the committed time as well to
> > be added on newval. For the same reasons we use cpu_clock_sample_group() in (3) here.
> 
> Sorry, I haven't caught your point. Could you elaborate more?

See above when I describe my worries on set_process_cpu_timer().
