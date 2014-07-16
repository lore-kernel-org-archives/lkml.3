Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965789AbaGPSFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965736AbaGPSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:05:14 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X re-initialization failed
Date: Wed, 16 Jul 2014 20:05:17 +0200
Message-Id: <3d2402ebfad625e508bb13257e1560abf92594cd.1405533479.git.agordeev@redhat.com>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver fails to analize MSI-X re-enablement
status on resuming and always assumes the success. This
update checks the MSI-X initialization result and fails
to resume if MSI-Xs re-enablement failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 112799b..ba06102 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5134,9 +5134,10 @@ megasas_resume(struct pci_dev *pdev)
 		goto fail_ready_state;
 
 	/* Now re-enable MSI-X */
-	if (instance->msix_vectors)
-		pci_enable_msix(instance->pdev, instance->msixentry,
-				instance->msix_vectors);
+	if (instance->msix_vectors &&
+	    pci_enable_msix(instance->pdev, instance->msixentry,
+			    instance->msix_vectors))
+		goto fail_reenable_msix;
 
 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
@@ -5245,6 +5246,7 @@ fail_init_mfi:
 
 fail_set_dma_mask:
 fail_ready_state:
+fail_reenable_msix:
 
 	pci_disable_device(pdev);
 
-- 
1.7.7.6

