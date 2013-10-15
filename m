Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3JOHok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:44:40 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20788 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3JOHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:44:39 -0400
Message-ID: <525CF265.20506@atmel.com>
Date: Tue, 15 Oct 2013 09:44:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 2/5] net: macb: Migrate to devm clock interface
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381795140-10792-3-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2013 01:58, Soren Brinkmann :
> Migrate to using the device managed intreface for clocks and clean up
> the associated error paths.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/net/ethernet/cadence/macb.c | 32 ++++++++++++++++++++------------
>   1 file changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 389ccf1362d5..62aa136889a4 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1790,19 +1790,31 @@ static int __init macb_probe(struct platform_device *pdev)
>   	spin_lock_init(&bp->lock);
>   	INIT_WORK(&bp->tx_error_task, macb_tx_error_task);
>
> -	bp->pclk = clk_get(&pdev->dev, "pclk");
> +	bp->pclk = devm_clk_get(&pdev->dev, "pclk");
>   	if (IS_ERR(bp->pclk)) {
> -		dev_err(&pdev->dev, "failed to get macb_clk\n");
> +		err = PTR_ERR(bp->pclk);
> +		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
>   		goto err_out_free_dev;
>   	}
> -	clk_prepare_enable(bp->pclk);
>
> -	bp->hclk = clk_get(&pdev->dev, "hclk");
> +	bp->hclk = devm_clk_get(&pdev->dev, "hclk");
>   	if (IS_ERR(bp->hclk)) {
> -		dev_err(&pdev->dev, "failed to get hclk\n");
> -		goto err_out_put_pclk;
> +		err = PTR_ERR(bp->hclk);
> +		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
> +		goto err_out_free_dev;
> +	}
> +
> +	err = clk_prepare_enable(bp->pclk);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
> +		goto err_out_free_dev;
> +	}
> +
> +	err = clk_prepare_enable(bp->hclk);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to enable hclk (%u)\n", err);
> +		goto err_out_disable_pclk;
>   	}
> -	clk_prepare_enable(bp->hclk);
>
>   	bp->regs = ioremap(regs->start, resource_size(regs));
>   	if (!bp->regs) {
> @@ -1908,10 +1920,8 @@ err_out_iounmap:
>   	iounmap(bp->regs);
>   err_out_disable_clocks:
>   	clk_disable_unprepare(bp->hclk);
> -	clk_put(bp->hclk);
> +err_out_disable_pclk:
>   	clk_disable_unprepare(bp->pclk);
> -err_out_put_pclk:
> -	clk_put(bp->pclk);
>   err_out_free_dev:
>   	free_netdev(dev);
>   err_out:
> @@ -1936,9 +1946,7 @@ static int __exit macb_remove(struct platform_device *pdev)
>   		free_irq(dev->irq, dev);
>   		iounmap(bp->regs);
>   		clk_disable_unprepare(bp->hclk);
> -		clk_put(bp->hclk);
>   		clk_disable_unprepare(bp->pclk);
> -		clk_put(bp->pclk);
>   		free_netdev(dev);
>   	}
>
>


-- 
Nicolas Ferre
