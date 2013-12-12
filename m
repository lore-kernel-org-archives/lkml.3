Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3LLIAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:00:36 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1540 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3LLH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 00:00:09 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 07/12] iommu/tegra: smmu: register device to iommu dynamically
Date: Thu, 12 Dec 2013 09:57:08 +0200
Message-ID: <1386835033-4701-8-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_devices are registered as IOMMU'able dynamically via
add_device() and remove_device().

Tegra SMMU can have multiple address spaces(AS). IOMMU'able devices
can belong to one of them. Multiple IOVA maps are created at boot-up,
which can be attached to devices later. We reserve 2 of them for
static assignment, AS[0] for system default, AS[1] for AHB clusters as
protected domain from others, where there are many traditional
pheripheral devices like USB, SD/MMC. They should be isolated from
some smart devices like host1x for system robustness. Even if smart
devices behaves wrongly, the traditional devices(SD/MMC, USB) wouldn't
be affected, and the system could continue most likely. DMA API(ARM)
needs ARM_DMA_USE_IOMMU to be enabled.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6:
Use smmu_iommu_{bound,unbind}_driver() instead of
smmu_iommu_{add,del}_device() to register devices to SMMU.

v5:
Add check NUM_OF_STATIC_MAPS < #asids.

v4:
Combined the following from v3. This makes more sense what they do.
  [PATCHv3 06/19] iommu/tegra: smmu: Select ARM_DMA_USE_IOMMU in Kconfig
  [PATCHv3 07/19] iommu/tegra: smmu: Create default IOVA maps
  [PATCHv3 08/19] iommu/tegra: smmu: Register platform_device to IOMMU dynamically
  [PATCHv3 19/19] iommu/tegra: smmu: Support Multiple ASID

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/Kconfig      |  1 +
 drivers/iommu/tegra-smmu.c | 70 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3e7fdbb..0a86d63 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -170,6 +170,7 @@ config TEGRA_IOMMU_SMMU
 	bool "Tegra SMMU IOMMU Support"
 	depends on ARCH_TEGRA && TEGRA_AHB
 	select IOMMU_API
+	select ARM_DMA_USE_IOMMU
 	help
 	  Enables support for remapping discontiguous physical memory
 	  shared with the operating system into contiguous I/O virtual
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 3c772c9..99b4bd4 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -39,6 +39,9 @@
 
 #include <asm/page.h>
 #include <asm/cacheflush.h>
+#include <asm/dma-iommu.h>
+
+#include <dt-bindings/memory/tegra-swgroup.h>
 
 enum smmu_hwgrp {
 	HWGRP_AFI,
@@ -319,6 +322,8 @@ struct smmu_device {
 
 	struct device_node *ahb;
 
+	struct dma_iommu_mapping **map;
+
 	int		num_as;
 	struct smmu_as	as[0];		/* Run-time allocated array */
 };
@@ -947,6 +952,44 @@ static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
 	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
 }
 
+/*
+ * ASID[0] for the system default
+ * ASID[1] for PPCS("AHB bus children"), which has SDMMC
+ * ASID[2][3].. open for drivers, first come, first served.
+ */
+enum {
+	SYSTEM_DEFAULT,
+	SYSTEM_PROTECTED,
+	NUM_OF_STATIC_MAPS,
+};
+
+static int smmu_iommu_bound_driver(struct device *dev)
+{
+	int err = -EPROBE_DEFER;
+	u32 swgroups = dev->platform_data;
+	struct dma_iommu_mapping *map = NULL;
+
+	if (test_bit(TEGRA_SWGROUP_PPCS, swgroups))
+		map = smmu_handle->map[SYSTEM_PROTECTED];
+	else
+		map = smmu_handle->map[SYSTEM_DEFAULT];
+
+	if (map)
+		err = arm_iommu_attach_device(dev, map);
+	else
+		return -EPROBE_DEFER;
+
+	pr_debug("swgroups=%08lx map=%p err=%d %s\n",
+		 swgroups, map, err, dev_name(dev));
+	return err;
+}
+
+static void smmu_iommu_unbind_driver(struct device *dev)
+{
+	dev_dbg(dev, "Detaching from map %p\n", to_dma_iommu_mapping(dev));
+	arm_iommu_detach_device(dev);
+}
+
 static struct iommu_ops smmu_iommu_ops = {
 	.domain_init	= smmu_iommu_domain_init,
 	.domain_destroy	= smmu_iommu_domain_destroy,
@@ -956,6 +999,8 @@ static struct iommu_ops smmu_iommu_ops = {
 	.unmap		= smmu_iommu_unmap,
 	.iova_to_phys	= smmu_iommu_iova_to_phys,
 	.domain_has_cap	= smmu_iommu_domain_has_cap,
+	.bound_driver	= smmu_iommu_bound_driver,
+	.unbind_driver	= smmu_iommu_unbind_driver,
 	.pgsize_bitmap	= SMMU_IOMMU_PGSIZES,
 };
 
@@ -1144,6 +1189,23 @@ static int tegra_smmu_resume(struct device *dev)
 	return err;
 }
 
+static void tegra_smmu_create_default_map(struct smmu_device *smmu)
+{
+	int i;
+
+	for (i = 0; i < smmu->num_as; i++) {
+		dma_addr_t base = smmu->iovmm_base;
+		size_t size = smmu->page_count << PAGE_SHIFT;
+
+		smmu->map[i] = arm_iommu_create_mapping(&platform_bus_type,
+							base, size, 0);
+		if (IS_ERR(smmu->map[i]))
+			dev_err(smmu->dev,
+				"Couldn't create: asid=%d map=%p %pa-%pa\n",
+				i, smmu->map[i], &base, &base + size - 1);
+	}
+}
+
 static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
@@ -1160,13 +1222,18 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
 		return -ENODEV;
 
-	bytes = sizeof(*smmu) + asids * sizeof(*smmu->as);
+	if (asids < NUM_OF_STATIC_MAPS)
+		return -EINVAL;
+
+	bytes = sizeof(*smmu) + asids * (sizeof(*smmu->as) +
+					 sizeof(struct dma_iommu_mapping *));
 	smmu = devm_kzalloc(dev, bytes, GFP_KERNEL);
 	if (!smmu) {
 		dev_err(dev, "failed to allocate smmu_device\n");
 		return -ENOMEM;
 	}
 
+	smmu->map = (struct dma_iommu_mapping **)(smmu->as + asids);
 	smmu->nregs = pdev->num_resources;
 	smmu->regs = devm_kzalloc(dev, 2 * smmu->nregs * sizeof(*smmu->regs),
 				  GFP_KERNEL);
@@ -1236,6 +1303,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu_debugfs_create(smmu);
 	smmu_handle = smmu;
 	bus_set_iommu(&platform_bus_type, &smmu_iommu_ops);
+	tegra_smmu_create_default_map(smmu);
 	return 0;
 }
 
-- 
1.8.1.5

