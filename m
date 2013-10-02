Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3JBQvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:51:50 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:24846 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754770Ab3JBQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:51:45 -0400
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
Subject: [PATCH RFC 21/77] csiostor: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:48:37 +0200
Message-Id: <a4355b8061609e4a4a28104cc5014178e4720bd0.1380703262.git.agordeev@redhat.com>
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
 drivers/scsi/csiostor/csio_isr.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
index abf20ab..b8a840e 100644
--- a/drivers/scsi/csiostor/csio_isr.c
+++ b/drivers/scsi/csiostor/csio_isr.c
@@ -512,6 +512,16 @@ csio_enable_msix(struct csio_hw *hw)
 	if (hw->flags & CSIO_HWF_USING_SOFT_PARAMS || !csio_is_hw_master(hw))
 		cnt = min_t(uint8_t, hw->cfg_niq, cnt);
 
+	rv = pci_msix_table_size(hw->pdev);
+	if (rv < 0)
+		return rv;
+
+	cnt = min(cnt, rv);
+	if (cnt < min) {
+		csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
+		return -ENOSPC;
+	}
+
 	entries = kzalloc(sizeof(struct msix_entry) * cnt, GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
@@ -521,19 +531,15 @@ csio_enable_msix(struct csio_hw *hw)
 
 	csio_dbg(hw, "FW supp #niq:%d, trying %d msix's\n", hw->cfg_niq, cnt);
 
-	while ((rv = pci_enable_msix(hw->pdev, entries, cnt)) >= min)
-		cnt = rv;
+	rv = pci_enable_msix(hw->pdev, entries, cnt);
 	if (!rv) {
 		if (cnt < (hw->num_sqsets + extra)) {
 			csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
 			csio_reduce_sqsets(hw, cnt - extra);
 		}
 	} else {
-		if (rv > 0)
-			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
-
 		kfree(entries);
-		return -ENOSPC;
+		return rv;
 	}
 
 	/* Save off vectors */
-- 
1.7.7.6

