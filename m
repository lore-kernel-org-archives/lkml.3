Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaKSPEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:04:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:56254 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbaKSPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:04:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="624910766"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: read and print all six FW status registers
Date: Wed, 19 Nov 2014 17:01:38 +0200
Message-Id: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

ME devices prior to PCH8 (Lynx Point) have two FW status registers,
on PCH8 and newer excluding txe there are six FW status registers.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 12 ++++++++----
 drivers/misc/mei/hw-me.c      | 19 ++++++++++++++++---
 drivers/misc/mei/hw-me.h      |  3 ++-
 drivers/misc/mei/hw-txe.c     |  7 +++----
 drivers/misc/mei/init.c       | 38 +++++++++++++++++++++++++++++++++-----
 drivers/misc/mei/mei_dev.h    | 38 ++++++++++++++++++++++++++++++++------
 drivers/misc/mei/pci-me.c     | 12 ++++++------
 7 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index c5feafdd58a8..9eb7ed70ace2 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,14 +117,18 @@
 #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
 #define MEI_DEV_ID_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
 
-/* Host Firmware Status Registers in PCI Config Space */
-#define PCI_CFG_HFS_1         0x40
-#define PCI_CFG_HFS_2         0x48
-
 /*
  * MEI HW Section
  */
 
+/* Host Firmware Status Registers in PCI Config Space */
+#define PCI_CFG_HFS_1         0x40
+#define PCI_CFG_HFS_2         0x48
+#define PCI_CFG_HFS_3         0x60
+#define PCI_CFG_HFS_4         0x64
+#define PCI_CFG_HFS_5         0x68
+#define PCI_CFG_HFS_6         0x6C
+
 /* MEI registers */
 /* H_CB_WW - Host Circular Buffer (CB) Write Window register */
 #define H_CB_WW    0
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 7ce7cf4b6092..ff2755062b44 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -835,6 +835,14 @@ static bool mei_me_fw_type_sps(struct pci_dev *pdev)
 	.fw_status.status[0] = PCI_CFG_HFS_1,   \
 	.fw_status.status[1] = PCI_CFG_HFS_2
 
