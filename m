Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaE2XGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:06:18 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58181 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaE2XGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:06:17 -0400
Message-ID: <5387BD73.9030607@kernel.dk>
Date: Thu, 29 May 2014 17:06:27 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>, willy@linux.intel.com,
        sbradshaw@micron.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR> <53874374.2020302@kernel.dk> <alpine.LRH.2.03.1405291601150.25112@AMR>
In-Reply-To: <alpine.LRH.2.03.1405291601150.25112@AMR>
Content-Type: multipart/mixed;
 boundary="------------060304040604010700000505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060304040604010700000505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/29/2014 04:34 PM, Keith Busch wrote:
> On Thu, 29 May 2014, Jens Axboe wrote:
>> On 2014-05-28 21:07, Keith Busch wrote:
>> Barring any bugs in the code, then yes, this should work. On the
>> scsi-mq side, extensive error injection and pulling has been done, and
>> it seems to hold up fine now. The ioctl path would need to be audited.
> 
> It's a little different than scsi. This would be like pulling the drive and
> the HBA. In any case, it still looks like it works as expected.

That is true, but block/blk-mq generally only cares about whether the
device goes or not. So it should be pretty much the same for this case.

>>>> +static void req_completion(struct nvme_queue *nvmeq, void *ctx,
>>>>                         struct nvme_completion *cqe)
>>>> {
>>>>     struct nvme_iod *iod = ctx;
>>>> -    struct bio *bio = iod->private;
>>>> +    struct request *req = iod->private;
>>>> +
>>>>     u16 status = le16_to_cpup(&cqe->status) >> 1;
>>>>
>>>> -    if (unlikely(status)) {
>>>> -        if (!(status & NVME_SC_DNR ||
>>>> -                bio->bi_rw & REQ_FAILFAST_MASK) &&
>>>> -                (jiffies - iod->start_time) < IOD_TIMEOUT) {
>>>> -            if (!waitqueue_active(&nvmeq->sq_full))
>>>> -                add_wait_queue(&nvmeq->sq_full,
>>>> -                            &nvmeq->sq_cong_wait);
>>>> -            list_add_tail(&iod->node, &nvmeq->iod_bio);
>>>> -            wake_up(&nvmeq->sq_full);
>>>> -            return;
>>>> -        }
>>>> -    }
>>>
>>> Is blk-mq going to retry intermittently failed commands for me? It
>>> doesn't look like it will.
>>
>> Not sure what kind of behavior you are looking for here. If you can
>> expand on the above a bit, I'll gladly help sort it out. Only the
>> driver really knows if a particular request should be failed hard or
>> retried. So you'd probably have to track retry counts in the request
>> and reinsert/end as appropriate.
> 
> Some vendor's drives return a failure status for a command but fully
> expect a retry to be successul. It'd be addressing this bug:
> 
> bugzilla.kernel.org/show_bug.cgi?id=61061
> 
> The code being removed at the top of this function in the latest patch was
> taking care of the requeuing. I wasn't sure how many retries would be
> necessary, so I capped it at a total time instead of total tries. I'm told
> from 3rd parties that what we're doing is successful in their tests.

Ah I see, yes that code apparently got axed. The attached patch brings
it back. Totally untested, I'll try and synthetically hit it to ensure
that it does work. Note that it currently does unmap and iod free, so
the request comes back pristine. We could preserve that if we really
wanted to, I'm guessing it's not a big deal.

-- 
Jens Axboe


--------------060304040604010700000505
Content-Type: text/x-patch;
 name="nvme-retry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvme-retry.patch"

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 22d8013cd4ff..ccdd02fa6882 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -363,9 +363,14 @@ static void req_completion(struct nvme_queue *nvmeq, void *ctx,
 	}
 	nvme_free_iod(nvmeq->dev, iod);
 
-	if (unlikely(status))
+	if (unlikely(status)) {
+		if (!(status & NVME_SC_DNR || blk_noretry_request(req))
+		    && (jiffies - req->start_time) < req->timeout) {
+			blk_mq_requeue_request(req);
+			return;
+		}
 		req->errors = -EIO;
-	else
+	} else
 		req->errors = 0;
 
 	blk_mq_complete_request(req);

--------------060304040604010700000505--
