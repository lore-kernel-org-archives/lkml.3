Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaCEAKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:10:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:38123 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaCEAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:10:13 -0500
Date: Wed, 5 Mar 2014 01:10:20 +0100 (CET)
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
In-Reply-To: <CALCETrWOsSm3M9C+2bx2mLCdjjdFJOZk1QL6khCzvzxX9iO+0Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403050017020.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-6-git-send-email-a.perevalov@samsung.com> <530D5715.1050901@mit.edu> <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de> <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
 <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de> <CALCETrWOsSm3M9C+2bx2mLCdjjdFJOZk1QL6khCzvzxX9iO+0Q@mail.gmail.com>
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
> On Tue, Mar 4, 2014 at 2:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > We do no add another random special case syscall for timerfd just
> > because timerfd is linux specific.
> 
> What syscalls?  I can think of exactly two timer interfaces that
> actually accept a clock id and flags: clock_nanosleep and
> timerfd_settime.

Sure, and what you can think of is reality?

 sys_timer_settime() which relies on sys_timer_create() are outside
 your universe, right?

And no. We are not adding timer_list mess back to any of them.

Aside of that if you want to make the slack thing usefull on a per
call basis then you want to add it to a lot of other interfaces like
poll.

And you are completely ignoring the fact that the slack works
completely differrent:

A slacked timer still gets enqueued into the main timer queue. It just
relies on the fact that it gets batched with some other expiring
timer. But thats completely different to the deferrable approach.

       start_timer(timer, expiry, slack);

       	   timer.hard_expiry = expiry + slack;
	   timer.soft_expiry = expiry;
	   enqueue_timer(timer, timer.hard_expiry);

The enqueueing code puts it into the queue by looking at the
hard_expiry code. And the expiry code looks at the timer.soft_expiry
value to expire a timer early.

Now assume the following:

       start_timer(timer, +100ms, 100s);

So that puts that timer into the hard expiry line of 100.1 sec from
now. So if the cpu is busy and is firing a lot of timers then your
timer could be delayed up to the hard expiry time, i.e. 100.1 seconds
from now, which has completely differrent semantics than the
deferrrable timers.

The deferrable timer is guaranteed to expire (halfways) on time when
the system is active and does not affect the system from going idle,
but it expires right away when the system comes back out of idle.

The slack timers are just a batching mechanism to align expiry times
of non deferrable timers to a common time.

So how do you map those together?

I'm not saying that a per timer slack is useless, but it does not
solve the issue of deferrable timers.

Quite the contrary, it would be simpler to implement the slacked
timers as a special case of the deferrable timers. But hell no, we are
not going to go there.

> > But we cannot do that right now as we cannot whip up severl dozen of
> > new syscalls just because we want to add slack/deferrable whatever
> > properties.

> Two syscalls, right?

It does not matter at all how many syscalls this affects. We are not
adding any random new syscalls just because we can.

> Once we agree on a solution to the Y2038 issue on 32bit with a unified
> 32/64 bit syscall interface which simply gets rid of the timespec/val
> nonsense and takes a simple u64 nsec value we can add the slack
> property to that without any further inconvenience.

Ignoring this wont get you anywhere.

Thanks,

	tglx
