Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3KWKWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 05:22:38 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:58874 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3KWKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 05:22:35 -0500
Date: Sat, 23 Nov 2013 11:22:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Clock drift with GENERIC_TIME_VSYSCALL_OLD
Message-ID: <20131123112226.254bd0a3@mschwide>
In-Reply-To: <528FAD63.5030805@linaro.org>
References: <20131122163815.393ab1f2@mschwide>
	<528FAD63.5030805@linaro.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112310-5024-0000-0000-000007E91A56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 11:15:47 -0800
John Stultz <john.stultz@linaro.org> wrote:

> On 11/22/2013 07:38 AM, Martin Schwidefsky wrote:
> 
> > But that has the downside that it creates a negative ntp_error that
> > can only be corrected with an adjustment of tk->mult which takes a
> > long time.
> 
> So the time it would take depends on the clocksource details, but I'm
> not sure it would be all that long (though the math is subtle and I just
> drank my coffee, so I could be wrong): Assuming you're clocksource is
> otherwise perfect, you're gaining only 1ns of error per tick. And we do
> the adjustment once error(in shifted nanoseconds) > cycle_interval/2,
> which I think works out to  error_in_nanoseconds > (cycle_interval >>
> (shift+1)). S390 tod clocksource has a shift value of 12, and since mult
> is 1000, I'm guessing a cycle_interval value for HZ=1000 is 4096000. So
> with that, you'd need 500 ns of error before the mult adjustment occurs,
> which would take about half a second.  If there were any other sources
> of error, then you'd see the same range, but likely a faster or slower
> period to the oscillation.
> 
> Is that about what you were seeing? Or am I way off?

Ah, the NTP math. Let us see

        tmp = NTP_INTERVAL_LENGTH;
        tmp <<= clock->shift;
        ntpinterval = tmp;
        tmp += clock->mult/2;
        do_div(tmp, clock->mult);
        if (tmp == 0)
                tmp = 1;

        interval = (cycle_t) tmp;
        tk->cycle_interval = interval;

That evaluates to 

cycle_interval = ((1000000000/100 << 12) + 500) / 1000 = 40960000
The correction in timekeeping_adjust sets in if the ntp_error is larger
than half the interval. The TOD clock has a fixed format, bit 2**12 is
a microsecond. Half the interval is 5ms which makes sense since HZ is
100 on s390. On x86 with a HZ of 1000 should give you 500 microseconds.
Which gives me 13.8 hours for s390 and 8.3 minutes for x86 until the
correction kicks in. As the ntp_error has been corrected into the wrong
direction (it is positive!) the multiplicator is >increased< which makes
the xtime run away even faster. Without an external NTP time to compare
against the xtime will drift away with increasing speed.
No problem on x86 though as it already uses GENERIC_TIME_VSYSCALL.

> And yes, these days a 500ns oscillation is problematic as PTP and other
> sync methods are getting below that. Though the s390's clocksource is
> rare in that its shift value is manually set and is using a fairly
> coarse shift value (I can't recall, is there a reason for it being that
> low? I know its manually set because you use it as the default
> clocksource). So other clocksources using the register_khz/hz methods
> will get calculated shift values that are usually a bit larger, allowing
> for much finer grained adjustments and proportionally smaller oscillation.

The TOD clock on s390 is not a cycle counter, it is a wall-clock. Given an
appropriate setup the TOD is already drifted by a precise time source.
That is why the multiplicator and the shift are fixed, there is no
variance to that time source.
Which is the reason why we recommend to run Linux on s390 without NTP,
it is usually not needed.

> > The fix I am going to use is to convert s390 to GENERIC_TIME_VSYSCALL,
> > you might want to think about doing that for powerpc and ia64 as well.
> 
> So again, the old_vsyscall method (with your fix to the regression) is
> probably not as problematic on other arches. None the less, I would love
> to see that old code removed and powerpc and ia64 to be updated to the
> new vsyscall method. Unfortunately in both cases, I'll likely need the
> maintainers to do the transition, because I don't know ia64 asm, and the
> powerpc vdso has a complicated legacy interface that has its own subtle
> quirks.

With the new GENERIC_TIME_VSYSCALL the code is a bit simpler so that
should be the way to go. I have the patch for s390 ready and it will
be queue to the linux-s390 tree.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

