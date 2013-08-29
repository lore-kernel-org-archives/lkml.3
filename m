Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3H2TaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:30:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54166 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3H2TaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:30:10 -0400
Message-ID: <521FA13F.5040204@linaro.org>
Date: Thu, 29 Aug 2013 12:30:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/2] time: allow changing the timekeeper clock frequency
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com> <CALAqxLX8zkzofgGSdEVsP4wdnejd25iSFHyhBwp7nRVgEnqNrA@mail.gmail.com> <520BF6EC.8070006@tilera.com> <521F95BB.2060600@tilera.com>
In-Reply-To: <521F95BB.2060600@tilera.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:40 AM, Chris Metcalf wrote:
> Ping!  I have this work queued up to push as part of the linux-tile tree for the
> merge window.  Is that acceptable to the timekeeping/clocksource folks?
> Should I hold it back pending further review?  Or does it make sense to
> push it as-is and think about further improvements, if any, for a later release?
>
> https://lkml.org/lkml/2013/8/9/497
> https://lkml.org/lkml/2013/8/9/499

Oh right! Sorry for the slow response here! I originally replied while I
was on vacation and didn't flag the thread to follow up on.

Few comments below.


> On 8/14/2013 5:30 PM, Chris Metcalf wrote:
>> On 8/14/2013 2:17 PM, John Stultz wrote:
>>> So a long while back we had tried to adapt for clock frequency changes
>>> on things like the TSC, but it resulting in *terrible* timekeeping as
>>> the latency between the frequency change and the handling of the
>>> notifications caused lots of clock drift, making it impossible for NTP
>>> or other synchronization methods to work properly.
>> We've done quite a bit of testing to show that our current implementation
>> doesn't have any clock drift over time.  Basically, we take a machine
>> running some workload, sync its time via ntpdate, and then run a script
>> that changes the CPU speed up or down continually, with a delay of a couple
>> seconds in between so we run for some decent amount of time at each speed.
Is this delay randomized? If its too perfect back and forth, you may be
undoing any skew caused by slowing the clock.


>> Every 5 minutes or so, the script runs ntpdate -q to see what the offset
>> from real time is.  The skew we see doing that for a couple of days is
>> identical to that seen when we _aren't_ changing the CPU frequency.
>>
>> A key part of making this work, as noted in the comments at the head of
>> timekeeping_chfreq_prep(), is the fact that we do the frequency change
>> under stop_machine() to make sure that no CPU gets an opportunity to
>> sample the clock while it's being changed.
>>
>> However, I'm wondering whether you're talking about some other sort of
>> much more local clock skew or other frequency effect that perhaps we
>> haven't tested for.  (For instance, we haven't actually run this code
>> on an NTP server.)  Can you give a bit more detail on exactly what sorts
>> of bad behavior you saw with the previous implementation, and things one
>> might do to detect them?

What I'm concerned about is how the system time reacts when its being
corrected by ntp while these frequency changes are going on. Basically
given some drift, can NTP drive the system time it to converge if the
underlying clock frequency is changing around on it.

This seems unlikely with the current patch, as every time
tk_setup_internals is called, the ntp_error is cleared (but its not
clearing the ntp state machine).

Whats more problematic at a fundamental level is that the drift NTP is
correcting for may not be the same at the different clock frequency
levels. So there's no sane way for to actually calculate a accurate
frequency correction.

If the freq changes were rare enough, we could clear the ntp state
machine each change, letting NTP know it needs to sort things out again.
But I suspect freq changes are likely to be more often then every 5
minutes or so.

You might want to try to collect some ntp convergence graphs (using a
local ntp server, also prob good to use minpoll 4 maxpoll 4 to see how
tightly you can follow the server) to see how fixed freq vs this dynamic
freq manipulations effect ntp behavior. Maybe the noise and error from
the freq changes is really small enough in the larger scope that its not
something I should fret over? But I'm still a bit skeptical. There's
some plot generating tips at the bottom of this link:
http://www.ntp.org/ntpfaq/NTP-s-trouble.htm


Also looking closer at the actual patch:

> +int timekeeping_chfreq_prep(struct clocksource *clock, cycle_t *start_cycle)
> +{
> +	if (timekeeper.clock != clock)
> +		return 1;
> +
> +	timekeeping_forward_now(&timekeeper);
> +	*start_cycle = timekeeper.clock->cycle_last;
> +
> +	return 0;
> +}

I don't see any locking here at all.



> +
> +/**
> + * timekeeping_chfreq() - change the frequency of the clocksource being
> + *   used for timekeeping, and then recompute the internal timekeeping
> + *   parameters which depend upon that
> + * @freq:		New frequency for the clocksource, in hertz.
> + * @end_cycle:		Cycle count, in the new clock domain.
> + * @delta_ns:		Time delta in ns between start_cycle (as returned
> + *			from timekeeping_chfreq_prep()) and end_cycle.
> + *
> + * See the timekeeping_chfreq_prep() description for how this routine is
> + * used.
> + */
> +void timekeeping_chfreq(unsigned int freq, cycle_t end_cycle, u64 delta_ns)
> +{
> +	struct clocksource *clock = timekeeper.clock;
> +
> +	write_seqlock(&jiffies_lock);

Why are you taking the jiffies_lock here instead of the timekeeper_lock?

Note also the timekeeping locking is a bit more complex, so writers need
to take both timekeeper_lock and the timekeeper_seq. Check out other
callers of tk_setup_internals for examples.


> +	__clocksource_updatefreq_hz(clock, freq);
> +	tk_setup_internals(&timekeeper, clock);
> +

So tk_setup_internals is probably overly heavyweight here, and isn't
really designed handle the same clock being passed in.

For instance, if the shift value chagnes in
__clocksource_updatefreq_hz(), you'll not end up doing the right
conversion of the xtime_nsec value. It might not matter since you
accumulated everything w/ forward_now, but still looks off and is likely
to confuse.

So outside of my larger suspicion that this isn't actually going to
work, this doesn't look like 3.12 material yet to me.

thanks
-john

