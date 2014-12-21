Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaLUX6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:58:20 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35622 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaLUX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:58:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141221223204.GA9618@codemonkey.org.uk>
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
Date: Sun, 21 Dec 2014 15:58:18 -0800
X-Google-Sender-Auth: 1l3gZbP1crYi6AAMLPENMZZ6iuI
Message-ID: <CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
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
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 2:32 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
> On Sun, Dec 21, 2014 at 02:19:03PM -0800, Linus Torvalds wrote:
> >
>  > And finally, and stupidly, is there any chance that you have anything
>  > accessing /dev/hpet?
>
> Not knowingly at least, but who the hell knows what systemd has its
> fingers in these days.

Actually, it looks like /dev/hpet doesn't allow write access.

I can do the mmap(/dev/mem) thing and access the HPET by hand, and
when I write zero to it I immediately get something like this:

  Clocksource tsc unstable (delta = -284317725450 ns)
  Switched to clocksource hpet

just to confirm that yes, a jump in the HPET counter would indeed give
those kinds of symptoms:blaming the TSC with a negative delta in the
0-300s range, even though it's the HPET that is broken.

And if the HPET then occasionally jumps around afterwards, it would
show up as ktime_get() occasionally going backwards, which in turn
would - as far as I can tell - result in exactly that pseudo-infirnite
loop with timers.

Anyway, any wild kernel pointer access *could* happen to just hit the
HPET and write to the main counter value, although I'd personally be
more inclined to blame BIOS/SMM kind of code playing tricks with
time.. We do have a few places where we explicitly write the value on
purpose, but they are in the HPET init code, and in the clocksource
resume code, so they should not be involved.

Thomas - have you had reports of HPET breakage in RT circles, the same
way BIOSes have been tinkering with TSC?

Also, would it perhaps be a good idea to make "ktime_get()" save the
last time in a percpu variable, and warn if time ever goes backwards
on a particular CPU?  A percpu thing should be pretty cheap, even if
we write to it every time somebody asks for time..

                       Linus
