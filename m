Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaLWAqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:46:44 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63445 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaLWAqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:46:43 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLUQpF6nTWXGdwd=kTchtm-uQW=5_1wMadNCdTdJcv1Fng@mail.gmail.com>
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
	<CALAqxLUQpF6nTWXGdwd=kTchtm-uQW=5_1wMadNCdTdJcv1Fng@mail.gmail.com>
Date: Mon, 22 Dec 2014 16:46:42 -0800
X-Google-Sender-Auth: 1RkFXig4tjBhNzFPI9K1J-P44sk
Message-ID: <CA+55aFxrtYmLe8xnn1RfUZv6yDkxKr1efea9X+C0jhLS7=sCBw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
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

On Mon, Dec 22, 2014 at 3:59 PM, John Stultz <john.stultz@linaro.org> wrote:
>
> * So 1/8th of the interval seems way too short, as there's
> clocksources like the ACP PM, which wrap every 2.5 seconds or so.

Ugh. At the same time, 1/8th of a range is actually bigger than I'd
like, since if there is some timer corruption, it means that we only
catch it when it's in really big.

But as I said, I'd actually prefer it to be time-based, because it
would be good if this approach worked on things like the TSC which is
a 64-bit counter..

So yes, that capping was very much arbitrary, and was mostly a case of
"this works with the one timer source that I can easily trigger"

> * I suspect something closer to the clocksource_max_deferment() value
> (which I think is max interval before multiplication overflows could
> happen - ~12%) which we use in the scheduler would make more sense.
> Especially since the timer scheduler uses that to calculate how long
> we can idle for.

I'd rather not be anywhere *close* to any overflow problems. Even for
the scheduler all-idle case, I'd argue that there is rather quickly
diminishing returns. Yes, a thousand timer interrupts per second are
expensive and a noticeable power draw. The difference between "one
timer interrupt every two seconds" and "every 20 seconds" is rather
less noticeable.

Of course, reasonable clock sources have *much* longer periods than a
second (yeah, the acpi pm timer really isn't a good one), so there are
probably good middle grounds, The 1/8th was a hack, and one that was
aware of teh 300s cycle of the HPET at that..

> * Nulling out delta in timekeeping_get_ns() seems like it could cause
> problems since time would then possibly go backwards compared to
> previous reads (as you mentioned, resulting in smaller time jumps).
> Instead it would probably make more sense to cap the delta at the
> maximum value (though this assumes the clock doesn't jump back in the
> interval before the next call to update_wall_time).

So part of the nulling was that it was simpler, and part of it was
that I expected to get backwards jumps (see the other email to Dave
about the inherent races). And with the whole timer mask modulo
arithmetic, those backwards jumps just look like biggish positive
numbers, not even negative. So it ends up being things like "is it an
unsigned number larger than half the mask? Consider it negative" etc.

The "zero it out" was simple, and it worked for my test-case, which
was "ok, my machine no longer locks up when I mess with the timer".

And I didn't post the earlier versions of that patch that didn't even *boot*.

I started out trying to do it at a higher level (not on a clock read
level, but outside the whole 'convert-to-ns and do the sequence  value
check'), but during bootup we play a lot of games with initializing
the timer sources etc.

So that explains the approach of doing it at that

   cycle_now = tkr->read(tkr->clock);

level, and keeping it very low-level.

But as I already explained in the email that crossed, that low-level
thing also results in some fundamental races.

> * Also, as you note, this would just cause the big time jump to only
> happen at the next update, since there's no logic in
> update_wall_time() to limit the jump. I'm not sure if "believing" the
> large jump at write time make that much more sense, though.

So I considered just capping it there (to a single interval or
something). Again, just ignoring - like the read side does - it would
have been easier, but at the same time I *really* wanted to make time
go forward, so just taking the big value seemed safest.

But yes. this was very much a RFC patch. It's not even ready for real
use, as DaveJ found out (although it might be good enough in practice,
despite its flaws)

> * Finally, you're writing to error while only holding a read lock, but
> that's sort of a minor thing.

It's not a minor thing, but the alternatives looked worse.

I really wanted to make it per-cpu, and do this with interrupts
disabled or something. But that then pushes a big problem to the write
time to go over all cpu's and see if there are errors.

So it's not right. But .. It's a hacky patch to get discussion
started, and it's actually hard to do "right" when this code has to be
basically lockless.

> * Checking the accumulation interval isn't beyond the
> clocksource_max_deferment() value seems like a very good check to have
> in update_wall_time().

Sounds like a good idea. Also, quite frankly, reading all the code I
wasn't ever really able to figure out that things don't overflow. The
overflow protection is a bit ad-hoc (that maxshift thing in
update_wall_time() really makes baby Jesus cry, despite the season,
and it wasn't at all obvious that ntp_tick_length() is fundamentally
bigger than xtime_interval, for example).

It's also not clear that the complicated and frankly not-very-obvious
shift-loop is any faster than just using a divide - possibly with the
"single interval" case being a special case to avoid dividing then.

I was a bit nervous that the whole update of tkr.cycle_last in there
could just overrun the actual *read* value of 'tk->tkr.clock'. With
the whole offset logic split between update_wall_time() and
logarithmic_accumulation(), the code isn't exactly self-explanatory.

Heh.

> * Maybe when we schedule the next timekeeping update, the tick
> scheduler could store the expected time for that to fire, and then we
> could validate that we're relatively close after that value when we do
> accumulate time (warning if we're running too early or far too late -
> though with virtualziation, defining a "reasonable" late value is
> difficult).

In general, it would be really nice to know what the expected limits
are. It was hard to impossible to figure out the interaction between
the timer subsystem and the scheduler tick. It's pretty incestuous,
and if there's an explanation for it, I missed it.

> * This "expected next tick" time could be used to try to cap read-time
> intervals in a similar fashion as done here. (Of course, again, we'd
> have to be careful, since if that expected next tick ends up somehow
> being before the actual hrtimer expiration value, we could end up
> stopping time - and the system).

I don't think you can cap them to exactly the expected value anyway,
since the wall time update *will* get delayed by locking and just
interrupts being off etc. And virtual environments will obviously make
it much worse. So the capping needs to be somewhat loose anyway.

The patch I posted was actually sloppy by design, exactly because I
had so much trouble with trying to be strict. My first patch was a
percpu thing that just limited ktime_get() from ever going backwards
on that particular cpu (really simple, real;ly stupid), and it got
*nowhere*.

                        Linus
