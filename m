Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaHUViM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:38:12 -0400
Received: from 8bytes.org ([81.169.241.247]:32980 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbaHUViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:38:08 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/2] iommu: Make iommu_group_get_for_dev() more robust
Date: Thu, 21 Aug 2014 23:37:24 +0200
Message-Id: <1408657045-4979-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408657045-4979-1-git-send-email-joro@8bytes.org>
References: <1408657045-4979-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When a non-PCI device is passed to that function it might
pass group == NULL to iommu_group_add_device() which then
dereferences it and cause a crash this way. Fix it by
just returning an error for non-PCI devices.

Fixes: 104a1c13ac66e40cf8c6ae74d76ff14ff24b9b01
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1698360..ef8da12 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -678,15 +678,17 @@ static struct iommu_group *iommu_group_get_for_pci_dev(struct pci_dev *pdev)
  */
 struct iommu_group *iommu_group_get_for_dev(struct device *dev)
 {
-	struct iommu_group *group = ERR_PTR(-EIO);
+	struct iommu_group *group;
 	int ret;
 
 	group = iommu_group_get(dev);
 	if (group)
 		return group;
 
-	if (dev_is_pci(dev))
-		group = iommu_group_get_for_pci_dev(to_pci_dev(dev));
+	if (!dev_is_pci(dev))
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get_for_pci_dev(to_pci_dev(dev));
 
 	if (IS_ERR(group))
 		return group;
-- 
1.9.1

