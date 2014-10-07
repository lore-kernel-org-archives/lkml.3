Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaJGLG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:06:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53395 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbaJGLGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:06:25 -0400
Date: Tue, 7 Oct 2014 12:06:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] clocksource: arch_timer: Fix code to use physical
 timers when requested
Message-ID: <20141007110620.GG24725@leverpostej>
References: <1412656456-26663-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412656456-26663-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:34:16AM +0100, Sonny Rao wrote:
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
> 
> 0d651e4e "clocksource: arch_timer: use virtual counters"
> 
> We need this on certain ARMv7 systems which are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset between the
>   virtual and physical counters.  Each core gets a different random
>   offset.
> 
> * The device boots in "Secure SVC" mode.
> 
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
> 
> One example of such as system is RK3288 where it is much simpler to
> use the physical counter since there's nobody managing the offset and
> each time a core goes down and comes back up it will get reinitialized
> to some other random value.
> 
> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Acked-by: Olof Johansson <olof@lixom.net>
> ---
> v2: Add fixes tag to commit message, cc stable, copy Doug's
>     description of the systems which need this in commit message.
> v3: Don't change the memory-mapped physical timer/counter code
> ---
>  arch/arm/include/asm/arch_timer.h    |  9 +++++++++
>  arch/arm64/include/asm/arch_timer.h  | 10 ++++++++++
>  drivers/clocksource/arm_arch_timer.c | 25 ++++++++++++++++++++++---
>  3 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index 0704e0c..e72aa4d 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -78,6 +78,15 @@ static inline u32 arch_timer_get_cntfrq(void)
>  	return val;
>  }
>  
> +static inline u64 arch_counter_get_cntpct(void)
> +{
> +	u64 cval;
> +
> +	isb();
> +	asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
> +	return cval;
> +}
> +
>  static inline u64 arch_counter_get_cntvct(void)
>  {
>  	u64 cval;
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 9400596..58657c4 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -135,6 +135,16 @@ static inline void arch_timer_evtstrm_enable(int divider)
>  #endif
>  }
>  
> +static inline u64 arch_counter_get_cntpct(void)
> +{
> +	u64 cval;
> +
> +	isb();
> +	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
> +
> +	return cval;
> +}
> +
>  static inline u64 arch_counter_get_cntvct(void)
>  {
>  	u64 cval;
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec1..bd8da15 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -30,6 +30,8 @@
>  #define CNTTIDR		0x08
>  #define CNTTIDR_VIRT(n)	(BIT(1) << ((n) * 4))
>  
> +#define CNTPCT_LO	0x00
> +#define CNTPCT_HI	0x04
>  #define CNTVCT_LO	0x08
>  #define CNTVCT_HI	0x0c
>  #define CNTFRQ		0x10
> @@ -386,6 +388,19 @@ static u64 arch_counter_get_cntvct_mem(void)
>  	return ((u64) vct_hi << 32) | vct_lo;
>  }
>  
> +static u64 arch_counter_get_cntpct_mem(void)
> +{
> +	u32 pct_lo, pct_hi, tmp_hi;
> +
> +	do {
> +		pct_hi = readl_relaxed(arch_counter_base + CNTPCT_HI);
> +		pct_lo = readl_relaxed(arch_counter_base + CNTPCT_LO);
> +		tmp_hi = readl_relaxed(arch_counter_base + CNTPCT_HI);
> +	} while (pct_hi != tmp_hi);
> +
> +	return ((u64) pct_hi << 32) | pct_lo;
> +}

Theise MMIO timer changes should be dropped. They're unused below
anyhow.

Mark.

> +
>  /*
>   * Default to cp15 based access because arm64 uses this function for
>   * sched_clock() before DT is probed and the cp15 method is guaranteed
> @@ -429,10 +444,14 @@ static void __init arch_counter_register(unsigned type)
>  	u64 start_count;
>  
>  	/* Register the CP15 based counter if we have one */
> -	if (type & ARCH_CP15_TIMER)
> -		arch_timer_read_counter = arch_counter_get_cntvct;
> -	else
> +	if (type & ARCH_CP15_TIMER) {
> +		if (arch_timer_use_virtual)
> +			arch_timer_read_counter = arch_counter_get_cntvct;
> +		else
> +			arch_timer_read_counter = arch_counter_get_cntpct;
> +	} else {
>  		arch_timer_read_counter = arch_counter_get_cntvct_mem;
> +	}
>  
>  	start_count = arch_timer_read_counter();
>  	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
> -- 
> 1.8.3.2
> 
> 
