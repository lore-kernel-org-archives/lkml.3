Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaJNXIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaJNXIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:08:23 -0400
Date: Wed, 15 Oct 2014 02:11:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC] virtio_net: enable tx interrupt
Message-ID: <20141014231154.GA23806@redhat.com>
References: <1413323524-23380-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413323524-23380-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:53:59AM +0300, Michael S. Tsirkin wrote:
>  static void skb_xmit_done(struct virtqueue *vq)
>  {
>  	struct virtnet_info *vi = vq->vdev->priv;
> +	struct send_queue *sq = &vi->sq[vq2txq(vq)];
>  
> -	/* Suppress further interrupts. */
> -	virtqueue_disable_cb(vq);
> -

One note here: current code seems racy because of doing
virtqueue_disable_cb from skb_xmit_done that I'm dropping here: there's
no guarantee we don't get an interrupt while tx ring is running, and if
that happens we can end up with interrupts disabled forever.

> -	/* We were probably waiting for more output buffers. */
> -	netif_wake_subqueue(vi->dev, vq2txq(vq));
> +	if (napi_schedule_prep(&sq->napi)) {
> +		__napi_schedule(&sq->napi);
> +	}
>  }
>  
>  static unsigned int mergeable_ctx_to_buf_truesize(unsigned long mrg_ctx)
