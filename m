Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3BTKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:10:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758854Ab3BTKKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:10:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,700,1355068800"; 
   d="scan'208";a="6735911"
Message-ID: <5124A0CF.3070104@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:09:19 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 07/16] virtio_ring: don't count elements twice for add_buf
 path.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-8-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-8-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:09:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:09:39,
	Serialize complete at 2013/02/20 18:09:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> Extract the post-counting code into virtqueue_add(), make both callers
> use it.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

> ---
>  drivers/virtio/virtio_ring.c |  147 +++++++++++++++++++++++-------------------
>  1 file changed, 80 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 27e31d3..c537385 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -163,69 +163,17 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
>  	return head;
>  }
>  
> -/**
> - * virtqueue_add_buf - expose buffer to other end
> - * @vq: the struct virtqueue we're talking about.
> - * @sg: the description of the buffer(s).
> - * @out_num: the number of sg readable by other side
> - * @in_num: the number of sg which are writable (after readable ones)
> - * @data: the token identifying the buffer.
> - * @gfp: how to do memory allocations (if necessary).
> - *
> - * Caller must ensure we don't call this with other virtqueue operations
> - * at the same time (except where noted).
> - *
> - * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> - */
> -int virtqueue_add_buf(struct virtqueue *_vq,
> -		      struct scatterlist sg[],
> -		      unsigned int out,
> -		      unsigned int in,
> -		      void *data,
> -		      gfp_t gfp)
> -{
> -	struct scatterlist *sgs[2];
> -	unsigned int i;
> -
> -	sgs[0] = sg;
> -	sgs[1] = sg + out;
> -
> -	/* Workaround until callers pass well-formed sgs. */
> -	for (i = 0; i < out + in; i++)
> -		sg_unmark_end(sg + i);
> -
> -	sg_mark_end(sg + out + in - 1);
> -	if (out && in)
> -		sg_mark_end(sg + out - 1);
> -
> -	return virtqueue_add_sgs(_vq, sgs, out ? 1 : 0, in ? 1 : 0, data, gfp);
> -}
> -EXPORT_SYMBOL_GPL(virtqueue_add_buf);
> -
> -/**
> - * virtqueue_add_sgs - expose buffers to other end
> - * @vq: the struct virtqueue we're talking about.
> - * @sgs: array of terminated scatterlists.
> - * @out_num: the number of scatterlists readable by other side
> - * @in_num: the number of scatterlists which are writable (after readable ones)
> - * @data: the token identifying the buffer.
> - * @gfp: how to do memory allocations (if necessary).
> - *
> - * Caller must ensure we don't call this with other virtqueue operations
> - * at the same time (except where noted).
> - *
> - * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> - */
> -int virtqueue_add_sgs(struct virtqueue *_vq,
> -		      struct scatterlist *sgs[],
> -		      unsigned int out_sgs,
> -		      unsigned int in_sgs,
> -		      void *data,
> -		      gfp_t gfp)
> +static int virtqueue_add(struct virtqueue *_vq,
> +			 struct scatterlist *sgs[],
> +			 unsigned int total_sg,
> +			 unsigned int out_sgs,
> +			 unsigned int in_sgs,
> +			 void *data,
> +			 gfp_t gfp)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  	struct scatterlist *sg;
> -	unsigned int i, n, avail, uninitialized_var(prev), total_sg;
> +	unsigned int i, n, avail, uninitialized_var(prev);
>  	int head;
>  
>  	START_USE(vq);
> @@ -245,13 +193,6 @@ int virtqueue_add_sgs(struct virtqueue *_vq,
>  	}
>  #endif
>  
> -	/* Count them first. */
> -	for (i = total_sg = 0; i < out_sgs + in_sgs; i++) {
> -		struct scatterlist *sg;
> -		for (sg = sgs[i]; sg; sg = sg_next(sg))
> -			total_sg++;
> -	}
> -
>  	/* If the host supports indirect descriptor tables, and we have multiple
>  	 * buffers, then go indirect. FIXME: tune this threshold */
>  	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
> @@ -329,6 +270,78 @@ add_head:
>  
>  	return 0;
>  }
> +
> +/**
> + * virtqueue_add_buf - expose buffer to other end
> + * @vq: the struct virtqueue we're talking about.
> + * @sg: the description of the buffer(s).
> + * @out_num: the number of sg readable by other side
> + * @in_num: the number of sg which are writable (after readable ones)
> + * @data: the token identifying the buffer.
> + * @gfp: how to do memory allocations (if necessary).
> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> + */
> +int virtqueue_add_buf(struct virtqueue *_vq,
> +		      struct scatterlist sg[],
> +		      unsigned int out,
> +		      unsigned int in,
> +		      void *data,
> +		      gfp_t gfp)
> +{
> +	struct scatterlist *sgs[2];
> +	unsigned int i;
> +
> +	sgs[0] = sg;
> +	sgs[1] = sg + out;
> +
> +	/* Workaround until callers pass well-formed sgs. */
> +	for (i = 0; i < out + in; i++)
> +		sg_unmark_end(sg + i);
> +
> +	sg_mark_end(sg + out + in - 1);
> +	if (out && in)
> +		sg_mark_end(sg + out - 1);
> +
> +	return virtqueue_add(_vq, sgs, out+in, out ? 1 : 0, in ? 1 : 0,
> +			     data, gfp);
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_add_buf);
> +
> +/**
> + * virtqueue_add_sgs - expose buffers to other end
> + * @vq: the struct virtqueue we're talking about.
> + * @sgs: array of terminated scatterlists.
> + * @out_num: the number of scatterlists readable by other side
> + * @in_num: the number of scatterlists which are writable (after readable ones)
> + * @data: the token identifying the buffer.
> + * @gfp: how to do memory allocations (if necessary).
> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
> + */
> +int virtqueue_add_sgs(struct virtqueue *_vq,
> +		      struct scatterlist *sgs[],
> +		      unsigned int out_sgs,
> +		      unsigned int in_sgs,
> +		      void *data,
> +		      gfp_t gfp)
> +{
> +	unsigned int i, total_sg;
> +
> +	/* Count them first. */
> +	for (i = total_sg = 0; i < out_sgs + in_sgs; i++) {
> +		struct scatterlist *sg;
> +		for (sg = sgs[i]; sg; sg = sg_next(sg))
> +			total_sg++;
> +	}
> +	return virtqueue_add(_vq, sgs, total_sg, out_sgs, in_sgs, data, gfp);
> +}
>  EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
>  
>  /**
> 

