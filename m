Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaA1J0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:26:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbaA1J0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:26:50 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 08/14] NVMe: nvme_dev_map() is a bad place to set admin queue IRQ number
Date: Tue, 28 Jan 2014 09:38:54 +0100
Message-Id: <89acbd530af682cd02ed5e04e18528cd54943924.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialization of the admin queue interrupt number within
nvme_dev_map() is confusing. Just keep nvme_dev_map() and
nvme_dev_unmap() counterparts simple and let deal function
nvme_configure_admin_queue() with the admin queue in full.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e004c09..98d4b51 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1424,6 +1424,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result)
 		return result;
 
+	dev->entry[0].vector = dev->pci_dev->irq;
 	result = queue_request_irq(nvmeq, "nvme admin");
 	if (result)
 		return result;
@@ -2077,7 +2078,6 @@ static int nvme_dev_map(struct nvme_dev *dev)
 	if (pci_enable_device_mem(pdev))
 		return result;
 
-	dev->entry[0].vector = pdev->irq;
 	pci_set_master(pdev);
 	bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	if (pci_request_selected_regions(pdev, bars, "nvme"))
-- 
1.7.7.6

