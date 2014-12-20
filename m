Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaLTSZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:25:45 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:34852 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLTSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:25:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
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
	<CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
Date: Sat, 20 Dec 2014 10:25:40 -0800
X-Google-Sender-Auth: Tawyv40ZlrcruN8Cwh4M7_HY5XA
Message-ID: <CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
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

On Fri, Dec 19, 2014 at 5:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm claiming that the race happened *once*. And it then corrupted some
> data structure or similar sufficiently that CPU0 keeps looping.
>
> Perhaps something keeps re-adding itself to the head of the timerqueue
> due to the race.

So tick_sched_timer() does

        ktime_t now = ktime_get();
        ...
        hrtimer_forward(timer, now, tick_period);
        return HRTIMER_RESTART;

and then __run_hrtimer does

        enqueue_hrtimer(timer, base);

which just adds the timer back on the tiemr heap.

So all you need to get an infinite loop (as far as I can see) is that
hrtimer_forward() doesn't actually move the timer forward.

The most likely reason would seem to be this:

        delta = ktime_sub(now, hrtimer_get_expires(timer));

        if (delta.tv64 < 0)
                return 0;

and clearly it *should* return a positive number, since the timer has
expired, so the expiry time _should_ be smaller than "now". So it
should never trigger, and this bug is clearly impossible.

HOWEVER.

It turns out that while tick_sched_timer() does "ktime_get()" to get
the current time, the actual timer machinery does *not* do that at
all. The actual timer machinery does

        entry_time = now = hrtimer_update_base(cpu_base);

                base = cpu_base->clock_base + i;
                basenow = ktime_add(now, base->offset);

_once_ per hrtimer_clock_base. And then it iterates using that
"basenow" thing, and  compares it to the timer expiry.

So we have two different times. Now, let's think about what happens if
those clocks aren't quote in sync.

We know (since __run_hrtimer was called) that

        basenow.tv64 > hrtimer_get_softexpires_tv64(timer)

but here we have "basenow" - which is not that ktime_get(), and we
have "hrtimer_get_softexpires_tv64()" (which is not
hrtimer_get_expires() in general - we have all that "delta" range
handling, but for the scheduling tick it *should* be the same).

So I can see at least one lockup:

 - if "expires < basenow" hrtimer_interrupt() will run the timer
 - if "now < expires" hrtimer_forward() will not do anything, and will
just reschedule the timer with the same expiration

iow, all you need for a re-arming of the same timer is:

   now < expires < basenow

now, the two clocks (now and basenow) are not the same, but they do
have the same *base*. So they are related, but even the base time was
gotten under two different sequence locks, so even the base could have
been updated in between the hrtimer_update_base() time and the
ktime_get(). And even though they have the same base, they have
different offsets: basenow does that "base->offset" thing (and
ktime_get_update_offsets_now() does timekeeping_get_ns()

 - now = ktime_get() does

                base = tk->tkr.base_mono;
                nsecs = timekeeping_get_ns(&tk->tkr);

 - basenow = ktime_get_update_offsets_now() does

                base = tk->tkr.base_mono;
                nsecs = timekeeping_get_ns(&tk->tkr);
          .. and then ..
                ktime_add(.., base->offset);

and if I read the thing right, the ktime_add() should be a no-op,
because base->offset should be 0 for the normal monotonic clock.
Right?

So the two times (now and basenow) *should* be the same time, and the
whole "now < expires < basenow" situation can never happen. Right?

Potentially wrong.

Because that's where the whole "different sequence locks" comes in.
The one-time race could be something that updates the base in between
the (one-time) ktime_get_update_offsets_now() and the (then as a
result pseudo-infinitely repeating) ktime_get.

Hmm? If "base" ever goes backwards, or if "base" does *not* update
atomically with the HPET timer overflows, I can see that happening. Of
course, that would imply that ktime_get() is not monotonic. But we do
know that we've had odd time issues on that machine.

I think you already had DaveJ check clock monotonicity. But that was
with the TSC, wasn't it? I'm claiming maybe the HPET isn't monotonic,
and there is some HPET clocksource issue with overflow in 32 bits.

(I think the HPET *should* be 64-bit, and just the comparators for
interrupts may be 32-bit, but we use a "readl()" and only use the low
32-bits even if the upper 32 bits *might* be ok).

I keep harping on that HPET overflow, because we actually have the 6
"locked up" HPET traces, and then we have a seventh without that
lockup, and there definitely was a overflow in 32 bits:

  [torvalds@i7 linux]$ grep -3 read_hpet+0x16 ~/dj-1.txt | grep RAX
   RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
   RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000
   RAX: 0000000091ca7f65 RBX: 0000000000513346 RCX: 0000000000000000
   RAX: 00000000a9afbd0d RBX: 000000000051491e RCX: 0000000000000000
   RAX: 00000000cbd1340c RBX: 000000000051684a RCX: 0000000000000000
   RAX: 00000000fb9d303f RBX: 00000000005193fc RCX: 0000000000000000
   RAX: 000000002b67efe4 RBX: 000000000051c224 RCX: 0000000000000004

and I have just gotten hung up on that small detail.

How/where is the HPET overflow case handled? I don't know the code enough.

(Also, maybe I shouldn't be so hung up on this *one* long trace from
DaveJ. There's been a lot of crazy traces from that machine. We've had
some time-handling questions about it before, but *most* of the traces
have not been implicating the HPET like this one, so..)

                            Linus
