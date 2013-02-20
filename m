Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab3BTJUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:20:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995Ab3BTJUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:20:49 -0500
Message-ID: <5124956B.4060306@redhat.com>
Date: Wed, 20 Feb 2013 17:20:43 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/16] virtio_blk: remove nents member.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-7-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-7-git-send-email-rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> It's simply a flag as to whether we have data now, so make it an
> explicit function parameter rather than a member of struct
> virtblk_req.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


Reviewed-by: Asias He <asias@redhat.com>


> ---
>  drivers/block/virtio_blk.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 523a70f..6369cb9 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -62,7 +62,6 @@ struct virtblk_req
>  	struct virtio_blk *vblk;
>  	int flags;
>  	u8 status;
> -	int nents;
>  	struct scatterlist sg[];
>  };
>  
> @@ -104,7 +103,7 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
>  static int __virtblk_add_req(struct virtqueue *vq,
>  			     struct virtblk_req *vbr,
>  			     struct scatterlist *data_sg,
> -			     unsigned data_nents)
> +			     bool have_data)
>  {
>  	struct scatterlist hdr, tailer, cmd, sense, inhdr, *sgs[6];
>  	unsigned int num_out = 0, num_in = 0;
> @@ -124,7 +123,7 @@ static int __virtblk_add_req(struct virtqueue *vq,
>  		sgs[num_out++] = &cmd;
>  	}
>  
> -	if (data_nents) {
> +	if (have_data) {
>  		if (vbr->out_hdr.type & VIRTIO_BLK_T_OUT)
>  			sgs[num_out++] = data_sg;
>  		else
> @@ -144,7 +143,7 @@ static int __virtblk_add_req(struct virtqueue *vq,
>  	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
>  }
>  
> -static void virtblk_add_req(struct virtblk_req *vbr)
> +static void virtblk_add_req(struct virtblk_req *vbr, bool have_data)
>  {
>  	struct virtio_blk *vblk = vbr->vblk;
>  	DEFINE_WAIT(wait);
> @@ -152,7 +151,7 @@ static void virtblk_add_req(struct virtblk_req *vbr)
>  
>  	spin_lock_irq(vblk->disk->queue->queue_lock);
>  	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr, vbr->sg,
> -						 vbr->nents)) < 0)) {
> +						 have_data)) < 0)) {
>  		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
>  					  TASK_UNINTERRUPTIBLE);
>  
> @@ -173,30 +172,31 @@ static void virtblk_bio_send_flush(struct virtblk_req *vbr)
>  	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
>  	vbr->out_hdr.sector = 0;
>  	vbr->out_hdr.ioprio = 0;
> -	vbr->nents = 0;
>  
> -	virtblk_add_req(vbr);
> +	virtblk_add_req(vbr, false);
>  }
>  
>  static void virtblk_bio_send_data(struct virtblk_req *vbr)
>  {
>  	struct virtio_blk *vblk = vbr->vblk;
>  	struct bio *bio = vbr->bio;
> +	bool have_data;
>  
>  	vbr->flags &= ~VBLK_IS_FLUSH;
>  	vbr->out_hdr.type = 0;
>  	vbr->out_hdr.sector = bio->bi_sector;
>  	vbr->out_hdr.ioprio = bio_prio(bio);
>  
> -	vbr->nents = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg);
> -	if (vbr->nents) {
> +	if (blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg)) {
> +		have_data = true;
>  		if (bio->bi_rw & REQ_WRITE)
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
>  		else
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
> -	}
> +	} else
> +		have_data = false;
>  
> -	virtblk_add_req(vbr);
> +	virtblk_add_req(vbr, have_data);
>  }
>  
>  static void virtblk_bio_send_data_work(struct work_struct *work)
> 


-- 
Asias
