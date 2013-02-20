Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000Ab3BTKyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab3BTKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:54:19 -0500
Message-ID: <5124AB50.8050702@redhat.com>
Date: Wed, 20 Feb 2013 11:54:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: rusty@rustcorp.com.au, asias@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 17/16 V2] virtio-scsi: use virtqueue_add_sgs for command
 buffers
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361353639-10623-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1361353639-10623-1-git-send-email-gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/02/2013 10:47, Wanlong Gao ha scritto:
> Using the new virtqueue_add_sgs function lets us simplify the queueing
> path.  In particular, all data protected by the tgt_lock is just gone
> (multiqueue will find a new use for the lock).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Rusty, please put this after patch 7 in your series.

Thanks Wanlong!

Paolo

> ---
> V1->V2:
> 	add the lost comments (Asias)
> 
>  drivers/scsi/virtio_scsi.c | 91 +++++++++++++++++-----------------------------
>  1 file changed, 34 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 3449a1f..bae0c95 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -59,11 +59,8 @@ struct virtio_scsi_vq {
>  
>  /* Per-target queue state */
>  struct virtio_scsi_target_state {
> -	/* Protects sg.  Lock hierarchy is tgt_lock -> vq_lock.  */
> +	/* Never held at the same time as vq_lock.  */
>  	spinlock_t tgt_lock;
> -
> -	/* For sglist construction when adding commands to the virtqueue.  */
> -	struct scatterlist sg[];
>  };
>  
>  /* Driver instance state */
> @@ -351,75 +348,61 @@ static void virtscsi_event_done(struct virtqueue *vq)
>  	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
>  };
>  
> -static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
> -			     struct scsi_data_buffer *sdb)
> -{
> -	struct sg_table *table = &sdb->table;
> -	struct scatterlist *sg_elem;
> -	unsigned int idx = *p_idx;
> -	int i;
> -
> -	for_each_sg(table->sgl, sg_elem, table->nents, i)
> -		sg[idx++] = *sg_elem;
> -
> -	*p_idx = idx;
> -}
> -
>  /**
> - * virtscsi_map_cmd - map a scsi_cmd to a virtqueue scatterlist
> - * @vscsi	: virtio_scsi state
> + * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
> + * @vq		: the struct virtqueue we're talking about
>   * @cmd		: command structure
> - * @out_num	: number of read-only elements
> - * @in_num	: number of write-only elements
>   * @req_size	: size of the request buffer
>   * @resp_size	: size of the response buffer
> - *
> - * Called with tgt_lock held.
> + * @gfp	: flags to use for memory allocations
>   */
> -static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
> -			     struct virtio_scsi_cmd *cmd,
> -			     unsigned *out_num, unsigned *in_num,
> -			     size_t req_size, size_t resp_size)
> +static int virtscsi_add_cmd(struct virtqueue *vq,
> +			    struct virtio_scsi_cmd *cmd,
> +			    size_t req_size, size_t resp_size, gfp_t gfp)
>  {
>  	struct scsi_cmnd *sc = cmd->sc;
> -	struct scatterlist *sg = tgt->sg;
> -	unsigned int idx = 0;
> +	struct scatterlist *sgs[4], req, resp;
> +	struct sg_table *out, *in;
> +	unsigned out_num = 0, in_num = 0;
> +
> +	out = in = NULL;
> +
> +	if (sc && sc->sc_data_direction != DMA_NONE) {
> +		if (sc->sc_data_direction != DMA_FROM_DEVICE)
> +			out = &scsi_out(sc)->table;
> +		if (sc->sc_data_direction != DMA_TO_DEVICE)
> +			in = &scsi_in(sc)->table;
> +	}
>  
>  	/* Request header.  */
> -	sg_set_buf(&sg[idx++], &cmd->req, req_size);
> +	sg_init_one(&req, &cmd->req, req_size);
> +	sgs[out_num++] = &req;
>  
>  	/* Data-out buffer.  */
> -	if (sc && sc->sc_data_direction != DMA_FROM_DEVICE)
> -		virtscsi_map_sgl(sg, &idx, scsi_out(sc));
> -
> -	*out_num = idx;
> +	if (out)
> +		sgs[out_num++] = out->sgl;
>  
>  	/* Response header.  */
> -	sg_set_buf(&sg[idx++], &cmd->resp, resp_size);
> +	sg_init_one(&resp, &cmd->resp, resp_size);
> +	sgs[out_num + in_num++] = &resp;
>  
>  	/* Data-in buffer */
> -	if (sc && sc->sc_data_direction != DMA_TO_DEVICE)
> -		virtscsi_map_sgl(sg, &idx, scsi_in(sc));
> +	if (in)
> +		sgs[out_num + in_num++] = in->sgl;
>  
> -	*in_num = idx - *out_num;
> +	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
>  }
>  
> -static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
> -			     struct virtio_scsi_vq *vq,
> +static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
>  			     struct virtio_scsi_cmd *cmd,
>  			     size_t req_size, size_t resp_size, gfp_t gfp)
>  {
> -	unsigned int out_num, in_num;
>  	unsigned long flags;
>  	int err;
>  	bool needs_kick = false;
>  
> -	spin_lock_irqsave(&tgt->tgt_lock, flags);
> -	virtscsi_map_cmd(tgt, cmd, &out_num, &in_num, req_size, resp_size);
> -
> -	spin_lock(&vq->vq_lock);
> -	err = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
> -	spin_unlock(&tgt->tgt_lock);
> +	spin_lock_irqsave(&vq->vq_lock, flags);
> +	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size, gfp);
>  	if (!err)
>  		needs_kick = virtqueue_kick_prepare(vq->vq);
>  
> @@ -433,7 +416,6 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
>  static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  {
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> -	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
>  	struct virtio_scsi_cmd *cmd;
>  	int ret;
>  
> @@ -467,7 +449,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
>  
> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
> +	if (virtscsi_kick_cmd(&vscsi->req_vq, cmd,
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>  			      GFP_ATOMIC) == 0)
>  		ret = 0;
> @@ -481,11 +463,10 @@ out:
>  static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>  {
>  	DECLARE_COMPLETION_ONSTACK(comp);
> -	struct virtio_scsi_target_state *tgt = vscsi->tgt[cmd->sc->device->id];
>  	int ret = FAILED;
>  
>  	cmd->comp = &comp;
> -	if (virtscsi_kick_cmd(tgt, &vscsi->ctrl_vq, cmd,
> +	if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
>  			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
>  			      GFP_NOIO) < 0)
>  		goto out;
> @@ -591,15 +572,11 @@ static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
>  	struct virtio_scsi_target_state *tgt;
>  	gfp_t gfp_mask = GFP_KERNEL;
>  
> -	/* We need extra sg elements at head and tail.  */
> -	tgt = kmalloc(sizeof(*tgt) + sizeof(tgt->sg[0]) * (sg_elems + 2),
> -		      gfp_mask);
> -
> +	tgt = kmalloc(sizeof(*tgt), gfp_mask);
>  	if (!tgt)
>  		return NULL;
>  
>  	spin_lock_init(&tgt->tgt_lock);
> -	sg_init_table(tgt->sg, sg_elems + 2);
>  	return tgt;
>  }
>  
> 

