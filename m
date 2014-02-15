Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBODF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 22:05:28 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38660 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaBODFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 22:05:03 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH] Fix dump failure caused by DMA through an IOMMU
Date: Fri, 14 Feb 2014 20:04:27 -0700
Message-Id: <1392433467-62357-2-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1392433467-62357-1-git-send-email-bill.sumner@hp.com>
References: <1392433467-62357-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed from "Crashdump Accepting Active IOMMU" to better communicate
the purpose of this patch.

This patch implements a fix for:
A kdump problem about DMA that has been discussed for a long time. That is,
when a kernel panics and boots into the kdump kernel, DMA started by the 
panicked kernel is not stopped before the kdump kernel is booted and the 
kdump kernel disables the IOMMU while this DMA continues.  This causes the
IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them 
as physical memory addresses -- which causes the DMA to either:
(1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer  
data to or from incorrect areas of memory. Often this causes the dump to fail.

This patch modifies the behavior of the Intel iommu in the crashdump kernel:
1. to skip disabling the IOMMU translation of IO Virtual Addresses (IOVA),
2. to leave the current translations in-place so that legacy DMA will continue
   using its current buffers until the device drivers in the crashdump kernel
   initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers
   in the crashdump kernel than the iova ranges that were in-use at the time
   of the panic.  

Advantages of this approach:
1. All manipulation of the IO-device is done by the Linux device-driver
   for that device.
2. This approach behaves in a manner very similar to operation without an
   active iommu.
3. Any activity between the IO-device and its RMRR areas is handled by the
   device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
   This supports the practice of creating a special kdump kernel without
   drivers for any devices that are not required for taking a crashdump. 

High-level overview:
During a crashdump, this code operates primarily during iommu initialization
and device-driver initialization -- in essentially the following order:

During intel-iommu hardware initialization:
In intel_iommu_init(void)
* If (This is the crash kernel)
  .  Set flag: crashdump_with_iommu (all changes below check this)
  .  Skip disabling the iommu hardware translations

In init_dmars()
* Duplicate the intel iommu translation tables from the old kernel
  into the new kernel
  . The root-entry table, all context-entry tables,
    and all page-translation-entry tables
  . The duplicate tables contain updated physical addresses to link them together.
  . The duplicate tables are mapped into kernel virtual addresses
    in the new kernel which allows most of the existing iommu code
    to operate without change.
  . Do some minimal sanity-checks during the copy
  . Place the address of the new root-entry structure into "struct intel_iommu"

* Skip setting-up new domains for 'si', 'rmrr', 'isa' 
  . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
  . This patch has not yet been tested with iommu pass-through enabled

* Existing (unchanged) code near the end of dmar_init:
  . Loads the address of the duplicated root-entry structure from
    "struct intel_iommu" into the iommu hardware and does the hardware flushes.
    This changes the active translation tables from the ones in the old kernel
    to the copies in the new kernel.
  . This is legal because the translations in the two sets of tables are
    currently identical:
      Virtualization Technology for Directed I/O. Architecture Specification,
      February 2011, Rev. 1.3  (section 11.2, paragraph 2) 

In iommu_init_domains()
* Mark as in-use all domain-id's from the old kernel
  . In case the new kernel contains a device that was not in the old kernel
    and a new, unused domain-id is actually needed, the bitmap will give us one.

During Device Driver Initialization:
When a new domain is created for a device:
* If (this device has a context in the old kernel)
  . Get domain-id, address-width, and IOVA ranges from the old kernel context;
  . Get address(page-entry-tables) from the copy in the new kernel;
  . And apply all of the above values to the new domain structure.
* Else
  . Create a new domain as normal


Changes from: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
1. Rearranged the patch cover-letter to provide a clearer and shorter
   explanation of the problem, how the problem is being solved, and
   the advantages of this approach.
2. Combined the multiple patches of the previous patch-set into this
   single patch.
3. Deleted two purely diagnostic print functions that were unnecessary 
   to the primary purpose of this fix.  These could be submitted later
   as separate, independent patches.
4. Changed the patch subject to more accurately reflect its purpose.
5. Made a few changes to better match the style of the mainline code.
6. Added comments at the front of several of the new functions.  
7. Re-edited this patch log 


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 1233 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 1172 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a22c86c..69b48e9 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -21,6 +21,8 @@
  * Author: Fenghua Yu <fenghua.yu@intel.com>
  */
 
+/* #define DEBUG 1 */	/* Enable/Disable debug print in this source file */
+
 #include <linux/init.h>
 #include <linux/bitmap.h>
 #include <linux/debugfs.h>
@@ -48,6 +50,7 @@
 
 #include "irq_remapping.h"
 #include "pci.h"
+#include <linux/crash_dump.h>
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -165,6 +168,78 @@ static inline unsigned long virt_to_dma_pfn(void *p)
 	return page_to_dma_pfn(virt_to_page(p));
 }
 
