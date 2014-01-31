Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaAaPUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:20:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbaAaPHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Rasesh Mody <rmody@brocade.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 04/34] bna: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:23 +0100
Message-Id: <8d67f1e452834fde10b872e80a2c1a432fddaabd.1391172839.git.agordeev@redhat.com>
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
 drivers/net/ethernet/brocade/bna/bnad.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index cf64f3d..bf436d0 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2666,9 +2666,11 @@ bnad_enable_msix(struct bnad *bnad)
 	for (i = 0; i < bnad->msix_num; i++)
 		bnad->msix_table[i].entry = i;
 
-	ret = pci_enable_msix(bnad->pcidev, bnad->msix_table, bnad->msix_num);
-	if (ret > 0) {
-		/* Not enough MSI-X vectors. */
+	ret = pci_enable_msix_range(bnad->pcidev, bnad->msix_table,
+				    1, bnad->msix_num);
+	if (ret < 0) {
+		goto intx_mode;
+	} else if (ret < bnad->msix_num) {
 		pr_warn("BNA: %d MSI-X vectors allocated < %d requested\n",
 			ret, bnad->msix_num);
 
@@ -2681,18 +2683,11 @@ bnad_enable_msix(struct bnad *bnad)
 		bnad->msix_num = BNAD_NUM_TXQ + BNAD_NUM_RXP +
 			 BNAD_MAILBOX_MSIX_VECTORS;
 
-		if (bnad->msix_num > ret)
-			goto intx_mode;
-
-		/* Try once more with adjusted numbers */
-		/* If this fails, fall back to INTx */
-		ret = pci_enable_msix(bnad->pcidev, bnad->msix_table,
-				      bnad->msix_num);
-		if (ret)
+		if (bnad->msix_num > ret) {
+			pci_disable_msix(bnad->pcidev);
 			goto intx_mode;
-
-	} else if (ret < 0)
-		goto intx_mode;
+		}
+	}
 
 	pci_intx(bnad->pcidev, 0);
 
-- 
1.7.7.6

