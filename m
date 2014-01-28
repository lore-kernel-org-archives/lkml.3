Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaA1IlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbaA1Ihs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:48 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 06/14] NVMe: Get rid of superfluous dev parameter to queue_request_irq()
Date: Tue, 28 Jan 2014 09:38:52 +0100
Message-Id: <daf2acdd8c45e0572dccbaf0904515a0b898a9c2.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 661277d..f03f123 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1267,9 +1267,10 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	return NULL;
 }
 
-static int queue_request_irq(struct nvme_dev *dev, struct nvme_queue *nvmeq,
-							const char *name)
+static int queue_request_irq(struct nvme_queue *nvmeq, const char *name)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+
 	if (use_threaded_interrupts)
 		return request_threaded_irq(dev->entry[nvmeq->cq_vector].vector,
 					nvme_irq_check, nvme_irq, IRQF_SHARED,
@@ -1296,7 +1297,6 @@ static void nvme_init_queue(struct nvme_queue *nvmeq)
 
 static int nvme_create_queue(struct nvme_queue *nvmeq)
 {
-	struct nvme_dev *dev = nvmeq->dev;
 	int result;
 
 	result = adapter_alloc_cq(nvmeq);
@@ -1307,7 +1307,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq)
 	if (result < 0)
 		goto release_cq;
 
-	result = queue_request_irq(dev, nvmeq, "nvme");
+	result = queue_request_irq(nvmeq, "nvme");
 	if (result < 0)
 		goto release_sq;
 
@@ -1424,7 +1424,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result)
 		return result;
 
-	result = queue_request_irq(dev, nvmeq, "nvme admin");
+	result = queue_request_irq(nvmeq, "nvme admin");
 	if (result)
 		return result;
 
@@ -1945,7 +1945,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	 */
 	nr_io_queues = vecs;
 
-	result = queue_request_irq(dev, dev->queues[0], "nvme admin");
+	result = queue_request_irq(dev->queues[0], "nvme admin");
 	if (result) {
 		dev->queues[0]->q_suspended = 1;
 		goto free_queues;
-- 
1.7.7.6

