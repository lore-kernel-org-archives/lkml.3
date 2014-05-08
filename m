Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaEHPzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:55:19 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42320 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaEHPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:55:18 -0400
Date: Thu, 8 May 2014 17:54:55 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Message-ID: <20140508155455.GB6776@localhost>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the resend -- forgot to add Doug as CC. ]

On Wed, May 07, 2014 at 06:20:49PM +0200, Boris BREZILLON wrote:
> The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
> mask all interrupts no matter what IMR claims about already masked irqs.

Crap, I totally forgot about this. Doug reported the problem off-list
back in December, but it got lost somehow. Sorry.

> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello Bryan,
> 
> Yet another patch for you ;-).
> 
> As usual, could you tell me if it fixes your bug.
> 
> BTW, thanks for your tests.
> 
> Best Regards,
> 
> Boris
> 
>  arch/arm/mach-at91/sysirq_mask.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
> index 2ba694f..eb3d2a5 100644
> --- a/arch/arm/mach-at91/sysirq_mask.c
> +++ b/arch/arm/mach-at91/sysirq_mask.c
> @@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
>  	if (!base)
>  		return;
>  
> -	mask = readl_relaxed(base + AT91_RTC_IMR);
> -	if (mask) {
> -		pr_info("AT91: Disabling rtc irq\n");
> -		writel_relaxed(mask, base + AT91_RTC_IDR);
> -		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
> -	}
> +	writel_relaxed(0x1f, base + AT91_RTC_IDR);

I believe this is the right way to handle this hardware bug (IMR is
always read as 0 on one particular SoC), but please document this in a
comment.

You should also keep the flush (read of IMR) regardless (to make sure
the write has reached the peripheral), and remember to remove the now
unused mask variable.

>  	iounmap(base);
>  }

Thanks,
Johan
