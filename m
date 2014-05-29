Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaE2WeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:34:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:42892 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaE2WeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:34:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,936,1392192000"; 
   d="scan'208";a="546991408"
Date: Thu, 29 May 2014 16:34:00 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@kernel.dk>
cc: Keith Busch <keith.busch@intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        willy@linux.intel.com, sbradshaw@micron.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
In-Reply-To: <53874374.2020302@kernel.dk>
Message-ID: <alpine.LRH.2.03.1405291601150.25112@AMR>
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR> <53874374.2020302@kernel.dk>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Jens Axboe wrote:
> On 2014-05-28 21:07, Keith Busch wrote:
> Barring any bugs in the code, then yes, this should work. On the scsi-mq 
> side, extensive error injection and pulling has been done, and it seems to 
> hold up fine now. The ioctl path would need to be audited.

It's a little different than scsi. This would be like pulling the drive and
the HBA. In any case, it still looks like it works as expected.

>>> +static void req_completion(struct nvme_queue *nvmeq, void *ctx,
>>>                         struct nvme_completion *cqe)
>>> {
>>>     struct nvme_iod *iod = ctx;
>>> -    struct bio *bio = iod->private;
>>> +    struct request *req = iod->private;
>>> +
>>>     u16 status = le16_to_cpup(&cqe->status) >> 1;
>>> 
>>> -    if (unlikely(status)) {
>>> -        if (!(status & NVME_SC_DNR ||
>>> -                bio->bi_rw & REQ_FAILFAST_MASK) &&
>>> -                (jiffies - iod->start_time) < IOD_TIMEOUT) {
>>> -            if (!waitqueue_active(&nvmeq->sq_full))
>>> -                add_wait_queue(&nvmeq->sq_full,
>>> -                            &nvmeq->sq_cong_wait);
>>> -            list_add_tail(&iod->node, &nvmeq->iod_bio);
>>> -            wake_up(&nvmeq->sq_full);
>>> -            return;
>>> -        }
>>> -    }
>> 
>> Is blk-mq going to retry intermittently failed commands for me? It
>> doesn't look like it will.
>
> Not sure what kind of behavior you are looking for here. If you can expand on 
> the above a bit, I'll gladly help sort it out. Only the driver really knows 
> if a particular request should be failed hard or retried. So you'd probably 
> have to track retry counts in the request and reinsert/end as appropriate.

Some vendor's drives return a failure status for a command but fully
expect a retry to be successul. It'd be addressing this bug:

bugzilla.kernel.org/show_bug.cgi?id=61061

The code being removed at the top of this function in the latest patch was
taking care of the requeuing. I wasn't sure how many retries would be
necessary, so I capped it at a total time instead of total tries. I'm told
from 3rd parties that what we're doing is successful in their tests.
