Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaBRKKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:10:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaBRKKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:10:11 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 11/35] benet: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:11:40 +0100
Message-Id: <184bdb56228bd3ecd2df5f02cc89c240fa90a5cb.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Sathya Perla <sathya.perla@emulex.com>
Cc: Subbu Seetharaman <subbu.seetharaman@emulex.com>
Cc: Ajit Khaparde <ajit.khaparde@emulex.com>
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Sathya Perla <sathya.perla@emulex.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c |   31 +++++++++++---------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a8cf03e..4f87f5c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2507,7 +2507,7 @@ static void be_msix_disable(struct be_adapter *adapter)
 
 static int be_msix_enable(struct be_adapter *adapter)
 {
-	int i, status, num_vec;
+	int i, num_vec;
 	struct device *dev = &adapter->pdev->dev;
 
 	/* If RoCE is supported, program the max number of NIC vectors that
@@ -2523,24 +2523,11 @@ static int be_msix_enable(struct be_adapter *adapter)
 	for (i = 0; i < num_vec; i++)
 		adapter->msix_entries[i].entry = i;
 
-	status = pci_enable_msix(adapter->pdev, adapter->msix_entries, num_vec);
-	if (status == 0) {
-		goto done;
-	} else if (status >= MIN_MSIX_VECTORS) {
-		num_vec = status;
-		status = pci_enable_msix(adapter->pdev, adapter->msix_entries,
-					 num_vec);
-		if (!status)
-			goto done;
-	}
+	num_vec = pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					MIN_MSIX_VECTORS, num_vec);
+	if (num_vec < 0)
+		goto fail;
 
-	dev_warn(dev, "MSIx enable failed\n");
-
-	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
-	if (!be_physfn(adapter))
-		return status;
-	return 0;
-done:
 	if (be_roce_supported(adapter) && num_vec > MIN_MSIX_VECTORS) {
 		adapter->num_msix_roce_vec = num_vec / 2;
 		dev_info(dev, "enabled %d MSI-x vector(s) for RoCE\n",
@@ -2552,6 +2539,14 @@ done:
 	dev_info(dev, "enabled %d MSI-x vector(s) for NIC\n",
 		 adapter->num_msix_vec);
 	return 0;
+
+fail:
+	dev_warn(dev, "MSIx enable failed\n");
+
+	/* INTx is not supported in VFs, so fail probe if enable_msix fails */
+	if (!be_physfn(adapter))
+		return num_vec;
+	return 0;
 }
 
 static inline int be_msix_vec_get(struct be_adapter *adapter,
-- 
1.7.7.6

