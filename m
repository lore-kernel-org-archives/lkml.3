Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaHVNyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:54:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58274 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbaHVNyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:08 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/6] ARM: OMAP4: PRM: use the generic prm_inst to allow logic to be abstracted
Date: Fri, 22 Aug 2014 08:51:49 -0500
Message-ID: <1408715513-25851-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
References: <1408715513-25851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use the generic function to pick up the prm_instance for a generic logic
which can be reused from OMAP4+

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/prm44xx.c |   47 +++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index a7f6ea2..d4d745e 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -154,21 +154,36 @@ void omap4_prm_vp_clear_txdone(u8 vp_id)
 
 u32 omap4_prm_vcvp_read(u8 offset)
 {
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return 0;
+
 	return omap4_prminst_read_inst_reg(OMAP4430_PRM_PARTITION,
-					   OMAP4430_PRM_DEVICE_INST, offset);
+					   inst, offset);
 }
 
 void omap4_prm_vcvp_write(u32 val, u8 offset)
 {
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return;
+
 	omap4_prminst_write_inst_reg(val, OMAP4430_PRM_PARTITION,
-				     OMAP4430_PRM_DEVICE_INST, offset);
+				     inst, offset);
 }
 
 u32 omap4_prm_vcvp_rmw(u32 mask, u32 bits, u8 offset)
 {
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return 0;
+
 	return omap4_prminst_rmw_inst_reg_bits(mask, bits,
 					       OMAP4430_PRM_PARTITION,
-					       OMAP4430_PRM_DEVICE_INST,
+					       inst,
 					       offset);
 }
 
@@ -275,14 +290,18 @@ void omap44xx_prm_restore_irqen(u32 *saved_mask)
 void omap44xx_prm_reconfigure_io_chain(void)
 {
 	int i = 0;
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return;
 
 	/* Trigger WUCLKIN enable */
 	omap4_prm_rmw_inst_reg_bits(OMAP4430_WUCLK_CTRL_MASK,
 				    OMAP4430_WUCLK_CTRL_MASK,
-				    OMAP4430_PRM_DEVICE_INST,
+				    inst,
 				    OMAP4_PRM_IO_PMCTRL_OFFSET);
 	omap_test_timeout(
-		(((omap4_prm_read_inst_reg(OMAP4430_PRM_DEVICE_INST,
+		(((omap4_prm_read_inst_reg(inst,
 					   OMAP4_PRM_IO_PMCTRL_OFFSET) &
 		   OMAP4430_WUCLK_STATUS_MASK) >>
 		  OMAP4430_WUCLK_STATUS_SHIFT) == 1),
@@ -292,10 +311,10 @@ void omap44xx_prm_reconfigure_io_chain(void)
 
 	/* Trigger WUCLKIN disable */
 	omap4_prm_rmw_inst_reg_bits(OMAP4430_WUCLK_CTRL_MASK, 0x0,
-				    OMAP4430_PRM_DEVICE_INST,
+				    inst,
 				    OMAP4_PRM_IO_PMCTRL_OFFSET);
 	omap_test_timeout(
-		(((omap4_prm_read_inst_reg(OMAP4430_PRM_DEVICE_INST,
+		(((omap4_prm_read_inst_reg(inst,
 					   OMAP4_PRM_IO_PMCTRL_OFFSET) &
 		   OMAP4430_WUCLK_STATUS_MASK) >>
 		  OMAP4430_WUCLK_STATUS_SHIFT) == 0),
@@ -316,9 +335,14 @@ void omap44xx_prm_reconfigure_io_chain(void)
  */
 static void __init omap44xx_prm_enable_io_wakeup(void)
 {
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return;
+
 	omap4_prm_rmw_inst_reg_bits(OMAP4430_GLOBAL_WUEN_MASK,
 				    OMAP4430_GLOBAL_WUEN_MASK,
-				    OMAP4430_PRM_DEVICE_INST,
+				    inst,
 				    OMAP4_PRM_IO_PMCTRL_OFFSET);
 }
 
@@ -333,8 +357,13 @@ static u32 omap44xx_prm_read_reset_sources(void)
 	struct prm_reset_src_map *p;
 	u32 r = 0;
 	u32 v;
+	s32 inst = omap4_prmst_get_prm_dev_inst();
+
+	if (inst == PRM_INSTANCE_UNKNOWN)
+		return 0;
+
 
-	v = omap4_prm_read_inst_reg(OMAP4430_PRM_DEVICE_INST,
+	v = omap4_prm_read_inst_reg(inst,
 				    OMAP4_RM_RSTST);
 
 	p = omap44xx_prm_reset_src_map;
-- 
1.7.9.5

