Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaLVX7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:59:21 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54044 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaLVX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141222225725.GA8140@codemonkey.org.uk>
References: <alpine.DEB.2.11.1412200100130.17382@nanos>
	<CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
	<CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
	<CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
	<CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
	<20141222225725.GA8140@codemonkey.org.uk>
Date: Mon, 22 Dec 2014 15:59:19 -0800
X-Google-Sender-Auth: rTxYnLEObmo31wqJEPL0t3VFjb0
Message-ID: <CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 2:57 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> I tried the nohpet thing for a few hours this morning and didn't see
> anything weird, but it may have been that I just didn't run long enough.
> When I saw your patch, I gave that a shot instead, with hpet enabled
> again.  Just got back to find lots of messages in dmesg, but none
> of the usual NMI/lockup messages.

Hmm. So my patch is a bit sloppy, and I suspect that the sloppiness
may account for some - and quite probably all - of those numbers.

Some of your numbers are pretty big (it's a 32-bit mask, so they are
all really just pretty small negative numbers), but they are still in
the 2us .. 165ms range when taking the 14MHz HPET counter into
account.  So not huge timer shifts.

And the sloppiness of the patch is two-fold:

One problem with my patch is that it does that "tkr->cycle_error"
without any locking (because it's running in various environmetns
where locking really doesn't work, and we can't even sanely disable
preemption because we might well be inside the scheduler etc.

So this:

          cycle_now = tkr->read(tkr->clock) + tkr->cycle_error;

          /* calculate the delta since the last update_wall_time: */
          delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);

          /* Hmm? This is really not good, we're too close to overflowing */
          if (unlikely(delta > (tkr->mask >> 3))) {
                  tkr->cycle_error = delta;
                 delta = 0;
          }

might run concurrently on two CPU's, and then that tkr->cycle_error
access isn't serialized, so a "later" read of the HPET clock could end
up being written to tkr->cycle_error before. So that can account for
small errors: you'd have a "cycle_error" that gets updated on one CPU,
and then used to correct for an "earlier" read of the clock on another
CPU, and that could make the cycle error possibly worse.

However, that first race only matters if you get errors to begin with,
so if that was the only race, it would still show that some real error
happened.

BUT.

The *bigger* problem is that since the reading side cannot hold any
locks at all, it can also race against the writing side. That's by
design, and we will use the sequence counter to recover from it and
try again, but it means that some of those small errors are just a
reader racing with the wall-time update code, and since this error
code is done _inside_ the read-sequence code, it's not aware of the
retry, and will give a false positive even if we then later on throw
the known-bad result out and re-try.

So your small negative numbers are most likely just those false positives.

I was more hoping to see some big sudden jumps on the order of your
20-second delays - the kinds of jumps that your "tsc unstable"
messages implied (which weren't in the 2us .. 165ms range, but in the
2s to 250s range)

Ugh. I guess I'll have to try to figure out a non-sloppy thing, but
quite frankly, the non-sloppy things I tried first were rather painful
failures. The sloppy thing was sloppy, but worked well to see the
disaster case.

I'll put on my thinking cap. Maybe I can move the "cycle_error" logic
to outside the sequence lock retry loop.

But in the meantime please do keep that thing running as long as you
can. Let's see if we get bigger jumps. Or perhaps we'll get a negative
result - the original softlockup bug happening *without* any bigger
hpet jumps.

                         Linus
