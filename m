Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3GVRIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:08:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61837 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3GVRIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:08:02 -0400
Message-ID: <1374512879.4990.19.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Eric Dumazet <eric.dumazet@gmail.com>
To: freddy@asix.com.tw
Cc: davem@davemloft.net, netdev@vger.kernel.org, grundler@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        louis@asix.com.tw, allan@asix.com.tw
Date: Mon, 22 Jul 2013 10:07:59 -0700
In-Reply-To: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-20 at 17:16 +0800, freddy@asix.com.tw wrote:
> From: Freddy Xin <freddy@asix.com.tw>
> 
> Disable TSO and SG network features in reset() and bind() functions,
> and check the return value of skb_linearize() in tx_fixup() to prevent
> TX throttling.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
> ---
>  drivers/net/usb/ax88179_178a.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index 1e3c302..eb71331 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1029,7 +1029,7 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
>  	dev->mii.supports_gmii = 1;
>  
>  	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
> -			      NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
> +			      NETIF_F_RXCSUM;
>  
>  	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
>  				 NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
> @@ -1173,7 +1173,9 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
>  	if (((skb->len + 8) % frame_size) == 0)
>  		tx_hdr2 |= 0x80008000;	/* Enable padding */
>  
> -	skb_linearize(skb);
> +	if (skb_linearize(skb))
> +		return NULL;
> +
>  	

I guess that if a driver does not advertise NETIF_F_SG, this
skb_linearize() call is not needed : All frames reaching your xmit
function should already be linear

Thanks


