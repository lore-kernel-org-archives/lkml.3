Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaJOLAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaJOLAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:00:32 -0400
Message-ID: <543E53C6.8040907@redhat.com>
Date: Wed, 15 Oct 2014 19:00:22 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 5/6] virtio-net: enable tx interrupt
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com> <1413357930-45302-6-git-send-email-jasowang@redhat.com> <20141015101826.GD25776@redhat.com> <543E4B95.2040209@redhat.com> <20141015104309.GI25776@redhat.com>
In-Reply-To: <20141015104309.GI25776@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 06:43 PM, Michael S. Tsirkin wrote:
> On Wed, Oct 15, 2014 at 06:25:25PM +0800, Jason Wang wrote:
>> > On 10/15/2014 06:18 PM, Michael S. Tsirkin wrote:
>>> > > On Wed, Oct 15, 2014 at 03:25:29PM +0800, Jason Wang wrote:
>>>>> > >> > Orphan skb in ndo_start_xmit() breaks socket accounting and packet
>>>>> > >> > queuing. This in fact breaks lots of things such as pktgen and several
>>>>> > >> > TCP optimizations. And also make BQL can't be implemented for
>>>>> > >> > virtio-net.
>>>>> > >> > 
>>>>> > >> > This patch tries to solve this issue by enabling tx interrupt. To
>>>>> > >> > avoid introducing extra spinlocks, a tx napi was scheduled to free
>>>>> > >> > those packets.
>>>>> > >> > 
>>>>> > >> > More tx interrupt mitigation method could be used on top.
>>>>> > >> > 
>>>>> > >> > Cc: Rusty Russell <rusty@rustcorp.com.au>
>>>>> > >> > Cc: Michael S. Tsirkin <mst@redhat.com>
>>>>> > >> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>> > >> > ---
>>>>> > >> >  drivers/net/virtio_net.c |  125 +++++++++++++++++++++++++++++++---------------
>>>>> > >> >  1 files changed, 85 insertions(+), 40 deletions(-)
>>>>> > >> > 
>>>>> > >> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>> > >> > index ccf98f9..2afc2e2 100644
>>>>> > >> > --- a/drivers/net/virtio_net.c
>>>>> > >> > +++ b/drivers/net/virtio_net.c
>>>>> > >> > @@ -72,6 +72,8 @@ struct send_queue {
>>>>> > >> >  
>>>>> > >> >  	/* Name of the send queue: output.$index */
>>>>> > >> >  	char name[40];
>>>>> > >> > +
>>>>> > >> > +	struct napi_struct napi;
>>>>> > >> >  };
>>>>> > >> >  
>>>>> > >> >  /* Internal representation of a receive virtqueue */
>>>>> > >> > @@ -217,15 +219,40 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>>>>> > >> >  	return p;
>>>>> > >> >  }
>>>>> > >> >  
>>>>> > >> > +static int free_old_xmit_skbs(struct send_queue *sq, int budget)
>>>>> > >> > +{
>>>>> > >> > +	struct sk_buff *skb;
>>>>> > >> > +	unsigned int len;
>>>>> > >> > +	struct virtnet_info *vi = sq->vq->vdev->priv;
>>>>> > >> > +	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
>>>>> > >> > +	u64 tx_bytes = 0, tx_packets = 0;
>>>>> > >> > +
>>>>> > >> > +	while (tx_packets < budget &&
>>>>> > >> > +	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
>>>>> > >> > +		pr_debug("Sent skb %p\n", skb);
>>>>> > >> > +
>>>>> > >> > +		tx_bytes += skb->len;
>>>>> > >> > +		tx_packets++;
>>>>> > >> > +
>>>>> > >> > +		dev_kfree_skb_any(skb);
>>>>> > >> > +	}
>>>>> > >> > +
>>>>> > >> > +	u64_stats_update_begin(&stats->tx_syncp);
>>>>> > >> > +	stats->tx_bytes += tx_bytes;
>>>>> > >> > +	stats->tx_packets =+ tx_packets;
>>>>> > >> > +	u64_stats_update_end(&stats->tx_syncp);
>>>>> > >> > +
>>>>> > >> > +	return tx_packets;
>>>>> > >> > +}
>>>>> > >> > +
>>>>> > >> >  static void skb_xmit_done(struct virtqueue *vq)
>>>>> > >> >  {
>>>>> > >> >  	struct virtnet_info *vi = vq->vdev->priv;
>>>>> > >> > +	struct send_queue *sq = &vi->sq[vq2txq(vq)];
>>>>> > >> >  
>>>>> > >> > -	/* Suppress further interrupts. */
>>>>> > >> > -	virtqueue_disable_cb(vq);
>>>>> > >> > -
>>>>> > >> > -	/* We were probably waiting for more output buffers. */
>>>>> > >> > -	netif_wake_subqueue(vi->dev, vq2txq(vq));
>>>>> > >> > +	if (napi_schedule_prep(&sq->napi)) {
>>>>> > >> > +		__napi_schedule(&sq->napi);
>>>>> > >> > +	}
>>>>> > >> >  }
>>>>> > >> >  
>>>>> > >> >  static unsigned int mergeable_ctx_to_buf_truesize(unsigned long mrg_ctx)
>>>>> > >> > @@ -774,7 +801,39 @@ again:
>>>>> > >> >  	return received;
>>>>> > >> >  }
>>>>> > >> >  
>>>>> > >> > +static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>>> > >> > +{
>>>>> > >> > +	struct send_queue *sq =
>>>>> > >> > +		container_of(napi, struct send_queue, napi);
>>>>> > >> > +	struct virtnet_info *vi = sq->vq->vdev->priv;
>>>>> > >> > +	struct netdev_queue *txq = netdev_get_tx_queue(vi->dev, vq2txq(sq->vq));
>>>>> > >> > +	unsigned int r, sent = 0;
>>>>> > >> > +
>>>>> > >> > +again:
>>>>> > >> > +	__netif_tx_lock(txq, smp_processor_id());
>>>>> > >> > +	virtqueue_disable_cb(sq->vq);
>>>>> > >> > +	sent += free_old_xmit_skbs(sq, budget - sent);
>>>>> > >> > +
>>>>> > >> > +	if (sent < budget) {
>>>>> > >> > +		r = virtqueue_enable_cb_prepare(sq->vq);
>>>>> > >> > +		napi_complete(napi);
>>>>> > >> > +		__netif_tx_unlock(txq);
>>>>> > >> > +		if (unlikely(virtqueue_poll(sq->vq, r)) &&
>>> > > So you are enabling callback on the next packet,
>>> > > which is almost sure to cause an interrupt storm
>>> > > on the guest.
>>> > >
>>> > >
>>> > > I think it's a bad idea, this is why I used
>>> > > enable_cb_delayed in my patch.
>> > 
>> > Right, will do this, but may also need to make sure used event never
>> > goes back since we may call virtqueue_enable_cb_avail().
> That's why my patch always calls virtqueue_enable_cb_delayed.
> So no need for hacks.
>
> Maybe you can review my patch and comment?

I think I miss the virtqueue_enable_cb_delayed() in your patch when I'm
reviewing it. Will do.
