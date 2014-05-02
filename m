Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaEBQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:50:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45953 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaEBQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:50:55 -0400
Date: Fri, 2 May 2014 17:50:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, Theodore Ts o <tytso@mit.edu>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] sched_clock: also call
 register_current_timer_delay() if possible
Message-ID: <20140502165011.GC20642@arm.com>
References: <1398860614-29469-1-git-send-email-bigeasy@linutronix.de>
 <20140430124800.GC21876@arm.com>
 <5360F42C.9080401@linutronix.de>
 <20140430132628.GC15719@arm.com>
 <20140430165653.GA26716@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430165653.GA26716@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 05:56:53PM +0100, Sebastian Andrzej Siewior wrote:
> * Will Deacon | 2014-04-30 14:26:28 [+0100]:
> >I don't think that's the problem I was referring to. What I mean is that a
> >clocksource might overflow at any number of bits, so the delay calculation
> >needs to take this into account when it does:
> >
> >	while ((get_cycles() - start) < cycles)
> >
> >because a premature overflow from get_cycles() will cause us to return
> >early. The solution is to mask the result of the subtraction before the
> >comparison to match the width of the clock.
> 
> So I got this:

[...]

> Is this what you had in mind? If so, there is one user of
> register_current_timer_delay() which I didn't convert. That is
> arch_timer_delay_timer_register(). It returns arch_counter_get_cntvct()
> which seems to return an u64 (which is truncated to 32bit). However
> arch_counter_register() registers the clocksource with 56bits. So this
> does not look too good, right?

That should be fine, I think there's only an issue if you can overflow
twice during a single delay operation, so the thing would need to be
ticking at quite a frequency for that to happen!

> The other thing I noticed is
> |arch/arm/include/asm/timex.h:typedef unsigned long cycles_t;
> 
> This works for clocksource because timekeeping is using
> |include/linux/clocksource.h:typedef u64 cycle_t;
> 
> instead.
> Do I assume correct, that the arch_timer is really providing a number
> wider than 32bit? Shouldn't I then promote cycles_t to 64bit if that
> timer is active? Unless you have better suggestions of course :)

The architected timer is guaranteed to be at least 56 bits wide, but I
think we can safely truncate delay sources to 32-bit.

So actually, we only have a problem if people want to register delay clocks
smaller than 32-bit. Maybe it's simpler to enforce at least 32-bit precision
and don't bother with the registration if the clock is smaller than that?
You could use sizeof(cycles_t) to parameterise that.

Will
