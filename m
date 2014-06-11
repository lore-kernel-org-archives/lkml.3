Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaFKMrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:47:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaFKMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:47:33 -0400
Date: Wed, 11 Jun 2014 05:47:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@Parallels.com, venkateshs@google.com
Subject: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling uninitialized work
 items
Message-ID: <20140611124731.GA16990@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I get a second review on this one from anyone?

On Wed, Jun 04, 2014 at 01:34:56PM +0200, Paolo Bonzini wrote:
> Calling the workqueue interface on uninitialized work items isn't a
> good idea even if they're zeroed. It's not failing catastrophically only
> through happy accidents.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f0b4cdbfceb0..d66c4ee2c774 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -253,6 +253,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
>  	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
>  };
>  
> +static void virtscsi_handle_event(struct work_struct *work);
> +
>  static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  			       struct virtio_scsi_event_node *event_node)
>  {
> @@ -260,6 +262,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  	struct scatterlist sg;
>  	unsigned long flags;
>  
> +	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>  
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> @@ -377,7 +380,6 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
>  {
>  	struct virtio_scsi_event_node *event_node = buf;
>  
> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	schedule_work(&event_node->work);
>  }
>  
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
