Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3KUAWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:22:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:57746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab3KUAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438872111"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] NTB: Fix NTB-RP Link Up
Date: Wed, 20 Nov 2013 17:21:23 -0700
Message-Id: <1384993290-10107-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xeon NTB-RP setup, the transparent side does not get a link up/down
interrupt.  Since the presence of a NTB device on the transparent side
means that we have a NTB link up, we can work around the lack of an
interrupt by simply calling the link up function to notify the upper
layers.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 6c9d733..a9b065f 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1296,6 +1296,32 @@ static void ntb_free_debugfs(struct ntb_device *ndev)
 	}
 }
 
+static void ntb_hw_link_up(struct ntb_device *ndev)
+{
+	if (ndev->conn_type == NTB_CONN_TRANSPARENT)
+		ntb_link_event(ndev, NTB_LINK_UP);
+	else
+		/* Let's bring the NTB link up */
+		writel(NTB_CNTL_BAR23_SNOOP | NTB_CNTL_BAR45_SNOOP,
+		       ndev->reg_ofs.lnk_cntl);
+}
+
+static void ntb_hw_link_down(struct ntb_device *ndev)
+{
+	u32 ntb_cntl;
+
+	if (ndev->conn_type == NTB_CONN_TRANSPARENT) {
+		ntb_link_event(ndev, NTB_LINK_DOWN);
+		return;
+	}
+
+	/* Bring NTB link down */
+	ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
+	ntb_cntl &= ~(NTB_CNTL_BAR23_SNOOP | NTB_CNTL_BAR45_SNOOP);
+	ntb_cntl |= NTB_CNTL_LINK_DISABLE;
+	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
+}
+
 static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ntb_device *ndev;
@@ -1384,9 +1410,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err6;
 
-	/* Let's bring the NTB link up */
-	writel(NTB_CNTL_BAR23_SNOOP | NTB_CNTL_BAR45_SNOOP,
-	       ndev->reg_ofs.lnk_cntl);
+	ntb_hw_link_up(ndev);
 
 	return 0;
 
@@ -1416,12 +1440,8 @@ static void ntb_pci_remove(struct pci_dev *pdev)
 {
 	struct ntb_device *ndev = pci_get_drvdata(pdev);
 	int i;
-	u32 ntb_cntl;
 
-	/* Bring NTB link down */
-	ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
-	ntb_cntl |= NTB_CNTL_LINK_DISABLE;
-	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
+	ntb_hw_link_down(ndev);
 
 	ntb_transport_free(ndev->ntb_transport);
 
-- 
1.7.9.5

