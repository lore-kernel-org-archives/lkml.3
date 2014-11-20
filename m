Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaKTHNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:13:49 -0500
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:47552 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbaKTHNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:13:45 -0500
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
X-Google-Original-From: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH 14/22] [SCSI] mpt2sas, mpt3sas: Remove redundancy code while freeing the controller resources.
Date: Thu, 20 Nov 2014 12:35:47 +0530
Message-Id: <1416467155-16869-15-git-send-email-Sreekanth.Reddy@avagotech.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the redundancy code while freeing the controller resources.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 49 ++++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 7286cd2..79626d9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1501,6 +1501,33 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * mpt2sas_base_unmap_resources - free controller resources
+ * @ioc: per adapter object
+ */
+void
+mpt2sas_base_unmap_resources(struct MPT2SAS_ADAPTER *ioc)
+{
+	struct pci_dev *pdev = ioc->pdev;
+
+	dexitprintk(ioc, printk(MPT2SAS_FMT "%s\n",
+		ioc->name, __func__));
+
+	_base_free_irq(ioc);
+	_base_disable_msix(ioc);
+
+	if (ioc->chip_phys) {
+		iounmap(ioc->chip);
+		ioc->chip_phys = 0;
+	}
+
+	if (pci_is_enabled(pdev)) {
+		pci_release_selected_regions(ioc->pdev, ioc->bars);
+		pci_disable_pcie_error_reporting(pdev);
+		pci_disable_device(pdev);
+	}
+}
+
+/**
  * mpt2sas_base_map_resources - map in controller resources (io/irq/memap)
  * @ioc: per adapter object
  *
@@ -1606,12 +1633,7 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	return 0;
 
  out_fail:
-	if (ioc->chip_phys)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-	pci_release_selected_regions(ioc->pdev, ioc->bars);
-	pci_disable_pcie_error_reporting(pdev);
-	pci_disable_device(pdev);
+	mpt2sas_base_unmap_resources(ioc);
 	return r;
 }
 
@@ -4422,8 +4444,6 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 void
 mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 {
-	struct pci_dev *pdev = ioc->pdev;
-
 	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
@@ -4434,18 +4454,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 		ioc->shost_recovery = 0;
 	}
 
-	_base_free_irq(ioc);
-	_base_disable_msix(ioc);
-
-	if (ioc->chip_phys && ioc->chip)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-
-	if (pci_is_enabled(pdev)) {
-		pci_release_selected_regions(ioc->pdev, ioc->bars);
-		pci_disable_pcie_error_reporting(pdev);
-		pci_disable_device(pdev);
-	}
+	mpt2sas_base_unmap_resources(ioc);
 	return;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 527f91b..4322d7c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1791,6 +1791,36 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * mpt3sas_base_unmap_resources - free controller resources
+ * @ioc: per adapter object
+ */
+void
+mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct pci_dev *pdev = ioc->pdev;
+
+	dexitprintk(ioc, printk(MPT3SAS_FMT "%s\n",
+		ioc->name, __func__));
+
+	_base_free_irq(ioc);
+	_base_disable_msix(ioc);
+
+	if (ioc->msix96_vector)
+		kfree(ioc->replyPostRegisterIndex);
+
+	if (ioc->chip_phys) {
+		iounmap(ioc->chip);
+		ioc->chip_phys = 0;
+	}
+
+	if (pci_is_enabled(pdev)) {
+		pci_release_selected_regions(ioc->pdev, ioc->bars);
+		pci_disable_pcie_error_reporting(pdev);
+		pci_disable_device(pdev);
+	}
+}
+
+/**
  * mpt3sas_base_map_resources - map in controller resources (io/irq/memap)
  * @ioc: per adapter object
  *
@@ -1918,14 +1948,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	return 0;
 
  out_fail:
-	if (ioc->chip_phys)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-	pci_release_selected_regions(ioc->pdev, ioc->bars);
-	pci_disable_pcie_error_reporting(pdev);
-	pci_disable_device(pdev);
-	if (ioc->msix96_vector)
-		kfree(ioc->replyPostRegisterIndex);
+	mpt3sas_base_unmap_resources(ioc);
 	return r;
 }
 
@@ -4657,8 +4680,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 void
 mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct pci_dev *pdev = ioc->pdev;
-
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
@@ -4669,21 +4690,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 		ioc->shost_recovery = 0;
 	}
 
-	_base_free_irq(ioc);
-	_base_disable_msix(ioc);
-
-	if (ioc->msix96_vector)
-		kfree(ioc->replyPostRegisterIndex);
-
-	if (ioc->chip_phys && ioc->chip)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-
-	if (pci_is_enabled(pdev)) {
-		pci_release_selected_regions(ioc->pdev, ioc->bars);
-		pci_disable_pcie_error_reporting(pdev);
-		pci_disable_device(pdev);
-	}
+	mpt3sas_base_unmap_resources(ioc);
 	return;
 }
 
-- 
2.0.2

