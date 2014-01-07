Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaAGJAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:3277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbaAGJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454740060"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 12/14] iommu/vt-d, PCI: unify the way to process DMAR device scope array
Date: Tue,  7 Jan 2014 17:00:32 +0800
Message-Id: <1389085234-22296-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have a PCI bus notification based mechanism to update DMAR
device scope array, we could extend the mechanism to support boot
time initialization too, which will help to unify and simplify
the implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c        |  163 ++++++++++++-------------------------------
 drivers/iommu/intel-iommu.c |   71 +++++--------------
 include/linux/dmar.h        |    7 --
 3 files changed, 61 insertions(+), 180 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 15c9ce0..d82cee2 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -60,6 +60,7 @@ LIST_HEAD(dmar_drhd_units);
 
 struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
+static int dmar_dev_scope_status = 1;
 
 static int alloc_iommu(struct dmar_drhd_unit *drhd);
 static void free_iommu(struct intel_iommu *iommu);
@@ -76,58 +77,6 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 		list_add_rcu(&drhd->list, &dmar_drhd_units);
 }
 
-static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
-					   struct pci_dev __rcu **dev, u16 segment)
-{
-	struct pci_bus *bus;
-	struct pci_dev *pdev = NULL;
-	struct acpi_dmar_pci_path *path;
-	int count;
-
-	bus = pci_find_bus(segment, scope->bus);
-	path = (struct acpi_dmar_pci_path *)(scope + 1);
-	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
-		/ sizeof(struct acpi_dmar_pci_path);
-
-	while (count) {
-		if (pdev)
-			pci_dev_put(pdev);
-		/*
-		 * Some BIOSes list non-exist devices in DMAR table, just
-		 * ignore it
-		 */
-		if (!bus) {
-			pr_warn("Device scope bus [%d] not found\n", scope->bus);
-			break;
-		}
-		pdev = pci_get_slot(bus, PCI_DEVFN(path->device, path->function));
-		if (!pdev) {
-			/* warning will be printed below */
-			break;
-		}
-		path ++;
-		count --;
-		bus = pdev->subordinate;
-	}
-	if (!pdev) {
-		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
-			segment, scope->bus, path->device, path->function);
-		return 0;
-	}
-	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
-			pdev->subordinate) || (scope->entry_type == \
-			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
-		pci_dev_put(pdev);
-		pr_warn("Device scope type does not match for %s\n",
-			pci_name(pdev));
-		return -EINVAL;
-	}
-
-	rcu_assign_pointer(*dev, pdev);
-
-	return 0;
-}
-
 void *dmar_alloc_dev_scope(void *start, void *end, int *cnt)
 {
 	struct acpi_dmar_device_scope *scope;
@@ -150,35 +99,6 @@ void *dmar_alloc_dev_scope(void *start, void *end, int *cnt)
 	return kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
 }
 
-int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev __rcu ***devices, u16 segment)
-{
-	struct acpi_dmar_device_scope *scope;
-	int index, ret;
-
-	*devices = dmar_alloc_dev_scope(start, end, cnt);
-	if (*cnt == 0)
-		return 0;
-	else if (!*devices)
-		return -ENOMEM;
-
-	for (index = 0; start < end; start += scope->length) {
-		scope = start;
-		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
-		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
-			ret = dmar_parse_one_dev_scope(scope,
-				&(*devices)[index], segment);
-			if (ret) {
-				dmar_free_dev_scope(devices, cnt);
-				return ret;
-			}
-			index ++;
-		}
-	}
-
-	return 0;
-}
-
 void dmar_free_dev_scope(struct pci_dev __rcu ***devices, int *cnt)
 {
 	int i;
@@ -220,6 +140,8 @@ dmar_alloc_pci_notify_info(struct pci_dev *dev, unsigned long event)
 		if (!info) {
 			pr_warn("Out of memory when allocating notify_info "
 				"for %s.\n", pci_name(dev));
+			if (dmar_dev_scope_status == 0)
+				dmar_dev_scope_status = -ENOMEM;
 			return NULL;
 		}
 	}
