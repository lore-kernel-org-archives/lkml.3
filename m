Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaBUPrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:47:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaBUPrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:47:42 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jon Mason <jon.mason@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 4/4] ntb: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Fri, 21 Feb 2014 16:49:32 +0100
Message-Id: <0afccb5cf0710f980b47e57c4e9b27eeb3033955.1392996332.git.agordeev@redhat.com>
In-Reply-To: <cover.1392996332.git.agordeev@redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/ntb/ntb_hw.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 0472045..9f2005d 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1088,11 +1088,9 @@ static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
 	if (msix_entries < SNB_MSIX_CNT)
 		return -ENOSPC;
 
-	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+	rc = pci_enable_msix_exact(pdev, ndev->msix_entries, msix_entries);
 	if (rc < 0)
 		return rc;
-	else if (rc > 0)
-		return -ENOSPC;
 
 	for (i = 0; i < msix_entries; i++) {
 		msix = &ndev->msix_entries[i];
@@ -1142,18 +1140,10 @@ static int ntb_setup_bwd_msix(struct ntb_device *ndev, int msix_entries)
 	struct msix_entry *msix;
 	int rc, i;
 
-retry:
-	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
-	if (rc < 0)
-		return rc;
-	else if (rc > 0) {
-		dev_warn(&pdev->dev,
-			 "Only %d MSI-X vectors. "
-			 "Limiting the number of queues to that number.\n",
-			 rc);
-		msix_entries = rc;
-		goto retry;
-	}
+	msix_entries = pci_enable_msix_range(pdev, ndev->msix_entries,
+					     1, msix_entries);
+	if (msix_entries < 0)
+		return msix_entries;
 
 	for (i = 0; i < msix_entries; i++) {
 		msix = &ndev->msix_entries[i];
-- 
1.7.7.6

