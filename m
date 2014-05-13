Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaEMVuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:50:10 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:64171 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaEMVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UJK1nSPjH-au-KtbnOZk2nC7usLD8L9neMedj6WHUp8g@mail.gmail.com>
References: <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
	<CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>
	<alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>
	<20140508192209.GH3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
	<20140508205223.GI3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405082058130.980@knanqh.ubzr>
	<20140509091824.GL3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405091245070.980@knanqh.ubzr>
	<20140509182245.GM3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405091640090.980@knanqh.ubzr>
	<CAD=FV=UJK1nSPjH-au-KtbnOZk2nC7usLD8L9neMedj6WHUp8g@mail.gmail.com>
Date: Tue, 13 May 2014 14:50:02 -0700
X-Google-Sender-Auth: m4woLWmfN2pfdADZL9G-NhjRpBY
Message-ID: <CAD=FV=XM2URyJjV9gaE=mrp7LAEGtvi9wQGhGJi3_HYp_XzYWg@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems#
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 12, 2014 at 4:51 PM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Fri, May 9, 2014 at 2:05 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>> On Fri, 9 May 2014, Russell King - ARM Linux wrote:
>>
>>> I'd much prefer just printing a warning at kernel boot time to report
>>> that the kernel is running with features which would make udelay() less
>>> than accurate.
>>
>> What if there is simply no timer to rely upon, as in those cases where
>> interrupts are needed for time keeping to make progress?  We should do
>> better than simply saying "sorry your kernel should irradicate every
>> udelay() usage to be reliable".
>>
>> And I mean "reliable" which is not exactly the same as "accurate".
>> Reliable means "never *significantly* shorter".
>>
>>> Remember, it should be usable for _short_ delays on slow machines as
>>> well as other stuff, and if we're going to start throwing stuff like
>>> the above at it, it's going to become very inefficient.
>>
>> You said that udelay can be much longer than expected due to various
>> reasons.
>>
>> You also said that the IRQ handler overhead during udelay calibration
>> makes actual delays slightli shorter than expected.
>>
>> I'm suggesting the addition of a slight overhead that is much smaller
>> than the IRQ handler here.  That shouldn't impact things masurably.
>> I'd certainly like Doug to run his udelay timing test with the following
>> patch to see if it solves the problem.
>
> ...so I spent a whole chunk of time debugging this problem today.  I'm
> out of time today (more tomorrow), but it looks like the theory I
> proposed about why udelay() is giving bad results _might_ have more to
> do with bugs in the exynos cpufreq driver and less to do with the
> theoretical race we've been talking about.  It looks possible that the
> driver is not setting the "old" frequency properly, which would
> certainly cause problems.

Argh.  It turns out that I spent a whole lot of time tracking down the
fact that cpufreq_out_of_sync() running.  As part of debugging this
problem I added a cpufreq_get(0).  That would periodically notice that
the driver's reported frequency didn't match "policy->cur" and call
cpufreq_out_of_sync().  cpufreq_out_of_sync() would "thoughtfully"
send out its own CPUFREQ_PRECHANGE / CPUFREQ_POSTCHANGE but without
any sort of mutexes (at least in our tree).  Ugh.

Overall cpufreq_out_of_sync() seems incredibly racy since there will
inevitably be some period of time where the cpufreq driver has changed
the real CPU frequency but hasn't yet sent out the
cpufreq_notify_transition().  ...and there is no locking between the
two that I see.  ...but that's getting pretty far afield from my
original bug and it's been that way forever, so I guess I'll ignore
it.

--

...but then I found the true problem shows up when we transition
between very low frequencies on exynos, like between 200MHz and
300MHz.  While transitioning between frequencies the system
temporarily bumps over to the "switcher" PLL running at 800MHz while
waiting for the main PLL to stabilize.  No CPUFREQ notification is
sent for that.  That means there's a period of time when we're running
at 800MHz but loops_per_jiffy is calibrated at between 200MHz and
300MHz.


I'm welcome to any suggestions for how to address this.  It sorta
feels like it would be a common thing to have a temporary PLL during
the transition, so my inclination would be to add a "temp" field to
"struct cpufreq_freqs".  Anyone who cared about the fact that cpufreq
might transition through a different frequency on its way from old to
new could look at this field.


What do people think?


-Doug
