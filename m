Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab3EGDg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:36:29 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:35061 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757395Ab3EGDg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:36:28 -0400
Message-ID: <1367897750.14310.59.camel@Wailaba2>
Subject: Re: [PATCH v3 1/3] posix_timers: do not account group_exec_runtime
 for dying autoreaped tasks
From: Olivier Langlois <olivier@trillion01.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 23:35:50 -0400
In-Reply-To: <20130506231835.GC1225@somewhere>
References: <1367258649.8833.19.camel@Wailaba2>
	 <20130506231835.GC1225@somewhere>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

On Tue, 2013-05-07 at 01:18 +0200, Frederic Weisbecker wrote:
> On Mon, Apr 29, 2013 at 02:04:09PM -0400, Olivier Langlois wrote:
> > 
> > 
> > Forbids the cputimer to drift ahead of its process clock by
> > blocking its update when a tick occurs while a autoreaping task
> > is currently in do_exit() between the call to release_task() and
> > its final call to schedule().
> > 
> > Any task stats update after having called release_task() will
> > be lost because they are added to the global process stats located
> > in the signal struct from release_task().
> 
> I wonder if this is real problem that the clock is ahead of the timer.
> Have you seen any issue in practice with this?

note that it is the timer that will be ahead because the process clock
is the sum of past group tasks exec time plus current group tasks exec
time. Few updates are missing in the past group tasks exec time counter
in struct signal.

The effect of this is failure of the unittest testing POSIX compliance
in glibc rt/tst-cputimer1.c

pseudo code of the test is:

1. call clock_gettime() to get now
2. Compute timer expiring time now+timer interval
3. call clock_gettime() when timer cb is called
4. Compare that clock_gettime() result is >= than computed expiring time

The error is adding up as more thread exits and usually the test fails
when testing periodic timers where threads are created to handle the
timer timeouts.

>  Or may be it's a
> guarantee that the posix clock should provide wrt. to the timer?
> 
> thanks.


> 
> > 
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > ---
> >  kernel/sched/fair.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 7a33e59..52d7b10 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -708,7 +708,15 @@ static void update_curr(struct cfs_rq *cfs_rq)
> >  
> >                 trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
> >                 cpuacct_charge(curtask, delta_exec);
> > -               account_group_exec_runtime(curtask, delta_exec);
> > +               /*
> > +                * Do not update the cputimer if the task is already released by
> > +                * release_task().
> > +                *
> > +                * it would preferable to defer the autoreap release_task
> > +                * after the last context switch but harder to do.
> > +                */
> > +               if (likely(curtask->sighand))
> > +                       account_group_exec_runtime(curtask, delta_exec);
> >         }
> >  
> >         account_cfs_rq_runtime(cfs_rq, delta_exec);
> > -- 
> > 1.8.2.1
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


