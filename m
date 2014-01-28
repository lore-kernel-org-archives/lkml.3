Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaA1IiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:38:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbaA1IiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:38:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 13/14] NVMe: Factor out nvme_setup_interrupts()
Date: Tue, 28 Jan 2014 09:38:59 +0100
Message-Id: <d31efb3af96031be9a94d9c803a0e7118da01fa5.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 39868be..83d57b3 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1945,12 +1945,18 @@ static int nvme_init_interrupts(struct nvme_dev *dev, int nr_io_queues)
 	return vecs;
 }
 
-static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
+static int nvme_setup_interrupts(struct nvme_dev *dev, int nr_io_queues)
 {
-	int result, cpu, i, q_depth;
+	struct nvme_queue *adminq = dev->queues[0];
+	int result;
 
-	/* Deregister the admin queue's interrupt */
-	free_irq(dev->entry[dev->queues[0]->cq_vector].vector, dev->queues[0]);
+	/*
+	 * Deregister the admin queue's interrupt, since it is about
+	 * to move to other IRQ number. We do not re-configure the
+	 * admin queue - are there any adverse effects of this trick?
+	 * Should we call nvme_clear_queue() to mimic nvme_disable_queue()?
+	 */
+	free_irq(dev->entry[adminq->cq_vector].vector, adminq);
 
 	/*
 	 * Should investigate if there's a performance win from allocating
@@ -1963,12 +1969,19 @@ static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
 	 */
 	nr_io_queues = nvme_init_interrupts(dev, nr_io_queues);
 
-	result = queue_request_irq(dev->queues[0], "nvme admin");
+	result = queue_request_irq(adminq, "nvme admin");
 	if (result) {
-		dev->queues[0]->q_suspended = 1;
-		goto free_queues;
+		adminq->q_suspended = 1;
+		return result;
 	}
 
+	return nr_io_queues;
+}
+
+static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
+{
+	int result, cpu, i, q_depth;
+
 	/* Free previously allocated queues that are no longer usable */
 	spin_lock(&dev_list_lock);
 	for (i = dev->queue_count - 1; i > nr_io_queues; i--) {
@@ -2442,6 +2455,11 @@ static int nvme_dev_start(struct nvme_dev *dev)
 	if (result < 0)
 		goto disable;
 
+	result = nvme_setup_interrupts(dev, result);
+	if (result < 0)
+		/* Admin queue interrupt has been torn down - can not go on */
+		goto delete;
+
 	result = nvme_setup_io_queues(dev, result);
 	if (result)
 		goto disable;
@@ -2453,6 +2471,7 @@ static int nvme_dev_start(struct nvme_dev *dev)
 		return -EBUSY;
 
 	nvme_disable_queue(dev->queues[0]);
+ delete:
 	spin_lock(&dev_list_lock);
 	list_del_init(&dev->node);
 	spin_unlock(&dev_list_lock);
-- 
1.7.7.6

