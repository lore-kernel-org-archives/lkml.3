Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3KFC4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:56:30 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36566 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3KFC42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:56:28 -0500
MIME-Version: 1.0
In-Reply-To: <1383681526-5316-1-git-send-email-stilor@att.net>
References: <CAA+hA=R=hZfr6Kx_5X8PQ1ck+1wD3C6LOiXyKNMN7yrqdA0YqA@mail.gmail.com>
	<1383681526-5316-1-git-send-email-stilor@att.net>
Date: Wed, 6 Nov 2013 10:56:27 +0800
Message-ID: <CAA+hA=StthxfMWjQ+0fhdRiPuDDVWUGrrW9E71Q+E3RoF_QdHw@mail.gmail.com>
Subject: Re: [PATCH] Avoid needless loop in sdhci_irq()
From: Dong Aisheng <dongas86@gmail.com>
To: Alexey Neyman <stilor@att.net>
Cc: Chris Ball <cjb@laptop.org>,
        "open list:SECURE DIGITAL HO..." <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 3:58 AM, Alexey Neyman <stilor@att.net> wrote:
> Ignore Card Interrupt bit in the interrupt status if we already know that
> mmc_signal_sdio_irq() is going to be called at the end of sdhci_irq(). This
> avoids a needless loop in sdhci_irq() repeatedly reading interrupt status
> and doing nothing.
>
> Signed-off-by: Alexey Neyman <stilor@att.net>

You need improve the patch title a bit, like:
mmc: sdhci: avoid needless loop for handle SDIO interrupts in sdhci_irq

Otherwise,
Acked-by: Dong Aisheng <b29396@freescale.com>

You could resend with my ack.

Regards
Dong Aisheng

> ---
>  drivers/mmc/host/sdhci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7a7fb4f..a83cd1b 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2491,6 +2491,14 @@ again:
>         result = IRQ_HANDLED;
>
>         intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> +
> +       /*
> +        * If we know we'll call the driver to signal SDIO IRQ, disregard
> +        * further indications of Card Interrupt in the status to avoid a
> +        * needless loop.
> +        */
> +       if (cardint)
> +               intmask &= ~SDHCI_INT_CARD_INT;
>         if (intmask && --max_loops)
>                 goto again;
>  out:
> --
> 1.8.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