+#define MEI_CFG_PCH8_HFS                        \
+	.fw_status.count = 6,                   \
+	.fw_status.status[0] = PCI_CFG_HFS_1,   \
+	.fw_status.status[1] = PCI_CFG_HFS_2,   \
+	.fw_status.status[2] = PCI_CFG_HFS_3,   \
+	.fw_status.status[3] = PCI_CFG_HFS_4,   \
+	.fw_status.status[4] = PCI_CFG_HFS_5,   \
+	.fw_status.status[5] = PCI_CFG_HFS_6
 
 /* ICH Legacy devices */
 const struct mei_cfg mei_me_legacy_cfg = {
@@ -858,9 +866,14 @@ const struct mei_cfg mei_me_pch_cpt_pbg_cfg = {
 	MEI_CFG_FW_NM,
 };
 
-/* PCH Lynx Point with quirk for SPS Firmware exclusion */
-const struct mei_cfg mei_me_lpt_cfg = {
-	MEI_CFG_PCH_HFS,
+/* PCH8 Lynx Point and newer devices */
+const struct mei_cfg mei_me_pch8_cfg = {
+	MEI_CFG_PCH8_HFS,
+};
+
+/* PCH8 Lynx Point with quirk for SPS Firmware exclusion */
+const struct mei_cfg mei_me_pch8_sps_cfg = {
+	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_SPS,
 };
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index e44ed1d03911..d6567af44377 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -65,7 +65,8 @@ extern const struct mei_cfg mei_me_legacy_cfg;
 extern const struct mei_cfg mei_me_ich_cfg;
 extern const struct mei_cfg mei_me_pch_cfg;
 extern const struct mei_cfg mei_me_pch_cpt_pbg_cfg;
-extern const struct mei_cfg mei_me_lpt_cfg;
+extern const struct mei_cfg mei_me_pch8_cfg;
+extern const struct mei_cfg mei_me_pch8_sps_cfg;
 
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 				   const struct mei_cfg *cfg);
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index c5e1902e493f..618ea721aca8 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -700,11 +700,10 @@ static int mei_txe_write(struct mei_device *dev,
 	mei_txe_input_ready_interrupt_enable(dev);
 
 	if (!mei_txe_is_input_ready(dev)) {
-		struct mei_fw_status fw_status;
+		char fw_sts_str[MEI_FW_STATUS_STR_SZ];
 
-		mei_fw_status(dev, &fw_status);
-		dev_err(dev->dev, "Input is not ready " FW_STS_FMT "\n",
-			FW_STS_PRM(fw_status));
+		mei_fw_status_str(dev, fw_sts_str, MEI_FW_STATUS_STR_SZ);
+		dev_err(dev->dev, "Input is not ready %s\n", fw_sts_str);
 		return -EAGAIN;
 	}
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 7901d076c127..9306219d5675 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -54,6 +54,35 @@ const char *mei_pg_state_str(enum mei_pg_state state)
 #undef MEI_PG_STATE
 }
 
+/**
+ * mei_fw_status2str - convert fw status registers to printable string
+ *
+ * @fw_status:  firmware status
+ * @buf: string buffer at minimal size MEI_FW_STATUS_STR_SZ
+ * @len: buffer len must be >= MEI_FW_STATUS_STR_SZ
+ *
+ * Return: number of bytes written or -EINVAL if buffer is to small
+ */
+ssize_t mei_fw_status2str(struct mei_fw_status *fw_status,
+			  char *buf, size_t len)
+{
+	ssize_t cnt = 0;
+	int i;
+
+	buf[0] = '\0';
+
+	if (len < MEI_FW_STATUS_STR_SZ)
+		return -EINVAL;
+
+	for (i = 0; i < fw_status->count; i++)
+		cnt += scnprintf(buf + cnt, len - cnt, "%08X ",
+				fw_status->status[i]);
+
+	/* drop last space */
+	buf[cnt] = '\0';
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(mei_fw_status2str);
 
 /**
  * mei_cancel_work - Cancel mei background jobs
@@ -86,12 +115,11 @@ int mei_reset(struct mei_device *dev)
 	    state != MEI_DEV_DISABLED &&
 	    state != MEI_DEV_POWER_DOWN &&
 	    state != MEI_DEV_POWER_UP) {
-		struct mei_fw_status fw_status;
+		char fw_sts_str[MEI_FW_STATUS_STR_SZ];
 
-		mei_fw_status(dev, &fw_status);
-		dev_warn(dev->dev,
-			"unexpected reset: dev_state = %s " FW_STS_FMT "\n",
-			mei_dev_state_str(state), FW_STS_PRM(fw_status));
+		mei_fw_status_str(dev, fw_sts_str, MEI_FW_STATUS_STR_SZ);
+		dev_warn(dev->dev, "unexpected reset: dev_state = %s fw status = %s\n",
+			 mei_dev_state_str(state), fw_sts_str);
 	}
 
 	/* we're already in reset, cancel the init timer
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7d3a1de0b051..49c033158d43 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -152,7 +152,10 @@ struct mei_msg_data {
 };
 
 /* Maximum number of processed FW status registers */
-#define MEI_FW_STATUS_MAX 2
+#define MEI_FW_STATUS_MAX 6
+/* Minimal  buffer for FW status string (8 bytes in dw + space or '\0') */
+#define MEI_FW_STATUS_STR_SZ (MEI_FW_STATUS_MAX * (8 + 1))
+
 
 /*
  * struct mei_fw_status - storage of FW status data
@@ -807,11 +810,6 @@ static inline int mei_fw_status(struct mei_device *dev,
 	return dev->ops->fw_status(dev, fw_status);
 }
 
-#define FW_STS_FMT "%08X %08X"
-#define FW_STS_PRM(fw_status) \
-	(fw_status).count > 0 ? (fw_status).status[0] : 0xDEADBEEF, \
-	(fw_status).count > 1 ? (fw_status).status[1] : 0xDEADBEEF
-
 bool mei_hbuf_acquire(struct mei_device *dev);
 
 bool mei_write_is_idle(struct mei_device *dev);
@@ -835,4 +833,32 @@ void mei_deregister(struct mei_device *dev);
 	(hdr)->host_addr, (hdr)->me_addr, \
 	(hdr)->length, (hdr)->internal, (hdr)->msg_complete
 
+ssize_t mei_fw_status2str(struct mei_fw_status *fw_sts, char *buf, size_t len);
+/**
+ * mei_fw_status_str - fetch and convert fw status registers to printable string
+ *
+ * @dev: the device structure
+ * @buf: string buffer at minimal size MEI_FW_STATUS_STR_SZ
+ * @len: buffer len must be >= MEI_FW_STATUS_STR_SZ
+ *
+ * Return: number of bytes written or < 0 on failure
+ */
+static inline ssize_t mei_fw_status_str(struct mei_device *dev,
+					char *buf, size_t len)
+{
+	struct mei_fw_status fw_status;
+	int ret;
+
+	buf[0] = '\0';
+
+	ret = mei_fw_status(dev, &fw_status);
+	if (ret)
+		return ret;
+
+	ret = mei_fw_status2str(&fw_status, buf, MEI_FW_STATUS_STR_SZ);
+
+	return ret;
+}
+
+
 #endif
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index f3225b1643ab..b0da60f10acf 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -76,12 +76,12 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, mei_me_lpt_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, mei_me_lpt_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_lpt_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, mei_me_pch8_sps_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, mei_me_pch8_sps_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, mei_me_pch8_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_pch8_sps_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, mei_me_pch8_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, mei_me_pch8_cfg)},
 
 	/* required last entry */
 	{0, }
-- 
1.9.3

