Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaE2Tdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:33:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55497 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaE2Tds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:33:48 -0400
Message-ID: <53878BA6.7050907@kernel.dk>
Date: Thu, 29 May 2014 13:33:58 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>,
        =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
CC: willy@linux.intel.com, sbradshaw@micron.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR> <53874374.2020302@kernel.dk> <53878B5D.8040508@kernel.dk>
In-Reply-To: <53878B5D.8040508@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020204020405020301090704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020204020405020301090704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/29/2014 01:32 PM, Jens Axboe wrote:
> On 05/29/2014 08:25 AM, Jens Axboe wrote:
>>>> +static int nvme_submit_flush_sync(struct nvme_queue *nvmeq, struct
>>>> nvme_ns *ns)
>>>> +{
>>>> +    struct request *req;
>>>> +    struct nvme_command cmnd;
>>>> +
>>>> +    req = blk_mq_alloc_request(ns->queue, WRITE, GFP_KERNEL, false);
>>>> +    if (!req)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    nvme_setup_flush(&cmnd, ns, req->tag);
>>>> +    nvme_submit_sync_cmd(req, &cmnd, NULL, NVME_IO_TIMEOUT);
>>>>
>>>>     return 0;
>>>> }
>>>
>>> It looks like this function above is being called from an interrupt
>>> context where we are already holding a spinlock. The sync command will
>>> try to take that same lock.
>>
>> Yes, that code still looks very buggy. The initial alloc for
>> flush_cmd_info should also retry, not fail hard, if that alloc fails.
>> For the reinsert part, Matias, you want to look at the flush code in
>> blk-mq and how that handles it.
> 
> There's an easy fix for this. Once it's managed by blk-mq, blk-mq will
> decompose requests for you. This means a flush with data will be turned
> into two commands for you, so we can kill this code attempting to handle
> flush request with data.
> 
> Patch attached. Depending on how the series needs to look, the prep
> patch of support bio flush with data should just be dropped however. No
> point in adding that, and the removing it again.

Updated, we can kill the flush_cmd_info struct as well.

-- 
Jens Axboe


--------------020204020405020301090704
Content-Type: text/x-patch;
 name="nvme-flush-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvme-flush-v2.patch"

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ac695b336a98..4cd525ee5f4a 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -513,35 +513,6 @@ static void nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	writel(nvmeq->sq_tail, nvmeq->q_db);
 }
 
-static int nvme_submit_flush_sync(struct nvme_queue *nvmeq, struct nvme_ns *ns)
-{
-	struct request *req;
-	struct nvme_command cmnd;
-
-	req = blk_mq_alloc_request(ns->queue, WRITE, GFP_KERNEL, false);
-	if (!req)
-		return -ENOMEM;
-
-	nvme_setup_flush(&cmnd, ns, req->tag);
-	nvme_submit_sync_cmd(req, &cmnd, NULL, NVME_IO_TIMEOUT);
-
-	return 0;
-}
-
-struct flush_cmd_info {
-	struct nvme_ns *ns;
-	struct nvme_iod *iod;
-};
-
-static void req_flush_completion(struct nvme_queue *nvmeq, void *ctx,
-						struct nvme_completion *cqe)
-{
-	struct flush_cmd_info *flush_cmd = ctx;
-	nvme_submit_flush_sync(nvmeq, flush_cmd->ns);
-	req_completion(nvmeq, flush_cmd->iod, cqe);
-	kfree(flush_cmd);
-}
-
 static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 							struct nvme_ns *ns)
 {
@@ -560,7 +531,7 @@ static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		nvme_submit_discard(nvmeq, ns, req, iod);
 		goto end_submit;
 	}
-	if (req->cmd_flags & REQ_FLUSH && !iod->nents) {
+	if (req->cmd_flags & REQ_FLUSH) {
 		nvme_submit_flush(nvmeq, ns, req->tag);
 		goto end_submit;
 	}
@@ -615,16 +586,6 @@ static int nvme_submit_req_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 
 	nvme_set_info(cmd, iod, req_completion);
 
-	if ((req->cmd_flags & REQ_FLUSH) && psegs) {
-		struct flush_cmd_info *flush_cmd = kmalloc(
-				sizeof(struct flush_cmd_info), GFP_KERNEL);
-		if (!flush_cmd)
-			goto free_iod;
-		flush_cmd->ns = ns;
-		flush_cmd->iod = iod;
-		nvme_set_info(cmd, flush_cmd, req_flush_completion);
-	}
-
 	if (req->cmd_flags & REQ_DISCARD) {
 		void *range;
 		/*
@@ -655,7 +616,6 @@ static int nvme_submit_req_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 
  finish_cmd:
 	nvme_finish_cmd(nvmeq, req->tag, NULL);
- free_iod:
 	nvme_free_iod(nvmeq->dev, iod);
 	return BLK_MQ_RQ_QUEUE_ERROR;
 }

--------------020204020405020301090704--
