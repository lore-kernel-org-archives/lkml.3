Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3JBQiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:38:01 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:24683 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753715Ab3JBQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:37:59 -0400
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
Subject: [PATCH RFC 70/77] vmci: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:26 +0200
Message-Id: <654a7884b9ad6fbe777d00bb0a226010e421b3b9.1380703263.git.agordeev@redhat.com>
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
 drivers/misc/vmw_vmci/vmci_guest.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index b3a2b76..af5caf8 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -377,19 +377,27 @@ static int vmci_enable_msix(struct pci_dev *pdev,
 {
 	int i;
 	int result;
+	int nvec;
 
-	for (i = 0; i < VMCI_MAX_INTRS; ++i) {
+	result = pci_msix_table_size(pdev);
+	if (result < 0)
+		return result;
+
+	nvec = min(result, VMCI_MAX_INTRS);
+	if (nvec < VMCI_MAX_INTRS)
+		nvec = 1;
+
+	for (i = 0; i < nvec; ++i) {
 		vmci_dev->msix_entries[i].entry = i;
 		vmci_dev->msix_entries[i].vector = i;
 	}
 
-	result = pci_enable_msix(pdev, vmci_dev->msix_entries, VMCI_MAX_INTRS);
-	if (result == 0)
-		vmci_dev->exclusive_vectors = true;
-	else if (result > 0)
-		result = pci_enable_msix(pdev, vmci_dev->msix_entries, 1);
+	result = pci_enable_msix(pdev, vmci_dev->msix_entries, nvec);
+	if (result)
+		return result;
 
-	return result;
+	vmci_dev->exclusive_vectors = true;
+	return 0;
 }
 
 /*
-- 
1.7.7.6

