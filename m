Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaLVJRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:17:12 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:36859 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaLVJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:17:07 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>
Subject: [PATCH 07/10] iommu/vt-d: enable kdump support in iommu module
Date: Mon, 22 Dec 2014 17:15:26 +0800
Message-Id: <1419239729-26529-8-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the operation of the following functions when called during crash dump:
    device_to_domain_id
    get_domain_for_dev
    init_dmars
    intel_iommu_init

Bill Sumner:
    Original version.

Zhenhua:
    Minor change,
    The name of new calling functions.
    Do not disable and re-enable TE in kdump kernel.

Signed-off-by: Bill Sumner <billsumnerlinux@gmail.com>
Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 142 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 125 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f9849cb..4efed7c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -907,6 +907,11 @@ static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
 		set_root_value(root, phy_addr);
 		set_root_present(root);
 		__iommu_flush_cache(iommu, root, sizeof(*root));
+
+#ifdef CONFIG_CRASH_DUMP
+		if (is_kdump_kernel())
+			__iommu_update_old_root_entry(iommu, bus);
+#endif
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
 	return &context[devfn];
@@ -958,7 +963,8 @@ static void free_context_table(struct intel_iommu *iommu)
 
 	spin_lock_irqsave(&iommu->lock, flags);
 	if (!iommu->root_entry) {
-		goto out;
+		spin_unlock_irqrestore(&iommu->lock, flags);
+		return;
 	}
 	for (i = 0; i < ROOT_ENTRY_NR; i++) {
 		root = &iommu->root_entry[i];
@@ -966,10 +972,26 @@ static void free_context_table(struct intel_iommu *iommu)
 		if (context)
 			free_pgtable_page(context);
 	}
-	free_pgtable_page(iommu->root_entry);
-	iommu->root_entry = NULL;
-out:
+
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		iommu->root_entry_old_phys = 0;
+		root = iommu->root_entry;
+		iommu->root_entry = NULL;
+	} else {
+#endif
+		free_pgtable_page(iommu->root_entry);
+		iommu->root_entry = NULL;
+#ifdef CONFIG_CRASH_DUMP
+	}
+#endif
+
 	spin_unlock_irqrestore(&iommu->lock, flags);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel())
+		iounmap(root);
+#endif
 }
 
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
@@ -2381,6 +2403,9 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	unsigned long flags;
 	u8 bus, devfn;
 	int did = -1;   /* Default to "no domain_id supplied" */
+#ifdef CONFIG_CRASH_DUMP
+	struct domain_values_entry *dve = NULL;
+#endif /* CONFIG_CRASH_DUMP */
 
 	domain = find_domain(dev);
 	if (domain)
@@ -2414,6 +2439,24 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(0);
 	if (!domain)
 		return NULL;
