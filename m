Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaGUELV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:11:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaGUELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:11:18 -0400
Date: Sun, 20 Jul 2014 21:11:17 -0700 (PDT)
Message-Id: <20140720.211117.1625702942607731036.davem@davemloft.net>
To: narmstrong@neotion.com
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: macb: Handle errors in RX path
From: David Miller <davem@davemloft.net>
In-Reply-To: <53C91658.208@neotion.com>
References: <53C91658.208@neotion.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:11:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Armstrong <narmstrong@neotion.com>
Date: Fri, 18 Jul 2014 14:43:04 +0200

> @@ -872,12 +890,22 @@ static int macb_poll(struct napi_struct *napi, int budget)
>  	status = macb_readl(bp, RSR);
>  	macb_writel(bp, RSR, status);
>  
> -	work_done = 0;
> +	work_done = -EIO;
>  
>  	netdev_vdbg(bp->dev, "poll: status = %08lx, budget = %d\n",
> -		   (unsigned long)status, budget);
> +			(unsigned long)status, budget);
> +
> +	if (status & (MACB_BIT(OVR) | MACB_BIT(BNA)) ||
> +	    !(status & MACB_BIT(REC))) {
> +		netdev_err(bp->dev, "RX error, status = %02lx\n",
> +			   (unsigned long)status);
> +		goto rx_out;
 ...
> @@ -892,7 +920,23 @@ static int macb_poll(struct napi_struct *napi, int budget)
>  		}
>  	}
>  
> -	/* TODO: Handle errors */
> +	return work_done;
> +
> +rx_out:
> +	/* In case of error, disable RX and reset
> +	 * the descriptor ring before re-enabling RX.
> +	 */
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) & ~MACB_BIT(RE));
> +
> +	bp->macbgem_ops.mog_init_rx_rings(bp);
> +	macb_writel(bp, RBQP, bp->rx_ring_dma);
> +
> +	/* Re-enable RX and get notified for new packets */
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE));
> +
> +	napi_complete(napi);
> +
> +	macb_writel(bp, IER, MACB_RX_INT_FLAGS);
>  
>  	return work_done;

Do not return negative error codes, as you will in this path due to the
work_done = -EIO initialization, from the NAPI poll method.

You must always return the amount of work you processed, which you can
force to zero on errors that caused the chip to be reset and you thus
want polling to force terminate.
