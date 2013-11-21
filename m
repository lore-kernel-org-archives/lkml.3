Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3KUAVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:21:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:6670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3KUAVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="431181596"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] NTB: Enable Snoop on Primary Side
Date: Wed, 20 Nov 2013 17:21:29 -0700
Message-Id: <1384993290-10107-9-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Snoop from Primary to Secondary side on BAR23 and BAR45 on all
TLPs.  Previously, Snoop was only enabled from Secondary to Primary
side.  This can have a performance improvement on some workloads.

Also, make the code more obvious about how the link is being enabled.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |   17 ++++++++++++-----
 drivers/ntb/ntb_regs.h |   12 +++++++-----
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 391c377..80505ae 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1316,10 +1316,16 @@ static void ntb_hw_link_up(struct ntb_device *ndev)
 {
 	if (ndev->conn_type == NTB_CONN_TRANSPARENT)
 		ntb_link_event(ndev, NTB_LINK_UP);
-	else
+	else {
+		u32 ntb_cntl;
+
 		/* Let's bring the NTB link up */
-		writel(NTB_CNTL_BAR23_SNOOP | NTB_CNTL_BAR45_SNOOP,
-		       ndev->reg_ofs.lnk_cntl);
+		ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
+		ntb_cntl &= ~(NTB_CNTL_LINK_DISABLE | NTB_CNTL_CFG_LOCK);
+		ntb_cntl |= NTB_CNTL_P2S_BAR23_SNOOP | NTB_CNTL_S2P_BAR23_SNOOP;
+		ntb_cntl |= NTB_CNTL_P2S_BAR45_SNOOP | NTB_CNTL_S2P_BAR45_SNOOP;
+		writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
+	}
 }
 
 static void ntb_hw_link_down(struct ntb_device *ndev)
@@ -1333,8 +1339,9 @@ static void ntb_hw_link_down(struct ntb_device *ndev)
 
 	/* Bring NTB link down */
 	ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
-	ntb_cntl &= ~(NTB_CNTL_BAR23_SNOOP | NTB_CNTL_BAR45_SNOOP);
-	ntb_cntl |= NTB_CNTL_LINK_DISABLE;
+	ntb_cntl &= ~(NTB_CNTL_P2S_BAR23_SNOOP | NTB_CNTL_S2P_BAR23_SNOOP);
+	ntb_cntl &= ~(NTB_CNTL_P2S_BAR45_SNOOP | NTB_CNTL_S2P_BAR45_SNOOP);
+	ntb_cntl |= NTB_CNTL_LINK_DISABLE | NTB_CNTL_CFG_LOCK;
 	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
 }
 
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index a689f1c..9774506 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -143,11 +143,13 @@
 #define BWD_LTSSMSTATEJMP_FORCEDETECT	(1 << 2)
 #define BWD_IBIST_ERR_OFLOW	0x7FFF7FFF
 
-#define NTB_CNTL_CFG_LOCK	(1 << 0)
-#define NTB_CNTL_LINK_DISABLE	(1 << 1)
-#define NTB_CNTL_BAR23_SNOOP	(1 << 2)
-#define NTB_CNTL_BAR45_SNOOP	(1 << 6)
-#define BWD_CNTL_LINK_DOWN	(1 << 16)
+#define NTB_CNTL_CFG_LOCK		(1 << 0)
+#define NTB_CNTL_LINK_DISABLE		(1 << 1)
+#define NTB_CNTL_S2P_BAR23_SNOOP	(1 << 2)
+#define NTB_CNTL_P2S_BAR23_SNOOP	(1 << 4)
+#define NTB_CNTL_S2P_BAR45_SNOOP	(1 << 6)
+#define NTB_CNTL_P2S_BAR45_SNOOP	(1 << 8)
+#define BWD_CNTL_LINK_DOWN		(1 << 16)
 
 #define NTB_PPD_OFFSET		0x00D4
 #define SNB_PPD_CONN_TYPE	0x0003
-- 
1.7.9.5

