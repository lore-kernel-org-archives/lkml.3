Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3FTHn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:43:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:21953 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3FTHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:43:57 -0400
Message-ID: <51C2B2B8.2040104@atmel.com>
Date: Thu, 20 Jun 2013 09:43:52 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Dan Williams <djbw@fb.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] at_hdmac: prepare clk before calling enable
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com> <1371640494-9472-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1371640494-9472-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/2013 13:14, Boris BREZILLON :
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

BTW Vinod, it seems that we have several slave-dma patches pending: do 
you want me to collect them and send you a pull-request for 3.11?

Best regards,

> ---
>   drivers/dma/at_hdmac.c |   17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index e923cda..19a484a 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1374,7 +1374,9 @@ static int __init at_dma_probe(struct platform_device *pdev)
>   		err = PTR_ERR(atdma->clk);
>   		goto err_clk;
>   	}
> -	clk_enable(atdma->clk);
> +	err = clk_prepare_enable(atdma->clk);
> +	if (err)
> +		goto err_clk_prepare;
>
>   	/* force dma off, just in case */
>   	at_dma_off(atdma);
> @@ -1475,7 +1477,8 @@ err_pool_create:
>   	platform_set_drvdata(pdev, NULL);
>   	free_irq(platform_get_irq(pdev, 0), atdma);
>   err_irq:
> -	clk_disable(atdma->clk);
> +	clk_disable_unprepare(atdma->clk);
> +err_clk_prepare:
>   	clk_put(atdma->clk);
>   err_clk:
>   	iounmap(atdma->regs);
> @@ -1512,7 +1515,7 @@ static int at_dma_remove(struct platform_device *pdev)
>   		list_del(&chan->device_node);
>   	}
>
> -	clk_disable(atdma->clk);
> +	clk_disable_unprepare(atdma->clk);
>   	clk_put(atdma->clk);
>
>   	iounmap(atdma->regs);
> @@ -1531,7 +1534,7 @@ static void at_dma_shutdown(struct platform_device *pdev)
>   	struct at_dma	*atdma = platform_get_drvdata(pdev);
>
>   	at_dma_off(platform_get_drvdata(pdev));
> -	clk_disable(atdma->clk);
> +	clk_disable_unprepare(atdma->clk);
>   }
>
>   static int at_dma_prepare(struct device *dev)
> @@ -1588,7 +1591,7 @@ static int at_dma_suspend_noirq(struct device *dev)
>
>   	/* disable DMA controller */
>   	at_dma_off(atdma);
> -	clk_disable(atdma->clk);
> +	clk_disable_unprepare(atdma->clk);
>   	return 0;
>   }
>
> @@ -1618,7 +1621,9 @@ static int at_dma_resume_noirq(struct device *dev)
>   	struct dma_chan *chan, *_chan;
>
>   	/* bring back DMA controller */
> -	clk_enable(atdma->clk);
> +	err = clk_prepare_enable(atdma->clk);
> +	if (err)
> +		return err;
>   	dma_writel(atdma, EN, AT_DMA_ENABLE);
>
>   	/* clear any pending interrupt */
>


-- 
Nicolas Ferre
