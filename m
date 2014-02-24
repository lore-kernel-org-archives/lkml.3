Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBXIAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:00:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBXIAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:00:47 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 02/23] bfa: Do not call pci_enable_msix() after it failed once
Date: Mon, 24 Feb 2014 09:02:02 +0100
Message-Id: <e19ade23db801b0b4310947ad2aeb3350bc1aab5.1393191330.git.agordeev@redhat.com>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_enable_msix() should not be called in case
it threw a negative errno from a previous call.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   48 ++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index cc0fbcd..972ff8d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1235,33 +1235,31 @@ bfad_setup_intr(struct bfad_s *bfad)
 	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
 
 		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
-		if (error) {
-			/* In CT1 & CT2, try to allocate just one vector */
-			if (bfa_asic_id_ctc(pdev->device)) {
-				printk(KERN_WARNING "bfa %s: trying one msix "
-				       "vector failed to allocate %d[%d]\n",
-				       bfad->pci_name, bfad->nvec, error);
-				bfad->nvec = 1;
-				error = pci_enable_msix(bfad->pcidev,
+		/* In CT1 & CT2, try to allocate just one vector */
+		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+			printk(KERN_WARNING "bfa %s: trying one msix "
+			       "vector failed to allocate %d[%d]\n",
+			       bfad->pci_name, bfad->nvec, error);
+			bfad->nvec = 1;
+			error = pci_enable_msix(bfad->pcidev,
 						msix_entries, bfad->nvec);
-			}
+		}
 
-			/*
-			 * Only error number of vector is available.
-			 * We don't have a mechanism to map multiple
-			 * interrupts into one vector, so even if we
-			 * can try to request less vectors, we don't
-			 * know how to associate interrupt events to
-			 *  vectors. Linux doesn't duplicate vectors
-			 * in the MSIX table for this case.
-			 */
-			if (error) {
-				printk(KERN_WARNING "bfad%d: "
-				       "pci_enable_msix failed (%d), "
-				       "use line based.\n",
-					bfad->inst_no, error);
-				goto line_based;
-			}
+		/*
+		 * Only error number of vector is available.
+		 * We don't have a mechanism to map multiple
+		 * interrupts into one vector, so even if we
+		 * can try to request less vectors, we don't
+		 * know how to associate interrupt events to
+		 *  vectors. Linux doesn't duplicate vectors
+		 * in the MSIX table for this case.
+		 */
+		if (error) {
+			printk(KERN_WARNING "bfad%d: "
+			       "pci_enable_msix failed (%d), "
+			       "use line based.\n",
+				bfad->inst_no, error);
+			goto line_based;
 		}
 
 		/* Disable INTX in MSI-X mode */
-- 
1.7.7.6

