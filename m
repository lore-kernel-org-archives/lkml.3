Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJOJhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:37:48 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33892 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaJOJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:37:47 -0400
Message-ID: <1413365865.12304.55.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [RFC PATCH net-next 5/6] virtio-net: enable tx interrupt
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Date: Wed, 15 Oct 2014 02:37:45 -0700
In-Reply-To: <1413357930-45302-6-git-send-email-jasowang@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
	 <1413357930-45302-6-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 15:25 +0800, Jason Wang wrote:

...

> +static int free_old_xmit_skbs(struct send_queue *sq, int budget)
> +{
> +	struct sk_buff *skb;
> +	unsigned int len;
> +	struct virtnet_info *vi = sq->vq->vdev->priv;
> +	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
> +	u64 tx_bytes = 0, tx_packets = 0;
> +
> +	while (tx_packets < budget &&
> +	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> +		pr_debug("Sent skb %p\n", skb);
> +
> +		tx_bytes += skb->len;
> +		tx_packets++;
> +
> +		dev_kfree_skb_any(skb);
> +	}
> +
> +	u64_stats_update_begin(&stats->tx_syncp);
> +	stats->tx_bytes += tx_bytes;
> +	stats->tx_packets =+ tx_packets;

	
	stats->tx_packets += tx_packets;

> +	u64_stats_update_end(&stats->tx_syncp);
> +
> +	return tx_packets;
> +}

