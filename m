Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3D2RKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:10:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45138 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756901Ab3D2RKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:10:14 -0400
Message-ID: <1367255407.8833.4.camel@Wailaba2>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 13:10:07 -0400
In-Reply-To: <517DFFE9.4050808@gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>
	 <517DFFE9.4050808@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 01:06 -0400, KOSAKI Motohiro wrote:
> (4/27/13 12:40 AM), Olivier Langlois wrote:
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
> > 
> > Ideally, you should postpone the release_task() call after the
> > final context switch to get all the stats added but this is
> > more complex to achieve.
> > 
> > In other words, this is slowing down the cputimer so it keep the same
> > pace than the process clock but in fact, what should be done is to
> > speed up the process clock by adding the missing stats to it.
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
> 
> I'm confused. glibc's rt/tst-cputimer1 doesn't have thread exiting code. I have
> no seen any issue in this accounting.

glibc launch a helper thread to receive timer signal and will also
create a new thread upon signal reception when a timer is created with
sigev_notify = SIGEV_THREAD;

please see:

glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_create.c
glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_routines.c

Greetings,
Olivier



