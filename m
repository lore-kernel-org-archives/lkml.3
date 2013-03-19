Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3CSG5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:57:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3CSG5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:57:13 -0400
Date: Tue, 19 Mar 2013 14:57:00 +0800
From: Asias He <asias@redhat.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        pbonzini@redhat.com
Subject: Re: [PATCH V4 1/5] virtio-scsi: redo allocation of target data
Message-ID: <20130319065700.GB31573@hj.localdomain>
References: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:43:58AM +0800, Wanlong Gao wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> virtio_scsi_target_state is now empty, but we will find new uses
> for it in the next few patches.  However, dropping the sglist lets
> us turn the array-of-pointers into a simple array, which simplifies
> the allocation.
> 
> However, we do not leave the virtio_scsi_target_state structs in the
> flexible array member at the end of struct virtio_scsi, because
> we will place the virtqueues there in the next patches.
> 
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  drivers/scsi/virtio_scsi.c | 45 ++++++++++++---------------------------------
>  1 file changed, 12 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 6307099..75ccde1 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -76,7 +76,7 @@ struct virtio_scsi {
>  	/* Get some buffers ready for event vq */
>  	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
>  
> -	struct virtio_scsi_target_state *tgt[];
> +	struct virtio_scsi_target_state *tgt;
>  };
>  
>  static struct kmem_cache *virtscsi_cmd_cache;
> @@ -568,18 +568,9 @@ static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>  	virtscsi_vq->vq = vq;
>  }
>  
> -static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
> -	struct virtio_device *vdev, int sg_elems)
> +static void virtscsi_init_tgt(struct virtio_scsi_target_state *tgt)
>  {
> -	struct virtio_scsi_target_state *tgt;
> -	gfp_t gfp_mask = GFP_KERNEL;
> -
> -	tgt = kmalloc(sizeof(*tgt), gfp_mask);
> -	if (!tgt)
> -		return NULL;
> -
>  	spin_lock_init(&tgt->tgt_lock);
> -	return tgt;
>  }
>  
>  static void virtscsi_scan(struct virtio_device *vdev)
> @@ -593,17 +584,10 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
>  {
>  	struct Scsi_Host *sh = virtio_scsi_host(vdev);
>  	struct virtio_scsi *vscsi = shost_priv(sh);
> -	u32 i, num_targets;
>  
>  	/* Stop all the virtqueues. */
>  	vdev->config->reset(vdev);
> -
> -	num_targets = sh->max_id;
> -	for (i = 0; i < num_targets; i++) {
> -		kfree(vscsi->tgt[i]);
> -		vscsi->tgt[i] = NULL;
> -	}
> -
> +	kfree(vscsi->tgt);
>  	vdev->config->del_vqs(vdev);
>  }
>  
> @@ -612,7 +596,7 @@ static int virtscsi_init(struct virtio_device *vdev,
>  {
>  	int err;
>  	struct virtqueue *vqs[3];
> -	u32 i, sg_elems;
> +	u32 i;
>  
>  	vq_callback_t *callbacks[] = {
>  		virtscsi_ctrl_done,
> @@ -640,16 +624,14 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
>  		virtscsi_kick_event_all(vscsi);
>  
> -	/* We need to know how many segments before we allocate.  */
> -	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;

The drop of sg_elems does not belong to this patch. It should be done in
'virtio-scsi: use virtqueue_add_sgs for command buffers'.

> -	for (i = 0; i < num_targets; i++) {
> -		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev, sg_elems);
> -		if (!vscsi->tgt[i]) {
> -			err = -ENOMEM;
> -			goto out;
> -		}
> +	vscsi->tgt = kmalloc(num_targets * sizeof(vscsi->tgt[0]), GFP_KERNEL);
> +	if (!vscsi->tgt) {
> +		err = -ENOMEM;
> +		goto out;
>  	}
> +	for (i = 0; i < num_targets; i++)
> +		virtscsi_init_tgt(&vscsi->tgt[i]);
> +
>  	err = 0;
>  
>  out:
> @@ -668,10 +650,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  
>  	/* Allocate memory and link the structs together.  */
>  	num_targets = virtscsi_config_get(vdev, max_target) + 1;
> -	shost = scsi_host_alloc(&virtscsi_host_template,
> -		sizeof(*vscsi)
> -		+ num_targets * sizeof(struct virtio_scsi_target_state));
> -
> +	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
>  	if (!shost)
>  		return -ENOMEM;
>  
> -- 
> 1.8.2.rc2
> 

-- 
Asias
