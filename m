Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaEHSIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:08:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:48750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318AbaEHSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:07:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1012,1389772800"; 
   d="scan'208";a="429590904"
From: Keith Busch <keith.busch@intel.com>
To: linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 2/2] NVMe: Complete shutdown asynchronously
Date: Thu,  8 May 2014 12:07:34 -0600
Message-Id: <1399572454-30239-3-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
References: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices may take a long time to complete a shutdown.  The driver
can perform the device shutdown asynchronously so multiple devices may
be done in parallel and speed up the overall system shutdown.

PCI disables MSI/MSI-x after the driver's .shutdown returns, so the
driver enables the INTx irq if performing the shutdown asynchronously.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/block/nvme-core.c |   28 ++++++++++++++++++++++++++--
 include/linux/nvme.h      |    1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index cd8a8bc7..a9982b8 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/nvme.h>
+#include <linux/async.h>
 #include <linux/bio.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
@@ -1401,7 +1402,7 @@ static int nvme_shutdown_ctrl(struct nvme_dev *dev)
 	cc = (readl(&dev->bar->cc) & ~NVME_CC_SHN_MASK) | NVME_CC_SHN_NORMAL;
 	writel(cc, &dev->bar->cc);
 
-	timeout = 2 * HZ + jiffies;
+	timeout = 20 * HZ + jiffies;
 	while ((readl(&dev->bar->csts) & NVME_CSTS_SHST_MASK) !=
 							NVME_CSTS_SHST_CMPLT) {
 		msleep(100);
@@ -2739,6 +2740,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->reset_workfn = nvme_reset_failed_dev;
 	INIT_WORK(&dev->reset_work, nvme_reset_workfn);
 	dev->pci_dev = pdev;
+	dev->intx_irq = pdev->irq;
 	pci_set_drvdata(pdev, dev);
 	result = nvme_set_instance(dev);
 	if (result)
@@ -2791,10 +2793,32 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return result;
 }
 
+static void nvme_async_shutdown(void *data, async_cookie_t cookie)
+{
+	struct nvme_dev *dev = data;
+	nvme_dev_shutdown(dev);
+	free_irq(dev->intx_irq, raw_nvmeq(dev, 0));
+}
+
 static void nvme_shutdown(struct pci_dev *pdev)
 {
 	struct nvme_dev *dev = pci_get_drvdata(pdev);
-	nvme_dev_shutdown(dev);
+	struct nvme_queue *adminq = raw_nvmeq(dev, 0);
+	bool use_async = true;
+
+	/* MSI/MSI-x are disabled after returning from this function */
+	if (dev->pci_dev->msi_enabled || dev->pci_dev->msix_enabled) {
+		if (request_irq(dev->intx_irq, nvme_irq, IRQF_SHARED,
+						adminq->irqname, adminq))
+			use_async = false;
+		else
+			pci_intx(dev->pci_dev, 1);
+	}
+	if (!use_async)
+		nvme_dev_shutdown(dev);
+	else
+		async_schedule_domain(nvme_async_shutdown, dev,
+							&shutdown_domain);
 }
 
 static void nvme_remove(struct pci_dev *pdev)
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 1813cfd..3df7c48 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -80,6 +80,7 @@ struct nvme_dev {
 	unsigned queue_count;
 	unsigned online_queues;
 	unsigned max_qid;
+	unsigned intx_irq;
 	int q_depth;
 	u32 db_stride;
 	u32 ctrl_config;
-- 
1.7.10.4

