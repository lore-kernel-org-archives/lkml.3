Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176Ab3DRSL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:11:59 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:61944 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3DRSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:11:57 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCH 6/6] arm: mach-omap2: Remove "no_console_suspend"
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
	<1366198467-6757-7-git-send-email-sourav.poddar@ti.com>
Date: Thu, 18 Apr 2013 11:11:53 -0700
In-Reply-To: <1366198467-6757-7-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Wed, 17 Apr 2013 17:04:27 +0530")
Message-ID: <877gjz4sk6.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Since the omap serial driver is now adapted to handle the
> case where you dont need to cut the clock on suspend while
> using "no_console_suspend" in the bootargs.
>
> We can get rid of the previous implementation of setting the od->flags to
> "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" from platform
> and omap_device files.
>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

also, the serial.c change here should be a separate patch
subject: arm: omap2+: serial: remove no_console_suspend support

with a changelog stating that it's no longer handled in the core.

Kevin

> ---
>  arch/arm/mach-omap2/omap_device.c |    3 ---
>  arch/arm/mach-omap2/serial.c      |    7 -------
>  2 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index d6dce8f..c226946 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -170,9 +170,6 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
>  			r->name = dev_name(&pdev->dev);
>  	}
>  
> -	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
> -		omap_device_disable_idle_on_suspend(pdev);
> -
>  	pdev->dev.pm_domain = &omap_device_pm_domain;
>  
>  odbfd_exit1:
> diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
> index f660156..58d5b56 100644
> --- a/arch/arm/mach-omap2/serial.c
> +++ b/arch/arm/mach-omap2/serial.c
> @@ -63,7 +63,6 @@ struct omap_uart_state {
>  static LIST_HEAD(uart_list);
>  static u8 num_uarts;
>  static u8 console_uart_id = -1;
> -static u8 no_console_suspend;
>  static u8 uart_debug;
>  
>  #define DEFAULT_RXDMA_POLLRATE		1	/* RX DMA polling rate (us) */
> @@ -207,9 +206,6 @@ static int __init omap_serial_early_init(void)
>  					uart_name, uart->num);
>  			}
>  
> -			if (cmdline_find_option("no_console_suspend"))
> -				no_console_suspend = true;
> -
>  			/*
>  			 * omap-uart can be used for earlyprintk logs
>  			 * So if omap-uart is used as console then prevent
> @@ -292,9 +288,6 @@ void __init omap_serial_init_port(struct omap_board_data *bdata,
>  		return;
>  	}
>  
> -	if ((console_uart_id == bdata->id) && no_console_suspend)
> -		omap_device_disable_idle_on_suspend(pdev);
> -
>  	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
>  
>  	if (console_uart_id == bdata->id) {
