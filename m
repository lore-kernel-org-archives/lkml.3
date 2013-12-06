Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3LFDVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:21:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab3LFDVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325987037"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 20/20] iommu/vt-d: free all resources if failed to initialize DMARs
Date: Fri,  6 Dec 2013 11:21:23 +0800
Message-Id: <1386300083-6882-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance intel_iommu_init() to free all resources if failed to
initialize DMAR hardware.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   80 ++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 87ea78b..27b270b4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2612,6 +2612,7 @@ static int __init init_dmars(void)
 error:
 	for_each_active_iommu(iommu, drhd)
 		free_dmar_iommu(iommu);
+	kfree(deferred_flush);
 	kfree(g_iommus);
 	g_iommus = NULL;
 	return ret;
@@ -3456,18 +3457,12 @@ static int __init
 rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 {
 	struct acpi_dmar_reserved_memory *rmrr;
-	int ret;
 
 	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
-	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + rmrr->header.length,
-		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
-
-	if (ret || (rmrru->devices_cnt == 0)) {
-		list_del(&rmrru->list);
-		kfree(rmrru);
-	}
-	return ret;
+	return dmar_parse_dev_scope((void *)(rmrr + 1),
+				    ((void *)rmrr) + rmrr->header.length,
+				    &rmrru->devices_cnt, &rmrru->devices,
+				    rmrr->segment);
 }
 
 static LIST_HEAD(dmar_atsr_units);
@@ -3492,23 +3487,38 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
 {
-	int rc;
 	struct acpi_dmar_atsr *atsr;
 
 	if (atsru->include_all)
 		return 0;
 
 	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-	rc = dmar_parse_dev_scope((void *)(atsr + 1),
-				(void *)atsr + atsr->header.length,
-				&atsru->devices_cnt, &atsru->devices,
-				atsr->segment);
-	if (rc || !atsru->devices_cnt) {
-		list_del(&atsru->list);
-		kfree(atsru);
+	return dmar_parse_dev_scope((void *)(atsr + 1),
+				    (void *)atsr + atsr->header.length,
+				    &atsru->devices_cnt, &atsru->devices,
+				    atsr->segment);
+}
+
+static void intel_iommu_free_atsr(struct dmar_atsr_unit *atsru)
+{
+	dmar_free_dev_scope(&atsru->devices, &atsru->devices_cnt);
+	list_del(&atsru->list);
+	kfree(atsru);
+}
+
+static void intel_iommu_free_dmars(void)
+{
+	struct dmar_rmrr_unit *rmrru, *rmrr_n;
+	struct dmar_atsr_unit *atsru, *atsr_n;
+
+	list_for_each_entry_safe(rmrru, rmrr_n, &dmar_rmrr_units, list) {
+		dmar_free_dev_scope(&rmrru->devices, &rmrru->devices_cnt);
+		list_del(&rmrru->list);
+		kfree(rmrru);
 	}
 
-	return rc;
+	list_for_each_entry_safe(atsru, atsr_n, &dmar_atsr_units, list)
+		intel_iommu_free_atsr(atsru);
 }
 
 int dmar_find_matched_atsr_unit(struct pci_dev *dev)
@@ -3552,17 +3562,17 @@ found:
 
 int __init dmar_parse_rmrr_atsr_dev(void)
 {
-	struct dmar_rmrr_unit *rmrr, *rmrr_n;
-	struct dmar_atsr_unit *atsr, *atsr_n;
+	struct dmar_rmrr_unit *rmrr;
+	struct dmar_atsr_unit *atsr;
 	int ret = 0;
 
-	list_for_each_entry_safe(rmrr, rmrr_n, &dmar_rmrr_units, list) {
+	list_for_each_entry(rmrr, &dmar_rmrr_units, list) {
 		ret = rmrr_parse_dev(rmrr);
 		if (ret)
 			return ret;
 	}
 
-	list_for_each_entry_safe(atsr, atsr_n, &dmar_atsr_units, list) {
+	list_for_each_entry(atsr, &dmar_atsr_units, list) {
 		ret = atsr_parse_dev(atsr);
 		if (ret)
 			return ret;
@@ -3609,7 +3619,7 @@ static struct notifier_block device_nb = {
 
 int __init intel_iommu_init(void)
 {
-	int ret = 0;
+	int ret = -ENODEV;
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 
@@ -3619,7 +3629,7 @@ int __init intel_iommu_init(void)
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
-		return 	-ENODEV;
+		goto out_free_dmar;
 	}
 
 	/*
@@ -3632,16 +3642,16 @@ int __init intel_iommu_init(void)
 	if (dmar_dev_scope_init() < 0) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR device scope\n");
-		return 	-ENODEV;
+		goto out_free_dmar;
 	}
 
 	if (no_iommu || dmar_disabled)
-		return -ENODEV;
+		goto out_free_dmar;
 
 	if (iommu_init_mempool()) {
 		if (force_on)
 			panic("tboot: Failed to initialize iommu memory\n");
-		return 	-ENODEV;
+		goto out_free_dmar;
 	}
 
 	if (list_empty(&dmar_rmrr_units))
@@ -3653,7 +3663,7 @@ int __init intel_iommu_init(void)
 	if (dmar_init_reserved_ranges()) {
 		if (force_on)
 			panic("tboot: Failed to reserve iommu ranges\n");
-		return 	-ENODEV;
+		goto out_free_mempool;
 	}
 
 	init_no_remapping_devices();
@@ -3663,9 +3673,7 @@ int __init intel_iommu_init(void)
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
-		put_iova_domain(&reserved_iova_list);
-		iommu_exit_mempool();
-		return ret;
+		goto out_free_reserved_range;
 	}
 	printk(KERN_INFO
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
@@ -3685,6 +3693,14 @@ int __init intel_iommu_init(void)
 	intel_iommu_enabled = 1;
 
 	return 0;
+
+out_free_reserved_range:
+	put_iova_domain(&reserved_iova_list);
+out_free_mempool:
+	iommu_exit_mempool();
+out_free_dmar:
+	intel_iommu_free_dmars();
+	return ret;
 }
 
 static void iommu_detach_dependent_devices(struct intel_iommu *iommu,
-- 
1.7.10.4

