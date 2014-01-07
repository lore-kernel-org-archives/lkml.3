Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaAGJDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:03:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:3277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbaAGJAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739971"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 09/14] iommu/vt-d: introduce a rwsem to protect global data structures
Date: Tue,  7 Jan 2014 17:00:29 +0800
Message-Id: <1389085234-22296-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a global rwsem dmar_global_lock, which will be used to
protect DMAR related global data structures from DMAR/PCI/memory
device hotplug operations in process context.

DMA and interrupt remapping related data structures are read most,
and only change when memory/PCI/DMAR hotplug event happens.
So a global rwsem solution is adopted for balance between simplicity
and performance.

For interrupt remapping driver, function intel_irq_remapping_supported(),
dmar_table_init(), intel_enable_irq_remapping(), disable_irq_remapping(),
reenable_irq_remapping() and enable_drhd_fault_handling() etc
are called during booting, suspending and resuming with interrupt
disabled, so no need to take the global lock.

For interrupt remapping entry allocation, the locking model is:
	down_read(&dmar_global_lock);
	/* Find corresponding iommu */
	iommu = map_hpet_to_ir(id);
	if (iommu)
		/*
		 * Allocate remapping entry and mark entry busy,
		 * the IOMMU won't be hot-removed until the
		 * allocated entry has been released.
		 */
		index = alloc_irte(iommu, irq, 1);
	up_read(&dmar_global_lock);

For DMA remmaping driver, we only uses the dmar_global_lock rwsem to
protect functions which are only called in process context. For any
function which may be called in interrupt context, we will use RCU
to protect them in following patches.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c                |   19 +++++-
 drivers/iommu/intel-iommu.c         |    5 ++
 drivers/iommu/intel_irq_remapping.c |  108 +++++++++++++++++++++++------------
 include/linux/dmar.h                |    2 +
 4 files changed, 95 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index ff33866..2831442 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -43,10 +43,19 @@
 
 #include "irq_remapping.h"
 
-/* No locks are needed as DMA remapping hardware unit
- * list is constructed at boot time and hotplug of
- * these units are not supported by the architecture.
+/*
+ * Assumptions:
+ * 1) The hotplug framework guarentees that DMAR unit will be hot-added
+ *    before IO devices managed by that unit.
+ * 2) The hotplug framework guarantees that DMAR unit will be hot-removed
+ *    after IO devices managed by that unit.
+ * 3) Hotplug events are rare.
+ *
+ * Locking rules for DMA and interrupt remapping related global data structures:
+ * 1) Use dmar_global_lock in process context
+ * 2) Use RCU in interrupt context
  */
+DECLARE_RWSEM(dmar_global_lock);
 LIST_HEAD(dmar_drhd_units);
 
 struct acpi_table_header * __initdata dmar_tbl;
@@ -565,6 +574,7 @@ static int __init detect_intel_iommu(void)
 {
 	int ret;
 
+	down_write(&dmar_global_lock);
 	ret = dmar_table_detect();
 	if (ret)
 		ret = check_zero_address();
@@ -582,6 +592,7 @@ static int __init detect_intel_iommu(void)
 	}
 	early_acpi_os_unmap_memory((void __iomem *)dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
+	up_write(&dmar_global_lock);
 
 	return ret ? 1 : -ENODEV;
 }
@@ -1394,10 +1405,12 @@ static int __init dmar_free_unused_resources(void)
 	if (irq_remapping_enabled || intel_iommu_enabled)
 		return 0;
 
+	down_write(&dmar_global_lock);
 	list_for_each_entry_safe(dmaru, dmaru_n, &dmar_drhd_units, list) {
 		list_del(&dmaru->list);
 		dmar_free_drhd(dmaru);
 	}
