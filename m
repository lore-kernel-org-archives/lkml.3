Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaLSHcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:32:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:20397 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaLSHcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:32:50 -0500
Message-ID: <5493D488.7020000@huawei.com>
Date: Fri, 19 Dec 2014 15:32:24 +0800
From: Qin Chuanyu <qinchuanyu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>
CC: <pagupta@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC v4 net-next 1/5] virtio_net: enable tx interrupt
References: <1417429028-11971-1-git-send-email-jasowang@redhat.com> <1417429028-11971-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1417429028-11971-2-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.21.101]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/1 18:17, Jason Wang wrote:
> On newer hosts that support delayed tx interrupts,
> we probably don't have much to gain from orphaning
> packets early.
>
> Note: this might degrade performance for
> hosts without event idx support.
> Should be addressed by the next patch.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/net/virtio_net.c | 132 +++++++++++++++++++++++++++++++----------------
>   1 file changed, 88 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ec2a8b4..f68114e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
>   static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>   {
>   	struct skb_vnet_hdr *hdr;
> @@ -912,7 +951,9 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>   		sg_set_buf(sq->sg, hdr, hdr_len);
>   		num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
>   	}
> -	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
> +
> +	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb,
> +				    GFP_ATOMIC);
>   }
>
>   static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -924,8 +965,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>   	bool kick = !skb->xmit_more;
>
> -	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(sq);

I think there is no need to remove free_old_xmit_skbs here.
you could add free_old_xmit_skbs in tx_irq's napi func.
also could do this in start_xmit if you handle the race well.

I have done the same thing in ixgbe driver(free skb in ndo_start_xmit 
and both in tx_irq's poll func), and it seems work well:)

I think there would be no so much interrupts in this way, also tx 
interrupt coalesce is not needed.

> +	virtqueue_disable_cb(sq->vq);
>
>   	/* Try to transmit */
>   	err = xmit_skb(sq, skb);
> @@ -941,27 +981,19 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   		return NETDEV_TX_OK;
>   	}
>
> -	/* Don't wait up for transmitted skbs to be freed. */
> -	skb_orphan(skb);
> -	nf_reset(skb);
> -
>   	/* Apparently nice girls don't return TX_BUSY; stop the queue
>   	 * before it gets out of hand.  Naturally, this wastes entries. */
> -	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> +	if (sq->vq->num_free < 2+MAX_SKB_FRAGS)
>   		netif_stop_subqueue(dev, qnum);
> -		if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> -			/* More just got used, free them then recheck. */
> -			free_old_xmit_skbs(sq);
> -			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
> -				netif_start_subqueue(dev, qnum);
> -				virtqueue_disable_cb(sq->vq);
> -			}
> -		}
> -	}
>
>   	if (kick || netif_xmit_stopped(txq))
>   		virtqueue_kick(sq->vq);
>
> +	if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> +		virtqueue_disable_cb(sq->vq);
> +		napi_schedule(&sq->napi);
> +	}
> +
>   	return NETDEV_TX_OK;
>   }
>
> @@ -1138,8 +1170,10 @@ static int virtnet_close(struct net_device *dev)
>   	/* Make sure refill_work doesn't re-enable napi! */
>   	cancel_delayed_work_sync(&vi->refill);
>
> -	for (i = 0; i < vi->max_queue_pairs; i++)
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		napi_disable(&vi->rq[i].napi);
> +		napi_disable(&vi->sq[i].napi);
> +	}
>
>   	return 0;
>   }
> @@ -1452,8 +1486,10 @@ static void virtnet_free_queues(struct virtnet_info *vi)
>   {
>   	int i;
>
> -	for (i = 0; i < vi->max_queue_pairs; i++)
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		netif_napi_del(&vi->rq[i].napi);
> +		netif_napi_del(&vi->sq[i].napi);
> +	}
>
>   	kfree(vi->rq);
>   	kfree(vi->sq);


