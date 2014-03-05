Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaCEAnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:43:20 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48516 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaCEAnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403050017020.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
 <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
 <530D5715.1050901@mit.edu> <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
 <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
 <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de>
 <CALCETrWOsSm3M9C+2bx2mLCdjjdFJOZk1QL6khCzvzxX9iO+0Q@mail.gmail.com> <alpine.DEB.2.02.1403050017020.18573@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Mar 2014 16:42:57 -0800
Message-ID: <CALCETrVxvCaLUyeMoaEHXvUzOgj_531HENu1G90_WKnS3dE4zA@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 4:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 4 Mar 2014, Andy Lutomirski wrote:
>> On Tue, Mar 4, 2014 at 2:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > We do no add another random special case syscall for timerfd just
>> > because timerfd is linux specific.
>>
>> What syscalls?  I can think of exactly two timer interfaces that
>> actually accept a clock id and flags: clock_nanosleep and
>> timerfd_settime.
>
> Sure, and what you can think of is reality?
>
>  sys_timer_settime() which relies on sys_timer_create() are outside
>  your universe, right?
>

Sigh, I forgot about those.  I would argue that there is no real
reason to make timer_create any fancier.  That kind of sucks.

> Aside of that if you want to make the slack thing usefull on a per
> call basis then you want to add it to a lot of other interfaces like
> poll.

Same with deferrable timers.  And things that want MONOTONIC *and*
REALTIME.  Etc.

>
> And you are completely ignoring the fact that the slack works
> completely differrent:
>
> A slacked timer still gets enqueued into the main timer queue. It just
> relies on the fact that it gets batched with some other expiring
> timer. But thats completely different to the deferrable approach.
>
>        start_timer(timer, expiry, slack);
>
>            timer.hard_expiry = expiry + slack;
>            timer.soft_expiry = expiry;
>            enqueue_timer(timer, timer.hard_expiry);
>
> The enqueueing code puts it into the queue by looking at the
> hard_expiry code. And the expiry code looks at the timer.soft_expiry
> value to expire a timer early.
>
> Now assume the following:
>
>        start_timer(timer, +100ms, 100s);
>
> So that puts that timer into the hard expiry line of 100.1 sec from
> now. So if the cpu is busy and is firing a lot of timers then your
> timer could be delayed up to the hard expiry time, i.e. 100.1 seconds
> from now, which has completely differrent semantics than the
> deferrrable timers.

Erk.  I didn't realize that.  Is that really the desired behavior?  I
assumed that a timer with slack would fire at the earliest time after
the soft timeout at which the system wasn't idle.  The idea is to
batch wakeups, right?

>
> The deferrable timer is guaranteed to expire (halfways) on time when
> the system is active and does not affect the system from going idle,
> but it expires right away when the system comes back out of idle.
>
> The slack timers are just a batching mechanism to align expiry times
> of non deferrable timers to a common time.
>
> So how do you map those together?

By thinking of what semantics are actually useful for userspace developers.

I think that most userspace developers probably want the semantics
that I thought that timer slack had: I want to do work between time A
and time B.  Before A is too early, but I'm willing to wait until time
B if it improves power consumption.

Presumably, if the kernel chooses *not* to fire the timer just after
time A even if the system is awake, then it's risking an unnecessary
wakeup at time B.

(I admit that I don't really understand the hrtimer code.  I guess
that two indexes on the list of timers would be needed.)

>> > But we cannot do that right now as we cannot whip up severl dozen of
>> > new syscalls just because we want to add slack/deferrable whatever
>> > properties.
>
>> Two syscalls, right?
>
> It does not matter at all how many syscalls this affects. We are not
> adding any random new syscalls just because we can.
>
>> Once we agree on a solution to the Y2038 issue on 32bit with a unified
>> 32/64 bit syscall interface which simply gets rid of the timespec/val
>> nonsense and takes a simple u64 nsec value we can add the slack
>> property to that without any further inconvenience.
>
> Ignoring this wont get you anywhere.

I'm not entirely sure why per-timer slack can't be added without
simultaneously fixing Y2038 (and presumably leap seconds, too) but a
new flag can be.

--Andy
