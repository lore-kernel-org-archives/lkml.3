Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaHRI46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:56:58 -0400
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380AbaHRIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:28 -0400
X-Greylist: delayed 10355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 04:55:02 EDT
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:51 +0200
Message-Id: <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
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
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5769a9..37f2a20 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8211,9 +8211,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-3 interface specs. The kernel function pci_enable_msix() is
- * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
- * invoked, enables either all or nothing, depending on the current
+ * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
+ * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
+ * once invoked, enables either all or nothing, depending on the current
  * availability of PCI vector resources. The device driver is responsible
  * for calling the individual request_irq() to register each MSI-X vector
  * with a interrupt handler, which is done in this function. Note that
@@ -8237,8 +8237,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 		phba->msix_entries[i].entry = i;
 
 	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
+	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				   LPFC_MSIX_VECTORS);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
@@ -8775,16 +8775,14 @@ out:
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors to device
- * with SLI-4 interface spec. The kernel function pci_enable_msix() is called
- * to enable the MSI-X vectors. Note that pci_enable_msix(), once invoked,
- * enables either all or nothing, depending on the current availability of
- * PCI vector resources. The device driver is responsible for calling the
- * individual request_irq() to register each MSI-X vector with a interrupt
- * handler, which is done in this function. Note that later when device is
- * unloading, the driver should always call free_irq() on all MSI-X vectors
- * it has done request_irq() on before calling pci_disable_msix(). Failure
- * to do so results in a BUG_ON() and a device will be left with MSI-X
- * enabled and leaks its vectors.
+ * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
+ * is called to enable the MSI-X vectors. The device driver is responsible
+ * for calling the individual request_irq() to register each MSI-X vector
+ * with a interrupt handler, which is done in this function. Note that
+ * later when device is unloading, the driver should always call free_irq()
+ * on all MSI-X vectors it has done request_irq() on before calling
+ * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
+ * will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
  * 0 - successful
@@ -8805,17 +8803,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		phba->sli4_hba.msix_entries[index].entry = index;
 		vectors++;
 	}
-enable_msix_vectors:
-	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
-			     vectors);
-	if (rc > 1) {
-		vectors = rc;
-		goto enable_msix_vectors;
-	} else if (rc) {
+	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
+				   2, vectors);
+	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
 		goto vec_fail_out;
 	}
+	vectors = rc;
 
 	/* Log MSI-X vector assignment */
 	for (index = 0; index < vectors; index++)
-- 
1.9.3

