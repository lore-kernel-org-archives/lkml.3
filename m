Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3IJUqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:46:25 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42658 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3IJUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:46:23 -0400
Message-ID: <522F851D.1040101@linaro.org>
Date: Tue, 10 Sep 2013 13:46:21 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <20130910203853.GG29237@thunk.org>
In-Reply-To: <20130910203853.GG29237@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 01:38 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 12:38:56PM -0700, John Stultz wrote:
>> So the end of timekeeping_init() may not be what you want here. This
>> only means we've started up the timekeping core with only the default
>> clocksource (with only few exceptions, this is almost always jiffies).
>> Then as clocksource drivers are initialized, they are registered and
>> the timekeeping core will switch over to the best available
>> clocksource.  Also, to avoid the churn at boot of switching to every
>> clocksource registered, we queue them up and wait until fs_init time
>> to switch to whatever is the best available then.
> Is there any indication in the clocksource structures where we can
> determine what the cost (in CPU, time, bus overhead, etc.) for a
> particular clock source, verus the granularity of the clock source?

Not really. We only have the rating which is developer assigned to try
to order the clocks in some linear fashion so we can select the best one.

We do read the clocksource fairly frequently though, so rather then
re-reading on each interrupt, could you instead re-use the points at
interrupt time where we already read the clocksource, like in
hrtimer_interrupt()?

Otherwise, it might be good to stick to sched_clock, which is usually
more constrained to higher performance counters, where correctness is
less critical.

> Also, is it always safe to read from a clock source from an interrupt
> handler?
Yes.

thanks
-john


