Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3KUIYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:24:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:10653 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3KUIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:24:20 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Yijing Wang" <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2] IOMMU: enhance dmar to support device hotplug
Date: Thu, 21 Nov 2013 16:21:56 +0800
Message-ID: <1385022116-228-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
References: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, DMAR driver save target pci devices pointers for drhd/rmrr/atsr
in (pci_dev *) array, but never update it after initialization. 
This is not safe, because pci devices maybe hot added or removed during 
system running. They will have new pci_dev * pointer. So if there have 
two IOMMUs or more in system, these devices will find a wrong drhd during 
DMA mapping. And DMAR faults will occur. This patch save pci device id 
to fix this issue. Pci device id will be used to update pci_dev *pointer
info during device hotplug in intel iommu driver notifier, Other we use list 
to manage target devices for IOMMU, then we can easily use list helper.

Fault log: after remove and rescan a pci device
[  611.857095] dmar: DRHD: handling fault status reg 2
[  611.857109] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff7000
[  611.857109] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.857524] dmar: DRHD: handling fault status reg 102
[  611.857534] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff6000
[  611.857534] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.857936] dmar: DRHD: handling fault status reg 202
[  611.857947] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff5000
[  611.857947] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.858351] dmar: DRHD: handling fault status reg 302
[  611.858362] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff4000
[  611.858362] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.860819] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
[  611.860983] dmar: DRHD: handling fault status reg 402
[  611.860995] dmar: INTR-REMAP: Request device [[86:00.3] fault index a4
[  611.860995] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/dmar.c        |   82 +++++++++++-----------
 drivers/iommu/intel-iommu.c |  161 +++++++++++++++++++++++++++++-------------
 include/linux/dmar.h        |   24 ++++--
 3 files changed, 167 insertions(+), 100 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 8b452c9..012b431 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -65,11 +65,12 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 }
 
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
-					   struct pci_dev **dev, u16 segment)
+					   struct list_head *head, u16 segment)
 {
 	struct pci_bus *bus;
 	struct pci_dev *pdev = NULL;
 	struct acpi_dmar_pci_path *path;
+	struct dmar_device *dmar_dev;
 	int count;
 
 	bus = pci_find_bus(segment, scope->bus);
@@ -99,8 +100,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 	}
 	if (!pdev) {
 		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
-			segment, scope->bus, path->device, path->function);
-		*dev = NULL;
+			segment, scope->bus, path->dev, path->fn);
 		return 0;
 	}
 	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
@@ -111,50 +111,36 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 			pci_name(pdev));
 		return -EINVAL;
 	}
-	*dev = pdev;
+
+	dmar_dev = kzalloc(sizeof(struct dmar_device), GFP_KERNEL);
+	if (!dmar_dev) {
+		pci_dev_put(pdev);
+		return -ENOMEM;
+	}
+	dmar_dev->pdev = pdev;
+	dmar_dev->bus = pdev->bus->number;
+	dmar_dev->devfn = pdev->devfn;
+	dmar_dev->segment = segment;
+
+	list_add_tail(&dmar_dev->list, head);
+
 	return 0;
 }
 
-int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment)
+int __init dmar_parse_dev_scope(void *start, void *end,
+		struct list_head *head, u16 segment)
 {
 	struct acpi_dmar_device_scope *scope;
-	void * tmp = start;
-	int index;
 	int ret;
 
-	*cnt = 0;
-	while (start < end) {
-		scope = start;
-		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
-		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
-			(*cnt)++;
-		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC &&
-			scope->entry_type != ACPI_DMAR_SCOPE_TYPE_HPET) {
-			pr_warn("Unsupported device scope\n");
-		}
-		start += scope->length;
-	}
-	if (*cnt == 0)
-		return 0;
-
-	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
-	if (!*devices)
-		return -ENOMEM;
-
-	start = tmp;
-	index = 0;
 	while (start < end) {
 		scope = start;
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
-			ret = dmar_parse_one_dev_scope(scope,
-				&(*devices)[index], segment);
+			ret = dmar_parse_one_dev_scope(scope, head, segment);
 			if (ret) {
-				kfree(*devices);
 				return ret;
 			}
-			index ++;
 		}
 		start += scope->length;
 	}
@@ -183,6 +169,7 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->segment = drhd->segment;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
+	INIT_LIST_HEAD(&dmaru->devices);
 
 	ret = alloc_iommu(dmaru);
 	if (ret) {
@@ -193,6 +180,19 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 	return 0;
 }
 
