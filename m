Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaIBLvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:51:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:30427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbaIBLvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="585035641"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/6] mei: move fw_status back to hw ops handlers
Date: Tue,  2 Sep 2014 14:50:01 +0300
Message-Id: <1409658604-31615-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
References: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw status retrieval has pci specific implementation
so we push it back to the hw layer

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   | 28 ++++++++++++++++++++++++++++
 drivers/misc/mei/hw-txe.c  | 30 ++++++++++++++++++++++++++++++
 drivers/misc/mei/init.c    | 21 ---------------------
 drivers/misc/mei/mei_dev.h |  9 ++++++++-
 4 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 1247be7..678531c 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -101,6 +101,33 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 	mei_me_reg_write(hw, H_CSR, hcsr);
 }
 
+/**
+ * mei_me_fw_status - read fw status register from pci config space
+ *
+ * @dev: mei device
+ * @fw_status: fw status register values
+ */
+static int mei_me_fw_status(struct mei_device *dev,
+			    struct mei_fw_status *fw_status)
+{
+	const struct mei_fw_status *fw_src = &dev->cfg->fw_status;
+	struct pci_dev *pdev = to_pci_dev(dev->dev);
+	int ret;
+	int i;
+
+	if (!fw_status)
+		return -EINVAL;
+
+	fw_status->count = fw_src->count;
+	for (i = 0; i < fw_src->count && i < MEI_FW_STATUS_MAX; i++) {
+		ret = pci_read_config_dword(pdev,
+			fw_src->status[i], &fw_status->status[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
 
 /**
  * mei_me_hw_config - configure hw dependent settings
@@ -714,6 +741,7 @@ end:
 
 static const struct mei_hw_ops mei_me_hw_ops = {
 
+	.fw_status = mei_me_fw_status,
 	.pg_state  = mei_me_pg_state,
 
 	.host_is_ready = mei_me_host_is_ready,
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index acc475e..e4cb9dc 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -573,6 +573,35 @@ static int mei_txe_readiness_wait(struct mei_device *dev)
 	return 0;
 }
 
+
+/**
+ * mei_txe_fw_status - read fw status register from pci config space
+ *
+ * @dev: mei device
+ * @fw_status: fw status register values
+ */
+static int mei_txe_fw_status(struct mei_device *dev,
+			     struct mei_fw_status *fw_status)
+{
+	const struct mei_fw_status *fw_src = &dev->cfg->fw_status;
+	struct pci_dev *pdev = to_pci_dev(dev->dev);
+	int ret;
+	int i;
+
+	if (!fw_status)
+		return -EINVAL;
+
+	fw_status->count = fw_src->count;
+	for (i = 0; i < fw_src->count && i < MEI_FW_STATUS_MAX; i++) {
+		ret = pci_read_config_dword(pdev,
+			fw_src->status[i], &fw_status->status[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  *  mei_txe_hw_config - configure hardware at the start of the devices
  *
@@ -1064,6 +1093,7 @@ static const struct mei_hw_ops mei_txe_hw_ops = {
 
 	.host_is_ready = mei_txe_host_is_ready,
 
+	.fw_status = mei_txe_fw_status,
 	.pg_state = mei_txe_pg_state,
 
 	.hw_is_ready = mei_txe_hw_is_ready,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 29aae7b..dd233fd 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -344,27 +344,6 @@ bool mei_write_is_idle(struct mei_device *dev)
 }
 EXPORT_SYMBOL_GPL(mei_write_is_idle);
 
-int mei_fw_status(struct mei_device *dev, struct mei_fw_status *fw_status)
-{
-	const struct mei_fw_status *fw_src = &dev->cfg->fw_status;
-	int ret;
-	int i;
-
-	if (!fw_status)
-		return -EINVAL;
-
-	fw_status->count = fw_src->count;
-	for (i = 0; i < fw_src->count && i < MEI_FW_STATUS_MAX; i++) {
-		ret = pci_read_config_dword(dev->pdev,
-			fw_src->status[i], &fw_status->status[i]);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mei_fw_status);
-
 /**
  * mei_device_init  -- initialize mei_device structure
  *
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7051430..7080fff 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -233,6 +233,7 @@ struct mei_cl {
  * @hw_start         - start hw after reset
  * @hw_config        - configure hw
 
+ * @fw_status        - get fw status registers
  * @pg_state         - power gating state of the device
  * @pg_is_enabled    - is power gating enabled
 
@@ -260,6 +261,8 @@ struct mei_hw_ops {
 	int (*hw_start)(struct mei_device *dev);
 	void (*hw_config)(struct mei_device *dev);
 
+
+	int (*fw_status)(struct mei_device *dev, struct mei_fw_status *fw_sts);
 	enum mei_pg_state (*pg_state)(struct mei_device *dev);
 	bool (*pg_is_enabled)(struct mei_device *dev);
 
@@ -731,7 +734,11 @@ static inline int mei_count_full_read_slots(struct mei_device *dev)
 	return dev->ops->rdbuf_full_slots(dev);
 }
 
-int mei_fw_status(struct mei_device *dev, struct mei_fw_status *fw_status);
+static inline int mei_fw_status(struct mei_device *dev,
+				struct mei_fw_status *fw_status)
+{
+	return dev->ops->fw_status(dev, fw_status);
+}
 
 #define FW_STS_FMT "%08X %08X"
 #define FW_STS_PRM(fw_status) \
-- 
1.9.3

