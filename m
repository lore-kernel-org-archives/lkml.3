Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3JOHpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:45:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54163 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3JOHp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:45:29 -0400
Message-ID: <525CF298.9050400@atmel.com>
Date: Tue, 15 Oct 2013 09:45:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 3/5] net: macb: Use devm_ioremap()
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-4-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381795140-10792-4-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2013 01:58, Soren Brinkmann :
> Use the device managed version of ioremap to remap IO memory,
> simplifying error paths.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/net/ethernet/cadence/macb.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 62aa136889a4..436aecc31732 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -17,6 +17,7 @@
>   #include <linux/circ_buf.h>
>   #include <linux/slab.h>
>   #include <linux/init.h>
> +#include <linux/io.h>
>   #include <linux/gpio.h>
>   #include <linux/interrupt.h>
>   #include <linux/netdevice.h>
> @@ -1816,7 +1817,7 @@ static int __init macb_probe(struct platform_device *pdev)
>   		goto err_out_disable_pclk;
>   	}
>
> -	bp->regs = ioremap(regs->start, resource_size(regs));
> +	bp->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
>   	if (!bp->regs) {
>   		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
>   		err = -ENOMEM;
> @@ -1828,7 +1829,7 @@ static int __init macb_probe(struct platform_device *pdev)
>   	if (err) {
>   		dev_err(&pdev->dev, "Unable to request IRQ %d (error %d)\n",
>   			dev->irq, err);
> -		goto err_out_iounmap;
> +		goto err_out_disable_clocks;
>   	}
>
>   	dev->netdev_ops = &macb_netdev_ops;
> @@ -1916,8 +1917,6 @@ err_out_unregister_netdev:
>   	unregister_netdev(dev);
>   err_out_free_irq:
>   	free_irq(dev->irq, dev);
> -err_out_iounmap:
> -	iounmap(bp->regs);
>   err_out_disable_clocks:
>   	clk_disable_unprepare(bp->hclk);
>   err_out_disable_pclk:
> @@ -1944,7 +1943,6 @@ static int __exit macb_remove(struct platform_device *pdev)
>   		mdiobus_free(bp->mii_bus);
>   		unregister_netdev(dev);
>   		free_irq(dev->irq, dev);
> -		iounmap(bp->regs);
>   		clk_disable_unprepare(bp->hclk);
>   		clk_disable_unprepare(bp->pclk);
>   		free_netdev(dev);
>


-- 
Nicolas Ferre
