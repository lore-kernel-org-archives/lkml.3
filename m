Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3IZX1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:27:15 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29970 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3IZX1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:27:12 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Subject: [RFC PATCH] Crashdump Accepting Active IOMMU
Thread-Topic: [RFC PATCH] Crashdump Accepting Active IOMMU
Thread-Index: Ac67D54OrKpBvvCoTIueU4/nA4Pw+w==
Date: Thu, 26 Sep 2013 23:25:57 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A055A67790@G9W0337.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {13353048-8E5E-4EFA-A73A-1B775A1DD8EE}
x-cr-hashedpuzzle: Ax4i F4tA KflY PGwn VyLS XwHg lBTK vB4K wHTn zReb 4Zjb
 5ObR ABBujA== ABqscg== ADikgA==
 AD759w==;10;YQBsAGUAeAAuAHcAaQBsAGwAaQBhAG0AcwBvAG4AQAByAGUAZABoAGEAdAAuAGMAbwBtADsAYgBoAGUAbABnAGEAYQBzAEAAZwBvAG8AZwBsAGUALgBjAG8AbQA7AGQAZAB1AHQAaQBsAGUAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGkAbgBkAG8AdQAuAHQAYQBrAGEAbwBAAGoAcAAuAGYAdQBqAGkAdABzAHUALgBjAG8AbQA7AGkAbwBtAG0AdQBAAGwAaQBzAHQAcwAuAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGkAcwBoAGkAaQAuAGgAaQByAG8AbgBvAGIAdQBAAGoAcAAuAGYAdQBqAGkAdABzAHUALgBjAG8AbQA7AGsAZQB4AGUAYwBAAGwAaQBzAHQAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AcABjAGkAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{13353048-8E5E-4EFA-A73A-1B775A1DD8EE};YgBpAGwAbAAuAHMAdQBtAG4AZQByAEAAaABwAC4AYwBvAG0A;Thu,
 26 Sep 2013 23:24:59
 GMT;WwBSAEYAQwAgAFAAQQBUAEMASABdACAAQwByAGEAcwBoAGQAdQBtAHAAIABBAGMAYwBlAHAAdABpAG4AZwAgAEEAYwB0AGkAdgBlACAASQBPAE0ATQBVAA==
x-originating-ip: [16.210.48.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Request For Comment submission is primarily to solicit comments on a concept for how kdump can handle legacy DMA IO leftover from the panicked kernel and comments on early prototype code to implement it.  Some level of interest was noted when I proposed this concept in June; however, for generating serious discussion there is no substitute for a working prototype.  

This concept modifies the behavior of the iommu in the (new) crashdump kernel: 
1. to accept the iommu hardware in an active state, 
2. to leave the current translations in-place so that legacy DMA will continue using its current buffers until the device drivers in the crashdump kernel initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers in the crashdump kernel than the iova ranges that were in-use at the time of the panic.  

Advantages of this concept:
1. All manipulation of the IO-device is done by the Linux device-driver for that device.
2. This concept behaves in a very similar manner to operation without an active iommu.
3. Any activity between the IO-device and its RMRR areas is handled by the device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.  This supports the practice of creating a special kdump kernel without drivers for any devices that are not required for taking a crashdump. 



About the early-prototype code in the patch below:
--------------------------------------------------
1. It works on one machine that reproduced the original problem -- still need to test it on a lot of other machines with various IO configurations.

2. Currently implemented for intel-iommu architecture only,

3. It is based near TOT from kernel.org.  The TOT version of 'crash' reads the dump that is produced.

4. It is definitely prototype-only and not yet ready to propose as a patch for inclusion into Linux proper.

5. Although this patch is not yet intended for incorporation into mainstream Linux, it should install and operate for anyone who wants to experiment with it.  Because this patch changes the low-level IO-operation, and because of its very-limited testing, I strongly advise against installing this patch on any system that contains production data.

6. For this RFC, I decided to leave-in all of the debugging, diagnostic, temporary, and test code so that it would be readily available.  In a (future) patch submission, much of this would need to be either eliminated, separated into a diagnostics area, moved under conditional compilation, or something else.  We'll see what the Linux community recommends.



At a high level, this code:
===========================
* is entirely within intel-iommu.c 
* operates primarily during iommu initialization and device-driver initialization

During intel-iommu hardware initialization:
-------------------------------------------
In intel_iommu_init(void)
* If (This is the crash kernel)
  .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
  .  Skip disabling the iommu hardware translations

In init_dmars()
* Duplicate the intel iommu translation tables from the old kernel in the new kernel
  . The root-entry table, all context-entry tables, and all page-translation-entry tables
  . The duplicate tables contain updated physical addresses to link them together.
  . The duplicate tables are mapped into kernel virtual addresses in the new kernel 
    which allows most of the existing iommu code to operate without change.
  . Do some minimal sanity-checks during the copy
  . Place the address of the new root-entry structure into "struct intel_iommu"

* Skip setting-up new domains for 'si', 'rmrr', 'isa' 
  . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
  . This prototype does not yet handle pass-through

* Existing (unchanged) code near the end of dmar_init:
  . Loads the address of the (now new) root-entry structure from "struct intel_iommu"
    into the iommu hardware and does the iommu hardware flushes. This changes the 
    active translation tables from the ones in the old kernel to the copies in the new kernel.
  . This is legal because the translations in the two sets of tables are currently identical:
      Intel(r) Virtualization Technology for Directed I/O. Architecture Specification,
      February 2011, Rev. 1.3  (section 11.2, paragraph 2) 

In iommu_init_domains()
* Mark as in-use all domain-id's from the old kernel
  . In case the new kernel contains a device that was not in the old kernel
    and a new, unused domain-id is actually needed, the bitmap will give us one.

When a new domain is created for a device:
------------------------------------------
* If (this device has a context in the old kernel)
  . Get domain-id, address-width, and IOVA ranges from the old kernel context;
  . Get address(page-entry-tables) from the copy in the new kernel;
  . And apply all of the above values to the new domain structure.
* Else
  . Create a new domain as normal

I would very much like the advice of the Linux community on how to proceed.

Signed-off-by: Bill Sumner <bill.sumner@hp.com>

Bill



>From c1c6102f2a82e9450c6e3ea76f250bb35e6b1992 Mon Sep 17 00:00:00 2001
From: Bill <bill.sumner@hp.com>
Date: Thu, 26 Sep 2013 15:37:48 -0600
Subject: [PATCH] rfc-crashdump-accepting-active-iommu.patch

---
 drivers/iommu/intel-iommu.c | 1984 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 1913 insertions(+), 71 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index eec0d3e..28e8888 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -48,6 +48,7 @@
 
 #include "irq_remapping.h"
 #include "pci.h"
+#include <linux/crash_dump.h>
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
@@ -164,6 +165,63 @@ static inline unsigned long virt_to_dma_pfn(void *p)
 	return page_to_dma_pfn(virt_to_page(p));
 }
 
+#ifdef CONFIG_CRASH_DUMP
+/* ===================================================================
+ * Crashdump Accepting Active IOMMU
+ * Introduces the concept of the crashdump kernel dealing with an active iommu
+ * and legacy DMA from the (old) panic'd kernel in a manner similar to how
+ * legacy DMA is handled when no hardware iommu was in use by the old kernel --
+ * allow the legacy DMA to continue into its current buffers.
+ *
+ * This proof-of-concept / prototype code:
+ * 1. accepts the iommu hardware in an active state from the old kernel,
+ * 2. leaves the current translations in-place so that legacy DMA will
+ *    continue to use its current buffers,
+ * 3. uses portions of the iova address ranges for the device drivers
+ *    in the crashdump kernel that are different from the iova address ranges
+ *    that were being used by the old kernel at the time of the panic.
+ * -------------------------------------------------------------------
+ */
+
+/* Flags for Crashdump Accepting Active IOMMU */
+
+static int crashdump_accepting_active_iommu;
+static int intel_iommu_translation_tables_are_mapped;
+
+
+/*
+ * Prototypes for interface functions for
+ * Crashdump Accepting Active IOMMU
+ */
+static void
+print_intel_iommu_registers(struct dmar_drhd_unit *drhd);
+
+static void
+process_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd);
+
+static int
+copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
+	struct root_entry **root_old_p, struct root_entry **root_new_p);
+
+static int
+test_copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd);
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
+static void domain_get_ranges_from_old_kernel(struct dmar_domain *domain,
+		  struct intel_iommu *iommu, struct pci_dev *pdev);
+
+static int intel_iommu_get_dids_from_old_kernel(struct intel_iommu *iommu);
+#endif	/* CONFIG_CRASH_DUMP */
+
+
 /* global iommu list, set NULL for ignored DMAR units */
 static struct intel_iommu **g_iommus;
 
