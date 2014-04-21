Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaDUPSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:18:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaDUPSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:18:13 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com, Jens Axboe <axboe@kernel.dk>,
        linux-pci@vger.kernel.org
Subject: [PATCH RESEND 2/2] cciss: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 21 Apr 2014 17:19:32 +0200
Message-Id: <19e90b1e94d7f1a56d103e9d4cb82748fae754cb.1398093399.git.agordeev@redhat.com>
In-Reply-To: <cover.1398093399.git.agordeev@redhat.com>
References: <cover.1398093399.git.agordeev@redhat.com>
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
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/cciss.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 73894ca..4595c22 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4080,7 +4080,7 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 		goto default_int_mode;
 
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
-		err = pci_enable_msix(h->pdev, cciss_msix_entries, 4);
+		err = pci_enable_msix_exact(h->pdev, cciss_msix_entries, 4);
 		if (!err) {
 			h->intr[0] = cciss_msix_entries[0].vector;
 			h->intr[1] = cciss_msix_entries[1].vector;
@@ -4088,10 +4088,6 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 			h->intr[3] = cciss_msix_entries[3].vector;
 			h->msix_vector = 1;
 			return;
-		}
-		if (err > 0) {
-			dev_warn(&h->pdev->dev,
-				"only %d MSI-X vectors available\n", err);
 		} else {
 			dev_warn(&h->pdev->dev,
 				"MSI-X init failed %d\n", err);
-- 
1.7.7.6

