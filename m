Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaHVPCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:02:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbaHVPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:02:19 -0400
Date: Fri, 22 Aug 2014 08:02:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC 1/4] xen, blkfront: add support for the multi-queue
 block layer API
Message-ID: <20140822150214.GA29424@infradead.org>
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
 <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arianna,

thanks for doing this work!

keeping both the legacy and blk-mq is fine for testing, but before you
submit the code for submission please make sure the blk-mq path
unconditionally better and remove the legacy one, similar to most
drivers we converted (virtio, mtip, soon nvme)

> +static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> +{
> +	struct blkfront_info *info = req->rq_disk->private_data;
> +
> +	pr_debug("Entered blkfront_queue_rq\n");
> +
> +	spin_lock_irq(&info->io_lock);
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


> +	if (blkif_queue_request(req)) {
> +wait:

Just a small style nipick: goto labels inside conditionals are not
very easy to undertand.  Just add another goto here and move the wait
label and its code to the very end of the function.

> +static int blkfront_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			  unsigned int index)
> +{
> +	return 0;
> +}

There is no need to have an empty implementation of this function,
the blk-mq code is fine with not having one.

> +static void blkfront_complete(struct request *req)
> +{
> +	blk_mq_end_io(req, req->errors);
> +}

No need to have this one either, blk_mq_end_io is the default I/O
completion implementation if no other one is provided.

> +		memset(&info->tag_set, 0, sizeof(info->tag_set));
> +		info->tag_set.ops = &blkfront_mq_ops;
> +		info->tag_set.nr_hw_queues = hardware_queues;
> +		info->tag_set.queue_depth = BLK_RING_SIZE;
> +		info->tag_set.numa_node = NUMA_NO_NODE;
> +		info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;

You probably also want the recently added BLK_MQ_F_SG_MERGE flag,
and maybe BLK_MQ_F_SHOULD_SORT depending on the speed of the device.

Does Xenstore expose something like a rotational flag to key off wether
we want to do guest side merging/scheduling?

> +		info->tag_set.cmd_size = 0;
> +		info->tag_set.driver_data = info;
> +
> +		if (blk_mq_alloc_tag_set(&info->tag_set))
> +			return -1;
> +		rq = blk_mq_init_queue(&info->tag_set);
> +		if (!rq) {
> +			blk_mq_free_tag_set(&info->tag_set);
> +			return -1;

It seems like returning -1 is the existing style in this driver, but
it's generaly preferable to return a real errno.

