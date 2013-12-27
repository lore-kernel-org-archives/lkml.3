Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3L0DTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 22:19:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab3L0DTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 22:19:53 -0500
Message-ID: <52BCF1C3.8080702@redhat.com>
Date: Fri, 27 Dec 2013 11:19:31 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
CC: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        Michael Dalton <mwdalton@google.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable v2 2/3] virtio-net: make all RX paths handle errors
 consistently
References: <1388064752-15734-1-git-send-email-mst@redhat.com> <1388064752-15734-3-git-send-email-mst@redhat.com>
In-Reply-To: <1388064752-15734-3-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 09:32 PM, Michael S. Tsirkin wrote:
> receive mergeable now handles errors internally.
> Do same for big and small packet paths, otherwise
> the logic is too hard to follow.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Acked-by: Michael Dalton <mwdalton@google.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> (cherry picked from commit f121159d72091f25afb22007c833e60a6845e912)
> ---
>  drivers/net/virtio_net.c | 56 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 36 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 435076f..c0ed6d5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -297,6 +297,34 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
>  	return skb;
>  }
>  
> +static struct sk_buff *receive_small(void *buf, unsigned int len)
> +{
> +	struct sk_buff * skb = buf;
> +
> +	len -= sizeof(struct virtio_net_hdr);
> +	skb_trim(skb, len);
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *receive_big(struct net_device *dev,
> +				   struct receive_queue *rq,
> +				   void *buf)
> +{
> +	struct page *page = buf;
> +	struct sk_buff *skb = page_to_skb(rq, page, 0);
> +
> +	if (unlikely(!skb))
> +		goto err;
> +
> +	return skb;
> +
> +err:
> +	dev->stats.rx_dropped++;
> +	give_pages(rq, page);
> +	return NULL;
> +}
> +
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
>  					 struct receive_queue *rq,
>  					 void *buf,
> @@ -360,7 +388,6 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
>  	struct net_device *dev = vi->dev;
>  	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
>  	struct sk_buff *skb;
> -	struct page *page;
>  	struct skb_vnet_hdr *hdr;
>  
>  	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
> @@ -372,26 +399,15 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
>  			dev_kfree_skb(buf);
>  		return;
>  	}
> +	if (vi->mergeable_rx_bufs)
> +		skb = receive_mergeable(dev, rq, buf, len);
> +	else if (vi->big_packets)
> +		skb = receive_big(dev, rq, buf);
> +	else
> +		skb = receive_small(buf, len);
>  
> -	if (!vi->mergeable_rx_bufs && !vi->big_packets) {
> -		skb = buf;
> -		len -= sizeof(struct virtio_net_hdr);
> -		skb_trim(skb, len);
> -	} else {
> -		page = buf;
> -		if (vi->mergeable_rx_bufs) {
> -			skb = receive_mergeable(dev, rq, page, len);
> -			if (unlikely(!skb))
> -				return;
> -		} else {
> -			skb = page_to_skb(rq, page, len);
> -			if (unlikely(!skb)) {
> -				dev->stats.rx_dropped++;
> -				give_pages(rq, page);
> -				return;
> -			}
> -		}
> -	}
> +	if (unlikely(!skb))
> +		return;
>  
>  	hdr = skb_vnet_hdr(skb);
>  

Acked-by: Jason Wang <jasowang@redhat.com>
