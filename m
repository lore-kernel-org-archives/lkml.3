Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3JKNZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:25:05 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46567 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3JKNZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:25:03 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, agraf@suse.de, B08248@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [PATCH 1/2] ARM: SMMU: add devices attached to the SMMU to an IOMMU group
Date: Fri, 11 Oct 2013 15:24:46 +0200
Message-Id: <1381497887-14586-1-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Add new devices found by the SMMU driver to an IOMMU
group to satisfy those users.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 0f45a48..8b71332 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1502,6 +1502,8 @@ static int arm_smmu_add_device(struct device *dev)
 {
 	struct arm_smmu_device *child, *parent, *smmu;
 	struct arm_smmu_master *master = NULL;
+	struct iommu_group *group;
+	int ret;
 
 	spin_lock(&arm_smmu_devices_lock);
 	list_for_each_entry(parent, &arm_smmu_devices, list) {
@@ -1534,13 +1536,27 @@ static int arm_smmu_add_device(struct device *dev)
 	if (!master)
 		return -ENODEV;
 
+	group = iommu_group_get(dev);
+
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group)) {
+			dev_err(dev, "Failed to allocate IOMMU group\n");
+			return PTR_ERR(group);
+		}
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

