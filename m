Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaHVMZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:25:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16955 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbaHVMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:25:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,380,1406592000"; 
   d="scan'208";a="164135002"
Message-ID: <53F736BE.9010202@citrix.com>
Date: Fri, 22 Aug 2014 13:25:34 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 1/4] xen, blkfront: add support for the multi-queue
 block layer API
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 12:20, Arianna Avanzini wrote:
> This commit introduces support for the multi-queue block layer API.
> The changes are only structural, and force both the use of the
> multi-queue API and the use of a single I/O ring, by initializing
> statically the number of hardware queues to one.
[...]
> @@ -98,6 +99,8 @@ static unsigned int xen_blkif_max_segments = 32;
>  module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
>  MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
>  
> +static unsigned int hardware_queues = 1;
> +
>  #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
>  
>  /*
> @@ -134,6 +137,8 @@ struct blkfront_info
>  	unsigned int feature_persistent:1;
>  	unsigned int max_indirect_segments;
>  	int is_ready;
> +	/* Block layer tags. */
> +	struct blk_mq_tag_set tag_set;
>  };
>  
>  static unsigned int nr_minors;
> @@ -385,6 +390,7 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
>   * and writes are handled as expected.
>   *
>   * @req: a request struct
> + * @ring_idx: index of the ring the request is to be inserted in

This comment addition doesn't seem to correspond with anything?

>   */
>  static int blkif_queue_request(struct request *req)
>  {
> @@ -632,6 +638,61 @@ wait:
>  		flush_requests(info);
>  }
>  
> +static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> +{
> +	struct blkfront_info *info = req->rq_disk->private_data;
> +
> +	pr_debug("Entered blkfront_queue_rq\n");

I don't think this debug is useful.

> +	spin_lock_irq(&info->io_lock);

Is this lock necessary?  Does the block layer serialise calls to the
queue_rq op?

> +	if (RING_FULL(&info->ring))
> +		goto wait;
> +
> +	if ((req->cmd_type != REQ_TYPE_FS) ||
> +			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> +			 !info->flush_op)) {
> +		req->errors = -EIO;
> +		blk_mq_complete_request(req);
> +		spin_unlock_irq(&info->io_lock);
> +		return BLK_MQ_RQ_QUEUE_ERROR;
> +	}
> +
> +	pr_debug("blkfront_queue_req %p: cmd %p, sec %lx, ""(%u/%u) [%s]\n",
> +			req, req->cmd, (unsigned long)blk_rq_pos(req),
> +			blk_rq_cur_sectors(req), blk_rq_sectors(req),
> +			rq_data_dir(req) ? "write" : "read");

The block layer already has extensive tracing for requests.  Is this
debug useful?

> @@ -639,9 +700,29 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>  	struct request_queue *rq;
>  	struct blkfront_info *info = gd->private_data;
>  
> -	rq = blk_init_queue(do_blkif_request, &info->io_lock);
> -	if (rq == NULL)
> -		return -1;
> +	if (hardware_queues) {

hardware_queues is never 0.  Is this if here and elsewhere necessary?

David
