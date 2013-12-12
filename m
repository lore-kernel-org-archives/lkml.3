Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3LLH6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:39 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15491 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LLH6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:01:13 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 08/12] iommu/tegra: smmu: calculate ASID register offset by ID
Date: Thu, 12 Dec 2013 09:57:09 +0200
Message-ID: <1386835033-4701-9-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASID register offset is caclulated by SWGROUP ID so that we can get
rid of old SoC specific MACROs. This ID conversion is needed for the
unified SMMU driver over Tegra SoCs. We use dt-bindings MACRO instead
of SoC dependent MACROs. The formula is:

  MC_SMMU_<swgroup name>_ASID_0 = MC_SMMU_AFI_ASID_0 + ID * 4;

Now SWGROUP ID is the global HardWare Accelerator(HWA) identifier
among all Tegra SoC except Tegra2.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v5:
Added SMMU_ASID_BASE(== SMMU_AFI_ASID).
Removed unused ASID offset definitions.
Use 'unsigned long *' instead of u64 for swgroups bitmap.

v4:
Combined the following patches from v3:
[PATCHv3 09/19] iommu/tegra: smmu: Calculate ASID register offset by ID
[PATCHv3 16/19] iommu/tegra: smmu: Use dt-bindings MACRO

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 111 +++++++--------------------------------------
 1 file changed, 17 insertions(+), 94 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 99b4bd4..6ab977a 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -43,46 +43,6 @@
 
 #include <dt-bindings/memory/tegra-swgroup.h>
 
-enum smmu_hwgrp {
-	HWGRP_AFI,
-	HWGRP_AVPC,
-	HWGRP_DC,
-	HWGRP_DCB,
-	HWGRP_EPP,
-	HWGRP_G2,
-	HWGRP_HC,
-	HWGRP_HDA,
-	HWGRP_ISP,
-	HWGRP_MPE,
-	HWGRP_NV,
-	HWGRP_NV2,
-	HWGRP_PPCS,
-	HWGRP_SATA,
-	HWGRP_VDE,
-	HWGRP_VI,
-
-	HWGRP_COUNT,
-
-	HWGRP_END = ~0,
-};
-
-#define HWG_AFI		(1 << HWGRP_AFI)
-#define HWG_AVPC	(1 << HWGRP_AVPC)
-#define HWG_DC		(1 << HWGRP_DC)
-#define HWG_DCB		(1 << HWGRP_DCB)
-#define HWG_EPP		(1 << HWGRP_EPP)
-#define HWG_G2		(1 << HWGRP_G2)
-#define HWG_HC		(1 << HWGRP_HC)
-#define HWG_HDA		(1 << HWGRP_HDA)
-#define HWG_ISP		(1 << HWGRP_ISP)
-#define HWG_MPE		(1 << HWGRP_MPE)
-#define HWG_NV		(1 << HWGRP_NV)
-#define HWG_NV2		(1 << HWGRP_NV2)
-#define HWG_PPCS	(1 << HWGRP_PPCS)
-#define HWG_SATA	(1 << HWGRP_SATA)
-#define HWG_VDE		(1 << HWGRP_VDE)
-#define HWG_VI		(1 << HWGRP_VI)
-
 /* bitmap of the page sizes currently supported */
 #define SMMU_IOMMU_PGSIZES	(SZ_4K)
 
