Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3GXPoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:44:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:53657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3GXPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="350846054"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei me: add handler for me_hw_ops fw_status
Date: Wed, 24 Jul 2013 18:41:55 +0300
Message-Id: <1374680517-30894-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FW status is read from mei pci configuration space.
The register address depends on the plataform id

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h |  9 +++++++++
 drivers/misc/mei/hw-me.c      | 30 ++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6a203b6..3f612ce 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -111,10 +111,19 @@
 
 #define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
 #define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
+
 /*
  * MEI HW Section
  */
 
+/* Host Firmware Status in Platforms < LPT */
+#define PCI_CFG_HFS_PPT   0x40
+/* Host Firmware Status in Platforms >= LPT */
+#define PCI_CFG_HFS_LPT 0x60
+#  define PCI_CFG_HFS_STATE_MSK    0x0000000F
+#  define PCI_CFG_HFS_ISR_CNT_MSK  0x00000600
+#  define PCI_CFG_HFS_ERR_CODE_MSK 0x0000F000
+
 /* MEI registers */
 /* H_CB_WW - Host Circular Buffer (CB) Write Window register */
 #define H_CB_WW    0
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index b22c7e2..2346167 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -536,8 +536,38 @@ end:
 
 	return IRQ_HANDLED;
 }
+
+/**
+ * mei_me_fw_status  - retrieve fw status from the pci config space
+ *
+ * @dev: the device structure
+ * @fw_status: fw status register value
+ *
+ * returns 0 on success an error code otherwise
+ */
+static int mei_me_fw_status(struct mei_device *dev, u32 *fw_status)
+{
+	u32 reg;
+	if (!dev || !fw_status)
+		return -EINVAL;
+
+	switch (dev->pdev->device) {
+	case MEI_DEV_ID_LPT:
+	case MEI_DEV_ID_LPT_LP:
+		reg = PCI_CFG_HFS_LPT;
+		break;
+	default:
+		reg = PCI_CFG_HFS_PPT;
+		break;
+	}
+
+	return pci_read_config_dword(dev->pdev, reg, fw_status);
+}
+
 static const struct mei_hw_ops mei_me_hw_ops = {
 
+	.fw_status = mei_me_fw_status,
+
 	.host_is_ready = mei_me_host_is_ready,
 
 	.hw_is_ready = mei_me_hw_is_ready,
-- 
1.8.1.2

