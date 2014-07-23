Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaGWS6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:58:36 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50821 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:58:35 -0400
Message-ID: <53D005D6.8050302@bjorling.me>
Date: Wed, 23 Jul 2014 20:58:30 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, rlnelson@google.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v10] NVMe: Convert to blk-mq
References: <1404226382-7179-1-git-send-email-m@bjorling.me> <1404226382-7179-2-git-send-email-m@bjorling.me> <20140714124131.GA311@infradead.org>
In-Reply-To: <20140714124131.GA311@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 02:41 PM, Christoph Hellwig wrote:
>> +static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>> +			  unsigned int hctx_idx)
>> +	struct nvme_queue *nvmeq = dev->queues[
>> +					(hctx_idx % dev->queue_count) + 1];
>> +
>> +	/* nvmeq queues are shared between namespaces. We assume here that
>> +	 * blk-mq map the tags so they match up with the nvme queue tags */
>> +	if (!nvmeq->hctx)
>> +		nvmeq->hctx = hctx;
>> +	else
>> +		WARN_ON(nvmeq->hctx->tags != hctx->tags);
>
>
> This wrong to me, as you're overwriting the value of nvmeq->hctx for each
> new requeust_queue.  But nothing but ->tagsis ever used from nvmeq->hctx,
> so you shold rather set up nvmeq->tags in nvme_dev_add.

Ack

