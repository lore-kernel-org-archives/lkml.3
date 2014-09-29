Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaI2MTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:19:03 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:56872 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaI2MTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:19:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 14:18:55 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: kernel@pengutronix.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        festevam@gmail.com, jingchang.lu@freescale.com, bpringlemeir@nbsps.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: vf610: Add ARM Global Timer clocksource
 option
In-Reply-To: <20140929115122.GA14087@tiger>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
 <1411575610-20895-4-git-send-email-stefan@agner.ch>
 <20140929115122.GA14087@tiger>
Message-ID: <21207261e1b7b480f56391bb37fa2847@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-29 13:51, schrieb Shawn Guo:
> On Wed, Sep 24, 2014 at 06:20:10PM +0200, Stefan Agner wrote:
>> Add the ARM Global Timer as clocksource/scheduler clock option and
>> use it as default scheduler clock. This leaves the PIT timer for
>> other users e.g. the secondary Cortex-M4 core. Also, the Global Timer
>> has double the precission (running at pheripheral clock compared to
>> IPG clock) and a 64-bit incrementing counter register. We still keep
>> the PIT timer as an secondary option in case the ARM Global Timer is
>> not available.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/mach-imx/Kconfig | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
>> index 11b2957..9482f58 100644
>> --- a/arch/arm/mach-imx/Kconfig
>> +++ b/arch/arm/mach-imx/Kconfig
>> @@ -633,12 +633,29 @@ config SOC_VF610
>>  	bool "Vybrid Family VF610 support"
>>  	select ARM_GIC
>>  	select PINCTRL_VF610
>> -	select VF_PIT_TIMER
>>  	select PL310_ERRATA_769419 if CACHE_L2X0
>>
>>  	help
>>  	  This enable support for Freescale Vybrid VF610 processor.
>>
>> +choice
>> +	prompt "Clocksource for scheduler clock"
>> +	depends on SOC_VF610
>> +	default ARM_GLOBAL_TIMER
>> +
>> +	config ARM_GLOBAL_TIMER
>> +		bool "Use ARM Global Timer"
>> +		select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>> +		help
>> +		  Use the ARM Global Timer as clocksource
>> +
>> +	config VF_PIT_TIMER
>> +		bool "Use PIT timer"
>> +		help
>> +		  Use SoC Periodic Interrupt Timer (PIT) as clocksource
>> +
>> +endchoice
>> +
> 
> As per the report from 0-DAY kernel build test (thanks), the change
> causes the following warning on a particular config.
> 
> warning: (ARCH_ROCKCHIP && ARCH_BCM_5301X) selects
> CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK which has unmet direct
> dependencies (ARM_GLOBAL_TIMER)
> 
> It looks the redefinition of ARM_GLOBAL_TIMER is the cause for that
> warning.  I think it's more safer to use new config symbols for choosing
> the clocksource device for VF610.  I propose the following change to fix
> the warning.  If there is no objection, I will squash it into the
> original commit soon.
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 9482f5837b7e..e26b0fdd72db 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -641,16 +641,18 @@ config SOC_VF610
>  choice
>         prompt "Clocksource for scheduler clock"
>         depends on SOC_VF610
> -       default ARM_GLOBAL_TIMER
> +       default VF_USE_ARM_GLOBAL_TIMER
>  
> -       config ARM_GLOBAL_TIMER
> +       config VF_USE_ARM_GLOBAL_TIMER
>                 bool "Use ARM Global Timer"
> +               select ARM_GLOBAL_TIMER
>                 select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>                 help
>                   Use the ARM Global Timer as clocksource
>  
> -       config VF_PIT_TIMER
> +       config VF_USE_PIT_TIMER
>                 bool "Use PIT timer"
> +               select VF_PIT_TIMER
>                 help
>                   Use SoC Periodic Interrupt Timer (PIT) as clocksource

I thought that Kconfig actually allowed to define a config symbol twice.
But maybe this is not a good idea with dependencies (depends on
SOC_VF610 on the choice level...?).

Thx Shawn, sorry about that.

Acked-by: Stefan Agner <stefan@agner.ch>
