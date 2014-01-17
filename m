Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaAQQB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:01:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaAQQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:01:20 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 6/9] nvme: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Fri, 17 Jan 2014 17:02:20 +0100
Message-Id: <aab7de499d2186f4b9d6adac836ea0554f23ed65.1389904166.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e292450..adf26c2 100644
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
-			if (result > 0) {
-				vecs = result;
-				continue;
-			} else if (result < 0) {
-				vecs = 1;
-			}
-			for (i = 0; i < vecs; i++)
-				dev->entry[i].vector = i + pdev->irq;
-			break;
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

