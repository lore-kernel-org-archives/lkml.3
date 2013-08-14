Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab3HNVaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:30:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:18521 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3HNVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:30:23 -0400
Message-ID: <520BF6EC.8070006@tilera.com>
Date: Wed, 14 Aug 2013 17:30:20 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/2] time: allow changing the timekeeper clock frequency
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com> <CALAqxLX8zkzofgGSdEVsP4wdnejd25iSFHyhBwp7nRVgEnqNrA@mail.gmail.com>
In-Reply-To: <CALAqxLX8zkzofgGSdEVsP4wdnejd25iSFHyhBwp7nRVgEnqNrA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2013 2:17 PM, John Stultz wrote:
> So a long while back we had tried to adapt for clock frequency changes
> on things like the TSC, but it resulting in *terrible* timekeeping as
> the latency between the frequency change and the handling of the
> notifications caused lots of clock drift, making it impossible for NTP
> or other synchronization methods to work properly.

We've done quite a bit of testing to show that our current implementation
doesn't have any clock drift over time.  Basically, we take a machine
running some workload, sync its time via ntpdate, and then run a script
that changes the CPU speed up or down continually, with a delay of a couple
seconds in between so we run for some decent amount of time at each speed.
Every 5 minutes or so, the script runs ntpdate -q to see what the offset
from real time is.  The skew we see doing that for a couple of days is
identical to that seen when we _aren't_ changing the CPU frequency.

A key part of making this work, as noted in the comments at the head of
timekeeping_chfreq_prep(), is the fact that we do the frequency change
under stop_machine() to make sure that no CPU gets an opportunity to
sample the clock while it's being changed.

However, I'm wondering whether you're talking about some other sort of
much more local clock skew or other frequency effect that perhaps we
haven't tested for.  (For instance, we haven't actually run this code
on an NTP server.)  Can you give a bit more detail on exactly what sorts
of bad behavior you saw with the previous implementation, and things one
might do to detect them?


> So early on we made
> a requirement that all clocksources have a constant frequency and
> provided a way to disqualify any clocksources that change frequency.
>
> So I'd be very hesitant to try to add any such behavior into the
> timekeeping core. You may want to try to add some logic in the
> clocksource driver itself to allow for the variable freq clocksource
> to output what seems to be a fixed freq,

So, just to be clear, you're suggesting that we claim our clocksource
runs at some lower virtual speed (say, 1 MHz), and that internally to
our clocksource drver we divide down the real frequency to the virtual
one?


> and if we get some time on it
> to prove that it can be made to work well, then we can see about
> making it more generic.
>
> Does that sound ok?

That seems possible, although it would seem to make the whole process
a bit less efficient (e.g., our clocksource will have to maintain its
own multiplier and offset to convert from real ticks to virtual ticks,
and then the core code will do the same operation again to convert to
wall-clock time).  Obviously, we're not really anxious to re-test/re-qualify
a new implementation of this, but if our current version is or might be
incompatible with other code in the kernel perhaps that's a safer approach.

What sort of eventual more-generic support were you thinking of?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