@@ -349,6 +271,8 @@ static int dmar_pci_bus_add_dev(struct dmar_pci_notify_info *info)
 	}
 	if (ret >= 0)
 		ret = dmar_iommu_notify_scope_dev(info);
+	if (ret < 0 && dmar_dev_scope_status == 0)
+		dmar_dev_scope_status = ret;
 
 	return ret;
 }
@@ -418,9 +342,21 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->segment = drhd->segment;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
+	if (!dmaru->include_all) {
+		dmaru->devices = dmar_alloc_dev_scope((void *)(drhd + 1),
+					((void *)drhd) + drhd->header.length,
+					&dmaru->devices_cnt);
+		if (dmaru->devices_cnt && dmaru->devices == NULL) {
+			kfree(dmaru);
+			return -ENOMEM;
+		}
+	}
 
 	ret = alloc_iommu(dmaru);
 	if (ret) {
+		if (!dmaru->include_all)
+			dmar_free_dev_scope(&dmaru->devices,
+					    &dmaru->devices_cnt);
 		kfree(dmaru);
 		return ret;
 	}
@@ -437,21 +373,6 @@ static void dmar_free_drhd(struct dmar_drhd_unit *dmaru)
 	kfree(dmaru);
 }
 
-static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
-{
-	struct acpi_dmar_hardware_unit *drhd;
-
-	drhd = (struct acpi_dmar_hardware_unit *) dmaru->hdr;
-
-	if (dmaru->include_all)
-		return 0;
-
-	return dmar_parse_dev_scope((void *)(drhd + 1),
-				    ((void *)drhd) + drhd->header.length,
-				    &dmaru->devices_cnt, &dmaru->devices,
-				    drhd->segment);
-}
-
 #ifdef CONFIG_ACPI_NUMA
 static int __init
 dmar_parse_one_rhsa(struct acpi_dmar_header *header)
@@ -665,34 +586,35 @@ out:
 
 int __init dmar_dev_scope_init(void)
 {
-	static int dmar_dev_scope_initialized;
-	struct dmar_drhd_unit *drhd;
-	int ret = -ENODEV;
+	struct pci_dev *dev = NULL;
+	struct dmar_pci_notify_info *info;
 
-	if (dmar_dev_scope_initialized)
-		return dmar_dev_scope_initialized;
+	if (dmar_dev_scope_status != 1)
+		return dmar_dev_scope_status;
 
-	if (list_empty(&dmar_drhd_units))
-		goto fail;
+	if (list_empty(&dmar_drhd_units)) {
+		dmar_dev_scope_status = -ENODEV;
+	} else {
+		dmar_dev_scope_status = 0;
+
+		for_each_pci_dev(dev) {
+			if (dev->is_virtfn)
+				continue;
+
+			info = dmar_alloc_pci_notify_info(dev,
+					BUS_NOTIFY_ADD_DEVICE);
+			if (!info) {
+				return dmar_dev_scope_status;
+			} else {
+				dmar_pci_bus_add_dev(info);
+				dmar_free_pci_notify_info(info);
+			}
+		}
 
-	for_each_drhd_unit(drhd) {
-		ret = dmar_parse_dev(drhd);
-		if (ret)
-			goto fail;
+		bus_register_notifier(&pci_bus_type, &dmar_pci_bus_nb);
 	}
 
-	ret = dmar_parse_rmrr_atsr_dev();
-	if (ret)
-		goto fail;
-
-	bus_register_notifier(&pci_bus_type, &dmar_pci_bus_nb);
-
-	dmar_dev_scope_initialized = 1;
-	return 0;
-
-fail:
-	dmar_dev_scope_initialized = ret;
-	return ret;
+	return dmar_dev_scope_status;
 }
 
 
@@ -1617,7 +1539,8 @@ static int __init dmar_free_unused_resources(void)
 	if (irq_remapping_enabled || intel_iommu_enabled)
 		return 0;
 
-	bus_unregister_notifier(&pci_bus_type, &dmar_pci_bus_nb);
+	if (dmar_dev_scope_status != 1 && !list_empty(&dmar_drhd_units))
+		bus_unregister_notifier(&pci_bus_type, &dmar_pci_bus_nb);
 
 	down_write(&dmar_global_lock);
 	list_for_each_entry_safe(dmaru, dmaru_n, &dmar_drhd_units, list) {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 010491f..6a9a314 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3467,11 +3467,6 @@ static void __init init_iommu_pm_ops(void)
 static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
-static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
-{
-	list_add(&rmrr->list, &dmar_rmrr_units);
-}
-
 
 int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
@@ -3486,21 +3481,17 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
 	rmrru->base_address = rmrr->base_address;
 	rmrru->end_address = rmrr->end_address;
+	rmrru->devices = dmar_alloc_dev_scope((void *)(rmrr + 1),
+				((void *)rmrr) + rmrr->header.length,
+				&rmrru->devices_cnt);
+	if (rmrru->devices_cnt && rmrru->devices == NULL) {
+		kfree(rmrru);
+		return -ENOMEM;
+	}
 
-	dmar_register_rmrr_unit(rmrru);
-	return 0;
-}
+	list_add(&rmrru->list, &dmar_rmrr_units);
 
-static int __init
-rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
-{
-	struct acpi_dmar_reserved_memory *rmrr;
-
-	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
-	return dmar_parse_dev_scope((void *)(rmrr + 1),
-				    ((void *)rmrr) + rmrr->header.length,
-				    &rmrru->devices_cnt, &rmrru->devices,
-				    rmrr->segment);
+	return 0;
 }
 
 int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
@@ -3515,26 +3506,21 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	if (!atsru->include_all) {
+		atsru->devices = dmar_alloc_dev_scope((void *)(atsr + 1),
+				(void *)atsr + atsr->header.length,
+				&atsru->devices_cnt);
+		if (atsru->devices_cnt && atsru->devices == NULL) {
+			kfree(atsru);
+			return -ENOMEM;
+		}
+	}
 
 	list_add_rcu(&atsru->list, &dmar_atsr_units);
 
 	return 0;
 }
 
