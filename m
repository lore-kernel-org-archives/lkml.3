Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaIWMn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:43:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:26579 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIWMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:43:56 -0400
Date: Tue, 23 Sep 2014 14:43:58 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mmc: atmel-mci: Release mmc resources on failure
 in probe
Message-ID: <20140923124358.GB586@ldesroches-Latitude-E6320>
Mail-Followup-To: Pramod Gurav <pramod.gurav@smartplayin.com>,
	linux-kernel@vger.kernel.org, Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
References: <1411467606-13041-1-git-send-email-pramod.gurav@smartplayin.com>
 <1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411467606-13041-2-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:50:06PM +0530, Pramod Gurav wrote:
> This change takes care of releasing mmc resources on error cases in
> probe function which was missing. Also release timer in remove function.
> 

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
> Changes since v1: None
> 
>  drivers/mmc/host/atmel-mci.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 36212fb..288bcc1 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -2376,7 +2376,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>  	struct resource			*regs;
>  	unsigned int			nr_slots;
>  	int				irq;
> -	int				ret;
> +	int				ret, i;
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!regs)
> @@ -2482,7 +2482,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>  		if (!host->buffer) {
>  			ret = -ENOMEM;
>  			dev_err(&pdev->dev, "buffer allocation failed\n");
> -			goto err_init_slot;
> +			goto err_dma_alloc;
>  		}
>  	}
>  
> @@ -2492,7 +2492,13 @@ static int __init atmci_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> +err_dma_alloc:
> +	for (i = 0; i < ATMCI_MAX_NR_SLOTS; i++) {
> +		if (host->slot[i])
> +			atmci_cleanup_slot(host->slot[i], i);
> +	}
>  err_init_slot:
> +	del_timer_sync(&host->timer);
>  	if (host->dma.chan)
>  		dma_release_channel(host->dma.chan);
>  	free_irq(irq, host);
> @@ -2519,6 +2525,7 @@ static int __exit atmci_remove(struct platform_device *pdev)
>  	atmci_readl(host, ATMCI_SR);
>  	clk_disable_unprepare(host->mck);
>  
> +	del_timer_sync(&host->timer);
>  	if (host->dma.chan)
>  		dma_release_channel(host->dma.chan);
>  
> -- 
> 1.7.9.5
> 
