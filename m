Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3JBSHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:07:49 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:27372 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755524Ab3JBSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:07:45 -0400
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
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 44/77] lpfc: Make MSI-X initialization routine more readable
Date: Wed,  2 Oct 2013 12:49:00 +0200
Message-Id: <f3a2e684c57fb47c8f789b0aca078d90c0e52878.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0ec8008..0cfaf20 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8633,10 +8633,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
 
-	/* Set up MSI-X multi-message vectors */
-	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
-		phba->sli4_hba.msix_entries[index].entry = index;
-
 	/* Configure MSI-X capability structure */
 	vectors = phba->cfg_fcp_io_channel;
 
@@ -8650,14 +8646,14 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 		goto msg_fail_out;
 	}
 
+	/* Set up MSI-X multi-message vectors */
+	for (index = 0; index < vectors; index++)
+		phba->sli4_hba.msix_entries[index].entry = index;
+
 	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
 			     vectors);
-	if (rc) {
-msg_fail_out:
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0484 PCI enable MSI-X failed (%d)\n", rc);
-		goto vec_fail_out;
-	}
+	if (rc)
+		goto msg_fail_out;
 
 	/* Log MSI-X vector assignment */
 	for (index = 0; index < vectors; index++)
@@ -8697,7 +8693,7 @@ msg_fail_out:
 	}
 
 	lpfc_sli4_set_affinity(phba, vectors);
-	return rc;
+	return 0;
 
 cfg_fail_out:
 	/* free the irq already requested */
@@ -8710,8 +8706,11 @@ cfg_fail_out:
 
 	/* Unconfigure MSI-X capability structure */
 	pci_disable_msix(phba->pcidev);
+	return rc;
 
-vec_fail_out:
+msg_fail_out:
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0484 PCI enable MSI-X failed (%d)\n", rc);
 	return rc;
 }
 
-- 
1.7.7.6