+#ifdef CONFIG_CRASH_DUMP
+/*
+ * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
+ *
+ * Fixes the crashdump kernel to deal with an active iommu and legacy
+ * DMA from the (old) panicked kernel in a manner similar to how legacy
+ * DMA is handled when no hardware iommu was in use by the old kernel --
+ * allow the legacy DMA to continue into its current buffers.
+ *
+ * In the crashdump kernel, this code:
+ * 1. skips disabling the IOMMU's translating of IO Virtual Addresses (IOVA)
+ * 2. leaves the current translations in-place so that legacy DMA will
+ *    continue to use its current buffers,
+ * 3. allocates to the device drivers in the crashdump kernel
+ *    portions of the iova address ranges that are different
+ *    from the iova address ranges that were being used by the old kernel
+ *    at the time of the panic.
+ *
+ */
+
+static int crashdump_with_iommu;	/* activate this feature */
+static int iova_translation_tables_are_mapped;	/* table copy done */
+
+static struct {				/* run-time pr_debug() flags */
+	unsigned in_crashdump:1;	/* if crashdump_with_iommu */
+	unsigned domain_get:1;		/* pr_debug in domain_get* functions */
+	unsigned copy_page_table:1;	/* enter/leave copy_page_table() */
+	unsigned copy_page_addr:1;	/* enter/leave copy_page_addr() */
+	unsigned addr_ranges:1;		/* accumulated addr ranges */
+	unsigned reserved_ranges:1;	/* accumulated addr ranges reserved */
+	unsigned page_addr:1;		/* adr(each page table) */
+	unsigned enter_oldcopy:1;	/* enter oldcopy() parameters */
+	unsigned leave_oldcopy:1;	/* leave oldcopy() parameters */
+} pr_dbg  = {				/* Enable flags below here */
+	.in_crashdump = 1,
+	.domain_get = 1,
+	.copy_page_table = 1,
+	.copy_page_addr = 0,
+	.addr_ranges = 0,
+	.reserved_ranges = 0,
+	.page_addr = 0,
+	.enter_oldcopy = 0,
+	.leave_oldcopy = 0,
+};
+
+
+/*
+ * Prototypes of interface functions for:
+ * Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
+ */
+
+static int
+copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
+	struct root_entry **root_old_p, struct root_entry **root_new_p);
+
+static int
+domain_get_did_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static int
+domain_get_gaw_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static u64
+domain_get_pgd_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static void
+domain_get_ranges_from_old_kernel(struct dmar_domain *domain,
+		  struct intel_iommu *iommu, struct pci_dev *pdev);
+static int
+intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+#endif	/* CONFIG_CRASH_DUMP */
+
+
 /* global iommu list, set NULL for ignored DMAR units */
 static struct intel_iommu **g_iommus;
 
@@ -1258,6 +1333,12 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 */
 	if (cap_caching_mode(iommu->cap))
 		set_bit(0, iommu->domain_ids);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (crashdump_with_iommu)
+		intel_iommu_get_dids_from_old_kernel(iommu);
+#endif /* CONFIG_CRASH_DUMP */
+
 	return 0;
 }
 
@@ -1327,7 +1408,8 @@ static struct dmar_domain *alloc_domain(void)
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long ndomains;
@@ -1337,12 +1419,15 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
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
@@ -1953,8 +2038,17 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	int bus = 0, devfn = 0;
 	int segment;
 	int ret;
+	int did = -1;	/* Default to "no domain_id supplied" */
 
 	domain = find_domain(pdev);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (domain)
