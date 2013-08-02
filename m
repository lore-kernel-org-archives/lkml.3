Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3HBRgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:20732 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3HBRgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380308503"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] NTB: Remove References of non-B2B BWD HW
Date: Fri,  2 Aug 2013 10:35:41 -0700
Message-Id: <1375464944-27914-13-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NTB-RP is not a supported configuration on BWD hardware.  Remove the
code attempting to set it up.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |   16 ++++------------
 drivers/ntb/ntb_regs.h |    1 -
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 371b65e..8153bea 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -829,7 +829,7 @@ static int ntb_bwd_setup(struct ntb_device *ndev)
 		break;
 	case NTB_CONN_RP:
 	default:
-		dev_err(&ndev->pdev->dev, "Only B2B supported at this time\n");
+		dev_err(&ndev->pdev->dev, "Unsupported NTB configuration\n");
 		return -EINVAL;
 	}
 
@@ -846,24 +846,16 @@ static int ntb_bwd_setup(struct ntb_device *ndev)
 
 	ndev->reg_ofs.ldb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
 	ndev->reg_ofs.ldb_mask = ndev->reg_base + BWD_PDBMSK_OFFSET;
+	ndev->reg_ofs.rdb = ndev->reg_base + BWD_B2B_DOORBELL_OFFSET;
 	ndev->reg_ofs.bar2_xlat = ndev->reg_base + BWD_SBAR2XLAT_OFFSET;
 	ndev->reg_ofs.bar4_xlat = ndev->reg_base + BWD_SBAR4XLAT_OFFSET;
 	ndev->reg_ofs.lnk_cntl = ndev->reg_base + BWD_NTBCNTL_OFFSET;
 	ndev->reg_ofs.lnk_stat = ndev->reg_base + BWD_LINK_STATUS_OFFSET;
 	ndev->reg_ofs.spad_read = ndev->reg_base + BWD_SPAD_OFFSET;
+	ndev->reg_ofs.spad_write = ndev->reg_base + BWD_B2B_SPAD_OFFSET;
 	ndev->reg_ofs.spci_cmd = ndev->reg_base + BWD_PCICMD_OFFSET;
-
-	if (ndev->conn_type == NTB_CONN_B2B) {
-		ndev->reg_ofs.rdb = ndev->reg_base + BWD_B2B_DOORBELL_OFFSET;
-		ndev->reg_ofs.spad_write = ndev->reg_base + BWD_B2B_SPAD_OFFSET;
-		ndev->limits.max_spads = BWD_MAX_SPADS;
-	} else {
-		ndev->reg_ofs.rdb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
-		ndev->reg_ofs.spad_write = ndev->reg_base + BWD_SPAD_OFFSET;
-		ndev->limits.max_spads = BWD_MAX_COMPAT_SPADS;
-	}
-
 	ndev->limits.max_mw = BWD_MAX_MW;
+	ndev->limits.max_spads = BWD_MAX_SPADS;
 	ndev->limits.max_db_bits = BWD_MAX_DB_BITS;
 	ndev->limits.msix_cnt = BWD_MSIX_CNT;
 	ndev->bits_per_vector = BWD_DB_BITS_PER_VEC;
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 910d5e9..57aefbb 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -103,7 +103,6 @@
 
 #define BWD_MSIX_CNT		34
 #define BWD_MAX_SPADS		16
-#define BWD_MAX_COMPAT_SPADS	16
 #define BWD_MAX_DB_BITS		34
 #define BWD_DB_BITS_PER_VEC	1
 #define BWD_MAX_MW		2
-- 
1.7.9.5

