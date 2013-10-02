Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JBQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:44:31 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:24762 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753881Ab3JBQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:44:29 -0400
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
Subject: [PATCH RFC 42/77] lpfc: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:48:58 +0200
Message-Id: <b0f0cdcc95f7899d9340214fdc1db01097bdc25f.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of recent re-design of the MSI/MSI-X interrupts enabling
pattern this driver has to be updated to use the new technique to
obtain a optimal number of MSI/MSI-X interrupts required.

Note, in case just one MSI-X vector was available the
error message "0484 PCI enable MSI-X failed 1" is
preserved to not break tools which might depend on it.

Also, not sure why in case of multiple MSI-Xs mode failed
the driver skips the single MSI-X mode and falls back to
single MSI mode.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0803b84..d83a1a3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8639,13 +8639,17 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 
 	/* Configure MSI-X capability structure */
 	vectors = phba->cfg_fcp_io_channel;
-enable_msix_vectors:
-	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
-			     vectors);
-	if (rc > 1) {
-		vectors = rc;
-		goto enable_msix_vectors;
-	} else if (rc) {
+
+	rc = pci_msix_table_size(phba->pcidev);
+	if (rc < 0)
+		goto msg_fail_out;
+
+	vectors = min(vectors, rc);
+	if (vectors > 1)
+		rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
+				     vectors);
+	if (rc) {
+msg_fail_out:
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
 		goto vec_fail_out;
-- 
1.7.7.6