+static void dmar_free(struct dmar_drhd_unit *dmaru)
+{
+	struct dmar_device *dmar_dev, *tmp;
+
+	list_for_each_entry_safe(dmar_dev, tmp,
+			&dmaru->devices, list) {
+		if (dmar_dev->pdev)
+			pci_dev_put(dmar_dev->pdev);
+		list_del(&dmar_dev->list);
+		kfree(dmar_dev);
+	}
+}
+
 static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 {
 	struct acpi_dmar_hardware_unit *drhd;
@@ -205,11 +205,10 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 
 	ret = dmar_parse_dev_scope((void *)(drhd + 1),
 				((void *)drhd) + drhd->header.length,
-				&dmaru->devices_cnt, &dmaru->devices,
-				drhd->segment);
+				&dmaru->devices, drhd->segment);
 	if (ret) {
 		list_del(&dmaru->list);
-		kfree(dmaru);
+		dmar_free(dmaru);
 	}
 	return ret;
 }
@@ -378,14 +377,14 @@ parse_dmar_table(void)
 	return ret;
 }
 
-static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
+static int dmar_pci_device_match(struct list_head *head,
 			  struct pci_dev *dev)
 {
-	int index;
+	struct dmar_device *dmar_dev;
 
 	while (dev) {
-		for (index = 0; index < cnt; index++)
-			if (dev == devices[index])
+		list_for_each_entry(dmar_dev, head, list)
+			if (dev == dmar_dev->pdev)
 				return 1;
 
 		/* Check our parent */
@@ -412,8 +411,7 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 		    drhd->segment == pci_domain_nr(dev->bus))
 			return dmaru;
 
-		if (dmar_pci_device_match(dmaru->devices,
-					  dmaru->devices_cnt, dev))
+		if (dmar_pci_device_match(&dmaru->devices, dev))
 			return dmaru;
 	}
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 43b9bfe..8dd7dbe 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -650,23 +650,23 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
 static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 {
 	struct dmar_drhd_unit *drhd = NULL;
-	int i;
+	struct dmar_device *dmar_dev;
 
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
 			continue;
 		if (segment != drhd->segment)
 			continue;
-
-		for (i = 0; i < drhd->devices_cnt; i++) {
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->bus->number == bus &&
-			    drhd->devices[i]->devfn == devfn)
+
+		list_for_each_entry(dmar_dev, &drhd->devices, list) {
+			if (dmar_dev->pdev &&
+			    dmar_dev->pdev->bus->number == bus &&
+			    dmar_dev->pdev->devfn == devfn)
 				return drhd->iommu;
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->subordinate &&
-			    drhd->devices[i]->subordinate->number <= bus &&
-			    drhd->devices[i]->subordinate->busn_res.end >= bus)
+			if (dmar_dev->pdev &&
+			    dmar_dev->pdev->subordinate &&
+				dmar_dev->pdev->subordinate->number <= bus &&
+			    dmar_dev->pdev->subordinate->busn_res.end >= bus)
 				return drhd->iommu;
 		}
 
@@ -2335,15 +2335,16 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 static bool device_has_rmrr(struct pci_dev *dev)
 {
 	struct dmar_rmrr_unit *rmrr;
-	int i;
+	struct dmar_device *dmar_dev;
 
 	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
+		list_for_each_entry(dmar_dev, &rmrr->devices,
+				list) {
 			/*
 			 * Return TRUE if this RMRR contains the device that
 			 * is passed in.
 			 */
-			if (rmrr->devices[i] == dev)
+			if (dmar_dev->pdev == dev)
 				return true;
 		}
 	}
@@ -2455,7 +2456,7 @@ static int __init init_dmars(void)
 	struct dmar_rmrr_unit *rmrr;
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
-	int i, ret;
+	int ret;
 
 	/*
 	 * for each drhd
@@ -2609,8 +2610,10 @@ static int __init init_dmars(void)
 	 */
 	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
 	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
