Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaCRUzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:55:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbaCRUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172489"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 09/13] mei: txe: add runtime pm framework
Date: Tue, 18 Mar 2014 22:52:03 +0200
Message-Id: <1395175927-10562-10-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add runtime pm framework for TXE devices.
The runtime pm handlers are used to run
txe power gating isolation protocol.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-txe.h  |   2 +
 drivers/misc/mei/pci-txe.c | 101 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/hw-txe.h b/drivers/misc/mei/hw-txe.h
index 799f9f2..e8dd2d1 100644
--- a/drivers/misc/mei/hw-txe.h
+++ b/drivers/misc/mei/hw-txe.h
@@ -22,6 +22,8 @@
 #include "hw.h"
 #include "hw-txe-regs.h"
 
+#define MEI_TXI_RPM_TIMEOUT    500 /* ms */
+
 /* Flatten Hierarchy interrupt cause */
 #define TXE_INTR_READINESS_BIT  0 /* HISR_INT_0_STS */
 #define TXE_INTR_READINESS      HISR_INT_0_STS
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index ad3adb0..31d86e7 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -27,6 +27,7 @@
 #include <linux/jiffies.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mei.h>
 
@@ -137,12 +138,17 @@ static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto release_irq;
 	}
 
+	pm_runtime_set_autosuspend_delay(&pdev->dev, MEI_TXI_RPM_TIMEOUT);
+	pm_runtime_use_autosuspend(&pdev->dev);
+
 	err = mei_register(dev);
 	if (err)
 		goto release_irq;
 
 	pci_set_drvdata(pdev, dev);
 
+	pm_runtime_put_noidle(&pdev->dev);
+
 	return 0;
 
 release_irq:
@@ -187,6 +193,8 @@ static void mei_txe_remove(struct pci_dev *pdev)
 		return;
 	}
 
+	pm_runtime_get_noresume(&pdev->dev);
+
 	hw = to_txe_hw(dev);
 
 	mei_stop(dev);
@@ -265,15 +273,100 @@ static int mei_txe_pci_resume(struct device *device)
 
 	return err;
 }
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int mei_txe_pm_runtime_idle(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev;
+
+	dev_dbg(&pdev->dev, "rpm: txe: runtime_idle\n");
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
+	if (mei_write_is_idle(dev))
+		pm_schedule_suspend(device, MEI_TXI_RPM_TIMEOUT * 2);
+
+	return -EBUSY;
+}
+static int mei_txe_pm_runtime_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev;
+	int ret;
+
+	dev_dbg(&pdev->dev, "rpm: txe: runtime suspend\n");
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
 
-static SIMPLE_DEV_PM_OPS(mei_txe_pm_ops,
-			 mei_txe_pci_suspend,
-			 mei_txe_pci_resume);
+	mutex_lock(&dev->device_lock);
+
+	if (mei_write_is_idle(dev))
+		ret = mei_txe_aliveness_set_sync(dev, 0);
+	else
+		ret = -EAGAIN;
+
+	/*
+	 * If everything is okay we're about to enter PCI low
+	 * power state (D3) therefor we need to disable the
+	 * interrupts towards host.
+	 * However if device is not wakeable we do not enter
+	 * D-low state and we need to keep the interrupt kicking
+	 */
+	 if (!ret && pci_dev_run_wake(pdev))
+		mei_disable_interrupts(dev);
+
+	dev_dbg(&pdev->dev, "rpm: txe: runtime suspend ret=%d\n", ret);
+
+	mutex_unlock(&dev->device_lock);
+	return ret;
+}
+
+static int mei_txe_pm_runtime_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev;
+	int ret;
+
+	dev_dbg(&pdev->dev, "rpm: txe: runtime resume\n");
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+
+	mei_enable_interrupts(dev);
+
+	ret = mei_txe_aliveness_set_sync(dev, 1);
+
+	mutex_unlock(&dev->device_lock);
+
+	dev_dbg(&pdev->dev, "rpm: txe: runtime resume ret = %d\n", ret);
+
+	return ret;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops mei_txe_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mei_txe_pci_suspend,
+				mei_txe_pci_resume)
+	SET_RUNTIME_PM_OPS(
+		mei_txe_pm_runtime_suspend,
+		mei_txe_pm_runtime_resume,
+		mei_txe_pm_runtime_idle)
+};
 
 #define MEI_TXE_PM_OPS	(&mei_txe_pm_ops)
 #else
 #define MEI_TXE_PM_OPS	NULL
-#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
+
 /*
  *  PCI driver structure
  */
-- 
1.8.5.3

