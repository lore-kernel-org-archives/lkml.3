Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaFBKIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:08:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaFBKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:08:23 -0400
Date: Mon, 2 Jun 2014 03:08:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
Message-ID: <20140602100821.GB30612@infradead.org>
References: <1401400285-25003-1-git-send-email-m@bjorling.me>
 <1401400285-25003-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401400285-25003-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> +		struct request *req, enum dma_data_direction dma_dir,
> +		int psegs)
>  {
>  	sg_init_table(iod->sg, psegs);
> +	iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
>  
> +	if (!dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir))
>  		return -ENOMEM;
>  
> +	return iod->nents;

Given how simple I'd suggest merging this into the only caller.

> +static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> +							struct nvme_ns *ns)
>  {
> +	struct request *req = iod->private;
>  	struct nvme_command *cmnd;
> +	u16 control = 0;
> +	u32 dsmgmt = 0;
>  
> +	spin_lock_irq(&nvmeq->q_lock);
> +	if (nvmeq->q_suspended) {
> +		spin_unlock_irq(&nvmeq->q_lock);
> +		return -EBUSY;
> +	}
>  
> +	if (req->cmd_flags & REQ_DISCARD) {
> +		nvme_submit_discard(nvmeq, ns, req, iod);
> +		goto end_submit;
> +	}
> +	if (req->cmd_flags & REQ_FLUSH) {
> +		nvme_submit_flush(nvmeq, ns, req->tag);
> +		goto end_submit;
> +	}

It would be nicer to have the locking and the the suspend check
in the caller, and then branch out to one function for each type
of request, especially as the caller already has special cases for
discard and zero-payload requests anyway.

> +static int nvme_queue_request(struct blk_mq_hw_ctx *hctx, struct request *req)
> +{

Can you call this nvme_queue_rq to match the method name?  Makes
grepping so much easier..  (ditto for the admin queue).

> +	struct nvme_ns *ns = hctx->queue->queuedata;
> +	struct nvme_queue *nvmeq = hctx->driver_data;
>  
> +	return nvme_submit_req_queue(nvmeq, ns, req);

What's the point of the serparate nvme_submit_req_queue function?

>  	spin_lock(&nvmeq->q_lock);
> -	nvme_process_cq(nvmeq);
> -	result = nvmeq->cqe_seen ? IRQ_HANDLED : IRQ_NONE;
> -	nvmeq->cqe_seen = 0;
> +	result = nvme_process_cq(nvmeq) ? IRQ_HANDLED : IRQ_NONE;

No other caller checks the nvme_process_cq return value, so it might
as well return the IRQ_ values directly.

> +static struct blk_mq_ops nvme_mq_admin_ops = {
> +	.queue_rq	= nvme_queue_admin_request,
> +	.map_queue	= blk_mq_map_queue,
> +	.init_hctx	= nvme_init_admin_hctx,
> +	.init_request	= nvme_init_admin_request,
> +	.timeout	= nvme_timeout,

Care to name these nvme_admin_<methodname> for easier grep-ability?

> +static int nvme_alloc_admin_tags(struct nvme_dev *dev)
> +{
> +	if (!dev->admin_rq) {

Why do you need the NULL check here?

> +		dev->admin_tagset.reserved_tags = 1;

What is the reserved tag for?

> +		dev->admin_rq = blk_mq_init_queue(&dev->admin_tagset);
> +		if (!dev->admin_rq) {
> +			memset(&dev->admin_tagset, 0,
> +						sizeof(dev->admin_tagset));
> +			blk_mq_free_tag_set(&dev->admin_tagset);

Why do you zero the tagset here before freeing it?

