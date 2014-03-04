Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaCDPUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbaCDPUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:20:43 -0500
Date: Tue, 4 Mar 2014 16:22:00 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 3/2] nvme: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Message-ID: <20140304152200.GA18364@dhcp-26-207.brq.redhat.com>
References: <cover.1393404496.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1393404496.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org
Reviewed-by: Keith Busch <keith.busch@intel.com>
---
 drivers/block/nvme-core.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 51824d1..eca2b3e 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1837,31 +1837,16 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	/* Deregister the admin queue's interrupt */
 	free_irq(dev->entry[0].vector, adminq);
 
-	vecs = nr_io_queues;
-	for (i = 0; i < vecs; i++)
+	for (i = 0; i < nr_io_queues; i++)
 		dev->entry[i].entry = i;
-	for (;;) {
-		result = pci_enable_msix(pdev, dev->entry, vecs);
-		if (result <= 0)
-			break;
-		vecs = result;
-	}
-
-	if (result < 0) {
-		vecs = nr_io_queues;
-		if (vecs > 32)
-			vecs = 32;
-		for (;;) {
-			result = pci_enable_msi_block(pdev, vecs);
-			if (result == 0) {
-				for (i = 0; i < vecs; i++)
-					dev->entry[i].vector = i + pdev->irq;
-				break;
-			} else if (result < 0) {
-				vecs = 1;
-				break;
-			}
-			vecs = result;
+	vecs = pci_enable_msix_range(pdev, dev->entry, 1, nr_io_queues);
+	if (vecs < 0) {
+		vecs = pci_enable_msi_range(pdev, 1, min(nr_io_queues, 32));
+		if (vecs < 0) {
+			vecs = 1;
+		} else {
+			for (i = 0; i < vecs; i++)
+				dev->entry[i].vector = i + pdev->irq;
 		}
 	}
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
