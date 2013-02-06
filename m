Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3BFLGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:45 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:58701 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3BFKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/49] regulator: ab8500: Another push to synchronise recent AB8500 developments
Date: Wed,  6 Feb 2013 10:53:28 +0000
Message-Id: <1360148051-7560-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that many of the recent developments pertaining to
the AB8500 regulator device are propagated out into the public arena.
It aims to update some of the existing initialisation values in
accordance with internal ST-Ericsson code submissions. This single
patch was originally a collection of updates which have been squashed
together to aid with clarity.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   18 ------
 drivers/regulator/ab8500.c                    |   86 +++++++++++++++----------
 include/linux/regulator/ab8500.h              |   21 +++---
 3 files changed, 65 insertions(+), 60 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 96dd174..a8141e3 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -239,24 +239,6 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC,         0x03, 0x00),
 	/*
-	 * VBBN                     = force OFF
-	 * VBBP                     = force OFF
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_ARMREGU2,               0x0f, 0x00),
-	/*
-	 * VBBNSel1                 = VBBP = VBBPFB
-	 * VBBPSel1                 = 0 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL1,                0x0f, 0x00),
-	/*
-	 * VBBNSel2                 = VBBP = VBBPFB
-	 * VBBPSel2                 = 0 V
-	 * NOTE! PRCMU register
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x0f, 0x00),
-	/*
 	 * Vsmps1Regu               = HW control
 	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b1b9687..abc9e43 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -614,11 +614,19 @@ struct ab8500_reg_init {
 
 static struct ab8500_reg_init ab8500_reg_init[] = {
 	/*
-	 * 0x30, VanaRequestCtrl
+	 * 0x03, VarmRequestCtrl
+	 * 0x0c, VapeRequestCtrl
+	 * 0x30, Vsmps1RequestCtrl
+	 * 0xc0, Vsmps2RequestCtrl
+	 */
+	REG_INIT(AB8500_REGUREQUESTCTRL1,	0x03, 0x03, 0xff),
+	/*
+	 * 0x03, Vsmps3RequestCtrl
 	 * 0x0c, VpllRequestCtrl
+	 * 0x30, VanaRequestCtrl
 	 * 0xc0, VextSupply1RequestCtrl
 	 */
-	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xfc),
+	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xff),
 	/*
 	 * 0x03, VextSupply2RequestCtrl
 	 * 0x0c, VextSupply3RequestCtrl
@@ -643,50 +651,71 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
 	/*
+	 * 0x01, VapeSysClkReq1HPValid
+	 * 0x02, VarmSysClkReq1HPValid
+	 * 0x04, VbbSysClkReq1HPValid
+	 * 0x08, VmodSysClkReq1HPValid
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
 	 * 0x40, VextSupply3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x70),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x7f),
 	/*
+	 * 0x01, Vsmps1HwHPReq1Valid
+	 * 0x02, Vsmps2HwHPReq1Valid
+	 * 0x04, Vsmps3HwHPReq1Valid
 	 * 0x08, VanaHwHPReq1Valid
+	 * 0x10, VpllHwHPReq1Valid
 	 * 0x20, Vaux1HwHPReq1Valid
 	 * 0x40, Vaux2HwHPReq1Valid
 	 * 0x80, Vaux3HwHPReq1Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xe8),
+	REG_INIT(AB8500_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xff),
 	/*
 	 * 0x01, VextSupply1HwHPReq1Valid
 	 * 0x02, VextSupply2HwHPReq1Valid
 	 * 0x04, VextSupply3HwHPReq1Valid
+	 * 0x08, VmodHwHPReq1Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x07),
+	REG_INIT(AB8500_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x0f),
 	/*
+	 * 0x01, Vsmps1HwHPReq2Valid
+	 * 0x02, Vsmps2HwHPReq2Valid
+	 * 0x03, Vsmps3HwHPReq2Valid
 	 * 0x08, VanaHwHPReq2Valid
+	 * 0x10, VpllHwHPReq2Valid
 	 * 0x20, Vaux1HwHPReq2Valid
 	 * 0x40, Vaux2HwHPReq2Valid
 	 * 0x80, Vaux3HwHPReq2Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xe8),
+	REG_INIT(AB8500_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xff),
 	/*
 	 * 0x01, VextSupply1HwHPReq2Valid
 	 * 0x02, VextSupply2HwHPReq2Valid
 	 * 0x04, VextSupply3HwHPReq2Valid
+	 * 0x08, VmodHwHPReq2Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x07),
+	REG_INIT(AB8500_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x0f),
 	/*
+	 * 0x01, VapeSwHPReqValid
+	 * 0x02, VarmSwHPReqValid
+	 * 0x04, Vsmps1SwHPReqValid
+	 * 0x08, Vsmps2SwHPReqValid
+	 * 0x10, Vsmps3SwHPReqValid
 	 * 0x20, VanaSwHPReqValid
+	 * 0x40, VpllSwHPReqValid
 	 * 0x80, Vaux1SwHPReqValid
 	 */
-	REG_INIT(AB8500_REGUSWHPREQVALID1,	0x03, 0x0d, 0xa0),
+	REG_INIT(AB8500_REGUSWHPREQVALID1,	0x03, 0x0d, 0xff),
 	/*
 	 * 0x01, Vaux2SwHPReqValid
 	 * 0x02, Vaux3SwHPReqValid
 	 * 0x04, VextSupply1SwHPReqValid
 	 * 0x08, VextSupply2SwHPReqValid
 	 * 0x10, VextSupply3SwHPReqValid
+	 * 0x20, VmodSwHPReqValid
 	 */
