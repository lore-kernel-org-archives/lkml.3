Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDYAi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:38:27 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:20582 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaDYAiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:38:24 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com, jerry.hoemann@hp.com
Subject: [PATCH 8/8] iommu/vt-d: Changes to support kdump
Date: Thu, 24 Apr 2014 18:36:38 -0600
Message-Id: <1398386198-19304-9-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add "#include <linux/crash_dump.h>" to gain access to is_kdump_kernel()

 Modify the operation of the following functions when called during crash dump:
 device_to_domain_id
 get_domain_for_dev
 init_dmars
 intel_iommu_init

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 133 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 120 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 226c1d0..8b3e509 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -46,6 +46,7 @@
 #include "irq_remapping.h"
 #include "pci.h"
 #include "intel-iommu-private.h"
+#include <linux/crash_dump.h>
 
 static LIST_HEAD(dmar_atsr_units);
 static LIST_HEAD(dmar_rmrr_units);
@@ -53,6 +54,7 @@ static LIST_HEAD(dmar_rmrr_units);
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
+static int intel_iommu_in_crashdump;
 
 static void __init check_tylersburg_isoch(void);
 
@@ -1796,6 +1798,24 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
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
  * Note: we use struct device->archdata.iommu stores the info
@@ -1880,6 +1900,9 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	unsigned long flags;
 	u8 bus, devfn, bridge_bus, bridge_devfn;
 	int did = -1;   /* Default to "no domain_id supplied" */
+#ifdef CONFIG_CRASH_DUMP
+	struct domain_values_entry *dve = NULL;
+#endif /* CONFIG_CRASH_DUMP */
 
 	domain = find_domain(dev);
 	if (domain)
@@ -1920,6 +1943,24 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	domain = alloc_domain(false);
 	if (!domain)
 		goto error;
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
 	if (iommu_attach_domain(domain, iommu, did)) {
 		free_domain_mem(domain);
 		domain = NULL;
@@ -1929,6 +1970,18 @@ static struct dmar_domain *get_domain_for_dev(struct device *dev, int gaw)
 	if (domain_init(domain, gaw))
 		goto error;
 
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
 		domain = dmar_insert_dev_info(iommu, bridge_bus, bridge_devfn,
@@ -2331,6 +2384,10 @@ static int __init init_dmars(void)
 	struct device *dev;
 	struct intel_iommu *iommu;
 	int i, ret;
+#ifdef CONFIG_CRASH_DUMP
+	struct root_entry *root_old_phys;
+	struct root_entry *root_new_virt;
+#endif /* CONFIG_CRASH_DUMP */
 
 	/*
 	 * for each drhd
@@ -2374,16 +2431,40 @@ static int __init init_dmars(void)
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
+				printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+				goto free_iommu;
+			}
+#ifdef CONFIG_CRASH_DUMP
 		}
+#endif /* CONFIG_CRASH_DUMP */
+
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
@@ -2442,6 +2523,16 @@ static int __init init_dmars(void)
 
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
@@ -2482,6 +2573,10 @@ static int __init init_dmars(void)
 
 	iommu_prepare_isa();
 
+#ifdef CONFIG_CRASH_DUMP
+skip_new_domains_for_si_rmrr_isa:;
+#endif /* CONFIG_CRASH_DUMP */
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -3624,12 +3719,24 @@ int __init intel_iommu_init(void)
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

