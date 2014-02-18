Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaBRPIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbaBRPHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:07:20 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 16:09:02 +0100
Message-Id: <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
In-Reply-To: <cover.1392733151.git.agordeev@redhat.com>
References: <cover.1392733151.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/infiniband/hw/qib/qib_pcie.c |   55 +++++++++++++++++----------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c8d9c4a..61a0046 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -197,46 +197,47 @@ static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
 			   struct qib_msix_entry *qib_msix_entry)
 {
 	int ret;
-	u32 tabsize = 0;
-	u16 msix_flags;
+	int nvec = *msixcnt;
 	struct msix_entry *msix_entry;
 	int i;
 
+	ret = pci_msix_vec_count(dd->pcidev);
+	if (ret < 0)
+		goto do_intx;
+
+	nvec = min(nvec, ret);
+
 	/* We can't pass qib_msix_entry array to qib_msix_setup
 	 * so use a dummy msix_entry array and copy the allocated
 	 * irq back to the qib_msix_entry array. */
-	msix_entry = kmalloc(*msixcnt * sizeof(*msix_entry), GFP_KERNEL);
-	if (!msix_entry) {
-		ret = -ENOMEM;
+	msix_entry = kmalloc(nvec * sizeof(*msix_entry), GFP_KERNEL);
+	if (!msix_entry)
 		goto do_intx;
-	}
-	for (i = 0; i < *msixcnt; i++)
+
+	for (i = 0; i < nvec; i++)
 		msix_entry[i] = qib_msix_entry[i].msix;
 
-	pci_read_config_word(dd->pcidev, pos + PCI_MSIX_FLAGS, &msix_flags);
-	tabsize = 1 + (msix_flags & PCI_MSIX_FLAGS_QSIZE);
-	if (tabsize > *msixcnt)
-		tabsize = *msixcnt;
-	ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);
-	if (ret > 0) {
-		tabsize = ret;
-		ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);
-	}
-do_intx:
-	if (ret) {
-		qib_dev_err(dd,
-			"pci_enable_msix %d vectors failed: %d, falling back to INTx\n",
-			tabsize, ret);
-		tabsize = 0;
-	}
-	for (i = 0; i < tabsize; i++)
+	ret = pci_enable_msix_range(dd->pcidev, msix_entry, 1, nvec);
+	if (ret < 0)
+		goto free_msix_entry;
+	else
+		nvec = ret;
+
+	for (i = 0; i < nvec; i++)
 		qib_msix_entry[i].msix = msix_entry[i];
+
 	kfree(msix_entry);
-	*msixcnt = tabsize;
+	*msixcnt = nvec;
+	return;
 
-	if (ret)
-		qib_enable_intx(dd->pcidev);
+free_msix_entry:
+	kfree(msix_entry);
 
+do_intx:
+	qib_dev_err(dd, "pci_enable_msix_range %d vectors failed: %d, "
+			"falling back to INTx\n", nvec, ret);
+	*msixcnt = 0;
+	qib_enable_intx(dd->pcidev);
 }
 
 /**
-- 
1.7.7.6

