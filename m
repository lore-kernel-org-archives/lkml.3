Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaDUUAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:00:11 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59169 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaDUUAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:00:06 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arc_emac: write initial MAC address from devicetree to hw
Date: Mon, 21 Apr 2014 22:01:59 +0200
Message-ID: <1991077.DWMmAhPCQt@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1664530.jeK9vBIgft@typ>
References: <1664530.jeK9vBIgft@typ>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 18. April 2014, 02:17:32 schrieb Max Schwarz:
> The MAC address retrieved from dt was not actually written to the
> hardware. This meant proper communication was only possible after
> changing the MAC address.
> 
> Fix that by always writing the mac address during probing.
> 
> Signed-off-by: Max Schwarz <max.schwarz@online.de>
Acked-by: Heiko Stuebner <heiko@sntech.de>
On the same hardware (rk3188 radxa rock)
Tested-by: Heiko Stuebner <heiko@sntech.de>

> ---
> 
> I recently noticed this problem on the Radxa Rock board. I'm not
> sure how this has ever worked on other platforms, though. I can
> only receive broadcast packets without configuring the address.
> 
> Running ifconfig eth0 hw ether XYZ or applying the patch fixes
> the problem for me.
> 
> CCing Heiko Stübner because he has seen the problem as well.
> 
>  drivers/net/ethernet/arc/emac_main.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/arc/emac_main.c
> b/drivers/net/ethernet/arc/emac_main.c index eeecc29..9f45782 100644
> --- a/drivers/net/ethernet/arc/emac_main.c
> +++ b/drivers/net/ethernet/arc/emac_main.c
> @@ -574,6 +574,18 @@ static int arc_emac_tx(struct sk_buff *skb, struct
> net_device *ndev) return NETDEV_TX_OK;
>  }
> 
> +static void arc_emac_set_address_internal(struct net_device *ndev)
> +{
> +	struct arc_emac_priv *priv = netdev_priv(ndev);
> +	unsigned int addr_low, addr_hi;
> +
> +	addr_low = le32_to_cpu(*(__le32 *) &ndev->dev_addr[0]);
> +	addr_hi = le16_to_cpu(*(__le16 *) &ndev->dev_addr[4]);
> +
> +	arc_reg_set(priv, R_ADDRL, addr_low);
> +	arc_reg_set(priv, R_ADDRH, addr_hi);
> +}
> +
>  /**
>   * arc_emac_set_address - Set the MAC address for this device.
>   * @ndev:	Pointer to net_device structure.
> @@ -587,9 +599,7 @@ static int arc_emac_tx(struct sk_buff *skb, struct
> net_device *ndev) */
>  static int arc_emac_set_address(struct net_device *ndev, void *p)
>  {
> -	struct arc_emac_priv *priv = netdev_priv(ndev);
>  	struct sockaddr *addr = p;
> -	unsigned int addr_low, addr_hi;
> 
>  	if (netif_running(ndev))
>  		return -EBUSY;
> @@ -599,11 +609,7 @@ static int arc_emac_set_address(struct net_device
> *ndev, void *p)
> 
>  	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
> 
> -	addr_low = le32_to_cpu(*(__le32 *) &ndev->dev_addr[0]);
> -	addr_hi = le16_to_cpu(*(__le16 *) &ndev->dev_addr[4]);
> -
> -	arc_reg_set(priv, R_ADDRL, addr_low);
> -	arc_reg_set(priv, R_ADDRH, addr_hi);
> +	arc_emac_set_address_internal(ndev);
> 
>  	return 0;
>  }
> @@ -713,6 +719,7 @@ static int arc_emac_probe(struct platform_device *pdev)
>  	else
>  		eth_hw_addr_random(ndev);
> 
> +	arc_emac_set_address_internal(ndev);
>  	dev_info(&pdev->dev, "MAC address is now %pM\n", ndev->dev_addr);
> 
>  	/* Do 1 allocation instead of 2 separate ones for Rx and Tx BD rings */

