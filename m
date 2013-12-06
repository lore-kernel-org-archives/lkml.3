Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3LFDVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:21:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3LFDVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986940"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiri Kosina <trivial@kernel.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org
Subject: [Patch Part1 V2 11/20] iommu/vt-d, trivial: simplify code with existing macros
Date: Fri,  6 Dec 2013 11:21:14 +0800
Message-Id: <1386300083-6882-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify vt-d related code with existing macros and introduce a new
macro for_each_active_drhd_unit() to enumerate all active DRHD unit.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c                |    7 ++---
 drivers/iommu/intel-iommu.c         |   55 ++++++++---------------------------
 drivers/iommu/intel_irq_remapping.c |   31 +++++++-------------
 include/linux/dmar.h                |    4 +++
 4 files changed, 29 insertions(+), 68 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 4bbd972..99fb0c2 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1313,15 +1313,14 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 int __init enable_drhd_fault_handling(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 
 	/*
 	 * Enable fault control interrupt.
 	 */
-	for_each_drhd_unit(drhd) {
-		int ret;
-		struct intel_iommu *iommu = drhd->iommu;
+	for_each_iommu(iommu, drhd) {
 		u32 fault_status;
-		ret = dmar_set_interrupt(iommu);
+		int ret = dmar_set_interrupt(iommu);
 
 		if (ret) {
 			pr_err("DRHD %Lx: failed to enable fault, interrupt, ret %d\n",
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b5f13e4..0ec49da 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -628,9 +628,7 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 	struct dmar_drhd_unit *drhd = NULL;
 	int i;
 
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
+	for_each_active_drhd_unit(drhd) {
 		if (segment != drhd->segment)
 			continue;
 
@@ -2467,11 +2465,7 @@ static int __init init_dmars(void)
 		goto error;
 	}
 
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
-
-		iommu = drhd->iommu;
+	for_each_active_iommu(iommu, drhd) {
 		g_iommus[iommu->seq_id] = iommu;
 
 		ret = iommu_init_domains(iommu);
@@ -2495,12 +2489,7 @@ static int __init init_dmars(void)
 	/*
 	 * Start from the sane iommu hardware state.
 	 */
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
-
-		iommu = drhd->iommu;
-
+	for_each_active_iommu(iommu, drhd) {
 		/*
 		 * If the queued invalidation is already initialized by us
 		 * (for example, while enabling interrupt-remapping) then
@@ -2520,12 +2509,7 @@ static int __init init_dmars(void)
 		dmar_disable_qi(iommu);
 	}
 
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
-
-		iommu = drhd->iommu;
-
+	for_each_active_iommu(iommu, drhd) {
 		if (dmar_enable_qi(iommu)) {
 			/*
 			 * Queued Invalidate not enabled, use Register Based
@@ -2608,17 +2592,16 @@ static int __init init_dmars(void)
 	 *   global invalidate iotlb
 	 *   enable translation
 	 */
-	for_each_drhd_unit(drhd) {
+	for_each_iommu(iommu, drhd) {
 		if (drhd->ignored) {
 			/*
 			 * we always have to disable PMRs or DMA may fail on
 			 * this device
 			 */
 			if (force_on)
-				iommu_disable_protect_mem_regions(drhd->iommu);
+				iommu_disable_protect_mem_regions(iommu);
 			continue;
 		}
-		iommu = drhd->iommu;
 
 		iommu_flush_write_buffer(iommu);
 
@@ -2640,12 +2623,8 @@ static int __init init_dmars(void)
 
 	return 0;
 error:
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
-		iommu = drhd->iommu;
+	for_each_active_iommu(iommu, drhd)
 		free_iommu(iommu);
-	}
 	kfree(g_iommus);
 	return ret;
 }
@@ -3293,9 +3272,9 @@ static void __init init_no_remapping_devices(void)
 		}
 	}
 
-	for_each_drhd_unit(drhd) {
+	for_each_active_drhd_unit(drhd) {
 		int i;
-		if (drhd->ignored || drhd->include_all)
+		if (drhd->include_all)
 			continue;
 
 		for (i = 0; i < drhd->devices_cnt; i++)
@@ -3644,6 +3623,7 @@ int __init intel_iommu_init(void)
 {
 	int ret = 0;
 	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
@@ -3657,16 +3637,9 @@ int __init intel_iommu_init(void)
 	/*
 	 * Disable translation if already enabled prior to OS handover.
 	 */
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu;
-
-		if (drhd->ignored)
-			continue;
-
-		iommu = drhd->iommu;
+	for_each_active_iommu(iommu, drhd)
 		if (iommu->gcmd & DMA_GCMD_TE)
 			iommu_disable_translation(iommu);
-	}
 
 	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
@@ -3909,11 +3882,7 @@ static void iommu_free_vm_domain(struct dmar_domain *domain)
 	unsigned long i;
 	unsigned long ndomains;
 
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
-		iommu = drhd->iommu;
-
+	for_each_active_iommu(iommu, drhd) {
 		ndomains = cap_ndoms(iommu->cap);
 		for_each_set_bit(i, iommu->domain_ids, ndomains) {
 			if (iommu->domains[i] == domain) {
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 50fd55c..7b4bdaa 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -520,6 +520,7 @@ static int __init dmar_x2apic_optout(void)
 static int __init intel_irq_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 
 	if (disable_irq_remap)
 		return 0;
@@ -538,12 +539,9 @@ static int __init intel_irq_remapping_supported(void)
 	if (!dmar_ir_support())
 		return 0;
 
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu = drhd->iommu;
-
+	for_each_iommu(iommu, drhd)
 		if (!ecap_ir_support(iommu->ecap))
 			return 0;
-	}
 
 	return 1;
 }
@@ -551,6 +549,7 @@ static int __init intel_irq_remapping_supported(void)
 static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 	bool x2apic_present;
 	int setup = 0;
 	int eim = 0;
@@ -571,9 +570,7 @@ static int __init intel_enable_irq_remapping(void)
 				"Use 'intremap=no_x2apic_optout' to override BIOS request.\n");
 	}
 
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu = drhd->iommu;
-
+	for_each_iommu(iommu, drhd) {
 		/*
 		 * If the queued invalidation is already initialized,
 		 * shouldn't disable it.
@@ -598,9 +595,7 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * check for the Interrupt-remapping support
 	 */
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu = drhd->iommu;
-
+	for_each_iommu(iommu, drhd) {
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
@@ -614,10 +609,8 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * Enable queued invalidation for all the DRHD's.
 	 */
-	for_each_drhd_unit(drhd) {
-		int ret;
-		struct intel_iommu *iommu = drhd->iommu;
-		ret = dmar_enable_qi(iommu);
+	for_each_iommu(iommu, drhd) {
+		int ret = dmar_enable_qi(iommu);
 
 		if (ret) {
 			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
@@ -630,9 +623,7 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * Setup Interrupt-remapping for all the DRHD's now.
 	 */
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu = drhd->iommu;
-
+	for_each_iommu(iommu, drhd) {
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
@@ -776,19 +767,17 @@ static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
 static int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 	int ir_supported = 0;
 	int ioapic_idx;
 
-	for_each_drhd_unit(drhd) {
-		struct intel_iommu *iommu = drhd->iommu;
-
+	for_each_iommu(iommu, drhd)
 		if (ecap_ir_support(iommu->ecap)) {
 			if (ir_parse_ioapic_hpet_scope(drhd->hdr, iommu))
 				return -1;
 
 			ir_supported = 1;
 		}
-	}
 
 	if (!ir_supported)
 		return 0;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index f614357..bd5026b 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -53,6 +53,10 @@ extern struct list_head dmar_drhd_units;
 #define for_each_drhd_unit(drhd) \
 	list_for_each_entry(drhd, &dmar_drhd_units, list)
 
+#define for_each_active_drhd_unit(drhd)					\
+	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
+		if (drhd->ignored) {} else
+
 #define for_each_active_iommu(i, drhd)					\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
 		if (i=drhd->iommu, drhd->ignored) {} else
-- 
1.7.10.4

