Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3JBSFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:05:48 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:27352 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754370Ab3JBSFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:05:46 -0400
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
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 74/77] vmxnet3: Limit number of rx queues to 1 if per-queue MSI-Xs failed
Date: Wed,  2 Oct 2013 12:49:30 +0200
Message-Id: <f029865a23808e2f788f90f878355fddf3b04ad2.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3df7f32..00dc0d0 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2814,12 +2814,14 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 
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
@@ -2829,8 +2831,6 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 			}
 			return;
 		}
-		if (!err)
-			return;
 
 		/* If we cannot allocate MSIx vectors use only one rx queue */
 		dev_info(&adapter->pdev->dev,
-- 
1.7.7.6

