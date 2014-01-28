Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaA1Ihv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:37:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbaA1Ihu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:50 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 02/14] NVMe: Cleanup nvme_alloc_queue() and nvme_free_queue()
Date: Tue, 28 Jan 2014 09:38:48 +0100
Message-Id: <aa07e615e115fb53e96be756f3ac37b198a3dd23.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While nvme_alloc_queue() and nvme_free_queue() are logically
counterparts, they are inconsistent with regard to how device
queue_count is updated - it is increased within the former,
but decreased outside of the latter. This update fixes the
described inconsistency and also makes further improvements
to the functions code.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 3dfb0d4..60c6c05 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1137,6 +1137,9 @@ static void nvme_cancel_ios(struct nvme_queue *nvmeq, bool timeout)
 
 static void nvme_free_queue(struct nvme_queue *nvmeq)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+	int qid = nvmeq->qid;
+
 	spin_lock_irq(&nvmeq->q_lock);
 	while (bio_list_peek(&nvmeq->sq_cong)) {
 		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
@@ -1149,17 +1152,17 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
 	dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
 					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
 	kfree(nvmeq);
+
+	dev->queue_count--;
+	dev->queues[qid] = NULL;
 }
 
 static void nvme_free_queues(struct nvme_dev *dev, int lowest)
 {
 	int i;
 
-	for (i = dev->queue_count - 1; i >= lowest; i--) {
+	for (i = dev->queue_count - 1; i >= lowest; i--)
 		nvme_free_queue(dev->queues[i]);
-		dev->queue_count--;
-		dev->queues[i] = NULL;
-	}
 }
 
 /**
@@ -1245,6 +1248,8 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	nvmeq->cq_vector = vector;
 	nvmeq->qid = qid;
 	nvmeq->q_suspended = 1;
+
+	dev->queues[qid] = nvmeq;
 	dev->queue_count++;
 
 	return nvmeq;
@@ -1394,7 +1399,6 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 		nvmeq = nvme_alloc_queue(dev, 0, 64, 0);
 		if (!nvmeq)
 			return -ENOMEM;
-		dev->queues[0] = nvmeq;
 	}
 
 	aqa = nvmeq->q_depth - 1;
@@ -1951,8 +1955,6 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		spin_unlock_irq(&nvmeq->q_lock);
 
 		nvme_free_queue(nvmeq);
-		dev->queue_count--;
-		dev->queues[i] = NULL;
 	}
 	spin_unlock(&dev_list_lock);
 
@@ -2439,8 +2441,6 @@ static void nvme_remove_disks(struct work_struct *ws)
 	for (i = dev->queue_count - 1; i > 0; i--) {
 		BUG_ON(!dev->queues[i] || !dev->queues[i]->q_suspended);
 		nvme_free_queue(dev->queues[i]);
-		dev->queue_count--;
-		dev->queues[i] = NULL;
 	}
 	spin_unlock(&dev_list_lock);
 }
-- 
1.7.7.6

