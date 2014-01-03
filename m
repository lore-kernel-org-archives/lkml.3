Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaACAH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:07:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaACAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>
Subject: [PATCH v2 09/10] IOMMU: Add dmar_parse_one_drhd()
Date: Thu,  2 Jan 2014 16:08:16 -0800
Message-Id: <1388707697-16800-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To parse new hot-added iommu dmar entry table

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Donald Dutile <ddutile@redhat.com>
---
 drivers/iommu/dmar.c | 51 +++++++++++++++++++++++++++++++++++++++++----------
 include/linux/dmar.h | 47 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 79 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 78e75ad..31d7942 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -167,8 +167,9 @@ int dmar_parse_dev_scope(void *start, void *end, int *cnt,
  * structure which uniquely represent one DMA remapping hardware unit
  * present in the platform
  */
-static int __init
-dmar_parse_one_drhd(struct acpi_dmar_header *header)
+static int
+__dmar_parse_one_drhd(struct acpi_dmar_header *header,
+		      struct dmar_drhd_unit **pdmaru)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct dmar_drhd_unit *dmaru;
@@ -190,10 +191,18 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 		return ret;
 	}
 	dmar_register_drhd_unit(dmaru);
+	if (pdmaru)
+		*pdmaru = dmaru;
 	return 0;
 }
 
-static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
+static int __init
+dmar_parse_one_drhd(struct acpi_dmar_header *header)
+{
+	return __dmar_parse_one_drhd(header, NULL);
+}
+
+static int dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	int ret = 0;
@@ -214,10 +223,10 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
 	return ret;
 }
 
-#ifdef CONFIG_ACPI_NUMA
-static int __init
+static int
 dmar_parse_one_rhsa(struct acpi_dmar_header *header)
 {
+#ifdef CONFIG_ACPI_NUMA
 	struct acpi_dmar_rhsa *rhsa;
 	struct dmar_drhd_unit *drhd;
 
@@ -241,12 +250,11 @@ dmar_parse_one_rhsa(struct acpi_dmar_header *header)
 		dmi_get_system_info(DMI_BIOS_VERSION),
 		dmi_get_system_info(DMI_PRODUCT_VERSION));
 
+#endif
 	return 0;
 }
-#endif
 
-static void __init
-dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
+static void dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_reserved_memory *rmrr;
@@ -358,9 +366,7 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_atsr(entry_header);
 			break;
 		case ACPI_DMAR_HARDWARE_AFFINITY:
-#ifdef CONFIG_ACPI_NUMA
 			ret = dmar_parse_one_rhsa(entry_header);
-#endif
 			break;
 		default:
 			pr_warn("Unknown DMAR structure type %d\n",
@@ -545,6 +551,23 @@ void restore_dev_to_drhd(struct pci_dev *dev)
 		drhd->devices[i] = pci_dev_get(dev);
 }
 
+static void remove_dmaru_from_saved_list(void *drhd,
+				  struct list_head *lh)
+{
+	struct dev_dmaru *m, *n;
+
+	list_for_each_entry_safe(m, n, lh, list) {
+		if (m->dmaru == drhd) {
+			list_del(&m->list);
+			kfree(m);
+		}
+	}
+}
+static void remove_dmaru_from_saved_dev_drhd_list(void *drhd)
+{
+	remove_dmaru_from_saved_list(drhd, &saved_dev_drhd_list);
+}
+
 #ifdef CONFIG_INTEL_IOMMU
 static LIST_HEAD(saved_dev_atsr_list);
 void remove_dev_from_atsr(struct pci_dev *dev)
@@ -587,6 +610,14 @@ void restore_dev_to_atsr(struct pci_dev *dev)
 	if (atsr)
 		atsr->devices[i] = pci_dev_get(dev);
 }
+static void remove_atsru_from_saved_dev_atsru_list(void *atsr)
+{
+	remove_dmaru_from_saved_list(atsr, &saved_dev_atsr_list);
+}
+#else
+static void remove_atsru_from_saved_dev_atsru_list(struct dmar_atsr_unit *atsr)
+{
+}
 #endif  /* CONFIG_INTEL_IOMMU */
 
 int __init dmar_table_init(void)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 0a3dd71..81e8678 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -33,6 +33,7 @@ struct acpi_dmar_header;
 #define DMAR_X2APIC_OPT_OUT	0x2
 
 struct intel_iommu;
+struct dmar_drhd_unit;
 #ifdef CONFIG_DMAR_TABLE
 extern struct acpi_table_header *dmar_tbl;
 struct dmar_drhd_unit {
@@ -136,6 +137,15 @@ void restore_dev_to_drhd(struct pci_dev *dev);
 void remove_dev_from_atsr(struct pci_dev *dev);
 void restore_dev_to_atsr(struct pci_dev *dev);
 
+struct dmar_atsr_unit {
+	struct list_head list;		/* list of ATSR units */
+	struct acpi_dmar_header *hdr;	/* ACPI header */
+	struct pci_dev **devices;	/* target devices */
+	int devices_cnt;		/* target device count */
+	u16 segment;			/* PCI domain */
+	u8 include_all:1;		/* include all ports */
+};
+
 #ifdef CONFIG_INTEL_IOMMU
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
@@ -152,24 +162,19 @@ struct dmar_rmrr_unit {
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 
 extern struct list_head dmar_atsr_units;
-struct dmar_atsr_unit {
-	struct list_head list;		/* list of ATSR units */
-	struct acpi_dmar_header *hdr;	/* ACPI header */
-	struct pci_dev **devices;	/* target devices */
-	int devices_cnt;		/* target device count */
-	u16 segment;			/* PCI domain */
-	u8 include_all:1;		/* include all ports */
-};
-
 #define for_each_atsr_unit(atsr) \
 	list_for_each_entry(atsr, &dmar_atsr_units, list)
 
 int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
+int __dmar_parse_one_atsr(struct acpi_dmar_header *header,
+			  struct dmar_atsr_unit **patsru);
+int atsr_parse_dev(struct dmar_atsr_unit *atsru);
 extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
 				struct pci_dev ***devices, u16 segment);
 extern int intel_iommu_init(void);
+int init_dmar_one(struct dmar_drhd_unit *drhd);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
 static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
@@ -180,10 +185,34 @@ static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
 {
 	return 0;
 }
+static inline int __dmar_parse_one_atsr(struct acpi_dmar_header *header,
+			  struct dmar_atsr_unit **patsru)
+{
+	return 0;
+}
+static inline int atsr_parse_dev(struct dmar_atsr_unit *atsru)
+{
+	return 0;
+}
 static inline int dmar_parse_rmrr_atsr_dev(void)
 {
 	return 0;
 }
+static inline int init_dmar_one(struct dmar_drhd_unit *drhd)
+{
+	return 0;
+}
 #endif /* CONFIG_INTEL_IOMMU */
 
+#ifdef CONFIG_IRQ_REMAP
+void disable_irq_remapping_one(struct dmar_drhd_unit *drhd);
+int intel_enable_irq_remapping_one(struct dmar_drhd_unit *drhd);
+#else
+static inline void disable_irq_remapping_one(struct dmar_drhd_unit *drhd) { }
+static inline int intel_enable_irq_remapping_one(struct dmar_drhd_unit *drhd)
+{
+	return 0;
+}
+#endif
+
 #endif /* __DMAR_H__ */
-- 
1.8.4

