Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3KRUBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:01:15 -0500
Received: from nm25-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.115.198]:42520
	"EHLO nm25-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab3KRUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:01:13 -0500
X-Yahoo-Newman-Id: 185968.81308.bm@smtp113.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QZ8dj3UVM1myn3LTtq6bgjS_rdkHi_QqK7htNALgeH.irwc
 nyBKhTjOVlHtGkt9mb98cHQL_xHLHGwRnBq5QU4p3GxYUCb7FtVJCrBwQwfc
 2UmMnxDDxG77BCTP1HM1k3MmHJN7AKYw9nhnpA48EQ5lGhS7RWqeKmfPfsii
 yCxdSP2MjCMMfJIbN7pevgYG0lgQb2KdLImuyqcGZTFWmJemOUfu9QOabwLV
 ptGb73aIOeD5sWDr2CAezuQTGSLeF.1g_V3_jIppMurJHamvp7nKnyGyq_Q0
 TBesg7lqRFT9059jXwGtEf73xX42rh_lbFFYfJyJqYaHFKlwFjESNp1uATIO
 KBuOT4uq79pYhfQI1u4jARvuRkxBDXk23IiLpP0Frhe6ZehPb4ng0iOLELmQ
 fxBoi9k21Eoil7ecRAm9BeXOwbqlzwXaWkW0G3QD_DIt4aV7FaRKKKGzHV9b
 za9qoLpKSfEH_7q66MlcxjS4qEcAxEZgidiHw6h7h0GXTYH71c05JH10Q9C2
 UUO4I1Dpxm.wSEJP5nv2cBfIpcQLJRBoMmt9Th1SaseTHOYzVmXM.DGo7gA-
 -
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp113.sbc.mail.ne1.yahoo.com with SMTP; 18 Nov 2013 20:01:12 +0000 UTC
From: Alexey Neyman <stilor@att.net>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Chris Ball <cjb@laptop.org>,
        "open list:SECURE DIGITAL HO..." <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci: Avoid needless loop while handling SDIO interrupts in sdhci_irq()
Date: Mon, 18 Nov 2013 12:01:11 -0800
Message-ID: <2863850.GcQ0l6lPBj@mistral>
User-Agent: KMail/4.11.2 (Linux/3.11.0-12-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1383709236-26692-1-git-send-email-stilor@att.net>
References: <CAA+hA=StthxfMWjQ+0fhdRiPuDDVWUGrrW9E71Q+E3RoF_QdHw@mail.gmail.com> <1383709236-26692-1-git-send-email-stilor@att.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[yet another patch ping]

On Tuesday, November 05, 2013 07:40:36 PM Alexey Neyman wrote:
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

