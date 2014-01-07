Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaAGJAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:3277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaAGJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739951"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 08/14] iommu/vt-d: introduce macro for_each_dev_scope() to walk device scope entries
Date: Tue,  7 Jan 2014 17:00:28 +0800
Message-Id: <1389085234-22296-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce for_each_dev_scope()/for_each_active_dev_scope() to walk
{active} device scope entries. This will help following RCU lock
related patches.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c        |   14 +++---
 drivers/iommu/intel-iommu.c |  100 +++++++++++++++++++++----------------------
 include/linux/dmar.h        |    6 +++
 3 files changed, 64 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 4a4c9a1..ff33866 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -170,9 +170,12 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 
 void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
 {
+	int i;
+	struct pci_dev *tmp_dev;
+
 	if (*devices && *cnt) {
-		while (--*cnt >= 0)
-			pci_dev_put((*devices)[*cnt]);
+		for_each_active_dev_scope(*devices, *cnt, i, tmp_dev)
+			pci_dev_put(tmp_dev);
 		kfree(*devices);
 		*devices = NULL;
 		*cnt = 0;
@@ -402,10 +405,11 @@ static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
 			  struct pci_dev *dev)
 {
 	int index;
+	struct pci_dev *tmp;
 
 	while (dev) {
-		for (index = 0; index < cnt; index++)
-			if (dev == devices[index])
+		for_each_active_dev_scope(devices, cnt, index, tmp)
+			if (dev == tmp)
 				return 1;
 
 		/* Check our parent */
@@ -452,7 +456,7 @@ int __init dmar_dev_scope_init(void)
 	if (list_empty(&dmar_drhd_units))
 		goto fail;
 
-	list_for_each_entry(drhd, &dmar_drhd_units, list) {
+	for_each_drhd_unit(drhd) {
 		ret = dmar_parse_dev(drhd);
 		if (ret)
 			goto fail;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index b0028e2..7e043ca 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -652,29 +652,31 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
 static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 {
 	struct dmar_drhd_unit *drhd = NULL;
+	struct intel_iommu *iommu;
+	struct pci_dev *dev;
 	int i;
 
-	for_each_active_drhd_unit(drhd) {
+	for_each_active_iommu(iommu, drhd) {
 		if (segment != drhd->segment)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++) {
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->bus->number == bus &&
-			    drhd->devices[i]->devfn == devfn)
-				return drhd->iommu;
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->subordinate &&
-			    drhd->devices[i]->subordinate->number <= bus &&
-			    drhd->devices[i]->subordinate->busn_res.end >= bus)
-				return drhd->iommu;
+		for_each_active_dev_scope(drhd->devices,
+					  drhd->devices_cnt, i, dev) {
+			if (dev->bus->number == bus && dev->devfn == devfn)
+				goto out;
+			if (dev->subordinate &&
+			    dev->subordinate->number <= bus &&
+			    dev->subordinate->busn_res.end >= bus)
+				goto out;
 		}
 
 		if (drhd->include_all)
-			return drhd->iommu;
+			goto out;
 	}
+	iommu = NULL;
+out:
 
-	return NULL;
+	return iommu;
 }
 
 static void domain_flush_cache(struct dmar_domain *domain,
@@ -2329,17 +2331,19 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 static bool device_has_rmrr(struct pci_dev *dev)
 {
 	struct dmar_rmrr_unit *rmrr;
+	struct pci_dev *tmp;
 	int i;
 
 	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
-			/*
-			 * Return TRUE if this RMRR contains the device that
-			 * is passed in.
-			 */
-			if (rmrr->devices[i] == dev)
+		/*
+		 * Return TRUE if this RMRR contains the device that
+		 * is passed in.
+		 */
+		for_each_active_dev_scope(rmrr->devices,
+					  rmrr->devices_cnt, i, tmp)
+			if (tmp == dev) {
 				return true;
-		}
+			}
 	}
 	return false;
 }
@@ -2589,14 +2593,9 @@ static int __init init_dmars(void)
 	 */
 	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
 	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
-			pdev = rmrr->devices[i];
-			/*
-			 * some BIOS lists non-exist devices in DMAR
-			 * table.
-			 */
-			if (!pdev)
-				continue;
+		/* some BIOS lists non-exist devices in DMAR table. */
+		for_each_active_dev_scope(rmrr->devices, rmrr->devices_cnt,
+					  i, pdev) {
 			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
 			if (ret)
 				printk(KERN_ERR
@@ -3282,13 +3281,14 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quir
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct pci_dev *dev;
+	int i;
 
 	for_each_drhd_unit(drhd) {
 		if (!drhd->include_all) {
-			int i;
-			for (i = 0; i < drhd->devices_cnt; i++)
-				if (drhd->devices[i] != NULL)
-					break;
+			for_each_active_dev_scope(drhd->devices,
+						  drhd->devices_cnt, i, dev)
+				break;
 			/* ignore DMAR unit if no pci devices exist */
 			if (i == drhd->devices_cnt)
 				drhd->ignored = 1;
@@ -3296,15 +3296,13 @@ static void __init init_no_remapping_devices(void)
 	}
 
 	for_each_active_drhd_unit(drhd) {
-		int i;
 		if (drhd->include_all)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++)
-			if (drhd->devices[i] &&
-			    !IS_GFX_DEVICE(drhd->devices[i]))
+		for_each_active_dev_scope(drhd->devices,
+					  drhd->devices_cnt, i, dev)
+			if (!IS_GFX_DEVICE(dev))
 				break;
-
 		if (i < drhd->devices_cnt)
 			continue;
 
@@ -3314,11 +3312,9 @@ static void __init init_no_remapping_devices(void)
 			intel_iommu_gfx_mapped = 1;
 		} else {
 			drhd->ignored = 1;
-			for (i = 0; i < drhd->devices_cnt; i++) {
-				if (!drhd->devices[i])
-					continue;
-				drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
-			}
+			for_each_active_dev_scope(drhd->devices,
+						  drhd->devices_cnt, i, dev)
+				dev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
@@ -3554,9 +3550,9 @@ static void intel_iommu_free_dmars(void)
 
 int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 {
-	int i;
+	int i, ret = 1;
 	struct pci_bus *bus;
-	struct pci_dev *bridge = NULL;
+	struct pci_dev *bridge = NULL, *tmp;
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
@@ -3577,22 +3573,24 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 		if (atsr->segment != pci_domain_nr(dev->bus))
 			continue;
 
-		for (i = 0; i < atsru->devices_cnt; i++)
-			if (atsru->devices[i] == bridge)
-				return 1;
+		for_each_dev_scope(atsru->devices, atsru->devices_cnt, i, tmp)
+			if (tmp == bridge)
+				goto out;
 
 		if (atsru->include_all)
-			return 1;
+			goto out;
 	}
+	ret = 0;
+out:
 
-	return 0;
+	return ret;
 }
 
 int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr;
 	struct dmar_atsr_unit *atsr;
-	int ret = 0;
+	int ret;
 
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list) {
 		ret = rmrr_parse_dev(rmrr);
@@ -3606,7 +3604,7 @@ int __init dmar_parse_rmrr_atsr_dev(void)
 			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index dc8c7d5..8aa7561 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -65,6 +65,12 @@ extern struct list_head dmar_drhd_units;
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
 		if (i=drhd->iommu, 0) {} else 
 
+#define	for_each_dev_scope(a, c, p, d)	\
+	for ((p) = 0; ((d) = (p) < (c) ? (a)[(p)] : NULL, (p) < (c)); (p)++)
+
+#define	for_each_active_dev_scope(a, c, p, d)	\
+	for_each_dev_scope((a), (c), (p), (d))	if (!(d)) { continue; } else
+
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
 extern int enable_drhd_fault_handling(void);
-- 
1.7.10.4

