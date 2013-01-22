Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AVRb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:31:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3AVRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:31:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Date: Tue, 22 Jan 2013 17:31:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130122145113.GK23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221731.46902.arnd@arndb.de>
X-Provags-ID: V02:K0:hcR0zM4iopChG/tWJi4gcJyOLP+vK3Y0PLu0lSKhYcR
 UF9Ruo8zMd8JqwdF3g7dyeiQOOnw16BfC0GghSLxSdOqqB3nio
 EqyFA1G/pZBuag9W0subKG+/70pIuxa9LDeCd8KDma97LZfM/p
 +aQSqzvLSyuLEsSWhlx5fpfYxwEvYPcJu0P/arYa/MQP6rsFJh
 cUe6MnY6qaDakqGrglZujSRWn2zYsqfSrujY+i18xdTdWLXSMs
 ed8aFAQ4XT57Yrbc3QR+4yqVVH6tGFw/6GJpWDeg4+g3Eim0/2
 bpt+qTCprx18wTFcKBfC1moMc9vI2KYFoUK+2aco1yP8EzDASy
 JoxFdjkUiUEATRqoNY6c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Russell King - ARM Linux wrote:
> On Tue, Jan 22, 2013 at 03:44:03PM +0530, Santosh Shilimkar wrote:
> > Sorry for not being clear enough. On OMAP, 32KHz is the only clock which
> > is always running(even during low power states) and hence the clock
> > source and clock event have been clocked using 32KHz clock. As mentioned
> > by RMK, with 32768 Hz clock and HZ = 100, there will be always an
> > error of 0.1 %. This accuracy also impacts the timer tick interval.
> > This was the reason, OMAP has been using the HZ = 128.
> 
> Ok.  Let's look at this.  As far as time-of-day is concerned, this
> shouldn't really matter with the clocksource/clockevent based system
> that we now have (where *important point* platforms have been converted
> over.)
>
> Any platform providing a clocksource will override the jiffy-based
> clocksource.  The measurement of time-of-day passing is now based on
> the difference in values read from the clocksource, not from the actual
> tick rate.

Ok, that was my reading as well.

> - if the interrupt rate is slightly faster than HZ, then you can end up
>   with updates being delayed by 2x interrupt rate.
> - if the interrupt rate is slightly slower than HZ, you can occasionally
>   end up with jiffies incrementing by two.
> - if your interrupt rate is dead on HZ, then other system noise can come
>   into effect and you may get maybe zero, one or two jiffy increments per
>   interrupt.
> 
> (You have to think about time passing in NS, where jiffy updates should
> be vs where the timer interrupts happen.)  See tick_do_update_jiffies64()
> for the details.

Ah, right. I forgot about this case. So when we have an accurate clocksource,
rather than relying on the timer tick as the sole source for timekeeping,
the jiffies64 variable may be less accurate (up to almost two jiffies
diff, rather than almost one jiffy).

> The timer infrastructure is jiffy based - which includes scheduling where
> the scheduler does not use hrtimers.  That means a slight discrepency
> between HZ and the actual interrupt rate can cause around 1/HZ jitter.
> That's a matter of fact due to how the code works.

Yes, the two jiffies accuracy I mentioned above would be the result of
the 1 jiffy jitter plus 1 jiffy from the limited resolution.

> So, actually, I think the accuracy of HZ has much overall effect _provided_
> a platform provides a clocksource to the accuracy of jiffy based timers
> nor timekeeping.  For those which don't, the accuracy of the timer
> interrupt to HZ is very important.

This is where I don't see the same problem that you are seeing. Shouldn't
the old ACT_HZ calculation based on CLOCK_TICK_RATE have prevented this?

Note that all PC-like systems traditionally have a CLOCK_TICK_RATE of
1193182 Hz, which does not accurately divide into any of the normal
HZ values, the jiffies clocksource used to have code in it to make
up for this problem. Nowadays, since John's b3c869d35 "jiffies: Remove
compile time assumptions about CLOCK_TICK_RATE" patch in 3.7, the
logic in part of the refined_jiffies clock source that is used currently
only on x86.

I do agree that any platform that is using neither a platform specific
clocksource nor the refined_jiffies would suffer from the drift as
you describe. OMAP was in fact using CLOCK_TICK_RATE correctly, but
is not using the refined_jiffies clocksource now because it has
its own clocksource implementation.

> And I think further discussion is pointless until such research has been
> done (or someone who _really_ knows the time keeping/timer/sched code
> inside out comments.)

Maybe John has some more insights here, he seems to be the one that
understands it better than any of us.

	Arnd
