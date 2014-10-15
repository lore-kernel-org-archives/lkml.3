Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaJOKT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaJOKT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:19:26 -0400
Date: Wed, 15 Oct 2014 13:22:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 6/6] virtio-net: enable tx interrupt only
 for the final skb in the chain
Message-ID: <20141015102251.GE25776@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
 <1413357930-45302-7-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413357930-45302-7-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:25:30PM +0800, Jason Wang wrote:
> With the help of xmit_more and virtqueue_enable_cb_avail(), this patch
> enable tx interrupt only for the final skb in the chain if
> needed. This will help to mitigate tx interrupts.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I think you should split xmit_more stuff out.



> ---
>  drivers/net/virtio_net.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2afc2e2..5943f3f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -993,12 +993,16 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  				virtqueue_disable_cb(sq->vq);
>  			}
>  		}
> -	} else if (virtqueue_enable_cb(sq->vq)) {
> -		free_old_xmit_skbs(sq, qsize);
>  	}
>  
> -	if (__netif_subqueue_stopped(dev, qnum) || !skb->xmit_more)
> +	if (__netif_subqueue_stopped(dev, qnum) || !skb->xmit_more) {
>  		virtqueue_kick(sq->vq);
> +		if (sq->vq->num_free >= 2 +MAX_SKB_FRAGS &&
> +		    unlikely(virtqueue_enable_cb_avail(sq->vq))) {
> +			free_old_xmit_skbs(sq, qsize);
> +			virtqueue_disable_cb(sq->vq);
> +		}
> +	}
>  
>  	return NETDEV_TX_OK;
>  }
> -- 
> 1.7.1
