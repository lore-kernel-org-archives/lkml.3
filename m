Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaJOJeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaJOJeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:34:11 -0400
Date: Wed, 15 Oct 2014 12:37:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 3/6] virtio-net: small optimization on
 free_old_xmit_skbs()
Message-ID: <20141015093739.GC25776@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
 <1413357930-45302-4-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413357930-45302-4-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:25:27PM +0800, Jason Wang wrote:
> Accumulate the sent packets and sent bytes in local variables and perform a
> single u64_stats_update_begin/end() after.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Not sure how much it's worth but since Eric suggested it ...

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 3d0ce44..a4d56b8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -833,17 +833,21 @@ static void free_old_xmit_skbs(struct send_queue *sq)
>  	unsigned int len;
>  	struct virtnet_info *vi = sq->vq->vdev->priv;
>  	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
> +	u64 tx_bytes = 0, tx_packets = 0;
>  
>  	while ((skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
>  		pr_debug("Sent skb %p\n", skb);
>  
> -		u64_stats_update_begin(&stats->tx_syncp);
> -		stats->tx_bytes += skb->len;
> -		stats->tx_packets++;
> -		u64_stats_update_end(&stats->tx_syncp);
> +		tx_bytes += skb->len;
> +		tx_packets++;
>  
>  		dev_kfree_skb_any(skb);
>  	}
> +
> +	u64_stats_update_begin(&stats->tx_syncp);
> +	stats->tx_bytes += tx_bytes;
> +	stats->tx_packets =+ tx_packets;
> +	u64_stats_update_end(&stats->tx_syncp);
>  }
>  
>  static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> -- 
> 1.7.1
