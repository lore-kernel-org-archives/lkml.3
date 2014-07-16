Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbaGPStq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:49:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965724AbaGPStm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:49:42 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        iss_storagedev@hp.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 09/23] hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 20:05:13 +0200
Message-Id: <fa8dc16252a7afa6186b78af4b90590755f45507.1405533479.git.agordeev@redhat.com>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/hpsa.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 648dec2..5c4ab6e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6160,25 +6160,22 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		h->msix_vector = MAX_REPLY_QUEUES;
 		if (h->msix_vector > num_online_cpus())
 			h->msix_vector = num_online_cpus();
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-				      h->msix_vector);
-		if (err > 0) {
+		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
+					    1, h->msix_vector);
+		if (err < 0) {
+			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
+			h->msix_vector = 0;
+			goto single_msi_mode;
+		} else if (err < h->msix_vector) {
 			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
-			h->msix_vector = err;
-			err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-					      h->msix_vector);
-		}
-		if (!err) {
-			for (i = 0; i < h->msix_vector; i++)
-				h->intr[i] = hpsa_msix_entries[i].vector;
-			return;
-		} else {
-			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
-			       err);
-			h->msix_vector = 0;
 		}
+		h->msix_vector = err;
+		for (i = 0; i < h->msix_vector; i++)
+			h->intr[i] = hpsa_msix_entries[i].vector;
+		return;
 	}
+single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI\n");
 		if (!pci_enable_msi(h->pdev))
-- 
1.7.7.6

