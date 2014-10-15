Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaJOJbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaJOJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:31:04 -0400
Date: Wed, 15 Oct 2014 12:34:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 1/6] virtio: make sure used event never go
 backwards
Message-ID: <20141015093432.GB25776@redhat.com>
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>
 <1413357930-45302-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413357930-45302-2-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:25:25PM +0800, Jason Wang wrote:
> This patch checks the new event idx to make sure used event idx never
> goes back. This is used to synchronize the calls between
> virtqueue_enable_cb_delayed() and virtqueue_enable_cb().
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

the implication being that moving event idx back might cause some race
condition?  If yes but please describe the race explicitly.
Is there a bug we need to fix on stable?
Please also explicitly describe a configuration that causes event idx
to go back.

All this info should go in the commit log.

> ---
>  drivers/virtio/virtio_ring.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 3b1f89b..1b3929f 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -559,14 +559,17 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
>  	u16 last_used_idx;
>  
>  	START_USE(vq);
> -
> +	last_used_idx = vq->last_used_idx;
>  	/* We optimistically turn back on interrupts, then check if there was
>  	 * more to do. */
>  	/* Depending on the VIRTIO_RING_F_EVENT_IDX feature, we need to
>  	 * either clear the flags bit or point the event index at the next
>  	 * entry. Always do both to keep code simple. */
>  	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
> -	vring_used_event(&vq->vring) = last_used_idx = vq->last_used_idx;
> +	/* Make sure used event never go backwards */

s/go/goes/

> +	if (!vring_need_event(vring_used_event(&vq->vring),
> +			      vq->vring.avail->idx, last_used_idx))
> +		vring_used_event(&vq->vring) = last_used_idx;

The result will be that driver will *not* get an interrupt
on the next consumed buffer, which is likely not what driver
intended when it called virtqueue_enable_cb.

Instead, how about we simply document the requirement that drivers either
always call virtqueue_enable_cb_delayed or virtqueue_enable_cb
but not both?


>  	END_USE(vq);
>  	return last_used_idx;
>  }
> -- 
> 1.7.1
