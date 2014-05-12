Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaELWbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:31:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:51588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaELWbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1038,1389772800"; 
   d="scan'208";a="431204298"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 2/2] mei: me: move probe quirk to cfg structure
Date: Tue, 13 May 2014 01:30:54 +0300
Message-Id: <1399933854-2665-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399933854-2665-1-git-send-email-tomas.winkler@intel.com>
References: <1399933854-2665-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move quirk FW type detector to cfg structure

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   | 37 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw-me.h   |  2 ++
 drivers/misc/mei/mei_dev.h |  2 ++
 drivers/misc/mei/pci-me.c  | 47 +++++++++++++---------------------------------
 4 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ed08118..6a2d272 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -792,6 +792,30 @@ static const struct mei_hw_ops mei_me_hw_ops = {
 	.read = mei_me_read_slots
 };
 
+static bool mei_me_fw_type_nm(struct pci_dev *pdev)
+{
+	u32 reg;
+	pci_read_config_dword(pdev, PCI_CFG_HFS_2, &reg);
+	/* make sure that bit 9 (NM) is up and bit 10 (DM) is down */
+	return (reg & 0x600) == 0x200;
+}
+
+#define MEI_CFG_FW_NM                           \
+	.quirk_probe = mei_me_fw_type_nm
+
+static bool mei_me_fw_type_sps(struct pci_dev *pdev)
+{
+	u32 reg;
+	/* Read ME FW Status check for SPS Firmware */
+	pci_read_config_dword(pdev, PCI_CFG_HFS_1, &reg);
+	/* if bits [19:16] = 15, running SPS Firmware */
+	return (reg & 0xf0000) == 0xf0000;
+}
+
+#define MEI_CFG_FW_SPS                           \
+	.quirk_probe = mei_me_fw_type_sps
+
+
 #define MEI_CFG_LEGACY_HFS                      \
 	.fw_status.count = 0
 
@@ -820,6 +844,19 @@ const struct mei_cfg mei_me_pch_cfg = {
 	MEI_CFG_PCH_HFS,
 };
 
+
+/* PCH Cougar Point and Patsburg with quirk for Node Manager exclusion */
+const struct mei_cfg mei_me_pch_cpt_pbg_cfg = {
+	MEI_CFG_PCH_HFS,
+	MEI_CFG_FW_NM,
+};
+
+/* PCH Lynx Point with quirk for SPS Firmware exclusion */
+const struct mei_cfg mei_me_lpt_cfg = {
+	MEI_CFG_PCH_HFS,
+	MEI_CFG_FW_SPS,
+};
+
 /**
  * mei_me_dev_init - allocates and initializes the mei device structure
  *
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 473aafb..12b0f4b 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -41,6 +41,8 @@ struct mei_me_hw {
 extern const struct mei_cfg mei_me_legacy_cfg;
 extern const struct mei_cfg mei_me_ich_cfg;
 extern const struct mei_cfg mei_me_pch_cfg;
+extern const struct mei_cfg mei_me_pch_cpt_pbg_cfg;
+extern const struct mei_cfg mei_me_lpt_cfg;
 
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 				   const struct mei_cfg *cfg);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 909d13d..5c7e990 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -383,9 +383,11 @@ enum mei_pg_state {
  * mei_cfg
  *
  * @fw_status - FW status
+ * @quirk_probe - device exclusion quirk
  */
 struct mei_cfg {
 	const struct mei_fw_status fw_status;
+	bool (*quirk_probe)(struct pci_dev *pdev);
 };
 
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 6cb9819..1b46c64 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -72,15 +72,15 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_1, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_2, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CPT_1, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PBG_1, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CPT_1, mei_me_pch_cpt_pbg_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PBG_1, mei_me_pch_cpt_pbg_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, mei_me_lpt_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, mei_me_lpt_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, mei_me_pch_cfg)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_lpt_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, mei_me_pch_cfg)},
 
 	/* required last entry */
@@ -101,40 +101,21 @@ static inline void mei_me_unset_pm_domain(struct mei_device *dev) {}
  * mei_quirk_probe - probe for devices that doesn't valid ME interface
  *
  * @pdev: PCI device structure
- * @ent: entry into pci_device_table
+ * @cfg: per generation config
  *
  * returns true if ME Interface is valid, false otherwise
  */
 static bool mei_me_quirk_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+				const struct mei_cfg *cfg)
 {
-	u32 reg;
-	/* Cougar Point || Patsburg */
-	if (ent->device == MEI_DEV_ID_CPT_1 ||
-	    ent->device == MEI_DEV_ID_PBG_1) {
-		pci_read_config_dword(pdev, PCI_CFG_HFS_2, &reg);
-		/* make sure that bit 9 (NM) is up and bit 10 (DM) is down */
-		if ((reg & 0x600) == 0x200)
-			goto no_mei;
-	}
-
-	/* Lynx Point */
-	if (ent->device == MEI_DEV_ID_LPT_H  ||
-	    ent->device == MEI_DEV_ID_LPT_W  ||
-	    ent->device == MEI_DEV_ID_LPT_HR) {
-		/* Read ME FW Status check for SPS Firmware */
-		pci_read_config_dword(pdev, PCI_CFG_HFS_1, &reg);
-		/* if bits [19:16] = 15, running SPS Firmware */
-		if ((reg & 0xf0000) == 0xf0000)
-			goto no_mei;
+	if (cfg->quirk_probe && cfg->quirk_probe(pdev)) {
+		dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+		return false;
 	}
 
 	return true;
-
-no_mei:
-	dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
-	return false;
 }
+
 /**
  * mei_probe - Device Initialization Routine
  *
@@ -151,10 +132,8 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int err;
 
 
-	if (!mei_me_quirk_probe(pdev, ent)) {
-		err = -ENODEV;
-		goto end;
-	}
+	if (!mei_me_quirk_probe(pdev, cfg))
+		return -ENODEV;
 
 	/* enable pci dev */
 	err = pci_enable_device(pdev);
-- 
1.9.0

