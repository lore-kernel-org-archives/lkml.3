Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaFNQAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:00:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:38979 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaFNQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:00:45 -0400
Date: Sat, 14 Jun 2014 12:00:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH-v2 4/4] random: clean up interrupt entropy accounting for
 archs w/o cycle counters
Message-ID: <20140614160041.GI6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <1402730118-23122-4-git-send-email-tytso@mit.edu>
 <20140614072849.27887.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614072849.27887.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 03:28:49AM -0400, George Spelvin wrote:
> +	if (cycles || (fast_pool->notimer_count >= 32))
> +		credit++;
> 
> Ah, this addresses my concern about too few interrupts, too.  If the
> (non-timer) interrupt rate is less than 32/second, you'll never get any
> credit.

I'll want to measure the interrupt rate on things like a mobile
handset to see if this is a real problem or not, but the real question
is if you don't have a cycle counter, and the system is largely idle,
*and* all of the clocks are driven off of the same master oscillator,
how much entropy do you really get from measuring timing interrupts
where your time measurement has a granularity of 1/HZ seconds?  

Basically, at that point, you're getting most of your entorpy from
instruction_pointer(regs), and whatever the value of irq is --- and if
irq is mostly TIMER_IRQ, there's not much entropy there either.

Also note that the question is not whether the non-timer interrupt
rate is less than 32 seconds, but rather out of the last 64
interrupts, how many of the interrupts come from non-timer sources?
That's not the same thing, especially if you are running in tickless
mode, which most modern kernels for mobile handsets would want to do
for the obvious power savings reason.  Indeed the main concern on most
mobile handsets is that there aren't that many interrupts to begin
with, because they've been optimized out as much as possible.

The real answer is that ARM manufacuters have to get off their !@#!@?
duff and give us either a real clock cycle counter, or a real hardware
randum number generator, or both...

						- Ted
