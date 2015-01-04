Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbbADTqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:46:32 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60835 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbbADTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLX7ad_B82A9=O30v0PVqq2LKiSF7wOkGOytC=SuBh7wcg@mail.gmail.com>
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
Date: Sun, 4 Jan 2015 11:46:30 -0800
X-Google-Sender-Auth: x1iEL1EgNpf8uTDT7Iy9XTNBzck
Message-ID: <CA+55aFxZ7yj7Jdt1H9JQJNQUgZSLft_b=rAZv0tw95tjQ0Eq2A@mail.gmail.com>
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

On Fri, Jan 2, 2015 at 4:27 PM, John Stultz <john.stultz@linaro.org> wrote:
>
> So I sent out a first step validation check to warn us if we end up
> with idle periods that are larger then we expect.

.. not having tested it, this is just from reading the patch, but it
would *seem* that it doesn't actually validate the clock reading much
at all.

Why? Because most of the time, for crap clocks like HPET, the real
limitation will be not the multiplication overflow, but the "mask",
which is just 32-bit (or worse - I think the ACPI PM timer might be
just 24 bits).

So then you effectively "validate" that the timer difference value
fits in mask, but that isn't any validation at all - it's just a
truism. Since we by definition mask the difference to just the valid
bitmask.

So I really think that the maximum valid clock needs to be narrowed
down from the "technically, this clock can count to X".

But maybe I'm wrong, and the multiplication overflow is actually often
the real limit. What are the actual values for real timer sources?

                        Linus