+	up_write(&dmar_global_lock);
 
 	return 0;
 }
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 7e043ca..25e9b84 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3627,6 +3627,7 @@ static int device_notifier(struct notifier_block *nb,
 	if (!domain)
 		return 0;
 
+	down_read(&dmar_global_lock);
 	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
@@ -3635,6 +3636,7 @@ static int device_notifier(struct notifier_block *nb,
 		    list_empty(&domain->devices))
 			domain_exit(domain);
 	}
+	up_read(&dmar_global_lock);
 
 	return 0;
 }
@@ -3652,6 +3654,7 @@ int __init intel_iommu_init(void)
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
+	down_write(&dmar_global_lock);
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
@@ -3701,6 +3704,7 @@ int __init intel_iommu_init(void)
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
 		goto out_free_reserved_range;
 	}
+	up_write(&dmar_global_lock);
 	printk(KERN_INFO
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
 
@@ -3726,6 +3730,7 @@ out_free_mempool:
 	iommu_exit_mempool();
 out_free_dmar:
 	intel_iommu_free_dmars();
+	up_write(&dmar_global_lock);
 	return ret;
 }
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f307a3f..009a2bb 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -38,6 +38,17 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
 static int ir_ioapic_num, ir_hpet_num;
 
+/*
+ * Lock ordering:
+ * ->dmar_global_lock
+ *	->irq_2_ir_lock
+ *		->qi->q_lock
+ *	->iommu->register_lock
+ * Note:
+ * intel_irq_remap_ops.{supported,prepare,enable,disable,reenable} are called
+ * in single-threaded environment with interrupt disabled, so no need to tabke
+ * the dmar_global_lock.
+ */
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
 static int __init parse_ioapics_under_ir(void);
@@ -312,12 +323,14 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 	if (!irte)
 		return -1;
 
+	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_IO_APICS; i++) {
 		if (ir_ioapic[i].id == apic) {
 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
 			break;
 		}
 	}
+	up_read(&dmar_global_lock);
 
 	if (sid == 0) {
 		pr_warning("Failed to set source-id of IOAPIC (%d)\n", apic);
@@ -337,12 +350,14 @@ static int set_hpet_sid(struct irte *irte, u8 id)
 	if (!irte)
 		return -1;
 
+	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_HPET_TBS; i++) {
 		if (ir_hpet[i].id == id) {
 			sid = (ir_hpet[i].bus << 8) | ir_hpet[i].devfn;
 			break;
 		}
 	}
