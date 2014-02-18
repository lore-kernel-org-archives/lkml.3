Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaBRKGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaBRKGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:06:38 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH net-next 01/35] bnx2: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:07:53 +0100
Message-Id: <c8d230441b63d4c30818a55b0e6ca0f376572b87.1392717502.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/broadcom/bnx2.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index cda25ac..ca6b362 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -6206,7 +6206,7 @@ bnx2_free_irq(struct bnx2 *bp)
 static void
 bnx2_enable_msix(struct bnx2 *bp, int msix_vecs)
 {
-	int i, total_vecs, rc;
+	int i, total_vecs;
 	struct msix_entry msix_ent[BNX2_MAX_MSIX_VEC];
 	struct net_device *dev = bp->dev;
 	const int len = sizeof(bp->irq_tbl[0].name);
@@ -6229,16 +6229,9 @@ bnx2_enable_msix(struct bnx2 *bp, int msix_vecs)
 #ifdef BCM_CNIC
 	total_vecs++;
 #endif
-	rc = -ENOSPC;
-	while (total_vecs >= BNX2_MIN_MSIX_VEC) {
-		rc = pci_enable_msix(bp->pdev, msix_ent, total_vecs);
-		if (rc <= 0)
-			break;
-		if (rc > 0)
-			total_vecs = rc;
-	}
-
-	if (rc != 0)
+	total_vecs = pci_enable_msix_range(bp->pdev, msix_ent,
+					   BNX2_MIN_MSIX_VEC, total_vecs);
+	if (total_vecs < 0)
 		return;
 
 	msix_vecs = total_vecs;
-- 
1.7.7.6

