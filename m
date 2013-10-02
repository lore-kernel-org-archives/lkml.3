Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3JBRM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:12:59 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:25820 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753385Ab3JBRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:12:56 -0400
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
Subject: [PATCH RFC 13/77] bna: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:48:29 +0200
Message-Id: <e138df4579979bc0f60940258525036f5da61424.1380703262.git.agordeev@redhat.com>
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
 drivers/net/ethernet/brocade/bna/bnad.c |   34 ++++++++++++------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index b78e69e..d41257c 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2469,21 +2469,11 @@ bnad_enable_msix(struct bnad *bnad)
 	if (bnad->msix_table)
 		return;
 
-	bnad->msix_table =
-		kcalloc(bnad->msix_num, sizeof(struct msix_entry), GFP_KERNEL);
-
-	if (!bnad->msix_table)
+	ret = pci_msix_table_size(bnad->pcidev);
+	if (ret < 0)
 		goto intx_mode;
 
-	for (i = 0; i < bnad->msix_num; i++)
-		bnad->msix_table[i].entry = i;
-
-	ret = pci_enable_msix(bnad->pcidev, bnad->msix_table, bnad->msix_num);
-	if (ret > 0) {
-		/* Not enough MSI-X vectors. */
-		pr_warn("BNA: %d MSI-X vectors allocated < %d requested\n",
-			ret, bnad->msix_num);
-
+	if (ret < bnad->msix_num) {
 		spin_lock_irqsave(&bnad->bna_lock, flags);
 		/* ret = #of vectors that we got */
 		bnad_q_num_adjust(bnad, (ret - BNAD_MAILBOX_MSIX_VECTORS) / 2,
@@ -2495,15 +2485,19 @@ bnad_enable_msix(struct bnad *bnad)
 
 		if (bnad->msix_num > ret)
 			goto intx_mode;
+	}
 
-		/* Try once more with adjusted numbers */
-		/* If this fails, fall back to INTx */
-		ret = pci_enable_msix(bnad->pcidev, bnad->msix_table,
-				      bnad->msix_num);
-		if (ret)
-			goto intx_mode;
+	bnad->msix_table =
+		kcalloc(bnad->msix_num, sizeof(struct msix_entry), GFP_KERNEL);
+
+	if (!bnad->msix_table)
+		goto intx_mode;
 
-	} else if (ret < 0)
+	for (i = 0; i < bnad->msix_num; i++)
+		bnad->msix_table[i].entry = i;
+
+	ret = pci_enable_msix(bnad->pcidev, bnad->msix_table, bnad->msix_num);
+	if (ret)
 		goto intx_mode;
 
 	pci_intx(bnad->pcidev, 0);
-- 
1.7.7.6