+		if (pr_dbg.in_crashdump && crashdump_with_iommu)
+			pr_debug("IOMMU: Found domain (%d) for device %s\n",
+				domain->id, pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (domain)
 		return domain;
 
@@ -1985,6 +2079,12 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		}
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_with_iommu)
+		pr_debug("IOMMU: Allocating new domain for device %s\n",
+			pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	domain = alloc_domain();
 	if (!domain)
 		goto error;
@@ -1999,7 +2099,29 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 	iommu = drhd->iommu;
 
-	ret = iommu_attach_domain(domain, iommu);
+#ifdef CONFIG_CRASH_DUMP
+	if (crashdump_with_iommu) {
+		/*
+		 * if this device had a did & gaw in the old kernel
+		 * use them instead of generating new ones
+		 */
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
+	if (pr_dbg.in_crashdump && crashdump_with_iommu)
+		pr_debug("IOMMU: new domain for device %s: gaw(%d) did(%d)\n",
+			pci_name(pdev), gaw, did);
+#endif /* CONFIG_CRASH_DUMP */
+
+	ret = iommu_attach_domain(domain, iommu, did);
 	if (ret) {
 		free_domain_mem(domain);
 		goto error;
@@ -2010,6 +2132,23 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		goto error;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
+	if (crashdump_with_iommu && did >= 0) {
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
@@ -2218,7 +2357,7 @@ static int __init si_domain_init(int hw)
 		return -EFAULT;
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, (int) -1);
 		if (ret) {
 			domain_exit(si_domain);
 			return -EFAULT;
@@ -2428,6 +2567,10 @@ static int __init init_dmars(void)
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2471,16 +2614,39 @@ static int __init init_dmars(void)
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
+		if (crashdump_with_iommu) {
+			pr_debug("Calling copy_intel_iommu_translation_tables\n");
+			pr_debug("(lists tables in OLD KERNEL during copy)\n");
+			ret = copy_intel_iommu_translation_tables(drhd,
+					&root_old_phys, &root_new_virt);
+			if (ret) {
+				pr_err("IOMMU: Copy translate tables failed\n");
+
+				/* Best to stop trying */
+				crashdump_with_iommu = false;
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
@@ -2539,50 +2705,64 @@ static int __init init_dmars(void)
 
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
+	if (!crashdump_with_iommu) {
+#endif /* CONFIG_CRASH_DUMP */
+		/*
+		 * If pass through is not set or not enabled, setup context
+		 * entries for identity mappings for rmrr, gfx, and isa and
+		 * may fall back to static identity mapping if
+		 * iommu_identity_mapping is set.
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
+					printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
+			}
 		}
-	}
 
-	iommu_prepare_isa();
+		iommu_prepare_isa();
+#ifdef CONFIG_CRASH_DUMP
+	} else {
+		iova_translation_tables_are_mapped = true;
+		pr_debug("iova_translation_tables_are_mapped = true\n");
+	}
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2772,6 +2952,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	BUG_ON(dir == DMA_NONE);
 
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_with_iommu)
+		pr_debug("ENTER %s paddr(0x%12.12llx) size(0x%12.12lx)\n",
+			 __func__, paddr, size);
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (iommu_no_mapping(hwdev))
 		return paddr;
 
@@ -2814,6 +3000,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	start_paddr = (phys_addr_t)iova->pfn_lo << PAGE_SHIFT;
 	start_paddr += paddr & ~PAGE_MASK;
+
+#ifdef CONFIG_CRASH_DUMP
+	if (pr_dbg.in_crashdump && crashdump_with_iommu)
+		pr_debug("LEAVE %s dma_addr_t(0x%16.16llx)\n",
+			 __func__, start_paddr);
+#endif /* CONFIG_CRASH_DUMP */
 	return start_paddr;
 
 error:
@@ -3644,12 +3836,24 @@ int __init intel_iommu_init(void)
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
+		crashdump_with_iommu = true;
+		pr_info("IOMMU crashdump_with_iommu = true\n");
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
@@ -4340,3 +4544,910 @@ static void __init check_tylersburg_isoch(void)
 	printk(KERN_WARNING "DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
 	       vtisochctrl);
 }
+
+#ifdef CONFIG_CRASH_DUMP
+/* ------------------------------------------------------------------------
+ * Utility functions for accessing the iommu Translation Tables
+ * ------------------------------------------------------------------------
+ */
+
+static inline struct context_entry *
+get_context_phys_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root) ? (void *) (root->val & VTD_PAGE_MASK)
+				    : NULL);
+}
+
+static int
+context_get_p(struct context_entry *c)    {return((c->lo >> 0) & 0x1); }
+
+static int
+context_get_fpdi(struct context_entry *c) {return((c->lo >> 1) & 0x1); }
+
+static int
+context_get_t(struct context_entry *c)    {return((c->lo >> 2) & 0x3); }
+
+static u64
+context_get_asr(struct context_entry *c)  {return((c->lo >> 12));      }
+
+static int
+context_get_aw(struct context_entry *c)   {return((c->hi >> 0) & 0x7); }
+
+static int
+context_get_aval(struct context_entry *c) {return((c->hi >> 3) & 0xf); }
+
+static int
+context_get_did(struct context_entry *c)  {return((c->hi >> 8) & 0xffff); }
+
+static void context_put_asr(struct context_entry *c, unsigned long asr)
+{
+	c->lo &= (~VTD_PAGE_MASK);
+	c->lo |= (asr << VTD_PAGE_SHIFT);
+}
+
+
+/*
+ * Copy memory from a physically-addressed area into a virtually-addressed area
+ */
+static int oldcopy(void *to, void *from, int size)
+{
+	size_t ret = 0;			/* Length copied */
+	unsigned long pfn;		/* Page Frame Number */
+	char *buf = to;			/* Adr(Output buffer) */
+	size_t csize = (size_t)size;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of from */
+	int userbuf = 0;		/* to is in kernel space */
+
+	if (pr_dbg.enter_oldcopy)
+		pr_debug("ENTER %s to=%16.16llx, from = %16.16llx, size = %d\n",
+			__func__,
+			(unsigned long long) to,
+			(unsigned long long) from, size);
+
+	if (iova_translation_tables_are_mapped)
+		memcpy(to, phys_to_virt((phys_addr_t)from), csize);
+	else {
+		pfn = ((unsigned long) from) >> VTD_PAGE_SHIFT;
+		offset = ((unsigned long) from) & (~VTD_PAGE_MASK);
+		ret = copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+	}
+
+	if (pr_dbg.leave_oldcopy)
+		pr_debug("LEAVE %s ret=%d\n", __func__, (int) ret);
+
+	return (int) ret;
+}
+
+
+
+/* ------------------------------------------------------------------------
+ * Interfaces for when a new domain in the crashdump kernel needs some
+ * values from the panicked kernel's context entries
+ * ------------------------------------------------------------------------
+ */
+
+/* List to hold domain values found during the copy operation */
+static struct list_head *device_domain_values_list;
+
+
+/*
+ * Utility function for interface functions that follow.
+ */
+static int
+context_get_entry(struct context_entry *context_addr,
+			struct intel_iommu *iommu, u32 bus, int devfn)
+{
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys adr (root table entry) */
+	struct root_entry  root_temp;	/* Local copy of root_entry */
+	struct context_entry *context_phys;	/* Phys adr */
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x &context_entry:0x%llx &intel_iommu:0x%llx\n",
+			__func__, bus, devfn>>3, devfn&7,
+			(u64)context_addr, (u64)iommu);
+
+	if (bus > 255)				/* Sanity check */
+		return -5;
+	if (devfn > 255 || devfn < 0)		/* Sanity check */
+		return -6;
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return -1;
+
+	root_phys = (struct root_entry *) q;	/* Adr(base of vector) */
+	root_phys += bus;			/* Adr(entry we want) */
+
+	oldcopy(&root_temp, root_phys, sizeof(root_temp));
+
+	pr_debug("root_temp.val:0x%llx .rsvd1:0x%llx root_phys:0x%llx\n",
+		root_temp.val, root_temp.rsvd1, (u64)root_phys);
+
+	if (!root_present(&root_temp))
+		return -2;
+
+	pr_debug("B:D:F=%2.2x:%2.2x:%1.1x root_temp.val: %llx .rsvd1: %llx\n",
+		bus, devfn >> 3, devfn & 7, root_temp.val, root_temp.rsvd1);
+
+	if (root_temp.rsvd1)			/* If (root_entry is bad) */
+		return -3;
+
+	context_phys = get_context_phys_from_root(&root_temp);
+	if (!context_phys)
+		return -4;
+
+	context_phys += devfn;			/* Adr(context_entry we want) */
+
+
+	oldcopy(context_addr, context_phys, sizeof(*context_addr));
+
+	if (pr_dbg.domain_get)
+		pr_debug("LEAVE %s returning: phys:0x%12.12llx hi:0x%16.16llx lo:0x%16.16llx\n",
+			__func__, (u64) context_phys,
+			context_addr->hi, context_addr->lo);
+	return 0;
+}
+
+
+/*
+ * Get address_width of iova for a device from old kernel (if device existed)
+ */
+static int
+domain_get_gaw_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return ret;
+
+	return (int) agaw_to_width(context_get_aw(&context_temp));
+}
+
+
+/*
+ * Get domain_id for a device from old kernel (if device existed)
+ */
+static int
+domain_get_did_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return ret;
+
+	return (int) context_get_did(&context_temp);
+}
+
+
+/*
+ * Get adr(top page_table) for a device from old kernel (if device exists)
+ */
+static u64
+domain_get_pgd_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int ret;
+	struct context_entry context_temp;
+	u64 phys;
+	u64 virt;
+
+	if (pr_dbg.domain_get)
+		pr_debug("ENTER %s B:D:F=%2.2x:%2.2x:%1.1x iommu:%d\n",
+			__func__, pdev->bus->number,
+			pdev->devfn >> 3, pdev->devfn & 7,
+			iommu->seq_id);
+
+	ret = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (ret < 0)
+		return 0;
+	if (!context_get_p(&context_temp))
+		return 0;
+
+	phys = context_get_asr(&context_temp) << VTD_PAGE_SHIFT;
+	if (pr_dbg.domain_get)
+		pr_debug("%s, phys: 0x%16.16llx\n", __func__, (u64) phys);
+
+	if (!phys)
+		return 0;
+
+	virt = (u64) phys_to_virt(phys);
+	if (pr_dbg.domain_get)
+		pr_debug("%s, virt: 0x%16.16llx\n", __func__, (u64) virt);
+
+	return virt;
+}
+
+
+/* Mark IOVAs that are in-use at time of panic by a device of the old kernel.
+ * Mark IOVAs in the domain for that device in the new kernel
+ * so that all new requests from the device driver for an IOVA will avoid
+ * re-using any IOVA that was in-use by the old kernel.
+ */
+static void
+domain_get_ranges_from_old_kernel(struct dmar_domain *domain,
+				  struct intel_iommu *iommu,
+				  struct pci_dev *pdev)
+{
+	u32 bus = pdev->bus->number;
+	int devfn = pdev->devfn;
+	struct device_domain_info *i = NULL;    /* iterator for foreach */
+
+	pr_debug("ENTER %s, iommu=%d, B:D:F=%2.2x:%2.2x:%1.1x\n",
+			__func__, iommu->seq_id,
+			bus, devfn >> 3, devfn & 0x3);
+
+	list_for_each_entry(i, &device_domain_values_list[iommu->seq_id],
+				global) {
+		if (i->bus == bus && i->devfn == devfn) {
+			if (i->domain == NULL) {
+				pr_err("ERROR %s, iommu=%d, B:D:F=%2.2x:%2.2x:%1.1x\n",
+					__func__, iommu->seq_id,
+					bus, devfn >> 3, devfn & 0x3);
+
+				pr_err("FOUND B:D:F=%2.2x:%2.2x:%1.1x INFO domain-pointer is NULL\n",
+					bus, devfn >> 3, devfn & 0x3);
+				break;
+			}
+			pr_debug("FOUND B:D:F=%2.2x:%2.2x:%1.1x did:%4.4x\n",
+				bus, devfn >> 3, devfn & 0x3, i->domain->id);
+
+			copy_reserved_iova(&i->domain->iovad, &domain->iovad);
+			break;
+		}
+	}
+
+	pr_debug("LEAVE %s\n", __func__);
+}
+
+
+/* Mark domain-id's from old kernel as in-use on this iommu so that a new
+ * domain-id is allocated in the case where there is a device in the new kernel
+ * that was not in the old kernel -- and therefore a new domain-id is needed.
+ */
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu)
+{
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys(in old kernel) */
+	struct root_entry *root_temp;	/* Virt(Local copy) */
+	struct root_entry *re;		/* Loop index */
+	struct context_entry *context_phys;	/* Phys(in old kernel) */
+	struct context_entry *context_temp;	/* Virt(Local copy) */
+	struct context_entry *ce;	/* Loop index */
+	int did;			/* Each domain-id found */
+	u32 bus;			/* Index into root-entry-table */
+	u32 devfn;			/* Index into context-entry-table */
+
+	pr_debug("ENTER %s iommu:%d\n", __func__, iommu->seq_id);
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return -ENOMEM;
+
+	root_phys = (void *)q;
+	root_temp = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	if (!root_temp)
+		return -ENOMEM;
+	oldcopy(root_temp, root_phys, PAGE_SIZE);
+
+	context_temp = (struct context_entry *)alloc_pgtable_page(iommu->node);
+	if (!context_temp) {
+		free_pgtable_page(root_temp);
+		return -ENOMEM;
+	}
+
+	for (bus = 0, re = root_temp; bus < 256; bus += 1, re += 1) {
+
+		if (!root_present(re))
+			continue;
+
+		pr_debug("ROOT B:%2.2x val: %16.16llx rsvd1: %16.16llx\n",
+			bus, re->val, re->rsvd1);
+
+		if (re->rsvd1)			/* If (root_entry is bad) */
+			continue;
+
+		context_phys = get_context_phys_from_root(re);
+		if (!context_phys)
+			continue;
+
+		oldcopy(context_temp, context_phys, PAGE_SIZE);
+
+		for (devfn = 0, ce = context_temp; devfn < 512; devfn++, ce++) {
+			if (!context_get_p(ce))
+				continue;
+
+			did = context_get_did(ce);
+			set_bit(did, iommu->domain_ids);
+			pr_debug("DID B:D:F:%2.2x:%2.2x:%1.1x did:%d(0x%4.4x)\n",
+				bus, devfn >> 3, devfn & 0x7, did, did);
+		}
+
+	}
+	free_pgtable_page(root_temp);
+	free_pgtable_page(context_temp);
+	pr_debug("LEAVE %s iommu:%d\n", __func__, iommu->seq_id);
+	return 0;
+}
+
+
+
+/* ========================================================================
+ * Copy iommu translation tables from old kernel into new  kernel.
+ * Entry to this set of functions is: copy_intel_iommu_translation_tables()
+ * ------------------------------------------------------------------------
+ */
+
+/*
+ * Struct copy_page_addr_parms is used to allow copy_page_addr()
+ * to accumulate values across multiple calls and returns.
+ */
+struct copy_page_addr_parms {
+	u32 first;	/* flag: first-time  */
+	u32 last;	/* flag: last-time */
+	u32 bus;	/* last bus number we saw */
+	u32 devfn;	/* last devfn we saw */
+	u32 shift;	/* last shift we saw */
+	u64 pte;	/* Page Table Entry */
+	u64 next_addr;	/* next-expected page_addr */
+
+	u64 page_addr;	/* page_addr accumulating size */
+	u64 page_size;	/* page_size accumulated */
+
+	struct dmar_domain *domain;	/* to accumulate iova ranges */
+};
+
+/*
+ * constant for initializing instances of copy_page_addr_parms properly.
+ */
+static struct copy_page_addr_parms copy_page_addr_parms_init = {1, 0};
+
+
+
+/*
+ * Lowest-level function in the 'Copy Page Tables' set
+ * Called once for each page_addr present in an iommu page-address table.
+ *
+ * Because of the depth-first traversal of the page-tables by the
+ * higher-level functions that call 'copy_page_addr', all pages
+ * of a domain will be presented in ascending order of IO Virtual Address.
+ *
+ * This function accumulates each contiguous range of these IOVAs and
+ * reserves it within the proper domain in the crashdump kernel when a
+ * non-contiguous range is detected, as determined by any of the following:
+ * 1. a change in the bus or device owning the presented page
+ * 2. a change in the page-size (parameter shift) of the presented page
+ * 3. a change in the page-table entry of the presented page
+ * 4. a presented IOVA that does not match the expected next-page address
+ * 5. the 'last' flag is set, indicating that all IOVAs have been seen.
+ */
+static int copy_page_addr(u64 page_addr, u32 shift, u32 bus, u32 devfn,
+				u64 pte, struct dmar_domain *domain,
+				void *parms)
+{
+	struct copy_page_addr_parms *ppap = parms;
+
+	u64 page_size = ((u64)1 << shift);	/* page_size */
+	u64 pfn_lo;				/* For reserving IOVA range */
+	u64 pfn_hi;				/* For reserving IOVA range */
+	struct iova *iova_p;			/* For reserving IOVA range */
+
+	if (!ppap) {
+		pr_err("ERROR: ppap is NULL: 0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
+			bus, bus, devfn, devfn,  page_addr,
+			page_size, page_size);
+		return 0;
+	}
+
+	if (!ppap->last) {			/* If (Not last time) */
+		if (pr_dbg.copy_page_addr)
+			pr_debug("ADDR::B:D:F=%2.2x:%2.2x:%1.1x Addr:0x%12.12llx Size:0x%12.12llx(%lld) Pte:0x%16.16llx\n",
+			bus, devfn >> 3, devfn & 0x7,
+			page_addr, page_size, page_size, pte);
+
+		/* If (only extending current addr range) */
+		if (ppap->first     == 0      &&
+		    ppap->bus       == bus    &&
+		    ppap->devfn     == devfn  &&
+		    ppap->shift     == shift  &&
+		    (ppap->pte & ~VTD_PAGE_MASK) == (pte & ~VTD_PAGE_MASK) &&
+		    ppap->next_addr == page_addr) {
+
+			/* Update page size and next-expected address */
+			ppap->next_addr += page_size;
+			ppap->page_size += page_size;
+			return 0;
+		}
+	}
+
+	if (!ppap->first) {
+		/* Print out the accumulated address range */
+
+		if (pr_dbg.addr_ranges)
+			pr_debug("DATA B:D:F=%2.2x:%2.2x:%1.1x Addr:0x%12.12llx Size:0x%12.12llx(%lld) Pte:0x%16.16llx\n",
+			ppap->bus, ppap->devfn >> 3, ppap->devfn & 0x7,
+			ppap->page_addr,
+			ppap->page_size, ppap->page_size, ppap->pte);
+
+		if (!ppap->domain) {
+			pr_err("%s ERROR: Domain is NULL -- needed to reserve range for B:D:F=%2.2x:%2.2x:%1.1x\n",
+				__func__,
+				ppap->bus, ppap->devfn >> 3, ppap->devfn & 0x7);
+			return 0;
+		}
+		pfn_lo = IOVA_PFN(ppap->page_addr);
+		pfn_hi = IOVA_PFN(ppap->page_addr + ppap->page_size);
+		iova_p = reserve_iova(&ppap->domain->iovad, pfn_lo, pfn_hi);
+
+		if (iova_p)
+			if (pr_dbg.reserved_ranges)
+				pr_debug("RSVD B:D:F=%2.2x:%2.2x:%1.1x (0x%16.16lx, 0x%16.16lx) did=0x%4.4x\n",
+					ppap->bus,
+					ppap->devfn >> 3, ppap->devfn & 0x7,
+					iova_p->pfn_lo, iova_p->pfn_hi,
+					ppap->domain->id);
+	}
+
+	/* Prepare for a new page */
+	ppap->first     = 0;		/* Not first-time anymore */
+	ppap->bus       = bus;
+	ppap->devfn     = devfn;
+	ppap->shift     = shift;
+	ppap->pte       = pte;
+	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
+
+	ppap->page_addr = page_addr;	/* Addr(new page) */
+	ppap->page_size = page_size;	/* Size(new page) */
+
+	ppap->domain    = domain;	/* adr(domain for the new range) */
+
+	return 0;
+}
+
+/*
+ * Recursive function to copy the tree of page tables (max 6 recursions)
+ * Parameter 'shift' controls the recursion
+ */
+static int copy_page_table(struct dma_pte **dma_pte_new_p,
+			   struct dma_pte *dma_pte_phys,
+			   u32 shift, u64 page_addr,
+			   struct intel_iommu *iommu,
+			   u32 bus, u32 devfn,
+			   struct dmar_domain *domain, void *ppap)
+{
+	int ret;			/* Integer return code */
+	struct dma_pte *p;		/* Physical adr(each entry) iterator */
+	struct dma_pte *pgt_new_virt;	/* Adr(dma_pte in new kernel) */
+	struct dma_pte *dma_pte_next;	/* Adr(next table down)  */
+	u64 u;				/* index(each entry in page_table) */
+
+	if (pr_dbg.copy_page_table)
+		pr_debug("ENTER %s B:D:F:%2.2x:%2.2x:%1.1x phys:%16.16llx shift:%d addr:%16.16llx\n",
+			__func__, bus, devfn >> 3, devfn & 0x7,
+			(u64)dma_pte_phys, shift, page_addr);
+
+	/* If (already done all levels -- problem) */
+	if (shift < 12) {
+		pr_err("ERROR %s shift < 12 %p\n", __func__, dma_pte_phys);
+		pr_err("shift %d, page_addr %16.16llu bus %3.3u devfn %3.3u\n",
+			shift, page_addr, bus, devfn);
+		return 2;
+	}
+
+	/* allocate a page table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+
+	pgt_new_virt = (struct dma_pte *)alloc_pgtable_page(iommu->node);
+	if (!pgt_new_virt)
+		return -ENOMEM;
+
+	ret = oldcopy(pgt_new_virt, dma_pte_phys, VTD_PAGE_SIZE);
+	if (ret <= 0)
+		return ret;
+
+	for (u = 0, p = pgt_new_virt; u < 512; u++, p++) {
+
+		if (((p->val & DMA_PTE_READ) == 0) &&
+		    ((p->val & DMA_PTE_WRITE) == 0))
+			continue;
+
+		if (dma_pte_superpage(p) || (shift == 12)) {
+
+			ret = copy_page_addr(page_addr | (u << shift),
+				shift, bus, devfn, p->val, domain, ppap);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		ret = copy_page_table(&dma_pte_next,
+				(struct dma_pte *)(p->val & VTD_PAGE_MASK),
+				shift-9, page_addr | (u << shift),
+				iommu, bus, devfn, domain, ppap);
+		if (ret)
+			return ret;
+
+		p->val &= ~VTD_PAGE_MASK;	/* Clear old and set new pgd */
+		p->val |= ((u64)dma_pte_next & VTD_PAGE_MASK);
+	}
+
+	*dma_pte_new_p = (struct dma_pte *)virt_to_phys(pgt_new_virt);
+	__iommu_flush_cache(iommu, pgt_new_virt, VTD_PAGE_SIZE);
+
+	if (pr_dbg.copy_page_table)
+		pr_debug("LEAVE %s new page:%16.16llx(phys) %16.16llx(virt)\n",
+			__func__, (u64)(*dma_pte_new_p), (u64)pgt_new_virt);
+
+	return 0;
+}
+
+
+/*
+ * Called once for each context_entry found in a copied context_entry_table
+ * Each context_entry represents one PCIe device handled by the IOMMU.
+ *
+ * Creates a 'struct device_domain_info' for this device and adds it to
+ * the 'device_domain_values_list'.
+ *
+ * The Intel-iommu spec. requires that every context_entry that contains
+ * the same domain-id point to the same set of page translation tables.
+ * The hardware uses this to improve the use of its translation cache.
+ * In order to make the software internal management structures match the
+ * existing context_entries in the translation tables, this function
+ * checks each previous entry on the list for a domain-id that matches the
+ * domain-id in this context_entry.  If found, it attaches the device to
+ * the existing domain structure and places the address of the previous
+ * domain's page translation table tree into this context_entry.
+ * If a matching previous entry is not found, a new 'dmar_domain'
+ * structure is created for the domain-id in this context_entry and
+ * copy_page_table is called to duplicate its tree of page tables.
+ *
+ * Note: although the 'device_domain_values_list' contains structures
+ * identical to those used by the mainline code to manage domains and
+ * devices, the structures in 'device_domain_values_list' are used only
+ * for the purpose of pointing the duplicated context_entry at the proper
+ * set of page translation tables.  At this point, it would be possible
+ * to create the actual structures used by mainline code; however, this was
+ * not done in order to minimize the changes to the mainline code.
+ */
+static int copy_context_entry(struct intel_iommu *iommu, u32 bus, u32 devfn,
+			      void *ppap, struct context_entry *ce)
+{
+	int ret = 0;			/* Integer Return Code */
+	u32 shift = 0;			/* bits to shift page_addr  */
+	u64 page_addr = 0;		/* Address of translated page */
+	struct dma_pte *pgt_old_phys;	/* Adr(page_table in the old kernel) */
+	struct dma_pte *pgt_new_phys;	/* Adr(page_table in the new kernel) */
+	unsigned long asr;		/* New asr value for new context */
+	u8  t;				/* Translation-type from context */
+	u8  aw;				/* Address-width from context */
+	u32 aw_shift[8] = {
+		12+9+9,		/* [000b] 30-bit AGAW (2-level page table) */
+		12+9+9+9,	/* [001b] 39-bit AGAW (3-level page table) */
+		12+9+9+9+9,	/* [010b] 48-bit AGAW (4-level page table) */
+		12+9+9+9+9+9,	/* [011b] 57-bit AGAW (5-level page table) */
+		12+9+9+9+9+9+9,	/* [100b] 64-bit AGAW (6-level page table) */
+		0,		/* [111b] Reserved */
+		0,		/* [110b] Reserved */
+		0,		/* [111b] Reserved */
+	};
+
+	struct dmar_domain *domain = NULL;	/* To hold domain & device */
+						/*    values from old kernel */
+	struct device_domain_info *info = NULL;	/* adr(new for this device) */
+	struct device_domain_info *i = NULL;	/* iterator for foreach */
+
+
+	pr_debug("CTXT B:D:F:%2.2x:%2.2x:%1.1x at virt: 0x%16.16llx  hi:%16.16llx lo:%16.16llx\n",
+		bus, devfn >> 3, devfn & 0x7,
+		(u64) ce, ce->hi, ce->lo);
+
+	if (!context_get_p(ce)) {	/* If (context not present) */
+		ret = 0;		/* Skip it */
+		goto exit;
+	}
+
+	pr_debug("CTXT B:D:F:%2.2x:%2.2x:%1.1x p=%d fpd=%d t=%d asr=%16.16llx aw=%d aval=%d did=0x%4.4x\n",
+		bus, devfn >> 3, devfn & 0x7,
+		(int) context_get_p(ce),
+		(int) context_get_fpdi(ce),
+		(int) context_get_t(ce),
+		(u64) context_get_asr(ce),
+		(int) context_get_aw(ce),
+		(int) context_get_aval(ce),
+		(u32) context_get_did(ce));
+
+	info = alloc_devinfo_mem();
+	if (!info) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	/* info->segment = segment;	 May need this later */
+	info->bus = bus;
+	info->devfn = devfn;
+	info->iommu = iommu;
+
+	list_for_each_entry(i, &device_domain_values_list[iommu->seq_id],
+				global) {
+		if (i->domain->id == (int) context_get_did(ce)) {
+			domain = i->domain;
+			pr_debug("CTXT B:D:F:%2.2x:%2.2x:%1.1x Found did=0x%4.4x\n",
+				bus, devfn >> 3, devfn & 0x7, i->domain->id);
+			break;
+		}
+	}
+
+	if (!domain) {
+		domain = alloc_domain();
+		if (!domain) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+		INIT_LIST_HEAD(&domain->devices);
+		domain->id = (int) context_get_did(ce);
+		domain->agaw = (int) context_get_aw(ce);
+		domain->pgd = NULL;
+		init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
+
+		pr_debug("CTXT Allocated new list entry, did:%d\n",
+			domain->id);
+	}
+
+	info->domain = domain;
+	list_add(&info->link, &domain->devices);
+	list_add(&info->global, &device_domain_values_list[iommu->seq_id]);
+
+	if (domain->pgd) {
+		asr = virt_to_phys(domain->pgd) >> VTD_PAGE_SHIFT;
+		context_put_asr(ce, asr);
+		ret = 4;
+		goto exit;
+	}
+
+	t = context_get_t(ce);
+
+	if (t == 0 || t == 1) {		/* If (context has page tables) */
+		aw = context_get_aw(ce);
+		shift = aw_shift[aw];
+
+		pgt_old_phys = (struct dma_pte *)(context_get_asr(ce) << 12);
+
+		ret = copy_page_table(&pgt_new_phys, pgt_old_phys,
+			shift-9, page_addr, iommu, bus, devfn, domain, ppap);
+
+		if (ret)		/* if (problem) bail out */
+			goto exit;
+
+		asr = ((unsigned long)(pgt_new_phys)) >> VTD_PAGE_SHIFT;
+		context_put_asr(ce, asr);
+		domain->pgd = phys_to_virt((unsigned long)pgt_new_phys);
+		ret = 1;
+		goto exit;
+	}
+
+	if (t == 2) {		/* If (Identity mapped pass-through) */
+		ret = 2;	/*	REVISIT: Skip for now */
+		goto exit;
+	}
+
+	ret = 3;		/* Else ce->t is a Reserved value */
+
+exit:	/* all returns come through here to insure good clean-up */
+
+	if (ret < 0) {
+		if (info)
+			free_devinfo_mem(info);
+		if (domain)
+			free_domain_mem(domain);
+	}
+	return ret;
+}
+
+
+/*
+ * Called once for each context_entry_table found in the root_entry_table
+ */
+static int copy_context_entry_table(struct intel_iommu *iommu,
+				    u32 bus, void *ppap,
+				    struct context_entry **context_new_p,
+				    struct context_entry *context_old_phys)
+{
+	int ret = 0;				/* Integer return code */
+	struct context_entry *ce;		/* Iterator */
+	struct context_entry *context_new_phys;	/* adr(table in new kernel) */
+	struct context_entry *context_new_virt;	/* adr(table in new kernel) */
+	u32 devfn = 0;				/* PCI Device & function */
+
+	/* allocate a context-entry table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+	context_new_virt =
+		(struct context_entry *)alloc_pgtable_page(iommu->node);
+	if (!context_new_virt)
+		return -ENOMEM;
+
+	context_new_phys =
+		(struct context_entry *)virt_to_phys(context_new_virt);
+
+	oldcopy(context_new_virt, context_old_phys, VTD_PAGE_SIZE);
+
+	for (devfn = 0, ce = context_new_virt; devfn < 256; devfn++, ce++) {
+
+		if (!context_get_p(ce))		/* If (context not present) */
+			continue;		/* Skip it */
+
+		ret = copy_context_entry(iommu, bus, devfn, ppap, ce);
+		if (ret == 0)		/* if (Entry not present) */
+			continue;
+		if (ret == 1)		/* If (Identity mapped pass-through) */
+			continue;	/*    REVISIT -- Skip for now */
+		if (ret == 2)		/* If (ce->t was reserved value) */
+			continue;	/*    REVISIT -- Skip for now */
+		if (ret < 0)		/* if (problem) */
+			return ret;
+	}
+
+	*context_new_p = context_new_phys;
+	__iommu_flush_cache(iommu, context_new_virt, VTD_PAGE_SIZE);
+	return 0;
+}
+
+
+/*
+ * Highest-level function in the 'copy translation tables' set of functions
+ */
+static int copy_root_entry_table(struct intel_iommu *iommu, void *ppap,
+				 struct root_entry  **root_new_virt_p,
+				 struct root_entry  *root_old_phys)
+{
+	int ret = 0;				/* Integer return code */
+	u32 bus;				/* Index: root-entry-table */
+	struct root_entry  *re;			/* Virt(iterator: new table) */
+	struct root_entry  *root_new_virt;	/* Virt(table in new kernel) */
+	struct context_entry *context_old_phys;	/* Phys(context table entry) */
+	struct context_entry *context_new_phys;	/* Phys(new context_entry) */
+
+	/*
+	 * allocate a root-entry table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+
+	root_new_virt = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	if (!root_new_virt)
+		return -ENOMEM;
+
+	oldcopy(root_new_virt, root_old_phys, VTD_PAGE_SIZE);
+
+	for (bus = 0, re = root_new_virt; bus < 256; bus += 1, re += 1) {
+
+		if (!root_present(re))
+			continue;
+
+		pr_debug("ROOT Bus: %2.2x re->val: %llx rsvd1: %llx\n",
+			bus, re->val, re->rsvd1);
+
+		context_old_phys = get_context_phys_from_root(re);
+
+		if (!context_old_phys)
+			continue;
+
+		ret = copy_context_entry_table(iommu, bus, ppap,
+						&context_new_phys,
+						context_old_phys);
+		if (ret)
+			return ret;
+
+		re->val &= ~VTD_PAGE_MASK;
+		set_root_value(re, (unsigned long)context_new_phys);
+	}
+
+	*root_new_virt_p = root_new_virt;
+	__iommu_flush_cache(iommu, root_new_virt, VTD_PAGE_SIZE);
+	return 0;
+}
+
+/*
+ * Interface to the "copy translation tables" set of functions
+ * from mainline code.
+ */
+static int copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
+		struct root_entry **root_old_phys_p,
+		struct root_entry **root_new_virt_p)
+{
+	struct intel_iommu *iommu;	/* Virt(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys(table in old kernel) */
+	struct root_entry *root_new;	/* Virt(table in new kernel) */
+	int ret = 0;			/* Integer return code */
+	int i = 0;			/* Loop index */
+
+	/* Structure so copy_page_addr() can accumulate things
+	 * over multiple calls and returns
+	 */
+	struct copy_page_addr_parms ppa_parms = copy_page_addr_parms_init;
+	struct copy_page_addr_parms *ppap = &ppa_parms;
+
+
+	pr_debug("ENTER %s\n", __func__);
+
+	iommu = drhd->iommu;
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+
+	if (!q)
+		return -1;
+
+	*root_old_phys_p = (struct root_entry *)q;	/* Returned to caller */
+
+	/* If (list needs initializing) do it here */
+	if (!device_domain_values_list) {
+		device_domain_values_list =
+			 kcalloc(g_num_of_iommus, sizeof(struct list_head),
+					GFP_KERNEL);
+
+		if (!device_domain_values_list) {
+			pr_err("Allocation failed for device_domain_values_list array\n");
+			return -ENOMEM;
+		}
+		for (i = 0; i < g_num_of_iommus; i++)
+			INIT_LIST_HEAD(&device_domain_values_list[i]);
+	}
+
+	/* Copy the root-entry table from the old kernel
+	 * foreach context_entry_table in root_entry
+	 *    foreach context_entry in context_entry_table
+	 *       foreach level-1 page_table_entry in context_entry
+	 *          foreach level-2 page_table_entry in level 1 page_table_entry
+	 *             Above pattern continues up to 6 levels of page tables
+	 *                Sanity-check the entry
+	 *                Process the bus, devfn, page_address, page_size
+	 */
+
+	root_phys = (struct root_entry *)q;
+	ret = copy_root_entry_table(iommu, ppap, &root_new, root_phys);
+	if (ret)
+		return ret;
+
+
+	ppa_parms.last = 1;
+	copy_page_addr(0, 0, 0, 0, 0, NULL, ppap);
+	*root_new_virt_p = root_new;			/* Returned to caller */
+
+	/* The translation tables in the new kernel should now contain
+	 * the same translations as the tables in the old kernel.
+	 * This will allow us to update the iommu hdw to use the new tables.
+	 *
+	 * NOTE: Neither the iommu hardware nor the iommu->root_entry
+	 *       struct-value is updated herein.
+	 *       These are left for the caller to do.
+	 */
+
+	pr_debug("LEAVE %s\n", __func__);
+	return 0;
+}
+#endif /* CONFIG_CRASH_DUMP */
-- 
Bill Sumner <bill.sumner@hp.com>
************************************************************************