+
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		/*
+		 * if this device had a did in the old kernel
+		 * use its values instead of generating new ones
+		 */
+		did = device_to_domain_id(iommu, bus, devfn);
+		if (did > 0 || (did == 0 && !cap_caching_mode(iommu->cap)))
+			dve = intel_iommu_did_to_domain_values_entry(did,
+								iommu);
+		if (dve)
+			gaw = dve->gaw;
+		else
+			did = -1;
+	}
+#endif /* CONFIG_CRASH_DUMP */
+
 	domain->id = iommu_attach_domain(domain, iommu, did);
 	if (domain->id < 0) {
 		free_domain_mem(domain);
@@ -2425,6 +2468,18 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 		return NULL;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel() && dve) {
+
+		if (domain->pgd)
+			free_pgtable_page(domain->pgd);
+
+		domain->pgd = dve->pgd;
+
+		copy_reserved_iova(&dve->iovad, &domain->iovad);
+	}
+#endif /* CONFIG_CRASH_DUMP */
+
 	/* register PCI DMA alias device */
 	if (dev_is_pci(dev)) {
 		tmp = dmar_insert_dev_info(iommu, PCI_BUS_NUM(dma_alias),
@@ -2948,14 +3003,35 @@ static int __init init_dmars(void)
 		if (ret)
 			goto free_iommu;
 
-		/*
-		 * TBD:
-		 * we could share the same root & context tables
-		 * among all IOMMU's. Need to Split it later.
-		 */
-		ret = iommu_alloc_root_entry(iommu);
-		if (ret)
-			goto free_iommu;
+#ifdef CONFIG_CRASH_DUMP
+		if (is_kdump_kernel()) {
+			pr_info("IOMMU Copying translate tables from panicked kernel\n");
+			ret = intel_iommu_load_translation_tables(drhd,
+					g_num_of_iommus);
+			if (ret) {
+				pr_err("IOMMU: Copy translate tables failed\n");
+
+				/* Best to stop trying */
+				goto free_iommu;
+			}
+			pr_info("IOMMU: root_cache:0x%12.12llx phys:0x%12.12llx\n",
+				(u64)iommu->root_entry,
+				(u64)iommu->root_entry_old_phys);
+			intel_iommu_get_dids_from_old_kernel(iommu);
+		} else {
+#endif /* CONFIG_CRASH_DUMP */
+			/*
+			 * TBD:
+			 * we could share the same root & context tables
+			 * among all IOMMU's. Need to Split it later.
+			 */
+			ret = iommu_alloc_root_entry(iommu);
+			if (ret)
+				goto free_iommu;
+#ifdef CONFIG_CRASH_DUMP
+		}
+#endif
+
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
@@ -2972,6 +3048,16 @@ static int __init init_dmars(void)
 
 	check_tylersburg_isoch();
 
+#ifdef CONFIG_CRASH_DUMP
+	/*
+	 * In the crashdump kernel: Skip setting-up new domains for
+	 * si, rmrr, and the isa bus on the expectation that these
+	 * translations were copied from the old kernel.
+	 */
+	if (is_kdump_kernel())
+		goto skip_new_domains_for_si_rmrr_isa;
+#endif /* CONFIG_CRASH_DUMP */
+
 	/*
 	 * If pass through is not set or not enabled, setup context entries for
 	 * identity mappings for rmrr, gfx, and isa and may fall back to static
@@ -3012,6 +3098,10 @@ static int __init init_dmars(void)
 
 	iommu_prepare_isa();
 
+#ifdef CONFIG_CRASH_DUMP
+skip_new_domains_for_si_rmrr_isa:;
+#endif /* CONFIG_CRASH_DUMP */
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -3040,7 +3130,15 @@ static int __init init_dmars(void)
 
 		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
 		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
-		iommu_enable_translation(iommu);
+
+#ifdef CONFIG_CRASH_DUMP
+		if (is_kdump_kernel()) {
+			if (!(iommu->gcmd & DMA_GCMD_TE))
+				iommu_enable_translation(iommu);
+		} else
+#endif
+			iommu_enable_translation(iommu);
+
 		iommu_disable_protect_mem_regions(iommu);
 	}
 
@@ -4351,12 +4449,22 @@ int __init intel_iommu_init(void)
 		goto out_free_dmar;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
 	/*
-	 * Disable translation if already enabled prior to OS handover.
+	 * If (This is the crash kernel)
+	 *    Set: copy iommu translate tables from old kernel
+	 *    Skip disabling the iommu hardware translations
 	 */
-	for_each_active_iommu(iommu, drhd)
-		if (iommu->gcmd & DMA_GCMD_TE)
-			iommu_disable_translation(iommu);
+	if (is_kdump_kernel()) {
+		pr_info("IOMMU Skip disabling iommu hardware translations\n");
+	} else
+#endif /* CONFIG_CRASH_DUMP */
+		/*
+		 * Disable translation if already enabled prior to OS handover.
+		 */
+		for_each_active_iommu(iommu, drhd)
+			if (iommu->gcmd & DMA_GCMD_TE)
+				iommu_disable_translation(iommu);
 
 	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
-- 
2.0.0-rc0

