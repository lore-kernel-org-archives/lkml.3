Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaEMIXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:23:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:52038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759466AbaEMIXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510767497"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: add WPT second mei interface
Date: Tue, 13 May 2014 11:22:01 +0300
Message-Id: <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add WPT second mei interface.
In order for correct device numbering we add mei device interface id
to to mei_cfg structure

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/hw-me.c      | 5 +++++
 drivers/misc/mei/hw-me.h      | 1 +
 drivers/misc/mei/main.c       | 2 +-
 drivers/misc/mei/mei_dev.h    | 2 ++
 drivers/misc/mei/pci-me.c     | 1 +
 6 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index a7856c0..c5feafd 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -115,6 +115,7 @@
 #define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
 
 #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
+#define MEI_DEV_ID_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
 
 /* Host Firmware Status Registers in PCI Config Space */
 #define PCI_CFG_HFS_1         0x40
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6a2d272..9066bb1 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -844,6 +844,11 @@ const struct mei_cfg mei_me_pch_cfg = {
 	MEI_CFG_PCH_HFS,
 };
 
+/* PCH devices MEI 2 interface */
+const struct mei_cfg mei_me_pch_2_cfg = {
+	MEI_CFG_PCH_HFS,
+	.mei_id = 1
+};
 
 /* PCH Cougar Point and Patsburg with quirk for Node Manager exclusion */
 const struct mei_cfg mei_me_pch_cpt_pbg_cfg = {
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 12b0f4b..6fb841f 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -41,6 +41,7 @@ struct mei_me_hw {
 extern const struct mei_cfg mei_me_legacy_cfg;
 extern const struct mei_cfg mei_me_ich_cfg;
 extern const struct mei_cfg mei_me_pch_cfg;
+extern const struct mei_cfg mei_me_pch_2_cfg;
 extern const struct mei_cfg mei_me_pch_cpt_pbg_cfg;
 extern const struct mei_cfg mei_me_lpt_cfg;
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index c58e059..cf4ed5a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -667,7 +667,7 @@ int mei_register(struct mei_device *dev)
 {
 
 	int ret, devno;
-	int id = 0; /* FIXME: retrieve interface version*/
+	int id = dev->cfg->mei_id;
 
 	/* Fill in the data structures */
 	devno = MKDEV(MAJOR(mei_devt), id);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index a418565..a521783 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -384,10 +384,12 @@ enum mei_pg_state {
  *
  * @fw_status - FW status
  * @quirk_probe - device exclusion quirk
+ * @mei_id - id of mei device
  */
 struct mei_cfg {
 	const struct mei_fw_status fw_status;
 	bool (*quirk_probe)(struct pci_dev *pdev);
+	int mei_id;
 };
 
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index cf4f654..bb1a8c9 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -81,6 +81,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_lpt_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, mei_me_pch_2_cfg)},
 
 	/* required last entry */
 	{0, }
-- 
1.9.0

