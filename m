Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaI2Nfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:35:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:32043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaI2NdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030075"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 12/18] mei: remove the reference to pdev from mei_device
Date: Mon, 29 Sep 2014 16:31:44 +0300
Message-Id: <1411997510-29094-13-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For purpose of adding testing HW we would like
to get rid of pci dependency in generic mei code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   | 3 +--
 drivers/misc/mei/hw-txe.c  | 3 +--
 drivers/misc/mei/mei_dev.h | 2 --
 drivers/misc/mei/pci-me.c  | 2 +-
 drivers/misc/mei/pci-txe.c | 2 +-
 5 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 678531c..da86310 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -676,7 +676,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	/* Ack the interrupt here
 	 * In case of MSI we don't go through the quick handler */
-	if (pci_dev_msi_enabled(dev->pdev))
+	if (pci_dev_msi_enabled(to_pci_dev(dev->dev)))
 		mei_clear_interrupts(dev);
 
 	/* check if ME wants a reset */
@@ -854,7 +854,6 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 
 	mei_device_init(dev, &pdev->dev, &mei_me_hw_ops);
 	dev->cfg  = cfg;
-	dev->pdev = pdev;
 	return dev;
 }
 
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index e4cb9dc..6eef676 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -998,7 +998,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 	mutex_lock(&dev->device_lock);
 	mei_io_list_init(&complete_list);
 
-	if (pci_dev_msi_enabled(dev->pdev))
+	if (pci_dev_msi_enabled(to_pci_dev(dev->dev)))
 		mei_txe_check_and_ack_intrs(dev, true);
 
 	/* show irq events */
@@ -1157,7 +1157,6 @@ struct mei_device *mei_txe_dev_init(struct pci_dev *pdev,
 	init_waitqueue_head(&hw->wait_aliveness_resp);
 
 	dev->cfg  = cfg;
-	dev->pdev = pdev;
 	return dev;
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7080fff..5a16cc4 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -401,7 +401,6 @@ struct mei_cfg {
 /**
  * struct mei_device -  MEI private device struct
 
- * @pdev - pointer to pci device struct
  * @dev  - device on a bus
  * @cdev - character device
  * @minor - minor number allocated for device
@@ -420,7 +419,6 @@ struct mei_cfg {
  * @cfg - per device generation config and ops
  */
 struct mei_device {
-	struct pci_dev *pdev;	/* pointer to pci device struct */
 	struct device *dev;
 	struct cdev cdev;
 	int minor;
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 83e8892..a910717 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -430,7 +430,7 @@ static int mei_me_pm_runtime_resume(struct device *device)
  */
 static inline void mei_me_set_pm_domain(struct mei_device *dev)
 {
-	struct pci_dev *pdev  = dev->pdev;
+	struct pci_dev *pdev  = to_pci_dev(dev->dev);
 
 	if (pdev->dev.bus && pdev->dev.bus->pm) {
 		dev->pg_domain.ops = *pdev->dev.bus->pm;
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index a1f60be..cd9dda7 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -378,7 +378,7 @@ static int mei_txe_pm_runtime_resume(struct device *device)
  */
 static inline void mei_txe_set_pm_domain(struct mei_device *dev)
 {
-	struct pci_dev *pdev  = dev->pdev;
+	struct pci_dev *pdev  = to_pci_dev(dev->dev);
 
 	if (pdev->dev.bus && pdev->dev.bus->pm) {
 		dev->pg_domain.ops = *pdev->dev.bus->pm;
-- 
1.9.3

