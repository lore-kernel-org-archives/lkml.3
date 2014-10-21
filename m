Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaJUIHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:07:48 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:11419 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaJUIFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:19 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 5/5] iommu/vt-d: enable kdump support in iommu module
Date: Tue, 21 Oct 2014 16:04:19 +0800
Message-Id: <1413878659-1383-6-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the operation of the following functions when called during crash dump:
 device_to_domain_id
 get_domain_for_dev
 init_dmars
 intel_iommu_init

Signed-off-by: Bill Sumner 
---
 drivers/iommu/intel-iommu.c | 134 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 121 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index bde8f22..be12dab 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -40,6 +40,7 @@
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
 #include <linux/dma-contiguous.h>
+#include <linux/crash_dump.h>
 #include <asm/irq_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -393,6 +394,8 @@ static struct list_head *domain_values_list;
  */
 #define RET_BADCOPY -1	/* Return-code: Cannot copy translate tables */
 
+static int intel_iommu_in_crashdump;
+
 /*
  * Struct copy_page_addr_parms is used to allow copy_page_addr()
  * to accumulate values across multiple calls and returns.
@@ -2287,6 +2290,24 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
+#ifdef CONFIG_CRASH_DUMP
+static int device_to_domain_id(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	int did = -1;			/* domain-id returned */
+	struct root_entry *root;
+	struct context_entry *context;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	context = get_context_addr_from_root(root);
+	if (context && context_present(context+devfn))
+		did = context_domain_id(context+devfn);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return did;
+}
+#endif /* CONFIG_CRASH_DUMP */
+
 /*
  * find_domain
  * Note: we use struct device->archdata.iommu stores the info
@@ -2375,6 +2396,9 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	unsigned long flags;
 	u8 bus, devfn;
 	int did = -1;   /* Default to "no domain_id supplied" */
+#ifdef CONFIG_CRASH_DUMP
+	struct domain_values_entry *dve = NULL;
+#endif /* CONFIG_CRASH_DUMP */
 
 	domain = find_domain(dev);
 	if (domain)
@@ -2408,6 +2432,24 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(0);
 	if (!domain)
 		return NULL;
+
+#ifdef CONFIG_CRASH_DUMP
+	if (intel_iommu_in_crashdump) {
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
@@ -2419,6 +2461,18 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 		return NULL;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (intel_iommu_in_crashdump && dve) {
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
@@ -2860,6 +2914,10 @@ static int __init init_dmars(void)
 	struct device *dev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2903,16 +2961,40 @@ static int __init init_dmars(void)
 		if (ret)
 			goto free_iommu;
 
-		/*
-		 * TBD:
-		 * we could share the same root & context tables
-		 * among all IOMMU's. Need to Split it later.
-		 */
-		ret = iommu_alloc_root_entry(iommu);
-		if (ret) {
-			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
-			goto free_iommu;
+#ifdef CONFIG_CRASH_DUMP
+		if (intel_iommu_in_crashdump) {
+			pr_info("IOMMU Copying translate tables from panicked kernel\n");
+			ret = intel_iommu_copy_translation_tables(drhd,
+					&root_old_phys, &root_new_virt,
+					g_num_of_iommus);
+			if (ret) {
+				pr_err("IOMMU: Copy translate tables failed\n");
+
+				/* Best to stop trying */
+				intel_iommu_in_crashdump = false;
+				goto error;
+			}
+			iommu->root_entry = root_new_virt;
+			pr_info("IOMMU: root_new_virt:0x%12.12llx phys:0x%12.12llx\n",
+				(u64)root_new_virt,
+				virt_to_phys(root_new_virt));
+			intel_iommu_get_dids_from_old_kernel(iommu);
+		} else {
+#endif /* CONFIG_CRASH_DUMP */
+			/*
+			 * TBD:
+			 * we could share the same root & context tables
+			 * among all IOMMU's. Need to Split it later.
+			 */
+			ret = iommu_alloc_root_entry(iommu);
+			if (ret) {
+				pr_err("IOMMU: allocate root entry failed\n");
+				goto free_iommu;
+			}
+#ifdef CONFIG_CRASH_DUMP
 		}
+#endif /* CONFIG_CRASH_DUMP */
+
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
@@ -2971,6 +3053,16 @@ static int __init init_dmars(void)
 
 	check_tylersburg_isoch();
 
+#ifdef CONFIG_CRASH_DUMP
+	/*
+	 * In the crashdump kernel: Skip setting-up new domains for
+	 * si, rmrr, and the isa bus on the expectation that these
+	 * translations were copied from the old kernel.
+	 */
+	if (intel_iommu_in_crashdump)
+		goto skip_new_domains_for_si_rmrr_isa;
+#endif /* CONFIG_CRASH_DUMP */
+
 	/*
 	 * If pass through is not set or not enabled, setup context entries for
 	 * identity mappings for rmrr, gfx, and isa and may fall back to static
@@ -3011,6 +3103,10 @@ static int __init init_dmars(void)
 
 	iommu_prepare_isa();
 
+#ifdef CONFIG_CRASH_DUMP
+skip_new_domains_for_si_rmrr_isa:;
+#endif /* CONFIG_CRASH_DUMP */
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -4185,12 +4281,24 @@ int __init intel_iommu_init(void)
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
+		intel_iommu_in_crashdump = true;
+		pr_info("IOMMU intel_iommu_in_crashdump = true\n");
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

