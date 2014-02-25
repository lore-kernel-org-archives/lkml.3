Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaBYO0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:26:30 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:40152 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaBYOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:19:12 -0500
Date: Tue, 25 Feb 2014 15:19:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>,
        Henrik Austad <haustad@cisco.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Message-ID: <20140225141906.GA22814@localhost.localdomain>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 01:33:55PM +0100, Henrik Austad wrote:
> From: Henrik Austad <haustad@cisco.com>
> 
> Hi!
> 
> This is a rework of the preiovus patch based on the feedback gathered
> from the last round. I've split it up a bit, mostly to make it easier to
> single out the parts that require more attention (#4 comes to mind).
> 
> Being able to read (and possible force a specific CPU to handle all
> do_timer() updates) can be very handy when debugging a system and tuning
> for performance. It is not always easy to route interrupts to a specific
> core (or away from one, for that matter).

It's a bit vague as a reason for the patchset. Do we really need it?

Concerning the read-only part, if I want to know which CPU is handling the
timekeeping, I'd rather use tracing than a sysfs file. I can correlate
timekeeping update traces with other events. Especially as the timekeeping duty
can change hands and move to any CPU all the time. We really don't want to
poll on a sysfs file to get that information. It's not adapted and doesn't
carry any timestamp. It may be useful only if the timekeeping CPU is static.

Now looking at the write part. What kind of usecase do you have in mind?

It's also important to consider that, in the case of NO_HZ_IDLE, if you force
the timekeeping duty to a specific CPU, it won't be able to enter in dynticks
idle mode as long as any other CPU is running. Because those CPUs can make use of
jiffies or gettimeofday() and must have uptodate values. This involve quite
some complication like using the full system idle detection (CONFIG_NO_HZ_FULL_SYSIDLE)
to avoid races between timekeeper entering dynticks idle mode and other CPUs waking
up from idle. But the worst here is the powesaving issues resulting from the timekeeper
who can't sleep.

These issues are being dealt with in NO_HZ_FULL because we want the timekeeping duty
to be affine to the CPUs that are no full dynticks. But in the case of NO_HZ_IDLE,
I fear it's not going to be desirable.

Thanks.
