Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFDS2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:28:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:29529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbaFDS2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,974,1392192000"; 
   d="scan'208";a="549806005"
Date: Wed, 4 Jun 2014 12:28:22 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>, willy@linux.intel.com,
        sbradshaw@micron.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
In-Reply-To: <538EE3E6.60408@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406041146280.11244@AMR>
References: <1401742510-10827-1-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406021642480.11244@AMR> <alpine.LRH.2.03.1406021702530.11244@AMR> <538E2C2E.1010500@bjorling.me> <alpine.LRH.2.03.1406031553280.11244@AMR> <alpine.LRH.2.03.1406031625120.11244@AMR>
 <538EE3E6.60408@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1891402715-1401906502=:11244"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1891402715-1401906502=:11244
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 4 Jun 2014, Matias Bjørling wrote:
> On 06/04/2014 12:27 AM, Keith Busch wrote:
>>> On Tue, 3 Jun 2014, Matias Bjorling wrote:
>>>> 
>>>> Keith, will you take the nvmemq_wip_v6 branch for a spin? Thanks!
>> 
>> BTW, if you want to test this out yourself, it's pretty simple to
>> recreate. I just run a simple user admin program sending nvme passthrough
>> commands in a tight loop, then run:
>>
>>   # echo 1 > /sys/bus/pci/devices/<bdf>/remove
>
> I can't recreate- I use the nvme_get_feature program to continuously hit the 
> ioctl path, testing using your nvme qemu branch.

Okay, I'll try to fix it.

I think there are multiple problems, but the first is that since there
is no gendisk associated with the admin_q, the QUEUE_FLAG_INIT_DONE flag
is never set, and blk_mq_queue_enter returns successful whenever this
flag is not set even though this queue is dying, so we enter with all
its invalid pointers.

Here's a couple diff's. The first fixes the kernel oops by not entering a
dying queue. The second is just a few unrelated clean-ups in nvme-core.c.

I still can't complete my current hot-removal test, though; something
appears hung, but haven't nailed that down yet.

Please let me know what you think! Thanks.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d10013b..5a9ae8a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,6 +105,10 @@ static int blk_mq_queue_enter(struct request_queue *q)
  	__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
  	smp_wmb();
  	/* we have problems to freeze the queue if it's initializing */
+	if (blk_queue_dying(q)) {
+		__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
+		ret = -ENODEV;
+	}
  	if (!blk_queue_bypass(q) || !blk_queue_init_done(q))
  		return 0;

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 243a5e6..22e9c82 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -98,7 +98,6 @@ struct nvme_queue {
  	u8 cq_phase;
  	u8 cqe_seen;
  	u8 q_suspended;
-	cpumask_var_t cpu_mask;
  	struct async_cmd_info cmdinfo;
  	struct blk_mq_hw_ctx *hctx;
  };
@@ -1055,8 +1054,6 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
  				(void *)nvmeq->cqes, nvmeq->cq_dma_addr);
  	dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
  					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
-	if (nvmeq->qid)
-		free_cpumask_var(nvmeq->cpu_mask);
  	kfree(nvmeq);
  }

@@ -1066,9 +1063,9 @@ static void nvme_free_queues(struct nvme_dev *dev, int lowest)

  	for (i = dev->queue_count - 1; i >= lowest; i--) {
  		struct nvme_queue *nvmeq = dev->queues[i];
-		nvme_free_queue(nvmeq);
  		dev->queue_count--;
  		dev->queues[i] = NULL;
+		nvme_free_queue(nvmeq);
  	}
  }

@@ -1142,9 +1139,6 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
  	if (!nvmeq->sq_cmds)
  		goto free_cqdma;

-	if (qid && !zalloc_cpumask_var(&nvmeq->cpu_mask, GFP_KERNEL))
-		goto free_sqdma;
-
  	nvmeq->q_dmadev = dmadev;
  	nvmeq->dev = dev;
  	snprintf(nvmeq->irqname, sizeof(nvmeq->irqname), "nvme%dq%d",
@@ -1162,9 +1156,6 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,

  	return nvmeq;

- free_sqdma:
-	dma_free_coherent(dmadev, SQ_SIZE(depth), (void *)nvmeq->sq_cmds,
-							nvmeq->sq_dma_addr);
   free_cqdma:
  	dma_free_coherent(dmadev, CQ_SIZE(depth), (void *)nvmeq->cqes,
  							nvmeq->cq_dma_addr);
--8323328-1891402715-1401906502=:11244--
