Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3JBRZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:25:25 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26071 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754182Ab3JBRZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:25:21 -0400
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
Subject: [PATCH RFC 63/77] qlcnic: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:19 +0200
Message-Id: <c92efbde96541d08f37510422c096d543bb01279.1380703263.git.agordeev@redhat.com>
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
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   56 ++++++++++++---------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index b94e679..a137c14 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -590,7 +590,37 @@ int qlcnic_enable_msix(struct qlcnic_adapter *adapter, u32 num_msix)
 	adapter->flags &= ~(QLCNIC_MSI_ENABLED | QLCNIC_MSIX_ENABLED);
 
 	if (adapter->ahw->msix_supported) {
- enable_msix:
+		err = pci_msix_table_size(pdev);
+		if (err < 0)
+			goto fail;
+
+		if (err < num_msix) {
+			dev_info(&pdev->dev,
+				 "Unable to allocate %d MSI-X interrupt vectors\n",
+				 num_msix);
+			if (qlcnic_83xx_check(adapter)) {
+				if (err < (QLC_83XX_MINIMUM_VECTOR - tx_vector))
+					return -ENOSPC;
+				err -= (max_tx_rings + 1);
+				num_msix = rounddown_pow_of_two(err);
+				num_msix += (max_tx_rings + 1);
+			} else {
+				num_msix = rounddown_pow_of_two(err);
+				if (qlcnic_check_multi_tx(adapter))
+					num_msix += max_tx_rings;
+			}
+
+			if (!num_msix) {
+				err = -ENOSPC;
+				goto fail;
+			}
+
+			dev_info(&pdev->dev,
+				 "Trying to allocate %d MSI-X interrupt vectors\n",
+				 num_msix);
+			}
+		}
+
 		for (i = 0; i < num_msix; i++)
 			adapter->msix_entries[i].entry = i;
 		err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
@@ -613,30 +643,8 @@ int qlcnic_enable_msix(struct qlcnic_adapter *adapter, u32 num_msix)
 				adapter->max_sds_rings = max_sds_rings;
 			}
 			dev_info(&pdev->dev, "using msi-x interrupts\n");
-		} else if (err > 0) {
-			dev_info(&pdev->dev,
-				 "Unable to allocate %d MSI-X interrupt vectors\n",
-				 num_msix);
-			if (qlcnic_83xx_check(adapter)) {
-				if (err < (QLC_83XX_MINIMUM_VECTOR - tx_vector))
-					return -ENOSPC;
-				err -= (max_tx_rings + 1);
-				num_msix = rounddown_pow_of_two(err);
-				num_msix += (max_tx_rings + 1);
-			} else {
-				num_msix = rounddown_pow_of_two(err);
-				if (qlcnic_check_multi_tx(adapter))
-					num_msix += max_tx_rings;
-			}
-
-			if (num_msix) {
-				dev_info(&pdev->dev,
-					 "Trying to allocate %d MSI-X interrupt vectors\n",
-					 num_msix);
-				goto enable_msix;
-			}
-			err = -ENOSPC;
 		} else {
+fail:
 			dev_info(&pdev->dev,
 				 "Unable to allocate %d MSI-X interrupt vectors\n",
 				 num_msix);
-- 
1.7.7.6

