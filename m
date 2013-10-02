Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3JBQ7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:59:13 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:25317 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753712Ab3JBQ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:59:10 -0400
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
Subject: [PATCH RFC 40/77] ixgbevf: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:48:56 +0200
Message-Id: <338c9012577acf694eb23622902185584987bd8f.1380703263.git.agordeev@redhat.com>
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
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index fa0537a..d506a01 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1749,8 +1749,7 @@ void ixgbevf_reset(struct ixgbevf_adapter *adapter)
 static int ixgbevf_acquire_msix_vectors(struct ixgbevf_adapter *adapter,
 					int vectors)
 {
-	int err = 0;
-	int vector_threshold;
+	int err, vector_threshold;
 
 	/* We'll want at least 2 (vector_threshold):
 	 * 1) TxQ[0] + RxQ[0] handler
@@ -1763,18 +1762,15 @@ static int ixgbevf_acquire_msix_vectors(struct ixgbevf_adapter *adapter,
 	 * Right now, we simply care about how many we'll get; we'll
 	 * set them up later while requesting irq's.
 	 */
-	while (vectors >= vector_threshold) {
-		err = pci_enable_msix(adapter->pdev, adapter->msix_entries,
-				      vectors);
-		if (!err || err < 0) /* Success or a nasty failure. */
-			break;
-		else /* err == number of vectors we should try again with */
-			vectors = err;
-	}
+	err = pci_msix_table_size(adapter->pdev);
+	if (err < 0)
+		return err;
 
+	vectors = min(vectors, err);
 	if (vectors < vector_threshold)
-		err = -ENOSPC;
+		return -ENOSPC;
 
+	err = pci_enable_msix(adapter->pdev, adapter->msix_entries, vectors);
 	if (err) {
 		dev_err(&adapter->pdev->dev,
 			"Unable to allocate MSI-X interrupts\n");
-- 
1.7.7.6

