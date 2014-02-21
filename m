Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaBUPsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:48:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaBUPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:47:40 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jon Mason <jon.mason@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/4] ntb: Use pci_msix_vec_count() to obtain number of MSI-Xs
Date: Fri, 21 Feb 2014 16:49:30 +0100
Message-Id: <342d032b652517e2084ba97962ed017a25bf10bd.1392996332.git.agordeev@redhat.com>
In-Reply-To: <cover.1392996332.git.agordeev@redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/ntb/ntb_hw.c |   15 ++++-----------
 drivers/ntb/ntb_hw.h |    2 --
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 487169dd..53468f4 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1085,19 +1085,12 @@ static int ntb_setup_msix(struct ntb_device *ndev)
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
index bbdb7ed..d307107 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -60,8 +60,6 @@
 #define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
 
-#define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
-
 #ifndef readq
 static inline u64 readq(void __iomem *addr)
 {
-- 
1.7.7.6

