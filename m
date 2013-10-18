Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3JSGpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:45:51 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:13398 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960Ab3JSGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:45:49 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 29/29] vmxnet3: Make use of pcim_enable_msix_range() interface
Date: Fri, 18 Oct 2013 19:12:29 +0200
Message-Id: <75788c5da384b16633fdab43d37a277aa92f38fd.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   40 +++++++++---------------------------
 1 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d33802c..e552d2b 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2735,39 +2735,19 @@ vmxnet3_read_mac_addr(struct vmxnet3_adapter *adapter, u8 *mac)
  */
 
 static int
-vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
-			     int vectors)
+vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter, int vectors)
 {
-	int err = -EINVAL, vector_threshold;
-	vector_threshold = VMXNET3_LINUX_MIN_MSIX_VECT;
-
-	while (vectors >= vector_threshold) {
-		err = pci_enable_msix(adapter->pdev, adapter->intr.msix_entries,
-				      vectors);
-		if (!err) {
-			adapter->intr.num_intrs = vectors;
-			return 0;
-		} else if (err < 0) {
-			dev_err(&adapter->netdev->dev,
-				   "Failed to enable MSI-X, error: %d\n", err);
-			return err;
-		} else if (err < vector_threshold) {
-			dev_info(&adapter->pdev->dev,
-				 "Number of MSI-Xs which can be allocated "
-				 "is lower than min threshold required.\n");
-			return -ENOSPC;
-		} else {
-			/* If fails to enable required number of MSI-x vectors
-			 * try enabling minimum number of vectors required.
-			 */
-			dev_err(&adapter->netdev->dev,
-				"Failed to enable %d MSI-X, trying %d instead\n",
-				    vectors, vector_threshold);
-			vectors = vector_threshold;
-		}
+	vectors = pcim_enable_msix_range(adapter->pdev,
+					 adapter->intr.msix_entries, vectors,
+					 VMXNET3_LINUX_MIN_MSIX_VECT);
+	if (vectors < 0) {
+		dev_err(&adapter->netdev->dev,
+			"Failed to enable MSI-X, error: %d\n", vectors);
+		return vectors;
 	}
 
-	return err;
+	adapter->intr.num_intrs = vectors;
+	return 0;
 }
 
 
-- 
1.7.7.6

