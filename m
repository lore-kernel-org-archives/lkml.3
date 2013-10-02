Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JBQek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:34:40 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:24640 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753339Ab3JBQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:34:38 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 12:34:37 EDT
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
Subject: [PATCH RFC 52/77] niu: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:08 +0200
Message-Id: <9808b7b5600043632fab8fa19f5b8e7845637de0.1380703263.git.agordeev@redhat.com>
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
 drivers/net/ethernet/sun/niu.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index f28460c..54c41b9 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9051,26 +9051,28 @@ static void niu_try_msix(struct niu *np, u8 *ldg_num_map)
 		    (np->port == 0 ? 3 : 1));
 	BUG_ON(num_irqs > (NIU_NUM_LDG / parent->num_ports));
 
-retry:
+	err = pci_msix_table_size(pdev);
+	if (err < 0)
+		goto fail;
+
+	num_irqs = min(num_irqs, err);
 	for (i = 0; i < num_irqs; i++) {
 		msi_vec[i].vector = 0;
 		msi_vec[i].entry = i;
 	}
 
 	err = pci_enable_msix(pdev, msi_vec, num_irqs);
-	if (err < 0) {
-		np->flags &= ~NIU_FLAGS_MSIX;
-		return;
-	}
-	if (err > 0) {
-		num_irqs = err;
-		goto retry;
-	}
+	if (err)
+		goto fail;
 
 	np->flags |= NIU_FLAGS_MSIX;
 	for (i = 0; i < num_irqs; i++)
 		np->ldg[i].irq = msi_vec[i].vector;
 	np->num_ldg = num_irqs;
+	return;
+
+fail:
+	np->flags &= ~NIU_FLAGS_MSIX;
 }
 
 static int niu_n2_irq_init(struct niu *np, u8 *ldg_num_map)
-- 
1.7.7.6

