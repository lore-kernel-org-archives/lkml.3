Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbbAHK4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:56:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:35981 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbbAHK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:56:04 -0500
Message-ID: <54AE623E.5020507@atmel.com>
Date: Thu, 8 Jan 2015 11:55:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/at91_ether: prepare and unprepare clock
References: <1420671566-30784-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1420671566-30784-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/01/2015 23:59, Alexandre Belloni a écrit :
> The clock is enabled without being prepared, this leads to:
> 
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:889 __clk_enable+0x24/0xa8()
> 
> and a non working ethernet interface.
> 
> Use clk_prepare_enable() and clk_disable_unprepare() to handle the clock.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/net/ethernet/cadence/at91_ether.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
> index 55eb7f2af2b4..7ef55f5fa664 100644
> --- a/drivers/net/ethernet/cadence/at91_ether.c
> +++ b/drivers/net/ethernet/cadence/at91_ether.c
> @@ -340,7 +340,7 @@ static int __init at91ether_probe(struct platform_device *pdev)
>  		res = PTR_ERR(lp->pclk);
>  		goto err_free_dev;
>  	}
> -	clk_enable(lp->pclk);
> +	clk_prepare_enable(lp->pclk);
>  
>  	lp->hclk = ERR_PTR(-ENOENT);
>  	lp->tx_clk = ERR_PTR(-ENOENT);
> @@ -406,7 +406,7 @@ static int __init at91ether_probe(struct platform_device *pdev)
>  err_out_unregister_netdev:
>  	unregister_netdev(dev);
>  err_disable_clock:
> -	clk_disable(lp->pclk);
> +	clk_disable_unprepare(lp->pclk);
>  err_free_dev:
>  	free_netdev(dev);
>  	return res;
> @@ -424,7 +424,7 @@ static int at91ether_remove(struct platform_device *pdev)
>  	kfree(lp->mii_bus->irq);
>  	mdiobus_free(lp->mii_bus);
>  	unregister_netdev(dev);
> -	clk_disable(lp->pclk);
> +	clk_disable_unprepare(lp->pclk);
>  	free_netdev(dev);
>  
>  	return 0;
> @@ -440,7 +440,7 @@ static int at91ether_suspend(struct platform_device *pdev, pm_message_t mesg)
>  		netif_stop_queue(net_dev);
>  		netif_device_detach(net_dev);
>  
> -		clk_disable(lp->pclk);
> +		clk_disable_unprepare(lp->pclk);
>  	}
>  	return 0;
>  }
> @@ -451,7 +451,7 @@ static int at91ether_resume(struct platform_device *pdev)
>  	struct macb *lp = netdev_priv(net_dev);
>  
>  	if (netif_running(net_dev)) {
> -		clk_enable(lp->pclk);
> +		clk_prepare_enable(lp->pclk);
>  
>  		netif_device_attach(net_dev);
>  		netif_start_queue(net_dev);
> 


-- 
Nicolas Ferre
