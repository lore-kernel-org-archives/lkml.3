Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaAGVku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:40:50 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:50128 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754204AbaAGVjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:39:21 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 16:39:21 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-pci@vger.kernel.org
Subject: [PATCH 7/7] wil6210: Use new interfaces for MSI enablement
Date: Tue,  7 Jan 2014 19:05:42 +0100
Message-Id: <a5774459cb8eebfc95156b8cd3b249d896e04400.1389103215.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++++++------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index eeceab3..022dfe4 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -41,30 +41,32 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	switch (use_msi) {
 	case 3:
 	case 1:
+		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
+		break;
 	case 0:
+		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
 		break;
 	default:
-		wil_err(wil, "Invalid use_msi=%d, default to 1\n",
-			use_msi);
+		wil_err(wil, "Invalid use_msi=%d, default to 1\n", use_msi);
 		use_msi = 1;
 	}
-	wil->n_msi = use_msi;
-	if (wil->n_msi) {
-		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
-		rc = pci_enable_msi_block(pdev, wil->n_msi);
-		if (rc && (wil->n_msi == 3)) {
-			wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
-			wil->n_msi = 1;
-			rc = pci_enable_msi_block(pdev, wil->n_msi);
-		}
-		if (rc) {
-			wil_err(wil, "pci_enable_msi failed, use INTx\n");
-			wil->n_msi = 0;
-		}
-	} else {
-		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
+
+	switch (use_msi) {
+	case 3:
+		if (pci_enable_msi_range(pdev, 3, 3) > 0)
+			break;
+		wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
+		use_msi = 1;
+		/* fallthrough */
+	case 1:
+		if (pci_enable_msi_range(pdev, 1, 1) > 0)
+			break;
+		wil_err(wil, "pci_enable_msi_range failed, use INTx\n");
+		use_msi = 0;
 	}
 
+	wil->n_msi = use_msi;
+
 	rc = wil6210_init_irq(wil, pdev->irq);
 	if (rc)
 		goto stop_master;
-- 
1.7.7.6

