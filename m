Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3IFNhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:37:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3IFNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:37:19 -0400
Date: Fri, 6 Sep 2013 09:37:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] xen/blkback: fix reference counting
Message-ID: <20130906133708.GM2590@phenom.dumpdata.com>
References: <1378378814-23721-1-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378378814-23721-1-git-send-email-vegard.nossum@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:00:14PM +0200, Vegard Nossum wrote:
> If the permission check fails, we drop a reference to the blkif without
> having taken it in the first place. The bug was introduced in commit
> 604c499cbbcc3d5fe5fb8d53306aa0fae1990109 (xen/blkback: Check device
> permissions before allowing OP_DISCARD).
> 
> Cc: stable@vger.kernel.org
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you for spotting that. Let me stick it on my for-jens queue.

> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index bf4b9d2..6620b73 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -872,49 +872,50 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
>  	}
>  
>  unmap:
>  	if (segments)
>  		kunmap_atomic(segments);
>  	xen_blkbk_unmap(blkif, pages, indirect_grefs);
>  	return rc;
>  }
>  
>  static int dispatch_discard_io(struct xen_blkif *blkif,
>  				struct blkif_request *req)
>  {
>  	int err = 0;
>  	int status = BLKIF_RSP_OKAY;
>  	struct block_device *bdev = blkif->vbd.bdev;
>  	unsigned long secure;
>  	struct phys_req preq;
>  
> +	xen_blkif_get(blkif);
> +
>  	preq.sector_number = req->u.discard.sector_number;
>  	preq.nr_sects      = req->u.discard.nr_sectors;
>  
>  	err = xen_vbd_translate(&preq, blkif, WRITE);
>  	if (err) {
>  		pr_warn(DRV_PFX "access denied: DISCARD [%llu->%llu] on dev=%04x\n",
>  			preq.sector_number,
>  			preq.sector_number + preq.nr_sects, blkif->vbd.pdevice);
>  		goto fail_response;
>  	}
>  	blkif->st_ds_req++;
>  
> -	xen_blkif_get(blkif);
>  	secure = (blkif->vbd.discard_secure &&
>  		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
>  		 BLKDEV_DISCARD_SECURE : 0;
>  
>  	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
>  				   req->u.discard.nr_sectors,
>  				   GFP_KERNEL, secure);
>  fail_response:
>  	if (err == -EOPNOTSUPP) {
>  		pr_debug(DRV_PFX "discard op failed, not supported\n");
>  		status = BLKIF_RSP_EOPNOTSUPP;
>  	} else if (err)
>  		status = BLKIF_RSP_ERROR;
>  
>  	make_response(blkif, req->u.discard.id, req->operation, status);
>  	xen_blkif_put(blkif);
>  	return err;
>  }
> -- 
> 1.7.10.4
> 
