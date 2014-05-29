Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213AbaE2O0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:26:01 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46961 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966AbaE2OZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:25:59 -0400
Message-ID: <53874374.2020302@kernel.dk>
Date: Thu, 29 May 2014 08:25:56 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>,
        =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
CC: willy@linux.intel.com, sbradshaw@micron.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR>
In-Reply-To: <alpine.LRH.2.03.1405281929460.4995@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-28 21:07, Keith Busch wrote:
> On Wed, 28 May 2014, Matias Bjørling wrote:
>> This converts the current NVMe driver to utilize the blk-mq layer.
>
> I am concerned about device hot removal since the h/w queues can be
> freed at any time. I *think* blk-mq helps with this in that the driver
> will not see a new request after calling blk_cleanup_queue. If you can
> confirm that's true and that blk-mq waits for all requests active in the
> driver to return to the block layer, then we're probably okay in this
> path. That wasn't true as a bio based driver which is why we are cautious
> with all the locking and barriers. But what about the IOCTL paths?

Barring any bugs in the code, then yes, this should work. On the scsi-mq 
side, extensive error injection and pulling has been done, and it seems 
to hold up fine now. The ioctl path would need to be audited.

>
> It also doesn't look like we're handling the case where the SGL can't
> map to a PRP.
>
>> +static void req_completion(struct nvme_queue *nvmeq, void *ctx,
>>                         struct nvme_completion *cqe)
>> {
>>     struct nvme_iod *iod = ctx;
>> -    struct bio *bio = iod->private;
>> +    struct request *req = iod->private;
>> +
>>     u16 status = le16_to_cpup(&cqe->status) >> 1;
>>
>> -    if (unlikely(status)) {
>> -        if (!(status & NVME_SC_DNR ||
>> -                bio->bi_rw & REQ_FAILFAST_MASK) &&
>> -                (jiffies - iod->start_time) < IOD_TIMEOUT) {
>> -            if (!waitqueue_active(&nvmeq->sq_full))
>> -                add_wait_queue(&nvmeq->sq_full,
>> -                            &nvmeq->sq_cong_wait);
>> -            list_add_tail(&iod->node, &nvmeq->iod_bio);
>> -            wake_up(&nvmeq->sq_full);
>> -            return;
>> -        }
>> -    }
>>     if (iod->nents) {
>> -        dma_unmap_sg(nvmeq->q_dmadev, iod->sg, iod->nents,
>> -            bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
>> -        nvme_end_io_acct(bio, iod->start_time);
>> +        dma_unmap_sg(&nvmeq->dev->pci_dev->dev, iod->sg, iod->nents,
>> +            rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
>>     }
>>     nvme_free_iod(nvmeq->dev, iod);
>> -    if (status)
>> -        bio_endio(bio, -EIO);
>> +
>> +    if (unlikely(status))
>> +        req->errors = -EIO;
>>     else
>> -        bio_endio(bio, 0);
>> +        req->errors = 0;
>> +
>> +    blk_mq_complete_request(req);
>> }
>
> Is blk-mq going to retry intermittently failed commands for me? It
> doesn't look like it will.

Not sure what kind of behavior you are looking for here. If you can 
expand on the above a bit, I'll gladly help sort it out. Only the driver 
really knows if a particular request should be failed hard or retried. 
So you'd probably have to track retry counts in the request and 
reinsert/end as appropriate.

>
>> +static int nvme_submit_flush_sync(struct nvme_queue *nvmeq, struct
>> nvme_ns *ns)
>> +{
>> +    struct request *req;
>> +    struct nvme_command cmnd;
>> +
>> +    req = blk_mq_alloc_request(ns->queue, WRITE, GFP_KERNEL, false);
>> +    if (!req)
>> +        return -ENOMEM;
>> +
>> +    nvme_setup_flush(&cmnd, ns, req->tag);
>> +    nvme_submit_sync_cmd(req, &cmnd, NULL, NVME_IO_TIMEOUT);
>>
>>     return 0;
>> }
>
> It looks like this function above is being called from an interrupt
> context where we are already holding a spinlock. The sync command will
> try to take that same lock.

Yes, that code still looks very buggy. The initial alloc for 
flush_cmd_info should also retry, not fail hard, if that alloc fails. 
For the reinsert part, Matias, you want to look at the flush code in 
blk-mq and how that handles it.

>> +    if ((req->cmd_flags & REQ_FLUSH) && psegs) {
>> +        struct flush_cmd_info *flush_cmd = kmalloc(
>> +                sizeof(struct flush_cmd_info), GFP_KERNEL);
>
> The comment above says "may not sleep", but using GFP_KERNEL here. I
> actually think it is safe to sleep, though since you're not taking a
> lock until later, so maybe you can change all the allocs to GFP_KERNEL?

It might be safe, and it might not be. It depends on the CPU mapping to 
the queue. preemption _could_ be off here (if needed), so GFP_KERNEL 
cannot be used. Additionally, see above comment on what to do on alloc 
failure.

-- 
Jens Axboe

