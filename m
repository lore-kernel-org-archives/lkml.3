Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaGTKhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:37:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:53485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaGTKhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,695,1400050800"; 
   d="scan'208";a="572660069"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: drop unused hw dependent fw status functions
Date: Sun, 20 Jul 2014 13:36:31 +0300
Message-Id: <1405852591-11632-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We introduced unified FW status function in patch
mei: add per device configuration (lkml.org/lkml/2014/5/12/607)

This change made hw_ops functions unused and obsolete
therefore we remove these functions from source code.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   | 54 ----------------------------------------------
 drivers/misc/mei/hw-txe.c  | 32 ---------------------------
 drivers/misc/mei/mei_dev.h |  3 ---
 3 files changed, 89 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6a2d272..a9a0d08 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -710,64 +710,10 @@ end:
 	return IRQ_HANDLED;
 }
 
-/**
- * mei_me_fw_status - retrieve fw status from the pci config space
- *
- * @dev: the device structure
- * @fw_status: fw status registers storage
- *
- * returns 0 on success an error code otherwise
- */
-static int mei_me_fw_status(struct mei_device *dev,
-			    struct mei_fw_status *fw_status)
-{
-	const u32 pci_cfg_reg[] = {PCI_CFG_HFS_1, PCI_CFG_HFS_2};
-	int i;
-
-	if (!fw_status)
-		return -EINVAL;
-
-	switch (dev->pdev->device) {
-	case MEI_DEV_ID_IBXPK_1:
-	case MEI_DEV_ID_IBXPK_2:
-	case MEI_DEV_ID_CPT_1:
-	case MEI_DEV_ID_PBG_1:
-	case MEI_DEV_ID_PPT_1:
-	case MEI_DEV_ID_PPT_2:
-	case MEI_DEV_ID_PPT_3:
-	case MEI_DEV_ID_LPT_H:
-	case MEI_DEV_ID_LPT_W:
-	case MEI_DEV_ID_LPT_LP:
-	case MEI_DEV_ID_LPT_HR:
-	case MEI_DEV_ID_WPT_LP:
-		fw_status->count = 2;
-		break;
-	case MEI_DEV_ID_ICH10_1:
-	case MEI_DEV_ID_ICH10_2:
-	case MEI_DEV_ID_ICH10_3:
-	case MEI_DEV_ID_ICH10_4:
-		fw_status->count = 1;
-		break;
-	default:
-		fw_status->count = 0;
-		break;
-	}
-
-	for (i = 0; i < fw_status->count && i < MEI_FW_STATUS_MAX; i++) {
-		int ret;
-		ret = pci_read_config_dword(dev->pdev,
-				pci_cfg_reg[i], &fw_status->status[i]);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 static const struct mei_hw_ops mei_me_hw_ops = {
 
 	.pg_state  = mei_me_pg_state,
 
-	.fw_status = mei_me_fw_status,
 	.host_is_ready = mei_me_host_is_ready,
 
 	.hw_is_ready = mei_me_hw_is_ready,
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 9327378..f1cd166 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -1042,40 +1042,8 @@ end:
 	return IRQ_HANDLED;
 }
 
-
-/**
- * mei_txe_fw_status - retrieve fw status from the pci config space
- *
- * @dev: the device structure
- * @fw_status: fw status registers storage
- *
- * returns: 0 on success an error code otherwise
- */
-static int mei_txe_fw_status(struct mei_device *dev,
-			     struct mei_fw_status *fw_status)
-{
-	const u32 pci_cfg_reg[] = {PCI_CFG_TXE_FW_STS0, PCI_CFG_TXE_FW_STS1};
-	int i;
-
-	if (!fw_status)
-		return -EINVAL;
-
-	fw_status->count = 2;
-
-	for (i = 0; i < fw_status->count && i < MEI_FW_STATUS_MAX; i++) {
-		int ret;
-		ret = pci_read_config_dword(dev->pdev,
-				pci_cfg_reg[i], &fw_status->status[i]);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static const struct mei_hw_ops mei_txe_hw_ops = {
 
-	.fw_status = mei_txe_fw_status,
 	.host_is_ready = mei_txe_host_is_ready,
 
 	.pg_state = mei_txe_pg_state,
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 2afa3d6..0b0d613 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -227,7 +227,6 @@ struct mei_cl {
 
 /** struct mei_hw_ops
  *
- * @fw_status        - read FW status from PCI config space
  * @host_is_ready    - query for host readiness
 
  * @hw_is_ready      - query if hw is ready
@@ -255,8 +254,6 @@ struct mei_cl {
  */
 struct mei_hw_ops {
 
-	int (*fw_status)(struct mei_device *dev,
-		struct mei_fw_status *fw_status);
 	bool (*host_is_ready)(struct mei_device *dev);
 
 	bool (*hw_is_ready)(struct mei_device *dev);
-- 
1.9.3

