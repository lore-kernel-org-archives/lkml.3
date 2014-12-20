Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaLTB5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:57:09 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46294 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaLTB5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:57:07 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412200100130.17382@nanos>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<alpine.DEB.2.11.1412192201520.17382@nanos>
	<CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
	<alpine.DEB.2.11.1412200100130.17382@nanos>
Date: Fri, 19 Dec 2014 17:57:05 -0800
X-Google-Sender-Auth: oXTy4vR4PshdhPzbUAjKvRyv4ro
Message-ID: <CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
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

On Fri, Dec 19, 2014 at 5:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> The watchdog timer runs on a fully periodic schedule. It's self
> rearming via
>
>          hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
>
> So if that aligns with the equally periodic tick interrupt on the
> other CPU then you might get into that situation due to the fully
> synchronizing and serializing nature of HPET reads.

No. Really. No.

There is no way in hell that a modern system ends up being that
synchronized. Not to the point that the interrupt also happens at the
*exact* same point.

Thomas, you're in denial. It's not just the exact same instruction in
the timer interrupt handler ("timer interrupts and NMI's are in
sync"), the call chain *past* the timer interrupt is the exact same
thing too.  The stack has the same contents. So not only must the two
CPU's be perfectly in sync so that the NMI always triggers on exactly
the same instruction, the CPU that takes the timer interrupt (in your
schenario, over and over again) must be magically filling the stack
with the exact same thing every time.

That CPU isn't making progress that just happens to be "synchronized".

Admit it, you've not seen a busy system that is *so* synchronized that
you get timer interrupts and NMI's that hit on the same instruction
over a sequence of minutes.

> So lets assume there is that hrtimer_remove race (I'm certainly going
> to stare at that tomorrow with fully awake brain. It's past beer
> o'clock here). How do you explain that:
>
> 1) the watchdog always triggers on CPU1?
>
> 2) the race only ever happens on CPU0?

I'm claiming that the race happened *once*. And it then corrupted some
data structure or similar sufficiently that CPU0 keeps looping.

Perhaps something keeps re-adding itself to the head of the timerqueue
due to the race.

The watchdog doesn't trigger on CPU0, because this is the software
watchdog, and interrupts are disabled on CPU0, and CPU0 isn't making
any progress. Because it's looping in a fairly tight loop.

The watchdog triggers on CPU1 (over and over again) because CPU1 is
waiting for the TLB shootdown to complete. And it doesn't, because
interrupts are disabled on CPU0 that it's trying to shoot down the TLB
on.

That theory at least fits the data. So CPU1 isn't doing anything odd at all.

In a way that "magic happens so that everything is so synchronized
that you cross-syncornize two CPU's making real progress over many
minutes". THAT sounds like just a fairy tale to me.

Your argument "it has a question mark in front of it" objection is
bogus. We got an *interrupt* in the middle of the call chain. Of
*course* the call chain is unreliable. It doesn't matter. What matters
is that the stack under the interrupt DOES NOT CHANGE. It doesn't even
matter if it's a real honest-to-god callchain or not, what matters is
that the kernel stack under the interrupt is unchanged. No way does
that happen if it's making progress at the same time.

> 3) the hrtimer interrupt took too long message never appears?

At a guess, it's looping (for a long long time) on
timerqueue_getnext() in hrtimer_interrupt(), and then returns. Never
gets to the retry or the "interrupt took %llu" messages.

And we know what timer entry it is looping on:  tick_sched_timer.
Which does a HRTIMER_RESTART, so the re-enqueueing isn't exactly
unlikely.

All it needs is that the re-enqueueing has gotten confused enough that
it re-enqueues it on the same queue over and over again.  Which would
run tick_sched_timer over and over again. No? Until the re-enqueuing
magically stops (and we do actually have a HPET counter overflow
there. Just look at the RAX values:

 RAX: 00000000fb9d303f
 RAX: 000000002b67efe4

that 00000000fb9d303f is the last time we see that particular
callchain. The next time we see hpet_read(), it's that
000000002b67efe4 thing.

So my "maybe it has something to do with HPET overflow" wasn't just a
random throw-away comment. We actually have real data saying that the
HPET *did* overflow, and it in fact happened somewhere around the time
when the lockup went away.

Are they related? Maybe not. But dammit, there's a lot of
"coincidences" here. Not just the "oh, it always takes the NMI on the
exact same instruction".

> 4) the RT throttler hit?
> 5) that the system makes progress afterwards?

.. something eventually clears the problem, maybe because of the HPET
overflow. I dunno. I'm just saying that your arguments to ignore CPU0
are pretty damn weak.

So I think the CPU1 behavior is 100% consistent with CPU0 just having
interrupts disabled.

So I think CPU1 is _trivial_ to explain if you accept that CPU0 is
doing something weird.

Which is why I think your "look at CPU1" sounds so strange. I don't
think CPU1 is all that interesting. I can *trivially* explain it with
a single sentence, and did exactly that above.

Can you trivially explain CPU0? Without the "it's just a big
coincidence that we take  the NMI on the same instruction for several
minutes, and the stack under the timer interrupt hasn't changed at all
in that same time".

                     Linus
