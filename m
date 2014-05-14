Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaENVm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:42:58 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:38903 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaENVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405131922580.980@knanqh.ubzr>
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
	<CAD=FV=XM2URyJjV9gaE=mrp7LAEGtvi9wQGhGJi3_HYp_XzYWg@mail.gmail.com>
	<5372998F.6020502@wwwdotorg.org>
	<alpine.LFD.2.11.1405131908260.980@knanqh.ubzr>
	<alpine.LFD.2.11.1405131922580.980@knanqh.ubzr>
Date: Wed, 14 May 2014 14:42:55 -0700
X-Google-Sender-Auth: oIEsm9IyIdXVFVZvGjMhS9px3XA
Message-ID: <CAD=FV=U+Uxd9d726-1mBY=MmL1bKfGQosvLmvttJavf3y4VftQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems#
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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

On Tue, May 13, 2014 at 4:29 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 13 May 2014, Nicolas Pitre wrote:
>
>> On Tue, 13 May 2014, Stephen Warren wrote:
>>
>> > On 05/13/2014 03:50 PM, Doug Anderson wrote:
>> > ...
>> > > ...but then I found the true problem shows up when we transition
>> > > between very low frequencies on exynos, like between 200MHz and
>> > > 300MHz.  While transitioning between frequencies the system
>> > > temporarily bumps over to the "switcher" PLL running at 800MHz while
>> > > waiting for the main PLL to stabilize.  No CPUFREQ notification is
>> > > sent for that.  That means there's a period of time when we're running
>> > > at 800MHz but loops_per_jiffy is calibrated at between 200MHz and
>> > > 300MHz.
>> > >
>> > >
>> > > I'm welcome to any suggestions for how to address this.  It sorta
>> > > feels like it would be a common thing to have a temporary PLL during
>> > > the transition, ...
>> >
>> > We definitely do that on Tegra for some cpufreq transitions.
>>
>> Ouch...  If this is a common strategy to use a third frequency during a
>> transition phase, especially if that frequency is way off (800MHz vs
>> 200-300MHz) then it is something the cpufreq layer must capture and
>> advertise.
>
> Of course if only the loops_per_jiffy scaling does care about frequency
> changes these days, and if in those cases udelay() can instead be moved
> to a timer source on those hick-up prone platforms, then all this is
> fairly theoretical and may not be worth pursuing.

Yup, I think I'm going to abandon this.  If anyone ever runs into this
problem later and can't use a bloody timer, hopefully they'll stumble
on this thread and at least end up with a good starting point.

For the record, the fix I made locally (which actually worked) was:

1. Add a new "temp" field to cpufreq_freqs:

--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -133,6 +133,7 @@ struct cpufreq_freqs {
        unsigned int cpu;       /* cpu nr */
        unsigned int old;
        unsigned int new;
+       unsigned int temp;
        u8 flags;               /* flags of cpufreq_driver, see below. */
 };

...depending on whether all users of this structure zero-initialize it
(I didn't check) you might also need to add a flag to say whether the
temp field is actually valid.


2. Set the "temp" to the switching PLL frequency in the cpufreq driver.


3. Change the ARM cpufreq_callback() to take the temp freq into account:

+       if (val == CPUFREQ_PRECHANGE) {
+               old_freq = freq->old;
+               new_freq = max(freq->new, freq->temp);
+       } else if (val == CPUFREQ_POSTCHANGE) {
+               old_freq = max(freq->old, freq->temp);
+               new_freq = freq->new;
+       }

...then use old_freq and new_freq in the place of freq->old and freq->new



-Doug
