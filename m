Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaIBLw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:52:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:30414 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbaIBLvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="585035602"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 1/6] mei: push all standard settings into mei_device_init
Date: Tue,  2 Sep 2014 14:49:59 +0300
Message-Id: <1409658604-31615-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
References: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting of hw_ops and device has should be in
mei_device_init.
We add reference to the parent device and remove
pci dependent cfg

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c   |  6 ++----
 drivers/misc/mei/hw-txe.c  |  5 ++---
 drivers/misc/mei/init.c    | 14 ++++++++++++--
 drivers/misc/mei/mei_dev.h |  6 +++++-
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 56a9caa..df42b6f 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -824,10 +824,8 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 	if (!dev)
 		return NULL;
 
-	mei_device_init(dev, cfg);
-
-	dev->ops = &mei_me_hw_ops;
-
+	mei_device_init(dev, &pdev->dev, &mei_me_hw_ops);
+	dev->cfg  = cfg;
 	dev->pdev = pdev;
 	return dev;
 }
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 1855b3b..fc1a51f 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -1123,14 +1123,13 @@ struct mei_device *mei_txe_dev_init(struct pci_dev *pdev,
 	if (!dev)
 		return NULL;
 
-	mei_device_init(dev, cfg);
+	mei_device_init(dev, &pdev->dev, &mei_txe_hw_ops);
 
 	hw = to_txe_hw(dev);
 
 	init_waitqueue_head(&hw->wait_aliveness_resp);
 
-	dev->ops = &mei_txe_hw_ops;
-
+	dev->cfg  = cfg;
 	dev->pdev = pdev;
 	return dev;
 }
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 5c41f58..ac65976 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -365,7 +365,16 @@ int mei_fw_status(struct mei_device *dev, struct mei_fw_status *fw_status)
 }
 EXPORT_SYMBOL_GPL(mei_fw_status);
 
-void mei_device_init(struct mei_device *dev, const struct mei_cfg *cfg)
+/**
+ * mei_device_init  -- initialize mei_device structure
+ *
+ * @dev: the mei device
+ * @device: the device structure
+ * @hw_ops: hw operations
+ */
+void mei_device_init(struct mei_device *dev,
+		     struct device *device,
+		     const struct mei_hw_ops *hw_ops)
 {
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
@@ -404,7 +413,8 @@ void mei_device_init(struct mei_device *dev, const struct mei_cfg *cfg)
 	bitmap_set(dev->host_clients_map, 0, 1);
 
 	dev->pg_event = MEI_PG_EVENT_IDLE;
-	dev->cfg      = cfg;
+	dev->ops      = hw_ops;
+	dev->dev      = device;
 }
 EXPORT_SYMBOL_GPL(mei_device_init);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index be7b147..7051430 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -399,6 +399,7 @@ struct mei_cfg {
  * struct mei_device -  MEI private device struct
 
  * @pdev - pointer to pci device struct
+ * @dev  - device on a bus
  * @cdev - character device
  * @minor - minor number allocated for device
  *
@@ -417,6 +418,7 @@ struct mei_cfg {
  */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
+	struct device *dev;
 	struct cdev cdev;
 	int minor;
 
@@ -560,7 +562,9 @@ static inline u32 mei_slots2data(int slots)
 /*
  * mei init function prototypes
  */
-void mei_device_init(struct mei_device *dev, const struct mei_cfg *cfg);
+void mei_device_init(struct mei_device *dev,
+		     struct device *device,
+		     const struct mei_hw_ops *hw_ops);
 int mei_reset(struct mei_device *dev);
 int mei_start(struct mei_device *dev);
 int mei_restart(struct mei_device *dev);
-- 
1.9.3

