Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaJAUT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:19:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJAUT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:19:26 -0400
Date: Wed, 1 Oct 2014 16:18:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com
Subject: Re: [PATCH RFC v2 1/5] xen, blkfront: port to the the multi-queue
 block layer API
Message-ID: <20141001201851.GB12581@laptop.dumpdata.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
 <1410479844-2864-2-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479844-2864-2-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:57:20AM +0200, Arianna Avanzini wrote:
> This commit introduces support for the multi-queue block layer API,
> and at the same time removes the existing request_queue API support.
> The changes are only structural, and the number of supported hardware
> contexts is forcedly set to one.

Hey Arianna,

Thank you for posting them and sorry for the long time in reviewing it.

> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  drivers/block/xen-blkfront.c | 171 ++++++++++++++++++++-----------------------
>  1 file changed, 80 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 5deb235..109add6 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -37,6 +37,7 @@
>  
>  #include <linux/interrupt.h>
>  #include <linux/blkdev.h>
> +#include <linux/blk-mq.h>
>  #include <linux/hdreg.h>
>  #include <linux/cdrom.h>
>  #include <linux/module.h>
> @@ -134,6 +135,8 @@ struct blkfront_info
>  	unsigned int feature_persistent:1;
>  	unsigned int max_indirect_segments;
>  	int is_ready;
> +	/* Block layer tags. */
> +	struct blk_mq_tag_set tag_set;
>  };
>  
>  static unsigned int nr_minors;
> @@ -582,66 +585,69 @@ static inline void flush_requests(struct blkfront_info *info)
>  		notify_remote_via_irq(info->irq);
>  }
>  
> -/*
> - * do_blkif_request
> - *  read a block; request is in a request queue
> - */
> -static void do_blkif_request(struct request_queue *rq)

> +static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>  {
> -	struct blkfront_info *info = NULL;
> -	struct request *req;
> -	int queued;
> -
> -	pr_debug("Entered do_blkif_request\n");
> -
> -	queued = 0;
> -

This loop allowed us to queue up on the ring up to 32 requests
(or more depending depending on the options), and then when done
(or when no more could be fitted), call the 'flush_request'
which would update the producer index and kick the backend (if needed).

With the removal of the loop we could be called for each
I/O and do a bunch of : write in ring, update producer index, kick backend,
write in ring, update producer ring, kick backend, etc.


> -	while ((req = blk_peek_request(rq)) != NULL) {
> -		info = req->rq_disk->private_data;
> +	struct blkfront_info *info = req->rq_disk->private_data;
>  
> -		if (RING_FULL(&info->ring))
> -			goto wait;
> +	spin_lock_irq(&info->io_lock);
> +	if (RING_FULL(&info->ring))
> +		goto wait;
>  
> -		blk_start_request(req);
> +	if ((req->cmd_type != REQ_TYPE_FS) ||
> +			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> +			 !info->flush_op)) {

You had an earlier patch (xen, blkfront: factor out flush-related checks from do_blkif_request())

Which made that 'if' statement much nicer. I put said patch on the 3.18 train
for Jens - so once v3.18-rc1 is out you can rebase on that and pick this
up.

> +		req->errors = -EIO;
> +		blk_mq_complete_request(req);
> +		spin_unlock_irq(&info->io_lock);
> +		return BLK_MQ_RQ_QUEUE_ERROR;
> +	}
>  
> -		if ((req->cmd_type != REQ_TYPE_FS) ||
> -		    ((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> -		    !info->flush_op)) {
> -			__blk_end_request_all(req, -EIO);
> -			continue;
> -		}
> +	if (blkif_queue_request(req)) {
> +		blk_mq_requeue_request(req);
> +		goto wait;
> +	}
>  
> -		pr_debug("do_blk_req %p: cmd %p, sec %lx, "
> -			 "(%u/%u) [%s]\n",
> -			 req, req->cmd, (unsigned long)blk_rq_pos(req),
> -			 blk_rq_cur_sectors(req), blk_rq_sectors(req),
> -			 rq_data_dir(req) ? "write" : "read");
> +	flush_requests(info);
> +	spin_unlock_irq(&info->io_lock);
> +	return BLK_MQ_RQ_QUEUE_OK;
>  
> -		if (blkif_queue_request(req)) {
> -			blk_requeue_request(rq, req);
>  wait:
> -			/* Avoid pointless unplugs. */
> -			blk_stop_queue(rq);
> -			break;
> -		}
> -
> -		queued++;
> -	}
> -
> -	if (queued != 0)
> -		flush_requests(info);
> +	/* Avoid pointless unplugs. */
> +	blk_mq_stop_hw_queue(hctx);
> +	spin_unlock_irq(&info->io_lock);
> +	return BLK_MQ_RQ_QUEUE_BUSY;
>  }
>  
> +static struct blk_mq_ops blkfront_mq_ops = {
> +	.queue_rq = blkfront_queue_rq,
> +	.map_queue = blk_mq_map_queue,
> +};
> +
>  static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>  				unsigned int physical_sector_size,
>  				unsigned int segments)
>  {
>  	struct request_queue *rq;
>  	struct blkfront_info *info = gd->private_data;
> +	int ret;
> +
> +	memset(&info->tag_set, 0, sizeof(info->tag_set));

You can ditch that. In 'blkfront_probe' we use 'kzalloc' to setup
the 'info' structure so it is already set to zero values.

> +	info->tag_set.ops = &blkfront_mq_ops;
> +	info->tag_set.nr_hw_queues = 1;
> +	info->tag_set.queue_depth = BLK_RING_SIZE;

Could you add an simple comment (or I can do it when I pick v3):
/* TODO: Need to figure out how to square this with 'xen_blkif_max_segments' */

> +	info->tag_set.numa_node = NUMA_NO_NODE;
> +	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
> +	info->tag_set.cmd_size = 0;

Could you add an comment about why we have zero here? My recollection is
that we do not need it as we keep track of the request internally (for
migration purposes and if we did persistent mapping).

/*
 * And the reason we want it set to zero is because we want to be responsible
 * for page recycling (in case it is persistent and we need to manually
 * deal with unmapping it, etc).
 */

> +	info->tag_set.driver_data = info;

Or perhaps mention that since we have 'driver_data' we can access 'info'
and do all internal mapping/unmapping/etc on that.

