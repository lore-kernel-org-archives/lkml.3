Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3AUUV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:21:57 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:5688 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab3AUUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:21:24 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MGZSJH-01-3FR-02
X-M-MSG: 
From: "Steven L. Kinney" <steven.kinney@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Steven L. Kinney" <steven.kinney@amd.com>
Subject: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks
Date: Mon, 21 Jan 2013 14:20:57 -0600
Message-ID: <1358799658-6236-3-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven L. Kinney" <steven.kinney@amd.com>

Add functionality to check the availability of the AMD IOMMUv2 Performance
Counters and export this functionality to other core drivers, such as in this
case, a perf IOMMUv2 PMU.  This feature is not bound to any specific AMD
family/model other than the presence of the IOMMUv2 with PC enabled.

The IOMMUv2 PC support static counting only at this time.

Signed-off-by: Steven L. Kinney <steven.kinney@amd.com>
---
 drivers/iommu/Kconfig           |   10 ++++
 drivers/iommu/amd_iommu_init.c  |   99 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h |   12 +++++
 3 files changed, 121 insertions(+)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..4a941dd 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -73,6 +73,16 @@ config AMD_IOMMU_V2
 	  hardware. Select this option if you want to use devices that support
 	  the PCI PRI and PASID interface.
 
+# AMD IOMMUv2 Performance Counter support
+config AMD_IOMMU_V2_PC
+	bool "AMD IOMMUv2 Performance Counter (EXPERIMENTAL)"
+	depends on AMD_IOMMU_V2
+	---help---
+	  This option enables support for AMD IOMMUv2 Performance Counters.
+	  Select this option if you want to enable IOMMUv2 Performance
+	  Counter support.
+	  If unsure, say N.
+
 # Intel IOMMU support
 config DMAR_TABLE
 	bool
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 81837b0..f38db14 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -154,6 +154,7 @@ bool amd_iommu_iotlb_sup __read_mostly = true;
 u32 amd_iommu_max_pasids __read_mostly = ~0;
 
 bool amd_iommu_v2_present __read_mostly;
+bool amd_iommu_v2_pc_present __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
@@ -1145,6 +1146,21 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+	if (iommu_feature(iommu, FEATURE_PC)) {
+		u32 val;
+		amd_iommu_v2_pc_present = true;
+		dev_printk(KERN_DEBUG, &iommu->dev->dev,
+			   "AMD-Vi: IOMMUv2 perf counters supported\n");
+		val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
+		iommu->max_banks = (u8) ((val >> 12) & 0x3f);
+		iommu->max_counters = (u8) ((val >> 7) & 0xf);
+		dev_printk(KERN_DEBUG, &iommu->dev->dev,
+			   "AMD-Vi: %d counter banks, %d counters each\n",
+			   iommu->max_banks, iommu->max_counters);
+	}
+#endif
+
 	if (is_rd890_iommu(iommu->dev)) {
 		int i, j;
 
@@ -2076,3 +2092,86 @@ bool amd_iommu_v2_supported(void)
 	return amd_iommu_v2_present;
 }
 EXPORT_SYMBOL(amd_iommu_v2_supported);
+
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+/****************************************************************************
+ *
+ * IOMMUv2 EFR Performance Counter support functionality. This code allows
+ * access to the IOMMUv2 PC functionality.
+ *
+ ****************************************************************************/
+
+u8 amd_iommu_v2_get_max_pc_banks(u16 devid)
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
+EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_banks);
+
+bool amd_iommu_v2_pc_supported(void)
+{
+	return amd_iommu_v2_pc_present;
+}
+EXPORT_SYMBOL(amd_iommu_v2_pc_supported);
+
+u8 amd_iommu_v2_get_max_pc_counters(u16 devid)
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
+EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_counters);
+
+int amd_iommu_v2_get_set_pc_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    long long *value, bool is_write)
+{
+	struct amd_iommu *iommu;
+	u32 offset;
+	u32 max_offset_lim;
+
+	/* Make sure the IOMMUv2 PC resource is available */
+	if (!amd_iommu_v2_pc_present) {
+		pr_info("AMD IOMMUv2 - PC Not supported in amd_iommu_v2_get_set_pc_reg_val\n");
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
+	if ((offset < IOMMU_V2_PC_REG_OFFSET) ||
+	    (offset > max_offset_lim))
+		return -EINVAL;
+
+	if (is_write)
+		writel((u32)*value, iommu->mmio_base + offset);
+	else
+		*value = readl(iommu->mmio_base + offset);
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_iommu_v2_get_set_pc_reg_val);
+#endif
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e38ab43..fdf236b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -38,7 +38,12 @@
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
 /* Length of the MMIO region for the AMD IOMMU */
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+#define MMIO_REGION_LENGTH       0x80000
+#define IOMMU_V2_PC_REG_OFFSET	 0x40000
+#else
 #define MMIO_REGION_LENGTH       0x4000
+#endif
 
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
@@ -77,6 +82,7 @@
 #define MMIO_STATUS_OFFSET	0x2020
 #define MMIO_PPR_HEAD_OFFSET	0x2030
 #define MMIO_PPR_TAIL_OFFSET	0x2038
+#define MMIO_CNTR_CONF_OFFSET	0x4000
 
 
 /* Extended Feature Bits */
@@ -585,6 +591,12 @@ struct amd_iommu {
 
 	/* The l2 indirect registers */
 	u32 stored_l2[0x83];
+
+#ifdef CONFIG_AMD_IOMMU_V2_PC
+	/* The maximum PC banks and counters/bank (PCSup=1) */
+	u8 max_banks;
+	u8 max_counters;
+#endif
 };
 
 struct devid_map {
-- 
1.7.9.5


