Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaI2NfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:32046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbaI2NdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030088"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 13/18] mei: push pci cfg structure me hw
Date: Mon, 29 Sep 2014 16:31:45 +0300
Message-Id: <1411997510-29094-14-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device specific configurations are currently only needed by me hw
so we can remove it from txe

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   |  7 +++++--
 drivers/misc/mei/hw-me.h   | 26 +++++++++++++++++++++++++-
 drivers/misc/mei/hw-txe.c  | 22 +++++++---------------
 drivers/misc/mei/hw-txe.h  |  5 +----
 drivers/misc/mei/mei_dev.h | 20 --------------------
 drivers/misc/mei/pci-txe.c |  6 +++---
 6 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index da86310..77166ea 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -110,8 +110,9 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 static int mei_me_fw_status(struct mei_device *dev,
 			    struct mei_fw_status *fw_status)
 {
-	const struct mei_fw_status *fw_src = &dev->cfg->fw_status;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	const struct mei_fw_status *fw_src = &hw->cfg->fw_status;
 	int ret;
 	int i;
 
@@ -846,14 +847,16 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 				   const struct mei_cfg *cfg)
 {
 	struct mei_device *dev;
+	struct mei_me_hw *hw;
 
 	dev = kzalloc(sizeof(struct mei_device) +
 			 sizeof(struct mei_me_hw), GFP_KERNEL);
 	if (!dev)
 		return NULL;
+	hw = to_me_hw(dev);
 
 	mei_device_init(dev, &pdev->dev, &mei_me_hw_ops);
-	dev->cfg  = cfg;
+	hw->cfg = cfg;
 	return dev;
 }
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 12b0f4b..b0001b3 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -19,14 +19,38 @@
 #ifndef _MEI_INTERFACE_H_
 #define _MEI_INTERFACE_H_
 
-#include <linux/mei.h>
 #include <linux/irqreturn.h>
+#include <linux/pci.h>
+#include <linux/mei.h>
+
 #include "mei_dev.h"
 #include "client.h"
 
+/*
+ * mei_cfg - mei device configuration
+ *
+ * @fw_status: FW status
+ * @quirk_probe: device exclusion quirk
+ */
+struct mei_cfg {
+	const struct mei_fw_status fw_status;
+	bool (*quirk_probe)(struct pci_dev *pdev);
+};
+
+
+#define MEI_PCI_DEVICE(dev, cfg) \
+	.vendor = PCI_VENDOR_ID_INTEL, .device = (dev), \
+	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, \
+	.driver_data = (kernel_ulong_t)&(cfg)
+
+
 #define MEI_ME_RPM_TIMEOUT    500 /* ms */
 
