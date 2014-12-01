Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaLAL4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:56:31 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64526 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbaLAL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:56:30 -0500
Message-ID: <1417434988.30245.33.camel@x220>
Subject: Re: [PATCH 1/2] ARM: at91: remove at91sam9261/at91sam9g10 legacy
 board support
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Mon, 01 Dec 2014 12:56:28 +0100
In-Reply-To: <2e591e7b3ac20c8f686a6099d236d09964d08406.1416568804.git.nicolas.ferre@atmel.com>
References: <2e591e7b3ac20c8f686a6099d236d09964d08406.1416568804.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2014 11:56:28.0156 (UTC) FILETIME=[D6DB4BC0:01D00D5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 12:27 +0100, Nicolas Ferre wrote:
> Remove legacy support for at91sam9261/at91sam9g10 boards.
> This include board files removal plus all legacy code for non DT boards
> support.
> Use the Device Tree for running this board with newer kernels.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

There's some further cleanup possible after this patch. I noticed that
when it landed in today's linux-next (ie, next-20141201) as commit
2e591e7b3ac2 ("ARM: at91: remove at91sam9261/at91sam9g10 legacy board
support").

>  arch/arm/configs/at91sam9261_9g10_defconfig |  147 ----
>  arch/arm/mach-at91/Kconfig.non_dt           |   34 -
>  arch/arm/mach-at91/Makefile                 |    5 -
>  arch/arm/mach-at91/at91sam9261.c            |  375 ---------
>  arch/arm/mach-at91/at91sam9261_devices.c    | 1098 ---------------------------
>  arch/arm/mach-at91/board-sam9261ek.c        |  623 ---------------
>  6 files changed, 2282 deletions(-)
>  delete mode 100644 arch/arm/configs/at91sam9261_9g10_defconfig
>  delete mode 100644 arch/arm/mach-at91/at91sam9261_devices.c
>  delete mode 100644 arch/arm/mach-at91/board-sam9261ek.c
> 
>[...]
> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
> deleted file mode 100644
> index 29baacb5c359..000000000000
> --- a/arch/arm/mach-at91/at91sam9261_devices.c
> +++ /dev/null
>[...]
> -/* --------------------------------------------------------------------
> - *  RTT
> - * -------------------------------------------------------------------- */
> -
> -static struct resource rtt_resources[] = {
> -	{
> -		.start	= AT91SAM9261_BASE_RTT,
> -		.end	= AT91SAM9261_BASE_RTT + SZ_16 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	}, {
> -		.flags	= IORESOURCE_MEM,
> -	}, {
> -		.flags  = IORESOURCE_IRQ,
> -	}
> -};
> -
> -static struct platform_device at91sam9261_rtt_device = {
> -	.name		= "at91_rtt",
> -	.id		= 0,
> -	.resource	= rtt_resources,
> -};
> -
> -#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> -static void __init at91_add_device_rtt_rtc(void)
> -{
> -	at91sam9261_rtt_device.name = "rtc-at91sam9";
> -	/*
> -	 * The second resource is needed:
> -	 * GPBR will serve as the storage for RTC time offset
> -	 */
> -	at91sam9261_rtt_device.num_resources = 3;
> -	rtt_resources[1].start = AT91SAM9261_BASE_GPBR +
> -				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;

This was the only place where the Kconfig symbol RTC_DRV_AT91SAM9_GPBR
was used. That again matches its help text:
    This option is only relevant for legacy board support and
    won't be used when booting a DT board.

> -	rtt_resources[1].end = rtt_resources[1].start + 3;
> -	rtt_resources[2].start = NR_IRQS_LEGACY + AT91_ID_SYS;
> -	rtt_resources[2].end = NR_IRQS_LEGACY + AT91_ID_SYS;
> -}
> -#else
> -static void __init at91_add_device_rtt_rtc(void)
> -{
> -	/* Only one resource is needed: RTT not used as RTC */
> -	at91sam9261_rtt_device.num_resources = 1;
> -}
> -#endif
> -
> -static void __init at91_add_device_rtt(void)
> -{
> -	at91_add_device_rtt_rtc();
> -	platform_device_register(&at91sam9261_rtt_device);
> -}

Is a patch to also remove that symbol from drivers/rtc/Kconfig queued
somewhere?


Paul Bolle

