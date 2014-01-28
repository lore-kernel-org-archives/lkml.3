Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaA1IiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:38:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbaA1IiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:38:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 14/14] NVMe: Rework "NVMe: Disable admin queue on init failure" commit
Date: Tue, 28 Jan 2014 09:39:00 +0100
Message-Id: <4a533c422bb1e466246517763cf131c92ae8878a.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update partially reverts commit c5dc919 ("NVMe: Disable
admin queue on init failure") to roll back easy readable
nvme_free_queues() function. Commit's c5dc919 functionality
aimed to free admin queue IRQ on init failure is preserved.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 83d57b3..a51f342 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1161,11 +1161,11 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
 	dev->queues[qid] = NULL;
 }
 
-static void nvme_free_queues(struct nvme_dev *dev, int lowest)
+static void nvme_free_queues(struct nvme_dev *dev)
 {
 	int i;
 
-	for (i = dev->queue_count - 1; i >= lowest; i--)
+	for (i = dev->queue_count - 1; i >= 0; i--)
 		nvme_free_queue(dev->queues[i]);
 }
 
@@ -2035,7 +2035,8 @@ static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
 	return 0;
 
  free_queues:
-	nvme_free_queues(dev, 1);
+	for (i = dev->queue_count - 1; i > 0; i--)
+		nvme_free_queue(dev->queues[i]);
 	return result;
 }
 
@@ -2601,7 +2602,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  shutdown:
 	nvme_dev_shutdown(dev);
  release_pools:
-	nvme_free_queues(dev, 0);
+	nvme_free_queues(dev);
 	nvme_release_prp_pools(dev);
  release:
 	nvme_release_instance(dev);
@@ -2625,7 +2626,7 @@ static void nvme_remove(struct pci_dev *pdev)
 	misc_deregister(&dev->miscdev);
 	nvme_dev_remove(dev);
 	nvme_dev_shutdown(dev);
-	nvme_free_queues(dev, 0);
+	nvme_free_queues(dev);
 	nvme_release_instance(dev);
 	nvme_release_prp_pools(dev);
 	kref_put(&dev->kref, nvme_free_dev);
-- 
1.7.7.6