+	up_read(&dmar_global_lock);
 
 	if (sid == 0) {
 		pr_warning("Failed to set source-id of HPET block (%d)\n", id);
@@ -799,10 +814,16 @@ static int __init parse_ioapics_under_ir(void)
 
 static int __init ir_dev_scope_init(void)
 {
+	int ret;
+
 	if (!irq_remapping_enabled)
 		return 0;
 
-	return dmar_dev_scope_init();
+	down_write(&dmar_global_lock);
+	ret = dmar_dev_scope_init();
+	up_write(&dmar_global_lock);
+
+	return ret;
 }
 rootfs_initcall(ir_dev_scope_init);
 
@@ -883,23 +904,27 @@ static int intel_setup_ioapic_entry(int irq,
 				    struct io_apic_irq_attr *attr)
 {
 	int ioapic_id = mpc_ioapic_id(attr->ioapic);
-	struct intel_iommu *iommu = map_ioapic_to_ir(ioapic_id);
+	struct intel_iommu *iommu;
 	struct IR_IO_APIC_route_entry *entry;
 	struct irte irte;
 	int index;
 
+	down_read(&dmar_global_lock);
+	iommu = map_ioapic_to_ir(ioapic_id);
 	if (!iommu) {
 		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
-		return -ENODEV;
-	}
-
-	entry = (struct IR_IO_APIC_route_entry *)route_entry;
-
-	index = alloc_irte(iommu, irq, 1);
-	if (index < 0) {
-		pr_warn("Failed to allocate IRTE for ioapic %d\n", ioapic_id);
-		return -ENOMEM;
+		index = -ENODEV;
+	} else {
+		index = alloc_irte(iommu, irq, 1);
+		if (index < 0) {
+			pr_warn("Failed to allocate IRTE for ioapic %d\n",
+				ioapic_id);
+			index = -ENOMEM;
+		}
 	}
+	up_read(&dmar_global_lock);
+	if (index < 0)
+		return index;
 
 	prepare_irte(&irte, vector, destination);
 
@@ -918,6 +943,7 @@ static int intel_setup_ioapic_entry(int irq,
 		irte.avail, irte.vector, irte.dest_id,
 		irte.sid, irte.sq, irte.svt);
 
+	entry = (struct IR_IO_APIC_route_entry *)route_entry;
 	memset(entry, 0, sizeof(*entry));
 
 	entry->index2	= (index >> 15) & 0x1;
@@ -1048,20 +1074,23 @@ static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
 	struct intel_iommu *iommu;
 	int index;
 
+	down_read(&dmar_global_lock);
 	iommu = map_dev_to_ir(dev);
 	if (!iommu) {
 		printk(KERN_ERR
 		       "Unable to map PCI %s to iommu\n", pci_name(dev));
-		return -ENOENT;
+		index = -ENOENT;
+	} else {
+		index = alloc_irte(iommu, irq, nvec);
+		if (index < 0) {
+			printk(KERN_ERR
+			       "Unable to allocate %d IRTE for PCI %s\n",
+			       nvec, pci_name(dev));
+			index = -ENOSPC;
+		}
 	}
+	up_read(&dmar_global_lock);
 
-	index = alloc_irte(iommu, irq, nvec);
-	if (index < 0) {
-		printk(KERN_ERR
-		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
-		       pci_name(dev));
-		return -ENOSPC;
-	}
 	return index;
 }
 
@@ -1069,33 +1098,40 @@ static int intel_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 			       int index, int sub_handle)
 {
 	struct intel_iommu *iommu;
+	int ret = -ENOENT;
 
+	down_read(&dmar_global_lock);
 	iommu = map_dev_to_ir(pdev);
-	if (!iommu)
-		return -ENOENT;
-	/*
-	 * setup the mapping between the irq and the IRTE
-	 * base index, the sub_handle pointing to the
-	 * appropriate interrupt remap table entry.
-	 */
-	set_irte_irq(irq, iommu, index, sub_handle);
+	if (iommu) {
+		/*
+		 * setup the mapping between the irq and the IRTE
+		 * base index, the sub_handle pointing to the
+		 * appropriate interrupt remap table entry.
+		 */
+		set_irte_irq(irq, iommu, index, sub_handle);
+		ret = 0;
+	}
+	up_read(&dmar_global_lock);
 
-	return 0;
+	return ret;
 }
 
 static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
-	struct intel_iommu *iommu = map_hpet_to_ir(id);
+	int ret = -1;
+	struct intel_iommu *iommu;
 	int index;
 
-	if (!iommu)
-		return -1;
-
-	index = alloc_irte(iommu, irq, 1);
-	if (index < 0)
-		return -1;
+	down_read(&dmar_global_lock);
+	iommu = map_hpet_to_ir(id);
+	if (iommu) {
+		index = alloc_irte(iommu, irq, 1);
+		if (index >= 0)
+			ret = 0;
+	}
+	up_read(&dmar_global_lock);
 
-	return 0;
+	return ret;
 }
 
 struct irq_remap_ops intel_irq_remap_ops = {
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 8aa7561..9572a4f 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
+#include <linux/rwsem.h>
 
 struct acpi_dmar_header;
 
@@ -48,6 +49,7 @@ struct dmar_drhd_unit {
 	struct intel_iommu *iommu;
 };
 
+extern struct rw_semaphore dmar_global_lock;
 extern struct list_head dmar_drhd_units;
 
 #define for_each_drhd_unit(drhd) \
-- 
1.7.10.4

