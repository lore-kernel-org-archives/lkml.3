Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaLNEpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 23:45:21 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:60050 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaLNEpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 23:45:20 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Sat, 13 Dec 2014 23:45:17 -0500
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141214044517.GD24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 05:08:56PM -0500, Lennart Sorensen wrote:
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
s/known/knowing/
and a comma after that.
> The real speed is then SYSCLK1 / 610 * 375 / 2 or SYSCLK1 * 75 / 244.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> ---
>  arch/arm/mach-omap2/timer.c |  120 +++++++++++++++++++++++++++++++------------
>  1 file changed, 87 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index fb0cb2b..f00e4b4 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -497,6 +497,7 @@ static void __init realtime_counter_init(void)
>  	static struct clk *sys_clk;
>  	unsigned long rate;
>  	unsigned int reg, num, den;
> +	bool errata_i856_workaround = false;
>  
>  	base = ioremap(REALTIME_COUNTER_BASE, SZ_32);
>  	if (!base) {
> @@ -510,39 +511,93 @@ static void __init realtime_counter_init(void)
>  		return;
>  	}
>  
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
> +			 * the master counter frequency to not be 6.144MHz
> +			 * This affects at least the AM572x 1.0 and
> +			 * 1.1 revisions.
> +			 *
> +			 * Of course any board built without a populated
> +			 * 32.768KHz crystal would also need this fix
> +			 * even if the CPU is fixed later.
> +			 *
> +			 * If the two speedselect bits are not 0, then the
> +			 * 32.768KHz clock driving the course counter that
s/course/coarse/
> +			 * corrects the fine counter every time it ticks is
> +			 * actually rate/610 rather than 32.768KHz and we
> +			 * should compensate to avoid the 570ppm (At 20MHz,
> +			 * much worse at other rates) too fast system time.
> +			 */
> +			if (reg) {
> +				errata_i856_workaround = true;
> +			}
> +		}
> +	}
> +
>  	rate = clk_get_rate(sys_clk);
> -	/* Numerator/denumerator values refer TRM Realtime Counter section */
> -	switch (rate) {
> -	case 12000000:
> -		num = 64;
> -		den = 125;
> -		break;
> -	case 13000000:
> -		num = 768;
> -		den = 1625;
> -		break;
> -	case 19200000:
> -		num = 8;
> -		den = 25;
> -		break;
> -	case 20000000:
> -		num = 192;
> -		den = 625;
> -		break;
> -	case 26000000:
> -		num = 384;
> -		den = 1625;
> -		break;
> -	case 27000000:
> -		num = 256;
> -		den = 1125;
> -		break;
> -	case 38400000:
> -	default:
> -		/* Program it for 38.4 MHz */
> -		num = 4;
> -		den = 25;
> -		break;
> +	if (errata_i856_workaround) {
> +		/*
> +		 * Realtime Counter frequency is not based on a real
> +		 * 32.768KHz time source, so calculate the real resulting
> +		 * frequency instead.  It is not 6.144MHz in this case.
> +		 *
> +		 * The frequency is always rate / 610 + 375 / 2 which
> +		 * is rate * 244 / 75 and will fit in 32 bit for all rates.
> +		 *
> +		 * The multiplication has to be first to keep accuracy
> +		 * with integer math as high as possible.
> +		 */
> +		num = 75;
> +		den = 244;
> +		arch_timer_freq = (rate * num) / den;
> +	} else {
> +		/* Numerator/denumerator values refer TRM Realtime Counter section */
> +		switch (rate) {
> +		case 12000000:
> +			num = 64;
> +			den = 125;
> +			break;
> +		case 13000000:
> +			num = 768;
> +			den = 1625;
> +			break;
> +		case 19200000:
> +			num = 8;
> +			den = 25;
> +			break;
> +		case 20000000:
> +			num = 192;
> +			den = 625;
> +			break;
> +		case 26000000:
> +			num = 384;
> +			den = 1625;
> +			break;
> +		case 27000000:
> +			num = 256;
> +			den = 1125;
> +			break;
> +		case 38400000:
> +		default:
> +			/* Program it for 38.4 MHz */
> +			num = 4;
> +			den = 25;
> +			break;
> +		}
> +		/* This divides cleanly and fits in 32 bits */
> +		arch_timer_freq = (rate / den) * num;
>  	}
>  
>  	/* Program numerator and denumerator registers */
> @@ -556,7 +611,6 @@ static void __init realtime_counter_init(void)
>  	reg |= den;
>  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>  
> -	arch_timer_freq = (rate / den) * num;
>  	set_cntfreq();
>  
>  	iounmap(base);
> -- 
> 1.7.10.4

Stupid typos.  Will make sure to include in next revision, and maybe
I can manage to reword the description a bit to make it flow better or
be clearer.

-- 
Len Sorensen
