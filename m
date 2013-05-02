Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab3EBOEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:04:44 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63566 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab3EBOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:04:42 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1367503010.24182.29.camel@intelbox>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	<15077.1367490569@warthog.procyon.org.uk>
	<CAKMK7uGKnK1VL5wNiFJXeBOHypWup8-7hZDLSqvEsbwvxVW5tA@mail.gmail.com>
	<20130502122302.GK7800@kernel.dk>
	<1367498096.24182.21.camel@intelbox>
	<20130502125426.GN7800@kernel.dk>
	<1367503010.24182.29.camel@intelbox>
Date: Thu, 2 May 2013 16:04:42 +0200
Message-ID: <CAKMK7uGUNzU2KKgiO9E18ZnwzEYe=ZwkPzNmuO7uR=iMqGDW3w@mail.gmail.com>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 3:56 PM, Imre Deak <imre.deak@intel.com> wrote:
> On Thu, 2013-05-02 at 14:54 +0200, Jens Axboe wrote:
>> On Thu, May 02 2013, Imre Deak wrote:
>> > On Thu, 2013-05-02 at 14:23 +0200, Jens Axboe wrote:
>> > > On Thu, May 02 2013, Daniel Vetter wrote:
>> > > > On Thu, May 2, 2013 at 12:29 PM, David Howells <dhowells@redhat.com> wrote:
>> > > > >> Fix this by returning at least 1 if the condition becomes true. This
>> > > > >> semantic is in line with what wait_for_condition_timeout() does; see
>> > > > >> commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
>> > > > >> failure under heavy load".
>> > > > >
>> > > > > But now you can't distinguish the timer expiring first, if the thread doing
>> > > > > the waiting gets delayed sufficiently long for the event to happen.
>> > > >
>> > > > That can already happen, e.g.
>> > > >
>> > > > 1. wakeup happens and condition is true.
>> > > > 2. we compute remaining jiffies > 0
>> > > > -> preempt
>> > > > 3. now wait_for_event_timeout returns.
>> > > >
>> > > > Only difference is that the delay/preempt happens in between 1. and
>> > > > 2., and then suddenly the wake up didn't happen in time (with the
>> > > > current return code semantics).
>> > > >
>> > > > So imo the current behaviour is simply a bug and will miss timely
>> > > > wakeups in some cases.
>> > > >
>> > > > The other way round, namely wait_for_event_timeout taking longer than
>> > > > the timeout is expected (and part of the interface for every timeout
>> > > > function). So all current callers already need to be able to cope with
>> > > > random preemption/delays pushing the total time before the call to
>> > > > wait_for_event and checking the return value over the timeout, even
>> > > > when condition was signalled in time.
>> > > >
>> > > > If there's any case which relies on accurate timeout detection that
>> > > > simply won't work with wait_for_event (they need an nmi or a hw
>> > > > timestamp counter or something similar).
>> > >
>> > > I seriously doubt that anyone is depending on any sort of accuracy on
>> > > the return. 1 jiffy is not going to make or break anything - in fact,
>> > > jiffies could be incremented nsecs after the initial call. So a
>> > > granularity of at least 1 is going to be expected in any case.
>> > >
>> > > The important bit here is that the API should behave as expected. And
>> > > the most logical way to code that is to check the return value. I can
>> > > easily see people forgetting to re-check the condition, hence you get a
>> > > bug. The fact that you and the original reporter already had accidents
>> > > with this is a clear sign that the logical way to use the API is not the
>> > > correct one.
>> > >
>> > > IMHO, the change definitely makes sense.
>> >
>> > Ok, so taking courage of this answer ;P How about also the following?
>> >
>> > diff --git a/kernel/timer.c b/kernel/timer.c
>> > index dbf7a78..5a62456 100644
>> > --- a/kernel/timer.c
>> > +++ b/kernel/timer.c
>> > @@ -1515,7 +1515,11 @@ signed long __sched schedule_timeout(signed long
>> > timeout)
>> >             }
>> >     }
>> >
>> > -   expire = timeout + jiffies;
>> > +   /*
>> > +    * We can't be sure how close we are to the next tick, so +1 to
>> > +    * guarantee that we wait at least timeout amount.
>> > +    */
>> > +   expire = timeout + jiffies + 1;
>> >
>> >     setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
>> >     __mod_timer(&timer, expire, false, TIMER_NOT_PINNED);
>> >
>> >
>> > It'd plug a similar hole for wait_event_timeout() and similar users, who
>> > don't compensate for the above..
>>
>> Any jiffy based API is going to have this issue. I think it's different
>> from the original patch, which just makes the API potentially return
>> something that is confusing.
>
> Yea, at least those that take a relative time. Usually the timeout is
> given with a big overhead, so there it won't be a problem. But I also
> found users like drivers/acpi/ec.c, that will pass a timeout of 1
> jiffies, which may then result in premature timeouts.

In drm/i915 we have a bunch of those 1 jiffie timeouts, too,
especially with low HZ configs. For easy comparison with hw docs we
try to stick to the documented timeout limits and convert them with
msec_to_jiffies (which does the right thing wrt rounding). But since
these timeouts are often in the low ms range, that often means just 1
jiffie timeouts. So the timeout could be off by a large factor (and we
have the bugzillas to prove it happens in reality).

I'm not sure whether sprinkling +1 all over the codebase is a that
nice approach. Adding the +1 in sched_timeout otoh would give us a
nice idiot proof interface for driver guys like me. We also have some
custom register wait loops using msleep(1) and jiffy based timeouts,
and there our driver macro does the +1. That helped a lot in avoiding
stupid bugs, but now we've converted a few things over to interrupts +
timeout and the bugs are back ...
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
