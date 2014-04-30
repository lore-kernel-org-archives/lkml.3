Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbaD3N1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:27:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32978 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbaD3N1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:27:07 -0400
Date: Wed, 30 Apr 2014 14:26:28 +0100
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
Message-ID: <20140430132628.GC15719@arm.com>
References: <1398860614-29469-1-git-send-email-bigeasy@linutronix.de>
 <20140430124800.GC21876@arm.com>
 <5360F42C.9080401@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5360F42C.9080401@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 02:01:32PM +0100, Sebastian Andrzej Siewior wrote:
> On 04/30/2014 02:48 PM, Will Deacon wrote:
> > Hi Sebastian,
> 
> Hi Will,
> 
> > As long as sched_clock is guaranteed to be a fixed frequency, always-on
> > clocksource then this could work, but it removes the flexibility of having
> > a separate delay clock and sched clock (is this useful?).
> 
> 
> 
> > Looking at your patch, I noticed that we need to extend the
> > register_current_timer_delay function to deal with clocks that aren't as
> > wide as cycle_t, otherwise we don't delay() for long enough when the clock
> > overflows (this is potentially already an issue for architected timers <
> > 64-bit). Could you cook a patch for that please?
> 
> Sure, I would change the type from long to u64 and fix all users. Would
> that be okay for you?

I don't think that's the problem I was referring to. What I mean is that a
clocksource might overflow at any number of bits, so the delay calculation
needs to take this into account when it does:

	while ((get_cycles() - start) < cycles)

because a premature overflow from get_cycles() will cause us to return
early. The solution is to mask the result of the subtraction before the
comparison to match the width of the clock.

Will