@@ -270,6 +328,7 @@ static inline void context_clear_entry(struct context_entry *context)
 	context->hi = 0;
 }
 
+
 /*
  * 0: readable
  * 1: writable
@@ -1280,6 +1339,12 @@ static int iommu_init_domains(struct intel_iommu *iommu)
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
 
@@ -1353,7 +1418,8 @@ static struct dmar_domain *alloc_domain(void)
 }
 
 static int iommu_attach_domain(struct dmar_domain *domain,
-			       struct intel_iommu *iommu)
+			       struct intel_iommu *iommu,
+			       int domain_number)
 {
 	int num;
 	unsigned long ndomains;
@@ -1363,12 +1429,15 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 
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
@@ -1979,8 +2048,21 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	int bus = 0, devfn = 0;
 	int segment;
 	int ret;
+	int did = -1;	/* Default to "no domain_id supplied" */
+
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	pr_err("IOMMU: get_domain_for_dev for device %s\n",
+			pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
 
 	domain = find_domain(pdev);
+
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (domain)
+		pr_err("IOMMU: Found domain (%d) for device %s\n",
+			domain->id, pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (domain)
 		return domain;
 
@@ -2011,6 +2093,11 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		}
 	}
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	pr_err("IOMMU: Allocating new domain for device %s\n",
+			pci_name(pdev));
+#endif /* CONFIG_CRASH_DUMP */
+
 	domain = alloc_domain();
 	if (!domain)
 		goto error;
@@ -2025,7 +2112,25 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
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
+	pr_err("IOMMU: Attaching new domain for device %s to iommu: gaw(%d) did(%d)\n",
+			pci_name(pdev), gaw, did);
+#endif /* CONFIG_CRASH_DUMP */
+
+	ret = iommu_attach_domain(domain, iommu, did);
 	if (ret) {
 		free_domain_mem(domain);
 		goto error;
@@ -2036,6 +2141,23 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
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
+		pr_err("IOMMU: New Domain for device %s Did:%d Pgd: 0x%12.12llx\n",
+			pci_name(pdev), did, temp_pgd);
+	}
+#endif /* CONFIG_CRASH_DUMP */
+
 	/* register pcie-to-pci device */
 	if (dev_tmp) {
 		info = alloc_devinfo_mem();
@@ -2246,7 +2368,7 @@ static int __init si_domain_init(int hw)
 	pr_debug("Identity mapping domain is domain %d\n", si_domain->id);
 
 	for_each_active_iommu(iommu, drhd) {
-		ret = iommu_attach_domain(si_domain, iommu);
+		ret = iommu_attach_domain(si_domain, iommu, (int) -1);
 		if (ret) {
 			domain_exit(si_domain);
 			return -EFAULT;
@@ -2454,6 +2576,10 @@ static int __init init_dmars(void)
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2501,16 +2627,63 @@ static int __init init_dmars(void)
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
+
+			/* Turn-off lines used for development and testing */
+#if 0
+			/* Diagnostic start */
+			pr_err("Calling process_intel_iommu_translation_tables\n");
+			pr_err("(lists tables in OLD KERNEL before copy)\n");
+			for_each_drhd_unit(drhd)
+				process_intel_iommu_translation_tables(drhd);
+
+			test_copy_intel_iommu_translation_tables(drhd);
+			/* Diagnostic end */
+#endif
+
+			print_intel_iommu_registers(drhd);
+
+			pr_err("Calling copy_intel_iommu_translation_tables\n");
+			pr_err("(lists tables in OLD KERNEL during copy)\n");
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
+			pr_err("IOMMU: root_new_virt:0x%12.12llx phys:0x%12.12llx\n",
+				(u64)root_new_virt,
+				virt_to_phys(root_new_virt));
+
+#if 0
+			/* Diagnostic start */
+			pr_err("Calling process_intel_iommu_translation_tables\n");
+			pr_err("(tables in OLD KERNEL after copy)\n");
+			process_intel_iommu_translation_tables(drhd);
+			/* Diagnostic end */
+#endif
 		}
+
+		if (!crashdump_accepting_active_iommu) {
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
+		}
+#endif /* CONFIG_CRASH_DUMP */
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
@@ -2579,50 +2752,84 @@ static int __init init_dmars(void)
 
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
+		 * about "over 80 characters" and "Prefer pr_err(".
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
+
+		iommu_prepare_isa();
+#ifdef CONFIG_CRASH_DUMP
+		/* Diagnostic start */
+		pr_err("IOMMU: Test Print RMRR:\n");
+		for_each_rmrr_units(rmrr) {
+			for (i = 0; i < rmrr->devices_cnt; i++) {
+				pdev = rmrr->devices[i];
+				/*
+				 * some BIOS lists non-exist devices in DMAR
+				 * table.
+				 */
+				pr_err("IOMMU: RMRR[0x%16.16llx, 0x%16.16llx, %s\n",
+					rmrr->base_address, rmrr->end_address,
+					pci_name(pdev));
+			}
+		}
+		/* Diagnostic end */
 	}
 
-	iommu_prepare_isa();
+	intel_iommu_translation_tables_are_mapped = true;
+	pr_err("intel_iommu_translation_tables_are_mapped = true\n");
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2659,6 +2866,17 @@ static int __init init_dmars(void)
 			goto error;
 
 		iommu_disable_protect_mem_regions(iommu);
+
+#ifdef CONFIG_CRASH_DUMP
+#if 0
+		/* Diagnostic start */
+		pr_err("Calling process_intel_iommu_translation_tables\n");
+		pr_err("(lists tables in NEW KERNEL after copy)\n");
+		if (crashdump_accepting_active_iommu)
+			process_intel_iommu_translation_tables(drhd);
+		/* Diagnostic end */
+#endif
+#endif /* CONFIG_CRASH_DUMP */
 	}
 
 	return 0;
@@ -2816,6 +3034,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	BUG_ON(dir == DMA_NONE);
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s ENTER paddr(0x%12.12llx) size(0x%12.12lx)\n",
+			 __func__, paddr, size);
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (iommu_no_mapping(hwdev))
 		return paddr;
 
@@ -2858,6 +3082,12 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 
 	start_paddr = (phys_addr_t)iova->pfn_lo << PAGE_SHIFT;
 	start_paddr += paddr & ~PAGE_MASK;
+
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s LEAVE dma_addr_t(0x%16.16llx)\n",
+			 __func__, start_paddr);
+#endif /* CONFIG_CRASH_DUMP */
 	return start_paddr;
 
 error:
@@ -3663,11 +3893,17 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_notifier,
 };
 
