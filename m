Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaJOJgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:36:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55447 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaJOJgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:36:06 -0400
Message-ID: <1413365764.12304.54.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [RFC PATCH net-next 3/6] virtio-net: small optimization on
 free_old_xmit_skbs()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Date: Wed, 15 Oct 2014 02:36:04 -0700
In-Reply-To: <1413357930-45302-4-git-send-email-jasowang@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
	 <1413357930-45302-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 15:25 +0800, Jason Wang wrote:
> Accumulate the sent packets and sent bytes in local variables and perform a
> single u64_stats_update_begin/end() after.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
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

	
	stats->tx_packets += tx_packets;


> +	u64_stats_update_end(&stats->tx_syncp);
>  }
>  
>  static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)