@@ -152,21 +112,7 @@ enum {
 #define SMMU_TRANSLATION_ENABLE_2		0x230
 
 #define SMMU_AFI_ASID	0x238   /* PCIE */
-#define SMMU_AVPC_ASID	0x23c   /* AVP */
-#define SMMU_DC_ASID	0x240   /* Display controller */
-#define SMMU_DCB_ASID	0x244   /* Display controller B */
-#define SMMU_EPP_ASID	0x248   /* Encoder pre-processor */
-#define SMMU_G2_ASID	0x24c   /* 2D engine */
-#define SMMU_HC_ASID	0x250   /* Host1x */
-#define SMMU_HDA_ASID	0x254   /* High-def audio */
-#define SMMU_ISP_ASID	0x258   /* Image signal processor */
-#define SMMU_MPE_ASID	0x264   /* MPEG encoder */
-#define SMMU_NV_ASID	0x268   /* (3D) */
-#define SMMU_NV2_ASID	0x26c   /* (3D) */
-#define SMMU_PPCS_ASID	0x270   /* AHB */
-#define SMMU_SATA_ASID	0x278   /* SATA */
-#define SMMU_VDE_ASID	0x27c   /* Video decoder */
-#define SMMU_VI_ASID	0x280   /* Video input */
+#define SMMU_ASID_BASE	SMMU_AFI_ASID
 
 #define SMMU_PDE_NEXT_SHIFT		28
 
@@ -238,27 +184,7 @@ enum {
 #define __smmu_client_enable_hwgrp(c, m) __smmu_client_set_hwgrp(c, m, 1)
 #define __smmu_client_disable_hwgrp(c)	__smmu_client_set_hwgrp(c, 0, 0)
 
-#define HWGRP_INIT(client) [HWGRP_##client] = SMMU_##client##_ASID
-
-static const u32 smmu_hwgrp_asid_reg[] = {
-	HWGRP_INIT(AFI),
-	HWGRP_INIT(AVPC),
-	HWGRP_INIT(DC),
-	HWGRP_INIT(DCB),
-	HWGRP_INIT(EPP),
-	HWGRP_INIT(G2),
-	HWGRP_INIT(HC),
-	HWGRP_INIT(HDA),
-	HWGRP_INIT(ISP),
-	HWGRP_INIT(MPE),
-	HWGRP_INIT(NV),
-	HWGRP_INIT(NV2),
-	HWGRP_INIT(PPCS),
-	HWGRP_INIT(SATA),
-	HWGRP_INIT(VDE),
-	HWGRP_INIT(VI),
-};
-#define HWGRP_ASID_REG(x) (smmu_hwgrp_asid_reg[x])
+#define HWGRP_ASID_REG(x) ((x) * sizeof(u32) + SMMU_ASID_BASE)
 
 /*
  * Per client for address space
@@ -267,7 +193,7 @@ struct smmu_client {
 	struct device		*dev;
 	struct list_head	list;
 	struct smmu_as		*as;
-	u32			hwgrp;
+	unsigned long		hwgrp[2];
 };
 
 /*
@@ -384,41 +310,37 @@ static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
  */
 #define FLUSH_SMMU_REGS(smmu)	smmu_read(smmu, SMMU_CONFIG)
 
-#define smmu_client_hwgrp(c) (u32)((c)->dev->platform_data)
-
 static int __smmu_client_set_hwgrp(struct smmu_client *c,
-				   unsigned long map, int on)
+				   unsigned long *map, int on)
 {
 	int i;
 	struct smmu_as *as = c->as;
 	u32 val, offs, mask = SMMU_ASID_ENABLE(as->asid);
 	struct smmu_device *smmu = as->smmu;
 
-	WARN_ON(!on && map);
-	if (on && !map)
-		return -EINVAL;
 	if (!on)
-		map = smmu_client_hwgrp(c);
+		map = c->hwgrp;
 
-	for_each_set_bit(i, &map, HWGRP_COUNT) {
+	for_each_set_bit(i, map, TEGRA_SWGROUP_MAX) {
 		offs = HWGRP_ASID_REG(i);
 		val = smmu_read(smmu, offs);
 		if (on) {
 			if (WARN_ON(val & mask))
 				goto err_hw_busy;
 			val |= mask;
+			memcpy(c->hwgrp, map, sizeof(u64));
 		} else {
 			WARN_ON((val & mask) == mask);
 			val &= ~mask;
 		}
 		smmu_write(smmu, val, offs);
 	}
+
 	FLUSH_SMMU_REGS(smmu);
-	c->hwgrp = map;
 	return 0;
 
 err_hw_busy:
-	for_each_set_bit(i, &map, HWGRP_COUNT) {
+	for_each_set_bit(i, map, TEGRA_SWGROUP_MAX) {
 		offs = HWGRP_ASID_REG(i);
 		val = smmu_read(smmu, offs);
 		val &= ~mask;
@@ -427,17 +349,18 @@ err_hw_busy:
 	return -EBUSY;
 }
 
-static int smmu_client_set_hwgrp(struct smmu_client *c, u32 map, int on)
+static int smmu_client_set_hwgrp(struct smmu_client *c,
+				 unsigned long *map, int on)
 {
-	u32 val;
+	int err;
 	unsigned long flags;
 	struct smmu_as *as = c->as;
 	struct smmu_device *smmu = as->smmu;
 
 	spin_lock_irqsave(&smmu->lock, flags);
-	val = __smmu_client_set_hwgrp(c, map, on);
+	err = __smmu_client_set_hwgrp(c, map, on);
 	spin_unlock_irqrestore(&smmu->lock, flags);
-	return val;
+	return err;
 }
 
 /*
@@ -796,7 +719,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	struct smmu_as *as = domain->priv;
 	struct smmu_device *smmu = as->smmu;
 	struct smmu_client *client, *c;
-	u32 map;
+	unsigned long *map;
 	int err;
 
 	client = devm_kzalloc(smmu->dev, sizeof(*c), GFP_KERNEL);
@@ -804,7 +727,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 		return -ENOMEM;
 	client->dev = dev;
 	client->as = as;
-	map = (unsigned long)dev->platform_data;
+	map = (unsigned long *)dev->platform_data;
 	if (!map)
 		return -EINVAL;
 
@@ -828,7 +751,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	 * Reserve "page zero" for AVP vectors using a common dummy
 	 * page.
 	 */
-	if (map & HWG_AVPC) {
+	if (test_bit(TEGRA_SWGROUP_AVPC, map)) {
 		struct page *page;
 
 		page = as->smmu->avp_vector_page;
-- 
1.8.1.5

