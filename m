Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaACAIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:08:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23840 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaACAIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:08:15 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Donald Dutile <ddutile@redhat.com>, iommu@lists.linux-foundation.org
Subject: [PATCH v2 01/10] IOMMU: Update dmar units devices list during hotplug
Date: Thu,  2 Jan 2014 16:08:08 -0800
Message-Id: <1388707697-16800-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do pci remove/rescan on system that have more iommus, got

[  894.089745] Set context mapping for c4:00.0
[  894.110890] mpt2sas3: Allocated physical memory: size(4293 kB)
[  894.112556] mpt2sas3: Current Controller Queue Depth(1883), Max Controller Queue Depth(2144)
[  894.127278] mpt2sas3: Scatter Gather Elements per IO(128)
[  894.361295] DRHD: handling fault status reg 2
[  894.364053] DMAR:[DMA Read] Request device [c4:00.0] fault addr fffbe000
[  894.364056] DMAR:[fault reason 02] Present bit in context entry is cl

It turns out when remove/rescan, pci dev will be freed and will get another
new dev. But drhd units still keep old one... so dmar_find_matched_drhd_unit
will return wrong drhd and iommu for the device that is not on first iommu.

So need to update devices in drhd_units during pci remove/rescan.

Could save domain/bus/device/function aside in the list and according that
info restore new dev to drhd_units later.
Then dmar_find_matched_drdh_unit and device_to_iommu could return right drhd
and iommu.

Add remove_dev_from_drhd/restore_dev_to_drhd functions to do the real work.
call them in device ADD_DEVICE and UNBOUND_DRIVER

Need to do the samething to atsr. (expose dmar_atsr_units and add
atsru->segment)

After patch, will have right iommu for the new dev and will not get DMAR
error anymore.

-v2: add pci_dev_put/pci_dev_get to make refcount consistent.
-v3: fix one left over CONFIG_DMAR
-v4: pass pci_dev *dev in save_dev_dmaru()/get_dev_dmaru() according to Bjorn.
-v5: fix case only have intr-remap enabled.
-v6: skip handling of vf adding/removing.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/dmar.c                | 138 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c         |  32 +++++----
 drivers/iommu/intel_irq_remapping.c |  33 ++++++++-
 include/linux/dmar.h                |  10 +++
 4 files changed, 200 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f4eaa50..a14867c 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -450,6 +450,144 @@ fail:
 	return ret;
 }
 
