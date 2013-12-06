Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3LFDVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:21:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3LFDVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986923"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org
Subject: [Patch Part1 V2 09/20] iommu/vt-d: mark internal functions as static
Date: Fri,  6 Dec 2013 11:21:12 +0800
Message-Id: <1386300083-6882-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function detect_intel_iommu()/alloc_iommu()/parse_ioapics_under_ir()
are only used internally, so mark them as static.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c                |    9 ++++++---
 drivers/iommu/intel_irq_remapping.c |    4 +++-
 include/linux/dmar.h                |   12 +-----------
 include/linux/intel-iommu.h         |    1 -
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 9a76073..4bbd972 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -52,6 +52,8 @@ LIST_HEAD(dmar_drhd_units);
 struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
 
+static int alloc_iommu(struct dmar_drhd_unit *drhd);
+
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
 	/*
@@ -498,7 +500,7 @@ static void warn_invalid_dmar(u64 addr, const char *message)
 		dmi_get_system_info(DMI_PRODUCT_VERSION));
 }
 
-int __init check_zero_address(void)
+static int __init check_zero_address(void)
 {
 	struct acpi_table_dmar *dmar;
 	struct acpi_dmar_header *entry_header;
@@ -548,7 +550,7 @@ failed:
 	return 0;
 }
 
-int __init detect_intel_iommu(void)
+static int __init detect_intel_iommu(void)
 {
 	int ret;
 
@@ -657,7 +659,7 @@ out:
 	return err;
 }
 
-int alloc_iommu(struct dmar_drhd_unit *drhd)
+static int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
@@ -1374,4 +1376,5 @@ int __init dmar_ir_support(void)
 		return 0;
 	return dmar->flags & 0x1;
 }
+
 IOMMU_INIT_POST(detect_intel_iommu);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 282d392..41e5798 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -40,6 +40,8 @@ static int ir_ioapic_num, ir_hpet_num;
 
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
+static int __init parse_ioapics_under_ir(void);
+
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
 	struct irq_cfg *cfg = irq_get_chip_data(irq);
@@ -771,7 +773,7 @@ static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
  * Finds the assocaition between IOAPIC's and its Interrupt-remapping
  * hardware unit.
  */
-int __init parse_ioapics_under_ir(void)
+static int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int ir_supported = 0;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 8adfce0..f614357 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -33,6 +33,7 @@ struct acpi_dmar_header;
 #define DMAR_X2APIC_OPT_OUT	0x2
 
 struct intel_iommu;
+
 #ifdef CONFIG_DMAR_TABLE
 extern struct acpi_table_header *dmar_tbl;
 struct dmar_drhd_unit {
@@ -62,19 +63,8 @@ extern struct list_head dmar_drhd_units;
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
-
-/* Intel IOMMU detection */
-extern int detect_intel_iommu(void);
 extern int enable_drhd_fault_handling(void);
-
-extern int parse_ioapics_under_ir(void);
-extern int alloc_iommu(struct dmar_drhd_unit *);
 #else
-static inline int detect_intel_iommu(void)
-{
-	return -ENODEV;
-}
-
 static inline int dmar_table_init(void)
 {
 	return -ENODEV;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index de1e5e9..f2c4114 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -348,7 +348,6 @@ static inline void __iommu_flush_cache(
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 extern int dmar_find_matched_atsr_unit(struct pci_dev *dev);
 
-extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
 extern int dmar_enable_qi(struct intel_iommu *iommu);
 extern void dmar_disable_qi(struct intel_iommu *iommu);
-- 
1.7.10.4

