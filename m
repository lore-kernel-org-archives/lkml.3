Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3EQTrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:47:45 -0400
Received: from [207.46.163.28] ([207.46.163.28]:15845 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab3EQTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:47:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMYK8R-02-HKG-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
CC: Steven L Kinney <Steven.Kinney@amd.com>,
        Steven Kinney <steven.kinney@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/2 V3] perf/x86/amd: Adding IOMMU PC resource management
Date: Fri, 17 May 2013 14:43:31 -0500
Message-ID: <1368819813-6481-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven L Kinney <Steven.Kinney@amd.com>

Add functionality to check the availability of the AMD IOMMU Performance
Counters and export this functionality to other core drivers, such as in this
case, a perf AMD IOMMU PMU.  This feature is not bound to any specific AMD
family/model other than the presence of the IOMMU with PC enabled.

The AMD IOMMU PC support static counting only at this time.

Signed-off-by: Steven Kinney <steven.kinney@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
V2 Changes:
	- Modify the amd_iommu_pc_get_set_reg_val function 
	to support 64 bit values. 
	- Fix logic to properly clear amd_iommu_pc_present when
	initialization failed.

 drivers/iommu/amd_iommu_init.c  |  121 ++++++++++++++++++++++++++++++++++++++-
 drivers/iommu/amd_iommu_proto.h |    7 +++
 drivers/iommu/amd_iommu_types.h |   12 +++-
 3 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bf51abb..395fa29 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -154,6 +154,7 @@ bool amd_iommu_iotlb_sup __read_mostly = true;
 u32 amd_iommu_max_pasids __read_mostly = ~0;
 
 bool amd_iommu_v2_present __read_mostly;
+bool amd_iommu_pc_present __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
@@ -371,21 +372,21 @@ static void iommu_disable(struct amd_iommu *iommu)
  */
 static u8 __iomem * __init iommu_map_mmio_space(u64 address)
 {
-	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
+	if (!request_mem_region(address, MMIO_REG_END_OFFSET, "amd_iommu")) {
 		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
 			address);
 		pr_err("AMD-Vi: This is a BIOS bug. Please contact your hardware vendor\n");
 		return NULL;
 	}
 
-	return (u8 __iomem *)ioremap_nocache(address, MMIO_REGION_LENGTH);
+	return (u8 __iomem *)ioremap_nocache(address, MMIO_REG_END_OFFSET);
 }
 
 static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
 {
 	if (iommu->mmio_base)
 		iounmap(iommu->mmio_base);
-	release_mem_region(iommu->mmio_phys, MMIO_REGION_LENGTH);
+	release_mem_region(iommu->mmio_phys, MMIO_REG_END_OFFSET);
 }
 
 /****************************************************************************
@@ -1160,6 +1161,33 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
+
+static void init_iommu_perf_ctr(struct amd_iommu *iommu)
+{
+	u64 val = 0xabcd, val2 = 0;
+
+	if (!iommu_feature(iommu, FEATURE_PC))
+		return;
+
+	amd_iommu_pc_present = true;
+
+	/* Check if the performance counters can be written to */
+	if ((0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val, true)) ||
+	    (0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val2, false)) ||
+	    (val != val2)) {
+		pr_err("AMD-Vi: Unable to write to IOMMU perf counter.\n");
+		amd_iommu_pc_present = false;
+		return;
+	}
+
+	pr_info("AMD-Vi: IOMMU performance counters " "supported\n");
+
+	val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
+	iommu->max_banks = (u8) ((val >> 12) & 0x3f);
+	iommu->max_counters = (u8) ((val >> 7) & 0xf);
+}
+
+
 static int iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
@@ -1226,6 +1254,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
+	init_iommu_perf_ctr(iommu);
+
 	if (is_rd890_iommu(iommu->dev)) {
 		int i, j;
 
@@ -2232,3 +2262,88 @@ bool amd_iommu_v2_supported(void)
 	return amd_iommu_v2_present;
 }
 EXPORT_SYMBOL(amd_iommu_v2_supported);
