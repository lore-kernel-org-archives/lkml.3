Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbaGQQOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41745 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222AbaGQQOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:30 -0400
Message-ID: <53C7F662.1090104@linaro.org>
Date: Thu, 17 Jul 2014 09:14:26 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>, Clemens Ladisch <clemens@ladisch.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
References: <alpine.DEB.2.10.1407161151450.24854@nanos> <53C6633D.9080905@ladisch.de> <20140716123727.GA19379@twins.programming.kicks-ass.net> <53C68943.2060003@ladisch.de> <20140716150010.GA4951@sirena.org.uk> <53C78B54.5070102@linaro.org>
In-Reply-To: <53C78B54.5070102@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 01:37 AM, Daniel Thompson wrote:
> On 16/07/14 16:00, Mark Brown wrote:
>> On Wed, Jul 16, 2014 at 04:16:35PM +0200, Clemens Ladisch wrote:
>>> (I don't have numbers for the errors caused by NTP adjustments.  Daniel?)
>> Right, the goal is to get a clock which is guaranteed to never have any
>> adjustments that might cause discontinuities or rate changes applied to
>> it.  My understanding is that the users are already doing their own rate
>> matching and it's much more important to them to get a stable clock than
>> it is to get a clock at a specific nominal rate, and given the set top
>> box applications I expect they also need this from very soon after boot.
> We are trying to match rates with a broadcast device that "shouts" the
> current time many times per second (MPEG transport stream PCR packets).
> These packets are timestamped on arrival with a local clock and the
> resulting data is used to recover the broadcast clock. However due to
> variable transmission delay of the packets we require very long
> control loops to extract any useful information from this data (varies
> between five minutes and half and hour).
>
> An NTP rate correction can change the rate of CLOCK_MONOTONIC
> sufficiently to confuse our clock recovery algorithms so we use
> CLOCK_MONOTONIC_RAW as the master view of time.

Just to further clarify on this point, the problem is that with NTP
there are both frequency (ie: clock runs too fast) and offset (ie: we're
out of sync by 10ms) corrections made to CLOCK_REALTIME. 

In the long-term when we've synced up with NTP, these are basically the
same thing, so to keep things (relatively) simple we eventually combine
these into one adjustment factor when steering the clock.  But in the
short-term when we're trying to quickly get in sync with NTP, the offset
correction can be fairly large.

The problem is that we want CLOCK_MONOTONIC to be frequency corrected,
so that a second is really a second. But we don't really care about it
being offset corrected. However, since its much simpler to define a
fixed offset between _MONOTONIC and _REALTIME (which is only modified if
_REALTIME is set or stepped).

Ideally I guess we'd probably want to track the freq adjustment and
offset adjustment separately and apply the freq offset to both
_MONONTONIC and _REALTIME, but only apply offset corrections to
_REALTIME. However, this would make the accounting much more complex and
would break the fixed relationship between _MONOTONIC and _REALTIME.

Miroslav has discussed trying this previously, but I'm a bit skeptical
its worth the extra effort and overhead.

CLOCK_MONOTONIC_RAW provide just a nanosecond abstraction of a hardware
counter. It was added because some folks who were doing time sync
algorithms were using non-portable methods like rdtsc to measure
corrections being made (as measuring correction with the time base being
corrected is a bit circular). So in cases where the short-term
adjustment is problematic, it can be a good choice, as long as accuracy
needs are low (since a second may not be a real second).

thanks
-john










CLOCK_MONOTONIC is ntp corrected, since we want 1 second there to really
be 1 second.
