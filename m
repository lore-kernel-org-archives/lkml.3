Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaKIOpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:45:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:9864 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbaKIOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485940446"
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
Subject: [Patch Part3 V7 5/8] iommu/vt-d: Enhance intel_irq_remapping driver to support DMAR unit hotplug
Date: Sun,  9 Nov 2014 22:48:00 +0800
Message-Id: <1415544483-27990-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement required callback functions for intel_irq_remapping driver
to support DMAR unit hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |  238 ++++++++++++++++++++++++++---------
 1 file changed, 178 insertions(+), 60 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 1cbdb509bc7b..7af0b56dc2d1 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -36,7 +36,6 @@ struct hpet_scope {
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
-static int ir_ioapic_num, ir_hpet_num;
 
 /*
  * Lock ordering:
@@ -206,7 +205,7 @@ static struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 	int i;
 
 	for (i = 0; i < MAX_HPET_TBS; i++)
-		if (ir_hpet[i].id == hpet_id)
+		if (ir_hpet[i].id == hpet_id && ir_hpet[i].iommu)
 			return ir_hpet[i].iommu;
 	return NULL;
 }
@@ -216,7 +215,7 @@ static struct intel_iommu *map_ioapic_to_ir(int apic)
 	int i;
 
 	for (i = 0; i < MAX_IO_APICS; i++)
-		if (ir_ioapic[i].id == apic)
+		if (ir_ioapic[i].id == apic && ir_ioapic[i].iommu)
 			return ir_ioapic[i].iommu;
 	return NULL;
 }
@@ -325,7 +324,7 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 
 	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_IO_APICS; i++) {
-		if (ir_ioapic[i].id == apic) {
+		if (ir_ioapic[i].iommu && ir_ioapic[i].id == apic) {
 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
 			break;
 		}
@@ -352,7 +351,7 @@ static int set_hpet_sid(struct irte *irte, u8 id)
 
 	down_read(&dmar_global_lock);
 	for (i = 0; i < MAX_HPET_TBS; i++) {
-		if (ir_hpet[i].id == id) {
+		if (ir_hpet[i].iommu && ir_hpet[i].id == id) {
 			sid = (ir_hpet[i].bus << 8) | ir_hpet[i].devfn;
 			break;
 		}
@@ -473,17 +472,17 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
-
-static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
+static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
 	unsigned long *bitmap;
 
-	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
-					     GFP_ATOMIC);
+	if (iommu->ir_table)
+		return 0;
 
-	if (!iommu->ir_table)
+	ir_table = kzalloc(sizeof(struct ir_table), GFP_ATOMIC);
+	if (!ir_table)
 		return -ENOMEM;
 
 	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
@@ -492,24 +491,37 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 	if (!pages) {
 		pr_err("IR%d: failed to allocate pages of order %d\n",
 		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
-		kfree(iommu->ir_table);
-		return -ENOMEM;
+		goto out_free_table;
 	}
 
 	bitmap = kcalloc(BITS_TO_LONGS(INTR_REMAP_TABLE_ENTRIES),
 			 sizeof(long), GFP_ATOMIC);
 	if (bitmap == NULL) {
 		pr_err("IR%d: failed to allocate bitmap\n", iommu->seq_id);
-		__free_pages(pages, INTR_REMAP_PAGE_ORDER);
-		kfree(ir_table);
-		return -ENOMEM;
+		goto out_free_pages;
 	}
 
 	ir_table->base = page_address(pages);
 	ir_table->bitmap = bitmap;
-
-	iommu_set_irq_remapping(iommu, mode);
+	iommu->ir_table = ir_table;
 	return 0;
+
+out_free_pages:
+	__free_pages(pages, INTR_REMAP_PAGE_ORDER);
+out_free_table:
+	kfree(ir_table);
+	return -ENOMEM;
+}
+
+static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
+{
+	if (iommu && iommu->ir_table) {
+		free_pages((unsigned long)iommu->ir_table->base,
+			   INTR_REMAP_PAGE_ORDER);
+		kfree(iommu->ir_table->bitmap);
+		kfree(iommu->ir_table);
+		iommu->ir_table = NULL;
+	}
 }
 
 /*
@@ -666,9 +678,10 @@ static int __init intel_enable_irq_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (intel_setup_irq_remapping(iommu, eim))
+		if (intel_setup_irq_remapping(iommu))
 			goto error;
 
+		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
 
@@ -699,12 +712,13 @@ error:
 	return -1;
 }
 
-static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static int ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
+				   struct intel_iommu *iommu,
+				   struct acpi_dmar_hardware_unit *drhd)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
-	int count;
+	int count, free = -1;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -720,19 +734,36 @@ static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
 					   PCI_SECONDARY_BUS);
 		path++;
 	}
-	ir_hpet[ir_hpet_num].bus   = bus;
-	ir_hpet[ir_hpet_num].devfn = PCI_DEVFN(path->device, path->function);
-	ir_hpet[ir_hpet_num].iommu = iommu;
-	ir_hpet[ir_hpet_num].id    = scope->enumeration_id;
-	ir_hpet_num++;
+
+	for (count = 0; count < MAX_HPET_TBS; count++) {
+		if (ir_hpet[count].iommu == iommu &&
+		    ir_hpet[count].id == scope->enumeration_id)
+			return 0;
+		else if (ir_hpet[count].iommu == NULL && free == -1)
+			free = count;
+	}
+	if (free == -1) {
+		pr_warn("Exceeded Max HPET blocks\n");
+		return -ENOSPC;
+	}
+
+	ir_hpet[free].iommu = iommu;
+	ir_hpet[free].id    = scope->enumeration_id;
+	ir_hpet[free].bus   = bus;
+	ir_hpet[free].devfn = PCI_DEVFN(path->device, path->function);
+	pr_info("HPET id %d under DRHD base 0x%Lx\n",
+		scope->enumeration_id, drhd->address);
+
+	return 0;
 }
 
-static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static int ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
+				     struct intel_iommu *iommu,
+				     struct acpi_dmar_hardware_unit *drhd)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
-	int count;
+	int count, free = -1;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -749,54 +780,63 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 		path++;
 	}
 
-	ir_ioapic[ir_ioapic_num].bus   = bus;
-	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->device, path->function);
-	ir_ioapic[ir_ioapic_num].iommu = iommu;
-	ir_ioapic[ir_ioapic_num].id    = scope->enumeration_id;
-	ir_ioapic_num++;
+	for (count = 0; count < MAX_IO_APICS; count++) {
+		if (ir_ioapic[count].iommu == iommu &&
+		    ir_ioapic[count].id == scope->enumeration_id)
+			return 0;
+		else if (ir_ioapic[count].iommu == NULL && free == -1)
+			free = count;
+	}
+	if (free == -1) {
+		pr_warn("Exceeded Max IO APICS\n");
+		return -ENOSPC;
+	}
+
+	ir_ioapic[free].bus   = bus;
+	ir_ioapic[free].devfn = PCI_DEVFN(path->device, path->function);
+	ir_ioapic[free].iommu = iommu;
+	ir_ioapic[free].id    = scope->enumeration_id;
+	pr_info("IOAPIC id %d under DRHD base  0x%Lx IOMMU %d\n",
+		scope->enumeration_id, drhd->address, iommu->seq_id);
+
+	return 0;
 }
 
 static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
 				      struct intel_iommu *iommu)
 {
+	int ret = 0;
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;
 	void *start, *end;
 
 	drhd = (struct acpi_dmar_hardware_unit *)header;
-
 	start = (void *)(drhd + 1);
 	end = ((void *)drhd) + header->length;
 
-	while (start < end) {
+	while (start < end && ret == 0) {
 		scope = start;
-		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
-			if (ir_ioapic_num == MAX_IO_APICS) {
-				printk(KERN_WARNING "Exceeded Max IO APICS\n");
-				return -1;
-			}
-
-			printk(KERN_INFO "IOAPIC id %d under DRHD base "
-			       " 0x%Lx IOMMU %d\n", scope->enumeration_id,
-			       drhd->address, iommu->seq_id);
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC)
+			ret = ir_parse_one_ioapic_scope(scope, iommu, drhd);
+		else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET)
+			ret = ir_parse_one_hpet_scope(scope, iommu, drhd);
+		start += scope->length;
+	}
 
-			ir_parse_one_ioapic_scope(scope, iommu);
-		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
-			if (ir_hpet_num == MAX_HPET_TBS) {
-				printk(KERN_WARNING "Exceeded Max HPET blocks\n");
-				return -1;
-			}
+	return ret;
+}
 
-			printk(KERN_INFO "HPET id %d under DRHD base"
-			       " 0x%Lx\n", scope->enumeration_id,
-			       drhd->address);
+static void ir_remove_ioapic_hpet_scope(struct intel_iommu *iommu)
+{
+	int i;
 
-			ir_parse_one_hpet_scope(scope, iommu);
-		}
-		start += scope->length;
-	}
+	for (i = 0; i < MAX_HPET_TBS; i++)
+		if (ir_hpet[i].iommu == iommu)
+			ir_hpet[i].iommu = NULL;
 
-	return 0;
+	for (i = 0; i < MAX_IO_APICS; i++)
+		if (ir_ioapic[i].iommu == iommu)
+			ir_ioapic[i].iommu = NULL;
 }
 
 /*
@@ -1172,7 +1212,85 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.alloc_hpet_msi		= intel_alloc_hpet_msi,
 };
 
+/*
+ * Support of Interrupt Remapping Unit Hotplug
+ */
+static int dmar_ir_add(struct dmar_drhd_unit *dmaru, struct intel_iommu *iommu)
+{
+	int ret;
+	int eim = x2apic_enabled();
+
+	if (eim && !ecap_eim_support(iommu->ecap)) {
+		pr_info("DRHD %Lx: EIM not supported by DRHD, ecap %Lx\n",
+			iommu->reg_phys, iommu->ecap);
+		return -ENODEV;
+	}
+
+	if (ir_parse_ioapic_hpet_scope(dmaru->hdr, iommu)) {
+		pr_warn("DRHD %Lx: failed to parse managed IOAPIC/HPET\n",
+			iommu->reg_phys);
+		return -ENODEV;
+	}
+
+	/* TODO: check all IOAPICs are covered by IOMMU */
+
+	/* Setup Interrupt-remapping now. */
+	ret = intel_setup_irq_remapping(iommu);
+	if (ret) {
+		pr_err("DRHD %Lx: failed to allocate resource\n",
+		       iommu->reg_phys);
+		ir_remove_ioapic_hpet_scope(iommu);
+		return ret;
+	}
+
+	if (!iommu->qi) {
+		/* Clear previous faults. */
+		dmar_fault(-1, iommu);
+		iommu_disable_irq_remapping(iommu);
+		dmar_disable_qi(iommu);
+	}
+
+	/* Enable queued invalidation */
+	ret = dmar_enable_qi(iommu);
+	if (!ret) {
+		iommu_set_irq_remapping(iommu, eim);
+	} else {
+		pr_err("DRHD %Lx: failed to enable queued invalidation, ecap %Lx, ret %d\n",
+		       iommu->reg_phys, iommu->ecap, ret);
+		intel_teardown_irq_remapping(iommu);
+		ir_remove_ioapic_hpet_scope(iommu);
+	}
+
+	return ret;
+}
+
 int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
 {
-	return irq_remapping_enabled ? -ENOSYS : 0;
+	int ret = 0;
+	struct intel_iommu *iommu = dmaru->iommu;
+
+	if (!irq_remapping_enabled)
+		return 0;
+	if (iommu == NULL)
+		return -EINVAL;
+	if (!ecap_ir_support(iommu->ecap))
+		return 0;
+
+	if (insert) {
+		if (!iommu->ir_table)
+			ret = dmar_ir_add(dmaru, iommu);
+	} else {
+		if (iommu->ir_table) {
+			if (!bitmap_empty(iommu->ir_table->bitmap,
+					  INTR_REMAP_TABLE_ENTRIES)) {
+				ret = -EBUSY;
+			} else {
+				iommu_disable_irq_remapping(iommu);
+				intel_teardown_irq_remapping(iommu);
+				ir_remove_ioapic_hpet_scope(iommu);
+			}
+		}
+	}
+
+	return ret;
 }
-- 
1.7.10.4

