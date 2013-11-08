Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3KHTPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:15:08 -0500
Received: from void.printf.net ([89.145.121.20]:43460 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab3KHTPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:15:06 -0500
From: Chris Ball <cjb@laptop.org>
To: Alexey Neyman <stilor@att.net>
Cc: Dong Aisheng <dongas86@gmail.com>,
        linux-mmc@vger.kernel.org (open list:SECURE DIGITAL HO...),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] mmc: sdhci: Avoid needless loop while handling SDIO interrupts in sdhci_irq()
References: <CAA+hA=StthxfMWjQ+0fhdRiPuDDVWUGrrW9E71Q+E3RoF_QdHw@mail.gmail.com>
	<1383709236-26692-1-git-send-email-stilor@att.net>
Date: Fri, 08 Nov 2013 14:14:54 -0500
In-Reply-To: <1383709236-26692-1-git-send-email-stilor@att.net> (Alexey
	Neyman's message of "Tue, 5 Nov 2013 19:40:36 -0800")
Message-ID: <87y54ywvrl.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Tue, Nov 05 2013, Alexey Neyman wrote:
> Ignore Card Interrupt bit in the interrupt status if we already know that
> mmc_signal_sdio_irq() is going to be called at the end of sdhci_irq(). This
> avoids a needless loop in sdhci_irq() repeatedly reading interrupt status
> and doing nothing.
>
> Signed-off-by: Alexey Neyman <stilor@att.net>
> Acked-by: Dong Aisheng <b29396@freescale.com>
> ---
>  drivers/mmc/host/sdhci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7a7fb4f..a83cd1b 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2491,6 +2491,14 @@ again:
>  	result = IRQ_HANDLED;
>  
>  	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> +
> +	/*
> +	 * If we know we'll call the driver to signal SDIO IRQ, disregard
> +	 * further indications of Card Interrupt in the status to avoid a
> +	 * needless loop.
> +	 */
> +	if (cardint)
> +		intmask &= ~SDHCI_INT_CARD_INT;
>  	if (intmask && --max_loops)
>  		goto again;
>  out:

Thanks, pushed to mmc-next for 3.13.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
