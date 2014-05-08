Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaEHUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:39:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39432 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaEHUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:39:17 -0400
Message-ID: <536BEB71.9070007@linaro.org>
Date: Thu, 08 May 2014 13:39:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Doug Anderson <dianders@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
References: <1399504982-31181-1-git-send-email-dianders@chromium.org> <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com> <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com> <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr> <CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com> <alpine.LFD.2.11.1405081329010.980@knanqh.ubzr> <20140508192209.GH3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 01:12 PM, Nicolas Pitre wrote:
> On Thu, 8 May 2014, Russell King - ARM Linux wrote:
>
>> So, the only /real/ solution if you want proper delays is for udelay()
>> to use a timer or counter, and this is should always the preferred
>> method where it's available.  Quite rightly, we're not hacking udelay()
>> stuff to work around not having that, or if someone configures it out.
> What about using a default based on ktime_get(), or even sched_clock(), 
> when SMP and cpufreq are configured in?

While somewhat rare these days, there are some systems that still only
have tick(jiffies)-granular time (as well as sched_clock), which might
be far too coarse for udelay, and in addition depends on irqs being
enabled to be able for time to progress.

The loops based delay is sort of a hack that allows fine grained (but
somewhat inaccurate) time delays in just about any context.

The problem being the loop based delays are somewhat fragile,
particularly as many of the assumptions for that code have been broken
(cpufreq scaling, ASMP, SMIs or other calibration issues, etc).  On
these systems where the assumptions are broken, time-based counter
delays are needed, but not always in place.

Thus I suspect we need something that provides proper warnings when we
are using loop delays on system that breaks its assumptions.

thanks
-john



