Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3LJIoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:44:16 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64988 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3LJIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:44:14 -0500
Message-ID: <52A6D44C.1010504@gmail.com>
Date: Tue, 10 Dec 2013 16:43:56 +0800
From: Haojian Zhuang <haojian.zhuang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Daniel Mack <zonque@gmail.com>, Marek Vasut <marex@denx.de>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH] ARM: pxa: prevent PXA270 occasional reboot freezes
References: <1386650355-2503-1-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386650355-2503-1-git-send-email-ynvich@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 12:39 PM, Sergei Ianovich wrote:
> Erratum 71 of PXA270M Processor Family Specification Update
> (April 19, 2010) explains that watchdog reset time is just
> 8us insead of 10ms in EMTS.
>
> If SDRAM is not reset, it causes memory bus congestion and
> the device hangs. We put SDRAM in selfresh mode before watchdog
> reset, removing potential freezes.
>
> Without this patch PXA270-based ICP DAS LP-8x4x hangs after up to 40
> reboots. With this patch it has successfully rebooted 500 times.
>
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> ---
>   arch/arm/mach-pxa/reset.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
> index 0d5dd64..263b152 100644
> --- a/arch/arm/mach-pxa/reset.c
> +++ b/arch/arm/mach-pxa/reset.c
> @@ -13,6 +13,7 @@
>
>   #include <mach/regs-ost.h>
>   #include <mach/reset.h>
> +#include <mach/smemc.h>
>
>   unsigned int reset_status;
>   EXPORT_SYMBOL(reset_status);
> @@ -81,6 +82,12 @@ static void do_hw_reset(void)
>   	writel_relaxed(OSSR_M3, OSSR);
>   	/* ... in 100 ms */
>   	writel_relaxed(readl_relaxed(OSCR) + 368640, OSMR3);
> +	/*
> +	 * SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71)
> +	 * we put SDRAM into self-refresh to prevent that
> +	 */
> +	while (1)
> +		writel_relaxed(MDREFR_SLFRSH, MDREFR);
>   }
>
>   void pxa_restart(enum reboot_mode mode, const char *cmd)
> @@ -104,4 +111,3 @@ void pxa_restart(enum reboot_mode mode, const char *cmd)
>   		break;
>   	}
>   }
> -
>

Hi Daniel/Marek/Igor,

Could you help to try this patch? I'm lack of PXA27x board.

Best Regards
Haojian
