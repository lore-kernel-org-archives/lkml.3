Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3JIHNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:13:05 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:46690 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3JIHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:12:53 -0400
Message-ID: <525501EF.8030301@bjorling.me>
Date: Wed, 09 Oct 2013 09:12:47 +0200
From: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: axboe@kernel.dk, willy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH RFC 2/2] NVMe: rfc blk-mq support
References: <1381224862-5299-1-git-send-email-m@bjorling.me> <1381224862-5299-3-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1310081254150.4763@AMR>
In-Reply-To: <alpine.LRH.2.03.1310081254150.4763@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback. I'll make a v2 and report back measurements of 
gain/loss for the machines I have available.

On 10/08/2013 10:59 PM, Keith Busch wrote:
> On Tue, 8 Oct 2013, Matias Bjørling wrote:
>> Convert the driver to blk mq.
>>
>> The patch consists of:
>>
>> * Initializion of mq data structures.
>> * Convert function calls from bio to request data structures.
>> * IO queues are split into an admin queue and io queues.
>> * bio splits are removed as it should be handled by block layer.
>>
>> Signed-off-by: Matias Bjørling <m@bjorling.me>
>
> I have no opinion right now if this is a good idea or not. I'll just
> comment on a couple issues on this implementation. Otherwise I think
> it's pretty neat and gave me a reason to explore multiqueues!
>
> First a couple minor suggestions:
>
> You might want to use "REQ_END" from the rq->cmd_flags to know if you
> should write the queue doorbell or not. Aggregating these would help
> most devices but we didn't have a good way of knowing before if this
> was the last request or not.
>
> Maybe change nvme_submit_bio_queue to return a BLK_MQ_RQ_QUEUE_ status
> so you don't need that switch statement after calling it.
>
> Must do something about requests that don't align to PRPs. I think you
> mentioned this in the outstanding work in [0/2].
>
>> struct nvme_queue *get_nvmeq(struct nvme_dev *dev)
>> {
>> -    return dev->queues[get_cpu() + 1];
>> +    get_cpu();
>> +    return dev->admin_queue;
>> }
>
> get_nvmeq now returns only the admin queue when it used to return only
> IO queues. This breaks NVME_IO and SG_IO ioctl handling.
>
>> +static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>> +              unsigned int i)
>> +{
>> +    struct nvme_ns *ns = data;
>> +    struct nvme_dev *dev = ns->dev;
>> +    struct nvme_queue *nq;
>> +
>> +    nq = nvme_create_queue(dev, i + 1, hctx->queue_depth, i);
>> +    if (IS_ERR(nq))
>> +        return PTR_ERR(nq);
>> +
>> +    hctx->driver_data = nq;
>> +
>> +    return 0;
>> +}
>
> This right here is the biggest problem with the implemenation. It is
> going to fail for every namespace but the first one since each namespace
> registers a multiqueue and each mulitqueue requires a hw context to
> work. The number of queues is for the device, not namespace, so only
> the first namespace is going to successfully return from nvme_init_hctx;
> the rest will be unable to create an NVMe IO queue for trying to create
> one with already allocated QID.
>
> You should instead create the IO queues on the device like how it was
> done before then just set the hctx->driver_data to dev->queues[i + 1]
> or something like.
>
>> +static enum blk_eh_timer_return nvme_timeout(struct request *rq)
>> +{
>> +    /* Currently the driver handle timeouts by itself */
>> +    return BLK_EH_NOT_HANDLED;
>> +}
>
> Need do something with the command timeouts here or somewhere. You've
> changed the driver to poll only on the admin queue for timed out commands,
> and left the multiqueue timeout a no-op.
