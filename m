Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3LCAyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:54:07 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42653 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3LCAyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:54:02 -0500
Message-ID: <529D2BA6.5020005@linaro.org>
Date: Mon, 02 Dec 2013 16:53:58 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com> <528A7C88.1030801@linaro.org> <20131120183900.GA25735@localhost>
In-Reply-To: <20131120183900.GA25735@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 10:39 AM, Miroslav Lichvar wrote:
> On Mon, Nov 18, 2013 at 12:46:00PM -0800, John Stultz wrote:
>>> In a simulation with 1GHz TSC clock and 10Hz clock update the maximum
>>> error went down from 4.7 microseconds to 5.5 nanoseconds. With 1Hz
>>> update the maximum error went down from 480 microseconds to 55
>>> nanoseconds.
>> Curious what sort of a environment you're using for simulation (as well
>> as the real test below)?
> I compile the kernel timekeeping.c file into a test program where a
> fake TSC is provided to the kernel code and I can easily control the
> tick length and timekeeper updates. The program collects pairs of
> TSC/getnstimeofday() values and then it runs linear regression through
> the points to see the frequency offset and how stable the clock was.
>
> http://mlichvar.fedorapeople.org/tmp/tk_test.tar.gz

So.. this doesn't build for me.

timekeeping.o: In function `change_clocksource':
timekeeping.c:(.text+0x535): undefined reference to `lock_acquire'
timekeeping.c:(.text+0x588): undefined reference to `lock_release'
timekeeping.o: In function `__getnstimeofday':
timekeeping.c:(.text+0x675): undefined reference to `trace_hardirqs_off'
timekeeping.c:(.text+0x69b): undefined reference to `lock_acquire'
timekeeping.c:(.text+0x6b0): undefined reference to `lock_release'
timekeeping.c:(.text+0x6c2): undefined reference to `trace_hardirqs_on'
timekeeping.c:(.text+0x77c): undefined reference to `trace_hardirqs_off'


Do you need a special .config in your kernel source? Changing lockdep
and irq tracer configs don't seem to fix things for me.



>> But this is all very interesting! Thanks again for digging into this
>> issue and sending the patch!
> Thanks for looking into it. I agree this is a rather radical change
> and it needs to be done very carefully. At this point, I'd like to
> know if you think there are no fundamental problems in the design and
> whether it would be an acceptable replacement.
>
> A different approach to fix this problem would be controlling the
> maximum idle interval from the tick adjusting code so that the NTP
> error corrections can be accurate. That would further increase the
> complexity of the code and increase the interrupt rate.

So I'm still trying to break apart the larger change you've made into
smaller functional steps.

The main two differences I see are:

1) Calculating the mult value directly from the ntp_tick_length() value
(via the division) each update cycle.

2) Drastically simplifying the ntp_error correction to a 0/1 multiplier
adjustment (assuming the calculated mult will be slightly slow, due to
truncating the remainder in the division) based on the sign of the error.

(and I'm ignoring the previously mentioned accounting changes that
appear to be improperly dropped ;)

This makes me suspect the main issue is we're over-correcting in the
timekeeping_bigadjust() logic with nohz and I'm curious if instead we
could either limit timekeeping_bigadjust() adjustment to achieve the
same stability? In particular, bigadjust()'s exponential adjustment of
mult seems problematic.

Am I missing or glossing over anything else that is key to your changes?

thanks
-john




