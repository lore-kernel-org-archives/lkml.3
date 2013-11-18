Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KRUqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:46:10 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54959 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3KRUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:46:06 -0500
Message-ID: <528A7C88.1030801@linaro.org>
Date: Mon, 18 Nov 2013 12:46:00 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
In-Reply-To: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 06:50 AM, Miroslav Lichvar wrote:
> Since commit 5eb6d205 the system clock is kept separately from NTP time
> and it is synchronized by adjusting its multiplier in a feedback loop.
> This works well when the updates are done regularly. With nohz and idle
> system, however, the loop becomes unstable at a certain update interval.
> The loop overcorrects and the frequency doesn't settle down. The clock
> has a large error, which seems to grow quadratically with update
> interval.
>
> If the constants used in the loop were modified for a maximum update
> interval, it would be stable, but too slow to keep up with NTP. Without
> knowing when will be the next update it's difficult to implement a loop
> that is both fast and stable.

So yes, trying to sort out how much of an adjustment to make when you
don't know how long the next interval will be is a difficult problem to
solve.

I'm definitely interested in ways to improve this. That said, there are
some major subtleties in the code you're removing. I'm never been a huge
fan of the code in question, but I did manage to sit down at one point
with some paper and see the design was right, its designed to be quite
efficient and has been mostly left alone for a number of years, so its
reasonably time tested (at least for the requirements it was designed
for). That said, its terribly opaque code, so I usually have to to
re-establish that proof to myself every time I look at it in depth. :)

So quite a bit of care and caution will be needed.

Also, I know you've had to have spent quite a bit of time researching
this issue and coming up with the solution, so I want to be clear I
really appreciate that! But if we are to replace this core logic, I'll
want to make sure I throughly understand your solution, so forgive me if
I have to ask quite a number of stupid sounding (or just stupid)
questions to clarify things and I'll likely propose alternative
solutions that may seem/be bone headed or overly cautious.  So please
bear with me through this. :)

> This patch fixes the problem by postponing update of NTP tick length in
> the clock and setting the multiplier directly without feedback loop by
> dividing the tick length with clock cycles. Previously, a change in tick
> length was applied immediately to all ticks since last update, which
> caused a jump in the NTP error proportional to the change and the update
> interval and which had to be corrected later by the loop.

Hmm. Reading this, but not having studied your patch in depth, is
interesting. It originally was that we only applied any NTP adjustment
to future changes. Also, since at that time the tick length was only
changed on the second overflow, we ran into some problems, since there
were some applications using the ntp interface to make very small
adjustments for only a few ms. Thus we changed (see fdcedf7b75808 -
time: apply NTP frequency/tick changes immediately) it to adjust the
tick length immediately.

If this is the core issue, then maybe would revisiting that change alone
improve things?

Also I'm not sure if I quite follow the bit about "a change in the tick
was applied immediately to all ticks since the last update", since at
least with classic nohz, if someone is making a change to the ntp tick
length, we're not idle, so we should still be getting regular ticks. So
at most, it should be the modified ntp tick length is immediately
applied to the current  tick in progress, as well as following ticks.
Now with nohz_full this is definitely more complicated, but I want to
make sure I really understand what you're seeing. So are the issues
you're seeing w/ classic idle nohz or nohz full?


One of the issues I've recently started to worry about with the existing
code, is that the ntp_error value can really only hold about 2 seconds
worth of error. Now, that's the internal loop adjustment error (ie: the
error from what ntpd specified the kernel to be and where the kernel is
which should be very small), not the actual drift from the ntp server,
so it really shouldn't be problematic, but as we do get into *very*
large nohz idle values, it seems possible that we could accumulate more
then 2 seconds and see overflows of ntp_error, which could cause
instability.  So I'm curious if you were seeing anything like this, or
at least ask if you've already eliminated this as a potential source of
the problem you were seeing.

> The only source of the accounted NTP error is now lack of resolution in
> the clock multiplier. The error is corrected by adding 0 or 1 to the
> calculated multiplier. With a constant tick length, the multiplier will
> be switching between the two values. The loop is greatly simplified and
> there is no problem with stability. The maximum error is limited by the
> update interval.

Hrmm.. So I wonder how well this works with fairly coarse grained
clocksources? Quite a bit of the previous design (which is still looks
mostly in place with a superficial review of your patch) is focused on
keeping our long-term accuracy correct via the internally managed
feedback loop, even if we had a very coarse clocksource shift value. 
While improving the nohz performance is desired, I'm not sure we want to
also throw away that managed precision.

Also, if the ntp_mult_correction is always 0 or 1, (which handles if
we're too slow) how does it handle if we're running too fast?

Apologies if I'm missing something in your code.


> In a simulation with 1GHz TSC clock and 10Hz clock update the maximum
> error went down from 4.7 microseconds to 5.5 nanoseconds. With 1Hz
> update the maximum error went down from 480 microseconds to 55
> nanoseconds.

Curious what sort of a environment you're using for simulation (as well
as the real test below)?

Also just want to clarify what/how you're measuring when you say
"maximum error".


> In a real test on idle machine comparing raw TSC and clock_gettime()
> time stamps, the maximum error went down from microseconds to tens of
> nanoseconds. A test with clock synchronized to a PTP hardware clock by
> phc2sys from linuxptp now shows no difference when running with nohz
> enabled and disabled, the clock seems to be stable to few tens of
> nanoseconds.

So this all sounds great!

I'm currently running your patch through some basic sanity checks in a
VM and its looking ok so far, so that's promising.
(my tests are here, if you want to run them as well:
https://github.com/johnstultz-work/timetests.git )

There's a few spots where I'm a bit concerned we're missing some
replacement for some of the accounting you removed (you don't seem to be
adjusting the non-accumulated offset value when modifying the
multiplier), and the division in the hotpath is a bit concerning (but
maybe that can be pre-computed in another path or approximated into
shifts?).

I'll want to reproduce your results, so let me know about your testing
methods. I may also want to generate some more intricate tests so we can
really see the if long-term precision and stability is really as
unaffected you make it sound.

But this is all very interesting! Thanks again for digging into this
issue and sending the patch!

thanks
-john