-			pdev = rmrr->devices[i];
+		struct dmar_device *dmar_dev;
+		list_for_each_entry(dmar_dev, &rmrr->devices,
+			 list) {
+			pdev = dmar_dev->pdev;
 			/*
 			 * some BIOS lists non-exist devices in DMAR
 			 * table.
@@ -3305,30 +3308,39 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quir
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
+	int ignore;
 
 	for_each_drhd_unit(drhd) {
 		if (!drhd->include_all) {
-			int i;
-			for (i = 0; i < drhd->devices_cnt; i++)
-				if (drhd->devices[i] != NULL)
+			struct dmar_device *dmar_dev;
+			ignore = 1;
+			list_for_each_entry(dmar_dev, &drhd->devices,
+					list)
+				if (dmar_dev->pdev != NULL) {
+					ignore = 0;
 					break;
+				}
 			/* ignore DMAR unit if no pci devices exist */
-			if (i == drhd->devices_cnt)
+			if (ignore)
 				drhd->ignored = 1;
 		}
 	}
 
 	for_each_drhd_unit(drhd) {
-		int i;
+		struct dmar_device *dmar_dev;
+		int flag = 0;
+
 		if (drhd->ignored || drhd->include_all)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++)
-			if (drhd->devices[i] &&
-			    !IS_GFX_DEVICE(drhd->devices[i]))
+		list_for_each_entry(dmar_dev, &drhd->devices, list)
+			if (dmar_dev->pdev &&
+			    !IS_GFX_DEVICE(dmar_dev->pdev)) {
+				flag = 1;
 				break;
+			}
 
