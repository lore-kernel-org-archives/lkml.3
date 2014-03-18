Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaCRUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:54:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237AbaCRUx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172528"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 12/13] mei: txe: use runtime PG pm domain for non wakeable devices
Date: Tue, 18 Mar 2014 22:52:06 +0200
Message-Id: <1395175927-10562-13-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

For non wakeable devices we can't use pci runtime framework
as we are not able to wakeup from D3 states.
Instead we create new pg runtime domain that only drives TXE power
gating protocol to reduce the power consumption.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-txe.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index 31d86e7..2c3f562 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -41,6 +41,13 @@ static const struct pci_device_id mei_txe_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, mei_txe_pci_tbl);
 
+#ifdef CONFIG_PM_RUNTIME
+static inline void mei_txe_set_pm_domain(struct mei_device *dev);
+static inline void mei_txe_unset_pm_domain(struct mei_device *dev);
+#else
+static inline void mei_txe_set_pm_domain(struct mei_device *dev) {}
+static inline void mei_txe_unset_pm_domain(struct mei_device *dev) {}
+#endif /* CONFIG_PM_RUNTIME */
 
 static void mei_txe_pci_iounmap(struct pci_dev *pdev, struct mei_txe_hw *hw)
 {
@@ -147,6 +154,14 @@ static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, dev);
 
+	/*
+	* For not wake-able HW runtime pm framework
+	* can't be used on pci device level.
+	* Use domain runtime pm callbacks instead.
+	*/
+	if (!pci_dev_run_wake(pdev))
+		mei_txe_set_pm_domain(dev);
+
 	pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
@@ -199,6 +214,9 @@ static void mei_txe_remove(struct pci_dev *pdev)
 
 	mei_stop(dev);
 
+	if (!pci_dev_run_wake(pdev))
+		mei_txe_unset_pm_domain(dev);
+
 	/* disable interrupts */
 	mei_disable_interrupts(dev);
 	free_irq(pdev->irq, dev);
@@ -350,6 +368,37 @@ static int mei_txe_pm_runtime_resume(struct device *device)
 
 	return ret;
 }
+
+/**
+ * mei_txe_set_pm_domain - fill and set pm domian stucture for device
+ *
+ * @dev: mei_device
+ */
+static inline void mei_txe_set_pm_domain(struct mei_device *dev)
+{
+	struct pci_dev *pdev  = dev->pdev;
+
+	if (pdev->dev.bus && pdev->dev.bus->pm) {
+		dev->pg_domain.ops = *pdev->dev.bus->pm;
+
+		dev->pg_domain.ops.runtime_suspend = mei_txe_pm_runtime_suspend;
+		dev->pg_domain.ops.runtime_resume = mei_txe_pm_runtime_resume;
+		dev->pg_domain.ops.runtime_idle = mei_txe_pm_runtime_idle;
+
+		pdev->dev.pm_domain = &dev->pg_domain;
+	}
+}
+
+/**
+ * mei_txe_unset_pm_domain - clean pm domian stucture for device
+ *
+ * @dev: mei_device
+ */
+static inline void mei_txe_unset_pm_domain(struct mei_device *dev)
+{
+	/* stop using pm callbacks if any */
+	dev->pdev->dev.pm_domain = NULL;
+}
 #endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM
-- 
1.8.5.3