+
+/****************************************************************************
+ *
+ * IOMMU EFR Performance Counter support functionality. This code allows
+ * access to the IOMMU PC functionality.
+ *
+ ****************************************************************************/
+
+u8 amd_iommu_pc_get_max_banks(u16 devid)
+{
+	struct amd_iommu *iommu;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+
+	if (iommu)
+		return iommu->max_banks;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_max_banks);
+
+bool amd_iommu_pc_supported(void)
+{
+	return amd_iommu_pc_present;
+}
+EXPORT_SYMBOL(amd_iommu_pc_supported);
+
+u8 amd_iommu_pc_get_max_counters(u16 devid)
+{
+	struct amd_iommu *iommu;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+
+	if (iommu)
+		return iommu->max_counters;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_max_counters);
+
+int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    u64 *value, bool is_write)
+{
+	struct amd_iommu *iommu;
+	u32 offset;
+	u32 max_offset_lim;
+
+	/* Make sure the IOMMU PC resource is available */
+	if (!amd_iommu_pc_present) {
+		pr_info("AMD IOMMU - PC Not supported.\n");
+		return -ENODEV;
+	}
+
+	/* locate the iommu associated with the device ID */
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu == NULL)
+		return -ENODEV;
+
+	/* check for valid iommu pc register indexing */
+	if (fxn < 0 || fxn > 0x28 || (fxn & 7))
+		return -ENODEV;
+
+	offset = (u32)(((0x40|bank) << 12) | (cntr << 8) | fxn);
+
+	/* limit the offset to the hw defined mmio region aperture */
+	max_offset_lim = (u32)(((0x40|iommu->max_banks) << 12) |
+				(iommu->max_counters << 8) | 0x28);
+	if ((offset < MMIO_CNTR_REG_OFFSET) ||
+	    (offset > max_offset_lim))
+		return -EINVAL;
+
+	if (is_write) {
+		writel((u32)*value, iommu->mmio_base + offset);
+		writel((*value >> 32), iommu->mmio_base + offset + 4);
+	} else {
+		*value = readl(iommu->mmio_base + offset + 4);
+		*value <<= 32;
+		*value = readl(iommu->mmio_base + offset);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_set_reg_val);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index c294961..95ed6de 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -56,6 +56,13 @@ extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid);
 extern struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev);
 
+/* IOMMU Performance Counter functions */
+extern bool amd_iommu_pc_supported(void);
+extern u8 amd_iommu_pc_get_max_banks(u16 devid);
+extern u8 amd_iommu_pc_get_max_counters(u16 devid);
+extern int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    u64 *value, bool is_write);
+
 #define PPR_SUCCESS			0x0
 #define PPR_INVALID			0x1
 #define PPR_FAILURE			0xf
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0285a21..a95f0ae 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -38,9 +38,6 @@
 #define ALIAS_TABLE_ENTRY_SIZE		2
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
-/* Length of the MMIO region for the AMD IOMMU */
-#define MMIO_REGION_LENGTH       0x4000
-
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
 #define MMIO_RANGE_OFFSET	0x0c
@@ -78,6 +75,10 @@
 #define MMIO_STATUS_OFFSET	0x2020
 #define MMIO_PPR_HEAD_OFFSET	0x2030
 #define MMIO_PPR_TAIL_OFFSET	0x2038
+#define MMIO_CNTR_CONF_OFFSET	0x4000
+#define MMIO_CNTR_REG_OFFSET	0x40000
+#define MMIO_REG_END_OFFSET	0x80000
+
 
 
 /* Extended Feature Bits */
@@ -507,6 +508,7 @@ struct amd_iommu {
 
 	/* physical address of MMIO space */
 	u64 mmio_phys;
+
 	/* virtual address of MMIO space */
 	u8 __iomem *mmio_base;
 
@@ -584,6 +586,10 @@ struct amd_iommu {
 
 	/* The l2 indirect registers */
 	u32 stored_l2[0x83];
+
+	/* The maximum PC banks and counters/bank (PCSup=1) */
+	u8 max_banks;
+	u8 max_counters;
 };
 
 struct devid_map {
-- 
1.7.10.4


