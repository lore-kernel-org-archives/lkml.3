Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbbAGSrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:47:13 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37334 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbAGSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
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
Date: Wed, 7 Jan 2015 10:47:09 -0800
X-Google-Sender-Auth: SqElq-0zzVRZQNpkP7ium2Py7D0
Message-ID: <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 10:11 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> I think this makes sense since __delay() expects the number of loops
> as argument rather than a duration scaled by some factor (based on the
> generic timer frequency).

Gaah. You guys make no sense at all.

No, __delay() does not expect "number of loops".

It doesn't do that on x86, and it doesn't even do it on arm.

It *literally* does exactly the reverse of what you say it does.

__delay() very much expects a "duration scaled by some factor". The
factor being "loops_per_jiffy" (ok, so it's a "reverse factor", but
you get the idea).

And this is very much exactly why bogomips is that "2 *
loops_per_jiffy * HZ / 1000000".

Let's break it down:

 - "loops_per_jiffy" is just the scale factor for __udelay(). Ignore
the "loops" part of the name, since it's purely historical. It comes
from the original "decrement and jump" implementation, but that hasn't
been true on x86 for over 15 years.

 - the "2x" factor is also purely historical, and comes from the same
"decrement and jump" thing - it used to be two instructions. But
again, it hasn't been true for a *looong* time,  but it is part of the
bogosity of bogomips.

 - the "*HZ" is the "per jiffy" part.

 - the "1000000" is the "MHz" part. The clock had better tick at a
megahertz or more, since the whole point of this is to do "udelay()".

Really. The original commit that removed bogomips from ARM was
*wrong*. Because that

    per_cpu(cpu_data, i).loops_per_jiffy / (500000UL/HZ

calculation is in fact  the very DEFINITION of bogomips (it's just
written in a way to not overflow).

Seriously.

The reason I reverted that commit is because it was crap. When Pavel
made the report, I looked at the code, and immediately reverted it.
For good reason. Exactly because that original patch was WRONG.

The old bogomips computation in arch/arm/kernel/setup.c is exactly the
right thing to do.

And every time somebody thinks it has to be about "loops" or about
"cpu frequency", I can only say "STOP IT". It hasn't been about loops
or CPU frequency for ages. I don't know when we switched it to "wait
for the timer", because it predates my history that starts in early
2002. So it's at *least* 13 years old.

                                Linus
