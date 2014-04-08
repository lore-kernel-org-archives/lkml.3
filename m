Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaDHA7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:59:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:55509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbaDHA7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="508850913"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 9/9] ntb: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon,  7 Apr 2014 17:52:54 -0700
Message-Id: <1396918374-5196-10-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 22a7eb4..372e08c 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1089,11 +1089,9 @@ static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
 	if (msix_entries < ndev->limits.msix_cnt)
 		return -ENOSPC;
 
-	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+	rc = pci_enable_msix_exact(pdev, ndev->msix_entries, msix_entries);
 	if (rc < 0)
 		return rc;
-	else if (rc > 0)
-		return -ENOSPC;
 
 	for (i = 0; i < msix_entries; i++) {
 		msix = &ndev->msix_entries[i];
@@ -1139,18 +1137,10 @@ static int ntb_setup_bwd_msix(struct ntb_device *ndev, int msix_entries)
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
1.8.3.2

