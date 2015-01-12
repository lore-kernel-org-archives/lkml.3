Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbALLIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:08:23 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52710 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbbALLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:08:20 -0500
Date: Mon, 12 Jan 2015 12:08:18 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/at91_ether: prepare and unprepare clock
Message-ID: <20150112110818.GJ2447@piout.net>
References: <1420671566-30784-1-git-send-email-alexandre.belloni@free-electrons.com>
 <54AE623E.5020507@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54AE623E.5020507@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

This is actually a fix for 3.19, can you take it for the next rc ?

Thanks!

On 08/01/2015 at 11:55:58 +0100, Nicolas Ferre wrote :
> Le 07/01/2015 23:59, Alexandre Belloni a écrit :
> > The clock is enabled without being prepared, this leads to:
> > 
> > WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:889 __clk_enable+0x24/0xa8()
> > 
> > and a non working ethernet interface.
> > 
> > Use clk_prepare_enable() and clk_disable_unprepare() to handle the clock.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> > ---
> >  drivers/net/ethernet/cadence/at91_ether.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
> > index 55eb7f2af2b4..7ef55f5fa664 100644
> > --- a/drivers/net/ethernet/cadence/at91_ether.c
> > +++ b/drivers/net/ethernet/cadence/at91_ether.c
> > @@ -340,7 +340,7 @@ static int __init at91ether_probe(struct platform_device *pdev)
> >  		res = PTR_ERR(lp->pclk);
> >  		goto err_free_dev;
> >  	}
> > -	clk_enable(lp->pclk);
> > +	clk_prepare_enable(lp->pclk);
> >  
> >  	lp->hclk = ERR_PTR(-ENOENT);
> >  	lp->tx_clk = ERR_PTR(-ENOENT);
> > @@ -406,7 +406,7 @@ static int __init at91ether_probe(struct platform_device *pdev)
> >  err_out_unregister_netdev:
> >  	unregister_netdev(dev);
> >  err_disable_clock:
> > -	clk_disable(lp->pclk);
> > +	clk_disable_unprepare(lp->pclk);
> >  err_free_dev:
> >  	free_netdev(dev);
> >  	return res;
> > @@ -424,7 +424,7 @@ static int at91ether_remove(struct platform_device *pdev)
> >  	kfree(lp->mii_bus->irq);
> >  	mdiobus_free(lp->mii_bus);
> >  	unregister_netdev(dev);
> > -	clk_disable(lp->pclk);
> > +	clk_disable_unprepare(lp->pclk);
> >  	free_netdev(dev);
> >  
> >  	return 0;
> > @@ -440,7 +440,7 @@ static int at91ether_suspend(struct platform_device *pdev, pm_message_t mesg)
> >  		netif_stop_queue(net_dev);
> >  		netif_device_detach(net_dev);
> >  
> > -		clk_disable(lp->pclk);
> > +		clk_disable_unprepare(lp->pclk);
> >  	}
> >  	return 0;
> >  }
> > @@ -451,7 +451,7 @@ static int at91ether_resume(struct platform_device *pdev)
> >  	struct macb *lp = netdev_priv(net_dev);
> >  
> >  	if (netif_running(net_dev)) {
> > -		clk_enable(lp->pclk);
> > +		clk_prepare_enable(lp->pclk);
> >  
> >  		netif_device_attach(net_dev);
> >  		netif_start_queue(net_dev);
> > 
> 
> 
> -- 
> Nicolas Ferre

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