-	REG_INIT(AB8500_REGUSWHPREQVALID2,	0x03, 0x0e, 0x1f),
+	REG_INIT(AB8500_REGUSWHPREQVALID2,	0x03, 0x0e, 0x3f),
 	/*
 	 * 0x02, SysClkReq2Valid1
 	 * ...
@@ -720,36 +749,22 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
 	/*
-	 * 0x0c, VBBNRegu
-	 * 0x03, VBBPRegu
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_ARMREGU2,		0x04, 0x01, 0x0f),
-	/*
-	 * 0x0c, VBBPSel1
-	 * 0x03, VBBNSel1
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VBBSEL1,		0x04, 0x11, 0x0f),
-	/*
-	 * 0x0c, VBBNSel2
-	 * 0x03, VBBPSel2
-	 * NOTE! PRCMU register
-	 */
-	REG_INIT(AB8500_VBBSEL2,		0x04, 0x12, 0x0f),
-	/*
 	 * 0x03, Vsmps1Regu
 	 * 0x0c, Vsmps1SelCtrl
+	 * 0x10, Vsmps1AutoMode
+	 * 0x20, Vsmps1PWMMode
 	 */
-	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x0f),
+	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x3f),
 	/*
 	 * 0x03, Vsmps2Regu
 	 * 0x0c, Vsmps2SelCtrl
+	 * 0x10, Vsmps2AutoMode
+	 * 0x20, Vsmps2PWMMode
 	 */
-	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x0f),
+	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x3f),
 	/*
-	 * 0x0c, VanaRegu
 	 * 0x03, VpllRegu
+	 * 0x0c, VanaRegu
 	 */
 	REG_INIT(AB8500_VPLLVANAREGU,		0x04, 0x06, 0x0f),
 	/*
@@ -789,13 +804,16 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_VAUX2SEL,		0x04, 0x20, 0x0f),
 	/*
 	 * 0x07, Vaux3Sel
+	 * 0x30, Vrf1Sel
 	 */
-	REG_INIT(AB8500_VRF1VAUX3SEL,		0x04, 0x21, 0x07),
+	REG_INIT(AB8500_VRF1VAUX3SEL,		0x04, 0x21, 0x37),
 	/*
 	 * 0x01, VextSupply12LP
 	 */
 	REG_INIT(AB8500_REGUCTRL2SPARE,		0x04, 0x22, 0x01),
 	/*
+	 * 0x01, VpllDisch
+	 * 0x02, Vrf1Disch
 	 * 0x04, Vaux1Disch
 	 * 0x08, Vaux2Disch
 	 * 0x10, Vaux3Disch
@@ -803,13 +821,15 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 * 0x40, VTVoutDisch
 	 * 0x80, VaudioDisch
 	 */
-	REG_INIT(AB8500_REGUCTRLDISCH,		0x04, 0x43, 0xfc),
+	REG_INIT(AB8500_REGUCTRLDISCH,		0x04, 0x43, 0xff),
 	/*
+	 * 0x01, VsimDisch
 	 * 0x02, VanaDisch
 	 * 0x04, VdmicPullDownEna
+	 * 0x08, VpllPullDownEna
 	 * 0x10, VdmicDisch
 	 */
-	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
+	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x1f),
 };
 
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index a1d245f..dd7944f 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -61,6 +61,7 @@ struct ab8500_regulator_reg_init {
 
 /* AB8500 registers */
 enum ab8500_regulator_reg {
+	AB8500_REGUREQUESTCTRL1,
 	AB8500_REGUREQUESTCTRL2,
 	AB8500_REGUREQUESTCTRL3,
 	AB8500_REGUREQUESTCTRL4,
@@ -77,26 +78,28 @@ enum ab8500_regulator_reg {
 	AB8500_REGUMISC1,
 	AB8500_VAUDIOSUPPLY,
 	AB8500_REGUCTRL1VAMIC,
+	AB8500_VSMPS1REGU,
+	AB8500_VSMPS2REGU,
+	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
 	AB8500_VPLLVANAREGU,
 	AB8500_VREFDDR,
 	AB8500_EXTSUPPLYREGU,
 	AB8500_VAUX12REGU,
 	AB8500_VRF1VAUX3REGU,
+	AB8500_VSMPS1SEL1,
+	AB8500_VSMPS1SEL2,
+	AB8500_VSMPS1SEL3,
+	AB8500_VSMPS2SEL1,
+	AB8500_VSMPS2SEL2,
+	AB8500_VSMPS2SEL3,
+	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
+	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_VAUX1SEL,
 	AB8500_VAUX2SEL,
 	AB8500_VRF1VAUX3SEL,
 	AB8500_REGUCTRL2SPARE,
 	AB8500_REGUCTRLDISCH,
 	AB8500_REGUCTRLDISCH2,
-	AB8500_ARMREGU2, /* NOTE! PRCMU register */
-	AB8500_VBBSEL1, /* NOTE! PRCMU register */
-	AB8500_VBBSEL2, /* NOTE! PRCMU register */
-	AB8500_VSMPS1REGU,
-	AB8500_VSMPS2REGU,
-	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
-	AB8500_VSMPS1SEL1,
-	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
-	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
 
-- 
1.7.9.5

