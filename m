Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145Ab3BTLL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:11:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935105Ab3BTLL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:11:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736128"
Message-ID: <5124A21C.2080906@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:14:52 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 14/16] virtio_rpmsg_bus: use simplified virtqueue accessors.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-15-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-15-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:15:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:15:25,
	Serialize complete at 2013/02/20 18:15:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> We never add buffers with input and output parts, so use the new accessors.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

> ---
>  drivers/rpmsg/virtio_rpmsg_bus.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index f1e3239..d9897d1 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -763,14 +763,14 @@ int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
>  	mutex_lock(&vrp->tx_lock);
>  
>  	/* add message to the remote processor's virtqueue */
> -	err = virtqueue_add_buf(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
> +	err = virtqueue_add_outbuf(vrp->svq, &sg, 1, msg, GFP_KERNEL);
>  	if (err) {
>  		/*
>  		 * need to reclaim the buffer here, otherwise it's lost
>  		 * (memory won't leak, but rpmsg won't use it again for TX).
>  		 * this will wait for a buffer management overhaul.
>  		 */
> -		dev_err(dev, "virtqueue_add_buf failed: %d\n", err);
> +		dev_err(dev, "virtqueue_add_outbuf failed: %d\n", err);
>  		goto out;
>  	}
>  
> @@ -845,7 +845,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
>  	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
>  
>  	/* add the buffer back to the remote processor's virtqueue */
> -	err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
> +	err = virtqueue_add_inbuf(vrp->rvq, &sg, 1, msg, GFP_KERNEL);
>  	if (err < 0) {
>  		dev_err(dev, "failed to add a virtqueue buffer: %d\n", err);
>  		return;
> @@ -976,7 +976,7 @@ static int rpmsg_probe(struct virtio_device *vdev)
>  
>  		sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
>  
> -		err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, cpu_addr,
> +		err = virtqueue_add_inbuf(vrp->rvq, &sg, 1, cpu_addr,
>  								GFP_KERNEL);
>  		WARN_ON(err); /* sanity check; this can't really happen */
>  	}
> 

