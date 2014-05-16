Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaEPH05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:26:57 -0400
Received: from sym2.noone.org ([178.63.92.236]:56647 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbaEPH0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:26:55 -0400
Date: Fri, 16 May 2014 09:26:54 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        himangi774@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging/wlan-ng: code refactoring
Message-ID: <20140516072653.GA14932@distanz.ch>
References: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
 <1399908167-19271-3-git-send-email-denis.pithon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399908167-19271-3-git-send-email-denis.pithon@gmail.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-12 at 17:22:46 +0200, Denis Pithon <denis.pithon@gmail.com> wrote:
> Extract new static function from p80211netdev_rx_bh() to fix coding
> style issue (too many leading tabs).
> 
> Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
> ---
>  drivers/staging/wlan-ng/p80211netdev.c | 74 ++++++++++++++++++++--------------
>  1 file changed, 43 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
> index 2da3cbb..61a3092 100644
> --- a/drivers/staging/wlan-ng/p80211netdev.c
> +++ b/drivers/staging/wlan-ng/p80211netdev.c
> @@ -240,6 +240,48 @@ void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb)
>  	tasklet_schedule(&wlandev->rx_bh);
>  }
>  
> +#define CONV_TO_ETHER_SKIPPED	0x01
> +#define CONV_TO_ETHER_FAILED	0x02
> +
> +/**
> + * convert_frame_to_ether - conversion from 802.11 frame to ethernet frame
> + * @wlandev: pointer to WLAN device
> + * @skb: pointer to socket buffer
> + *
> + * Returns: 0 if conversion succeeded
> + *	    CONV_TO_ETHER_FAILED if conversion failed
> + *	    CONV_TO_ETHER_SKIPPED if frame is ignored
> + */
> +static int convert_frame_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)

You should probably add a module/driver specific prefix to the function
name here, to stay consistent with the other functions in the module,
e.g. p80211_convert_frame_to_ether()

> +{
> +	struct p80211_hdr_a3 *hdr;
> +
> +	hdr = (struct p80211_hdr_a3 *) skb->data;
> +	if (p80211_rx_typedrop(wlandev, hdr->fc))
> +		return CONV_TO_ETHER_SKIPPED;
> +
> +	/* perform mcast filtering */
> +	if (wlandev->netdev->flags & IFF_ALLMULTI) {
> +		/* allow my local address through */
> +		if (memcmp(hdr->a1, wlandev->netdev->dev_addr, ETH_ALEN) != 0) {

While at it, you could use one of the ether_addr_equal* functions here
(depending on the address alignment).

> +			/* but reject anything else that isn't multicast */
> +			if (!(hdr->a1[0] & 0x01))
> +				return CONV_TO_ETHER_SKIPPED;

And here you could use !is_multicast_ether_addr() instead of open coding
it.

> +		}
> +	}
> +
> +	if (skb_p80211_to_ether(wlandev, wlandev->ethconv, skb) == 0) {
> +		skb->dev->last_rx = jiffies;
> +		wlandev->linux_stats.rx_packets++;
> +		wlandev->linux_stats.rx_bytes += skb->len;
> +		netif_rx_ni(skb);
> +		return 0;
> +	}
> +
> +	pr_debug("p80211_to_ether failed.\n");
> +	return CONV_TO_ETHER_FAILED;
> +}
> +
>  /**
>   * p80211netdev_rx_bh - deferred processing of all received frames
>   *
> @@ -250,7 +292,6 @@ static void p80211netdev_rx_bh(unsigned long arg)
>  	wlandevice_t *wlandev = (wlandevice_t *) arg;
>  	struct sk_buff *skb = NULL;
>  	netdevice_t *dev = wlandev->netdev;
> -	struct p80211_hdr_a3 *hdr;
>  
>  	/* Let's empty our our queue */
>  	while ((skb = skb_dequeue(&wlandev->nsd_rxq))) {
> @@ -273,37 +314,8 @@ static void p80211netdev_rx_bh(unsigned long arg)
>  				netif_rx_ni(skb);
>  				continue;
>  			} else {
> -				hdr = (struct p80211_hdr_a3 *) skb->data;
> -				if (p80211_rx_typedrop(wlandev, hdr->fc)) {
> -					dev_kfree_skb(skb);
> -					continue;
> -				}
> -
> -				/* perform mcast filtering */
> -				if (wlandev->netdev->flags & IFF_ALLMULTI) {
> -					/* allow my local address through */
> -					if (memcmp
> -					    (hdr->a1, wlandev->netdev->dev_addr,
> -					     ETH_ALEN) != 0) {
> -						/* but reject anything else that
> -						   isn't multicast */
> -						if (!(hdr->a1[0] & 0x01)) {
> -							dev_kfree_skb(skb);
> -							continue;
> -						}
> -					}
> -				}
> -
> -				if (skb_p80211_to_ether
> -				    (wlandev, wlandev->ethconv, skb) == 0) {
> -					skb->dev->last_rx = jiffies;
> -					wlandev->linux_stats.rx_packets++;
> -					wlandev->linux_stats.rx_bytes +=
> -					    skb->len;
> -					netif_rx_ni(skb);
> +				if (!convert_frame_to_ether(wlandev, skb))
>  					continue;
> -				}
> -				pr_debug("p80211_to_ether failed.\n");
>  			}
>  		}
>  		dev_kfree_skb(skb);
> -- 
> 1.8.1.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
