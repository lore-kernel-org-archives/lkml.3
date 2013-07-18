Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab3GRVbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:31:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61171 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab3GRVbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:31:00 -0400
Date: Thu, 18 Jul 2013 23:30:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/18] vtime: Update a few comments
Message-ID: <20130718213053.GD7398@somewhere>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
 <1374079471-3129-6-git-send-email-fweisbec@gmail.com>
 <1374083871.6458.166.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374083871.6458.166.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:57:51PM -0400, Steven Rostedt wrote:
> On Wed, 2013-07-17 at 18:44 +0200, Frederic Weisbecker wrote:
> > Update a stale comment from the old vtime era and document some
> > locking that might be non obvious.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > ---
> >  include/linux/context_tracking.h |    8 ++------
> >  kernel/sched/cputime.c           |    7 +++++++
> >  2 files changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> > index 5984f25..12045ce 100644
> > --- a/include/linux/context_tracking.h
> > +++ b/include/linux/context_tracking.h
> > @@ -72,8 +72,8 @@ extern void guest_exit(void);
> >  static inline void guest_enter(void)
> >  {
> >  	/*
> > -	 * This is running in ioctl context so we can avoid
> > -	 * the call to vtime_account() with its unnecessary idle check.
> > +	 * This is running in ioctl context so its safe
> > +	 * to assume the pending cputime to flush is stime.
> 
> The above is worded funny. What about:
> 
> "This is running in ioctl context so its safe to assume that its the
> stime pending cputime to flush"

May be. What I try to express is that we have some tickless
cputime that elapsed since the last snapshot and we need to know the nature
of that cputime in order to account it to the right stats: was it userspace,
system or idle cputime? We are in the kernel serving an ioctl syscall so
we know it's system, hence the vtime_account_system().

You are the native speaker and I wasn't listening in my english courses
so you definetly have the last word on this, I just want to be sure you
correctly understand why I try to say :)

> 
> I don't know. But "is stime" is what made me have to read that three
> times to figure out what you meant.
> 
> 
> >  	 */
> >  	vtime_account_system(current);
> >  	current->flags |= PF_VCPU;
> > @@ -81,10 +81,6 @@ static inline void guest_enter(void)
> >  
> >  static inline void guest_exit(void)
> >  {
> > -	/*
> > -	 * This is running in ioctl context so we can avoid
> > -	 * the call to vtime_account() with its unnecessary idle check.
> > -	 */
> 
> Should we copy the comment here too?

Yeah or a small reminder.

Thanks.

> 
> -- Steve
> 
> >  	vtime_account_system(current);
> >  	current->flags &= ~PF_VCPU;
> >  }
> > diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> > index a7959e0..223a35e 100644
> > --- a/kernel/sched/cputime.c
> > +++ b/kernel/sched/cputime.c
> > @@ -712,6 +712,13 @@ void vtime_user_enter(struct task_struct *tsk)
> >  
> >  void vtime_guest_enter(struct task_struct *tsk)
> >  {
> > +	/*
> > +	 * The flags must be updated under the lock with
> > +	 * the vtime_snap flush and update.
> > +	 * That enforces a right ordering and update sequence
> > +	 * synchronization against the reader (task_gtime())
> > +	 * that can thus safely catch up with a tickless delta.
> > +	 */
> >  	write_seqlock(&tsk->vtime_seqlock);
> >  	__vtime_account_system(tsk);
> >  	current->flags |= PF_VCPU;
> 
> 
