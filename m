Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaE2DHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:07:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:41425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbaE2DHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="539294414"
Date: Wed, 28 May 2014 21:07:46 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
In-Reply-To: <1401317998-8980-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1405281929460.4995@AMR>
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1777696569-1401332869=:4995"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1777696569-1401332869=:4995
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 28 May 2014, Matias Bjørling wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.

I am concerned about device hot removal since the h/w queues can be
freed at any time. I *think* blk-mq helps with this in that the driver
will not see a new request after calling blk_cleanup_queue. If you can
confirm that's true and that blk-mq waits for all requests active in the
driver to return to the block layer, then we're probably okay in this
path. That wasn't true as a bio based driver which is why we are cautious
with all the locking and barriers. But what about the IOCTL paths?

It also doesn't look like we're handling the case where the SGL can't
map to a PRP.

> +static void req_completion(struct nvme_queue *nvmeq, void *ctx,
> 						struct nvme_completion *cqe)
> {
> 	struct nvme_iod *iod = ctx;
> -	struct bio *bio = iod->private;
> +	struct request *req = iod->private;
> +
> 	u16 status = le16_to_cpup(&cqe->status) >> 1;
>
> -	if (unlikely(status)) {
> -		if (!(status & NVME_SC_DNR ||
> -				bio->bi_rw & REQ_FAILFAST_MASK) &&
> -				(jiffies - iod->start_time) < IOD_TIMEOUT) {
> -			if (!waitqueue_active(&nvmeq->sq_full))
> -				add_wait_queue(&nvmeq->sq_full,
> -							&nvmeq->sq_cong_wait);
> -			list_add_tail(&iod->node, &nvmeq->iod_bio);
> -			wake_up(&nvmeq->sq_full);
> -			return;
> -		}
> -	}
> 	if (iod->nents) {
> -		dma_unmap_sg(nvmeq->q_dmadev, iod->sg, iod->nents,
> -			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
> -		nvme_end_io_acct(bio, iod->start_time);
> +		dma_unmap_sg(&nvmeq->dev->pci_dev->dev, iod->sg, iod->nents,
> +			rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
> 	}
> 	nvme_free_iod(nvmeq->dev, iod);
> -	if (status)
> -		bio_endio(bio, -EIO);
> +
> +	if (unlikely(status))
> +		req->errors = -EIO;
> 	else
> -		bio_endio(bio, 0);
> +		req->errors = 0;
> +
> +	blk_mq_complete_request(req);
> }

Is blk-mq going to retry intermittently failed commands for me? It
doesn't look like it will.

> +static int nvme_submit_flush_sync(struct nvme_queue *nvmeq, struct nvme_ns *ns)
> +{
> +	struct request *req;
> +	struct nvme_command cmnd;
> +
> +	req = blk_mq_alloc_request(ns->queue, WRITE, GFP_KERNEL, false);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	nvme_setup_flush(&cmnd, ns, req->tag);
> +	nvme_submit_sync_cmd(req, &cmnd, NULL, NVME_IO_TIMEOUT);
>
> 	return 0;
> }

It looks like this function above is being called from an interrupt
context where we are already holding a spinlock. The sync command will
try to take that same lock.

> /*
> - * Called with local interrupts disabled and the q_lock held.  May not sleep.
> + * Called with preemption disabled, may not sleep.
>  */
> -static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> -								struct bio *bio)
> +static int nvme_submit_req_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> +							  struct request *req)
> {
> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
> 	struct nvme_iod *iod;
> -	int psegs = bio_phys_segments(ns->queue, bio);
> -	int result;
> +	enum dma_data_direction dma_dir;
> +	int psegs = req->nr_phys_segments;
>
> -	if ((bio->bi_rw & REQ_FLUSH) && psegs)
> -		return nvme_split_flush_data(nvmeq, bio);
> -
> -	iod = nvme_alloc_iod(psegs, bio->bi_iter.bi_size, GFP_ATOMIC);
> +	iod = nvme_alloc_iod(psegs, blk_rq_bytes(req), GFP_ATOMIC);
> 	if (!iod)
> -		return -ENOMEM;
> +		return BLK_MQ_RQ_QUEUE_BUSY;
> +
> +	iod->private = req;
> +
> +	nvme_set_info(cmd, iod, req_completion);
> +
> +	if ((req->cmd_flags & REQ_FLUSH) && psegs) {
> +		struct flush_cmd_info *flush_cmd = kmalloc(
> +				sizeof(struct flush_cmd_info), GFP_KERNEL);

The comment above says "may not sleep", but using GFP_KERNEL here. I
actually think it is safe to sleep, though since you're not taking a
lock until later, so maybe you can change all the allocs to GFP_KERNEL?

> +static struct blk_mq_ops nvme_mq_admin_ops = {
> +	.queue_rq	= nvme_queue_request,

I think you would get some unpredictable behavior if a request really
did go through nvme_queue_request on the admin queue. I don't see how
that would happen; just sayin.

> static void nvme_create_io_queues(struct nvme_dev *dev)
> {
> -	unsigned i, max;
> +	unsigned i;
>
> -	max = min(dev->max_qid, num_online_cpus());
> -	for (i = dev->queue_count; i <= max; i++)
> +	for (i = dev->queue_count; i <= dev->max_qid; i++)
> 		if (!nvme_alloc_queue(dev, i, dev->q_depth, i - 1))
> 			break;
>
> -	max = min(dev->queue_count - 1, num_online_cpus());
> -	for (i = dev->online_queues; i <= max; i++)
> -		if (nvme_create_queue(raw_nvmeq(dev, i), i))
> +	for (i = dev->online_queues; i <= dev->max_qid; i++)
> +		if (nvme_create_queue(dev->queues[i], i))
> 			break;
> }

I think your loop criteria is off. We may not have been successful in
allocating a queue to request the controller create it on its side,
so I don't think you want to use max_qid.

> +	dev->tagset.ops = &nvme_mq_ops;
> +	dev->tagset.nr_hw_queues = dev->queue_count - 1;

The queue_count is how many the driver allocated, but the controller
may not have successfully created it. The online_queues count is how
many the controller has available for use.
--8323328-1777696569-1401332869=:4995--
