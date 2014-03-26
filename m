Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaCZG7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaCZG7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:59:11 -0400
Date: Wed, 26 Mar 2014 08:59:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: Re: [PATCH net] virtio-net: correct error handling of
 virtqueue_kick()
Message-ID: <20140326065914.GA13127@redhat.com>
References: <1395810180-35169-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395810180-35169-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 01:03:00PM +0800, Jason Wang wrote:
> Current error handling of virtqueue_kick() was wrong in two places:
> - The skb were freed immediately when virtqueue_kick() fail during
>   xmit. This may lead double free since the skb was not detached from
>   the virtqueue.
> - try_fill_recv() returns false when virtqueue_kick() fail. This will
>   lead unnecessary rescheduling of refill work.
> 
> Actually, it's safe to just ignore the kick failure in those two
> places. So this patch fixes this by partially revert commit
> 67975901183799af8e93ec60e322f9e2a1940b9b.
> 
> Fixes 67975901183799af8e93ec60e322f9e2a1940b9b
> (virtio_net: verify if virtqueue_kick() succeeded).
> 
> Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5632a99..841b608 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -671,8 +671,7 @@ static bool try_fill_recv(struct receive_queue *rq, gfp_t gfp)
>  		if (err)
>  			break;
>  	} while (rq->vq->num_free);
> -	if (unlikely(!virtqueue_kick(rq->vq)))
> -		return false;
> +	virtqueue_kick(rq->vq);
>  	return !oom;
>  }
>  
> @@ -877,7 +876,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	err = xmit_skb(sq, skb);
>  
>  	/* This should not happen! */
> -	if (unlikely(err) || unlikely(!virtqueue_kick(sq->vq))) {
> +	if (unlikely(err)) {
>  		dev->stats.tx_fifo_errors++;
>  		if (net_ratelimit())
>  			dev_warn(&dev->dev,
> @@ -886,6 +885,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		kfree_skb(skb);
>  		return NETDEV_TX_OK;
>  	}
> +	virtqueue_kick(sq->vq);
>  
>  	/* Don't wait up for transmitted skbs to be freed. */
>  	skb_orphan(skb);
> -- 
> 1.7.1
