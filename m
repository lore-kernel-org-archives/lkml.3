Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3JSGmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:42:12 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:12774 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156Ab3JSGmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:42:11 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 15/29] ixgbe: Make use of pcim_enable_msix_range() interface
Date: Fri, 18 Oct 2013 19:12:15 +0200
Message-Id: <1845544d7b17de17198be343bba08dae83fea75e.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 90b4e10..9954b7a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -697,7 +697,7 @@ static void ixgbe_set_num_queues(struct ixgbe_adapter *adapter)
 static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
 				       int vectors)
 {
-	int err, vector_threshold;
+	int vector_threshold;
 
 	/* We'll want at least 2 (vector_threshold):
 	 * 1) TxQ[0] + RxQ[0] handler
@@ -711,18 +711,10 @@ static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
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
+	vectors = pcim_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					 vectors, vector_threshold);
 
-	if (vectors < vector_threshold) {
+	if (vectors < 0) {
 		/* Can't allocate enough MSI-X interrupts?  Oh well.
 		 * This just means we'll go with either a single MSI
 		 * vector or fall back to legacy interrupts.
-- 
1.7.7.6

