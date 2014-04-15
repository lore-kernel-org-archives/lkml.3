Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaDOXLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:11:40 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:50009 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaDOXJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:34 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 8/8] Add remaining changes to intel-iommu.c to fix crashdump
Date: Tue, 15 Apr 2014 17:09:09 -0600
Message-Id: <1397603349-30930-9-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add "#include <linux/crash_dump.h>"
 Chg device_to_domain_id
 Chg get_domain_for_dev
 Chg init_dmars
 Chg intel_iommu_init


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 210 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 158 insertions(+), 52 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0c00c2d..a8d8489 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -49,7 +49,9 @@
 #include "irq_remapping.h"
 #include "pci.h"
 #include "intel-iommu-private.h"
+#include <linux/crash_dump.h>
 
+static int intel_iommu_in_crashdump;
 
 static void __init check_tylersburg_isoch(void);
 
@@ -1605,6 +1607,24 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
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
+		did = context_get_did(context+devfn);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return did;
+}
+#endif /* CONFIG_CRASH_DUMP */
+
 /*
  * find_domain
  * Note: we use struct pci_dev->dev.archdata.iommu stores the info
@@ -1634,6 +1654,9 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	int segment;
 	int ret;
 	int did = -1;   /* Default to "no domain_id supplied" */
+#ifdef CONFIG_CRASH_DUMP
+	struct domain_values_entry *dve = NULL;
+#endif /* CONFIG_CRASH_DUMP */
 
 	domain = find_domain(pdev);
 	if (domain)
@@ -1680,6 +1703,24 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 	iommu = drhd->iommu;
 
+#ifdef CONFIG_CRASH_DUMP
+	if (intel_iommu_in_crashdump) {
+		/*
+		 * if this device had a did in the old kernel
+		 * use its values instead of generating new ones
+		 */
+		did = device_to_domain_id(iommu, pdev->bus->number,
+						pdev->devfn);
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
 	ret = iommu_attach_domain(domain, iommu, did);
 	if (ret) {
 		free_domain_mem(domain);
@@ -1691,6 +1732,18 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		goto error;
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
 	/* register pcie-to-pci device */
 	if (dev_tmp) {
 		info = alloc_devinfo_mem();
@@ -2109,6 +2162,10 @@ static int __init init_dmars(void)
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2152,16 +2209,40 @@ static int __init init_dmars(void)
 		if (ret)
 			goto error;
 
-		/*
-		 * TBD:
-		 * we could share the same root & context tables
-		 * among all IOMMU's. Need to Split it later.
-		 */
-		ret = iommu_alloc_root_entry(iommu);
-		if (ret) {
-			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
-			goto error;
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
+				printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+				goto error;
+			}
+#ifdef CONFIG_CRASH_DUMP
 		}
+#endif /* CONFIG_CRASH_DUMP */
+
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
@@ -2220,50 +2301,63 @@ static int __init init_dmars(void)
 
 	check_tylersburg_isoch();
 
+#ifdef CONFIG_CRASH_DUMP
 	/*
-	 * If pass through is not set or not enabled, setup context entries for
-	 * identity mappings for rmrr, gfx, and isa and may fall back to static
-	 * identity mapping if iommu_identity_mapping is set.
+	 * In the crashdump kernel: Skip setting-up new domains for
+	 * si, rmrr, and the isa bus on the expectation that these
+	 * translations were copied from the old kernel.
 	 */
-	if (iommu_identity_mapping) {
-		ret = iommu_prepare_static_identity_mapping(hw_pass_through);
-		if (ret) {
-			printk(KERN_CRIT "Failed to setup IOMMU pass-through\n");
-			goto error;
+	if (!intel_iommu_in_crashdump) {
+#endif /* CONFIG_CRASH_DUMP */
+		/*
+		 * If pass through is not set or not enabled, setup context
+		 * entries for identity mappings for rmrr, gfx, and isa and
+		 * may fall back to static identity mapping if
+		 * iommu_identity_mapping is set.
+		 */
+		if (iommu_identity_mapping) {
+			ret = iommu_prepare_static_identity_mapping(
+							hw_pass_through);
+			if (ret) {
+				printk(KERN_CRIT "Failed to setup IOMMU pass-through\n");
+				goto error;
+			}
 		}
-	}
-	/*
-	 * For each rmrr
-	 *   for each dev attached to rmrr
-	 *   do
-	 *     locate drhd for dev, alloc domain for dev
-	 *     allocate free domain
-	 *     allocate page table entries for rmrr
-	 *     if context not allocated for bus
-	 *           allocate and init context
-	 *           set present in root table for this bus
-	 *     init context with domain, translation etc
-	 *    endfor
-	 * endfor
-	 */
-	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
-	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
-			pdev = rmrr->devices[i];
-			/*
-			 * some BIOS lists non-exist devices in DMAR
-			 * table.
-			 */
-			if (!pdev)
-				continue;
-			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
-			if (ret)
-				printk(KERN_ERR
-				       "IOMMU: mapping reserved region failed\n");
+		/*
+		 * For each rmrr
+		 *   for each dev attached to rmrr
+		 *   do
+		 *     locate drhd for dev, alloc domain for dev
+		 *     allocate free domain
+		 *     allocate page table entries for rmrr
+		 *     if context not allocated for bus
+		 *           allocate and init context
+		 *           set present in root table for this bus
+		 *     init context with domain, translation etc
+		 *    endfor
+		 * endfor
+		 */
+		printk(KERN_INFO "IOMMU: Setting RMRR:\n");
+		for_each_rmrr_units(rmrr) {
+			for (i = 0; i < rmrr->devices_cnt; i++) {
+				pdev = rmrr->devices[i];
+				/*
+				 * some BIOS lists non-exist devices in DMAR
+				 * table.
+				 */
+				if (!pdev)
+					continue;
+				ret = iommu_prepare_rmrr_dev(rmrr, pdev);
+				if (ret)
+					printk(KERN_ERR
+					       "IOMMU: mapping reserved region failed\n");
+			}
 		}
-	}
 
-	iommu_prepare_isa();
+		iommu_prepare_isa();
+#ifdef CONFIG_CRASH_DUMP
+	}
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -3325,12 +3419,24 @@ int __init intel_iommu_init(void)
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
Bill Sumner <bill.sumner@hp.com>

