Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaAaPIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaAaPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:56 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 30/34] qlge: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:49 +0100
Message-Id: <c9d24ca514bde3e4caed3047dacbe64109d466bc.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 82bace5..adf87d2 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -3331,23 +3331,16 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 		for (i = 0; i < qdev->intr_count; i++)
 			qdev->msi_x_entry[i].entry = i;
 
-		/* Loop to get our vectors.  We start with
-		 * what we want and settle for what we get.
-		 */
-		do {
-			err = pci_enable_msix(qdev->pdev,
-				qdev->msi_x_entry, qdev->intr_count);
-			if (err > 0)
-				qdev->intr_count = err;
-		} while (err > 0);
-
+		err = pci_enable_msix_range(qdev->pdev, qdev->msi_x_entry,
+					    1, qdev->intr_count);
 		if (err < 0) {
 			kfree(qdev->msi_x_entry);
 			qdev->msi_x_entry = NULL;
 			netif_warn(qdev, ifup, qdev->ndev,
 				   "MSI-X Enable failed, trying MSI.\n");
 			qlge_irq_type = MSI_IRQ;
-		} else if (err == 0) {
+		} else {
+			qdev->intr_count = err;
 			set_bit(QL_MSIX_ENABLED, &qdev->flags);
 			netif_info(qdev, ifup, qdev->ndev,
 				   "MSI-X Enabled, got %d vectors.\n",
-- 
1.7.7.6

