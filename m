Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbbA2KL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:11:28 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57913 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbbA2KLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:11:22 -0500
Message-ID: <54CA0739.2030101@cogentembedded.com>
Date: Thu, 29 Jan 2015 13:11:05 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, sylvain.rochet@finsecur.com,
        peda@axentia.se, linux@maxim.org.za
Subject: Re: [PATCH v5 05/13] pm: at91: move the copying the sram function
 to the sram initializationi phase
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com> <1422513535-23885-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1422513535-23885-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/29/2015 9:38 AM, Wenyou Yang wrote:

> To decrease the suspend time, move the copying the sram function
> to the sram initialization phase, instead of every time go to suspend.

> In the meanwhile, if there is no sram allocated for PM, the PM is not supported.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/mach-at91/pm.c |   12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index daa998d..6df0152 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -163,10 +163,6 @@ static int at91_pm_enter(suspend_state_t state)
>   			 * turning off the main oscillator; reverse on wakeup.
>   			 */
>   			if (slow_clock) {
> -#ifdef CONFIG_AT91_SLOW_CLOCK
> -				/* copy slow_clock handler to SRAM, and call it */
> -				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> -#endif
>   				slow_clock(at91_pmc_base, at91_ramc_base[0],
>   					   at91_ramc_base[1],
>   					   at91_pm_data.memctrl);
> @@ -311,6 +307,9 @@ static void __init at91_pm_sram_init(void)
>   	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
>   	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
>
> +	/* Copy the slow_clock handler to SRAM */
> +	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);

    AFAIU (looking at the code above and below), __arm_ioremap_exec() can 
return NULL and in this case memcpy() will cause kernel oops.

> @@ -328,7 +327,10 @@ static void __init at91_pm_init(void)
>   	if (at91_cpuidle_device.dev.platform_data)
>   		platform_device_register(&at91_cpuidle_device);
>
> -	suspend_set_ops(&at91_pm_ops);
> +	if (slow_clock)
> +		suspend_set_ops(&at91_pm_ops);
> +	else
> +		pr_info("AT91: PM : Not supported, due to no sram allocated\n");

    I'd suggest upper-casing "sram". And removing of colon after "PM".

[...]

WBR, Sergei

