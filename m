Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaHNXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 19:09:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:17903 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaHNXJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 19:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,866,1400050800"; 
   d="scan'208";a="468903183"
Date: Thu, 14 Aug 2014 17:09:25 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@fb.com>
cc: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
In-Reply-To: <53ECD125.3080701@fb.com>
Message-ID: <alpine.LRH.2.03.1408141651300.14603@AMR>
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me>
 <53ECD125.3080701@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014, Jens Axboe wrote:
> nr_tags must be uninitialized or screwed up somehow, otherwise I don't
> see how that kmalloc() could warn on being too large. Keith, are you
> running with slab debugging? Matias, might be worth trying.

The allocation and freeing of blk-mq parts seems a bit asymmetrical
to me. The 'tags' belong to the tagset, but any request_queue using
that tagset may free the tags. I looked to separate the tag allocation
concerns, but that's more time than I have, so this is my quick-fix
driver patch, forcing tag access through the hw_ctx.

---
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 384dc91..91432d2 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -109,7 +109,7 @@ struct nvme_queue {
  	u8 cqe_seen;
  	u8 q_suspended;
  	struct async_cmd_info cmdinfo;
-	struct blk_mq_tags *tags;
+	struct blk_mq_hw_ctx *hctx;
  };

  /*
@@ -148,6 +148,7 @@ static int nvme_admin_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
  	struct nvme_queue *nvmeq = dev->queues[0];

  	hctx->driver_data = nvmeq;
+	nvmeq->hctx = hctx;
  	return 0;
  }

@@ -174,6 +175,7 @@ static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
  	irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector,
  								hctx->cpumask);
  	hctx->driver_data = nvmeq;
+	nvmeq->hctx = hctx;
  	return 0;
  }

@@ -280,8 +282,7 @@ static void async_completion(struct nvme_queue *nvmeq, void *ctx,
  static inline struct nvme_cmd_info *get_cmd_from_tag(struct nvme_queue *nvmeq,
  				  unsigned int tag)
  {
-	struct request *req = blk_mq_tag_to_rq(nvmeq->tags, tag);
-
+	struct request *req = blk_mq_tag_to_rq(nvmeq->hctx->tags, tag);
  	return blk_mq_rq_to_pdu(req);
  }

@@ -654,8 +655,6 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
  		nvme_submit_flush(nvmeq, ns, req->tag);
  	else
  		nvme_submit_iod(nvmeq, iod, ns);
-
- queued:
  	nvme_process_cq(nvmeq);
  	spin_unlock_irq(&nvmeq->q_lock);
  	return BLK_MQ_RQ_QUEUE_OK;
@@ -1051,9 +1050,8 @@ static void nvme_cancel_queue_ios(void *data, unsigned long *tag_map)
  		if (tag >= qdepth)
  			break;

-		req = blk_mq_tag_to_rq(nvmeq->tags, tag++);
+		req = blk_mq_tag_to_rq(nvmeq->hctx->tags, tag++);
  		cmd = blk_mq_rq_to_pdu(req);
  		if (cmd->ctx == CMD_CTX_CANCELLED)
  			continue;

@@ -1132,8 +1130,8 @@ static void nvme_clear_queue(struct nvme_queue *nvmeq)
  {
  	spin_lock_irq(&nvmeq->q_lock);
  	nvme_process_cq(nvmeq);
-	if (nvmeq->tags)
-		blk_mq_tag_busy_iter(nvmeq->tags, nvme_cancel_queue_ios, nvmeq);
+	if (nvmeq->hctx->tags)
+		blk_mq_tag_busy_iter(nvmeq->hctx->tags, nvme_cancel_queue_ios, nvmeq);
  	spin_unlock_irq(&nvmeq->q_lock);
  }

@@ -1353,8 +1351,6 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
  		if (blk_mq_alloc_tag_set(&dev->admin_tagset))
  			return -ENOMEM;

-		dev->queues[0]->tags = dev->admin_tagset.tags[0];
-
  		dev->admin_q = blk_mq_init_queue(&dev->admin_tagset);
  		if (!dev->admin_q) {
  			blk_mq_free_tag_set(&dev->admin_tagset);
@@ -2055,9 +2051,6 @@ static int nvme_dev_add(struct nvme_dev *dev)
  	if (blk_mq_alloc_tag_set(&dev->tagset))
  		goto out;

-	for (i = 1; i < dev->online_queues; i++)
-		dev->queues[i]->tags = dev->tagset.tags[i - 1];
-
  	id_ns = mem;
  	for (i = 1; i <= nn; i++) {
  		res = nvme_identify(dev, i, 0, dma_addr);
