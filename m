Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaCELkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:40:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:42208 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaCELkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:40:19 -0500
Date: Wed, 5 Mar 2014 12:40:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Alexey Perevalov <a.perevalov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
In-Reply-To: <CALCETrVxvCaLUyeMoaEHXvUzOgj_531HENu1G90_WKnS3dE4zA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403050146560.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-6-git-send-email-a.perevalov@samsung.com> <530D5715.1050901@mit.edu> <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de> <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
 <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de> <CALCETrWOsSm3M9C+2bx2mLCdjjdFJOZk1QL6khCzvzxX9iO+0Q@mail.gmail.com> <alpine.DEB.2.02.1403050017020.18573@ionos.tec.linutronix.de>
 <CALCETrVxvCaLUyeMoaEHXvUzOgj_531HENu1G90_WKnS3dE4zA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andy Lutomirski wrote:
> On Tue, Mar 4, 2014 at 4:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > A slacked timer still gets enqueued into the main timer queue. It just
> > relies on the fact that it gets batched with some other expiring
> > timer. But thats completely different to the deferrable approach.
> >
> >        start_timer(timer, expiry, slack);
> >
> >            timer.hard_expiry = expiry + slack;
> >            timer.soft_expiry = expiry;
> >            enqueue_timer(timer, timer.hard_expiry);
> >
> > The enqueueing code puts it into the queue by looking at the
> > hard_expiry code. And the expiry code looks at the timer.soft_expiry
> > value to expire a timer early.
> >
> > Now assume the following:
> >
> >        start_timer(timer, +100ms, 100s);
> >
> > So that puts that timer into the hard expiry line of 100.1 sec from
> > now. So if the cpu is busy and is firing a lot of timers then your
> > timer could be delayed up to the hard expiry time, i.e. 100.1 seconds
> > from now, which has completely differrent semantics than the
> > deferrrable timers.
> 
> Erk.  I didn't realize that.  Is that really the desired behavior?  I

It's the implemented behaviour for a reason.

> assumed that a timer with slack would fire at the earliest time after
> the soft timeout at which the system wasn't idle.  The idea is to
> batch wakeups, right?

Correct. And that's why the slack thing was invented. Not the best
invention, but it solved a problem without creating a cast in stone
new user space ABI. And it was simple to do with the existing
RB-Tree. Otherwise you'd need a Priority Search Tree which handles
overlapping expiry ranges.
 
> > The deferrable timer is guaranteed to expire (halfways) on time when
> > the system is active and does not affect the system from going idle,
> > but it expires right away when the system comes back out of idle.
> >
> > The slack timers are just a batching mechanism to align expiry times
> > of non deferrable timers to a common time.
> >
> > So how do you map those together?
> 
> By thinking of what semantics are actually useful for userspace developers.
> 
> I think that most userspace developers probably want the semantics
> that I thought that timer slack had: I want to do work between time A
> and time B.  Before A is too early, but I'm willing to wait until time
> B if it improves power consumption.

Well, that's what slack actually does.

But your assumption that this is what most userspace developers
probably want is wrong. A lot of them want the following:

   Fire me on time when the CPU/system is busy, otherwise ignore me
   for a time X, where X might be infinite.

And you cannot map this to slack. See below.
 
> Presumably, if the kernel chooses *not* to fire the timer just after
> time A even if the system is awake, then it's risking an unnecessary
> wakeup at time B.
> 
> (I admit that I don't really understand the hrtimer code.  I guess
> that two indexes on the list of timers would be needed.)

The real problem is that we want to cover the following cases:

    1) Expire me no matter what at X

    2) Expire me no matter what at X + Slack (wakeup batching)

    3) Expire me close to X when the system/cpu is busy otherwise expire me latest
        at X + Slack

    4) Expire me close to X when the system/cpu is busy otherwise
       ignore me

#1 and #2 are handled today #1 is #2 with Slack = 0

#4 is what I implemented with the extra internal queues and the extra
flag. We can make the internal implementation to handle #3 as well,
but we do not have a user space interface for that.

> >> Once we agree on a solution to the Y2038 issue on 32bit with a unified
> >> 32/64 bit syscall interface which simply gets rid of the timespec/val
> >> nonsense and takes a simple u64 nsec value we can add the slack
> >> property to that without any further inconvenience.
> >
> > Ignoring this wont get you anywhere.
> 
> I'm not entirely sure why per-timer slack can't be added without
> simultaneously fixing Y2038 (and presumably leap seconds, too) but a
> new flag can be.

The additional flag is fine as it does not introduce a completely new
ABI, it merily extends the existing ABI.

But adding a per call slack is going to introduce a new ABI and I
really dont want to go there as we need to introduce a new ABI for the
Y2038 issue anyway. And that's way more than the few direct timer
related syscalls. Basically we have to look at all syscalls which take
a timespec/timeval.

So no, we are not going to add an adhoc intermediate ABI which we need
to support forever.

Thanks,

	tglx
