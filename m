Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3JSGkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:40:14 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:12571 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab3JSGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:40:12 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 28/29] vmxnet3: Limit number of rx queues to 1 if per-queue MSI-Xs failed
Date: Fri, 18 Oct 2013 19:12:28 +0200
Message-Id: <48b60dd6eda8df93f1eb8e8356e3c80c673550e3.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3df7f32..d33802c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2814,23 +2814,21 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 
 		err = vmxnet3_acquire_msix_vectors(adapter,
 						   adapter->intr.num_intrs);
-		/* If we cannot allocate one MSIx vector per queue
-		 * then limit the number of rx queues to 1
-		 */
-		if (err == VMXNET3_LINUX_MIN_MSIX_VECT) {
-			if (adapter->share_intr != VMXNET3_INTR_BUDDYSHARE
-			    || adapter->num_rx_queues != 1) {
+		if (!err) {
+			/* If we cannot allocate one MSIx vector per queue
+			 * then limit the number of rx queues to 1
+			 */
+			if ((adapter->intr.num_intrs ==
+			     VMXNET3_LINUX_MIN_MSIX_VECT) &&
+			    ((adapter->share_intr != VMXNET3_INTR_BUDDYSHARE) ||
+			     (adapter->num_rx_queues != 1))) {
 				adapter->share_intr = VMXNET3_INTR_TXSHARE;
 				netdev_err(adapter->netdev,
 					   "Number of rx queues : 1\n");
 				adapter->num_rx_queues = 1;
-				adapter->intr.num_intrs =
-						VMXNET3_LINUX_MIN_MSIX_VECT;
 			}
 			return;
 		}
-		if (!err)
-			return;
 
 		/* If we cannot allocate MSIx vectors use only one rx queue */
 		dev_info(&adapter->pdev->dev,
-- 
1.7.7.6

