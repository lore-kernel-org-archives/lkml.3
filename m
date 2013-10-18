Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3JSGrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:47:39 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:13845 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960Ab3JSGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:47:37 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 19/29] ntb: Make use of pcim_enable_msix/msix_exact() interfaces
Date: Fri, 18 Oct 2013 19:12:19 +0200
Message-Id: <99464bf7495829672d97faa9beac3d456877b7b4.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ntb/ntb_hw.c |   38 +++++++++++++-------------------------
 1 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index de2062c..b7d6eed 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1032,22 +1032,15 @@ static int ntb_setup_msix(struct ntb_device *ndev)
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
+	rc = pci_msix_table_size(pdev);
+	if (rc < 0)
 		goto err;
-
-	msix_entries = msix_table_size(val);
-	if (msix_entries > ndev->limits.msix_cnt) {
+	else if (rc > ndev->limits.msix_cnt) {
 		rc = -EINVAL;
 		goto err;
-	}
+	} else
+		msix_entries = rc;
 
 	ndev->msix_entries = kmalloc(sizeof(struct msix_entry) * msix_entries,
 				     GFP_KERNEL);
@@ -1059,26 +1052,21 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 	for (i = 0; i < msix_entries; i++)
 		ndev->msix_entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
-	if (rc < 0)
-		goto err1;
-	if (rc > 0) {
+	if (ndev->hw_type != BWD_HW)
 		/* On SNB, the link interrupt is always tied to 4th vector.  If
 		 * we can't get all 4, then we can't use MSI-X.
 		 */
-		if (ndev->hw_type != BWD_HW) {
-			rc = -EIO;
-			goto err1;
-		}
-
+		rc = pcim_enable_msix_exact(pdev,
+					    ndev->msix_entries, msix_entries);
+	else
+		rc = pcim_enable_msix(pdev, ndev->msix_entries, msix_entries);
+	if (rc < 0)
+		goto err1;
+	else if (rc < msix_entries) {
 		dev_warn(&pdev->dev,
 			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
 			 rc);
 		msix_entries = rc;
-
-		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
-		if (rc)
-			goto err1;
 	}
 
 	for (i = 0; i < msix_entries; i++) {
-- 
1.7.7.6

