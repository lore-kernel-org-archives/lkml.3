Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbbALSyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:54:53 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:42249 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbbALSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:54:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150111124146.GA15387@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-7-git-send-email-john.stultz@linaro.org>
	<20150111124146.GA15387@localhost.localdomain>
Date: Mon, 12 Jan 2015 10:54:50 -0800
Message-ID: <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 4:41 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Fri, Jan 09, 2015 at 04:34:24PM -0800, John Stultz wrote:
>> When calculating the current delta since the last tick, we
>> currently have no hard protections to prevent a multiplciation
>> overflow from ocurring.
>
> This is just papering over the problem. The "hard protection" should
> be having a tick scheduled before the range of the clock source is
> exhausted.

So I disagree this is papering over the problem.

You say the tick should be scheduled before the clocksource wraps -
but we have logic to do that.

However there are many ways that can still go wrong.  Virtualization
can delay interrupts for long periods of time, the timer/irq code
isn't the simplest and there can be bugs, or timer hardware itself can
have issues. The difficulty is that when something has gone wrong, the
only thing we have to measure the problem may become corrupted.  And
worse, once the timekeeping code is having problems,  that can result
in bugs that manifest in all sorts of strange ways that are very
difficult to debug (you can't trust your log timestamps, etc).

So I think having some extra measures of protection is useful here.

I'll admit that its always difficult to manage, since we have to layer
our checks, we have circular dependencies (timer code needs
timekeeping to be correct, timekeeping code needs timer code to be
correct), and hardware problems are rampant - so we get trouble like
the clocksource watchdog which uses more trustworthy clocksources to
watch less trustworthy ones, but then hardware starts adding bugs to
the trustworthy ones which cause false positives, etc.   And these
checks make the code add complexity to the code that we'd be happier
without, but we can't throw out supporting the majority of hardware
that have some quirk and imperfection, so I'm not sure what the
alternative should be.

thanks
-john