+
 int __init intel_iommu_init(void)
 {
-	int ret = 0;
+
+	int irc = 0;
 	struct dmar_drhd_unit *drhd;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	pr_err("IOMMU intel_iommu_init ENTERED\n");
+#endif /* CONFIG_CRASH_DUMP */
+
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
@@ -3677,19 +3913,30 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
+#ifdef CONFIG_CRASH_DUMP
 	/*
-	 * Disable translation if already enabled prior to OS handover.
+	 * If (This is the crash kernel)
+	 *    Set: attempt to copy iommu translate tables from old kernel
+	 *    Skip disabling the iommu hardware translations
 	 */
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu;
+	if (is_kdump_kernel())
+		crashdump_accepting_active_iommu = true;
+	else
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
@@ -3720,14 +3967,14 @@ int __init intel_iommu_init(void)
 
 	init_no_remapping_devices();
 
-	ret = init_dmars();
-	if (ret) {
+	irc = init_dmars();
+	if (irc) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
 		put_iova_domain(&reserved_iova_list);
 		iommu_exit_mempool();
-		return ret;
+		return irc;
 	}
 	printk(KERN_INFO
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
@@ -3746,6 +3993,10 @@ int __init intel_iommu_init(void)
 
 	intel_iommu_enabled = 1;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	pr_err("IOMMU intel_iommu_init RETURNS\n");
+#endif /* CONFIG_CRASH_DUMP */
+
 	return 0;
 }
 
@@ -3976,6 +4227,10 @@ static int intel_iommu_domain_init(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s ENTER\n", __func__);
+#endif /* CONFIG_CRASH_DUMP */
 	dmar_domain = iommu_alloc_vm_domain();
 	if (!dmar_domain) {
 		printk(KERN_ERR
@@ -4014,6 +4269,10 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	struct intel_iommu *iommu;
 	int addr_width;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s ENTER\n", __func__);
+#endif /* CONFIG_CRASH_DUMP */
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
 		struct dmar_domain *old_domain;
@@ -4082,6 +4341,14 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	int prot = 0;
 	int ret;
 
+#ifdef CONFIG_CRASH_DUMP
+	/* Diagnostic start */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s did(%d) iommu width (%d) iova(0x%12.12lx) size(0x%12.12lx)\n",
+		__func__, dmar_domain->id, dmar_domain->gaw, iova, size);
+	/* Diagnostic end */
+#endif /* CONFIG_CRASH_DUMP */
+
 	if (iommu_prot & IOMMU_READ)
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
@@ -4133,6 +4400,11 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	struct dma_pte *pte;
 	u64 phys = 0;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s ENTER\n", __func__);
+#endif /* CONFIG_CRASH_DUMP */
+
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, 0);
 	if (pte)
 		phys = dma_pte_addr(pte);
@@ -4162,6 +4434,11 @@ static int intel_iommu_add_device(struct device *dev)
 	struct iommu_group *group;
 	int ret;
 
+#ifdef CONFIG_CRASH_DUMP	/* TEMPORARY */
+	if (crashdump_accepting_active_iommu)
+		pr_err("%s ENTER B:D:F 0x%2.2x:0x%2.2x:0x%1.1x\n",
+		__func__, pdev->bus->number, pdev->devfn >> 3, pdev->devfn & 7);
+#endif /* CONFIG_CRASH_DUMP */
 	if (!device_to_iommu(pci_domain_nr(pdev->bus),
 			     pdev->bus->number, pdev->devfn))
 		return -ENODEV;
@@ -4380,3 +4657,1568 @@ static void __init check_tylersburg_isoch(void)
 	printk(KERN_WARNING "DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
 	       vtisochctrl);
 }
+
+#ifdef CONFIG_CRASH_DUMP
+
+/*
+ * TEMPORARY
+ * Diagnostic note: All of the 'pr_err' functions under this 'ifdef'
+ * will probably be useful for ongoing diagnostic purposes.
+ * Probably would place them under a run-time conditional flag.
+ * May want to designate various print-frequency for some.
+ */
+
+/* ========================================================================
+ * Utility functions for accessing the iommu Translation Tables
+ * ------------------------------------------------------------------------
+ */
+static inline struct context_entry *
+get_context_phys_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root) ? (void *) (root->val & VTD_PAGE_MASK)
+				    : NULL);
+}
+
+#if 0	/* REVISIT Edited-out the only reference -- may delete this code */
+static u64 root_get_val(struct root_entry *root)
+{ return(root->val & VTD_PAGE_MASK); }
+#endif
+
+static int context_get_p(struct context_entry *c)    {return((c->lo >> 0) & 0x1); }
+static int context_get_fpdi(struct context_entry *c) {return((c->lo >> 1) & 0x1); }
+static int context_get_t(struct context_entry *c)    {return((c->lo >> 2) & 0x3); }
+static u64 context_get_asr(struct context_entry *c)  {return((c->lo >> 12));      }
+static int context_get_aw(struct context_entry *c)   {return((c->hi >> 0) & 0x7); }
+static int context_get_aval(struct context_entry *c) {return((c->hi >> 3) & 0xf); }
+static int context_get_did(struct context_entry *c)  {return((c->hi >> 8) & 0xffff); }
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
+static int oldcopy(void *pTo, void *pFrom, int iSize)
+{
+	size_t irc = 0;			/* Length copied */
+	unsigned long pfn;		/* Page Frame Number */
+	char *buf = pTo;		/* Adr(Output buffer) */
+	size_t csize = (size_t)iSize;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of pFrom */
+	int userbuf = 0;		/* pTo is in kernel space */
+
+#if 0
+	pr_err("oldcopy Entered pTo=%16.16llx, pFrom = %16.16llx, iSize = %d\n",
+		(unsigned long long) pTo, (unsigned long long) pFrom, iSize);
+#endif
+
+	pfn = ((unsigned long) pFrom) >> VTD_PAGE_SHIFT;
+	offset = ((unsigned long) pFrom) & (~VTD_PAGE_MASK);
+
+	if (intel_iommu_translation_tables_are_mapped)
+		memcpy(pTo, phys_to_virt((phys_addr_t)pFrom), csize);
+	else
+		irc = copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+
+#if 0
+	pr_err("oldcopy Returns %d\n", (int) irc);
+#endif
+
+	return (int) irc;
+}
+
+
+/* ========================================================================
+ * Functions to process the iommu Translation Tables in depth-first order
+ * ------------------------------------------------------------------------
+ */
+
+/* Structure to implement comparison of two trees of iommu translate tables */
+struct ppap_compare {
+	u64 iova;
+	u64 addr;
+	u8  bus;
+	u8  devfn;
+	u8  shift;
+};
+enum ppap_compare_cmd {
+	ppap_compare_none = 0,	/* No comparison activity */
+	ppap_compare_count,	/* Count number entries needed */
+	ppap_compare_fill,	/* Fill the entries */
+	ppap_compare_test,	/* Test values against the current entry */
+				/*    and print if there is a mismatch */
+	ppap_compare_print	/* Print values without testing */
+};
+
+
+/*
+ * Struct process_page_addr_parms is used to allow process_page_addr()
+ * to accumulate values across multiple calls and returns.
+ *
+ * Struct process_page_addr_parms_init is a constant for initializing
+ * instances of process_page_addr_parms properly.
+ */
+struct process_page_addr_parms {
+	u32 first;	/* flag: first-time  */
+	u32 last;	/* flag: last-time */
+	u32 bus;	/* last bus number we saw */
+	u32 devfn;	/* last devfn we saw */
+	u32 shift;	/* last shift we saw */
+	u64 pte;	/* Page Table Entry for page_addr */
+	u64 next_addr;	/* next-expected page_addr */
+
+	u64 page_addr;	/* page_addr accumulating size */
+	u64 page_size;	/* page_size accumulated */
+
+	struct dmar_domain *domain;
+	struct intel_iommu *iommu;
+	struct pci_dev     *pdev;
+
+	struct ppap_compare *compare_v;	/* Adr(vector) */
+	u32 compare_i;			/* Index(current item) */
+	u32 compare_m;			/* Maximum index */
+	u8  compare_cmd;		/* enum ppap_compare_cmd */
+};
+static struct process_page_addr_parms process_page_addr_parms_init = {1, 0};
+
+
+
+/* Lowest-level function in the 'Process Page Tables' set
+ * Called once for each page_addr present in an iommu page-address table.
+ */
+static int process_page_addr(struct intel_iommu *iommu, u64 page_addr,
+				u64 page_val, u32 shift, u32 bus, u32 devfn,
+				u64 pte, void *parms)
+{
+	struct process_page_addr_parms *ppap = parms;
+
+	u64 page_size = ((u64)1 << shift);	/* page_size */
+	u64 pfn_lo;			/* For reserving IOVA range */
+	u64 pfn_hi;			/* For reserving IOVA range */
+	struct iova *iova_p;		/* For reserving IOVA range */
+	struct ppap_compare *c;		/* Adr(item to compare this time) */
+
+	if (!ppap) {
+		pr_err("ERROR: ppap is NULL: 0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
+			bus, bus, devfn, devfn,  page_addr,
+			page_size, page_size);
+		return 0;
+	}
+
+	/* Handle a possible 'compare' request and then return */
+	switch (ppap->compare_cmd) {
+	case ppap_compare_none:
+		break;
+
+	case ppap_compare_count:
+		ppap->compare_m += 1;
+		return 0;
+
+	case ppap_compare_fill:
+		if (!ppap->compare_v || ppap->compare_i > ppap->compare_m)
+			break;
+
+		c = &ppap->compare_v[ppap->compare_i];
+		ppap->compare_i += 1;
+
+		c->iova  = page_addr;
+		c->addr  = page_val;
+		c->bus   = bus;
+		c->devfn = devfn;
+		c->shift = shift;
+		return 0;
+
+	case ppap_compare_test:
+		if (!ppap->compare_v || ppap->compare_i > ppap->compare_m)
+			return 0;
+
+		c = &ppap->compare_v[ppap->compare_i];
+		ppap->compare_i += 1;
+
+		if (c->iova  == page_addr &&
+		    c->addr  == page_val &&
+		    c->bus   == bus &&
+		    c->devfn == devfn &&
+		    c->shift == shift)
+			return 0;
+
+		/* Note fall-through */
+		ppap->compare_i -= 1;
+
+	case ppap_compare_print:
+		if (!ppap->compare_v || ppap->compare_i > ppap->compare_m)
+			return 0;
+
+		c = &ppap->compare_v[ppap->compare_i];
+		ppap->compare_i += 1;
+
+		pr_err("CMP NEW: Bus: %3.3d(0x%2.2x) DevFn: %3.3d(0x%2.2x) Shift: %3.3d(0x%2.2x) iova: 0x%16.16llx phys: 0x%16.16llx size:%lld\n",
+			bus, bus, devfn, devfn, shift, shift,
+			page_addr, page_val, ((u64)1) << c->shift);
+
+		pr_err("CMP OLD: Bus: %3.3d(0x%2.2x) DevFn: %3.3d(0x%2.2x) Shift: %3.3d(0x%2.2x) iova: 0x%16.16llx phys: 0x%16.16llx size: %lld\n",
+			c->bus, c->bus, c->devfn, c->devfn, c->shift, c->shift,
+			c->iova, c->addr, ((u64)1) << c->shift);
+
+		return 0;
+	}
+
+
+
+	/* Handle either 'print address ranges' or 'domain exclude ranges' */
+
+	if (!ppap->last) {
+
+#if 0
+		pr_err("DBG:0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
+			bus, bus, devfn, devfn, page_addr,
+			page_size, page_size);
+#endif
+
+		/* If (only extending current addr range) */
+		if (ppap->first     == 0      &&
+		    ppap->bus       == bus    &&
+		    ppap->devfn     == devfn  &&
+		    ppap->shift     == shift  &&
+		    (ppap->pte & ~VTD_PAGE_MASK) == (pte & ~VTD_PAGE_MASK) &&
+		    ppap->next_addr == page_addr) {
+			ppap->next_addr += page_size;	/* next-expected */
+			ppap->page_size += page_size;	/* accumulate size */
+			return 0;
+		}
+	}
+
+	if (!ppap->first) {
+		/* Print out the accumulated address range */
+
+			pr_err("PAGE B:D:F=0x%2.2x:0x%2.2x:0x%1.1x Addr:0x%12.12llx Size:0x%12.12llx(%lld) Pte:0x%16.16llx\n",
+				ppap->bus, ppap->devfn >> 3, ppap->devfn & 0x7,
+				ppap->page_addr,
+				ppap->page_size, ppap->page_size, ppap->pte);
+#if 0
+		pr_err("PAGE Bus:0x%3.3x(%3.3d) DevFn:0x%3.3x(%3.3d) Addr: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
+			ppap->bus,       ppap->bus,
+			ppap->devfn,     ppap->devfn,
+			ppap->page_addr,
+			ppap->page_size, ppap->page_size);
+#endif
+
+		if (ppap->domain) {
+			pfn_lo = IOVA_PFN(ppap->page_addr);
+			pfn_hi = IOVA_PFN(ppap->page_addr + ppap->page_size);
+			iova_p = reserve_iova(&ppap->domain->iovad,
+					      pfn_lo, pfn_hi);
+			if (iova_p)
+				pr_err("RESERVED (0x%16.16lx, 0x%16.16lx) did=0x%4.4x\n",
+					iova_p->pfn_lo, iova_p->pfn_hi,
+					ppap->domain->id);
+		}
+	}
+
+	/* Prepare for a new page */
+	ppap->first     = 0;
+	ppap->bus       = bus;
+	ppap->devfn     = devfn;
+	ppap->shift     = shift;
+	ppap->pte	= pte;
+	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
+
+	ppap->page_addr = page_addr; /* Addr(new page) */
+	ppap->page_size = page_size; /* Size(new page) */
+
+	return 0;
+}
+
+
+/*
+ * Recursive function (max 6 times) to handle tree of page tables.
+ * 'shift' parameter controls the recursion
+ */
+static int process_page_table(struct intel_iommu *iommu,
+				struct dma_pte *dma_pte_phys, u32 shift,
+				u64 page_addr, u32 bus, u32 devfn, void *ppap)
+{
+	int irc = 0;			/* Integer return code */
+	struct dma_pte *pte_temp;	/* Adr(Temporary copy in new kernel) */
+	struct dma_pte *p;		/* Virt adr(each entry) iterator */
+	u64 u;				/* index(entry in the page_table) */
+
+	if (shift < 12) {		/* If (already done all levels) */
+		pr_err("IOMMU ERROR process_page_table %p\n", dma_pte_phys);
+		pr_err("shift %d, page_addr %16.16llu bus %3.3u devfn %3.3u\n",
+			shift, page_addr, bus, devfn);
+		return 2;		/* return -- this is an error */
+	}
+
+	pr_err("process_page_table %16.16llx %d %16.16llx bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x)\n",
+		(u64)dma_pte_phys, shift, page_addr,
+		 bus, bus, devfn, devfn, devfn>>3, devfn & 0x7);
+
+	pte_temp = (struct dma_pte *)alloc_pgtable_page(iommu->node);
+	if (!pte_temp)
+		return -ENOMEM;
+
+	oldcopy(pte_temp, dma_pte_phys, PAGE_SIZE);
+
+	for (u = 0, p = pte_temp; u < 512; u++, p++) {
+
+		if (((p->val & DMA_PTE_READ) == 0) &&
+		    ((p->val & DMA_PTE_WRITE) == 0))
+			continue;
+
+		if (dma_pte_superpage(p) || (shift == 12)) {
+			process_page_addr(iommu,
+					  page_addr | (u << shift),
+					  p->val, shift, bus, devfn,
+					  (u64)(p->val), ppap);
+			continue;
+		}
+
+		irc = process_page_table(iommu,
+				(struct dma_pte *)(p->val & VTD_PAGE_MASK),
+				shift-9, page_addr | (u << shift),
+				bus, devfn, ppap);
+		if (irc)			/* if (problem) bail out */
+			goto exit;
+
+	}
+exit:;
+	free_pgtable_page(pte_temp);
+	return irc;
+}
+
+
+/* Called for each context-entry present in a context_entry table */
+
+static int process_context_entry(struct intel_iommu *iommu,
+				 struct context_entry *ce,
+				 u32 bus, u32 devfn, void *ppap)
+{
+	int irc;		/* Integer Return Code */
+	u32 shift = 0;		/* bits to shift page_addr  */
+	u64 page_addr = 0;	/* Address of translated page */
+	u8  t;			/* Translation-type from context */
+	u8  aw;			/* Address-width from context */
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
+
+	pr_err("CTXT bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x) hi: %16.16llx lo:%16.16llx\n",
+		bus, bus, devfn, devfn,
+		devfn >> 3, devfn & 0x7, ce->hi, ce->lo);
+
+	if (!context_get_p(ce))	/* If (context not present) */
+		return 1;			/* Skip it */
+
+	pr_err("CTXT bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x) p=%d fpd=%d t=%d asr=%16.16llx aw=%d aval=%d did=0x%4.4x\n",
+		bus, bus, devfn, devfn, devfn >> 3, devfn & 0x7,
+		(int) context_get_p(ce),
+		(int) context_get_fpdi(ce),
+		(int) context_get_t(ce),
+		(u64) context_get_asr(ce),
+		(int) context_get_aw(ce),
+		(int) context_get_aval(ce),
+		(u32) context_get_did(ce));
+
+	t = context_get_t(ce);
+
+	if (t == 0 || t == 1) {		/* If (context has page tables) */
+		aw = context_get_aw(ce);
+		shift = aw_shift[aw];
+		irc = process_page_table(iommu,
+				(struct dma_pte *)(context_get_asr(ce) << 12),
+				shift-9, page_addr, bus, devfn, ppap);
+		if (irc < 0)			/* if (problem) bail out */
+			return irc;
+		return 0;
+	}
+
+	if (t == 2)		/* If (Identity mapped pass-through) */
+		return 2;	/* REVISIT: Skip for now */
+
+	else			/* Else Reserved value */
+		return 3;	/* REVISIT: Skip for now */
+}
+
+
+/*
+ * Called for each context_entry_table address present
+ * in the root_entry table
+ */
+static int process_context_entry_table(struct intel_iommu *iommu,
+					struct context_entry *context_phys,
+					u32 bus, void *ppap)
+{
+	int irc = 0;				/* Integer return code */
+	struct context_entry  *context_temp;	/* Local copy of entry */
+	struct context_entry  *ce;		/* Virt adr(each entry) */
+	u32 devfn;				/* PCI Device & function */
+	u8  t;					/* Translation-type */
+
+
+
+	context_temp = (struct context_entry *)alloc_pgtable_page(iommu->node);
+	if (!context_temp)
+		return -ENOMEM;
+
+	oldcopy(context_temp, context_phys, PAGE_SIZE);
+
+	for (devfn = 0, ce = context_temp; devfn < 256; devfn++, ce++) {
+
+		if (!context_get_p(ce))		/* If (context not present) */
+			continue;		/* Skip it */
+
+		pr_err("CONTEXT at phys: 0x%16.16llx\n", (u64) ce);
+
+		irc = process_context_entry(iommu, ce, bus, devfn, ppap);
+		if (irc < 0)		/* if (problem) bail out */
+			goto exit;
+
+		t = context_get_t(ce);
+		if (t == 0 || t == 1)	/* If (there were page tables) */
+			continue;
+
+		if (t == 2)		/* If (Identity mapped pass-through) */
+			continue;		/* REVISIT: Skip for now */
+
+		else			/* Else Reserved value */
+			continue;		/* REVISIT: Skip for now */
+	}
+
+exit:;
+	free_pgtable_page(context_temp);
+	pr_err("process_context_entry_table LEAVE: %d\n", irc);
+	return irc;
+}
+
+
+/* Highest-level function in the "process translation tables" set.
+ * Entry to the "process translation tables" set from functions below
+ * to process the root_entry table, and lower-level tables
+ */
+
+static int process_root_entry_table(struct intel_iommu *iommu,
+				    struct root_entry *root_phys,
+				    void *ppap)
+{
+	int irc = 0;			/* Integer return code */
+	u32 bus;			/* Index into root-entry-table */
+	struct root_entry *re;		/* Virt adr (root table entry) */
+	struct root_entry *root_temp;	/* Virt adr (Local copy */
+	struct context_entry *context_phys;	/* Phys adr */
+
+	pr_err("process_root_entry_table ENTER: %p %p\n", root_phys, ppap);
+
+	/* foreach context_entry_table in root_entry_table
+	 *    foreach context_entry in context_entry_table
+	 *       foreach level-1 page_table_entry in context_entry
+	 *          foreach level-2 page_table_entry in level 1 page_table_entry
+	 *             Above pattern continues up to 6 levels of page tables
+	 *                Sanity-check the entry
+	 *                Process the bus, devfn, page_address, page_size
+	 */
+
+	root_temp = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	if (!root_temp)
+		return -ENOMEM;
+
+	oldcopy(root_temp, root_phys, PAGE_SIZE);
+
+	for (bus = 0, re = root_temp; bus < 256; bus++, re++) {
+
+		if (!root_present(re))
+			continue;
+
+		pr_err("ROOT Bus: %3.3d root_temp.val: %llx .rsvd1: %llx\n",
+			bus, re->val, re->rsvd1);
+
+		if (re->rsvd1)			/* If (root_entry is bad) */
+			continue;
+
+
+		context_phys = get_context_phys_from_root(re);
+		if (!context_phys)
+			continue;
+
+		irc = process_context_entry_table(iommu, context_phys,
+						  bus, (void *) ppap);
+
+		if (irc < 0)			/* if (problem) bail out */
+			break;
+
+	}
+
+	free_pgtable_page(root_temp);
+	pr_err("process_root_entry_table LEAVE: %d\n", irc);
+	return irc;
+}
+
+
+/* ==========================================================================
+ * Interfaces to the "process translation tables" set from locations
+ * among the existing portions of the intel_iommu.c code above.
+ * --------------------------------------------------------------------------
+ */
+
+/* Print the intel_iommu_translation_tables for a specific iommu. */
+
+static void process_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;	/* Virt adr(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys adr(root_entry_table) */
+
+	/* Structure so process_page_addr() can accumulate values
+	** over multiple calls and returns
+	*/
+	struct process_page_addr_parms ppa_parms = process_page_addr_parms_init;
+	struct process_page_addr_parms *ppap = &ppa_parms;
+
+
+	iommu = drhd->iommu;
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_err("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return;
+
+	root_phys = (void *)q;
+	process_root_entry_table(iommu, root_phys, (void *)ppap);
+
+	ppap->last = 1;						/* "Clean up" */
+	process_page_addr(NULL, 0, 0, 0, 0, 0, 0, (void *)ppap);/* last call */
+}
+
+
+
+/* Compare two trees of iommu translation tables (root, context, page tables)
+ * (For development, debugging, and sanity checking)
+ */
+static int compare_intel_iommu_translation_tables(struct root_entry *root_phys1,
+						  struct root_entry *root_phys2)
+{
+#if 0	/* TEMPORARILY broken */
+	u64 size;		/* Num bytes to request from vmalloc */
+	void *vscratch = NULL;	/* Adr(vmalloc'd scratch memory) */
+
+	/* Structure so process_page_addr() can accumulate values */
+	struct process_page_addr_parms ppa_parms = process_page_addr_parms_init;
+	struct process_page_addr_parms *ppap = &ppa_parms;
+#endif	/* TEMPORARILY broken */
+
+	pr_err("compare_intel_iommu_translation_tables ENTER: %p %p\n",
+		root_phys1, root_phys2);
+
+	pr_err("COMPARE IS TEMPORARILY UNAVAILABLE\n"); /* TEMP */
+#if 0	/* TEMPORARILY broken */
+
+	ppap->compare_cmd = ppap_compare_count;	/* Count needed entries */
+	process_root_entry_table(root_phys1, (void *)ppap);
+
+	size = ppap->compare_m * (sizeof(struct ppap_compare));
+	pr_err("compare_intel_iommu_translation_tables COUNT:%d SIZE:%llu\n",
+		ppap->compare_m, size);
+
+	if (!ppap->compare_m)
+		goto exit;
+
+	vscratch = vmalloc(size);
+
+	pr_err("compare_intel_iommu_translation_tables VMALLOC:0x%p\n",
+		vscratch);
+
+	ppap->compare_v   = vscratch;
+	ppap->compare_cmd = ppap_compare_fill;		/* Fill the entries */
+	process_root_entry_table(root_phys1, (void *)ppap);
+
+	pr_err("compare_intel_iommu_translation_tables FILLED:%d of %d\n",
+		ppap->compare_i, ppap->compare_m);
+
+	ppap->compare_cmd = ppap_compare_test;		/* Test the entries */
+	process_root_entry_table(root_phys2, (void *)ppap);
+
+exit:;
+	if (vscratch)
+		vfree(vscratch);
+#endif	/* TEMPORARILY broken */
+
+	pr_err("compare_intel_iommu_translation_tables LEAVE: %p %p\n",
+		root_phys1, root_phys2);
+
+	return 0;
+}
+
+
+
+
+/* ------------------------------------------------------------------------
+ * Interfaces to the "process translation tables" set for when a new
+ * domain in the new kernel needs some values from the old kernel tables
+ * ------------------------------------------------------------------------
+ */
+
+/* Utility function for interface functions that follow. */
+static int
+context_get_entry(struct context_entry *context_addr,
+			struct intel_iommu *iommu, u32 bus, int devfn)
+{
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys adr (root table entry) */
+	struct root_entry  root_temp;	/* Local copy of root_entry */
+	struct context_entry *context_phys;	/* Phys adr */
+
+	pr_err("%s ENTER B:D:F=%2.2x:%2.2x:%1.1x &context_entry:0x%llx &intel_iommu:0x%llx\n",
+		__func__, bus, devfn>>3, devfn&7,
+		(u64)context_addr, (u64)iommu);
+
+	if (bus > 255)				/* Sanity check */
+		return -5;
+	if (devfn > 255 || devfn < 0)		/* Sanity check */
+		return -6;
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_err("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+	if (!q)
+		return -1;
+
+	root_phys = (struct root_entry *) q;	/* Adr(base of vector) */
+	root_phys += bus;			/* Adr(entry we want) */
+
+	oldcopy(&root_temp, root_phys, sizeof(root_temp));
+
+	pr_err("root_temp.val:0x%llx .rsvd1:0x%llx root_phys:0x%llx\n",
+		root_temp.val, root_temp.rsvd1, (u64)root_phys);
+
+	if (!root_present(&root_temp))
+		return -2;
+
+	pr_err("B:D:F=%2.2x:%2.2x:%1.1x root_temp.val: %llx .rsvd1: %llx\n",
+		bus, devfn>>3, devfn&7, root_temp.val, root_temp.rsvd1);
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
+	pr_err("CONTEXT returned: phys:0x%12.12llx hi:0x%16.16llx lo:0x%16.16llx\n",
+		 (u64) context_phys, context_addr->hi, context_addr->lo);
+	return 0;
+}
+
+
+/* Get address_width of iova for a device from old kernel (if device existed) */
+static int
+domain_get_gaw_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int irc;
+	struct context_entry context_temp;
+
+	irc = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (irc < 0)
+		return irc;
+
+	return (int) agaw_to_width(context_get_aw(&context_temp));
+}
+
+
+/* Get domain_id for a device from old kernel (if device existed) */
+static int
+domain_get_did_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int irc;
+	struct context_entry context_temp;
+
+	irc = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (irc < 0)
+		return irc;
+
+	return (int) context_get_did(&context_temp);
+}
+
+
+/* Get adr(top page_table) for a device from old kernel (if device exists) */
+static u64
+domain_get_pgd_from_old_kernel(struct intel_iommu *iommu, struct pci_dev *pdev)
+{
+	int irc;
+	struct context_entry context_temp;
+	u64 phys;
+	u64 virt;
+
+
+	irc = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (irc < 0)
+		return 0;
+	if (!context_get_p(&context_temp))
+		return 0;
+
+	phys = context_get_asr(&context_temp) << VTD_PAGE_SHIFT;
+	pr_err("%s, phys: 0x%16.16llx\n", __func__, (u64) phys);
+	if (!phys)
+		return 0;
+
+	virt = (u64) phys_to_virt(phys);
+	pr_err("%s, virt: 0x%16.16llx\n", __func__, (u64) virt);
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
+	int irc;
+	u32 bus = pdev->bus->number;
+	int devfn = pdev->devfn;
+	struct context_entry context_temp;
+
+	/* Struct so process_page_addr() can accumulate over multiple calls */
+	struct process_page_addr_parms ppa_parms = process_page_addr_parms_init;
+	struct process_page_addr_parms *ppap = &ppa_parms;
+
+
+	pr_err("\nENTER %s, iommu=%d, bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x)\n",
+			__func__, iommu->seq_id, bus, bus, devfn, devfn,
+			devfn >> 3, devfn & 0x3);
+
+	irc = context_get_entry(&context_temp, iommu,
+				pdev->bus->number, pdev->devfn);
+	if (irc < 0) {
+		pr_err("LEAVE %s (No context to process)\n", __func__);
+		return;
+	}
+
+	ppap->domain = domain;
+	ppap->iommu  = iommu;
+	ppap->pdev   = pdev;
+
+	irc = process_context_entry(iommu, &context_temp,
+				    bus, devfn, (void *)ppap);
+
+	ppap->last = 1;			/* Last call -- Clean up */
+	process_page_addr(NULL, 0, 0, 0, bus, 0, 0, (void *)ppap);
+
+	pr_err("LEAVE %s\n", __func__);
+}
+
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
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_err("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
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
+		pr_err("ROOT Bus: %3.3d val: %llx rsvd1: %llx\n",
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
+			pr_err("DID Bus:%3.3d(0x%2.2x) devfn: %3.3d(0x%2.2x) did:%d(0x%4.4x)\n",
+				bus, bus, devfn, devfn, did, did);
+		}
+
+	}
+	free_pgtable_page(root_temp);
+	free_pgtable_page(context_temp);
+	return 0;
+}
+
+
+
+/* ========================================================================
+ * Copy iommu translation tables from old kernel into new  kernel
+ * This set of functions is similar to the "process" set above.
+ * ------------------------------------------------------------------------
+ */
+
+/* List to hold domain values found during the copy operation */
+static struct list_head *device_domain_values_list;
+
+/*
+ * Struct copy_page_addr_parms is used to allow copy_page_addr()
+ * to accumulate values across multiple calls and returns.
+ *
+ * Struct copy_page_addr_parms_init is a constant for initializing
+ * instances of copy_page_addr_parms properly.
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
+	struct dmar_domain *domain;
+	struct intel_iommu *iommu;
+	struct pci_dev     *pdev;
+};
+static struct copy_page_addr_parms copy_page_addr_parms_init = {1, 0};
+
+
+
+static int copy_page_addr(u64 page_addr, u32 shift, u32 bus, u32 devfn,
+				 u64 pte, void *parms)
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
+
+
+#if 0
+		pr_err("DBG::B:D:F=0x%2.2x:0x%2.2x:0x%1.1x Addr:0x%12.12llx Size:0x%12.12llx(%lld) Pte:0x%16.16llx\n",
+			bus, devfn >> 3, devfn & 0x7,
+			page_addr, page_size, page_size, pte);
+#endif
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
+		pr_err("PAGE B:D:F=0x%2.2x:0x%2.2x:0x%1.1x Addr:0x%12.12llx Size:0x%12.12llx(%lld) Pte:0x%16.16llx\n",
+			ppap->bus, ppap->devfn >> 3, ppap->devfn & 0x7,
+			ppap->page_addr,
+			ppap->page_size, ppap->page_size, ppap->pte);
+
+		if (ppap->domain) {
+			pfn_lo = IOVA_PFN(ppap->page_addr);
+			pfn_hi = IOVA_PFN(ppap->page_addr + ppap->page_size);
+			iova_p = reserve_iova(&ppap->domain->iovad,
+						pfn_lo, pfn_hi);
+			if (iova_p)
+				pr_err("RESERVED (0x%16.16lx, 0x%16.16lx) did=0x%4.4x\n",
+					iova_p->pfn_lo, iova_p->pfn_hi,
+					ppap->domain->id);
+		}
+	}
+
+	/* Prepare for a new page */
+	ppap->first     = 0;			/* Not first-time anymore */
+	ppap->bus       = bus;
+	ppap->devfn     = devfn;
+	ppap->shift     = shift;
+	ppap->pte       = pte;
+	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
+
+	ppap->page_addr = page_addr; /* Addr(new page) */
+	ppap->page_size = page_size; /* Size(new page) */
+
+	return 0;
+
+#if 0
+	pr_err("Bus:0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llu(%d)\n",
+		bus, bus, devfn, devfn,  page_addr, page_size, page_size);
+#endif
+
+}
+
+
+/* Recursive function to copy the tree of page tables (max 6 recursions)
+ * Parameter 'shift' controls the recursion
+ */
+static int copy_page_table(struct dma_pte **dma_pte_new_p,
+			   struct dma_pte *dma_pte_phys,
+			   u32 shift, u64 page_addr,
+			   struct intel_iommu *iommu,
+			   u32 bus, u32 devfn, void *ppap)
+{
+	int irc;			/* Integer return code */
+	struct dma_pte *p;		/* Physical adr(each entry) iterator */
+	struct dma_pte *pgt_new_virt;	/* Adr(dma_pte in new kernel) */
+	struct dma_pte *dma_pte_next;	/* Adr(next table down)  */
+	u64 u;				/* index(each entry in page_table) */
+
+	if (shift < 12) {	/* If (already done all levels -- problem) */
+		pr_err("IOMMU ERROR copy_page_table %p\n", dma_pte_phys);
+		pr_err("shift %d, page_addr %16.16llu bus %3.3u devfn %3.3u\n",
+			shift, page_addr, bus, devfn);
+		return 2;		/* return -- this is an error */
+	}
+
+	pr_err("copy_page_table %16.16llx %d %16.16llx bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x)\n",
+		(u64)dma_pte_phys, shift, page_addr,
+		 bus, bus, devfn, devfn, devfn >> 3, devfn & 0x7);
+
+	/* allocate a page table in the new kernel
+	** copy contents from old kernel
+	** then update each entry in the table in the new kernel
+	*/
+
+	pgt_new_virt = (struct dma_pte *)alloc_pgtable_page(iommu->node);
+	if (!pgt_new_virt)
+		return -ENOMEM;
+
+	irc = oldcopy(pgt_new_virt, dma_pte_phys, VTD_PAGE_SIZE);
+	if (irc <= 0)
+		return irc;
+
+	for (u = 0, p = pgt_new_virt; u < 512; u++, p++) {
+
+		if (((p->val & DMA_PTE_READ) == 0) &&
+		    ((p->val & DMA_PTE_WRITE) == 0))
+			continue;
+
+		if (dma_pte_superpage(p) || (shift == 12)) {
+
+			irc = copy_page_addr(page_addr | (u << shift),
+					    shift, bus, devfn, p->val, ppap);
+			if (irc)
+				return irc;
+			continue;
+		}
+
+		irc = copy_page_table(&dma_pte_next,
+				(struct dma_pte *)(p->val & VTD_PAGE_MASK),
+				shift-9, page_addr | (u << shift),
+				iommu, bus, devfn, ppap);
+		if (irc)
+			return irc;
+
+		p->val &= ~VTD_PAGE_MASK;	/* Clear old and set new pgd */
+		p->val |= ((u64)dma_pte_next & VTD_PAGE_MASK);
+	}
+
+	*dma_pte_new_p = (struct dma_pte *)virt_to_phys(pgt_new_virt);
+	__iommu_flush_cache(iommu, pgt_new_virt, VTD_PAGE_SIZE);
+
+#if 0
+	pr_err("Return new page %16.16llx(phys) %16.16llx(virt)\n",
+		(u64)(*dma_pte_new_p), (u64)pgt_new_virt);
+#endif
+	return 0;
+}
+
+
+
+static int copy_context_entry(struct intel_iommu *iommu, u32 bus, u32 devfn,
+			      void *ppap, struct context_entry *ce)
+{
+	int irc;			/* Integer Return Code */
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
+	pr_err("CTXT bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x) hi: %16.16llx lo:%16.16llx\n",
+		bus, bus, devfn, devfn,
+		devfn >> 3, devfn & 0x7, ce->hi, ce->lo);
+
+	if (!context_get_p(ce))		/* If (context not present) */
+		return 0;		/* Skip it */
+
+	pr_err("CTXT bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x) p=%d fpd=%d t=%d asr=%16.16llx aw=%d aval=%d did=0x%4.4x\n",
+		bus, bus, devfn, devfn, devfn >> 3, devfn & 0x7,
+		(int) context_get_p(ce),
+		(int) context_get_fpdi(ce),
+		(int) context_get_t(ce),
+		(u64) context_get_asr(ce),
+		(int) context_get_aw(ce),
+		(int) context_get_aval(ce),
+		(u32) context_get_did(ce));
+
+	info = alloc_devinfo_mem();
+	if (!info)
+		return -ENOMEM;
+	/* info->segment = segment;	 May need this later */
+	info->bus = bus;
+	info->devfn = devfn;
+
+	list_for_each_entry(i, &device_domain_values_list[iommu->seq_id],
+				global) {
+		if (i->domain->id == (int) context_get_did(ce)) {
+			domain = i->domain;
+			pr_err("CTXT bus=%3.3d(0x%2.2x), devfn=%3.3d(0x%2.2x) (0x%2.2x,0x%1.1x Found did=0x%4.4x\n",
+				i->bus, i->bus, i->devfn, i->devfn,
+				i->devfn >> 3, i->devfn & 0x7, i->domain->id);
+			break;
+		}
+	}
+
+	if (!domain) {
+		domain = alloc_domain();
+		if (!domain)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&domain->devices);
+		domain->id = (int) context_get_did(ce);
+		domain->agaw = (int) context_get_aw(ce);
+		domain->pgd = NULL;
+		pr_err("CTXT Allocated new list entry\n");
+	}
+
+	info->domain = domain;
+	list_add(&info->link, &domain->devices);
+	list_add(&info->global, &device_domain_values_list[iommu->seq_id]);
+
+	if (domain->pgd) {
+		asr = virt_to_phys(domain->pgd) >> VTD_PAGE_SHIFT;
+		context_put_asr(ce, asr);
+		return 4;
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
+		irc = copy_page_table(&pgt_new_phys, pgt_old_phys,
+			shift-9, page_addr, iommu, bus, devfn, ppap);
+
+		if (irc)		/* if (problem) bail out */
+			return irc;
+
+		asr = ((unsigned long)(pgt_new_phys)) >> VTD_PAGE_SHIFT;
+		context_put_asr(ce, asr);
+		domain->pgd = phys_to_virt((unsigned long)pgt_new_phys);
+		return 1;
+	}
+
+	if (t == 2)		/* If (Identity mapped pass-through) */
+		return 2;	/*	REVISIT: Skip for now */
+				/* Else ce->t is a Reserved value */
+	return 3;		/*	REVISIT: Skip for now */
+}
+
+
+static int copy_context_entry_table(struct intel_iommu *iommu,
+				    u32 bus, void *ppap,
+				    struct context_entry **context_new_p,
+				    struct context_entry *context_old_phys)
+{
+	int irc = 0;				/* Integer return code */
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
+		pr_err("CONTEXT at virt: 0x%16.16llx\n", (u64) ce);
+
+		irc = copy_context_entry(iommu, bus, devfn, ppap, ce);
+		if (irc == 0)		/* if (Entry not present) */
+			continue;
+		if (irc == 1)		/* If (Identity mapped pass-through) */
+			continue;	/*    REVISIT -- Skip for now */
+		if (irc == 2)		/* If (ce->t was reserved value) */
+			continue;	/*    REVISIT -- Skip for now */
+		if (irc < 0)		/* if (problem) */
+			return irc;
+	}
+
+	*context_new_p = context_new_phys;
+	__iommu_flush_cache(iommu, context_new_virt, VTD_PAGE_SIZE);
+	return 0;
+}
+
+
+
+static int copy_root_entry_table(struct intel_iommu *iommu, void *ppap,
+				 struct root_entry  **root_new_virt_p,
+				 struct root_entry  *root_old_phys)
+{
+	int irc = 0;			/* Integer return code */
+	u32 bus;			/* Index into root-entry-table */
+	struct root_entry  *re;		/* Adr(iterator in new table) */
+	struct root_entry  *root_new_virt;	/* Virt(table in new kernel) */
+	struct context_entry *context_old_phys;	/* Phys(context table entry) */
+	struct context_entry *context_new_phys;	/* Phys(new context_entry) */
+
+	/* allocate a root-entry table in the new kernel
+	** copy contents from old kernel
+	** then update each entry in the table in the new kernel
+	*/
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
+		pr_err("ROOT Bus: %3.3d re->val: %llx rsvd1: %llx\n",
+			bus, re->val, re->rsvd1);
+
+		context_old_phys = get_context_phys_from_root(re);
+
+		if (!context_old_phys)
+			continue;
+
+		irc = copy_context_entry_table(iommu, bus, ppap,
+						&context_new_phys,
+						context_old_phys);
+		if (irc)
+			return irc;
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
+
+/* Interface to the "copy translation tables" set of functions from portions
+ * of existing code.
+ */
+static int copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
+		struct root_entry **root_old_phys_p,
+		struct root_entry **root_new_virt_p)
+{
+	struct intel_iommu *iommu;	/* Virt(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys(entry in old kernel) */
+	struct root_entry *root_new;	/* Virt(table in new kernel) */
+	int irc = 0;			/* Integer return code */
+	int i = 0;			/* Loop index */
+
+	/* Structure so copy_page_addr() can accumulate things
+	 * over multiple calls and returns
+	 */
+	struct copy_page_addr_parms ppa_parms = copy_page_addr_parms_init;
+	struct copy_page_addr_parms *ppap = &ppa_parms;
+
+
+	pr_err("copy_intel_iommu_translation_tables ENTER\n");
+
+	iommu = drhd->iommu;
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_err("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
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
+	irc = copy_root_entry_table(iommu, ppap, &root_new, root_phys);
+	if (irc)
+		return irc;
+
+
+	ppa_parms.last = 1;
+	copy_page_addr(0, 0, 0, 0, 0, ppap);
+	*root_new_virt_p = root_new;			/* Returned to caller */
+
+	/* The translation tables in the new kernel should now contain
+	 * the same translations as the tables in the old kernel.
+	 * This will allow us to update the iommu hdw to use the new tables.
+	 *
+	 * NOTE: Neither the iommu hardware nor the iommu->root_entry
+	 *       is updated herein. These are left for the caller to do.
+	 */
+
+	{	/* Dump the new root-entry table on the console */
+		u64 *p;
+		int  i;
+
+		pr_err("ROOT_ENTRY TABLE (NEW) START\n");
+
+		for (p = (void *)root_new, i = 0; i < 256; p += 2, i++)
+			if (p[1] != 0 || p[0] != 0 || i == 255)
+				pr_err("i:%3.3d, p:0x%12.12llx %16.16llx %16.16llx\n",
+					i, (u64)p, p[1], p[0]);
+
+		pr_err("ROOT_ENTRY TABLE (NEW) END\n");
+	}
+	pr_err("copy_intel_iommu_translation_tables LEAVE\n");
+	return 0;
+}
+
+
+
+
+
+/* ========================================================================
+ * Diagnostic code
+ * Test copy iommu translation tables from old kernel into new kernel.
+ * Then compare the translations in the two sets of table trees.
+ * (For development, testing, and diagnostic use)
+ * ------------------------------------------------------------------------
+ */
+#if 0	/* TEMPORARY: Unavailable (compare function is broken) */
+static int test_copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd)
+{
+	int irc;				/* Integer Return Code */
+	struct root_entry *root_old_phys;	/* Adr(Phys in old kernel) */
+	struct root_entry *root_new_virt;	/* Adr(Virt in new kernel) */
+	struct root_entry *root_new_phys;	/* Adr(Phys in new kernel) */
+
+	pr_err("test_copy_intel_iommu_translation_tables ENTER\n");
+
+	irc = copy_intel_iommu_translation_tables(drhd, &root_old_phys,
+						  &root_new_virt);
+	if (irc) {
+		pr_err("TEST COPY irc=%d: LEAVE\n", irc);
+		return irc;
+	}
+
+	root_new_phys = (struct root_entry *) root_new_virt;
+
+	irc = compare_intel_iommu_translation_tables(root_old_phys,
+						     root_new_phys);
+	if (irc) {
+		pr_err("TEST COMPARE irc=%d: LEAVE\n", irc);
+		return irc;
+	}
+
+	pr_err("test_copy_intel_iommu_translation_tables LEAVE\n");
+	return irc;
+}
+#endif
+
+
+/* =========================================================================
+ * Diagnostic print
+ * ------------------------------------------------------------------------
+ */
+
+static struct intel_iommu_register_print {
+	int	len;		/* Length of register */
+	int	idx;		/* Index to read register */
+	char	reg[20];	/* Linux name of register */
+	char	txt[40];	/* Description */
+} intel_iommu_register_print_v[] = {
+	{1, DMAR_VER_REG,	"DMAR_VER_REG",		"Arch version supported by this IOMMU"},
+	{2, DMAR_CAP_REG,	"DMAR_CAP_REG",		"Hardware supported capabilities"},
+	{2, DMAR_ECAP_REG,	"DMAR_ECAP_REG",	"Extended capabilities supported"},
+	{1, DMAR_GCMD_REG,	"DMAR_GCMD_REG",	"Global command register"},
+	{1, DMAR_GSTS_REG,	"DMAR_GSTS_REG",	"Global status register "},
+	{2, DMAR_RTADDR_REG,	"DMAR_RTADDR_REG",	"Root entry table"},
+	{2, DMAR_CCMD_REG,	"DMAR_CCMD_REG",	"Context command reg"},
+	{1, DMAR_FSTS_REG,	"DMAR_FSTS_REG",	"Fault Status register"},
+	{1, DMAR_FECTL_REG,	"DMAR_FECTL_REG",	"Fault control register"},
+	{1, DMAR_FEDATA_REG,	"DMAR_FEDATA_REG",	"Fault event interrupt data register"},
+	{1, DMAR_FEADDR_REG,	"DMAR_FEADDR_REG",	"Fault event interrupt addr register"},
+	{1, DMAR_FEUADDR_REG,	"DMAR_FEUADDR_REG",	"Upper address register"},
+	{2, DMAR_AFLOG_REG,	"DMAR_AFLOG_REG",	"Advanced Fault control"},
+	{1, DMAR_PMEN_REG,	"DMAR_PMEN_REG",	"Enable Protected Memory Region"},
+	{1, DMAR_PLMBASE_REG,	"DMAR_PLMBASE_REG",	"PMRR Low addr"},
+	{1, DMAR_PLMLIMIT_REG,	"DMAR_PLMLIMIT_REG",	"PMRR low limit"},
+	{2, DMAR_PHMBASE_REG,	"DMAR_PHMBASE_REG",	"pmrr high base addr"},
+	{2, DMAR_PHMLIMIT_REG,	"DMAR_PHMLIMIT_REG",	"pmrr high limit"},
+	{2, DMAR_IQH_REG,	"DMAR_IQH_REG",		"Invalidation queue head register"},
+	{2, DMAR_IQT_REG,	"DMAR_IQT_REG",		"Invalidation queue tail register"},
+	{2, DMAR_IQA_REG,	"DMAR_IQA_REG",		"Invalidation queue addr register"},
+	{1, DMAR_ICS_REG,	"DMAR_ICS_REG",		"Invalidation complete status register"},
+	{2, DMAR_IRTA_REG,	"DMAR_IRTA_REG",	"Interrupt remapping table addr register"},
+};
+
+static void print_intel_iommu_registers(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;	/* Virt adr(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	u32 ver;			/* DMAR_VER_REG */
+
+	int m = sizeof(intel_iommu_register_print_v) /
+		sizeof(intel_iommu_register_print_v[0]);
+	struct intel_iommu_register_print *p = &intel_iommu_register_print_v[0];
+
+	iommu = drhd->iommu;
+
+	pr_err("%s ENTER\n", __func__);
+	ver = readl(iommu->reg + DMAR_VER_REG);
+	pr_err("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
+		iommu->seq_id,
+		(unsigned long long)drhd->reg_base_addr,
+		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
+		(unsigned long long)iommu->cap,
+		(unsigned long long)iommu->ecap);
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_err("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+
+	for (; p < &intel_iommu_register_print_v[m]; p++)
+		if (p->len == 2)
+			pr_err("0x%16.16llx %-20s %-40s\n",
+				(u64)readq(iommu->reg + p->idx), p->reg,
+						p->txt);
+		else
+			pr_err("        0x%8.8x %-20s %-40s\n",
+				(u32)readl(iommu->reg + p->idx), p->reg,
+						p->txt);
+
+	pr_err("%s LEAVE\n", __func__);
+}
+
+#if 0
+/* ==========================================================================
+ * This area under construction
+ * --------------------------------------------------------------------------
+ */
+
+static void print_root_entry(int bus, struct root_entry *re)
+{
+	pr_err("b:%2.2x, re:%12.12llx %16.16llx %16.16llx ctp:%12.12llx, p:%1.1x\n",
+		b, (u64)re, re->rsvd1, re->val,
+		(u64)get_context_addr_from_root(re),
+		(u32)root_present(re));
+}
+
+static void print_context_entry(int bus, int devfn, struct context_entry *ce)
+{
+	pr_err("B:D:F=0x%2.2x:0x%2.2x:0x%1.1x re:%12.12llx %16.16llx %16.16llx did=0x%4.4x aval=%d aw=%d asr=%12.12llx t=%d fpd=%d p=%d\n",
+		bus, devfn >> 3, devfn & 0x7, (u64)ce, (u64)ce->hi, (u64)ce->lo,
+		(u32) context_get_did(ce),
+		(int) context_get_aval(ce),
+		(int) context_get_aw(ce),
+		(u64) context_get_asr(ce),
+		(int) context_get_t(ce),
+		(int) context_get_fpd(ce),
+		(int) context_get_p(ce));
+}
+
+static void print_context_entry_table(bus, struct context_entry *ctxt_virt)
+{
+	struct context_entry *ce;
+	int d;
+
+	pr_err("CONTEXT_ENTRY TABLE at: %0x%12.12llx START\n", ctxt_virt);
+	for (ce = (void *)ctxt_virt, d = 0; d < 256; ce++, d++)
+		if (ce->hi != 0 || ce->lo != 0)
+			print_context_entry(b, d, ce);
+	pr_err("CONTEXT_ENTRY TABLE at: %0x%12.12llx END\n", ctxt_virt);
+}
+
+
+
+static void print_dma_pte(int bus, int devfn, struct dma_pte *pte)
+{
+	u8  tm  = pte->val >> 61 & 0x1;
+	u64 adr = pte->val <<  2 >> 14;
+	u8  snp = pte->val >> 11 & 0x1;
+	u8  sp  = pte->val >>  7 & 0x1;
+	u8  w   = pte->val >>  1 & 0x1;
+	u8  r   = pte->val >>  0 & 0x1;
+
+	pr_err("B:D:F=0x%2.2x:0x%2.2x:0x%1.1x pt:0x%12.12llx 0x%16.16llx tm: %1.1x adr:0x%12.12llx snp:%1.1x sp:%1.1x w:%1.1x r:%1.1x\n",
+		bus, devfn>>3, devfn&7,
+		(u64)pte, pte->val, tm, adr, snp, sp, w, r);
+}
+
+
+
+static int hexdump_intel_iommu_translation_tables(struct root_entry *root_phys)
+{	/* Dump the root-entry table on the console */
+	struct root_entry *re;
+	int  b;			/* bus: index to root_entry table */
+	struct context_entry *ce;
+	int d;			/* devfn: index to context_entry table */
+	struct dma_pte *pt;
+	int i;			/* index to dma_pte tables */
+
+
+	pr_err("ROOT_ENTRY TABLE at: %0x%12.12llx START\n", root_virt);
+	for (re = (void *)root_virt, b = 0; b < 256; re++, b++)
+		if (re->val != 0 || re->rsvd1 != 0)
+			print_root_entry(b, re);
+	pr_err("ROOT_ENTRY TABLE at: %0x%12.12llx END\n", root_virt);
+
+	for (re = (void *)root_virt, b = 0; b < 256; re++, b++) {
+		ce_phys = get_context_addr_from_root(re);
+		if (!ce_phys)
+			continue;
+		ce = phys_to_virt(ce_phys);
+		print_context_entry_table(b, ce);
+	}
+
+
+
+
+
+	for (re = (void *)root_virt, b = 0; b < 256; re++, b++)
+		for (ce = (void *)ctxt_virt, d = 0; d < 256; ce++, d++)
+			print_dma_pte(b, d, pt);
+
+
+	return 0;
+}
+
+/* ----------------------------
+ * End Area Under Construction
+ * ----------------------------
+ */
+#endif
+
+
+
+
+#endif /* CONFIG_CRASH_DUMP */
+
+
+
-- 
1.7.1

