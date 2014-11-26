Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaKZQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:52:33 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38563 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaKZQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:52:30 -0500
Message-ID: <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] r8152: drop the tx packet with invalid length
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Wed, 26 Nov 2014 08:52:28 -0800
In-Reply-To: <1394712342-15778-104-Taiwan-albertk@realtek.com>
References: <1394712342-15778-104-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 17:56 +0800, Hayes Wang wrote:
> Drop the tx packet which is more than the size of agg_buf_sz. When
> creating a bridge with the device, we may get the tx packet with
> TSO and the length is more than the gso_max_size which is set by
> the driver through netif_set_gso_max_size(). Such packets couldn't
> be transmitted and should be dropped directly.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c6554c7..ebdaff7 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1897,6 +1897,15 @@ static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
>  {
>  	struct r8152 *tp = netdev_priv(netdev);
>  
> +	if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz) {
> +		struct net_device_stats *stats = &netdev->stats;
> +
> +		dev_kfree_skb_any(skb);
> +		stats->tx_dropped++;
> +		WARN_ON_ONCE(1);
> +		return NETDEV_TX_OK;
> +	}
> +
>  	skb_tx_timestamp(skb);
>  
>  	skb_queue_tail(&tp->tx_queue, skb);

Looks like a candidate for ndo_gso_check(), so that we do not drop, but
instead segment from netif_needs_gso()/validate_xmit_skb()



