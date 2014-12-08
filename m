Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaLHGWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:22:13 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3690 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaLHGWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:22:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 07 Dec 2014 22:19:11 -0800
From: Mark Zhang <markz@nvidia.com>
To: <hdoyu@nvidia.com>, <joro@8bytes.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>, <olof@lixom.net>
CC: <iommu@lists.linux-foundation.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH] memory: Add NVIDIA SMMU suspend/resume support
Date: Mon, 8 Dec 2014 14:20:56 +0800
Message-ID: <1418019656-6893-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume support for NVIDIA SMMU.
This patch is created on top of Thierry Reding's patch set:

"[PATCH v7 00/12] NVIDIA Tegra memory controller and IOMMU support"

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 79 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/memory/tegra/mc.c  | 21 ++++++++++++
 drivers/memory/tegra/mc.h  |  4 +++
 3 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 0909e0bae9ec..ab38805055a4 100644
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
@@ -25,9 +27,10 @@ struct tegra_smmu {
 	const struct tegra_smmu_soc *soc;
 
 	unsigned long *asids;
+	struct tegra_smmu_as **as;
 	struct mutex lock;
 
-	struct list_head list;
+	struct list_head swgroup_asid_list;
 };
 
 struct tegra_smmu_as {
@@ -40,6 +43,12 @@ struct tegra_smmu_as {
 	u32 attr;
 };
 
+struct tegra_smmu_swgroup_asid {
+	struct list_head list;
+	unsigned swgroup_id;
+	unsigned asid;
+};
+
 static inline void smmu_writel(struct tegra_smmu *smmu, u32 value,
 			       unsigned long offset)
 {
@@ -376,6 +385,7 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 	as->smmu = smmu;
 	as->use_count++;
 
+	smmu->as[as->id] = as;
 	return 0;
 }
 
@@ -386,6 +396,7 @@ static void tegra_smmu_as_unprepare(struct tegra_smmu *smmu,
 		return;
 
 	tegra_smmu_free_asid(smmu, as->id);
+	smmu->as[as->id] = NULL;
 	as->smmu = NULL;
 }
 
@@ -398,6 +409,7 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
 	struct of_phandle_args args;
 	unsigned int index = 0;
 	int err = 0;
+	struct tegra_smmu_swgroup_asid *sa = NULL;
 
 	while (!of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
 					   &args)) {
@@ -411,6 +423,14 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
 			return err;
 
 		tegra_smmu_enable(smmu, swgroup, as->id);
+
+		sa = kzalloc(sizeof(struct tegra_smmu_swgroup_asid),
+				GFP_KERNEL);
+		INIT_LIST_HEAD(&sa->list);
+		sa->swgroup_id = swgroup;
+		sa->asid = as->id;
+		list_add_tail(&sa->list, &smmu->swgroup_asid_list);
+
 		index++;
 	}
 
@@ -427,6 +447,7 @@ static void tegra_smmu_detach_dev(struct iommu_domain *domain, struct device *de
 	struct tegra_smmu *smmu = as->smmu;
 	struct of_phandle_args args;
 	unsigned int index = 0;
+	struct tegra_smmu_swgroup_asid *sa = NULL;
 
 	while (of_parse_phandle_with_args(np, "iommus", "#iommu-cells", index,
 					  &args)) {
@@ -435,6 +456,13 @@ static void tegra_smmu_detach_dev(struct iommu_domain *domain, struct device *de
 		if (args.np != smmu->dev->of_node)
 			continue;
 
+		list_for_each_entry(sa, &smmu->swgroup_asid_list, list) {
+			if (sa->asid == as->id && sa->swgroup_id == swgroup)
+				break;
+		}
+		list_del(&sa->list);
+		kfree(sa);
+
 		tegra_smmu_disable(smmu, swgroup, as->id);
 		tegra_smmu_as_unprepare(smmu, as);
 		index++;
@@ -651,6 +679,48 @@ static void tegra_smmu_ahb_enable(void)
 	}
 }
 
+void tegra_smmu_resume(struct tegra_smmu *smmu)
+{
+	struct tegra_smmu_as *as = NULL;
+	unsigned int bit;
+	u32 value;
+	struct tegra_smmu_swgroup_asid *sa = NULL;
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
+	list_for_each_entry(sa, &smmu->swgroup_asid_list, list)
+		tegra_smmu_enable(smmu, sa->swgroup_id, sa->asid);
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
@@ -684,7 +754,14 @@ struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 	if (!smmu->asids)
 		return ERR_PTR(-ENOMEM);
 
+	smmu->as = devm_kzalloc(dev,
+				sizeof(struct tegra_smmu_as *) * soc->num_asids,
+				GFP_KERNEL);
+	if (!smmu->as)
+		return ERR_PTR(-ENOMEM);
+
 	mutex_init(&smmu->lock);
+	INIT_LIST_HEAD(&smmu->swgroup_asid_list);
 
 	smmu->regs = mc->regs;
 	smmu->soc = soc;
diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index 9b7c1645fd59..aa0c59ccd33a 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -283,6 +283,23 @@ static int tegra_mc_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int tegra_mc_suspend(struct platform_device *pdev, pm_message_t state)
+{
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
@@ -291,6 +308,10 @@ static struct platform_driver tegra_mc_driver = {
 	},
 	.prevent_deferred_probe = true,
 	.probe = tegra_mc_probe,
+#ifdef CONFIG_PM
+	.suspend = tegra_mc_suspend,
+	.resume = tegra_mc_resume,
+#endif
 };
 
 static int tegra_mc_init(void)
diff --git a/drivers/memory/tegra/mc.h b/drivers/memory/tegra/mc.h
index f714c309b960..cbf538b3f995 100644
--- a/drivers/memory/tegra/mc.h
+++ b/drivers/memory/tegra/mc.h
@@ -29,6 +29,7 @@ static inline void mc_writel(struct tegra_mc *mc, u32 value,
 struct tegra_smmu *tegra_smmu_probe(struct device *dev,
 				    const struct tegra_smmu_soc *soc,
 				    struct tegra_mc *mc);
+void tegra_smmu_resume(struct tegra_smmu *smmu);
 #else
 static inline struct tegra_smmu *
 tegra_smmu_probe(struct device *dev, const struct tegra_smmu_soc *soc,
@@ -36,6 +37,9 @@ tegra_smmu_probe(struct device *dev, const struct tegra_smmu_soc *soc,
 {
 	return NULL;
 }
+void tegra_smmu_resume(struct tegra_smmu *smmu)
+{
+}
 #endif
 
 #ifdef CONFIG_ARCH_TEGRA_3x_SOC
-- 
1.8.1.5

