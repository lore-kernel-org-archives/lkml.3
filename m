Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3BURJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:09:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3BURJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:09:06 -0500
Date: Thu, 21 Feb 2013 19:09:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] virtio_ring: virtqueue_add_outbuf /
 virtqueue_add_inbuf.
Message-ID: <20130221170902.GA27097@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
 <1361260594-601-9-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361260594-601-9-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 06:26:26PM +1030, Rusty Russell wrote:
> These are specialized versions of virtqueue_add_buf(), which cover
> over 50% of cases and are far clearer.
> 
> In particular, the scatterlists passed to these functions don't have
> to be clean (ie. we ignore end markers).
> 
> FIXME: I'm not sure about the unclean sglist bit.  I had a more
> ambitious one which conditionally ignored end markers in the iterator,
> but it was ugly and I suspect this is just as fast.  Maybe we should
> just fix all the drivers?
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Looking at code, it seems that most users really have a single sg, in
low memory. So how about simply passing void * instead of sg? Whoever
has multiple sgs can use the rich interface.

Long term we might optimize this unrolling some loops, I think
I saw this giving a small performance gain for -net.

> ---
>  drivers/virtio/virtio_ring.c |   58 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h       |   10 ++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index c537385..fb282b5 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -345,6 +345,64 @@ int virtqueue_add_sgs(struct virtqueue *_vq,
>  EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
>  
>  /**
> + * virtqueue_add_outbuf - expose output buffers to other end
> + * @vq: the struct virtqueue we're talking about.
> + * @sgs: array of scatterlists (need not be terminated!)
> + * @num: the number of scatterlists readable by other side
> + * @data: the token identifying the buffer.
> + * @gfp: how to do memory allocations (if necessary).
> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> + */
> +int virtqueue_add_outbuf(struct virtqueue *vq,
> +			 struct scatterlist sg[], unsigned int num,
> +			 void *data,
> +			 gfp_t gfp)
> +{
> +	unsigned int i;
> +
> +	/* We're about to iterate, so this is pretty cheap. */
> +	for (i = 0; i < num - 1; i++)
> +		sg_unmark_end(sg + i);
> +	sg_mark_end(sg + i);
> +
> +	return virtqueue_add(vq, &sg, num, 1, 0, data, gfp);
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_add_outbuf);
> +
> +/**
> + * virtqueue_add_inbuf - expose input buffers to other end
> + * @vq: the struct virtqueue we're talking about.
> + * @sgs: array of scatterlists (need not be terminated!)
> + * @num: the number of scatterlists writable by other side
> + * @data: the token identifying the buffer.
> + * @gfp: how to do memory allocations (if necessary).
> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> + */
> +int virtqueue_add_inbuf(struct virtqueue *vq,
> +			struct scatterlist sg[], unsigned int num,
> +			void *data,
> +			gfp_t gfp)
> +{
> +	unsigned int i;
> +
> +	/* We're about to iterate, so this is pretty cheap. */
> +	for (i = 0; i < num - 1; i++)
> +		sg_unmark_end(sg + i);
> +	sg_mark_end(sg + i);
> +
> +	return virtqueue_add(vq, &sg, num, 0, 1, data, gfp);
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
> +
> +/**
>   * virtqueue_kick_prepare - first half of split virtqueue_kick call.
>   * @vq: the struct virtqueue
>   *
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 6eff15b..b442500 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -40,6 +40,16 @@ int virtqueue_add_buf(struct virtqueue *vq,
>  		      void *data,
>  		      gfp_t gfp);
>  
> +int virtqueue_add_outbuf(struct virtqueue *vq,
> +			 struct scatterlist sg[], unsigned int num,
> +			 void *data,
> +			 gfp_t gfp);
> +
> +int virtqueue_add_inbuf(struct virtqueue *vq,
> +			struct scatterlist sg[], unsigned int num,
> +			void *data,
> +			gfp_t gfp);
> +
>  int virtqueue_add_sgs(struct virtqueue *vq,
>  		      struct scatterlist *sgs[],
>  		      unsigned int out_sgs,
> -- 
> 1.7.10.4
