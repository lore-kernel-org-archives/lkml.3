Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaAGVj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:39:28 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:50128 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754143AbaAGVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:39:17 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 16:39:13 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 4/7] nvme: Use new interfaces for MSI/MSI-X enablement
Date: Tue,  7 Jan 2014 19:05:39 +0100
Message-Id: <1d0440eface1cf3e939758c8c51e987608c046a8.1389103215.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 26d03fa..adf26c2 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1774,32 +1774,15 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	/* Deregister the admin queue's interrupt */
 	free_irq(dev->entry[0].vector, dev->queues[0]);
 
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
-		}
+	vecs = pci_enable_msix_range(pdev, dev->entry, 1, nr_io_queues);
+	if (vecs < 0) {
+		vecs = pci_enable_msi_range(pdev, 1, min(nr_io_queues, 32));
+		if (vecs < 0)
+			vecs = 1;
+		for (i = 0; i < vecs; i++)
+			dev->entry[i].vector = i + pdev->irq;
 	}
 
 	/*
-- 
1.7.7.6

