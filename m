Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3JSGvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:51:23 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14205 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751172Ab3JSGvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:51:21 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 16/29] ixgbevf: Make use of pcim_enable_msix_range() interface
Date: Fri, 18 Oct 2013 19:12:16 +0200
Message-Id: <10ec20c4c1a72169d0ea179a7aa8e0fb1fc7c744.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   33 +++++++-------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 59a62bb..ced3b24 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1749,7 +1749,6 @@ void ixgbevf_reset(struct ixgbevf_adapter *adapter)
 static int ixgbevf_acquire_msix_vectors(struct ixgbevf_adapter *adapter,
 					int vectors)
 {
-	int err = 0;
 	int vector_threshold;
 
 	/* We'll want at least 2 (vector_threshold):
@@ -1763,33 +1762,25 @@ static int ixgbevf_acquire_msix_vectors(struct ixgbevf_adapter *adapter,
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
+	vectors = pcim_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					 vectors, vector_threshold);
 
-	if (vectors < vector_threshold)
-		err = -ENOMEM;
-
-	if (err) {
+	if (vectors < 0) {
 		dev_err(&adapter->pdev->dev,
 			"Unable to allocate MSI-X interrupts\n");
 		kfree(adapter->msix_entries);
 		adapter->msix_entries = NULL;
-	} else {
-		/*
-		 * Adjust for only the vectors we'll use, which is minimum
-		 * of max_msix_q_vectors + NON_Q_VECTORS, or the number of
-		 * vectors we were allocated.
-		 */
-		adapter->num_msix_vectors = vectors;
+		return vectors;
 	}
 
-	return err;
+	/*
+	 * Adjust for only the vectors we'll use, which is minimum
+	 * of max_msix_q_vectors + NON_Q_VECTORS, or the number of
+	 * vectors we were allocated.
+	 */
+	adapter->num_msix_vectors = vectors;
+
+	return 0;
 }
 
 /**
-- 
1.7.7.6

