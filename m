Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaAGVkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:40:05 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:50128 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754235AbaAGVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:39:26 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 16:39:21 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 6/7] ath10k: Use new interfaces for MSI enablement
Date: Tue,  7 Jan 2014 19:05:41 +0100
Message-Id: <dc640013c28e6e24b4f7293a8adbd2b60a8f48c4.1389103215.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update also fixes a stylistic (naming and messaging only)
confusion of MSI-X vs multiple MSIs which are not the same.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9e86a81..08807fe 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2073,14 +2073,14 @@ static void ath10k_pci_tasklet(unsigned long data)
 	}
 }
 
-static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
+static int ath10k_pci_start_intr_multi_msi(struct ath10k *ar, int num)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 	int i;
 
-	ret = pci_enable_msi_block(ar_pci->pdev, num);
-	if (ret)
+	ret = pci_enable_msi_range(ar_pci->pdev, num, num);
+	if (ret < 0)
 		return ret;
 
 	ret = request_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW,
@@ -2111,16 +2111,16 @@ static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
 		}
 	}
 
-	ath10k_info("MSI-X interrupt handling (%d intrs)\n", num);
+	ath10k_info("Multi MSI interrupt handling (%d intrs)\n", num);
 	return 0;
 }
 
-static int ath10k_pci_start_intr_msi(struct ath10k *ar)
+static int ath10k_pci_start_intr_single_msi(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ret = pci_enable_msi(ar_pci->pdev);
+	ret = pci_enable_msi_range(ar_pci->pdev, 1, 1);
 	if (ret < 0)
 		return ret;
 
@@ -2132,7 +2132,7 @@ static int ath10k_pci_start_intr_msi(struct ath10k *ar)
 		return ret;
 	}
 
-	ath10k_info("MSI interrupt handling\n");
+	ath10k_info("Single MSI interrupt handling\n");
 	return 0;
 }
 
@@ -2199,20 +2199,20 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 		num = 1;
 
 	if (num > 1) {
-		ret = ath10k_pci_start_intr_msix(ar, num);
+		ret = ath10k_pci_start_intr_multi_msi(ar, num);
 		if (ret == 0)
 			goto exit;
 
-		ath10k_warn("MSI-X didn't succeed (%d), trying MSI\n", ret);
+		ath10k_warn("Multi MSI failed (%d), trying single MSI\n", ret);
 		num = 1;
 	}
 
 	if (num == 1) {
-		ret = ath10k_pci_start_intr_msi(ar);
+		ret = ath10k_pci_start_intr_single_msi(ar);
 		if (ret == 0)
 			goto exit;
 
-		ath10k_warn("MSI didn't succeed (%d), trying legacy INTR\n",
+		ath10k_warn("Single MSI failed (%d), trying legacy INTR\n",
 			    ret);
 		num = 0;
 	}
-- 
1.7.7.6

