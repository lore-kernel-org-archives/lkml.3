Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaILCIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:08:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:3016 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaILCIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="590198492"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part3 V5 7/8] iommu/vt-d: Enhance intel-iommu driver to support DMAR unit hotplug
Date: Fri, 12 Sep 2014 10:10:47 +0800
Message-Id: <1410487848-6027-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement required callback functions for intel-iommu driver
to support DMAR unit hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |  206 +++++++++++++++++++++++++++++++------------
 1 file changed, 151 insertions(+), 55 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 70d9d47eaeda..c2d369524960 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1125,8 +1125,11 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 	unsigned long flags;
 
 	root = (struct root_entry *)alloc_pgtable_page(iommu->node);
-	if (!root)
+	if (!root) {
+		pr_err("IOMMU: allocating root entry for %s failed\n",
+			iommu->name);
 		return -ENOMEM;
+	}
 
 	__iommu_flush_cache(iommu, root, ROOT_SIZE);
 
@@ -1466,7 +1469,7 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	return 0;
 }
 
-static void free_dmar_iommu(struct intel_iommu *iommu)
+static void disable_dmar_iommu(struct intel_iommu *iommu)
 {
 	struct dmar_domain *domain;
 	int i;
@@ -1490,11 +1493,16 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 	if (iommu->gcmd & DMA_GCMD_TE)
 		iommu_disable_translation(iommu);
+}
 
-	kfree(iommu->domains);
-	kfree(iommu->domain_ids);
-	iommu->domains = NULL;
-	iommu->domain_ids = NULL;
+static void free_dmar_iommu(struct intel_iommu *iommu)
+{
+	if ((iommu->domains) && (iommu->domain_ids)) {
+		kfree(iommu->domains);
+		kfree(iommu->domain_ids);
+		iommu->domains = NULL;
+		iommu->domain_ids = NULL;
+	}
 
 	g_iommus[iommu->seq_id] = NULL;
 
@@ -2701,6 +2709,41 @@ static int __init iommu_prepare_static_identity_mapping(int hw)
 	return 0;
 }
 
+static void intel_iommu_init_qi(struct intel_iommu *iommu)
+{
+	/*
+	 * Start from the sane iommu hardware state.
+	 * If the queued invalidation is already initialized by us
+	 * (for example, while enabling interrupt-remapping) then
+	 * we got the things already rolling from a sane state.
+	 */
+	if (!iommu->qi) {
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(-1, iommu);
+		/*
+		 * Disable queued invalidation if supported and already enabled
+		 * before OS handover.
+		 */
+		dmar_disable_qi(iommu);
+	}
+
+	if (dmar_enable_qi(iommu)) {
+		/*
+		 * Queued Invalidate not enabled, use Register Based Invalidate
+		 */
+		iommu->flush.flush_context = __iommu_flush_context;
+		iommu->flush.flush_iotlb = __iommu_flush_iotlb;
+		pr_info("IOMMU: %s using Register based invalidation\n",
+			iommu->name);
+	} else {
+		iommu->flush.flush_context = qi_flush_context;
+		iommu->flush.flush_iotlb = qi_flush_iotlb;
+		pr_info("IOMMU: %s using Queued invalidation\n", iommu->name);
+	}
+}
+
 static int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2729,6 +2772,10 @@ static int __init init_dmars(void)
 			  DMAR_UNITS_SUPPORTED);
 	}
 
+	/* Preallocate enough resources for IOMMU hot-addition */
+	if (g_num_of_iommus < DMAR_UNITS_SUPPORTED)
+		g_num_of_iommus = DMAR_UNITS_SUPPORTED;
+
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
 			GFP_KERNEL);
 	if (!g_iommus) {
@@ -2757,58 +2804,14 @@ static int __init init_dmars(void)
 		 * among all IOMMU's. Need to Split it later.
 		 */
 		ret = iommu_alloc_root_entry(iommu);
-		if (ret) {
-			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+		if (ret)
 			goto free_iommu;
-		}
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
 	}
 
