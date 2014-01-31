Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaAaPHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbaAaPHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:34 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 16/34] ixgbe: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:35 +0100
Message-Id: <d9020bc4e4e2188cedf32be7b6c609797afa1279.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 32e3eaa..0834e1e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -698,7 +698,7 @@ static void ixgbe_set_num_queues(struct ixgbe_adapter *adapter)
 static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
 				       int vectors)
 {
-	int err, vector_threshold;
+	int vector_threshold;
 
 	/* We'll want at least 2 (vector_threshold):
 	 * 1) TxQ[0] + RxQ[0] handler
@@ -712,18 +712,10 @@ static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
 	 * Right now, we simply care about how many we'll get; we'll
 	 * set them up later while requesting irq's.
 	 */
-	while (vectors >= vector_threshold) {
-		err = pci_enable_msix(adapter->pdev, adapter->msix_entries,
-				      vectors);
-		if (!err) /* Success in acquiring all requested vectors. */
-			break;
-		else if (err < 0)
-			vectors = 0; /* Nasty failure, quit now */
-		else /* err == number of vectors we should try again with */
-			vectors = err;
-	}
+	vectors = pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					vector_threshold, vectors);
 
-	if (vectors < vector_threshold) {
+	if (vectors < 0) {
 		/* Can't allocate enough MSI-X interrupts?  Oh well.
 		 * This just means we'll go with either a single MSI
 		 * vector or fall back to legacy interrupts.
-- 
1.7.7.6

