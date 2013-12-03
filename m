Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3LCTns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:43:48 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:38371 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3LCTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:42:47 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com
Subject: [PATCH 6/6] Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
Date: Tue,  3 Dec 2013 12:41:34 -0700
Message-Id: <1386099694-4190-7-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
References: <Crashdump-Accepting-Active-IOMMU>
 <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 272 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 204 insertions(+), 68 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 19c1370..71083d1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -21,6 +21,8 @@
  * Author: Fenghua Yu <fenghua.yu@intel.com>
  */
 
+#define DEBUG 1	/* TEMPORARY */
+
 #include <linux/init.h>
 #include <linux/bitmap.h>
 #include <linux/debugfs.h>
@@ -1353,6 +1355,12 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 */
 	if (cap_caching_mode(iommu->cap))
 		set_bit(0, iommu->domain_ids);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (crashdump_accepting_active_iommu)
+		intel_iommu_get_dids_from_old_kernel(iommu);
+#endif /* CONFIG_CRASH_DUMP */
+
 	return 0;
 }
 
@@ -1426,7 +1434,8 @@ static struct dmar_domain *alloc_domain(void)
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long ndomains;
@@ -1436,12 +1445,15 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
-	num = find_first_zero_bit(iommu->domain_ids, ndomains);
-	if (num >= ndomains) {
-		spin_unlock_irqrestore(&iommu->lock, flags);
-		printk(KERN_ERR "IOMMU: no free domain ids\n");
-		return -ENOMEM;
-	}
+	if (domain_number < 0) {
+		num = find_first_zero_bit(iommu->domain_ids, ndomains);
+		if (num >= ndomains) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			printk(KERN_ERR "IOMMU: no free domain ids\n");
+			return -ENOMEM;
+		}
+	} else
+		num = domain_number;
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
@@ -2052,8 +2064,17 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	int bus = 0, devfn = 0;
 	int segment;
 	int ret;
+	int did = -1;	/* Default to "no domain_id supplied" */
 
 	domain = find_domain(pdev);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (domain)
