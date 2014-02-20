Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaBTUot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:49 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:49559 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBTUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:46 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 6/9] nvme: don't use PREPARE_WORK
Date: Thu, 20 Feb 2014 15:44:28 -0500
Message-Id: <1392929071-16555-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

nvme_dev->reset_work is multiplexed with multiple work functions.
Introduce nvme_reset_workfn() which invokes nvme_dev->reset_workfn and
always use it as the work function and update the users to set the
->reset_workfn field instead of overriding the work function using
PREPARE_WORK().

It would probably be best to route this with other related updates
through the workqueue tree.

Compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvme@lists.infradead.org
---
 drivers/block/nvme-core.c | 18 ++++++++++++------
 include/linux/nvme.h      |  1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 51824d1..8459e4e 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -993,7 +993,7 @@ static void nvme_abort_cmd(int cmdid, struct nvme_queue *nvmeq)
 		dev_warn(&dev->pci_dev->dev,
 			"I/O %d QID %d timeout, reset controller\n", cmdid,
 								nvmeq->qid);
-		PREPARE_WORK(&dev->reset_work, nvme_reset_failed_dev);
+		dev->reset_workfn = nvme_reset_failed_dev;
 		queue_work(nvme_workq, &dev->reset_work);
 		return;
 	}
@@ -1696,8 +1696,7 @@ static int nvme_kthread(void *data)
 				list_del_init(&dev->node);
 				dev_warn(&dev->pci_dev->dev,
 					"Failed status, reset controller\n");
-				PREPARE_WORK(&dev->reset_work,
-							nvme_reset_failed_dev);
+				dev->reset_workfn = nvme_reset_failed_dev;
 				queue_work(nvme_workq, &dev->reset_work);
 				continue;
 			}
@@ -2406,7 +2405,7 @@ static int nvme_dev_resume(struct nvme_dev *dev)
 		return ret;
 	if (ret == -EBUSY) {
 		spin_lock(&dev_list_lock);
-		PREPARE_WORK(&dev->reset_work, nvme_remove_disks);
+		dev->reset_workfn = nvme_remove_disks;
 		queue_work(nvme_workq, &dev->reset_work);
 		spin_unlock(&dev_list_lock);
 	}
@@ -2435,6 +2434,12 @@ static void nvme_reset_failed_dev(struct work_struct *ws)
 	nvme_dev_reset(dev);
 }
 
+static void nvme_reset_workfn(struct work_struct *work)
+{
+	struct nvme_dev *dev = container_of(work, struct nvme_dev, reset_work);
+	dev->reset_workfn(work);
+}
+
 static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int result = -ENOMEM;
@@ -2453,7 +2458,8 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto free;
 
 	INIT_LIST_HEAD(&dev->namespaces);
-	INIT_WORK(&dev->reset_work, nvme_reset_failed_dev);
+	dev->reset_workfn = nvme_reset_failed_dev;
+	INIT_WORK(&dev->reset_work, nvme_reset_workfn);
 	dev->pci_dev = pdev;
 	pci_set_drvdata(pdev, dev);
 	result = nvme_set_instance(dev);
@@ -2553,7 +2559,7 @@ static int nvme_resume(struct device *dev)
 	struct nvme_dev *ndev = pci_get_drvdata(pdev);
 
 	if (nvme_dev_resume(ndev) && !work_busy(&ndev->reset_work)) {
-		PREPARE_WORK(&ndev->reset_work, nvme_reset_failed_dev);
+		ndev->reset_workfn = nvme_reset_failed_dev;
 		queue_work(nvme_workq, &ndev->reset_work);
 	}
 	return 0;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 69ae03f..6b9aafe 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -87,6 +87,7 @@ struct nvme_dev {
 	struct list_head namespaces;
 	struct kref kref;
 	struct miscdevice miscdev;
+	work_func_t reset_workfn;
 	struct work_struct reset_work;
 	char name[12];
 	char serial[20];
-- 
1.8.5.3

