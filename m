Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbaEFHIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:08:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:54817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934236AbaEFHEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:04:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526662245"
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
Subject: [Patch Part3 V2 08/21] iommu/VT-d: simplify include/linux/dmar.h
Date: Tue,  6 May 2014 15:05:19 +0800
Message-Id: <1399359932-28972-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify include/linux/dmar.h a bit based on the fact that
both CONFIG_INTEL_IOMMU and CONFIG_IRQ_REMAP select CONFIG_DMAR_TABLE.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/dmar.h |   50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 23c8db129560..1deece46a0ca 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -114,22 +114,30 @@ extern int dmar_remove_dev_scope(struct dmar_pci_notify_info *info,
 /* Intel IOMMU detection */
 extern int detect_intel_iommu(void);
 extern int enable_drhd_fault_handling(void);
-#else
-struct dmar_pci_notify_info;
-static inline int detect_intel_iommu(void)
+
+#ifdef CONFIG_INTEL_IOMMU
+extern int iommu_detected, no_iommu;
+extern int intel_iommu_init(void);
+extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
+extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
+#else /* !CONFIG_INTEL_IOMMU: */
+static inline int intel_iommu_init(void) { return -ENODEV; }
+static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
-	return -ENODEV;
+	return 0;
 }
-
-static inline int dmar_table_init(void)
+static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
 {
-	return -ENODEV;
+	return 0;
 }
-static inline int enable_drhd_fault_handling(void)
+static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
 {
-	return -1;
+	return 0;
 }
-#endif /* !CONFIG_DMAR_TABLE */
+#endif /* CONFIG_INTEL_IOMMU */
+
+#endif /* CONFIG_DMAR_TABLE */
 
 struct irte {
 	union {
@@ -177,26 +185,4 @@ extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
-#ifdef CONFIG_INTEL_IOMMU
-extern int iommu_detected, no_iommu;
-extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
-extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
-extern int intel_iommu_init(void);
-#else /* !CONFIG_INTEL_IOMMU: */
-static inline int intel_iommu_init(void) { return -ENODEV; }
-static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
-{
-	return 0;
-}
-static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
-{
-	return 0;
-}
-static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
-{
-	return 0;
-}
-#endif /* CONFIG_INTEL_IOMMU */
-
 #endif /* __DMAR_H__ */
-- 
1.7.10.4

