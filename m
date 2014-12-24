Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaLXBKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 20:10:49 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13306 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaLXBKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 20:10:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 17:09:04 -0800
From: Mark Zhang <markz@nvidia.com>
To: gnurou@gmail.com, hdoyu@nvidia.com, joro@8bytes.org, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, olof@lixom.net
CC: iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Zhang <markz@nvidia.com>
Subject: [PATCH v2] memory: Add NVIDIA SMMU suspend/resume support
Date: Wed, 24 Dec 2014 09:10:41 +0800
Message-ID: <1419383441-18242-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume support for NVIDIA SMMU.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
Hi Alex/Olof/Thierry/Hiroshi,

This patch is created on top of Thierry Reding's patch set:
"[PATCH v7 00/12] NVIDIA Tegra memory controller and IOMMU support"

Changes since v1:
- Remove the list which saves "tegra_smmu_swgroup_asid" instances
- Save all ASID registers when suspend then restore them when resume

 drivers/iommu/tegra-smmu.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/memory/tegra/mc.c  | 24 ++++++++++++++++
 drivers/memory/tegra/mc.h  |  8 ++++++
 3 files changed, 103 insertions(+)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 0909e0bae9ec..e735840d35d8 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -17,6 +17,8 @@
 #include <soc/tegra/ahb.h>
 #include <soc/tegra/mc.h>
 
+struct tegra_smmu_as;
+
 struct tegra_smmu {
 	void __iomem *regs;
 	struct device *dev;
@@ -25,8 +27,11 @@ struct tegra_smmu {
 	const struct tegra_smmu_soc *soc;
 
 	unsigned long *asids;
+	struct tegra_smmu_as **as;
 	struct mutex lock;
 
+	u32 *asid_reg_save;
+
 	struct list_head list;
 };
 
@@ -376,6 +381,7 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 	as->smmu = smmu;
 	as->use_count++;
 
+	smmu->as[as->id] = as;
 	return 0;
 }
 
@@ -386,6 +392,7 @@ static void tegra_smmu_as_unprepare(struct tegra_smmu *smmu,
 		return;
 
 	tegra_smmu_free_asid(smmu, as->id);
+	smmu->as[as->id] = NULL;
 	as->smmu = NULL;
 }
 
@@ -651,6 +658,58 @@ static void tegra_smmu_ahb_enable(void)
 	}
 }
 
+void tegra_smmu_suspend(struct tegra_smmu *smmu)
+{
+	int i;
+
+	for (i = 0; i < smmu->soc->num_swgroups; i++)
+		smmu->asid_reg_save[i] = smmu_readl(smmu,
+			smmu->soc->swgroups[i].reg);
+}
+
+void tegra_smmu_resume(struct tegra_smmu *smmu)
+{
+	struct tegra_smmu_as *as;
+	unsigned int bit;
+	u32 value;
+	int i;
+
+	for_each_set_bit(bit, smmu->asids, smmu->soc->num_asids) {
+		as = smmu->as[bit];
+		smmu->soc->ops->flush_dcache(as->pd, 0, SMMU_SIZE_PD);
+
+		smmu_writel(smmu, as->id & 0x7f, SMMU_PTB_ASID);
+		value = SMMU_PTB_DATA_VALUE(as->pd, as->attr);
+		smmu_writel(smmu, value, SMMU_PTB_DATA);
+	}
+
+	for (i = 0; i < smmu->soc->num_swgroups; i++)
+		smmu_writel(smmu, smmu->asid_reg_save[i],
+				smmu->soc->swgroups[i].reg);
+
+	value = SMMU_PTC_CONFIG_ENABLE | SMMU_PTC_CONFIG_INDEX_MAP(0x3f);
+
+	if (smmu->soc->supports_request_limit)
+		value |= SMMU_PTC_CONFIG_REQ_LIMIT(8);
+
+	smmu_writel(smmu, value, SMMU_PTC_CONFIG);
+
+	value = SMMU_TLB_CONFIG_HIT_UNDER_MISS |
+		SMMU_TLB_CONFIG_ACTIVE_LINES(0x20);
+
+	if (smmu->soc->supports_round_robin_arbitration)
+		value |= SMMU_TLB_CONFIG_ROUND_ROBIN_ARBITRATION;
+
+	smmu_writel(smmu, value, SMMU_TLB_CONFIG);
+
+	smmu_flush_ptc(smmu, NULL, 0);
+	smmu_flush_tlb(smmu);
+	smmu_writel(smmu, SMMU_CONFIG_ENABLE, SMMU_CONFIG);
+	smmu_flush(smmu);
+
+	tegra_smmu_ahb_enable();
+}
+
 struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 				    const struct tegra_smmu_soc *soc,
 				    struct tegra_mc *mc)
