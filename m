Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbbANThf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:37:35 -0500
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:43379 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbANThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:37:34 -0500
X-Greylist: delayed 96832 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 14:37:33 EST
Date: Wed, 14 Jan 2015 20:14:12 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: at91: pm: rework cpu detection
Message-ID: <20150114191412.GA14457@ns203013.ovh.net>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421097825-396-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421097825-396-2-git-send-email-alexandre.belloni@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Ovh-Tracer-Id: 13836183956745137043
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejjedrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejjedrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:23 Mon 12 Jan     , Alexandre Belloni wrote:
> Store SoC differences in a struct to remove cpu_is_* usage.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/pm.c | 54 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 9b15169a1c62..79aa793d1f00 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -17,6 +17,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sysfs.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/clk/at91_pmc.h>
> @@ -32,6 +33,11 @@
>  #include "generic.h"
>  #include "pm.h"
>  
> +static struct {
> +	unsigned long uhp_udp_mask;
> +	int memctrl;
> +} at91_pm_data;
> +
>  static void (*at91_pm_standby)(void);
>  
>  static int at91_pm_valid_state(suspend_state_t state)
> @@ -71,17 +77,9 @@ static int at91_pm_verify_clocks(void)
>  	scsr = at91_pmc_read(AT91_PMC_SCSR);
>  
>  	/* USB must not be using PLLB */
> -	if (cpu_is_at91rm9200()) {
> -		if ((scsr & (AT91RM9200_PMC_UHP | AT91RM9200_PMC_UDP)) != 0) {
> -			pr_err("AT91: PM - Suspend-to-RAM with USB still active\n");
> -			return 0;
> -		}
> -	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263()
> -			|| cpu_is_at91sam9g20() || cpu_is_at91sam9g10()) {
> -		if ((scsr & (AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP)) != 0) {
> -			pr_err("AT91: PM - Suspend-to-RAM with USB still active\n");
> -			return 0;
> -		}
> +	if ((scsr & at91_pm_data.uhp_udp_mask) != 0) {
> +		pr_err("AT91: PM - Suspend-to-RAM with USB still active\n");
> +		return 0;
>  	}
>  
>  	/* PCK0..PCK3 must be disabled, or configured to use clk32k */
> @@ -149,18 +147,13 @@ static int at91_pm_enter(suspend_state_t state)
>  			 * turning off the main oscillator; reverse on wakeup.
>  			 */
>  			if (slow_clock) {
> -				int memctrl = AT91_MEMCTRL_SDRAMC;
> -
> -				if (cpu_is_at91rm9200())
> -					memctrl = AT91_MEMCTRL_MC;
> -				else if (cpu_is_at91sam9g45())
> -					memctrl = AT91_MEMCTRL_DDRSDR;
>  #ifdef CONFIG_AT91_SLOW_CLOCK
>  				/* copy slow_clock handler to SRAM, and call it */
>  				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
>  #endif
>  				slow_clock(at91_pmc_base, at91_ramc_base[0],
> -					   at91_ramc_base[1], memctrl);
> +					   at91_ramc_base[1],
> +					   at91_pm_data.memctrl);
>  				break;
>  			} else {
>  				pr_info("AT91: PM - no slow clock mode enabled ...\n");
> @@ -237,10 +230,29 @@ static int __init at91_pm_init(void)
>  
>  	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
>  
> -	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh. */
> -	if (cpu_is_at91rm9200())
> +	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
> +
> +	if (of_machine_is_compatible("atmel,at91rm9200")) {
> +		/*
> +		 * AT91RM9200 SDRAM low-power mode cannot be used with
> +		 * self-refresh.
> +		 */
>  		at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
> -	
> +
> +		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
> +					    AT91RM9200_PMC_UDP;
> +		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
> +	} else if (of_machine_is_compatible("atmel,at91sam9260") ||
> +		   of_machine_is_compatible("atmel,at91sam9g20") ||
> +		   of_machine_is_compatible("atmel,at91sam9261") ||
> +		   of_machine_is_compatible("atmel,at91sam9g10") ||
> +		   of_machine_is_compatible("atmel,at91sam9263")) {
nack here

you switch for runtime information from the SOC register store in ram to DT

DT is great but I do prefer to rely on the SoC register here as the whole was
also to check that the is correct

wihich is way slower

Best Regards,
J.
> +		at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP |
> +					    AT91SAM926x_PMC_UDP;
> +	} else if (of_machine_is_compatible("atmel,at91sam9g45")) {
> +		at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
> +	}
> +
>  	if (at91_cpuidle_device.dev.platform_data)
>  		platform_device_register(&at91_cpuidle_device);
>  
> -- 
> 2.1.0
> 
