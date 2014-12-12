Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaLLTXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:23:08 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34130 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaLLTXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:23:06 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 12 Dec 2014 14:23:03 -0500
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: OMAP5/DRA7: Fix counter frequency drift for AM572x errata
 i856
Message-ID: <20141212192303.GY24110@csclub.uwaterloo.ca>
References: <20141211204116.GT24110@csclub.uwaterloo.ca>
 <20141211204308.GU24110@csclub.uwaterloo.ca>
 <548B27E5.4090108@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548B27E5.4090108@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:37:41AM -0600, Nishanth Menon wrote:
> -sricharan, as the email ID is defunct.

So I noticed.

> On 12/11/2014 02:43 PM, Lennart Sorensen wrote:
> > On Thu, Dec 11, 2014 at 03:41:16PM -0500, Lennart Sorensen wrote:
> >> Errata i856 for the AM572x (DRA7xx) points out that the 32.768KHz external
> >> crystal is not enabled at power up.  Instead the CPU falls back to using
> >> an emulation for the 32KHz clock which is SYSCLK1/610.  SYSCLK1 is usually
> >> 20MHz on boards so far (which gives an emulated frequency of 32.786KHz),
> >> but can also be 19.2 or 27MHz which result in much larger drift.
> 
> Why not just change the clock parent to something that is more
> accurate like the 32k clk?
 
According to the documentation, it can not be changed.  The course counter
runs from the external 32 crystal (which isn't working as per the errata)
and the only other choice is the emulated one.  I suspect it is limited
because it has to run in low power mode, so it tries to stay in a small
part of the CPU.  The same errata also means the internal RTC isn't
running, although why anyone would want a RTC that wasn't battery backed
I can't imagine, and I suspect every design wiill have a seperate external
RTC instead.

> Without digging into docs, This is just the boot configuration, right?
> are we not able to reconfigure?

Not according to anything I have seen in the documentation, and the
errata doesn't offer any options, and no one from TI has come back with
any options for changing it.  They have agreed that my patch will make
it run correctly however.

> Please sign-off on you patch. use git format-patch -M -s to generate
> patches. and when posting a series, use --cover-letter. Will also be
> good to provide tests that show that this is indeed an issue on OMAP5
> and DRA7 (considering the $subject here).

Oh yeah I missed that line.

As for a test, running ntp will pretty quickly simply declare that the
system clock is more than 500ppm out and give up.  Just using 'date'
you will see that it is off by over 10 seconds within 8 hours.

> >> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> >> index 4f61148..2e81511 100644
> >> --- a/arch/arm/mach-omap2/timer.c
> >> +++ b/arch/arm/mach-omap2/timer.c
> >> @@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
> >>  	rate = clk_get_rate(sys_clk);
> >>  	/* Numerator/denumerator values refer TRM Realtime Counter section */
> >>  	switch (rate) {
> >> -	case 1200000:
> >> +	case 12000000:
> >>  		num = 64;
> >>  		den = 125;
> >>  		break;
> >> -	case 1300000:
> >> +	case 13000000:
> >>  		num = 768;
> >>  		den = 1625;
> >>  		break;
> >> @@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
> >>  		num = 192;
> >>  		den = 625;
> >>  		break;
> >> -	case 2600000:
> >> +	case 26000000:
> >>  		num = 384;
> >>  		den = 1625;
> >>  		break;
> >> -	case 2700000:
> >> +	case 27000000:
> >>  		num = 256;
> >>  		den = 1125;
> >>  		break;
> 
> These should probably fall in as a separate patch.

OK, I will do that.

> >> @@ -557,6 +557,73 @@ static void __init realtime_counter_init(void)
> >>  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> >>  
> >>  	arch_timer_freq = (rate / den) * num;
> >> +
> >> +	if (soc_is_dra7xx()) {
> >> +		#define CTRL_CORE_BOOTSTRAP 0x4A0026C4
> >> +		#define SPEEDSELECT_MASK 0x00000300
> 
> we dont usually define it like this.
> 
> >> +		void __iomem *corebase;
> >> +		corebase = ioremap(CTRL_CORE_BOOTSTRAP, SZ_4);
> >> +		if (!corebase)
> >> +			pr_err("%s: ioremap failed\n", __func__);
> >> +		else {
> 
> also run ./scripts/checkpatch.pl --strict on your patch prior to
> posting. try to ensure there are 0 warnings or checks.
> 
> >> +			reg = readl_relaxed(corebase) & SPEEDSELECT_MASK;
> >> +			iounmap(corebase);
> >> +			/*
> >> +			 * Errata i856 says the 32.768KHz crystal does
> >> +			 * not start at power on, so the CPU falls back in
> >> +			 * an emulated 32KHz clock instead.  This causes
> >> +			 * the master counter frequency to not be what it
> >> +			 * was expected to be.	This affects at least
> >> +			 * the AM572x 1.0 and 1.1 revisions.
> >> +			 * Of course any board built without a populated
> >> +			 * 32.768KHz crystal would also need this fix
> >> +			 * even if the CPU is fixed later.
> >> +			 *
> >> +			 * If the two speedselect bits are not 0, then the
> >> +			 * 32.768KHz clock driving the course counter that
> >> +			 * corrects the fine counter every time it ticks is
> >> +			 * actually rate/610 rather than 32.768KHz and we
> >> +			 * should compensate to avoid the 570ppm (At 20MHz,
> >> +			 * much worse at other rates) too fast system time.
> >> +			 *
> >> +			 * Precalculate the arch_timer_freq, since
> >> +			 * rate/610 isn't integer math and accuracy is
> >> +			 * desirable here.
> >> +			 */
> >> +			if (reg) {
> >> +				switch (rate) {
> >> +				case 19200000:
> >> +					num = 375;
> >> +					den = 1220;
> >> +					arch_timer_freq = 5901639;
> >> +					break;
> >> +				case 27000000:
> >> +					num = 375;
> >> +					den = 1220;
> >> +					arch_timer_freq = 8299180;
> >> +					break;
> >> +				case 20000000:
> 
> >> +				default:
> >> +					num = 375;
> >> +					den = 1220;
> >> +					arch_timer_freq = 6147541;
> >> +					break;
> >> +				}
> >> +				reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
> >> +						NUMERATOR_DENUMERATOR_MASK;
> >> +				reg |= num;
> >> +				writel_relaxed(reg, base + INCREMENTER_NUMERATOR_OFFSET);
> >> +
> >> +				reg = readl_relaxed(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
> >> +						NUMERATOR_DENUMERATOR_MASK;
> >> +				reg |= den;
> >> +				writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> >> +
> >> +				printk(KERN_WARNING "DRA7xx CP15 compensated for sloppy internal 32KHz clock.\n");
> 
> we would want to reuse the configuration code previously done, not
> repeat the logic.

So which part do you suggest reusing?

> in general we want the flow to be common - so the point in logic where
> num, den is decided is also the place you want this logic to fit in..

I was trying to avoid making the code mroe complicated for the other
CPUs using this code, but I suppose since it runs only at boot once,
that probably isn't really a great concern.

I will try changing the flow and send an updated version.

-- 
Len Sorensen