-		if (i < drhd->devices_cnt)
+		if (flag)
 			continue;
 
 		/* This IOMMU has *only* gfx devices. Either bypass it or
@@ -3337,10 +3349,10 @@ static void __init init_no_remapping_devices(void)
 			intel_iommu_gfx_mapped = 1;
 		} else {
 			drhd->ignored = 1;
-			for (i = 0; i < drhd->devices_cnt; i++) {
-				if (!drhd->devices[i])
+			list_for_each_entry(dmar_dev, &drhd->devices, list) {
+				if (!dmar_dev->pdev)
 					continue;
-				drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+				dmar_dev->pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 			}
 		}
 	}
@@ -3505,11 +3517,25 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
 	rmrru->base_address = rmrr->base_address;
 	rmrru->end_address = rmrr->end_address;
+	INIT_LIST_HEAD(&rmrru->devices);
 
 	dmar_register_rmrr_unit(rmrru);
 	return 0;
 }
 
+static void rmrr_free(struct dmar_rmrr_unit *rmrru)
+{
+	struct dmar_device *dmar_dev, *tmp;
+
+	list_for_each_entry_safe(dmar_dev, tmp,
+			&rmrru->devices, list) {
+		if (dmar_dev->pdev)
+			pci_dev_put(dmar_dev->pdev);
+		list_del(&dmar_dev->list);
+		kfree(dmar_dev);
+	}
+}
+
 static int __init
 rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 {
@@ -3519,11 +3545,11 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
 	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
 		((void *)rmrr) + rmrr->header.length,
-		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+		&rmrru->devices, rmrr->segment);
 
-	if (ret || (rmrru->devices_cnt == 0)) {
+	if (ret || list_empty(&rmrru->devices)) {
 		list_del(&rmrru->list);
-		kfree(rmrru);
+		rmrr_free(rmrru);
 	}
 	return ret;
 }
@@ -3542,12 +3568,26 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	INIT_LIST_HEAD(&atsru->devices);
 
 	list_add(&atsru->list, &dmar_atsr_units);
 
 	return 0;
 }
 
+static void atsr_free(struct dmar_atsr_unit *atsru)
+{
+	struct dmar_device *dmar_dev, *tmp;
+
+	list_for_each_entry_safe(dmar_dev, tmp,
+			&atsru->devices, list) {
+		if (dmar_dev->pdev)
+			pci_dev_put(dmar_dev->pdev);
+		list_del(&dmar_dev->list);
+		kfree(dmar_dev);
+	}
+}
+
 static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
 {
 	int rc;
@@ -3559,11 +3599,10 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
 	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
 	rc = dmar_parse_dev_scope((void *)(atsr + 1),
 				(void *)atsr + atsr->header.length,
-				&atsru->devices_cnt, &atsru->devices,
-				atsr->segment);
-	if (rc || !atsru->devices_cnt) {
+				&atsru->devices, atsr->segment);
+	if (rc || list_empty(&atsru->devices)) {
 		list_del(&atsru->list);
-		kfree(atsru);
+		atsr_free(atsru);
 	}
 
 	return rc;
@@ -3571,7 +3610,6 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
 
 int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 {
-	int i;
 	struct pci_bus *bus;
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
@@ -3589,14 +3627,16 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 found:
 	for (bus = dev->bus; bus; bus = bus->parent) {
 		struct pci_dev *bridge = bus->self;
+		struct dmar_device *dmar_dev;
 
 		if (!bridge || !pci_is_pcie(bridge) ||
 		    pci_pcie_type(bridge) == PCI_EXP_TYPE_PCI_BRIDGE)
 			return 0;
 
 		if (pci_pcie_type(bridge) == PCI_EXP_TYPE_ROOT_PORT) {
-			for (i = 0; i < atsru->devices_cnt; i++)
-				if (atsru->devices[i] == bridge)
+			list_for_each_entry(dmar_dev, &atsru->devices,
+					list)
+				if (dmar_dev->pdev == bridge)
 					return 1;
 			break;
 		}
@@ -3641,21 +3681,42 @@ static int device_notifier(struct notifier_block *nb,
 	struct device *dev = data;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
+	struct dmar_device *dmar_dev;
+	struct dmar_drhd_unit *drhd;
 
-	if (iommu_no_mapping(dev))
-		return 0;
-
-	domain = find_domain(pdev);
-	if (!domain)
-		return 0;
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		for_each_drhd_unit(drhd)
+			list_for_each_entry(dmar_dev, &drhd->devices, list)
+				if (dmar_dev->segment == pci_domain_nr(pdev->bus)
+					&& dmar_dev->bus == pdev->bus->number
+					&& dmar_dev->devfn == pdev->devfn)
+					dmar_dev->pdev = pci_dev_get(pdev);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		for_each_drhd_unit(drhd)
+			list_for_each_entry(dmar_dev, &drhd->devices, list)
+				if (dmar_dev->pdev == pdev) {
+					pci_dev_put(pdev);
+					dmar_dev->pdev = NULL;
+				}
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		if (iommu_no_mapping(dev))
+			return 0;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
-		domain_remove_one_dev_info(domain, pdev);
+		domain = find_domain(pdev);
+		if (!domain)
+			return 0;
 
-		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
-		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
-		    list_empty(&domain->devices))
-			domain_exit(domain);
+		if (!iommu_pass_through) {
+			domain_remove_one_dev_info(domain, pdev);
+			if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
+				&& !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)
+				&& list_empty(&domain->devices))
+				domain_exit(domain);
+		}
+		break;
 	}
 
 	return 0;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index b029d1a..022cb80 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -32,6 +32,17 @@ struct acpi_dmar_header;
 #define DMAR_INTR_REMAP		0x1
 #define DMAR_X2APIC_OPT_OUT	0x2
 
+/* Save pci device id here to help update
+ * (pci_dev *) pointer during device hotplug
+ */
+struct dmar_device {
+	struct list_head list;
+	u8 bus;
+	u8 devfn;
+	u16 segment;
+	struct pci_dev *pdev;
+};
+
 struct intel_iommu;
 #ifdef CONFIG_DMAR_TABLE
 extern struct acpi_table_header *dmar_tbl;
@@ -39,8 +50,7 @@ struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	reg_base_addr;		/* register base address*/
-	struct	pci_dev **devices; 	/* target device array	*/
-	int	devices_cnt;		/* target device count	*/
+	struct list_head devices; /* target device list */
 	u16	segment;		/* PCI domain		*/
 	u8	ignored:1; 		/* ignore drhd		*/
 	u8	include_all:1;
@@ -139,8 +149,7 @@ struct dmar_rmrr_unit {
 	struct acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	base_address;		/* reserved base address*/
 	u64	end_address;		/* reserved end address */
-	struct pci_dev **devices;	/* target devices */
-	int	devices_cnt;		/* target device count */
+	struct list_head devices; /* target device list */
 };
 
 #define for_each_rmrr_units(rmrr) \
@@ -149,16 +158,15 @@ struct dmar_rmrr_unit {
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
-	struct pci_dev **devices;	/* target devices */
-	int devices_cnt;		/* target device count */
+	struct list_head devices;	/* target device list */
 	u8 include_all:1;		/* include all ports */
 };
 
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment);
+extern int dmar_parse_dev_scope(void *start, void *end,
+				struct list_head *head, u16 segment);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-- 
1.7.1


