Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3JINE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:04:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12003 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3JINEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:04:24 -0400
Message-ID: <52555455.7080605@atmel.com>
Date: Wed, 9 Oct 2013 15:04:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] ARM: at91: prepare sama5 dt boards transition to
 common clk
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com> <1375953654-11168-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375953654-11168-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 11:20, Boris BREZILLON :
> This patch prepare the transition to common clk for sama5 dt boards by
> replacing the timer init callback.
>
> Clocks registration cannot be done in early init callback (as formerly done
> by the old clk implementation) because it requires dynamic allocation
> which is not ready yet during early init.
>
> In the other hand, at91 clocks must be registered before
> at91sam926x_pit_init is called because PIT (Periodic Interval Timer) driver
> request the master clk (mck).
>
> A new function (at91sama5_dt_timer_init) is created to fullfil these needs.
> This function registers all at91 clks using the dt definition before
> calling the PIT init function.
> The device tree clock registration is enabled only if common clk is
> selected. Else the old clk registration is been done during
> at91_dt_initialize call.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/mach-at91/board-dt-sama5.c |   10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index ad95f6a..10b6913 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -16,6 +16,7 @@
>   #include <linux/of_irq.h>
>   #include <linux/of_platform.h>
>   #include <linux/phy.h>
> +#include <linux/clk-provider.h>
>
>   #include <asm/setup.h>
>   #include <asm/irq.h>
> @@ -26,6 +27,13 @@
>   #include "at91_aic.h"
>   #include "generic.h"
>
> +static void __init sama5_dt_timer_init(void)
> +{
> +#if defined(CONFIG_COMMON_CLK)
> +	of_clk_init(NULL);
> +#endif
> +	at91sam926x_pit_init();
> +}
>
>   static const struct of_device_id irq_of_match[] __initconst = {
>
> @@ -77,7 +85,7 @@ static const char *sama5_dt_board_compat[] __initdata = {
>
>   DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
>   	/* Maintainer: Atmel */
> -	.init_time	= at91sam926x_pit_init,
> +	.init_time	= sama5_dt_timer_init,
>   	.map_io		= at91_map_io,
>   	.handle_irq	= at91_aic5_handle_irq,
>   	.init_early	= at91_dt_initialize,
>


-- 
Nicolas Ferre