>
>> +static int nvme_init_request(void *data, struct request *req,
>> +				unsigned int hctx_idx, unsigned int rq_idx,
>> +				unsigned int numa_node)
>> +{
>> +	struct nvme_dev *dev = data;
>> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
>> +	struct nvme_queue *nvmeq = dev->queues[hctx_idx + 1];
>> +
>> +	WARN_ON(!nvmeq);
>> +	cmd->nvmeq = nvmeq;
>
> Shouldn't this fail instead of the warn_on?

Yes, ack

>
>> +static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>>   {
>> +	struct nvme_ns *ns = hctx->queue->queuedata;
>> +	struct nvme_queue *nvmeq = hctx->driver_data;
>> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
>>   	struct nvme_iod *iod;
>> +	enum dma_data_direction dma_dir;
>> +	int psegs = req->nr_phys_segments;
>> +	int result = BLK_MQ_RQ_QUEUE_BUSY;
>> +	/*
>> +	 * Requeued IO has already been prepped
>> +	 */
>> +	iod = req->special;
>> +	if (iod)
>> +		goto submit_iod;
>>
>> +	iod = nvme_alloc_iod(psegs, blk_rq_bytes(req), GFP_ATOMIC);
>>   	if (!iod)
>> +		return result;
>
> So there's still a memory allocation for each request here.  Any reason
> this can't be preallocated at least for reasonable sized I/O?

Not at all. I've kept from adding optimizations in the first pass. The 
patches following can implement the optimizations. Jens already has a 
patch for this in his tree. It also removes GFP_ATOMIC.

>
> No need for GFP_ATOMIC here either, and you probably need a mempool to
> guarantee forward progress.
>
>> +	if (req->cmd_flags & REQ_DISCARD) {
>>   		void *range;
>>   		/*
>>   		 * We reuse the small pool to allocate the 16-byte range here
>> @@ -752,33 +602,53 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
>>   		range = dma_pool_alloc(nvmeq->dev->prp_small_pool,
>>   						GFP_ATOMIC,
>>   						&iod->first_dma);
>> +		if (!range)
>> +			goto finish_cmd;
>>   		iod_list(iod)[0] = (__le64 *)range;
>>   		iod->npages = 0;
>>   	} else if (psegs) {
>> +		dma_dir = rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>> +
>> +		sg_init_table(iod->sg, psegs);
>> +		iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
>> +		if (!iod->nents) {
>> +			result = BLK_MQ_RQ_QUEUE_ERROR;
>> +			goto finish_cmd;
>>   		}
>> +
>> +		if (!dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir))
>> +			goto finish_cmd;
>> +
>> +		if (blk_rq_bytes(req) != nvme_setup_prps(nvmeq->dev, iod,
>> +						blk_rq_bytes(req), GFP_ATOMIC))
>> +			goto finish_cmd;
>> +	}
>
> Would be nice to factor these two into helpers, that could also avoid
> the submid_iod goto..

Agree. The q_suspended properly isn't necessary any more, I'll like to 
wait with this until its gone upstream, to keep the patch flow simple.

>
>> +
>> +	if (req->cmd_flags & REQ_DISCARD) {
>> +		nvme_submit_discard(nvmeq, ns, req, iod);
>> +		goto queued;
>> +	}
>> +
>> +	if (req->cmd_flags & REQ_FLUSH) {
>> +		nvme_submit_flush(nvmeq, ns, req->tag);
>> +		goto queued;
>>   	}
>> -	return 0;
>>
>> +	nvme_submit_iod(nvmeq, iod, ns);
>> + queued:
>
> A simple
>
> 	if (req->cmd_flags & REQ_DISCARD)
> 		nvme_submit_discard(nvmeq, ns, req, iod);
> 	else if if (req->cmd_flags & REQ_FLUSH)
> 		nvme_submit_flush(nvmeq, ns, req->tag);
> 	else
> 		nvme_submit_iod(nvmeq, iod, ns);
>
> seems preferable here.

Ack

>
>> +static void nvme_cancel_queue_ios(void *data, unsigned long *tag_map)
>>   {
>> +	struct nvme_queue *nvmeq = data;
>> +	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
>> +	unsigned int tag = 0;
>>
>> +	tag = 0;
>> +	do {
>> +		struct request *req;
>>   		void *ctx;
>>   		nvme_completion_fn fn;
>> +		struct nvme_cmd_info *cmd;
>>   		static struct nvme_completion cqe = {
>>   			.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1),
>>   		};
>> +		int qdepth = nvmeq == nvmeq->dev->queues[0] ?
>> +					nvmeq->dev->admin_tagset.queue_depth :
>> +					nvmeq->dev->tagset.queue_depth;
>>
>> +		/* zero'd bits are free tags */
>> +		tag = find_next_zero_bit(tag_map, qdepth, tag);
>> +		if (tag >= qdepth)
>> +			break;
>> +
>> +		req = blk_mq_tag_to_rq(hctx->tags, tag++);
>> +		cmd = blk_mq_rq_to_pdu(req);
>
> Seems like blk-mq would make your life easier by exporting an iterator
> that goes over each in-use request instead of the current
> blk_mq_tag_busy_iter prototype.  blk_mq_timeout_check would also be able
> to make use of that, so maybe that would be a good preparatory patch?

Yes. I'll prepare a patch and send it off to Jens.

>
>> +static enum blk_eh_timer_return nvme_timeout(struct request *req)
>>   {
>> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
>> +	struct nvme_queue *nvmeq = cmd->nvmeq;
>>
>> +	dev_warn(nvmeq->q_dmadev, "Timeout I/O %d QID %d\n", req->tag,
>> +							nvmeq->qid);
>> +	if (nvmeq->dev->initialized)
>> +		nvme_abort_req(req);
>>
>> +	return BLK_EH_RESET_TIMER;
>> +}
>
> Aborting a request but then resetting the timer looks wrong to me.
>
> If that's indeed the intended behavior please add a comment explaining
> it.

Ack

>
>> +
>> +static int nvme_alloc_admin_tags(struct nvme_dev *dev)
>> +{
>> +	if (!dev->admin_q) {
>
> When would it be non-NULL?  Seems like the resume case might be the
> case, but I suspect the code could be restructured to avoid even calling
> nvme_alloc_admin_tags for that case.

Ack. I want to wait changing resume/suspend flow until its gone 
upstream. It should go into a separate patch.

>
>> +static void nvme_free_admin_tags(struct nvme_dev *dev)
>> +{
>> +	if (dev->admin_q)
>> +		blk_mq_free_tag_set(&dev->admin_tagset);
>> +}
>
> When would this be called with the admin queue not initialized?

Is it possible for a pci_driver->remove fn to be called during the probe 
phase? If not, then this could definitely be removed.

>
>> +static void nvme_dev_remove_admin(struct nvme_dev *dev)
>> +{
>> +	if (dev->admin_q && !blk_queue_dying(dev->admin_q))
>> +		blk_cleanup_queue(dev->admin_q);
>> +}
>
> Same here.
>

Thanks for taking the time to look through it.

