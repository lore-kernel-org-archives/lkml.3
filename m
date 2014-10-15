Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaJOJuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:50:37 -0400
Received: from mx0.aculab.com ([213.249.233.131]:38421 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751292AbaJOJug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:50:36 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Michael S. Tsirkin'" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
CC: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: RE: [RFC PATCH net-next 3/6] virtio-net: small optimization on
 free_old_xmit_skbs()
Thread-Topic: [RFC PATCH net-next 3/6] virtio-net: small optimization on
 free_old_xmit_skbs()
Thread-Index: AQHP6FsCsmX5zz5fkUSOZUv7LBGEbpww6EfA
Date: Wed, 15 Oct 2014 09:49:01 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9D752A@AcuExch.aculab.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
 <1413357930-45302-4-git-send-email-jasowang@redhat.com>
 <20141015093739.GC25776@redhat.com>
In-Reply-To: <20141015093739.GC25776@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Michael S. Tsirkin
> On Wed, Oct 15, 2014 at 03:25:27PM +0800, Jason Wang wrote:
> > Accumulate the sent packets and sent bytes in local variables and perform a
> > single u64_stats_update_begin/end() after.
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Not sure how much it's worth but since Eric suggested it ...

Probably depends on the actual cost of u64_stats_update_begin/end
against the likely extra saving of the tx_bytes and tx_packets
values onto the stack across the call to dev_kfree_skb_any().
(Which depends on the number of caller saved registers.)

> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> > ---
> >  drivers/net/virtio_net.c |   12 ++++++++----
> >  1 files changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 3d0ce44..a4d56b8 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -833,17 +833,21 @@ static void free_old_xmit_skbs(struct send_queue *sq)
> >  	unsigned int len;
> >  	struct virtnet_info *vi = sq->vq->vdev->priv;
> >  	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
> > +	u64 tx_bytes = 0, tx_packets = 0;

tx_packets need only be 'unsigned int'.
The same is almost certainly true of tx_bytes.

	David

> >  	while ((skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> >  		pr_debug("Sent skb %p\n", skb);
> >
> > -		u64_stats_update_begin(&stats->tx_syncp);
> > -		stats->tx_bytes += skb->len;
> > -		stats->tx_packets++;
> > -		u64_stats_update_end(&stats->tx_syncp);
> > +		tx_bytes += skb->len;
> > +		tx_packets++;
> >
> >  		dev_kfree_skb_any(skb);
> >  	}
> > +
> > +	u64_stats_update_begin(&stats->tx_syncp);
> > +	stats->tx_bytes += tx_bytes;
> > +	stats->tx_packets =+ tx_packets;
> > +	u64_stats_update_end(&stats->tx_syncp);
> >  }
> >
> >  static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> > --
> > 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


