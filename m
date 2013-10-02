Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JBRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:15:19 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:25875 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754644Ab3JBRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:15:15 -0400
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
Subject: [PATCH RFC 12/77] benet: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:48:28 +0200
Message-Id: <4a8384c64f822aaed962169532bde927ac382ca0.1380703262.git.agordeev@redhat.com>
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
 drivers/net/ethernet/emulex/benet/be_main.c |   38 ++++++++++++++------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 3e2c834..84d560d 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2366,29 +2366,23 @@ static int be_msix_enable(struct be_adapter *adapter)
 	else
 		num_vec = adapter->cfg_num_qs;
 
-	for (i = 0; i < num_vec; i++)
-		adapter->msix_entries[i].entry = i;
+	status = pci_msix_table_size(adapter->pdev);
+	if (status < 0)
+		goto fail;
 
-	status = pci_enable_msix(adapter->pdev, adapter->msix_entries, num_vec);
-	if (status == 0) {
-		goto done;
-	} else if (status >= MIN_MSIX_VECTORS) {
-		num_vec = status;
-		status = pci_enable_msix(adapter->pdev, adapter->msix_entries,
-					 num_vec);
-		if (!status)
-			goto done;
-	} else (status > 0) {
+	num_vec = min(num_vec, status);
+	if (num_vec < MIN_MSIX_VECTORS) {
 		status = -ENOSPC;
+		goto fail;
 	}
 
-	dev_warn(dev, "MSIx enable failed\n");
+	for (i = 0; i < num_vec; i++)
+		adapter->msix_entries[i].entry = i;
+
+	status = pci_enable_msix(adapter->pdev, adapter->msix_entries, num_vec);
+	if (status)
+		goto fail;
 
-	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
-	if (!be_physfn(adapter))
-		return status;
-	return 0;
-done:
 	if (be_roce_supported(adapter) && num_vec > MIN_MSIX_VECTORS) {
 		adapter->num_msix_roce_vec = num_vec / 2;
 		dev_info(dev, "enabled %d MSI-x vector(s) for RoCE\n",
@@ -2400,6 +2394,14 @@ done:
 	dev_info(dev, "enabled %d MSI-x vector(s) for NIC\n",
 		 adapter->num_msix_vec);
 	return 0;
+
+fail:
+	dev_warn(dev, "MSIx enable failed\n");
+
+	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
+	if (!be_physfn(adapter))
+		return status;
+	return 0;
 }
 
 static inline int be_msix_vec_get(struct be_adapter *adapter,
-- 
1.7.7.6

