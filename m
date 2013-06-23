Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab3FWHpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:45:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:31713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3FWHpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="334099676"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/4 V2] mei: check if the hardware reset succeeded
Date: Sun, 23 Jun 2013 10:42:49 +0300
Message-Id: <1371973369-17950-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw may have multiple steps for resetting
so we need to check if it has really succeeded.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: fix the subject 'hardware start -> hardware reset'

 drivers/misc/mei/hw-me.c   | 3 ++-
 drivers/misc/mei/init.c    | 8 +++++++-
 drivers/misc/mei/mei_dev.h | 6 +++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 822170f..e4f8dec 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -171,7 +171,7 @@ static void mei_me_hw_reset_release(struct mei_device *dev)
  * @dev: the device structure
  * @intr_enable: if interrupt should be enabled after reset.
  */
-static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
+static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -191,6 +191,7 @@ static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 		mei_me_hw_reset_release(dev);
 
 	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", mei_hcsr_read(hw));
+	return 0;
 }
 
 /**
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 79e9e1c..1525388 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -132,13 +132,19 @@ EXPORT_SYMBOL_GPL(mei_start);
 void mei_reset(struct mei_device *dev, int interrupts_enabled)
 {
 	bool unexpected;
+	int ret;
 
 	unexpected = (dev->dev_state != MEI_DEV_INITIALIZING &&
 			dev->dev_state != MEI_DEV_DISABLED &&
 			dev->dev_state != MEI_DEV_POWER_DOWN &&
 			dev->dev_state != MEI_DEV_POWER_UP);
 
-	mei_hw_reset(dev, interrupts_enabled);
+	ret = mei_hw_reset(dev, interrupts_enabled);
+	if (ret) {
+		dev_err(&dev->pdev->dev, "hw reset failed disabling the device\n");
+		interrupts_enabled = false;
+		dev->dev_state = MEI_DEV_DISABLED;
+	}
 
 	dev->hbm_state = MEI_HBM_IDLE;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 80a9031..1aa4997 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -233,7 +233,7 @@ struct mei_hw_ops {
 	bool (*host_is_ready) (struct mei_device *dev);
 
 	bool (*hw_is_ready) (struct mei_device *dev);
-	void (*hw_reset) (struct mei_device *dev, bool enable);
+	int (*hw_reset) (struct mei_device *dev, bool enable);
 	int  (*hw_start) (struct mei_device *dev);
 	void (*hw_config) (struct mei_device *dev);
 
@@ -539,9 +539,9 @@ static inline void mei_hw_config(struct mei_device *dev)
 {
 	dev->ops->hw_config(dev);
 }
-static inline void mei_hw_reset(struct mei_device *dev, bool enable)
+static inline int mei_hw_reset(struct mei_device *dev, bool enable)
 {
-	dev->ops->hw_reset(dev, enable);
+	return dev->ops->hw_reset(dev, enable);
 }
 
 static inline void mei_hw_start(struct mei_device *dev)
-- 
1.8.1.2

