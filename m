Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaL1Vvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 16:51:40 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54425 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaL1Vvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 16:51:36 -0500
Date: Sun, 28 Dec 2014 22:52:00 +0100
From: Olivier Sobrie <olivier@sobrie.be>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux-stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] can: kvaser_usb: Don't free packets when tight on
 URBs
Message-ID: <20141228215200.GB2548@thinkoso.home>
Reply-To: Olivier Sobrie <olivier@sobrie.be>
References: <20141223154654.GB6460@vivalin-002>
 <20141224235644.GA3778@vivalin-002>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141224235644.GA3778@vivalin-002>
X-PGP-Key: http://olivier.sobrie.be/pgp/public.key
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 01:56:44AM +0200, Ahmed S. Darwish wrote:
> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> 
> Flooding the Kvaser CAN to USB dongle with multiple reads and
> writes in high frequency caused seemingly-random panics in the
> kernel.
> 
> On further inspection, it seems the driver erroneously freed the
> to-be-transmitted packet upon getting tight on URBs and returning
> NETDEV_TX_BUSY, leading to invalid memory writes and double frees
> at a later point in time.
> 
> Note:
> 
> Finding no more URBs/transmit-contexts and returning NETDEV_TX_BUSY
> is a driver bug in and out of itself: it means that our start/stop
> queue flow control is broken.
> 
> This patch only fixes the (buggy) error handling code; the root
> cause shall be fixed in a later commit.
> 
> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>

Acked-by: Olivier Sobrie <olivier@sobrie.be>

> ---
>  drivers/net/can/usb/kvaser_usb.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
>  (Marc, Greg, I believe this should also be added to -stable?)
> 
> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> index 541fb7a..6479a2b 100644
> --- a/drivers/net/can/usb/kvaser_usb.c
> +++ b/drivers/net/can/usb/kvaser_usb.c
> @@ -1294,12 +1294,14 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
>  	if (!urb) {
>  		netdev_err(netdev, "No memory left for URBs\n");
>  		stats->tx_dropped++;
> -		goto nourbmem;
> +		dev_kfree_skb(skb);
> +		return NETDEV_TX_OK;
>  	}
>  
>  	buf = kmalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
>  	if (!buf) {
>  		stats->tx_dropped++;
> +		dev_kfree_skb(skb);
>  		goto nobufmem;
>  	}
>  
> @@ -1334,6 +1336,9 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
>  		}
>  	}
>  
> +	/*
> +	 * This should never happen; it implies a flow control bug.
> +	 */
>  	if (!context) {
>  		netdev_warn(netdev, "cannot find free context\n");
>  		ret =  NETDEV_TX_BUSY;
> @@ -1364,9 +1369,6 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
>  	if (unlikely(err)) {
>  		can_free_echo_skb(netdev, context->echo_index);
>  
> -		skb = NULL; /* set to NULL to avoid double free in
> -			     * dev_kfree_skb(skb) */
> -
>  		atomic_dec(&priv->active_tx_urbs);
>  		usb_unanchor_urb(urb);
>  
> @@ -1388,8 +1390,6 @@ releasebuf:
>  	kfree(buf);
>  nobufmem:
>  	usb_free_urb(urb);
> -nourbmem:
> -	dev_kfree_skb(skb);
>  	return ret;
>  }
>  

-- 
Olivier
