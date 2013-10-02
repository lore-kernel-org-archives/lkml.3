Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3JBQuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:50:16 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:24824 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753716Ab3JBQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:50:13 -0400
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
Subject: [PATCH RFC 57/77] pmcraid: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:13 +0200
Message-Id: <70ae1192fb37922e07d9efe1448d902a3223921c.1380703263.git.agordeev@redhat.com>
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
 drivers/scsi/pmcraid.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..5c62d22 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4680,24 +4680,23 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 
 	if ((pmcraid_enable_msix) &&
 		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
-		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
 		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
+		int num_hrrq = ARRAY_SIZE(entries);
 		int i;
-		for (i = 0; i < PMCRAID_NUM_MSIX_VECTORS; i++)
-			entries[i].entry = i;
-
-		rc = pci_enable_msix(pdev, entries, num_hrrq);
-		if (rc < 0)
-			goto pmcraid_isr_legacy;
 
 		/* Check how many MSIX vectors are allocated and register
 		 * msi-x handlers for each of them giving appropriate buffer
 		 */
-		if (rc > 0) {
-			num_hrrq = rc;
-			if (pci_enable_msix(pdev, entries, num_hrrq))
-				goto pmcraid_isr_legacy;
-		}
+		rc = pci_msix_table_size(pdev);
+		if (rc < 0)
+			goto pmcraid_isr_legacy;
+
+		num_hrrq = min(num_hrrq, rc);
+		for (i = 0; i < num_hrrq; i++)
+			entries[i].entry = i;
+
+		if (pci_enable_msix(pdev, entries, num_hrrq))
+			goto pmcraid_isr_legacy;
 
 		for (i = 0; i < num_hrrq; i++) {
 			pinstance->hrrq_vector[i].hrrq_id = i;
-- 
1.7.7.6