+struct dev_dmaru {
+	struct list_head list;
+	void *dmaru;
+	int index;
+	int segment;
+	unsigned char bus;
+	unsigned int devfn;
+};
+
+static int save_dev_dmaru(struct pci_dev *dev, void *dmaru,
+			  int index, struct list_head *lh)
+{
+	struct dev_dmaru *m;
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	m->segment = pci_domain_nr(dev->bus);
+	m->bus     = dev->bus->number;
+	m->devfn   = dev->devfn;
+	m->dmaru   = dmaru;
+	m->index   = index;
+
+	list_add(&m->list, lh);
+
+	return 0;
+}
+static void *get_dev_dmaru(struct pci_dev *dev, int *index,
+				struct list_head *lh)
+{
+	int segment = pci_domain_nr(dev->bus);
+	unsigned char bus = dev->bus->number;
+	unsigned int devfn = dev->devfn;
+	struct dev_dmaru *m;
+	void *dmaru = NULL;
+
+	list_for_each_entry(m, lh, list) {
+		if (m->segment == segment &&
+		    m->bus == bus && m->devfn == devfn) {
+			*index = m->index;
+			dmaru  = m->dmaru;
+			list_del(&m->list);
+			kfree(m);
+			break;
+		}
+	}
+
+	return dmaru;
+}
+
+static LIST_HEAD(saved_dev_drhd_list);
+void remove_dev_from_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	if (dev->is_virtfn)
+		return;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		if (segment != drhd->segment)
+			continue;
+
+		for (i = 0; i < drhd->devices_cnt; i++) {
+			if (drhd->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(dev, drhd, i,
+						&saved_dev_drhd_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				drhd->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+void restore_dev_to_drhd(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int i;
+
+	if (dev->is_virtfn)
+		return;
+
+	/* find the stored drhd */
+	drhd = get_dev_dmaru(dev, &i, &saved_dev_drhd_list);
+	/* restore that into drhd */
+	if (drhd)
+		drhd->devices[i] = pci_dev_get(dev);
+}
+
+#ifdef CONFIG_INTEL_IOMMU
+static LIST_HEAD(saved_dev_atsr_list);
+void remove_dev_from_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int segment = pci_domain_nr(dev->bus);
+	int i;
+
+	if (dev->is_virtfn)
+		return;
+
+	for_each_atsr_unit(atsr) {
+		if (segment != atsr->segment)
+			continue;
+
+		for (i = 0; i < atsr->devices_cnt; i++) {
+			if (atsr->devices[i] == dev) {
+				/* save it at first if it is in drhd */
+				save_dev_dmaru(dev, atsr, i,
+						&saved_dev_atsr_list);
+				/* always remove it */
+				pci_dev_put(dev);
+				atsr->devices[i] = NULL;
+				return;
+			}
+		}
+	}
+}
+void restore_dev_to_atsr(struct pci_dev *dev)
+{
+	struct dmar_atsr_unit *atsr = NULL;
+	int i;
+
+	if (dev->is_virtfn)
+		return;
+
+	/* find the stored atsr */
+	atsr = get_dev_dmaru(dev, &i, &saved_dev_atsr_list);
+	/* restore that into atsr */
+	if (atsr)
+		atsr->devices[i] = pci_dev_get(dev);
+}
+#endif  /* CONFIG_INTEL_IOMMU */
 
 int __init dmar_table_init(void)
 {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 43b9bfe..a3eb689 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3528,7 +3528,7 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 	return ret;
 }
 
-static LIST_HEAD(dmar_atsr_units);
+LIST_HEAD(dmar_atsr_units);
 
 int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 {
@@ -3542,6 +3542,7 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
+	atsru->segment = atsr->segment;
 
 	list_add(&atsru->list, &dmar_atsr_units);
 
@@ -3573,16 +3574,13 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 {
 	int i;
 	struct pci_bus *bus;
-	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
 
 	dev = pci_physfn(dev);
 
-	list_for_each_entry(atsru, &dmar_atsr_units, list) {
-		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
-		if (atsr->segment == pci_domain_nr(dev->bus))
+	list_for_each_entry(atsru, &dmar_atsr_units, list)
+		if (atsru->segment == pci_domain_nr(dev->bus))
 			goto found;
-	}
 
 	return 0;
 
@@ -3642,20 +3640,30 @@ static int device_notifier(struct notifier_block *nb,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 
-	if (iommu_no_mapping(dev))
-		return 0;
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		if (iommu_no_mapping(dev) || iommu_pass_through)
+			break;
 
-	domain = find_domain(pdev);
-	if (!domain)
-		return 0;
+		domain = find_domain(pdev);
+		if (!domain)
+			break;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
 		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
 		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
 		    list_empty(&domain->devices))
 			domain_exit(domain);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		remove_dev_from_drhd(pdev);
+		remove_dev_from_atsr(pdev);
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		restore_dev_to_drhd(pdev);
+		restore_dev_to_atsr(pdev);
+		break;
 	}
 
 	return 0;
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 07ab6e8..8471f40 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -807,12 +807,43 @@ int __init parse_ioapics_under_ir(void)
 	return 1;
 }
 
+static int device_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	switch (action) {
+	case BUS_NOTIFY_DEL_DEVICE:
+		remove_dev_from_drhd(pdev);
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		restore_dev_to_drhd(pdev);
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block device_nb = {
+	.notifier_call = device_notifier,
+};
+
 int __init ir_dev_scope_init(void)
 {
+	int ret;
+
 	if (!irq_remapping_enabled)
 		return 0;
 
-	return dmar_dev_scope_init();
+	ret = dmar_dev_scope_init();
+	if (ret < 0)
+		return ret;
+
+	if (intel_iommu_enabled != 1)
+		bus_register_notifier(&pci_bus_type, &device_nb);
+
+	return ret;
 }
 rootfs_initcall(ir_dev_scope_init);
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index b029d1a..0a3dd71 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -131,6 +131,11 @@ extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
+void remove_dev_from_drhd(struct pci_dev *dev);
+void restore_dev_to_drhd(struct pci_dev *dev);
+void remove_dev_from_atsr(struct pci_dev *dev);
+void restore_dev_to_atsr(struct pci_dev *dev);
+
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
@@ -146,14 +151,19 @@ struct dmar_rmrr_unit {
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
+extern struct list_head dmar_atsr_units;
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
 	struct pci_dev **devices;	/* target devices */
 	int devices_cnt;		/* target device count */
+	u16 segment;			/* PCI domain */
 	u8 include_all:1;		/* include all ports */
 };
 
+#define for_each_atsr_unit(atsr) \
+	list_for_each_entry(atsr, &dmar_atsr_units, list)
+
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-- 
1.8.4

