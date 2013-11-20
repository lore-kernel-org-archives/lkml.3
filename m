Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3KTSjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:39:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab3KTSjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:39:04 -0500
Date: Wed, 20 Nov 2013 19:39:00 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131120183900.GA25735@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A7C88.1030801@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:46:00PM -0800, John Stultz wrote:
> Hmm. Reading this, but not having studied your patch in depth, is
> interesting. It originally was that we only applied any NTP adjustment
> to future changes. Also, since at that time the tick length was only
> changed on the second overflow, we ran into some problems, since there
> were some applications using the ntp interface to make very small
> adjustments for only a few ms. Thus we changed (see fdcedf7b75808 -
> time: apply NTP frequency/tick changes immediately) it to adjust the
> tick length immediately.
> 
> If this is the core issue, then maybe would revisiting that change alone
> improve things?

No, this doesn't seem to be related to the problem with stability.
Applying changes in tick length immediately is definitely a useful
feature. One item in my todo list for this patch is to make such phase
adjustments more accurate by forcing the timekeeper update immediately
after adjtimex().

> Also I'm not sure if I quite follow the bit about "a change in the tick
> was applied immediately to all ticks since the last update", since at
> least with classic nohz, if someone is making a change to the ntp tick
> length, we're not idle, so we should still be getting regular ticks. So
> at most, it should be the modified ntp tick length is immediately
> applied to the current  tick in progress, as well as following ticks.

I meant the tick length used in the NTP error calculation
in the logarithmic accumulation function (tk->ntp_error +=
ntp_tick_length() << shift). The code calls second_overflow() before
the NTP error is updated, which means the NTP error will jump by the
difference in the tick length multiplied by number of accumulated
ticks in that step and that's extra work for the loop to correct. This
must not happen in the design I'm proposing.

Probably a stupid question, but can adjtimex() or clock_gettime() be
called before the clock is updated after an idle period? I'm wondering
if this assumption would allow the timekeeper to correct the NTP error
simply by stepping the clock.

> Now with nohz_full this is definitely more complicated, but I want to
> make sure I really understand what you're seeing. So are the issues
> you're seeing w/ classic idle nohz or nohz full?

I was using only kernels with classic idle nohz.

> One of the issues I've recently started to worry about with the existing
> code, is that the ntp_error value can really only hold about 2 seconds
> worth of error. Now, that's the internal loop adjustment error (ie: the
> error from what ntpd specified the kernel to be and where the kernel is
> which should be very small), not the actual drift from the ntp server,
> so it really shouldn't be problematic, but as we do get into *very*
> large nohz idle values, it seems possible that we could accumulate more
> then 2 seconds and see overflows of ntp_error, which could cause
> instability.  So I'm curious if you were seeing anything like this, or
> at least ask if you've already eliminated this as a potential source of
> the problem you were seeing.

That doesn't seem to be related to the problem I'm seeing. With 1Hz
updates I think ntp_error was always in microseconds or milliseconds
at most.

> > The only source of the accounted NTP error is now lack of resolution in
> > the clock multiplier. The error is corrected by adding 0 or 1 to the
> > calculated multiplier. With a constant tick length, the multiplier will
> > be switching between the two values. The loop is greatly simplified and
> > there is no problem with stability. The maximum error is limited by the
> > update interval.
> 
> Hrmm.. So I wonder how well this works with fairly coarse grained
> clocksources? Quite a bit of the previous design (which is still looks
> mostly in place with a superficial review of your patch) is focused on
> keeping our long-term accuracy correct via the internally managed
> feedback loop, even if we had a very coarse clocksource shift value. 
> While improving the nohz performance is desired, I'm not sure we want to
> also throw away that managed precision.

There shouldn't be any regressions in the long-term frequency
accuracy. Short-term frequency accuracy should be better as the bug is
fixed :). 

However, the PLL/FLL and singleshot phase adjustments will be possibly
even less accurate as the whole accumulated interval will use only one
tick length. In the current code, the adjustments could be made
accurate by splitting the accumulated interval at start of second and
updating NTP error for each part with the right tick length. In the
design I'm proposing that will no longer be possible.

> Also, if the ntp_mult_correction is always 0 or 1, (which handles if
> we're too slow) how does it handle if we're running too fast?

If tick length is not divisible by cycles, with zero
ntp_mult_correction the clock will be running slower. If it is
divisible, the clock will be running at the exact same rate and stay
slightly ahead. How much it will be ahead depends on how long was the
last interval with correction of 1. It could use -1 to slow the clock
down in this case, but I'm not sure it's worth the extra frequency
error.

> > In a simulation with 1GHz TSC clock and 10Hz clock update the maximum
> > error went down from 4.7 microseconds to 5.5 nanoseconds. With 1Hz
> > update the maximum error went down from 480 microseconds to 55
> > nanoseconds.
> 
> Curious what sort of a environment you're using for simulation (as well
> as the real test below)?

I compile the kernel timekeeping.c file into a test program where a
fake TSC is provided to the kernel code and I can easily control the
tick length and timekeeper updates. The program collects pairs of
TSC/getnstimeofday() values and then it runs linear regression through
the points to see the frequency offset and how stable the clock was.

http://mlichvar.fedorapeople.org/tmp/tk_test.tar.gz

The real test uses the system TSC and clock_gettime() instead. The
clock needs to be exercised a bit to disturb the tick adjusting code.
Setting a non-zero frequency offset with ntptime(8) or adjtimex(8) or
running ntpd shortly and resetting the PLL offset seems to trigger the
problem reliably.

http://mlichvar.fedorapeople.org/tmp/tstsc.c

> Also just want to clarify what/how you're measuring when you say
> "maximum error".

It's the distance from the furthest point to the regression line. If
you monitor the value of ntp_error, you should see similar results.

> There's a few spots where I'm a bit concerned we're missing some
> replacement for some of the accounting you removed (you don't seem to be
> adjusting the non-accumulated offset value when modifying the
> multiplier),

Yes, I missed that part. There could be time jumps observed. I was
considering to change the code to accumulate partial ticks, so this
wouldn't be needed.

> and the division in the hotpath is a bit concerning (but
> maybe that can be pre-computed in another path or approximated into
> shifts?).

In this design the division needs to be exact, otherwise the ntp_error
correction wouldn't work. Do you have any suggestions on how to
replace it?

> I'll want to reproduce your results, so let me know about your testing
> methods. I may also want to generate some more intricate tests so we can
> really see the if long-term precision and stability is really as
> unaffected you make it sound.

Ok, please let me know if my tests don't work for you or something is
not clear. I tried to make it a bit more readable, but I'm not sure I
succeeded.

> But this is all very interesting! Thanks again for digging into this
> issue and sending the patch!

Thanks for looking into it. I agree this is a rather radical change
and it needs to be done very carefully. At this point, I'd like to
know if you think there are no fundamental problems in the design and
whether it would be an acceptable replacement.

A different approach to fix this problem would be controlling the
maximum idle interval from the tick adjusting code so that the NTP
error corrections can be accurate. That would further increase the
complexity of the code and increase the interrupt rate.

-- 
Miroslav Lichvar
