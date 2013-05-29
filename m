Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305Ab3E2RMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:12:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:3690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965244Ab3E2RMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="345207779"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: me: remove artificial singleton requirement
Date: Wed, 29 May 2013 20:09:31 +0300
Message-Id: <1369847371-31140-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369847371-31140-1-git-send-email-tomas.winkler@intel.com>
References: <1369847371-31140-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one device on the platform
drop mei_pdev and the mutex

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a727464..a2f5520f 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -43,9 +43,6 @@
 #include "hw-me.h"
 #include "client.h"
 
-/* AMT device is a singleton on the platform */
-static struct pci_dev *mei_pdev;
-
 /* mei_pci_tbl - PCI Device ID Table */
 static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
@@ -88,8 +85,6 @@ static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 
 MODULE_DEVICE_TABLE(pci, mei_me_pci_tbl);
 
-static DEFINE_MUTEX(mei_mutex);
-
 /**
  * mei_quirk_probe - probe for devices that doesn't valid ME interface
  *
@@ -126,17 +121,12 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct mei_me_hw *hw;
 	int err;
 
-	mutex_lock(&mei_mutex);
 
 	if (!mei_me_quirk_probe(pdev, ent)) {
 		err = -ENODEV;
 		goto end;
 	}
 
-	if (mei_pdev) {
-		err = -EEXIST;
-		goto end;
-	}
 	/* enable pci dev */
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -195,13 +185,10 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto release_irq;
 
-	mei_pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 	schedule_delayed_work(&dev->timer_work, HZ);
 
-	mutex_unlock(&mei_mutex);
-
 	pr_debug("initialization successful.\n");
 
 	return 0;
@@ -220,7 +207,6 @@ release_regions:
 disable_device:
 	pci_disable_device(pdev);
 end:
-	mutex_unlock(&mei_mutex);
 	dev_err(&pdev->dev, "initialization failed.\n");
 	return err;
 }
@@ -238,9 +224,6 @@ static void mei_me_remove(struct pci_dev *pdev)
 	struct mei_device *dev;
 	struct mei_me_hw *hw;
 
-	if (mei_pdev != pdev)
-		return;
-
 	dev = pci_get_drvdata(pdev);
 	if (!dev)
 		return;
@@ -251,8 +234,6 @@ static void mei_me_remove(struct pci_dev *pdev)
 	dev_err(&pdev->dev, "stop\n");
 	mei_stop(dev);
 
-	mei_pdev = NULL;
-
 	/* disable interrupts */
 	mei_disable_interrupts(dev);
 
-- 
1.8.1.2

