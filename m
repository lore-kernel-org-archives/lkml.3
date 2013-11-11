Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3KKL2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:28:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:12027 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3KKL1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:27:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="406751035"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: remove flash_work_queue
Date: Mon, 11 Nov 2013 13:26:06 +0200
Message-Id: <1384169168-30281-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
References: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cancel each work properly and remove flash_work_queue.

Quoting documentation:

In most situations flushing the entire workqueue is overkill; you merely
need to know that a particular work item isn't queued and isn't running.
In such cases you should use cancel_delayed_work_sync() or
cancel_work_sync() instead.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    | 17 ++++++++++++-----
 drivers/misc/mei/mei_dev.h |  3 ++-
 drivers/misc/mei/nfc.c     |  6 +++++-
 drivers/misc/mei/pci-me.c  |  2 +-
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 7dfc7a4..f83da33 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -131,6 +131,15 @@ err:
 }
 EXPORT_SYMBOL_GPL(mei_start);
 
+
+void mei_cancel_work(struct mei_device *dev)
+{
+	cancel_work_sync(&dev->init_work);
+
+	cancel_delayed_work(&dev->timer_work);
+}
+EXPORT_SYMBOL_GPL(mei_cancel_work);
+
 /**
  * mei_reset - resets host and fw.
  *
@@ -216,16 +225,14 @@ void mei_stop(struct mei_device *dev)
 {
 	dev_dbg(&dev->pdev->dev, "stopping the device.\n");
 
-	flush_scheduled_work();
+	mei_cancel_work(dev);
 
-	mutex_lock(&dev->device_lock);
+	mei_nfc_host_exit(dev);
 
-	cancel_delayed_work(&dev->timer_work);
+	mutex_lock(&dev->device_lock);
 
 	mei_wd_stop(dev);
 
-	mei_nfc_host_exit();
-
 	dev->dev_state = MEI_DEV_POWER_DOWN;
 	mei_reset(dev, 0);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 406f68e..6f577bf 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -463,6 +463,7 @@ void mei_device_init(struct mei_device *dev);
 void mei_reset(struct mei_device *dev, int interrupts);
 int mei_start(struct mei_device *dev);
 void mei_stop(struct mei_device *dev);
+void mei_cancel_work(struct mei_device *dev);
 
 /*
  *  MEI interrupt functions prototype
@@ -510,7 +511,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
  * NFC functions
  */
 int mei_nfc_host_init(struct mei_device *dev);
-void mei_nfc_host_exit(void);
+void mei_nfc_host_exit(struct mei_device *dev);
 
 /*
  * NFC Client UUID
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 994ca4a..0a89220 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -547,12 +547,16 @@ err:
 	return ret;
 }
 
-void mei_nfc_host_exit(void)
+void mei_nfc_host_exit(struct mei_device *dev)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 
+	cancel_work_sync(&ndev->init_work);
+
+	mutex_lock(&dev->device_lock);
 	if (ndev->cl && ndev->cl->device)
 		mei_cl_remove_device(ndev->cl->device);
 
 	mei_nfc_free(ndev);
+	mutex_unlock(&dev->device_lock);
 }
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b96205a..3bfae38 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -195,8 +195,8 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 release_irq:
+	mei_cancel_work(dev);
 	mei_disable_interrupts(dev);
-	flush_scheduled_work();
 	free_irq(pdev->irq, dev);
 disable_msi:
 	pci_disable_msi(pdev);
-- 
1.8.3.1