+/**
+ * @cfg: per device generation config and ops
+ */
 struct mei_me_hw {
+	const struct mei_cfg *cfg;
 	void __iomem *mem_addr;
 	/*
 	 * hw states of host and fw(ME)
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 6eef676..f33fbcb 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -573,6 +573,11 @@ static int mei_txe_readiness_wait(struct mei_device *dev)
 	return 0;
 }
 
+const struct mei_fw_status mei_txe_fw_sts = {
+	.count = 2,
+	.status[0] = PCI_CFG_TXE_FW_STS0,
+	.status[1] = PCI_CFG_TXE_FW_STS1
+};
 
 /**
  * mei_txe_fw_status - read fw status register from pci config space
@@ -583,7 +588,7 @@ static int mei_txe_readiness_wait(struct mei_device *dev)
 static int mei_txe_fw_status(struct mei_device *dev,
 			     struct mei_fw_status *fw_status)
 {
-	const struct mei_fw_status *fw_src = &dev->cfg->fw_status;
+	const struct mei_fw_status *fw_src = &mei_txe_fw_sts;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	int ret;
 	int i;
@@ -1120,27 +1125,15 @@ static const struct mei_hw_ops mei_txe_hw_ops = {
 
 };
 
-#define MEI_CFG_TXE_FW_STS                            \
-	.fw_status.count = 2,                         \
-	.fw_status.status[0] = PCI_CFG_TXE_FW_STS0,   \
-	.fw_status.status[1] = PCI_CFG_TXE_FW_STS1
-
-const struct mei_cfg mei_txe_cfg = {
-	MEI_CFG_TXE_FW_STS,
-};
-
-
 /**
  * mei_txe_dev_init - allocates and initializes txe hardware specific structure
  *
  * @pdev - pci device
- * @cfg - per device generation config
  *
  * returns struct mei_device * on success or NULL;
  *
  */
-struct mei_device *mei_txe_dev_init(struct pci_dev *pdev,
-				    const struct mei_cfg *cfg)
+struct mei_device *mei_txe_dev_init(struct pci_dev *pdev)
 {
 	struct mei_device *dev;
 	struct mei_txe_hw *hw;
@@ -1156,7 +1149,6 @@ struct mei_device *mei_txe_dev_init(struct pci_dev *pdev,
 
 	init_waitqueue_head(&hw->wait_aliveness_resp);
 
-	dev->cfg  = cfg;
 	return dev;
 }
 
diff --git a/drivers/misc/mei/hw-txe.h b/drivers/misc/mei/hw-txe.h
index e244af7..e8dd2d1 100644
--- a/drivers/misc/mei/hw-txe.h
+++ b/drivers/misc/mei/hw-txe.h
@@ -61,10 +61,7 @@ static inline struct mei_device *hw_txe_to_mei(struct mei_txe_hw *hw)
 	return container_of((void *)hw, struct mei_device, hw);
 }
 
-extern const struct mei_cfg mei_txe_cfg;
-
-struct mei_device *mei_txe_dev_init(struct pci_dev *pdev,
-	const struct mei_cfg *cfg);
+struct mei_device *mei_txe_dev_init(struct pci_dev *pdev);
 
 irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id);
 irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 5a16cc4..fed4c96 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -380,24 +380,6 @@ enum mei_pg_state {
 
 const char *mei_pg_state_str(enum mei_pg_state state);
 
-/*
- * mei_cfg
- *
- * @fw_status - FW status
- * @quirk_probe - device exclusion quirk
- */
-struct mei_cfg {
-	const struct mei_fw_status fw_status;
-	bool (*quirk_probe)(struct pci_dev *pdev);
-};
-
-
-#define MEI_PCI_DEVICE(dev, cfg) \
-	.vendor = PCI_VENDOR_ID_INTEL, .device = (dev), \
-	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, \
-	.driver_data = (kernel_ulong_t)&(cfg)
-
-
 /**
  * struct mei_device -  MEI private device struct
 
@@ -416,7 +398,6 @@ struct mei_cfg {
  * @hbuf_depth - depth of hardware host/write buffer is slots
  * @hbuf_is_ready - query if the host host/write buffer is ready
  * @wr_msg - the buffer for hbm control messages
- * @cfg - per device generation config and ops
  */
 struct mei_device {
 	struct device *dev;
@@ -530,7 +511,6 @@ struct mei_device {
 
 
 	const struct mei_hw_ops *ops;
-	const struct mei_cfg *cfg;
 	char hw[0] __aligned(sizeof(void *));
 };
 
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index cd9dda7..69eb999 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -36,7 +36,8 @@
 #include "hw-txe.h"
 
 static const struct pci_device_id mei_txe_pci_tbl[] = {
-	{MEI_PCI_DEVICE(0x0F18, mei_txe_cfg)}, /* Baytrail */
+	{PCI_VDEVICE(INTEL, 0x0F18)}, /* Baytrail */
+
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, mei_txe_pci_tbl);
@@ -70,7 +71,6 @@ static void mei_txe_pci_iounmap(struct pci_dev *pdev, struct mei_txe_hw *hw)
  */
 static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	const struct mei_cfg *cfg = (struct mei_cfg *)(ent->driver_data);
 	struct mei_device *dev;
 	struct mei_txe_hw *hw;
 	int err;
@@ -101,7 +101,7 @@ static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* allocates and initializes the mei dev structure */
-	dev = mei_txe_dev_init(pdev, cfg);
+	dev = mei_txe_dev_init(pdev);
 	if (!dev) {
 		err = -ENOMEM;
 		goto release_regions;
-- 
1.9.3

