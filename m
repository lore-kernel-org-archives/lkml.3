Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaCaPBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:01:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:43861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaCaPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:01:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,766,1389772800"; 
   d="scan'208";a="484041498"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: extract fw status registers
Date: Mon, 31 Mar 2014 17:59:23 +0300
Message-Id: <1396277964-25314-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Fetch FW status registers, as they are important in
in understanding of FW reset reasons

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c       | 55 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw-txe-regs.h |  2 +-
 drivers/misc/mei/hw-txe.c      | 37 +++++++++++++++++++++++++++-
 drivers/misc/mei/init.c        | 10 +++++---
 drivers/misc/mei/mei_dev.h     | 28 +++++++++++++++++++++
 5 files changed, 127 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 4b048b6..a31bc4c 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -696,10 +696,65 @@ end:
 	mutex_unlock(&dev->device_lock);
 	return IRQ_HANDLED;
 }
+
+/**
+ * mei_me_fw_status - retrieve fw status from the pci config space
+ *
+ * @dev: the device structure
+ * @fw_status: fw status registers storage
+ *
+ * returns 0 on success an error code otherwise
+ */
+static int mei_me_fw_status(struct mei_device *dev,
+			    struct mei_fw_status *fw_status)
+{
+	const u32 pci_cfg_reg[] = {PCI_CFG_HFS_1, PCI_CFG_HFS_2};
+	int i;
+
+	if (!fw_status)
+		return -EINVAL;
+
+	switch (dev->pdev->device) {
+	case MEI_DEV_ID_IBXPK_1:
+	case MEI_DEV_ID_IBXPK_2:
+	case MEI_DEV_ID_CPT_1:
+	case MEI_DEV_ID_PBG_1:
+	case MEI_DEV_ID_PPT_1:
+	case MEI_DEV_ID_PPT_2:
+	case MEI_DEV_ID_PPT_3:
+	case MEI_DEV_ID_LPT_H:
+	case MEI_DEV_ID_LPT_W:
+	case MEI_DEV_ID_LPT_LP:
+	case MEI_DEV_ID_LPT_HR:
+	case MEI_DEV_ID_WPT_LP:
+		fw_status->count = 2;
+		break;
+	case MEI_DEV_ID_ICH10_1:
+	case MEI_DEV_ID_ICH10_2:
+	case MEI_DEV_ID_ICH10_3:
+	case MEI_DEV_ID_ICH10_4:
+		fw_status->count = 1;
+		break;
+	default:
+		fw_status->count = 0;
+		break;
+	}
+
+	for (i = 0; i < fw_status->count && i < MEI_FW_STATUS_MAX; i++) {
+		int ret;
+		ret = pci_read_config_dword(dev->pdev,
+				pci_cfg_reg[i], &fw_status->status[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 static const struct mei_hw_ops mei_me_hw_ops = {
 
 	.pg_state  = mei_me_pg_state,
 
+	.fw_status = mei_me_fw_status,
 	.host_is_ready = mei_me_host_is_ready,
 
 	.hw_is_ready = mei_me_hw_is_ready,
diff --git a/drivers/misc/mei/hw-txe-regs.h b/drivers/misc/mei/hw-txe-regs.h
index 7283c24..f19229c 100644
--- a/drivers/misc/mei/hw-txe-regs.h
+++ b/drivers/misc/mei/hw-txe-regs.h
@@ -89,7 +89,7 @@ enum {
 #  define PCI_CFG_TXE_FW_STS0_ERR_CODE_MSK  0x0000F000
 #  define PCI_CFG_TXE_FW_STS0_OP_MODE_MSK   0x000F0000
 #  define PCI_CFG_TXE_FW_STS0_RST_CNT_MSK   0x00F00000
-
+#define PCI_CFG_TXE_FW_STS1   0x48
 
 #define IPC_BASE_ADDR	0x80400 /* SeC IPC Base Address */
 
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 4a6f567..455a6a5 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -620,7 +620,10 @@ static int mei_txe_write(struct mei_device *dev,
 	mei_txe_input_ready_interrupt_enable(dev);
 
 	if (!mei_txe_is_input_ready(dev)) {
-		dev_err(&dev->pdev->dev, "Input is not ready");
+		struct mei_fw_status fw_status;
+		mei_fw_status(dev, &fw_status);
+		dev_err(&dev->pdev->dev, "Input is not ready " FW_STS_FMT "\n",
+			FW_STS_PRM(fw_status));
 		return -EAGAIN;
 	}
 
@@ -1039,8 +1042,40 @@ end:
 	return IRQ_HANDLED;
 }
 
+
+/**
+ * mei_txe_fw_status - retrieve fw status from the pci config space
+ *
+ * @dev: the device structure
+ * @fw_status: fw status registers storage
+ *
+ * returns: 0 on success an error code otherwise
+ */
+static int mei_txe_fw_status(struct mei_device *dev,
+			     struct mei_fw_status *fw_status)
+{
+	const u32 pci_cfg_reg[] = {PCI_CFG_TXE_FW_STS0, PCI_CFG_TXE_FW_STS1};
+	int i;
+
+	if (!fw_status)
+		return -EINVAL;
+
+	fw_status->count = 2;
+
+	for (i = 0; i < fw_status->count && i < MEI_FW_STATUS_MAX; i++) {
+		int ret;
+		ret = pci_read_config_dword(dev->pdev,
+				pci_cfg_reg[i], &fw_status->status[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static const struct mei_hw_ops mei_txe_hw_ops = {
 
+	.fw_status = mei_txe_fw_status,
 	.host_is_ready = mei_txe_host_is_ready,
 
 	.pg_state = mei_txe_pg_state,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index abc5ea0..b3f70eb 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -74,9 +74,13 @@ int mei_reset(struct mei_device *dev)
 	if (state != MEI_DEV_INITIALIZING &&
 	    state != MEI_DEV_DISABLED &&
 	    state != MEI_DEV_POWER_DOWN &&
-	    state != MEI_DEV_POWER_UP)
-		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
-			 mei_dev_state_str(state));
+	    state != MEI_DEV_POWER_UP) {
+		struct mei_fw_status fw_status;
+		mei_fw_status(dev, &fw_status);
+		dev_warn(&dev->pdev->dev,
+			"unexpected reset: dev_state = %s " FW_STS_FMT "\n",
+			mei_dev_state_str(state), FW_STS_PRM(fw_status));
+	}
 
 	/* we're already in reset, cancel the init timer
 	 * if the reset was called due the hbm protocol error
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index beff9ef..1aaaf0b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -153,6 +153,20 @@ struct mei_msg_data {
 	unsigned char *data;
 };
 
+/* Maximum number of processed FW status registers */
+#define MEI_FW_STATUS_MAX 2
+
+/*
+ * struct mei_fw_status - storage of FW status data
+ *
+ * @count - number of actually available elements in array
+ * @status - FW status registers
+ */
+struct mei_fw_status {
+	int count;
+	u32 status[MEI_FW_STATUS_MAX];
+};
+
 /**
  * struct mei_me_client - representation of me (fw) client
  *
@@ -213,6 +227,7 @@ struct mei_cl {
 
 /** struct mei_hw_ops
  *
+ * @fw_status        - read FW status from PCI config space
  * @host_is_ready    - query for host readiness
 
  * @hw_is_ready      - query if hw is ready
@@ -240,6 +255,8 @@ struct mei_cl {
  */
 struct mei_hw_ops {
 
+	int (*fw_status)(struct mei_device *dev,
+		struct mei_fw_status *fw_status);
 	bool (*host_is_ready)(struct mei_device *dev);
 
 	bool (*hw_is_ready)(struct mei_device *dev);
@@ -681,6 +698,17 @@ static inline int mei_count_full_read_slots(struct mei_device *dev)
 	return dev->ops->rdbuf_full_slots(dev);
 }
 
+static inline int mei_fw_status(struct mei_device *dev,
+				struct mei_fw_status *fw_status)
+{
+	return dev->ops->fw_status(dev, fw_status);
+}
+
+#define FW_STS_FMT "%08X %08X"
+#define FW_STS_PRM(fw_status) \
+	(fw_status).count > 0 ? (fw_status).status[0] : 0xDEADBEEF, \
+	(fw_status).count > 1 ? (fw_status).status[1] : 0xDEADBEEF
+
 bool mei_hbuf_acquire(struct mei_device *dev);
 
 bool mei_write_is_idle(struct mei_device *dev);
-- 
1.9.0

