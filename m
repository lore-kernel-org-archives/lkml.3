Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3BNJXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:23:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab3BNJXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:23:48 -0500
Message-ID: <511CAD19.2010902@redhat.com>
Date: Thu, 14 Feb 2013 10:23:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <87r4kjjuyn.fsf@rustcorp.com.au>
In-Reply-To: <87r4kjjuyn.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/02/2013 07:00, Rusty Russell ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> This series adds a different set of APIs for adding a buffer to a
>> virtqueue.  The new API lets you pass the buffers piecewise, wrapping
>> multiple calls to virtqueue_add_sg between virtqueue_start_buf and
>> virtqueue_end_buf.  Letting drivers call virtqueue_add_sg multiple times
>> if they already have a scatterlist provided by someone else simplifies the
>> code and, for virtio-scsi, it saves the copying and related locking.
> 
> They are ugly though.  It's convoluted because we do actually know all
> the buffers at once, we don't need a piecemeal API.
> 
> As a result, you now have arbitrary changes to the indirect heuristic,
> because the API is now piecemeal.

Note that I have sent v2 of patch 1/9, keeping the original indirect
heuristic.  It was indeed a bad idea to conflate it in this series (it
was born there because originally virtqueue_add_buf was not sharing any
code, but now it's a different story)

> How about this as a first step?
> 
> virtio_ring: virtqueue_add_sgs, to add multiple sgs.
> 
> virtio_scsi and virtio_blk can really use these, to avoid their current
> hack of copying the whole sg array.
> 
> Signed-off-by: Ruty Russell <rusty@rustcorp.com.au> 

It's much better than the other prototype you had posted, but I still
dislike this...  You pay for additional counting of scatterlists when
the caller knows the number of buffers; and the nested loops aren't
free, either.

My piecemeal API tried hard to keep things as fast as virtqueue_add_buf
when possible; I'm worried that this approach requires a lot more
benchmarking.  Probably you would also need a fast-path
virtqueue_add_buf_single, and (unlike my version) that one couldn't
share much code if any with virtqueue_add_sgs.

So I can resend based on this patch, but I'm not sure it's really better...

Also, see below for a comment.

> @@ -197,8 +213,47 @@ int virtqueue_add_buf(struct virtqueue *_vq,
>  		      void *data,
>  		      gfp_t gfp)
>  {
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
> +	sg_unmark_end(sg + out + in);
> +	if (out && in)
> +		sg_unmark_end(sg + out);

What's this second sg_unmark_end block for?  Doesn't it access after the
end of sg?  If you wanted it to be sg_mark_end, that must be:

if (out)
	sg_mark_end(sg + out - 1);
if (in)
	sg_mark_end(sg + out + in - 1);

with a corresponding unmark afterwards.

Paolo

> +	return virtqueue_add_sgs(_vq, sgs, out ? 1 : 0, in ? 1 : 0, data, gfp);

> +}
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
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> -	unsigned int i, avail, uninitialized_var(prev);
> +	struct scatterlist *sg;
> +	unsigned int i, n, avail, uninitialized_var(prev), total_sg;
>  	int head;
>  
>  	START_USE(vq);
> @@ -218,46 +273,59 @@ int virtqueue_add_buf(struct virtqueue *_vq,
>  	}
>  #endif
>  
> +	/* Count them first. */
> +	for (i = total_sg = 0; i < out_sgs + in_sgs; i++) {
> +		struct scatterlist *sg;
> +		for (sg = sgs[i]; sg; sg = sg_next(sg))
> +			total_sg++;
> +	}
> +
> +
>  	/* If the host supports indirect descriptor tables, and we have multiple
>  	 * buffers, then go indirect. FIXME: tune this threshold */
> -	if (vq->indirect && (out + in) > 1 && vq->vq.num_free) {
> -		head = vring_add_indirect(vq, sg, out, in, gfp);
> +	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
> +		head = vring_add_indirect(vq, sgs, total_sg, out_sgs, in_sgs,
> +					  gfp);
>  		if (likely(head >= 0))
>  			goto add_head;
>  	}
>  
> -	BUG_ON(out + in > vq->vring.num);
> -	BUG_ON(out + in == 0);
> +	BUG_ON(total_sg > vq->vring.num);
> +	BUG_ON(total_sg == 0);
>  
> -	if (vq->vq.num_free < out + in) {
> +	if (vq->vq.num_free < total_sg) {
>  		pr_debug("Can't add buf len %i - avail = %i\n",
> -			 out + in, vq->vq.num_free);
> +			 total_sg, vq->vq.num_free);
>  		/* FIXME: for historical reasons, we force a notify here if
>  		 * there are outgoing parts to the buffer.  Presumably the
>  		 * host should service the ring ASAP. */
> -		if (out)
> +		if (out_sgs)
>  			vq->notify(&vq->vq);
>  		END_USE(vq);
>  		return -ENOSPC;
>  	}
>  
>  	/* We're about to use some buffers from the free list. */
> -	vq->vq.num_free -= out + in;
> -
> -	head = vq->free_head;
> -	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
> -		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
> -		vq->vring.desc[i].addr = sg_phys(sg);
> -		vq->vring.desc[i].len = sg->length;
> -		prev = i;
> -		sg++;
> +	vq->vq.num_free -= total_sg;
> +
> +	head = i = vq->free_head;
> +	for (n = 0; n < out_sgs; n++) {
> +		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
> +			vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
> +			vq->vring.desc[i].addr = sg_phys(sg);
> +			vq->vring.desc[i].len = sg->length;
> +			prev = i;
> +			i = vq->vring.desc[i].next;
> +		}
>  	}
> -	for (; in; i = vq->vring.desc[i].next, in--) {
> -		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
> -		vq->vring.desc[i].addr = sg_phys(sg);
> -		vq->vring.desc[i].len = sg->length;
> -		prev = i;
> -		sg++;
> +	for (; n < (out_sgs + in_sgs); n++) {
> +		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
> +			vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
> +			vq->vring.desc[i].addr = sg_phys(sg);
> +			vq->vring.desc[i].len = sg->length;
> +			prev = i;
> +			i = vq->vring.desc[i].next;
> +		}
>  	}
>  	/* Last one doesn't continue. */
>  	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index ff6714e..6eff15b 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -40,6 +40,13 @@ int virtqueue_add_buf(struct virtqueue *vq,
>  		      void *data,
>  		      gfp_t gfp);
>  
> +int virtqueue_add_sgs(struct virtqueue *vq,
> +		      struct scatterlist *sgs[],
> +		      unsigned int out_sgs,
> +		      unsigned int in_sgs,
> +		      void *data,
> +		      gfp_t gfp);
> +
>  void virtqueue_kick(struct virtqueue *vq);
>  
>  bool virtqueue_kick_prepare(struct virtqueue *vq);
> 