@@ -684,6 +743,18 @@ struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 	if (!smmu->asids)
 		return ERR_PTR(-ENOMEM);
 
+	smmu->asid_reg_save = devm_kzalloc(dev,
+				sizeof(u32) * smmu->soc->num_swgroups,
+				GFP_KERNEL);
+	if (!smmu->asid_reg_save)
+		return ERR_PTR(-ENOMEM);
+
+	smmu->as = devm_kzalloc(dev,
+				sizeof(struct tegra_smmu_as *) * soc->num_asids,
+				GFP_KERNEL);
+	if (!smmu->as)
+		return ERR_PTR(-ENOMEM);
+
 	mutex_init(&smmu->lock);
 
 	smmu->regs = mc->regs;
diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index 9b7c1645fd59..f48368fca423 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -283,6 +283,28 @@ static int tegra_mc_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int tegra_mc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct tegra_mc *mc = platform_get_drvdata(pdev);
+
+	if (IS_ENABLED(CONFIG_TEGRA_IOMMU_SMMU))
+		tegra_smmu_suspend(mc->smmu);
+
+	return 0;
+}
+
+static int tegra_mc_resume(struct platform_device *pdev)
+{
+	struct tegra_mc *mc = platform_get_drvdata(pdev);
+
+	if (IS_ENABLED(CONFIG_TEGRA_IOMMU_SMMU))
+		tegra_smmu_resume(mc->smmu);
+
+	return 0;
+}
+#endif
+
 static struct platform_driver tegra_mc_driver = {
 	.driver = {
 		.name = "tegra-mc",
@@ -291,6 +313,8 @@ static struct platform_driver tegra_mc_driver = {
 	},
 	.prevent_deferred_probe = true,
 	.probe = tegra_mc_probe,
+	.suspend = tegra_mc_suspend,
+	.resume = tegra_mc_resume,
 };
 
 static int tegra_mc_init(void)
diff --git a/drivers/memory/tegra/mc.h b/drivers/memory/tegra/mc.h
index f714c309b960..efc45ceed5ba 100644
--- a/drivers/memory/tegra/mc.h
+++ b/drivers/memory/tegra/mc.h
@@ -29,6 +29,8 @@ static inline void mc_writel(struct tegra_mc *mc, u32 value,
 struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 				    const struct tegra_smmu_soc *soc,
 				    struct tegra_mc *mc);
+void tegra_smmu_suspend(struct tegra_smmu *smmu);
+void tegra_smmu_resume(struct tegra_smmu *smmu);
 #else
 static inline struct tegra_smmu *
 tegra_smmu_probe(struct device *dev, const struct tegra_smmu_soc *soc,
@@ -36,6 +38,12 @@ tegra_smmu_probe(struct device *dev, const struct tegra_smmu_soc *soc,
 {
 	return NULL;
 }
+void tegra_smmu_suspend(struct tegra_smmu *smmu)
+{
+}
+void tegra_smmu_resume(struct tegra_smmu *smmu)
+{
+}
 #endif
 
 #ifdef CONFIG_ARCH_TEGRA_3x_SOC
-- 
1.8.1.5

