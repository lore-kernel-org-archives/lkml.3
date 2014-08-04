Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaHDLXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:23:11 -0400
Received: from 8bytes.org ([81.169.241.247]:58966 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaHDLXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:23:10 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joro@8bytes.org,
        Joerg Roedel <jroedel@suse.de>, Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] iommu/vt-d: Do not BUG_ON in intel_unmap if no domain
Date: Mon,  4 Aug 2014 13:23:06 +0200
Message-Id: <1407151386-16467-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This BUG_ON is easy to trigger with device-hotplug (e.g.
SR-IOV). The device_notifier function in the Intel IOMMU
driver listens to the BUS_NOTIFY_DEL_DEVICE event and frees
the domain for the device if it is reveived.

But this event is triggered before the device driver is
unbound from the device. When the driver core actually
removes the device the driver may release pending DMA
resources, which ends up in intel_unmap and triggers the
BUG_ON.

Not listening to BUS_NOTIFY_DEL_DEVICE would cause resource
leakage with devices that have never been assigned to any
driver, so fix this issue by just making unmap a nop when
the domain is already released.

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d1f5caa..7d689d7 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3196,7 +3196,8 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr)
 		return;
 
 	domain = find_domain(dev);
-	BUG_ON(!domain);
+	if (!domain)
+		return;
 
 	iommu = domain_get_iommu(domain);
 
-- 
1.9.1

