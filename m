Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3LLH7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:59:06 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1575 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3LLH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:01:28 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 12/12] iommu/tegra: smmu: add SMMU to an global iommu list
Date: Thu, 12 Dec 2013 09:57:13 +0200
Message-ID: <1386835033-4701-13-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to inquire if SMMU is populated or not.

Suggested by Thierry Reding and copied his example code.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
---
v6:
New for v6.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 55 +++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 2d4b8b6..d0f0ba7 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -225,6 +225,8 @@ struct smmu_debugfs_info {
  * Per SMMU device - IOMMU device
  */
 struct smmu_device {
+	struct iommu	iommu;
+
 	void __iomem	*regbase;	/* register offset base */
 	void __iomem	**regs;		/* register block start address array */
 	void __iomem	**rege;		/* register block end address array */
@@ -234,7 +236,6 @@ struct smmu_device {
 	unsigned long	page_count;	/* total remappable size */
 	spinlock_t	lock;
 	char		*name;
-	struct device	*dev;
 	struct rb_root	clients;
 	struct page *avp_vector_page;	/* dummy page shared by all AS's */
 
@@ -371,7 +372,7 @@ static int register_smmu_client(struct smmu_device *smmu,
 		return -EBUSY;
 	}
 
-	client = devm_kzalloc(smmu->dev, sizeof(*client), GFP_KERNEL);
+	client = devm_kzalloc(smmu->iommu.dev, sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return -ENOMEM;
 
@@ -388,7 +389,7 @@ static int smmu_of_get_swgroups(struct device *dev, unsigned long *swgroups)
 
 	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
 					       "#iommu-cells", 0, args, cur, end) {
-		if (args.np != smmu_handle->dev->of_node)
+		if (args.np != smmu_handle->iommu.dev->of_node)
 			continue;
 
 		BUG_ON(args.args_count != 2);
@@ -527,7 +528,7 @@ static void free_ptbl(struct smmu_as *as, dma_addr_t iova)
 	unsigned long *pdir = (unsigned long *)page_address(as->pdir_page);
 
 	if (pdir[pdn] != _PDE_VACANT(pdn)) {
-		dev_dbg(as->smmu->dev, "pdn: %lx\n", pdn);
+		dev_dbg(as->smmu->iommu.dev, "pdn: %lx\n", pdn);
 
 		ClearPageReserved(SMMU_EX_PTBL_PAGE(pdir[pdn]));
 		__free_page(SMMU_EX_PTBL_PAGE(pdir[pdn]));
@@ -542,7 +543,7 @@ static void free_pdir(struct smmu_as *as)
 {
 	unsigned addr;
 	int count;
-	struct device *dev = as->smmu->dev;
+	struct device *dev = as->smmu->iommu.dev;
 
 	if (!as->pdir_page)
 		return;
@@ -585,11 +586,11 @@ static unsigned long *locate_pte(struct smmu_as *as,
 		unsigned long addr = SMMU_PDN_TO_ADDR(pdn);
 
 		/* Vacant - allocate a new page table */
-		dev_dbg(as->smmu->dev, "New PTBL pdn: %lx\n", pdn);
+		dev_dbg(as->smmu->iommu.dev, "New PTBL pdn: %lx\n", pdn);
 
 		*ptbl_page_p = alloc_page(GFP_ATOMIC);
 		if (!*ptbl_page_p) {
-			dev_err(as->smmu->dev,
+			dev_err(as->smmu->iommu.dev,
 				"failed to allocate smmu_device page table\n");
 			return NULL;
 		}
@@ -649,7 +650,7 @@ static int alloc_pdir(struct smmu_as *as)
 	/*
 	 * do the allocation, then grab as->lock
 	 */
-	cnt = devm_kzalloc(smmu->dev,
+	cnt = devm_kzalloc(smmu->iommu.dev,
 			   sizeof(cnt[0]) * SMMU_PDIR_COUNT,
 			   GFP_KERNEL);
 	page = alloc_page(GFP_KERNEL | __GFP_DMA);
@@ -663,7 +664,8 @@ static int alloc_pdir(struct smmu_as *as)
 	}
 
 	if (!page || !cnt) {
-		dev_err(smmu->dev, "failed to allocate at %s\n", __func__);
+		dev_err(smmu->iommu.dev,
+			"failed to allocate at %s\n", __func__);
 		err = -ENOMEM;
 		goto err_out;
 	}
@@ -693,7 +695,7 @@ static int alloc_pdir(struct smmu_as *as)
 err_out:
 	spin_unlock_irqrestore(&as->lock, flags);
 
-	devm_kfree(smmu->dev, cnt);
+	devm_kfree(smmu->iommu.dev, cnt);
 	if (page)
 		__free_page(page);
 	return err;
@@ -748,7 +750,7 @@ static int smmu_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	unsigned long pfn = __phys_to_pfn(pa);
 	unsigned long flags;
 
-	dev_info(as->smmu->dev, "[%d] %08lx:%pa\n", as->asid, iova, &pa);
+	dev_info(as->smmu->iommu.dev, "[%d] %08lx:%pa\n", as->asid, iova, &pa);
 
 	if (!pfn_valid(pfn))
 		return -ENOMEM;
@@ -765,7 +767,7 @@ static size_t smmu_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	struct smmu_as *as = domain->priv;
 	unsigned long flags;
 
-	dev_dbg(as->smmu->dev, "[%d] %08lx\n", as->asid, iova);
+	dev_dbg(as->smmu->iommu.dev, "[%d] %08lx\n", as->asid, iova);
 
 	spin_lock_irqsave(&as->lock, flags);
 	__smmu_iommu_unmap(as, iova);
@@ -788,7 +790,7 @@ static phys_addr_t smmu_iommu_iova_to_phys(struct iommu_domain *domain,
 	pte = locate_pte(as, iova, true, &page, &count);
 	pfn = *pte & SMMU_PFN_MASK;
 	WARN_ON(!pfn_valid(pfn));
-	dev_dbg(as->smmu->dev,
+	dev_dbg(as->smmu->iommu.dev,
 		"iova:%08llx pfn:%08lx asid:%d\n", (unsigned long long)iova,
 		 pfn, as->asid);
 
@@ -822,7 +824,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	spin_lock(&as->client_lock);
 	list_for_each_entry(c, &as->client, list) {
 		if (c->dev == dev) {
-			dev_err(smmu->dev,
+			dev_err(smmu->iommu.dev,
 				"%s is already attached\n", dev_name(c->dev));
 			err = -EINVAL;
 			goto err_client;
@@ -844,7 +846,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 		pr_info("Reserve \"page zero\" for AVP vectors using a common dummy\n");
 	}
 
-	dev_dbg(smmu->dev, "%s is attached\n", dev_name(dev));
+	dev_dbg(smmu->iommu.dev, "%s is attached\n", dev_name(dev));
 	return 0;
 
 err_client:
@@ -867,12 +869,12 @@ static void smmu_iommu_detach_dev(struct iommu_domain *domain,
 			smmu_client_disable_swgroups(c);
 			list_del(&c->list);
 			c->as = NULL;
-			dev_dbg(smmu->dev,
+			dev_dbg(smmu->iommu.dev,
 				"%s is detached\n", dev_name(c->dev));
 			goto out;
 		}
 	}
-	dev_err(smmu->dev, "Couldn't find %s\n", dev_name(dev));
+	dev_err(smmu->iommu.dev, "Couldn't find %s\n", dev_name(dev));
 out:
 	spin_unlock(&as->client_lock);
 }
@@ -899,7 +901,7 @@ static int smmu_iommu_domain_init(struct iommu_domain *domain)
 			break;
 	}
 	if (i == smmu->num_as)
-		dev_err(smmu->dev,  "no free AS\n");
+		dev_err(smmu->iommu.dev,  "no free AS\n");
 	return err;
 
 found:
@@ -920,7 +922,7 @@ found:
 		smmu->page_count * SMMU_PAGE_SIZE - 1;
 	domain->geometry.force_aperture = true;
 
-	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
+	dev_dbg(smmu->iommu.dev, "smmu_as@%p\n", as);
 
 	return 0;
 }
@@ -953,7 +955,7 @@ static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
 	spin_unlock_irqrestore(&as->lock, flags);
 
 	domain->priv = NULL;
-	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
+	dev_dbg(smmu->iommu.dev, "smmu_as@%p\n", as);
 }
 
 /*
@@ -1085,7 +1087,7 @@ static ssize_t smmu_debugfs_stats_write(struct file *file,
 		break;
 	}
 
-	dev_dbg(smmu->dev, "%s() %08x, %08x @%08x\n", __func__,
+	dev_dbg(smmu->iommu.dev, "%s() %08x, %08x @%08x\n", __func__,
 		val, smmu_read(smmu, offs), offs);
 
 	return count;
@@ -1107,7 +1109,7 @@ static int smmu_debugfs_stats_show(struct seq_file *s, void *v)
 		val = smmu_read(smmu, offs);
 		seq_printf(s, "%s:%08x ", stats[i], val);
 
-		dev_dbg(smmu->dev, "%s() %s %08x @%08x\n", __func__,
+		dev_dbg(smmu->iommu.dev, "%s() %s %08x @%08x\n", __func__,
 			stats[i], val, offs);
 	}
 	seq_printf(s, "\n");
@@ -1145,7 +1147,7 @@ static void smmu_debugfs_create(struct smmu_device *smmu)
 	if (!smmu->debugfs_info)
 		return;
 
-	root = debugfs_create_dir(dev_name(smmu->dev), NULL);
+	root = debugfs_create_dir(dev_name(smmu->iommu.dev), NULL);
 	if (!root)
 		goto err_out;
 	smmu->debugfs_root = root;
@@ -1217,7 +1219,7 @@ static void tegra_smmu_create_default_map(struct smmu_device *smmu)
 		smmu->map[i] = arm_iommu_create_mapping(&platform_bus_type,
 							base, size, 0);
 		if (IS_ERR(smmu->map[i]))
-			dev_err(smmu->dev,
+			dev_err(smmu->iommu.dev,
 				"Couldn't create: asid=%d map=%p %pa-%pa\n",
 				i, smmu->map[i], &base, &base + size - 1);
 	}
@@ -1285,7 +1287,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	if (!smmu->ahb)
 		return -ENODEV;
 
-	smmu->dev = dev;
+	smmu->iommu.dev = dev;
 	smmu->num_as = asids;
 	smmu->iovmm_base = base;
 	smmu->page_count = size;
@@ -1322,6 +1324,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu_handle = smmu;
 	bus_set_iommu(&platform_bus_type, &smmu_iommu_ops);
 	tegra_smmu_create_default_map(smmu);
+
+	iommu_add(&smmu->iommu);
 	return 0;
 }
 
@@ -1337,6 +1341,7 @@ static int tegra_smmu_remove(struct platform_device *pdev)
 		free_pdir(&smmu->as[i]);
 	__free_page(smmu->avp_vector_page);
 	smmu_handle = NULL;
+	iommu_del(&smmu->iommu);
 	return 0;
 }
 
-- 
1.8.1.5

