Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbbAFCFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:05:33 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55193 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbAFCF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwV93C22B78mOFrX1aLr9meBLOHp+7Kci_YYdcktfuDfw@mail.gmail.com>
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
	<CALAqxLX7ad_B82A9=O30v0PVqq2LKiSF7wOkGOytC=SuBh7wcg@mail.gmail.com>
	<CA+55aFxZ7yj7Jdt1H9JQJNQUgZSLft_b=rAZv0tw95tjQ0Eq2A@mail.gmail.com>
	<CALAqxLWaYvnOyXkyME8rhhu2y84aVnb79apgCxN+LmQcbNSU5A@mail.gmail.com>
	<CA+55aFwV93C22B78mOFrX1aLr9meBLOHp+7Kci_YYdcktfuDfw@mail.gmail.com>
Date: Mon, 5 Jan 2015 18:05:28 -0800
Message-ID: <CALAqxLXo_unMw3GHyCAbFHWM7ym-D-AiNeGaCB6vO-=EMh+k8A@mail.gmail.com>
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

On Mon, Jan 5, 2015 at 5:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 5, 2015 at 5:17 PM, John Stultz <john.stultz@linaro.org> wrote:
>>
>> Anyway, It may be worth keeping the 50% margin (and dropping the 12%
>> reduction to simplify things)
>
> Again, the 50% margin is only on the multiplication overflow. Not on the mask.

Right, but we calculate the mult value based on the mask (or 10 mins,
whichever is shorter).

So then when we go back and calculate the max_cycles/max_idle_ns using
the mult, we end up with a value smaller then the mask. So the
scheduler shouldn't push idle times out beyond that and the debug
logic in my patch should be able to catch strangely large values.

> So it won't do anything at all for the case we actually care about,
> namely a broken HPET, afaik.

Yea, the case my code doesn't catch that yours did is for slightly
broken clocksources (I'm thinking two cpus which virtual hpets
embedded in them that are slightly off) where you could get negative
deltas right after the update. In that case the capping on read is
really needed since by the next update the stale value has grown large
enough to look like a reasonable offset. The TSC has a similar issue,
but its easier to check for negative values because it won't
reasonably ever overflow.

>
> I'd much rather limit to 50% of the mask too.

Ok, I'll try to rework the code to make this choice and make it more
explicitly clear.


> Also, why do we actually play games with ilog2 for that overflow
> calculation? It seems pointless. This is for the setup code, doing a
> real division there would seem to be a whole lot more straightforward,
> and not need that big comment. And there's no performance issue. Am I
> missing something?

I feel like there was a time when this may have been called by some of
the clocksource code if it they changed frequency (I think over
suspend/resume), but I'm not seeing it in the current source. So yea,
likely something to simplify.

>> I've also got a capping patch that I'm testing that keeps time reads
>> from passing that interval. The only thing I'm really cautious about
>> with that change is that we have to make sure the hrtimer that
>> triggers update_wall_clock is always set to expire within that cap (I
>> need to review it again) or else we'll hang ourselves.
>
>  Yeah, that thing is fragile. And quite possibly part of the problem.

"Time is a flat circle..." and thus unfortunately requires some
circular logic. :)

thanks
-john
