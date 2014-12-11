Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbaLKUnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:43:13 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:43536 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbaLKUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:43:11 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 11 Dec 2014 15:43:08 -0500
To: R Sricharan <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: OMAP5/DRA7: Fix counter frequency drift for AM572x errata
 i856
Message-ID: <20141211204308.GU24110@csclub.uwaterloo.ca>
References: <20141211204116.GT24110@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211204116.GT24110@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 03:41:16PM -0500, Lennart Sorensen wrote:
> Errata i856 for the AM572x (DRA7xx) points out that the 32.768KHz external
> crystal is not enabled at power up.  Instead the CPU falls back to using
> an emulation for the 32KHz clock which is SYSCLK1/610.  SYSCLK1 is usually
> 20MHz on boards so far (which gives an emulated frequency of 32.786KHz),
> but can also be 19.2 or 27MHz which result in much larger drift.
> 
> Since this is used to drive the master counter at 32.768KHz * 375 /
> 2 = 6.144MHz, the emulated speed for 20MHz is of by 570ppm, or about 43
> seconds per day, and more than the 500ppm NTP is able to tolerate.
> 
> Checking the CTRL_CORE_BOOTSTRAP register can determine if the CPU
> is using the real 32.768KHz crystal or the emulated SYSCLK1/610, and
> by known that the real counter frequency can be determined and used.
> The real speed is then SYSCLK1 / 610 * 375 / 2 or SYSCLK1 * 375 / 1220.
> This is unfortunately not integer math so the actual arch_timer_freq
> needs to be precalculated.
> 
> Also the SYSCLK1 frequencies that have never been used by an omap
> evaluation board were all missing a 0.
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 4f61148..2e81511 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
>  	rate = clk_get_rate(sys_clk);
>  	/* Numerator/denumerator values refer TRM Realtime Counter section */
>  	switch (rate) {
> -	case 1200000:
> +	case 12000000:
>  		num = 64;
>  		den = 125;
>  		break;
> -	case 1300000:
> +	case 13000000:
>  		num = 768;
>  		den = 1625;
>  		break;
> @@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
>  		num = 192;
>  		den = 625;
>  		break;
> -	case 2600000:
> +	case 26000000:
>  		num = 384;
>  		den = 1625;
>  		break;
> -	case 2700000:
> +	case 27000000:
>  		num = 256;
>  		den = 1125;
>  		break;
> @@ -557,6 +557,73 @@ static void __init realtime_counter_init(void)
>  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>  
>  	arch_timer_freq = (rate / den) * num;
> +
> +	if (soc_is_dra7xx()) {
> +		#define CTRL_CORE_BOOTSTRAP 0x4A0026C4
> +		#define SPEEDSELECT_MASK 0x00000300
> +		void __iomem *corebase;
> +		corebase = ioremap(CTRL_CORE_BOOTSTRAP, SZ_4);
> +		if (!corebase)
> +			pr_err("%s: ioremap failed\n", __func__);
> +		else {
> +			reg = readl_relaxed(corebase) & SPEEDSELECT_MASK;
> +			iounmap(corebase);
> +			/*
> +			 * Errata i856 says the 32.768KHz crystal does
> +			 * not start at power on, so the CPU falls back in
> +			 * an emulated 32KHz clock instead.  This causes
> +			 * the master counter frequency to not be what it
> +			 * was expected to be.	This affects at least
> +			 * the AM572x 1.0 and 1.1 revisions.
> +			 * Of course any board built without a populated
> +			 * 32.768KHz crystal would also need this fix
> +			 * even if the CPU is fixed later.
> +			 *
> +			 * If the two speedselect bits are not 0, then the
> +			 * 32.768KHz clock driving the course counter that
> +			 * corrects the fine counter every time it ticks is
> +			 * actually rate/610 rather than 32.768KHz and we
> +			 * should compensate to avoid the 570ppm (At 20MHz,
> +			 * much worse at other rates) too fast system time.
> +			 *
> +			 * Precalculate the arch_timer_freq, since
> +			 * rate/610 isn't integer math and accuracy is
> +			 * desirable here.
> +			 */
> +			if (reg) {
> +				switch (rate) {
> +				case 19200000:
> +					num = 375;
> +					den = 1220;
> +					arch_timer_freq = 5901639;
> +					break;
> +				case 27000000:
> +					num = 375;
> +					den = 1220;
> +					arch_timer_freq = 8299180;
> +					break;
> +				case 20000000:
> +				default:
> +					num = 375;
> +					den = 1220;
> +					arch_timer_freq = 6147541;
> +					break;
> +				}
> +				reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
> +						NUMERATOR_DENUMERATOR_MASK;
> +				reg |= num;
> +				writel_relaxed(reg, base + INCREMENTER_NUMERATOR_OFFSET);
> +
> +				reg = readl_relaxed(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
> +						NUMERATOR_DENUMERATOR_MASK;
> +				reg |= den;
> +				writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> +
> +				printk(KERN_WARNING "DRA7xx CP15 compensated for sloppy internal 32KHz clock.\n");
> +			}
> +		}
> +	}
> +
>  	set_cntfreq();
>  
>  	iounmap(base);

I am perfectly willing to split this into two patches it prefered (one
for the counter frequency fix and one for the rate typos).

Other cleanups needed would be great too, since I am still not too
pleased with how this looks.

With this fix however many boards have run ntp with drift less than 3ppm,
so it works very well.

-- 
Len Sorensen
