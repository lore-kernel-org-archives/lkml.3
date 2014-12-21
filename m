Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaLUVW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:22:26 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:62263 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaLUVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
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
	<CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
	<CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
Date: Sun, 21 Dec 2014 13:22:21 -0800
X-Google-Sender-Auth: 09iIXVwHOKPXjyc9qohGH3Cbq9U
Message-ID: <CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
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

On Sat, Dec 20, 2014 at 1:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm, ok, I've re-acquainted myself with it. And I have to admit that I
> can't see anything wrong. The whole "update_wall_clock" and the shadow
> timekeeping state is confusing as hell, but seems fine. We'd have to
> avoid update_wall_clock for a *long* time for overflows to occur.
>
> And the overflow in 32 bits isn't that special, since the only thing
> that really matters is the overflow of "cycle_now - tkr->cycle_last"
> within the mask.
>
> So I'm not seeing anything even halfway suspicious.

.. of course, this reminds me of the "clocksource TSC unstable" issue.

Then *simple* solution may actually be that the HPET itself is
buggered. That would explain both the "clocksource TSC unstable"
messages _and_ the "time went backwards, so now we're re-arming the
scheduler tick 'forever' until time has gone forwards again".

And googling for this actually shows other people seeing similar
issues, including hangs after switching to another clocksource. See
for example

   http://stackoverflow.com/questions/13796944/system-hang-with-possible-relevance-to-clocksource-tsc-unstable

which switches to acpi_pm (not HPET) and then hangs afterwards.

Of course, it may be the switching itself that causes some issue.

Btw, there's another reason to think that it's the HPET, I just realized.

DaveJ posted all his odd TSC unstable things, and the delta was pretty
damn random. But it did have a range: it was in the 1-251 second
range.

With a 14.318MHz clock (which is, I think, the normal HPET frequency),
a 32-bit overflow happens in about 300 seconds.

So the range of 1-251 seconds  is not entirely random. It's all in
that "32-bit HPET range".

In contrast, wrt the TSC frequency, that kind of range makes no sense at all.

                          Linus
