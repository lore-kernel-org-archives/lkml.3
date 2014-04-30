Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaD3Msp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:48:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64027 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932885AbaD3Mso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:48:44 -0400
Date: Wed, 30 Apr 2014 13:48:00 +0100
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
Message-ID: <20140430124800.GC21876@arm.com>
References: <1398860614-29469-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398860614-29469-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wed, Apr 30, 2014 at 01:23:34PM +0100, Sebastian Andrzej Siewior wrote:
> On ARM one has to call register_current_timer_delay() in order to use
> the (quick) timer based calibrarion instead of the a little slower loop
> based delay.
> The timer function specified in register_current_timer_delay() is also
> used by read_current_timer() which would otherwise return -ENXIO.
> And read_current_timer() timer is used by get_cycles() which in turn is
> used by random_get_entropy(). That means each sub-architecture returned
> here 0 if register_current_timer_delay() was no performed.
> 
> The parameters for for sched_clock_register() and
> register_current_timer_delay() are mostly the same. Instead of calling
> register_current_timer_delay() each time just after (or before)
> sched_clock_register() I thought it might easier by doing it once at
> sched_clock time since the parameter are the same. That means each ARM sub
> arch that working sched-clock would also have a working random_get_entropy()
> implementation.
> 
> Any comments?

As long as sched_clock is guaranteed to be a fixed frequency, always-on
clocksource then this could work, but it removes the flexibility of having
a separate delay clock and sched clock (is this useful?).

Looking at your patch, I noticed that we need to extend the
register_current_timer_delay function to deal with clocks that aren't as
wide as cycle_t, otherwise we don't delay() for long enough when the clock
overflows (this is potentially already an issue for architected timers <
64-bit). Could you cook a patch for that please?

Will
