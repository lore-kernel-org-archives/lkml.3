Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3JRPIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:08:54 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54966 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3JRPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:08:53 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [PATCH v2] ARM: SMMU: add devices attached to the SMMU to an IOMMU group
Date: Fri, 18 Oct 2013 17:08:29 +0200
Message-Id: <1382108910-18049-1-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Add new devices found by the SMMU driver to an IOMMU
group to satisfy those users.

Changes from v1:
 * Added check that dev->archdata.iommu has not been set already by an IOMMU
   driver. This way we can also skip checking for an existing IOMMU group.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 0f45a48..6762885 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1502,6 +1502,13 @@ static int arm_smmu_add_device(struct device *dev)
 {
 	struct arm_smmu_device *child, *parent, *smmu;
 	struct arm_smmu_master *master = NULL;
+	struct iommu_group *group;
+	int ret;
+
+	if (dev->archdata.iommu) {
+		dev_warn(dev, "IOMMU driver already assigned to device\n");
+		return -EINVAL;
+	}
 
 	spin_lock(&arm_smmu_devices_lock);
 	list_for_each_entry(parent, &arm_smmu_devices, list) {
@@ -1534,13 +1541,23 @@ static int arm_smmu_add_device(struct device *dev)
 	if (!master)
 		return -ENODEV;
 
+	group = iommu_group_alloc();
+	if (IS_ERR(group)) {
+		dev_err(dev, "Failed to allocate IOMMU group\n");
+		return PTR_ERR(group);
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	iommu_group_put(group);
 	dev->archdata.iommu = smmu;
-	return 0;
+
+	return ret;
 }
 
 static void arm_smmu_remove_device(struct device *dev)
 {
 	dev->archdata.iommu = NULL;
+	iommu_group_remove_device(dev);
 }
 
 static struct iommu_ops arm_smmu_ops = {
-- 
1.8.1.2

