Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3IQIzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3IQIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:55:37 -0400
Date: Tue, 17 Sep 2013 16:55:25 +0800
From: Asias He <asias@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dan Aloni <alonid@stratoscale.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, nab@linux-iscsi.org
Subject: Re: [PATCH] vhost/scsi: use vmalloc for order-10 allocation
Message-ID: <20130917085525.GB11609@hj.localdomain>
References: <1379401998-5131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379401998-5131-1-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:21:07AM +0300, Michael S. Tsirkin wrote:
> As vhost scsi device struct is large, if the device is
> created on a busy system, kzalloc() might fail, so this patch does a
> fallback to vzalloc().
> 
> As vmalloc() adds overhead on data-path, add __GFP_REPEAT
> to kzalloc() flags to do this fallback only when really needed.
> 
> Reported-by: Dan Aloni <alonid@stratoscale.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Asias He <asias@redhat.com>

> ---
> 
> I put this on my vhost fixes branch, intend to merge for 3.12.
> Dan, could you please confirm this works for you?
> 
>  drivers/vhost/scsi.c | 41 +++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4b79a1f..2c30bb0 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1373,21 +1373,30 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
>  	return 0;
>  }
>  
> +static void vhost_scsi_free(struct vhost_scsi *vs)
> +{
> +        if (is_vmalloc_addr(vs))
> +                vfree(vs);
> +        else
> +                kfree(vs);
> +}
> +
>  static int vhost_scsi_open(struct inode *inode, struct file *f)
>  {
>  	struct vhost_scsi *vs;
>  	struct vhost_virtqueue **vqs;
> -	int r, i;
> +	int r = -ENOMEM, i;
>  
> -	vs = kzalloc(sizeof(*vs), GFP_KERNEL);
> -	if (!vs)
> -		return -ENOMEM;
> +        vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
> +	if (!vs) {
> +		vs = vzalloc(sizeof(*vs));
> +		if (!vs)
> +			goto err_vs;
> +	}
>  
>  	vqs = kmalloc(VHOST_SCSI_MAX_VQ * sizeof(*vqs), GFP_KERNEL);
> -	if (!vqs) {
> -		kfree(vs);
> -		return -ENOMEM;
> -	}
> +	if (!vqs)
> +		goto err_vqs;
>  
>  	vhost_work_init(&vs->vs_completion_work, vhost_scsi_complete_cmd_work);
>  	vhost_work_init(&vs->vs_event_work, tcm_vhost_evt_work);
> @@ -1407,14 +1416,18 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>  
>  	tcm_vhost_init_inflight(vs, NULL);
>  
> -	if (r < 0) {
> -		kfree(vqs);
> -		kfree(vs);
> -		return r;
> -	}
> +	if (r < 0)
> +		goto err_init;
>  
>  	f->private_data = vs;
>  	return 0;
> +
> +err_init:
> +	kfree(vqs);
> +err_vqs:
> +	vhost_scsi_free(vs);
> +err_vs:
> +	return r;
>  }
>  
>  static int vhost_scsi_release(struct inode *inode, struct file *f)
> @@ -1431,7 +1444,7 @@ static int vhost_scsi_release(struct inode *inode, struct file *f)
>  	/* Jobs can re-queue themselves in evt kick handler. Do extra flush. */
>  	vhost_scsi_flush(vs);
>  	kfree(vs->dev.vqs);
> -	kfree(vs);
> +	vhost_scsi_free(vs);
>  	return 0;
>  }
>  
> -- 
> MST

-- 
Asias
