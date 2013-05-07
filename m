Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3EGDQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:16:45 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:35517 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756782Ab3EGDQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:16:44 -0400
Message-ID: <1367896600.14310.49.camel@Wailaba2>
Subject: Re: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after
 stopped thread runtime accounting
From: Olivier Langlois <olivier@trillion01.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 06 May 2013 23:16:40 -0400
In-Reply-To: <20130506234717.GA1703@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
	 <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com>
	 <20130506234717.GA1703@somewhere>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 01:47 +0200, Frederic Weisbecker wrote:
> On Fri, May 03, 2013 at 12:47:42AM -0400, kosaki.motohiro@gmail.com wrote:
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > When tsk->signal->cputimer->running is 1, signal->cputimer and
> > tsk->sum_sched_runtime increase at the same pace because update_curr()
> > increases both accounting.
> > 
> > However, there is one exception. When thread exiting, __exit_signal() turns
> > over task's sum_shced_runtime to sig->sum_sched_runtime, but it doesn't stop
> > signal->cputimer accounting.
> > 
> > This inconsistency makes POSIX timer wake up too early. This patch fixes it.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  kernel/sched/stats.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
> > index 2ef90a5..5a0cfc4 100644
> > --- a/kernel/sched/stats.h
> > +++ b/kernel/sched/stats.h
> > @@ -225,6 +225,13 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
> >       if (!cputimer->running)
> >               return;
> >  
> > +     /*
> > +      * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
> > +      * in __exit_signal(), we must not account exec_runtime for consistency.
> > +      */
> > +     if (unlikely(!tsk->sighand))
> > +             return;
> 
> Ok, if we want the clock and timer to be consistent, do we also want the same check in
> account_group_user_time() and account_group_system_time()? The task can still account
> a tick after autoreaping itself between release_task() and the final schedule().
> 
If I can reply, I believe that Kosaki refactoring is superior to my
initial proposal because:

1. Condition will only be evaluated when cputimer is on (and not slow
down scheduler when it is off)
2. It handles all the cases when this function is called. There are few
other places outside update_curr() that this function is called.