-	/*
-	 * Start from the sane iommu hardware state.
-	 */
-	for_each_active_iommu(iommu, drhd) {
-		/*
-		 * If the queued invalidation is already initialized by us
-		 * (for example, while enabling interrupt-remapping) then
-		 * we got the things already rolling from a sane state.
-		 */
-		if (iommu->qi)
-			continue;
-
-		/*
-		 * Clear any previous faults.
-		 */
-		dmar_fault(-1, iommu);
-		/*
-		 * Disable queued invalidation if supported and already enabled
-		 * before OS handover.
-		 */
-		dmar_disable_qi(iommu);
-	}
-
-	for_each_active_iommu(iommu, drhd) {
-		if (dmar_enable_qi(iommu)) {
-			/*
-			 * Queued Invalidate not enabled, use Register Based
-			 * Invalidate
-			 */
-			iommu->flush.flush_context = __iommu_flush_context;
-			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Register based "
-			       "invalidation\n",
-				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
-		} else {
-			iommu->flush.flush_context = qi_flush_context;
-			iommu->flush.flush_iotlb = qi_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued "
-			       "invalidation\n",
-				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
-		}
-	}
+	for_each_active_iommu(iommu, drhd)
+		intel_iommu_init_qi(iommu);
 
 	if (iommu_pass_through)
 		iommu_identity_mapping |= IDENTMAP_ALL;
@@ -2894,8 +2897,10 @@ static int __init init_dmars(void)
 	return 0;
 
 free_iommu:
-	for_each_active_iommu(iommu, drhd)
+	for_each_active_iommu(iommu, drhd) {
+		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
+	}
 	kfree(deferred_flush);
 free_g_iommus:
 	kfree(g_iommus);
@@ -3801,9 +3806,100 @@ int dmar_check_one_atsr(struct acpi_dmar_header *hdr, void *arg)
 	return 0;
 }
 
+static int intel_iommu_add(struct dmar_drhd_unit *dmaru)
+{
+	int sp, ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (g_iommus[iommu->seq_id])
+		return 0;
+
+	if (hw_pass_through && !ecap_pass_through(iommu->ecap)) {
+		pr_warn("IOMMU: %s doesn't support hardware pass through.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+	if (!ecap_sc_support(iommu->ecap) &&
+	    domain_update_iommu_snooping(iommu)) {
+		pr_warn("IOMMU: %s doesn't support snooping.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+	sp = domain_update_iommu_superpage(iommu) - 1;
+	if (sp >= 0 && !(cap_super_page_val(iommu->cap) & (1 << sp))) {
+		pr_warn("IOMMU: %s doesn't support large page.\n",
+			iommu->name);
+		return -ENXIO;
+	}
+
+	/*
+	 * Disable translation if already enabled prior to OS handover.
+	 */
+	if (iommu->gcmd & DMA_GCMD_TE)
+		iommu_disable_translation(iommu);
+
+	g_iommus[iommu->seq_id] = iommu;
+	ret = iommu_init_domains(iommu);
+	if (ret == 0)
+		ret = iommu_alloc_root_entry(iommu);
+	if (ret)
+		goto out;
+
+	if (dmaru->ignored) {
+		/*
+		 * we always have to disable PMRs or DMA may fail on this device
+		 */
+		if (force_on)
+			iommu_disable_protect_mem_regions(iommu);
+		return 0;
+	}
+
+	intel_iommu_init_qi(iommu);
+	iommu_flush_write_buffer(iommu);
+	ret = dmar_set_interrupt(iommu);
+	if (ret)
+		goto disable_iommu;
+
+	iommu_set_root_entry(iommu);
+	iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
+	iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
+	iommu_enable_translation(iommu);
+
+	if (si_domain) {
+		ret = iommu_attach_domain(si_domain, iommu);
+		if (ret < 0 || si_domain->id != ret)
+			goto disable_iommu;
+		domain_attach_iommu(si_domain, iommu);
+	}
+
+	iommu_disable_protect_mem_regions(iommu);
+	return 0;
+
+disable_iommu:
+	disable_dmar_iommu(iommu);
+out:
+	free_dmar_iommu(iommu);
+	return ret;
+}
+
 int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
 {
-	return intel_iommu_enabled ? -ENOSYS : 0;
+	int ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (!intel_iommu_enabled)
+		return 0;
+	if (iommu == NULL)
+		return -EINVAL;
+
+	if (insert) {
+		ret = intel_iommu_add(dmaru);
+	} else {
+		disable_dmar_iommu(iommu);
+		free_dmar_iommu(iommu);
+	}
+
+	return ret;
 }
 
 static void intel_iommu_free_dmars(void)
-- 
1.7.10.4

