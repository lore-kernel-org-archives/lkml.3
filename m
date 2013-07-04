Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3GDIWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab3GDIWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:22:21 -0400
Date: Thu, 4 Jul 2013 11:23:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH net] virtio-net: fix the race between channels setting
 and refill
Message-ID: <20130704082322.GB29342@redhat.com>
References: <1372853752-41889-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372853752-41889-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:15:52PM +0800, Jason Wang wrote:
> Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx queues
> which are being used) tries to refill on demand when changing the number of
> channels by call try_refill_recv() directly, this may race:
> 
> - the refill work who may do the refill in the same time
> - the try_refill_recv() called in bh since napi was not disabled
> 
> Which may led guest complain during setting channels:
> 
> virtio_net virtio0: input.1:id 0 is not a head!
> 
> Solve this issue by scheduling a refill work which can guarantee the
> serialization of refill.
> 
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c9e0038..47b4882 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -901,7 +901,6 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
>  	struct scatterlist sg;
>  	struct virtio_net_ctrl_mq s;
>  	struct net_device *dev = vi->dev;
> -	int i;
>  
>  	if (!vi->has_cvq || !virtio_has_feature(vi->vdev, VIRTIO_NET_F_MQ))
>  		return 0;
> @@ -915,10 +914,8 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
>  			 queue_pairs);
>  		return -EINVAL;
>  	} else {
> -		for (i = vi->curr_queue_pairs; i < queue_pairs; i++)
> -			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
> -				schedule_delayed_work(&vi->refill, 0);
>  		vi->curr_queue_pairs = queue_pairs;
> +		schedule_delayed_work(&vi->refill, 0);
>  	}
>  
>  	return 0;
> -- 
> 1.7.1
