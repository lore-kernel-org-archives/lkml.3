Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaLPTAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:00:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLPTAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:00:17 -0500
Message-ID: <54908128.7040005@ti.com>
Date: Tue, 16 Dec 2014 12:59:52 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Lokesh Vutla <lokeshvutla@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca> <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca> <20141214044517.GD24110@csclub.uwaterloo.ca> <549018EC.8020207@ti.com> <20141216145856.GA23358@kahuna> <20141216163657.GL24110@csclub.uwaterloo.ca>
In-Reply-To: <20141216163657.GL24110@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:36 AM, Lennart Sorensen wrote:
[...]
>> B) Since rate switch is no longer needed, how about something like the
>> following:
>> diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
>> index a3c0133..315d6d1 100644
>> --- a/arch/arm/mach-omap2/control.h
>> +++ b/arch/arm/mach-omap2/control.h
>> @@ -286,6 +286,11 @@
>>  #define OMAP5XXX_CONTROL_STATUS                0x134
>>  #define OMAP5_DEVICETYPE_MASK          (0x7 << 6)
>>  
>> +
>> +/* DRA7XX CONTROL CORE BOOTSTRAP */
>> +#define DRA7_CTRL_CORE_BOOTSTRAP	0x6c4
>> +#define DRA7_SPEEDSELECT_MASK		(0x3 << 8)
>> +
>>  /*
>>   * REVISIT: This list of registers is not comprehensive - there are more
>>   * that should be added.
> 
> I like that as a place for those.
> 
>> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
>> index 4f61148..783d3c3 100644
>> --- a/arch/arm/mach-omap2/timer.c
>> +++ b/arch/arm/mach-omap2/timer.c
>> @@ -54,6 +54,7 @@
>>  
>>  #include "soc.h"
>>  #include "common.h"
>> +#include "control.h"
>>  #include "powerdomain.h"
>>  #include "omap-secure.h"
>>  
> 
> How about this version for the rest of the file.  It handles that for
> the errata case we would like to do rate * num / den, which given how
> small the num is will fit in 32bit and gives the best accuracy for the
> calculation, while the non errata case the existing calculation works
> well and fits in 32 bit for all other cases.  It just has to be moved
> up so that the goto can skip it.  I changed sysclk to sysclk1 since on
> the dra7xx there is in fact a sysclk1 and a sysclk2 and it is probably
> worth keeping it clear which one this is referring to.
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index fb0cb2b..be254bf 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -511,6 +511,36 @@ static void __init realtime_counter_init(void)
>  	}
>  
>  	rate = clk_get_rate(sys_clk);
> +
> +	if (soc_is_dra7xx()) {
> +		/*
> +		 * Errata i856 says the 32.768KHz crystal does not start at
> +		 * power on, so the CPU falls back to an emulated 32KHz clock
> +		 * based on sysclk1 / 610 instead. This causes the master counter
> +		 * frequency to not be 6.144MHz but at sysclk1 / 610 * 375 / 2
> +		 * (OR sysclk1 * 75 / 244)
> +		 *
> +		 * This affects at least the DRA7/AM572x 1.0, 1.1 revisions.
> +		 * Of course any board built without a populated 32.768KHz
> +	         * crystal would also need this fix even if the CPU is fixed
> +		 * later.
> +		 *
> +		 * Either case can be detected by using the two speedselect bits
> +		 * If they are not 0, then the 32.768KHz clock driving the
> +		 * coarse counter that corrects the fine counter every time it
> +		 * ticks is actually rate/610 rather than 32.768KHz and we
> +		 * should compensate to avoid the 570ppm (at 20MHz, much worse
> +		 * at other rates) too fast system time.
> +		 */
> +		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
> +		if (reg & DRA7_SPEEDSELECT_MASK) {
> +			num = 75;
> +			den = 244;
> +			arch_timer_freq = (rate * num) / den;
> +			goto sysclk1_based;
> +		}
> +	}
> +
>  	/* Numerator/denumerator values refer TRM Realtime Counter section */
>  	switch (rate) {
>  	case 12000000:
> @@ -544,7 +574,9 @@ static void __init realtime_counter_init(void)
>  		den = 25;
>  		break;
>  	}
> +	arch_timer_freq = (rate / den) * num;
>  
> +sysclk1_based:
>  	/* Program numerator and denumerator registers */
>  	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
>  			NUMERATOR_DENUMERATOR_MASK;
> @@ -556,7 +588,6 @@ static void __init realtime_counter_init(void)
>  	reg |= den;
>  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>  
> -	arch_timer_freq = (rate / den) * num;

I see why arch_timer_freq might skip the rounding error of 39, 15 and
55 Vs existing logic which is possibly at a truncation error risk
(without errata for sysclk 13, 26 and 27MHz).

all you'd probably need to do is cast rate, num and den to unsigned
long and have a common computation logic.

if you'd really want to handle truncation error, it must be a separate
patch of it's own - I would not mix it with the errata fix.


-- 
Regards,
Nishanth Menon
