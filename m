Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaFBLq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:46:58 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:38791 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaFBLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:46:57 -0400
Message-ID: <538C642B.3000107@bjorling.me>
Date: Mon, 02 Jun 2014 13:46:51 +0200
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
References: <1401400285-25003-1-git-send-email-m@bjorling.me> <1401400285-25003-2-git-send-email-m@bjorling.me> <20140602100821.GB30612@infradead.org>
In-Reply-To: <20140602100821.GB30612@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 12:08 PM, Christoph Hellwig wrote:
>> +static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
>> +		struct request *req, enum dma_data_direction dma_dir,
>> +		int psegs)
>>   {
>>   	sg_init_table(iod->sg, psegs);
>> +	iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
>>
>> +	if (!dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir))
>>   		return -ENOMEM;
>>
>> +	return iod->nents;
>
> Given how simple I'd suggest merging this into the only caller.

Ok

>
>> +static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
>> +							struct nvme_ns *ns)
>>   {
>> +	struct request *req = iod->private;
>>   	struct nvme_command *cmnd;
>> +	u16 control = 0;
>> +	u32 dsmgmt = 0;
>>
>> +	spin_lock_irq(&nvmeq->q_lock);
>> +	if (nvmeq->q_suspended) {
>> +		spin_unlock_irq(&nvmeq->q_lock);
>> +		return -EBUSY;
>> +	}
>>
>> +	if (req->cmd_flags & REQ_DISCARD) {
>> +		nvme_submit_discard(nvmeq, ns, req, iod);
>> +		goto end_submit;
>> +	}
>> +	if (req->cmd_flags & REQ_FLUSH) {
>> +		nvme_submit_flush(nvmeq, ns, req->tag);
>> +		goto end_submit;
>> +	}
>
> It would be nicer to have the locking and the the suspend check
> in the caller, and then branch out to one function for each type
> of request, especially as the caller already has special cases for
> discard and zero-payload requests anyway.
>

Ok, good idea.

>> +static int nvme_queue_request(struct blk_mq_hw_ctx *hctx, struct request *req)
>> +{
>
> Can you call this nvme_queue_rq to match the method name?  Makes
> grepping so much easier..  (ditto for the admin queue).
>

Yes

>> +	struct nvme_ns *ns = hctx->queue->queuedata;
>> +	struct nvme_queue *nvmeq = hctx->driver_data;
>>
>> +	return nvme_submit_req_queue(nvmeq, ns, req);
>
> What's the point of the serparate nvme_submit_req_queue function?
>

Removed

>>   	spin_lock(&nvmeq->q_lock);
>> -	nvme_process_cq(nvmeq);
>> -	result = nvmeq->cqe_seen ? IRQ_HANDLED : IRQ_NONE;
>> -	nvmeq->cqe_seen = 0;
>> +	result = nvme_process_cq(nvmeq) ? IRQ_HANDLED : IRQ_NONE;
>
> No other caller checks the nvme_process_cq return value, so it might
> as well return the IRQ_ values directly.

Ok (it's been changed as cqe_seen had been mistakenly removed.)
>
>> +static struct blk_mq_ops nvme_mq_admin_ops = {
>> +	.queue_rq	= nvme_queue_admin_request,
>> +	.map_queue	= blk_mq_map_queue,
>> +	.init_hctx	= nvme_init_admin_hctx,
>> +	.init_request	= nvme_init_admin_request,
>> +	.timeout	= nvme_timeout,
>
> Care to name these nvme_admin_<methodname> for easier grep-ability?

Yes

>
>> +static int nvme_alloc_admin_tags(struct nvme_dev *dev)
>> +{
>> +	if (!dev->admin_rq) {
>
> Why do you need the NULL check here?

the nvme_alloc_admin_tags is called both in nvme_dev_start and 
nvme_dev_resume. To make sure we don't double allocated it check if its 
already been allocated.

>
>> +		dev->admin_tagset.reserved_tags = 1;
>
> What is the reserved tag for?

It was for flush. However, this way to do it has been removed in the 
later series.

>
>> +		dev->admin_rq = blk_mq_init_queue(&dev->admin_tagset);
>> +		if (!dev->admin_rq) {
>> +			memset(&dev->admin_tagset, 0,
>> +						sizeof(dev->admin_tagset));
>> +			blk_mq_free_tag_set(&dev->admin_tagset);
>
> Why do you zero the tagset here before freeing it?
>

Removed.

Thanks!

