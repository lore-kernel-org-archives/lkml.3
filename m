Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDNIEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:04:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbaDNIEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:04:43 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, xjtuwjp@gmail.com,
        lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 18/23] pm8001: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 14 Apr 2014 10:05:42 +0200
Message-Id: <47cb5bf9c2ff7628a96122d6c7263c12fa6dd455.1397461652.git.agordeev@redhat.com>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
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
Cc: xjtuwjp@gmail.com
Cc: lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pm8001/pm8001_init.c |   39 +++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index df421f5..1d3c02d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -725,34 +725,35 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		sizeof(pm8001_ha->msix_entries[0]);
 	for (i = 0; i < max_entry ; i++)
 		pm8001_ha->msix_entries[i].entry = i;
-	rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
+	rc = pci_enable_msix_exact(pm8001_ha->pdev, pm8001_ha->msix_entries,
 		number_of_intr);
 	pm8001_ha->number_of_intr = number_of_intr;
-	if (!rc) {
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"pci_enable_msix request ret:%d no of intr %d\n",
-					rc, pm8001_ha->number_of_intr));
+	if (rc)
+		return rc;
 
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
+		"pci_enable_msix_exact request ret:%d no of intr %d\n",
+				rc, pm8001_ha->number_of_intr));
 
-		for (i = 0; i < number_of_intr; i++) {
-			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
-					DRV_NAME"%d", i);
-			pm8001_ha->irq_vector[i].irq_id = i;
-			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
+	for (i = 0; i < number_of_intr; i++) {
+		snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+				DRV_NAME"%d", i);
+		pm8001_ha->irq_vector[i].irq_id = i;
+		pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
 
-			rc = request_irq(pm8001_ha->msix_entries[i].vector,
-				pm8001_interrupt_handler_msix, flag,
-				intr_drvname[i], &(pm8001_ha->irq_vector[i]));
-			if (rc) {
-				for (j = 0; j < i; j++)
-					free_irq(
-					pm8001_ha->msix_entries[j].vector,
+		rc = request_irq(pm8001_ha->msix_entries[i].vector,
+			pm8001_interrupt_handler_msix, flag,
+			intr_drvname[i], &(pm8001_ha->irq_vector[i]));
+		if (rc) {
+			for (j = 0; j < i; j++) {
+				free_irq(pm8001_ha->msix_entries[j].vector,
 					&(pm8001_ha->irq_vector[i]));
-				pci_disable_msix(pm8001_ha->pdev);
-				break;
 			}
+			pci_disable_msix(pm8001_ha->pdev);
+			break;
 		}
 	}
+
 	return rc;
 }
 #endif
-- 
1.7.7.6

