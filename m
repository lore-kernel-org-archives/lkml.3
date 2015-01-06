Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbbAFBR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:17:58 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:35175 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbAFBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxZ7yj7Jdt1H9JQJNQUgZSLft_b=rAZv0tw95tjQ0Eq2A@mail.gmail.com>
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
Date: Mon, 5 Jan 2015 17:17:54 -0800
Message-ID: <CALAqxLWaYvnOyXkyME8rhhu2y84aVnb79apgCxN+LmQcbNSU5A@mail.gmail.com>
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

On Sun, Jan 4, 2015 at 11:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 2, 2015 at 4:27 PM, John Stultz <john.stultz@linaro.org> wrote:
>>
>> So I sent out a first step validation check to warn us if we end up
>> with idle periods that are larger then we expect.
>
> .. not having tested it, this is just from reading the patch, but it
> would *seem* that it doesn't actually validate the clock reading much
> at all.
>
> Why? Because most of the time, for crap clocks like HPET, the real
> limitation will be not the multiplication overflow, but the "mask",
> which is just 32-bit (or worse - I think the ACPI PM timer might be
> just 24 bits).
>
> So then you effectively "validate" that the timer difference value
> fits in mask, but that isn't any validation at all - it's just a
> truism. Since we by definition mask the difference to just the valid
> bitmask.
>
> So I really think that the maximum valid clock needs to be narrowed
> down from the "technically, this clock can count to X".
>
> But maybe I'm wrong, and the multiplication overflow is actually often
> the real limit. What are the actual values for real timer sources?


As you point out, for clocksources where the mask is 32bits or under,
we shouldn't have any risk of multiplication overflow, since mult is a
32bit. So yes, the max_cycles on those probably should be the same as
the mask, and isn't useful on those clocksources to test if we run
over (though warning if we're within the 12% margin could be useful).
But for clocksources who have larger masks, it still could be a useful
check (@2ghz tscs overflow 32bits in 2 seconds), although the mult
value is targets an mult overflow at ~10 minutes, so its less likely
that we really hit it.

However, it ends up the calculations we use are a little more
conservative, treating the result as signed and so they avoid
multiplications that could run into a that sign bit. This looks like
an error to me (the code is also used for clockevents, so I haven't
run through to see if the requirements are different there), but a
conservative one, which results in the maximum idle interval to be
~halved what they could be (and we add yet another 12% margin on that
- so we probably need to just pick one or the other, not both).

So even on 32bit masks, max_cycles in my patch is smaller then 32bits.
That's why I was able to hit both warnings in my testing with the hpet
by sending SIGSTOP to qemu.

Anyway, It may be worth keeping the 50% margin (and dropping the 12%
reduction to simplify things), since I've not heard recent complaints
about timekeeping limiting idle lengths (but could be wrong here).
This would give you something closer to the 1/8th of the mask that you
were using in your patch (and on larger mask clocksources, we do
already cap the interval at 10 minutes - so most really crazy values
would be caught for clocksources like the TSC - and maybe we can make
this more configurable so we can shorten it as done in your patch to
try to debug things).

I've also got a capping patch that I'm testing that keeps time reads
from passing that interval. The only thing I'm really cautious about
with that change is that we have to make sure the hrtimer that
triggers update_wall_clock is always set to expire within that cap (I
need to review it again) or else we'll hang ourselves.

thanks
-john
