Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaDHCA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:00:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:26233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbaDHB7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:59:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516557748"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 7/9] ntb: Use pci_msix_vec_count() to obtain number of MSI-Xs
Date: Mon,  7 Apr 2014 17:52:52 -0700
Message-Id: <1396918374-5196-8-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c | 15 ++++-----------
 drivers/ntb/ntb_hw.h |  2 --
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index eba1ed5..06d605c 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1086,19 +1086,12 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 	struct msix_entry *msix;
 	int msix_entries;
 	int rc, i;
-	u16 val;
 
-	if (!pdev->msix_cap) {
-		rc = -EIO;
-		goto err;
-	}
-
-	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
-	if (rc)
+	msix_entries = pci_msix_vec_count(pdev);
+	if (msix_entries < 0) {
+		rc = msix_entries;
 		goto err;
-
-	msix_entries = msix_table_size(val);
-	if (msix_entries > ndev->limits.msix_cnt) {
+	} else if (msix_entries > ndev->limits.msix_cnt) {
 		rc = -EINVAL;
 		goto err;
 	}
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 923a0fb..465517b 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -61,8 +61,6 @@
 #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
 
-#define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
-
 #ifndef readq
 static inline u64 readq(void __iomem *addr)
 {
-- 
1.8.3.2

