Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3DKNO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:14:29 -0400
Received: from 1wt.eu ([62.212.114.60]:32786 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3DKNO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:14:27 -0400
Date: Thu, 11 Apr 2013 15:13:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Soeren Moch <smoch@web.de>, Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org,
        Dale Farnsworth <dale@farnsworth.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Florian Fainelli <florian@openwrt.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
Message-ID: <20130411131333.GD1910@1wt.eu>
References: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 11, 2013 at 02:40:23PM +0200, Sebastian Hesselbarth wrote:
> This patch adds GRO support to mv643xx_eth by making it invoke
> napi_gro_receive instead of netif_receive_skb.
> 
> Signed-off-by: Soeren Moch <smoch@web.de>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Dale Farnsworth <dale@farnsworth.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 305038f..c850d04 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -604,7 +604,7 @@ static int rxq_process(struct rx_queue *rxq, int budget)
>  			lro_receive_skb(&rxq->lro_mgr, skb, (void *)cmd_sts);
>  			lro_flush_needed = 1;
>  		} else
> -			netif_receive_skb(skb);
> +			napi_gro_receive(&mp->napi, skb);
>  
>  		continue;

I remember having experimented with this on 3.6 a few months ago with this
driver and finally switching back to something like this instead which
showed better performance on my tests :

               if (skb->ip_summed == CHECKSUM_UNNECESSARY)
                       napi_gro_receive(napi, skb);
               else
                       netif_receive_skb(skb);

Unfortunately I don't have more details as my commit message was rather
short due to this resulting from experimentation. Did you verify that
you did not lose any performance in various workloads ? I was playing
with bridges at this time, it's possible that I got better performance
on bridging with netif_receive_skb() than with napi_gro_receive().

Regards,
Willy

