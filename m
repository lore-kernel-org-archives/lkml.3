Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaEIEla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:41:30 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55085 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaEIEl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140509002334.GK3693@n2100.arm.linux.org.uk>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
	<CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
	<CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
	<CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>
	<alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>
	<CAD=FV=X4h0nfO7a10NXe+d76xj5ttBJx=q1pAvW4aPzrc22BoQ@mail.gmail.com>
	<20140508205556.GJ3693@n2100.arm.linux.org.uk>
	<CAD=FV=ViOie+E_mxgcE51oNL0HY1zF9KYG_TDSbKjMzE2GZZMw@mail.gmail.com>
	<20140509002334.GK3693@n2100.arm.linux.org.uk>
Date: Thu, 8 May 2014 21:41:27 -0700
X-Google-Sender-Auth: qb_C-CB1-2FFjg3sbhU7sN4LZyE
Message-ID: <CAD=FV=WkbGQ_F93rA6y7nPHcJ44UboH9vi_LiToCFeyL2b6btA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Thu, May 8, 2014 at 5:23 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 08, 2014 at 05:02:02PM -0700, Doug Anderson wrote:
>> Russel,
>>
>> On Thu, May 8, 2014 at 1:55 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Thu, May 08, 2014 at 11:06:24AM -0700, Doug Anderson wrote:
>> >> I guess I would say that my patch is unhacking the this code.  The
>> >> code after my patch is simpler.  I would perhaps argue that (ec971ea
>> >> ARM: add cpufreq transiton notifier to adjust loops_per_jiffy for smp)
>> >> should never have landed to begin with.
>> >
>> > That depends on your point of view.  As I've already pointed out through
>> > the examples of why udelay() is inaccurate, for driver authors, they
>> > should assume that udelay() just gives you an "approximate" delay and
>> > it has no accuracy.
>>
>> That disagrees with what Thomas Gleixner says at
>> <http://lkml.iu.edu//hypermail/linux/kernel/1203.1/01034.html>.  It
>> also seems like perhaps the regulator core is broken, then...  If a
>> udelay(30) can end up as a udelay(20) then we may return from a
>> regulator code 10us earlier than we should and we'll assume that a
>> regulator is ramped before it really is...
>>
>> I'm out tomorrow but I can confirm on Monday that I was really seeing
>> udelay(30) be a udelay(20) without this patch.
>
> Thomas is wrong - when I researched this topic, I ended up finding
> that udelay() does delay _less_ than requested, and I mailed Linus
> about it...  This is whe way udelay() is - it's an approximate delay,
> it's *not* accurate.
>
> It's also fairly obvious when you stop and consider how it's calibrated.
>
> Take a moment to wonder when we used to recalibrate each CPU individally,
> why the boot CPU bogomips would be slightly lower than the secondary
> CPU bogomips.  This is all down to the boot CPU having to run timer
> interrupts while the secondary CPUs weren't at the time they calibrated.
>
> Linus doesn't give a damn about udelay() being slightly short in this
> way.  Neither do I.

Can you define what you mean by "slightly"?  I'm personally not super
concerned by udelay(50) becoming udelay(49), but...

I've got a test that hammers on udelay and tests it against ktime.  It
runs for _multiple minutes_ and give nearly spot on udelay(50) values.
 Then, it gets unlucky and gives something like this (values reported
in nanoseconds):

[  467.034522] 0. want=50000, got=308708
[  467.034522] 1. want=50000, got=51917
[  467.034522] 2. want=50000, got=51167
[  467.034522] 3. want=50000, got=76291
[  467.034522] 4. want=50000, got=149959
[  467.034522] 5. want=50000, got=76458
[  467.034522] 6. want=50000, got=39583
[  467.034522] 7. want=50000, got=19459
[  467.034522] 8. want=50000, got=20625
[  467.034522] 9. want=50000, got=20375

It's things like "want 50000, got 19459" that concern me.  It's even
more concerning that it only happens after multiple minutes, meaning
that it will lead to random, impossible to reproduce bugs.

NOTE: I haven't traced through to figure out exactly what scenario
causes the above to happen.  In my case I'm simply looping over some
test code using
<https://chromium-review.googlesource.com/#/c/189760/8/init/calibrate.c>.
 ...but if we stop screwing with loops_per_jiffy it definitely doesn't
happen.


> Let me repeat again: use a timer.

Totally agree.  We are using a timer going forward.  I was posting
this patch to help those less fortunate who happen to be running on a
system where the timer isn't available for whatever reason.

-Doug
