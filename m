Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaJ1TTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:19:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45870 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ1TTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:19:48 -0400
Message-ID: <544FEC39.4060903@gmail.com>
Date: Tue, 28 Oct 2014 12:19:21 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] net: dsa: Don't set skb->protocol on outgoing
 tagged packets
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net> <1414342365-27191-2-git-send-email-linux@roeck-us.net>
In-Reply-To: <1414342365-27191-2-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 09:52 AM, Guenter Roeck wrote:
> Setting skb->protocol to a private protocol type may result in warning
> messages such as
> 	e1000e 0000:00:19.0 em1: checksum_partial proto=dada!
> 
> This happens if the L3 protocol is IP or IPv6 and skb->ip_summed is set
> to CHECKSUM_PARTIAL. Looking through the code, it appears that changing
> skb->protocol for transmitted packets is not necessary and may actually
> be harmful. Drop it.

You could emphasize that overriding skb->protocol prevents purposely
unmodified (from a DSA perspective) network drivers from properly
setting up their transmit checksum offload pointers since they inspect
skb->protocol to setup the IPv4 header or IPv6 header pointers.

> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2:
> - No change
> 
>  net/dsa/tag_dsa.c     | 2 --
>  net/dsa/tag_edsa.c    | 2 --
>  net/dsa/tag_trailer.c | 2 --
>  3 files changed, 6 deletions(-)
> 
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index ce90c8b..2dab270 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -63,8 +63,6 @@ static netdev_tx_t dsa_xmit(struct sk_buff *skb, struct net_device *dev)
>  		dsa_header[3] = 0x00;
>  	}
>  
> -	skb->protocol = htons(ETH_P_DSA);
> -
>  	skb->dev = p->parent->dst->master_netdev;
>  	dev_queue_xmit(skb);
>  
> diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
> index 94fcce7..9aeda59 100644
> --- a/net/dsa/tag_edsa.c
> +++ b/net/dsa/tag_edsa.c
> @@ -76,8 +76,6 @@ static netdev_tx_t edsa_xmit(struct sk_buff *skb, struct net_device *dev)
>  		edsa_header[7] = 0x00;
>  	}
>  
> -	skb->protocol = htons(ETH_P_EDSA);
> -
>  	skb->dev = p->parent->dst->master_netdev;
>  	dev_queue_xmit(skb);
>  
> diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
> index 115fdca..e268f9d 100644
> --- a/net/dsa/tag_trailer.c
> +++ b/net/dsa/tag_trailer.c
> @@ -57,8 +57,6 @@ static netdev_tx_t trailer_xmit(struct sk_buff *skb, struct net_device *dev)
>  	trailer[2] = 0x10;
>  	trailer[3] = 0x00;
>  
> -	nskb->protocol = htons(ETH_P_TRAILER);
> -
>  	nskb->dev = p->parent->dst->master_netdev;
>  	dev_queue_xmit(nskb);
>  
> 

