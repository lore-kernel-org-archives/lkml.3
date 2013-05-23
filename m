Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3EWF7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3EWF7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:59:40 -0400
Date: Thu, 23 May 2013 08:59:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH V2] virtio_net: enable napi for all possible queues
 during open
Message-ID: <20130523055957.GC13916@redhat.com>
References: <1369202638-17660-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369202638-17660-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:03:58PM +0800, Jason Wang wrote:
> Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx
> queues which are being used) only does the napi enabling during open for
> curr_queue_pairs. This will break multiqueue receiving since napi of new queues
> were still disabled after changing the number of queues.
> 
> This patch fixes this by enabling napi for all possible queues during open.
> 
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> Changes from V1:
> - enable napi in open instead of virtnet_set_queues() to avoid kernel BUG() when
> trying to do napi_enable() for a already enabled queue
> ---
>  drivers/net/virtio_net.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2d6abac..241527d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -636,10 +636,11 @@ static int virtnet_open(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i;
>  
> -	for (i = 0; i < vi->curr_queue_pairs; i++) {
> -		/* Make sure we have some buffers: if oom use wq. */
> -		if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
> -			schedule_delayed_work(&vi->refill, 0);
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		if (i < vi->curr_queue_pairs)
> +			/* Make sure we have some buffers: if oom use wq. */
> +			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
> +				schedule_delayed_work(&vi->refill, 0);
>  		virtnet_napi_enable(&vi->rq[i]);
>  	}
>  
> -- 
> 1.7.1
