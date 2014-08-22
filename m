Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaHVNzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:55:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbaHVNyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:10 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/6] ARM: OMAP4+: prminst: provide function to find prm_dev instance offset
Date: Fri, 22 Aug 2014 08:51:48 -0500
Message-ID: <1408715513-25851-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
References: <1408715513-25851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRM device instance can vary depending on SoC. We already handle the
same during reset of the device, However, this is also needed
for other logic instances. So, first abstract this out to a generic
function.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Minor note: this patch has a 'CHECK: extern prototypes should be avoided in .h files'
for prminst44xx.h but that is a continuation of existing style in the file.

 arch/arm/mach-omap2/prminst44xx.c |   40 +++++++++++++++++++++++--------------
 arch/arm/mach-omap2/prminst44xx.h |    3 +++
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/prminst44xx.c b/arch/arm/mach-omap2/prminst44xx.c
index 69f0dd0..225e025 100644
--- a/arch/arm/mach-omap2/prminst44xx.c
+++ b/arch/arm/mach-omap2/prminst44xx.c
@@ -31,6 +31,8 @@
 
 static void __iomem *_prm_bases[OMAP4_MAX_PRCM_PARTITIONS];
 
+static s32 prm_dev_inst = PRM_INSTANCE_UNKNOWN;
+
 /**
  * omap_prm_base_init - Populates the prm partitions
  *
@@ -43,6 +45,24 @@ void omap_prm_base_init(void)
 	_prm_bases[OMAP4430_PRCM_MPU_PARTITION] = prcm_mpu_base;
 }
 
+s32 omap4_prmst_get_prm_dev_inst(void)
+{
+	if (prm_dev_inst != PRM_INSTANCE_UNKNOWN)
+		return prm_dev_inst;
+
+	/* This cannot be done way early at boot.. as things are not setup */
+	if (cpu_is_omap44xx())
+		prm_dev_inst = OMAP4430_PRM_DEVICE_INST;
+	else if (soc_is_omap54xx())
+		prm_dev_inst = OMAP54XX_PRM_DEVICE_INST;
+	else if (soc_is_dra7xx())
+		prm_dev_inst = DRA7XX_PRM_DEVICE_INST;
+	else if (soc_is_am43xx())
+		prm_dev_inst = AM43XX_PRM_DEVICE_INST;
+
+	return prm_dev_inst;
+}
+
 /* Read a register in a PRM instance */
 u32 omap4_prminst_read_inst_reg(u8 part, s16 inst, u16 idx)
 {
@@ -169,28 +189,18 @@ int omap4_prminst_deassert_hardreset(u8 shift, u8 part, s16 inst,
 void omap4_prminst_global_warm_sw_reset(void)
 {
 	u32 v;
-	s16 dev_inst;
+	s32 inst = omap4_prmst_get_prm_dev_inst();
 
-	if (cpu_is_omap44xx())
-		dev_inst = OMAP4430_PRM_DEVICE_INST;
-	else if (soc_is_omap54xx())
-		dev_inst = OMAP54XX_PRM_DEVICE_INST;
-	else if (soc_is_dra7xx())
-		dev_inst = DRA7XX_PRM_DEVICE_INST;
-	else if (soc_is_am43xx())
-		dev_inst = AM43XX_PRM_DEVICE_INST;
-	else
+	if (inst == PRM_INSTANCE_UNKNOWN)
 		return;
 
-	v = omap4_prminst_read_inst_reg(OMAP4430_PRM_PARTITION, dev_inst,
+	v = omap4_prminst_read_inst_reg(OMAP4430_PRM_PARTITION, inst,
 					OMAP4_PRM_RSTCTRL_OFFSET);
 	v |= OMAP4430_RST_GLOBAL_WARM_SW_MASK;
 	omap4_prminst_write_inst_reg(v, OMAP4430_PRM_PARTITION,
-				 dev_inst,
-				 OMAP4_PRM_RSTCTRL_OFFSET);
+				 inst, OMAP4_PRM_RSTCTRL_OFFSET);
 
 	/* OCP barrier */
 	v = omap4_prminst_read_inst_reg(OMAP4430_PRM_PARTITION,
-				    dev_inst,
-				    OMAP4_PRM_RSTCTRL_OFFSET);
+				    inst, OMAP4_PRM_RSTCTRL_OFFSET);
 }
diff --git a/arch/arm/mach-omap2/prminst44xx.h b/arch/arm/mach-omap2/prminst44xx.h
index a2ede2d..583aa37 100644
--- a/arch/arm/mach-omap2/prminst44xx.h
+++ b/arch/arm/mach-omap2/prminst44xx.h
@@ -12,6 +12,9 @@
 #ifndef __ARCH_ASM_MACH_OMAP2_PRMINST44XX_H
 #define __ARCH_ASM_MACH_OMAP2_PRMINST44XX_H
 
+#define PRM_INSTANCE_UNKNOWN	-1
+extern s32 omap4_prmst_get_prm_dev_inst(void);
+
 /*
  * In an ideal world, we would not export these low-level functions,
  * but this will probably take some time to fix properly
-- 
1.7.9.5