+		if (pr_dbg.in_crashdump && crashdump_accepting_active_iommu)
+			pr_debug("IOMMU: Found domain (%d) for device %s\n",
+				domain->id, pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (domain)
 		return domain;
 
@@ -2084,6 +2105,12 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		}
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_accepting_active_iommu)
+		pr_debug("IOMMU: Allocating new domain for device %s\n",
+			pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	domain = alloc_domain();
 	if (!domain)
 		goto error;
@@ -2098,7 +2125,26 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 	iommu = drhd->iommu;
 
-	ret = iommu_attach_domain(domain, iommu);
+#ifdef CONFIG_CRASH_DUMP
+	/* See if this device had a did & gaw in the old kernel */
+	if (crashdump_accepting_active_iommu) {
+		did = domain_get_did_from_old_kernel(iommu, pdev);
+		if (did > 0 || (did == 0 && !cap_caching_mode(iommu->cap))) {
+			ret = domain_get_gaw_from_old_kernel(iommu, pdev);
+			if (ret > 0)
+				gaw = ret;
+			else
+				did = -1;
+		} else
+			did = -1;
+	}
+
+	if (pr_dbg.in_crashdump && crashdump_accepting_active_iommu)
+		pr_debug("IOMMU: new domain for device %s: gaw(%d) did(%d)\n",
+			pci_name(pdev), gaw, did);
+#endif /* CONFIG_CRASH_DUMP */
+
+	ret = iommu_attach_domain(domain, iommu, did);
 	if (ret) {
 		free_domain_mem(domain);
 		goto error;
@@ -2109,6 +2155,23 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		goto error;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (crashdump_accepting_active_iommu && did >= 0) {
+		u64 temp_pgd;	/* Top page-translation-table */
+
+		domain_get_ranges_from_old_kernel(domain, iommu, pdev);
+
+		temp_pgd = domain_get_pgd_from_old_kernel(iommu, pdev);
+		if (temp_pgd) {
+			if (domain->pgd)
+				free_pgtable_page(domain->pgd);
+			domain->pgd = (struct dma_pte *)temp_pgd;
+		}
+		pr_debug("IOMMU: New Domain for device %s Did:%d Pgd: 0x%12.12llx\n",
+			pci_name(pdev), did, temp_pgd);
+	}
+#endif /* CONFIG_CRASH_DUMP */
+
 	/* register pcie-to-pci device */
 	if (dev_tmp) {
 		info = alloc_devinfo_mem();
@@ -2319,7 +2382,7 @@ static int __init si_domain_init(int hw)
 	pr_debug("Identity mapping domain is domain %d\n", si_domain->id);
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, (int) -1);
 		if (ret) {
 			domain_exit(si_domain);
 			return -EFAULT;
@@ -2527,6 +2590,10 @@ static int __init init_dmars(void)
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2574,16 +2641,41 @@ static int __init init_dmars(void)
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
+		if (crashdump_accepting_active_iommu) {
+			print_intel_iommu_registers(drhd);
+
+			pr_debug("Calling copy_intel_iommu_translation_tables\n");
+			pr_debug("(lists tables in OLD KERNEL during copy)\n");
+			ret = copy_intel_iommu_translation_tables(drhd,
+					&root_old_phys, &root_new_virt);
+			if (ret) {
+				pr_err("IOMMU: Copy translate tables failed\n");
+
+				/* Best to stop trying */
+				crashdump_accepting_active_iommu = false;
+				goto error;
+			}
+			iommu->root_entry = root_new_virt;
+			pr_debug("IOMMU: root_new_virt:0x%12.12llx phys:0x%12.12llx\n",
+				(u64)root_new_virt,
+				virt_to_phys(root_new_virt));
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
@@ -2652,50 +2744,69 @@ static int __init init_dmars(void)
 
 	check_tylersburg_isoch();
 
-	/*
-	 * If pass through is not set or not enabled, setup context entries for
-	 * identity mappings for rmrr, gfx, and isa and may fall back to static
-	 * identity mapping if iommu_identity_mapping is set.
-	 */
-	if (iommu_identity_mapping) {
-		ret = iommu_prepare_static_identity_mapping(hw_pass_through);
-		if (ret) {
-			printk(KERN_CRIT "Failed to setup IOMMU pass-through\n");
-			goto error;
+#ifdef CONFIG_CRASH_DUMP
+	if (!crashdump_accepting_active_iommu) {
+		/* Skip setting-up new domains for si, rmrr, and the isa bus
+		 * on the expectation that these translations
+		 * were copied from the old kernel.
+		 *
+		 * NOTE: Indented the existing code below because it is now
+		 * conditional upon the 'if' statement above.
+		 * This pushed many of the lines over 80 characters.
+		 * Chose to leave them and live with the 'checkpatch' warnings
+		 * about "over 80 characters".
+		 */
+#endif /* CONFIG_CRASH_DUMP */
+		/*
+		 * If pass through is not set or not enabled, setup context entries for
+		 * identity mappings for rmrr, gfx, and isa and may fall back to static
+		 * identity mapping if iommu_identity_mapping is set.
+		 */
+		if (iommu_identity_mapping) {
+			ret = iommu_prepare_static_identity_mapping(hw_pass_through);
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
+	} else {
+		intel_iommu_translation_tables_are_mapped = true;
+		pr_debug("intel_iommu_translation_tables_are_mapped = true\n");
+	}
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2889,6 +3000,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	BUG_ON(dir == DMA_NONE);
 
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_accepting_active_iommu)
+		pr_debug("ENTER %s paddr(0x%12.12llx) size(0x%12.12lx)\n",
+			 __func__, paddr, size);
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (iommu_no_mapping(hwdev))
 		return paddr;
 
@@ -2931,6 +3048,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	start_paddr = (phys_addr_t)iova->pfn_lo << PAGE_SHIFT;
 	start_paddr += paddr & ~PAGE_MASK;
+
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_accepting_active_iommu)
+		pr_debug("LEAVE %s dma_addr_t(0x%16.16llx)\n",
+			 __func__, start_paddr);
+#endif /* CONFIG_CRASH_DUMP */
 	return start_paddr;
 
 error:
@@ -3750,19 +3873,32 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
 	/*
-	 * Disable translation if already enabled prior to OS handover.
+	 * If (This is the crash kernel)
+	 *    Set: copy iommu translate tables from old kernel
+	 *    Skip disabling the iommu hardware translations
 	 */
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu;
+	if (is_kdump_kernel()) {
+		crashdump_accepting_active_iommu = true;
+		pr_info("IOMMU crashdump_accepting_active_iommu = true\n");
+		pr_info("IOMMU Skip disabling iommu hardware translations\n");
+	} else
+#endif /* CONFIG_CRASH_DUMP */
+		/*
+		 * Disable translation if already enabled prior to OS handover.
+		 */
+		for_each_drhd_unit(drhd) {
+			struct intel_iommu *iommu;
 
-		if (drhd->ignored)
-			continue;
+			if (drhd->ignored)
+				continue;
+
+			iommu = drhd->iommu;
+			if (iommu->gcmd & DMA_GCMD_TE)
+				iommu_disable_translation(iommu);
+		}
 
-		iommu = drhd->iommu;
-		if (iommu->gcmd & DMA_GCMD_TE)
-			iommu_disable_translation(iommu);
-	}
 
 	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
-- 
Bill Sumner <bill.sumner@hp.com>

