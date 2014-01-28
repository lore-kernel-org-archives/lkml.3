Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaA1Iht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:37:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbaA1Ihr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:47 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 04/14] NVMe: Cleanup adapter_alloc_cq/sg() and adapter_delete_cq/sg()
Date: Tue, 28 Jan 2014 09:38:50 +0100
Message-Id: <05f59a0960799dce8c45c4594f8ac36108de7963.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A queue structure contains both a pointer to the device it
belongs to and the queue ID - there is no need to drag these
parameters around.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 606a2e1..652f0f6 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -942,8 +942,10 @@ int nvme_submit_admin_cmd_async(struct nvme_dev *dev, struct nvme_command *cmd,
 	return nvme_submit_async_cmd(dev->queues[0], cmd, cmdinfo, ADMIN_TIMEOUT);
 }
 
-static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
+static int adapter_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+	u16 id = nvmeq->qid;
 	int status;
 	struct nvme_command c;
 
@@ -957,9 +959,10 @@ static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
 	return 0;
 }
 
-static int adapter_alloc_cq(struct nvme_dev *dev, u16 qid,
-						struct nvme_queue *nvmeq)
+static int adapter_alloc_cq(struct nvme_queue *nvmeq)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+	u16 qid = nvmeq->qid;
 	int status;
 	struct nvme_command c;
 	int flags = NVME_QUEUE_PHYS_CONTIG | NVME_CQ_IRQ_ENABLED;
@@ -978,9 +981,10 @@ static int adapter_alloc_cq(struct nvme_dev *dev, u16 qid,
 	return 0;
 }
 
-static int adapter_alloc_sq(struct nvme_dev *dev, u16 qid,
-						struct nvme_queue *nvmeq)
+static int adapter_alloc_sq(struct nvme_queue *nvmeq)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+	u16 qid = nvmeq->qid;
 	int status;
 	struct nvme_command c;
 	int flags = NVME_QUEUE_PHYS_CONTIG | NVME_SQ_PRIO_MEDIUM;
@@ -999,14 +1003,14 @@ static int adapter_alloc_sq(struct nvme_dev *dev, u16 qid,
 	return 0;
 }
 
-static int adapter_delete_cq(struct nvme_dev *dev, u16 cqid)
+static int adapter_delete_cq(struct nvme_queue *nvmeq)
 {
-	return adapter_delete_queue(dev, nvme_admin_delete_cq, cqid);
+	return adapter_delete_queue(nvmeq, nvme_admin_delete_cq);
 }
 
-static int adapter_delete_sq(struct nvme_dev *dev, u16 sqid)
+static int adapter_delete_sq(struct nvme_queue *nvmeq)
 {
-	return adapter_delete_queue(dev, nvme_admin_delete_sq, sqid);
+	return adapter_delete_queue(nvmeq, nvme_admin_delete_sq);
 }
 
 int nvme_identify(struct nvme_dev *dev, unsigned nsid, unsigned cns,
@@ -1210,8 +1214,8 @@ static void nvme_disable_queue(struct nvme_queue *nvmeq)
 	/* Don't tell the adapter to delete the admin queue.
 	 * Don't tell a removed adapter to delete IO queues. */
 	if (qid && readl(&dev->bar->csts) != -1) {
-		adapter_delete_sq(dev, qid);
-		adapter_delete_cq(dev, qid);
+		adapter_delete_sq(nvmeq);
+		adapter_delete_cq(nvmeq);
 	}
 	nvme_clear_queue(nvmeq);
 }
@@ -1295,11 +1299,11 @@ static int nvme_create_queue(struct nvme_queue *nvmeq)
 	int qid = nvmeq->qid;
 	int result;
 
-	result = adapter_alloc_cq(dev, qid, nvmeq);
+	result = adapter_alloc_cq(nvmeq);
 	if (result < 0)
 		return result;
 
-	result = adapter_alloc_sq(dev, qid, nvmeq);
+	result = adapter_alloc_sq(nvmeq);
 	if (result < 0)
 		goto release_cq;
 
@@ -1314,9 +1318,9 @@ static int nvme_create_queue(struct nvme_queue *nvmeq)
 	return result;
 
  release_sq:
-	adapter_delete_sq(dev, qid);
+	adapter_delete_sq(nvmeq);
  release_cq:
-	adapter_delete_cq(dev, qid);
+	adapter_delete_cq(nvmeq);
 	return result;
 }
 
-- 
1.7.7.6

