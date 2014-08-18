Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaHRIzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:55:38 -0400
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752456AbaHRIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:35 -0400
X-Greylist: delayed 10355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 04:55:02 EDT
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 10/13] csiostor: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:50 +0200
Message-Id: <3ddc5fb60e32d05996a539d7007bfb3a5e5f09b2.1408335523.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
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
Cc: Naresh Kumar Inna <naresh@chelsio.com>
Cc: Arvind Bhushan <arvindb@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/csiostor/csio_hw.h  |  2 +-
 drivers/scsi/csiostor/csio_isr.c | 22 +++++++++-------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 49b1daa..5db2d85 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -94,7 +94,7 @@ enum {
 };
 
 struct csio_msix_entries {
-	unsigned short	vector;		/* Vector assigned by pci_enable_msix */
+	unsigned short	vector;		/* Assigned MSI-X vector */
 	void		*dev_id;	/* Priv object associated w/ this msix*/
 	char		desc[24];	/* Description of this vector */
 };
diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
index 91ba91d..a8c748a 100644
--- a/drivers/scsi/csiostor/csio_isr.c
+++ b/drivers/scsi/csiostor/csio_isr.c
@@ -499,7 +499,7 @@ csio_reduce_sqsets(struct csio_hw *hw, int cnt)
 static int
 csio_enable_msix(struct csio_hw *hw)
 {
-	int rv, i, j, k, n, min, cnt;
+	int i, j, k, n, min, cnt;
 	struct csio_msix_entries *entryp;
 	struct msix_entry *entries;
 	int extra = CSIO_EXTRA_VECS;
@@ -521,19 +521,15 @@ csio_enable_msix(struct csio_hw *hw)
 
 	csio_dbg(hw, "FW supp #niq:%d, trying %d msix's\n", hw->cfg_niq, cnt);
 
-	while ((rv = pci_enable_msix(hw->pdev, entries, cnt)) >= min)
-		cnt = rv;
-	if (!rv) {
-		if (cnt < (hw->num_sqsets + extra)) {
-			csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
-			csio_reduce_sqsets(hw, cnt - extra);
-		}
-	} else {
-		if (rv > 0)
-			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
-
+	cnt = pci_enable_msix_range(hw->pdev, entries, min, cnt);
+	if (cnt < 0) {
 		kfree(entries);
-		return -ENOMEM;
+		return cnt;
+	}
+
+	if (cnt < (hw->num_sqsets + extra)) {
+		csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
+		csio_reduce_sqsets(hw, cnt - extra);
 	}
 
 	/* Save off vectors */
-- 
1.9.3

