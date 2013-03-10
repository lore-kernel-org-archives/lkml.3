Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3CJL4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:56:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:23657 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3CJL4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:56:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,817,1355126400"; 
   d="scan'208";a="299148224"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 2/2][3.9] mei: add mei_stop function to stop mei device
Date: Sun, 10 Mar 2013 13:56:08 +0200
Message-Id: <1362916568-9650-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
References: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_stop calls mei_reset with disabling the interrupts.
It will have the same effect as the open code it replaces in the mei_remove.

The reset sequence on remove is required for the Lynx Point LP devices
to clean the reset state.

mei_stop is called from mei_pci_suspend and mei_remove functions

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    | 18 ++++++++++++++++
 drivers/misc/mei/mei_dev.h |  1 +
 drivers/misc/mei/pci-me.c  | 52 +++++++---------------------------------------
 3 files changed, 26 insertions(+), 45 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 6ec5301..3561799 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -183,6 +183,24 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	mei_cl_all_write_clear(dev);
 }
 
+void mei_stop(struct mei_device *dev)
+{
+	dev_dbg(&dev->pdev->dev, "stopping the device.\n");
+
+	mutex_lock(&dev->device_lock);
+
+	cancel_delayed_work(&dev->timer_work);
+
+	mei_wd_stop(dev);
+
+	dev->dev_state = MEI_DEV_POWER_DOWN;
+	mei_reset(dev, 0);
+
+	mutex_unlock(&dev->device_lock);
+
+	flush_scheduled_work();
+}
+
 
 
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index cb80166..9787381 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -381,6 +381,7 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 void mei_device_init(struct mei_device *dev);
 void mei_reset(struct mei_device *dev, int interrupts);
 int mei_hw_init(struct mei_device *dev);
+void mei_stop(struct mei_device *dev);
 
 /*
  *  MEI interrupt functions prototype
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b40ec06..b8b5c9c 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -247,44 +247,14 @@ static void mei_remove(struct pci_dev *pdev)
 
 	hw = to_me_hw(dev);
 
-	mutex_lock(&dev->device_lock);
-
-	cancel_delayed_work(&dev->timer_work);
 
-	mei_wd_stop(dev);
+	dev_err(&pdev->dev, "stop\n");
+	mei_stop(dev);
 
 	mei_pdev = NULL;
 
-	if (dev->iamthif_cl.state == MEI_FILE_CONNECTED) {
-		dev->iamthif_cl.state = MEI_FILE_DISCONNECTING;
-		mei_cl_disconnect(&dev->iamthif_cl);
-	}
-	if (dev->wd_cl.state == MEI_FILE_CONNECTED) {
-		dev->wd_cl.state = MEI_FILE_DISCONNECTING;
-		mei_cl_disconnect(&dev->wd_cl);
-	}
-
-	/* Unregistering watchdog device */
 	mei_watchdog_unregister(dev);
 
-	/* remove entry if already in list */
-	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
-
-	if (dev->open_handle_count > 0)
-		dev->open_handle_count--;
-	mei_cl_unlink(&dev->wd_cl);
-
-	if (dev->open_handle_count > 0)
-		dev->open_handle_count--;
-	mei_cl_unlink(&dev->iamthif_cl);
-
-	dev->iamthif_current_cb = NULL;
-	dev->me_clients_num = 0;
-
-	mutex_unlock(&dev->device_lock);
-
-	flush_scheduled_work();
-
 	/* disable interrupts */
 	mei_disable_interrupts(dev);
 
@@ -308,28 +278,20 @@ static int mei_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mei_device *dev = pci_get_drvdata(pdev);
-	int err;
 
 	if (!dev)
 		return -ENODEV;
-	mutex_lock(&dev->device_lock);
 
-	cancel_delayed_work(&dev->timer_work);
+	dev_err(&pdev->dev, "suspend\n");
 
-	/* Stop watchdog if exists */
-	err = mei_wd_stop(dev);
-	/* Set new mei state */
-	if (dev->dev_state == MEI_DEV_ENABLED ||
-	    dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET) {
-		dev->dev_state = MEI_DEV_POWER_DOWN;
-		mei_reset(dev, 0);
-	}
-	mutex_unlock(&dev->device_lock);
+	mei_stop(dev);
+
+	mei_disable_interrupts(dev);
 
 	free_irq(pdev->irq, dev);
 	pci_disable_msi(pdev);
 
-	return err;
+	return 0;
 }
 
 static int mei_pci_resume(struct device *device)
-- 
1.8.1.3

