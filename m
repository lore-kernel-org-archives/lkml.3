Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3JSGxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:53:09 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14257 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751079Ab3JSGxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:53:07 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 20/29] qib: Make use of pcim_enable_msix() and pci_msix_table_size() interfaces
Date: Fri, 18 Oct 2013 19:12:20 +0200
Message-Id: <4d71a3011da810c1a87d587cb5550ccfdc00bf45.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |   48 +++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 3f14009..bad0ca3 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -197,46 +197,46 @@ static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
 			   struct qib_msix_entry *qib_msix_entry)
 {
 	int ret;
-	u32 tabsize = 0;
-	u16 msix_flags;
+	int tabsize = *msixcnt;
 	struct msix_entry *msix_entry;
 	int i;
 
+	ret = pci_msix_table_size(dd->pcidev);
+	if (ret < 0)
+		goto err;
+
+	tabsize = min(tabsize, ret);
+
 	/* We can't pass qib_msix_entry array to qib_msix_setup
 	 * so use a dummy msix_entry array and copy the allocated
 	 * irq back to the qib_msix_entry array. */
-	msix_entry = kmalloc(*msixcnt * sizeof(*msix_entry), GFP_KERNEL);
+	msix_entry = kmalloc(tabsize * sizeof(*msix_entry), GFP_KERNEL);
 	if (!msix_entry) {
 		ret = -ENOMEM;
-		goto do_intx;
+		goto err;
 	}
-	for (i = 0; i < *msixcnt; i++)
+	for (i = 0; i < tabsize; i++)
 		msix_entry[i] = qib_msix_entry[i].msix;
 
-	pci_read_config_word(dd->pcidev, pos + PCI_MSIX_FLAGS, &msix_flags);
-	tabsize = 1 + (msix_flags & PCI_MSIX_FLAGS_QSIZE);
-	if (tabsize > *msixcnt)
-		tabsize = *msixcnt;
-	ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);
-	if (ret > 0) {
+	ret = pcim_enable_msix(dd->pcidev, msix_entry, tabsize);
+	if (ret < 0)
+		goto err;
+	else
 		tabsize = ret;
-		ret = pci_enable_msix(dd->pcidev, msix_entry, tabsize);
-	}
-do_intx:
-	if (ret) {
-		qib_dev_err(dd,
-			"pci_enable_msix %d vectors failed: %d, falling back to INTx\n",
-			tabsize, ret);
-		tabsize = 0;
-	}
+
 	for (i = 0; i < tabsize; i++)
 		qib_msix_entry[i].msix = msix_entry[i];
+
 	kfree(msix_entry);
 	*msixcnt = tabsize;
-
-	if (ret)
-		qib_enable_intx(dd->pcidev);
-
+	return;
+
+err:
+	qib_dev_err(dd,
+		"pci_enable_msix %d vectors failed: %d, falling back to INTx\n",
+		tabsize, ret);
+	*msixcnt = 0;
+	qib_enable_intx(dd->pcidev);
 }
 
 /**
-- 
1.7.7.6

