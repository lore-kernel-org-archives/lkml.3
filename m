Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBZISm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:18:42 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:45901 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaBZISj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:18:39 -0500
Date: Wed, 26 Feb 2014 09:16:03 +0100
From: Henrik Austad <henrik@austad.us>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Message-ID: <20140226081602.GA16591@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
 <20140225141906.GA22814@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225141906.GA22814@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:19:09PM +0100, Frederic Weisbecker wrote:
> On Tue, Feb 25, 2014 at 01:33:55PM +0100, Henrik Austad wrote:
> > From: Henrik Austad <haustad@cisco.com>
> > 
> > Hi!
> > 
> > This is a rework of the preiovus patch based on the feedback gathered
> > from the last round. I've split it up a bit, mostly to make it easier to
> > single out the parts that require more attention (#4 comes to mind).
> > 
> > Being able to read (and possible force a specific CPU to handle all
> > do_timer() updates) can be very handy when debugging a system and tuning
> > for performance. It is not always easy to route interrupts to a specific
> > core (or away from one, for that matter).
> 
> It's a bit vague as a reason for the patchset. Do we really need it?

One case is to move the timekeeping away from cores I know have 
interrupt-issues (in an embedded setup, it is not always easy to move 
interrupts away).

Another is to remove jitter from cores doing either real-time work or heavy 
workerthreads. The timekeeping update is pretty fast, but I do not see any 
reason for letting timekeeping interfere with my workers if it does not 
have to.

> Concerning the read-only part, if I want to know which CPU is handling the
> timekeeping, I'd rather use tracing than a sysfs file. I can correlate
> timekeeping update traces with other events. Especially as the timekeeping duty
> can change hands and move to any CPU all the time. We really don't want to
> poll on a sysfs file to get that information. It's not adapted and doesn't
> carry any timestamp. It may be useful only if the timekeeping CPU is static.

I agree that not having a timestamp will make it useless wrt to tracing, 
but that was never the intention. By having a sysfs/sysctl value you can 
quickly determine if the timekeeping is bound to a single core or if it is 
handled everywhere.

Tracing will give you the most accurate result, but that's not always what 
you want as tracing also provides an overhead (both in the kernel as well 
as in the head of the user) using the sysfs/sysctl interface for grabbing 
the CPU does not.

You can also use it to verify that the forced-cpu you just sat, did in fact 
have the desired effect.

Another approach I was contemplating, was to let current_cpu return the 
current mask CPUs where the timer is running, once you set it via 
forced_cpu, it will narrow down to that particular core. Would that be more 
useful for the RO approach outisde TICK_PERIODIC?

> Now looking at the write part. What kind of usecase do you have in mind?

Forcing the timer to run on single core only, and a core of my choosing at 
that.

- Get timekeeping away from cores with bad interrupts (no, I cannot move 
  them).
- Avoid running timekeeping udpates on worker-cores.

> It's also important to consider that, in the case of NO_HZ_IDLE, if you force
> the timekeeping duty to a specific CPU, it won't be able to enter in dynticks
> idle mode as long as any other CPU is running. 

Yes, it will in effect be a TICK_PERIODIC core where I can configure which 
core the timekeeping update will happen.

> Because those CPUs can make use of jiffies or gettimeofday() and must 
> have uptodate values. This involve quite some complication like using the 
> full system idle detection (CONFIG_NO_HZ_FULL_SYSIDLE) to avoid races 
> between timekeeper entering dynticks idle mode and other CPUs waking up 
> from idle. But the worst here is the powesaving issues resulting from the 
> timekeeper who can't sleep.

Personally, when I force the timer to be bound to a specific CPU, I'm 
pretty happy with the fact that it won't be allowed to turn ticks off. At 
that stage, powersave is the least of my concerns, throughput and/or jitter 
is.

I know that what I'm doing is in effect turning the kernel into a 
somewhat more configurable TICK_PERIODIC kernel (in the sense that I can 
set the timer to run on something other than the boot-cpu).

> These issues are being dealt with in NO_HZ_FULL because we want the 
> timekeeping duty to be affine to the CPUs that are no full dynticks. But 
> in the case of NO_HZ_IDLE, I fear it's not going to be desirable.

Hum? I didn't get that one, what do you mean?

-- 
Henrik Austad
