Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3JBRUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:20:06 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:25978 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754404Ab3JBRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:20:02 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 66/77] qlge: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:22 +0200
Message-Id: <5161bfdf162c8edd77d03e96312d48edb54242bc.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of recent re-design of the MSI/MSI-X interrupts enabling
pattern this driver has to be updated to use the new technique to
obtain a optimal number of MSI/MSI-X interrupts required.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c |   39 +++++++++++--------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index ac54cb0..d6fdd93 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -3258,45 +3258,40 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 
 	/* Get the MSIX vectors. */
 	if (qlge_irq_type == MSIX_IRQ) {
+		err = pci_msix_table_size(qdev->pdev);
+		if (err < 0)
+			goto msix_fail;
+
+		qdev->intr_count = min_t(u32, qdev->intr_count, err);
+
 		/* Try to alloc space for the msix struct,
 		 * if it fails then go to MSI/legacy.
 		 */
 		qdev->msi_x_entry = kcalloc(qdev->intr_count,
 					    sizeof(struct msix_entry),
 					    GFP_KERNEL);
-		if (!qdev->msi_x_entry) {
-			qlge_irq_type = MSI_IRQ;
-			goto msi;
-		}
+		if (!qdev->msi_x_entry)
+			goto msix_fail;
 
 		for (i = 0; i < qdev->intr_count; i++)
 			qdev->msi_x_entry[i].entry = i;
 
-		/* Loop to get our vectors.  We start with
-		 * what we want and settle for what we get.
-		 */
-		do {
-			err = pci_enable_msix(qdev->pdev,
-				qdev->msi_x_entry, qdev->intr_count);
-			if (err > 0)
-				qdev->intr_count = err;
-		} while (err > 0);
-
-		if (err < 0) {
-			kfree(qdev->msi_x_entry);
-			qdev->msi_x_entry = NULL;
-			netif_warn(qdev, ifup, qdev->ndev,
-				   "MSI-X Enable failed, trying MSI.\n");
-			qlge_irq_type = MSI_IRQ;
-		} else if (err == 0) {
+		if (!pci_enable_msix(qdev->pdev,
+				     qdev->msi_x_entry, qdev->intr_count)) {
 			set_bit(QL_MSIX_ENABLED, &qdev->flags);
 			netif_info(qdev, ifup, qdev->ndev,
 				   "MSI-X Enabled, got %d vectors.\n",
 				   qdev->intr_count);
 			return;
 		}
+
+		kfree(qdev->msi_x_entry);
+		qdev->msi_x_entry = NULL;
+msix_fail:
+		netif_warn(qdev, ifup, qdev->ndev,
+			   "MSI-X Enable failed, trying MSI.\n");
+		qlge_irq_type = MSI_IRQ;
 	}
-msi:
 	qdev->intr_count = 1;
 	if (qlge_irq_type == MSI_IRQ) {
 		if (!pci_enable_msi(qdev->pdev)) {
-- 
1.7.7.6