-static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
-{
-	struct acpi_dmar_atsr *atsr;
-
-	if (atsru->include_all)
-		return 0;
-
-	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-	return dmar_parse_dev_scope((void *)(atsr + 1),
-				    (void *)atsr + atsr->header.length,
-				    &atsru->devices_cnt, &atsru->devices,
-				    atsr->segment);
-}
-
 static void intel_iommu_free_atsr(struct dmar_atsr_unit *atsru)
 {
 	dmar_free_dev_scope(&atsru->devices, &atsru->devices_cnt);
@@ -3598,27 +3584,6 @@ out:
 	return ret;
 }
 
-int __init dmar_parse_rmrr_atsr_dev(void)
-{
-	struct dmar_rmrr_unit *rmrr;
-	struct dmar_atsr_unit *atsr;
-	int ret;
-
-	list_for_each_entry(rmrr, &dmar_rmrr_units, list) {
-		ret = rmrr_parse_dev(rmrr);
-		if (ret)
-			return ret;
-	}
-
-	list_for_each_entry_rcu(atsr, &dmar_atsr_units, list) {
-		ret = atsr_parse_dev(atsr);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
 {
 	int ret = 0;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 78c15a45..242c25b 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -96,8 +96,6 @@ extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
 extern int enable_drhd_fault_handling(void);
 extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
-extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev __rcu ***devices, u16 segment);
 extern void dmar_free_dev_scope(struct pci_dev __rcu ***devices, int *cnt);
 extern int dmar_insert_dev_scope(struct dmar_pci_notify_info *info,
 				 void *start, void*end, u16 segment,
@@ -166,7 +164,6 @@ extern int arch_setup_dmar_msi(unsigned int irq);
 
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
-extern int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
 extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
@@ -181,10 +178,6 @@ static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
 {
 	return 0;
 }
-static inline int dmar_parse_rmrr_atsr_dev(void)
-{
-	return 0;
-}
 static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
 {
 	return 0;
-- 
1.7.10.4

