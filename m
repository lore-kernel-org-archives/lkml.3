Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaE2XM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:12:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54949 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE2XM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:12:27 -0400
Message-ID: <5387BEE5.6060007@kernel.dk>
Date: Thu, 29 May 2014 17:12:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>, willy@linux.intel.com,
        sbradshaw@micron.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR> <53874374.2020302@kernel.dk> <alpine.LRH.2.03.1405291601150.25112@AMR> <5387BD73.9030607@kernel.dk>
In-Reply-To: <5387BD73.9030607@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------070002010408080901070507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070002010408080901070507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/29/2014 05:06 PM, Jens Axboe wrote:
> Ah I see, yes that code apparently got axed. The attached patch brings
> it back. Totally untested, I'll try and synthetically hit it to ensure
> that it does work. Note that it currently does unmap and iod free, so
> the request comes back pristine. We could preserve that if we really
> wanted to, I'm guessing it's not a big deal.

And another totally untested patch that retains the iod and dma mapping
on the requeue event. Again, probably not a big deal, I'm assuming these
happen rarely, but it's simple enough to do.

-- 
Jens Axboe


--------------070002010408080901070507
Content-Type: text/x-patch;
 name="nvme-retry-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvme-retry-v2.patch"

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 22d8013cd4ff..fd3f11d837bb 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -357,17 +357,22 @@ static void req_completion(struct nvme_queue *nvmeq, void *ctx,
 
 	u16 status = le16_to_cpup(&cqe->status) >> 1;
 
+	if (unlikely(status)) {
+		if (!(status & NVME_SC_DNR || blk_noretry_request(req))
+		    && (jiffies - req->start_time) < req->timeout) {
+			blk_mq_requeue_request(req);
+			return;
+		}
+		req->errors = -EIO;
+	} else
+		req->errors = 0;
+
 	if (iod->nents) {
 		dma_unmap_sg(&nvmeq->dev->pci_dev->dev, iod->sg, iod->nents,
 			rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	}
 	nvme_free_iod(nvmeq->dev, iod);
 
-	if (unlikely(status))
-		req->errors = -EIO;
-	else
-		req->errors = 0;
-
 	blk_mq_complete_request(req);
 }
 
@@ -569,11 +574,19 @@ static int nvme_submit_req_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	enum dma_data_direction dma_dir;
 	int psegs = req->nr_phys_segments;
 
+	/*
+	 * Requeued IO has already been prepped
+	 */
+	iod = req->special;
+	if (iod)
+		goto submit_iod;
+
 	iod = nvme_alloc_iod(psegs, blk_rq_bytes(req), GFP_ATOMIC);
 	if (!iod)
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
 	iod->private = req;
+	req->special = iod;
 
 	nvme_set_info(cmd, iod, req_completion);
 
@@ -602,6 +615,7 @@ static int nvme_submit_req_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 			goto finish_cmd;
 	}
 
+ submit_iod:
 	if (!nvme_submit_iod(nvmeq, iod, ns))
 		return 0;
 

--------------070002010408080901070507--
