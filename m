Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbbAHAZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:25:21 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37035 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbbAHAZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:25:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501071700301.1322@knanqh.ubzr>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<20150104201026.GA23427@amd>
	<alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
	<20150104203724.GA16372@amd>
	<alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
	<CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
	<alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
	<20150104212659.GC12302@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
	<CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
	<CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
	<alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
	<CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
	<alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
	<CA+55aFwuO2g1S-bY96V28crMWj+dKXWANzbP28JQjBdTg0rV0w@mail.gmail.com>
	<alpine.LFD.2.11.1501071618300.1322@knanqh.ubzr>
	<CA+55aFyrNE9qqBR9Khbj=TuAnjA+UzUhNxFz==SqKuiG5q3uMQ@mail.gmail.com>
	<alpine.LFD.2.11.1501071700301.1322@knanqh.ubzr>
Date: Wed, 7 Jan 2015 16:25:18 -0800
X-Google-Sender-Auth: JyVzYrRe5gYCrpPNyd36klcec8k
Message-ID: <CA+55aFxZ4YESQ0vr3qO_o_H8AvQPOv500qnbBXdq+4YNsnOPgA@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 2:42 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> Since when does bogomips mean kernel low-level timer resolution?

Well, effectively since always, even if it wasn't a primary thing. The
primary thing was just the sillyness of it all.

The fact that it always meant low-level timer resolution comes through
clearly in the actual change:

> As Catalin pointed out, the bogomips value went from 800 down to 6 when
> timer based udelay was introduced on ARM for the same piece of hardware.

The very fact that bogomips changed is kind of indicative of what
bogomips _is_, wouldn't you say.

But:

> Is that really what user space is expecting here?

It doesn't matter what user space "expects". User space isn't
conscious, and if it was, we still wouldn't care.

All that matters is whether it *works*.

And in this case, I suspect that pretty much any value actually
happens to fall in that "works" category.

> That's where I don't understand anymore.
>
> If the answer is: "user space should never care because bogomips is
> totally bogus" as some people are claiming then why all the fuss about
> "lying"?

No the answer is "we have no real idea what crazy things user space
might do, and we don't make value judgements on regressions".

User space is filled with insane code, some of it outright *buggy*
code, but users don't care. They just care about "it used to work, and
now it doesn't".

And, as a result, that's all we care about fixing too.

[ Ok, that's not really true.

   Obviously we do care about maintainability and other intrinsic
goals, but to a first approximation the externally visible issues are
much more important than our own intrinsic goals ]

And sometimes those kinds of regressions can end up being unsolvable.

Yes, the #1 rule for the kernel is "no regressions. Ever".

But while that is something I want people to consider a hard rule,
there are some cases where it's just not possible. I mentioned
security issues earlier - we've had cases where we simply could not
support an interface because it turned out to be fundamentally flawed
in a bad way.

Timing-related things can be similar. The whole "it used to work, now
it doesn't" could be an actual race condition - in user space - that
just was practically impossible to hit before on a particular machine,
and then something changed, and now it's easy to hit. There's nothing
we can really do about those kinds of things. It technically *is*
still a regression, it's just not one we can fix.

So in theory, bogomips changing (on the same machine) could indeed be
a regression. It wouldn't even be one of the "unsolvable" kinds,
because while it's timing-related, we *could* fudge the user-visible
scale factor etc. I wouldn't _want_ to, but it's not "fundamentally
unsolvable"

I'm pretty sure that kind of fudging isn't actually necessary in this
case, though.

But that "I'm pretty sure" is not because "people who would depend on
bogomips are crazy and applications using it are fundamentally buggy,
so we don't need to care". Buggy applications that do insane things
still count as regressions.

No, the "pretty sure" is because we know that bogomips varies wildly
between different machines, and any user application that actually
uses the value and is actively bring used clearly *does* work with
different values. It's likely fairly hard to make a real app that does
anything actually useful, and that seriously depends on the exact
bogomips (where "exact" is "within a few orders of magnitude" - not
very exact at all ;).

Sure, it's not impossible, but you *almost* have to actively try to do
something insane. And most user-space insanity is not "actively try to
do something insane" as just due to plain incompetence.

"Never blame on malice that which can be sufficiently explained by stupidity".

                           Linus
