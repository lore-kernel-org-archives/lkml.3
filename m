Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbbAWKaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:30:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49318 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbbAWKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:30:11 -0500
Date: Fri, 23 Jan 2015 11:30:06 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sylvain.rochet@finsecur.com, peda@axentia.se
Subject: Re: [PATCH 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Message-ID: <20150123103006.GH19922@piout.net>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-8-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421741825-18226-8-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2015 at 16:17:00 +0800, Wenyou Yang wrote :
> To simply the PM code, the suspend to standby mode uses the same sram function
> as the suspend to memory mode, running in the internal SRAM,
> instead of the respective code for each mode.
> 
> But for the suspend to standby mode, the master clock doesn't
> switch to the slow clock,  and the main oscillator doesn't
> turn off as well.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

That looks quite better, thanks.
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/mach-at91/pm.c           |   81 ++++++++++++++++---------------------
>  arch/arm/mach-at91/pm.h           |    6 +++
>  arch/arm/mach-at91/pm_slowclock.S |   18 +++++++++
>  3 files changed, 59 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 691e6db..a1010f0 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -145,62 +145,51 @@ extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
>  			    void __iomem *ramc1, int memctrl);
>  extern u32 at91_slow_clock_sz;
>  
> +static void at91_pm_suspend(suspend_state_t state)
> +{
> +	unsigned int pm_data = at91_pm_data.memctrl;
> +
> +	pm_data |= (state == PM_SUSPEND_MEM) ?
> +			(AT91_PM_SLOW_CLOCK << AT91_PM_MODE_OFFSET) : 0;
> +
> +	slow_clock(at91_pmc_base, at91_ramc_base[0],
> +			at91_ramc_base[1], pm_data);
> +}
> +
>  static int at91_pm_enter(suspend_state_t state)
>  {
>  	at91_pinctrl_gpio_suspend();
>  
>  	switch (state) {
> +	/*
> +	 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
> +	 * drivers must suspend more deeply, the master clock switches
> +	 * to the clk32k and turns off the main oscillator
> +	 *
> +	 * STANDBY mode has *all* drivers suspended; ignores irqs not
> +	 * marked as 'wakeup' event sources; and reduces DRAM power.
> +	 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
> +	 * nothing fancy done with main or cpu clocks.
> +	 */
> +	case PM_SUSPEND_MEM:
> +	case PM_SUSPEND_STANDBY:
>  		/*
> -		 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
> -		 * drivers must suspend more deeply:  only the master clock
> -		 * controller may be using the main oscillator.
> +		 * Ensure that clocks are in a valid state.
>  		 */
> -		case PM_SUSPEND_MEM:
> -			/*
> -			 * Ensure that clocks are in a valid state.
> -			 */
> -			if (!at91_pm_verify_clocks())
> -				goto error;
> -
> -			/*
> -			 * Enter slow clock mode by switching over to clk32k and
> -			 * turning off the main oscillator; reverse on wakeup.
> -			 */
> -			if (slow_clock) {
> -				slow_clock(at91_pmc_base, at91_ramc_base[0],
> -					   at91_ramc_base[1],
> -					   at91_pm_data.memctrl);
> -				break;
> -			} else {
> -				pr_info("AT91: PM - no slow clock mode enabled ...\n");
> -				/* FALLTHROUGH leaving master clock alone */
> -			}
> +		if (!at91_pm_verify_clocks())
> +			goto error;
>  
> -		/*
> -		 * STANDBY mode has *all* drivers suspended; ignores irqs not
> -		 * marked as 'wakeup' event sources; and reduces DRAM power.
> -		 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
> -		 * nothing fancy done with main or cpu clocks.
> -		 */
> -		case PM_SUSPEND_STANDBY:
> -			/*
> -			 * NOTE: the Wait-for-Interrupt instruction needs to be
> -			 * in icache so no SDRAM accesses are needed until the
> -			 * wakeup IRQ occurs and self-refresh is terminated.
> -			 * For ARM 926 based chips, this requirement is weaker
> -			 * as at91sam9 can access a RAM in self-refresh mode.
> -			 */
> -			if (at91_pm_standby)
> -				at91_pm_standby();
> -			break;
> +		at91_pm_suspend(state);
>  
> -		case PM_SUSPEND_ON:
> -			cpu_do_idle();
> -			break;
> +		break;
>  
> -		default:
> -			pr_debug("AT91: PM - bogus suspend state %d\n", state);
> -			goto error;
> +	case PM_SUSPEND_ON:
> +		cpu_do_idle();
> +		break;
> +
> +	default:
> +		pr_debug("AT91: PM - bogus suspend state %d\n", state);
> +		goto error;
>  	}
>  
>  error:
> diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
> index 7664d39..fbfea42 100644
> --- a/arch/arm/mach-at91/pm.h
> +++ b/arch/arm/mach-at91/pm.h
> @@ -15,6 +15,12 @@
>  
>  #include <mach/at91_ramc.h>
>  
> +#define AT91_PM_MEMCTRL_MASK	0x0f
> +#define AT91_PM_MODE_OFFSET	4
> +#define AT91_PM_MODE_MASK	0x0f
> +
> +#define	AT91_PM_SLOW_CLOCK	0x01
> +
>  /*
>   * On all at91 except rm9200 and x40 have the System Controller starts
>   * at address 0xffffc000 and has a size of 16KiB.
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index 634d819..92d7e63 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -15,12 +15,15 @@
>  #include <linux/clk/at91_pmc.h>
>  #include <mach/at91_ramc.h>
>  
> +#include "pm.h"
> +
>  pmc	.req	r0
>  sdramc	.req	r1
>  ramc1	.req	r2
>  memctrl	.req	r3
>  tmp1	.req	r4
>  tmp2	.req	r5
> +mode	.req	r6
>  
>  /*
>   * Wait until master clock is ready (after switching master clock source)
> @@ -72,6 +75,13 @@ ENTRY(at91_slow_clock)
>  	mov	tmp1, #0
>  	mcr	p15, 0, tmp1, c7, c10, 4
>  
> +	mov	tmp1, memctrl
> +	mov	tmp2, tmp1, lsr#AT91_PM_MODE_OFFSET
> +	and	mode, tmp2, #AT91_PM_MODE_MASK
> +
> +	mov	tmp1, memctrl
> +	and	memctrl, tmp1, #AT91_PM_MEMCTRL_MASK
> +
>  	cmp	memctrl, #AT91_MEMCTRL_MC
>  	bne	ddr_sr_enable
>  
> @@ -144,6 +154,9 @@ sdr_sr_enable:
>  	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
>  
>  sdr_sr_done:
> +	tst	mode, #AT91_PM_SLOW_CLOCK
> +	beq	skip_disable_clock
> +
>  	/* Save Master clock setting */
>  	ldr	tmp1, [pmc, #AT91_PMC_MCKR]
>  	str	tmp1, .saved_mckr
> @@ -169,9 +182,13 @@ sdr_sr_done:
>  	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
>  	str	tmp1, [pmc, #AT91_CKGR_MOR]
>  
> +skip_disable_clock:
>  	/* Wait for interrupt */
>  	mcr	p15, 0, tmp1, c7, c0, 4
>  
> +	tst	mode, #AT91_PM_SLOW_CLOCK
> +	beq	skip_enable_clock
> +
>  	/* Turn on the main oscillator */
>  	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
>  	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
> @@ -199,6 +216,7 @@ sdr_sr_done:
>  
>  	wait_mckrdy
>  
> +skip_enable_clock:
>  	/*
>  	 * at91rm9200 Memory controller
>  	 * Do nothing - self-refresh is automatically disabled.
> -- 
> 1.7.9.5
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
