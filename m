Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaAQQVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:21:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaAQQU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:20:59 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 5/9] nvme: Fix invalid call to irq_set_affinity_hint()
Date: Fri, 17 Jan 2014 17:02:19 +0100
Message-Id: <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case MSI-X and MSI initialization failed the function
irq_set_affinity_hint() is called with uninitialized value
in dev->entry[0].vector. This update fixes the issue.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 26d03fa..e292450 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1790,15 +1790,15 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 			vecs = 32;
 		for (;;) {
 			result = pci_enable_msi_block(pdev, vecs);
-			if (result == 0) {
-				for (i = 0; i < vecs; i++)
-					dev->entry[i].vector = i + pdev->irq;
-				break;
+			if (result > 0) {
+				vecs = result;
+				continue;
 			} else if (result < 0) {
 				vecs = 1;
-				break;
 			}
-			vecs = result;
+			for (i = 0; i < vecs; i++)
+				dev->entry[i].vector = i + pdev->irq;
+			break;
 		}
 	}
 
-- 
1.7.7.6

