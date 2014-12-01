Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaLAQK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:10:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50333 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaLAQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:10:25 -0500
Message-ID: <547C92F0.5050402@atmel.com>
Date: Mon, 1 Dec 2014 17:10:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/2] ARM: at91: remove at91sam9261/at91sam9g10 legacy
 board support
References: <2e591e7b3ac20c8f686a6099d236d09964d08406.1416568804.git.nicolas.ferre@atmel.com> <1417434988.30245.33.camel@x220>
In-Reply-To: <1417434988.30245.33.camel@x220>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 12:56, Paul Bolle a écrit :
> On Fri, 2014-11-21 at 12:27 +0100, Nicolas Ferre wrote:
>> Remove legacy support for at91sam9261/at91sam9g10 boards.
>> This include board files removal plus all legacy code for non DT boards
>> support.
>> Use the Device Tree for running this board with newer kernels.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> There's some further cleanup possible after this patch. I noticed that
> when it landed in today's linux-next (ie, next-20141201) as commit
> 2e591e7b3ac2 ("ARM: at91: remove at91sam9261/at91sam9g10 legacy board
> support").
> 
>>  arch/arm/configs/at91sam9261_9g10_defconfig |  147 ----
>>  arch/arm/mach-at91/Kconfig.non_dt           |   34 -
>>  arch/arm/mach-at91/Makefile                 |    5 -
>>  arch/arm/mach-at91/at91sam9261.c            |  375 ---------
>>  arch/arm/mach-at91/at91sam9261_devices.c    | 1098 ---------------------------
>>  arch/arm/mach-at91/board-sam9261ek.c        |  623 ---------------
>>  6 files changed, 2282 deletions(-)
>>  delete mode 100644 arch/arm/configs/at91sam9261_9g10_defconfig
>>  delete mode 100644 arch/arm/mach-at91/at91sam9261_devices.c
>>  delete mode 100644 arch/arm/mach-at91/board-sam9261ek.c
>>
>> [...]
>> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
>> deleted file mode 100644
>> index 29baacb5c359..000000000000
>> --- a/arch/arm/mach-at91/at91sam9261_devices.c
>> +++ /dev/null
>> [...]
>> -/* --------------------------------------------------------------------
>> - *  RTT
>> - * -------------------------------------------------------------------- */
>> -
>> -static struct resource rtt_resources[] = {
>> -	{
>> -		.start	= AT91SAM9261_BASE_RTT,
>> -		.end	= AT91SAM9261_BASE_RTT + SZ_16 - 1,
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags  = IORESOURCE_IRQ,
>> -	}
>> -};
>> -
>> -static struct platform_device at91sam9261_rtt_device = {
>> -	.name		= "at91_rtt",
>> -	.id		= 0,
>> -	.resource	= rtt_resources,
>> -};
>> -
>> -#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>> -static void __init at91_add_device_rtt_rtc(void)
>> -{
>> -	at91sam9261_rtt_device.name = "rtc-at91sam9";
>> -	/*
>> -	 * The second resource is needed:
>> -	 * GPBR will serve as the storage for RTC time offset
>> -	 */
>> -	at91sam9261_rtt_device.num_resources = 3;
>> -	rtt_resources[1].start = AT91SAM9261_BASE_GPBR +
>> -				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
> 
> This was the only place where the Kconfig symbol RTC_DRV_AT91SAM9_GPBR
> was used. That again matches its help text:
>     This option is only relevant for legacy board support and
>     won't be used when booting a DT board.
> 
>> -	rtt_resources[1].end = rtt_resources[1].start + 3;
>> -	rtt_resources[2].start = NR_IRQS_LEGACY + AT91_ID_SYS;
>> -	rtt_resources[2].end = NR_IRQS_LEGACY + AT91_ID_SYS;
>> -}
>> -#else
>> -static void __init at91_add_device_rtt_rtc(void)
>> -{
>> -	/* Only one resource is needed: RTT not used as RTC */
>> -	at91sam9261_rtt_device.num_resources = 1;
>> -}
>> -#endif
>> -
>> -static void __init at91_add_device_rtt(void)
>> -{
>> -	at91_add_device_rtt_rtc();
>> -	platform_device_register(&at91sam9261_rtt_device);
>> -}
> 
> Is a patch to also remove that symbol from drivers/rtc/Kconfig queued
> somewhere?

Yes, we are in the same situation as the at91sam9263. We will certainly
remove them during the 3.19-rc phase.

Tanks, best regards,
-- 
Nicolas Ferre
