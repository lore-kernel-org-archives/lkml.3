Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaAQQVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:21:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbaAQQVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:21:01 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 8/9] ath10k: Use pci_enable_msi_range()
Date: Fri, 17 Jan 2014 17:02:22 +0100
Message-Id: <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

This update also fixes a stylistic (naming and messaging only)
confusion of MSI-X vs multiple MSIs which are not the same.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9e86a81..873f50c 100644
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
@@ -2111,11 +2111,11 @@ static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
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

