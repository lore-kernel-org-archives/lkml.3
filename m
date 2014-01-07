Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbaAGJHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:07:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:40167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaAGJAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739644"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 02/14] iommu/vt-d: move private structures and variables into intel-iommu.c
Date: Tue,  7 Jan 2014 17:00:22 +0800
Message-Id: <1389085234-22296-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move private structures and variables into intel-iommu.c, which will
help to simplify locking policy for hotplug. Also delete redundant
declarations.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++------
 include/linux/dmar.h        |   23 +----------------------
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0863e25..1704e97 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -380,6 +380,29 @@ struct device_domain_info {
 	struct dmar_domain *domain; /* pointer to domain */
 };
 
+struct dmar_rmrr_unit {
+	struct list_head list;		/* list of rmrr units	*/
+	struct acpi_dmar_header *hdr;	/* ACPI header		*/
+	u64	base_address;		/* reserved base address*/
+	u64	end_address;		/* reserved end address */
+	struct pci_dev **devices;	/* target devices */
+	int	devices_cnt;		/* target device count */
+};
+
+struct dmar_atsr_unit {
+	struct list_head list;		/* list of ATSR units */
+	struct acpi_dmar_header *hdr;	/* ACPI header */
+	struct pci_dev **devices;	/* target devices */
+	int devices_cnt;		/* target device count */
+	u8 include_all:1;		/* include all ports */
+};
+
+static LIST_HEAD(dmar_atsr_units);
+static LIST_HEAD(dmar_rmrr_units);
+
+#define for_each_rmrr_units(rmrr) \
+	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
+
 static void flush_unmaps_timeout(unsigned long data);
 
 static DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
@@ -403,6 +426,8 @@ static int timer_on;
 static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
+static void domain_remove_one_dev_info(struct dmar_domain *domain,
+				       struct pci_dev *pdev);
 
 #ifdef CONFIG_INTEL_IOMMU_DEFAULT_ON
 int dmar_disabled = 0;
@@ -2243,8 +2268,6 @@ static int __init si_domain_init(int hw)
 	return 0;
 }
 
-static void domain_remove_one_dev_info(struct dmar_domain *domain,
-					  struct pci_dev *pdev);
 static int identity_mapping(struct pci_dev *pdev)
 {
 	struct device_domain_info *info;
@@ -3430,8 +3453,6 @@ static void __init init_iommu_pm_ops(void)
 static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
-LIST_HEAD(dmar_rmrr_units);
-
 static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
 {
 	list_add(&rmrr->list, &dmar_rmrr_units);
@@ -3468,8 +3489,6 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
 				    rmrr->segment);
 }
 
-static LIST_HEAD(dmar_atsr_units);
-
 int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 {
 	struct acpi_dmar_atsr *atsr;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 198eb09..dc8c7d5 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -127,28 +127,7 @@ extern int arch_setup_dmar_msi(unsigned int irq);
 
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
-extern struct list_head dmar_rmrr_units;
-struct dmar_rmrr_unit {
-	struct list_head list;		/* list of rmrr units	*/
-	struct acpi_dmar_header *hdr;	/* ACPI header		*/
-	u64	base_address;		/* reserved base address*/
-	u64	end_address;		/* reserved end address */
-	struct pci_dev **devices;	/* target devices */
-	int	devices_cnt;		/* target device count */
-};
-
-#define for_each_rmrr_units(rmrr) \
-	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
-
-struct dmar_atsr_unit {
-	struct list_head list;		/* list of ATSR units */
-	struct acpi_dmar_header *hdr;	/* ACPI header */
-	struct pci_dev **devices;	/* target devices */
-	int devices_cnt;		/* target device count */
-	u8 include_all:1;		/* include all ports */
-};
-
-int dmar_parse_rmrr_atsr_dev(void);
+extern int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
 extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
-- 
1.7.10.4

