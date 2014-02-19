Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaBSI4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaBSI4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:34 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com, linux-pci@vger.kernel.org
Subject: [PATCH 2/9] cciss: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 09:58:14 +0100
Message-Id: <93bb43ba4d56c17101c7930511851f7e7c3d0c0d.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-pci@vger.kernel.org
---
 drivers/block/cciss.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index fc5b0a4..5463cb5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4080,19 +4080,14 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 		goto default_int_mode;
 
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
-		err = pci_enable_msix(h->pdev, cciss_msix_entries, 4);
-		if (!err) {
+		err = pci_enable_msix_range(h->pdev, cciss_msix_entries, 4, 4);
+		if (err > 0) {
 			h->intr[0] = cciss_msix_entries[0].vector;
 			h->intr[1] = cciss_msix_entries[1].vector;
 			h->intr[2] = cciss_msix_entries[2].vector;
 			h->intr[3] = cciss_msix_entries[3].vector;
 			h->msix_vector = 1;
 			return;
-		}
-		if (err > 0) {
-			dev_warn(&h->pdev->dev,
-				"only %d MSI-X vectors available\n", err);
-			goto single_msi_mode;
 		} else {
 			dev_warn(&h->pdev->dev,
 				"MSI-X init failed %d\n", err);
@@ -4101,7 +4096,7 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 	}
 single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-		if (!pci_enable_msi(h->pdev))
+		if (pci_enable_msi_range(h->pdev, 1, 1) > 0)
 			h->msi_vector = 1;
 		else
 			dev_warn(&h->pdev->dev, "MSI init failed\n");
-- 
1.7.7.6

