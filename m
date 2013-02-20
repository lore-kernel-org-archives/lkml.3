Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab3BTJUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab3BTJUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:20:22 -0500
Message-ID: <51249542.9040008@redhat.com>
Date: Wed, 20 Feb 2013 17:20:02 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/16] virtio-blk: use virtqueue_add_sgs on req path
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-6-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-6-git-send-email-rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> (This is a respin of Paolo Bonzini's patch, but it calls
> virtqueue_add_sgs() instead of his multi-part API).
> 
> This is similar to the previous patch, but a bit more radical
> because the bio and req paths now share the buffer construction
> code.  Because the req path doesn't use vbr->sg, however, we
> need to add a couple of arguments to __virtblk_add_req.
> 
> We also need to teach __virtblk_add_req how to build SCSI command
> requests.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


Reviewed-by: Asias He <asias@redhat.com>


> ---
>  drivers/block/virtio_blk.c |   69 +++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index e27bc6c..523a70f 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -102,19 +102,40 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
>  }
>  
>  static int __virtblk_add_req(struct virtqueue *vq,
> -			     struct virtblk_req *vbr)
> +			     struct virtblk_req *vbr,
> +			     struct scatterlist *data_sg,
> +			     unsigned data_nents)
>  {
> -	struct scatterlist hdr, tailer, *sgs[3];
> +	struct scatterlist hdr, tailer, cmd, sense, inhdr, *sgs[6];
>  	unsigned int num_out = 0, num_in = 0;
> +	int type = vbr->out_hdr.type & ~VIRTIO_BLK_T_OUT;
>  
>  	sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
>  	sgs[num_out++] = &hdr;
>  
> -	if (vbr->nents) {
> +	/*
> +	 * If this is a packet command we need a couple of additional headers.
> +	 * Behind the normal outhdr we put a segment with the scsi command
> +	 * block, and before the normal inhdr we put the sense data and the
> +	 * inhdr with additional status information.
> +	 */
> +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
> +		sg_init_one(&cmd, vbr->req->cmd, vbr->req->cmd_len);
> +		sgs[num_out++] = &cmd;
> +	}
> +
> +	if (data_nents) {
>  		if (vbr->out_hdr.type & VIRTIO_BLK_T_OUT)
> -			sgs[num_out++] = vbr->sg;
> +			sgs[num_out++] = data_sg;
>  		else
> -			sgs[num_out + num_in++] = vbr->sg;
> +			sgs[num_out + num_in++] = data_sg;
> +	}
> +
> +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
> +		sg_init_one(&sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
> +		sgs[num_out + num_in++] = &sense;
> +		sg_init_one(&inhdr, &vbr->in_hdr, sizeof(vbr->in_hdr));
> +		sgs[num_out + num_in++] = &inhdr;
>  	}
>  
>  	sg_init_one(&tailer, &vbr->status, sizeof(vbr->status));
> @@ -130,7 +151,8 @@ static void virtblk_add_req(struct virtblk_req *vbr)
>  	int ret;
>  
>  	spin_lock_irq(vblk->disk->queue->queue_lock);
> -	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr)) < 0)) {
> +	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr, vbr->sg,
> +						 vbr->nents)) < 0)) {
>  		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
>  					  TASK_UNINTERRUPTIBLE);
>  
> @@ -283,7 +305,7 @@ static void virtblk_done(struct virtqueue *vq)
>  static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
>  		   struct request *req)
>  {
> -	unsigned long num, out = 0, in = 0;
> +	unsigned int num;
>  	struct virtblk_req *vbr;
>  
>  	vbr = virtblk_alloc_req(vblk, GFP_ATOMIC);
> @@ -320,40 +342,15 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
>  		}
>  	}
>  
> -	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
> -
> -	/*
> -	 * If this is a packet command we need a couple of additional headers.
> -	 * Behind the normal outhdr we put a segment with the scsi command
> -	 * block, and before the normal inhdr we put the sense data and the
> -	 * inhdr with additional status information before the normal inhdr.
> -	 */
> -	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
> -		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
> -
> -	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
> -
> -	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
> -		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
> -		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
> -			   sizeof(vbr->in_hdr));
> -	}
> -
> -	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
> -		   sizeof(vbr->status));
> -
> +	num = blk_rq_map_sg(q, vbr->req, vblk->sg);
>  	if (num) {
> -		if (rq_data_dir(vbr->req) == WRITE) {
> +		if (rq_data_dir(vbr->req) == WRITE)
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
> -			out += num;
> -		} else {
> +		else
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
> -			in += num;
> -		}
>  	}
>  
> -	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr,
> -			      GFP_ATOMIC) < 0) {
> +	if (__virtblk_add_req(vblk->vq, vbr, vblk->sg, num) < 0) {
>  		mempool_free(vbr, vblk->pool);
>  		return false;
>  	}
> 


-- 
Asias
