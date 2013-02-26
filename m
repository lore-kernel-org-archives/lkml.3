Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3BZOzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:55:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3BZOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:55:44 -0500
Date: Tue, 26 Feb 2013 15:54:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lianwei Wang <lianwei.wang@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
Message-ID: <20130226145412.GA31943@redhat.com>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com> <20130225235313.GE2679@htj.dyndns.org> <20130226141456.GB28940@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226141456.GB28940@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn.

Tejun, et all, sorry for confusion.

Somehow I misunderstood your email completely! as if you argue with
my "freezer: do not send a fake signal to a PF_DUMPCORE thread"
change http://marc.info/?l=linux-kernel&m=136173112604220

As for "add fake signal clearing back when thaw task", I do not
understand why do we need this change too, so I agree with you.

On 02/26, Oleg Nesterov wrote:
>
> On 02/25, Tejun Heo wrote:
> >
> > (cc'ing Rafael and Oleg and quoting whole body)
> >
> > On Thu, Feb 21, 2013 at 02:19:21PM +0800, Lianwei Wang wrote:
> > > Hi Tejun Heo and all,
> > >
> > > The commit of "34b087e freezer: kill unused
> > > set_freezable_with_signal()" remove recalc_sigpending*() calls in
> > > freezer, so the user tasks get TIF_SIGPENDING fake signal that is set
> > > when freezing userspace process. It left the fake signal to userspcae
> > > which cause the userspace task that wait_event_freezable and friends
> > > return a wrong ERESTARTSYS. This is not good because it waste cpu time
> > > to handle the fake signal.
> >
> > Is this even measureable?  Freeze / thaw isn't exactly a hot path and
> > I'm having difficult time believing -ERESTARTSYS would have a
> > noticeable impact on anything.  Can you please explain why this is a
> > problem?
>
> For example, wait_for_dump_helpers() can fail because it checks
> signal_pending(). And we can sleep in TASK_KILLABLE because pipe_release()
> does wake_up_interruptible(). But this is minor, wait_for_dump_helpers()
> could be fixed without this change.
>
> The real problem is dump_write-like code. Say, pipe_write() can fail if
> signal_pending() == T. I am not saying this is unsolvable, in fact I was
> going to add the freeze + recalc_sigpending + retry logic initially, but
> this looks soooo ugly.
>
> Also. Rightly or not, but I came to conclusion that this change is right
> even if we forget about killable/freezable problems in coredump. The
> coredumping thread is no longer a "real" user-space process. It can never
> handle the signals, it doesn't return to user-mode, but it does a lot of
> work in kernel space. So I think it should look as PF_KTHREAD to freezer.
> 
> > > Can we just call the recalc_sigpending to clear the fake signal for
> > > userspace tasks? as below patch do:
> > >
> > > +static void fake_signal_clear(struct task_struct *p)
> > > +{
> > > + unsigned long flags;
> > > +
> > > + if (lock_task_sighand(p, &flags)) {
> > > +     recalc_sigpending();
> > > +     unlock_task_sighand(p, &flags);
> > > + }
> 
> You know, _perhaps_ we have another reason for this change. Otherwise
> wait_event_freezable() doesn't look right. Or we should clarify that
> it is only for PF_KTHREAD but than we can simplify wait_event_freezable().
> And in this case I do not think we should reintroduce recalc_sigpending()
> removed by 34b087e48 "freezer: kill unused set_freezable_with_signal()".
> 
> I'll write another email about this, nobody actually need
> wait_event_freezable().
> 
> But. The change above can't help the coredumping thread. It still
> needs to do
> 
> 	spin_lock_irq(current->siglock);
> 	if (!__fatal_signal_pending(current))
> 		clear_thread_flag(TIF_SIGPENDING);
> 	spin_unlock_irq(current->siglock);
> 
> or we should change recalc_sigpending() to check PF_KTHREAD.
> 
> Oleg.

