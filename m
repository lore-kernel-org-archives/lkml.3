Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbbACA1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 19:27:22 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48255 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbACA1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 19:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyySYFJjV5689Ej+Rer_igR0R1S5=h0GwWpWpA6Tk1Okw@mail.gmail.com>
References: <CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
	<20141222225725.GA8140@codemonkey.org.uk>
	<CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com>
	<20141224030125.GA8725@codemonkey.org.uk>
	<20141226163410.GA25161@codemonkey.org.uk>
	<20141226181204.GA26527@codemonkey.org.uk>
	<CA+55aFyySYFJjV5689Ej+Rer_igR0R1S5=h0GwWpWpA6Tk1Okw@mail.gmail.com>
Date: Fri, 2 Jan 2015 16:27:19 -0800
Message-ID: <CALAqxLX7ad_B82A9=O30v0PVqq2LKiSF7wOkGOytC=SuBh7wcg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: John Stultz <john.stultz@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 12:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 26, 2014 at 10:12 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>> On Fri, Dec 26, 2014 at 11:34:10AM -0500, Dave Jones wrote:
>>
>>  > One thing I think I'll try is to try and narrow down which
>>  > syscalls are triggering those "Clocksource hpet had cycles off"
>>  > messages.  I'm still unclear on exactly what is doing
>>  > the stomping on the hpet.
>>
>> First I ran trinity with "-g vm" which limits it to use just
>> a subset of syscalls, specifically VM related ones.
>> That triggered the messages. Further experiments revealed:
>
> So I can trigger the false positives with my original patch quite
> easily by just putting my box under some load. My numbers are nowhere
> near as bad as yours, but then, I didn't put it under as much load
> anyway. Just a regular "make -j64" of the kernel.
>
> I suspect your false positives are bigger partly because of the load,
> but mostly because you presumably have preemption enabled too. I don't
> do preemption in my normal kernels, and that limits the damage of the
> race a bit.
>
> I have a newer version of the patch that gets rid of the false
> positives with some ordering rules instead, and just for you I hacked
> it up to say where the problem happens too, but it's likely too late.
>
> The fact that the original racy patch seems to make a difference for
> you does say that yes, we seem to be zeroing in on the right area
> here, but I'm not seeing what's wrong. I was hoping for big jumps from
> your HPET, since your "TSC unstable" messages do kind of imply that
> such really big jumps can happen.
>
> I'm attaching my updated hacky patch, although I assume it's much too
> late for that machine. Don't look too closely at the backtrace
> generation part, that's just a quick hack, and only works with frame
> pointers enabled anyway.
>
> So I'm still a bit unhappy about not figuring out *what* is wrong. And
> I'd still like the dmidecode from that machine, just for posterity. In
> case we can figure out some pattern.
>
> So right now I can imagine several reasons:
>
>  - actual hardware bug.
>
>    This is *really* unlikely, though. It should hit everybody. The
> HPET is in the core intel chipset, we're not talking random unusual
> hardware by fly-by-night vendors here.
>
>  - some SMM/BIOS "power management" feature.
>
>    We've seen this before, where the SMM saves/restores the TSC on
> entry/exit in order to hide itself from the system. I could imagine
> similar code for the HPET counter. SMM writers use some bad drugs to
> dull their pain.
>
>    And with the HPET counter, since it's not even per-CPU, the "save
> and restore HPET" will actually show up as "HPET went backwards" to
> the other non-SMM CPU's if it happens
>
>  - a bug in our own clocksource handling.
>
>    I'm not seeing it. But maybe my patch hides it for some magical reason.

So I sent out a first step validation check to warn us if we end up
with idle periods that are larger then we expect.

It doesn't yet cap the timekeeping_get_ns() output (like you're patch
effectively does), but it would be easy to do that in a following
patch.

I did notice while testing this that the max_idle_ns (max idle time we
report to the scheduler) for the hpet is only ~16sec, and we'll
overflow after just ~21seconds. This second number maps closely to the
22 second stalls seen in the  nmi watchdog reports which seems
interesting, but I also realize that qemu uses a 100MHz hpet, where as
real hardware is likely to be a bit slower, so maybe that's just
chance..

I'd be interested if folks seeing anything similar to Dave would give
my patch a shot.

thanks
-john
