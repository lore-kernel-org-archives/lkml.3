Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaLVX72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:59:28 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:47549 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaLVX7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
References: <20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<alpine.DEB.2.11.1412192201520.17382@nanos>
	<CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
	<alpine.DEB.2.11.1412200100130.17382@nanos>
	<CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
	<CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
	<CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
	<CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
Date: Mon, 22 Dec 2014 15:59:22 -0800
Message-ID: <CALAqxLUQpF6nTWXGdwd=kTchtm-uQW=5_1wMadNCdTdJcv1Fng@mail.gmail.com>
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

On Mon, Dec 22, 2014 at 11:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Dec 21, 2014 at 4:41 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> This is *not* to say that this is the bug you're hitting. But it does show that
>>
>>  (a) a flaky HPET can do some seriously bad stuff
>>  (b) the kernel is very fragile wrt time going backwards.
>>
>> and maybe we can use this test program to at least try to alleviate problem (b).
>
> Ok, so after several false starts (ktime_get() is really really
> fragile - called in scheduler things, and doing magic things at
> bootup), here is something that seems to alleviate the problem for me.
>
> I still get a lot of RCU  messages like "self-detected stall" etc, but
> that's to be expected. When the clock does odd things, crap *will*
> happen.
>
> But what this does is:
>
>  (a) make the error more visible as a clock error rather than various
> random downstream users
>
>      IOW, it prints things out when it looks like we're getting odd
> clock read errors (arbitrary cut-off: we expect clock read-outs to be
> withing 1/8th of the range of the expected clock value)

(Warning: I'm replying with my vacation goggles on)

A few thoughts from quickly looking at the patch (some of this is
repeating your comments here):

* So 1/8th of the interval seems way too short, as there's
clocksources like the ACP PM, which wrap every 2.5 seconds or so. And
even with more reasonable clocksource wrapping intervals, the tick
scheduler may not schedule the next tick till after that time, which
could cause major problems (we don't want the hrtimer expiration
calculation to get capped out here, since the timer may be scheduled
past 1/8th of the interval, which would keep us from ever accumulating
time and clearing the cycle_error added here)

* I suspect something closer to the clocksource_max_deferment() value
(which I think is max interval before multiplication overflows could
happen - ~12%) which we use in the scheduler would make more sense.
Especially since the timer scheduler uses that to calculate how long
we can idle for.

* Nulling out delta in timekeeping_get_ns() seems like it could cause
problems since time would then possibly go backwards compared to
previous reads (as you mentioned, resulting in smaller time jumps).
Instead it would probably make more sense to cap the delta at the
maximum value (though this assumes the clock doesn't jump back in the
interval before the next call to update_wall_time).

* Also, as you note, this would just cause the big time jump to only
happen at the next update, since there's no logic in
update_wall_time() to limit the jump. I'm not sure if "believing" the
large jump at write time make that much more sense, though.

* Finally, you're writing to error while only holding a read lock, but
that's sort of a minor thing.

I do agree something that is more helpful in validating the
timekeeping here would be nice to avoid further geese chases in the
future.

Some possible ideas:
* Checking the accumulation interval isn't beyond the
clocksource_max_deferment() value seems like a very good check to have
in update_wall_time().

* Maybe when we schedule the next timekeeping update, the tick
scheduler could store the expected time for that to fire, and then we
could validate that we're relatively close after that value when we do
accumulate time (warning if we're running too early or far too late -
though with virtualziation, defining a "reasonable" late value is
difficult).

* This "expected next tick" time could be used to try to cap read-time
intervals in a similar fashion as done here. (Of course, again, we'd
have to be careful, since if that expected next tick ends up somehow
being before the actual hrtimer expiration value, we could end up
stopping time - and the system).

I can try to add some of this when I'm back from holiday in the new year.

Maybe Thomas will have some other ideas?

thanks
-john
