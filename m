Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaLVAlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 19:41:21 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53431 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaLVAlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 19:41:19 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
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
Date: Sun, 21 Dec 2014 16:41:18 -0800
X-Google-Sender-Auth: 2Iu85qRvaZ66GfFxZSQ1PMkMUho
Message-ID: <CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=001a11c29a4418c16b050ac35169
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c29a4418c16b050ac35169
Content-Type: text/plain; charset=UTF-8

On Sun, Dec 21, 2014 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I can do the mmap(/dev/mem) thing and access the HPET by hand, and
> when I write zero to it I immediately get something like this:
>
>   Clocksource tsc unstable (delta = -284317725450 ns)
>   Switched to clocksource hpet
>
> just to confirm that yes, a jump in the HPET counter would indeed give
> those kinds of symptoms:blaming the TSC with a negative delta in the
> 0-300s range, even though it's the HPET that is broken.
>
> And if the HPET then occasionally jumps around afterwards, it would
> show up as ktime_get() occasionally going backwards, which in turn
> would - as far as I can tell - result in exactly that pseudo-infirnite
> loop with timers.

Ok, so I tried that too.

It's actually a pretty easy experiment to do: just mmap(/dev/mem) at
the HPET offset (the kernel prints it out at boot, it should normally
be at 0xfed00000). And then just write a zero to offset 0xf0, which is
the main counter.

The first time, you get the "Clocksource tsc unstable".

The second time (or third, or fourth - it might not take immediately)
you get a lockup or similar. Bad things happen.

This is *not* to say that this is the bug you're hitting. But it does show that

 (a) a flaky HPET can do some seriously bad stuff
 (b) the kernel is very fragile wrt time going backwards.

and maybe we can use this test program to at least try to alleviate problem (b).

Trivial HPET mess-up program attached.

                                Linus

--001a11c29a4418c16b050ac35169
Content-Type: text/x-csrc; charset=US-ASCII; name="hpet-mess.c"
Content-Disposition: attachment; filename="hpet-mess.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3z4bf5f0

I2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPGZj
bnRsLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8c3RkaW8uaD4KCgppbnQgbWFp
bihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCWludCBmZCA9IG9wZW4oIi9kZXYvbWVtIiwgT19S
RFdSKTsKCXZvaWQgKmJhc2U7CgoJaWYgKGZkIDwgMCkgewoJCWZwdXRzKCJVbmFibGUgdG8gb3Bl
biAvZGV2L21lbVxuIiwgc3RkZXJyKTsKCQlyZXR1cm4gLTE7Cgl9CgliYXNlID0gbW1hcChOVUxM
LCA0MDk2ICxQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfU0hBUkVELCBmZCwgMHhmZWQwMDAw
MCk7CglpZiAoKGxvbmcpYmFzZSA9PSAtMSkgewoJCWZwdXRzKCJVbmFibGUgdG8gbW1hcCBIUEVU
XG4iLCBzdGRlcnIpOwoJCXJldHVybiAtMTsKCX0KCSoodW5zaWduZWQgbG9uZyAqKSAoYmFzZSsw
eGYwKSA9IDA7CglyZXR1cm4gMDsKfQo=
--001a11c29a4418c16b050ac35169--
