Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3BFKzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42454 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3BFKzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/49] regulator: ab8500: Clean out SoC registers
Date: Wed,  6 Feb 2013 10:53:43 +0000
Message-Id: <1360148051-7560-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean out initialisation that is handled by SoC. Regulator
settings for Vpll (partly), Vsmps1, Vsmps2, Vsmps3 (partly),
Vrf1, Varm, Vape, Vbb, Vmod are cleaned out. They should not
be touched by the kernel.

We also update many of the initialisation values to be more
in-line with the current development efforts of ST-Ericsson
internal engineers.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   28 +------
 drivers/regulator/ab8500.c                    |   98 ++++++-------------------
 include/linux/regulator/ab8500.h              |   12 ---
 3 files changed, 28 insertions(+), 110 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 7c36734..4bd982f 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -142,10 +142,9 @@ static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	/*
 	 * VanaRequestCtrl          = HP/LP depending on VxRequest
-	 * VpllRequestCtrl          = HP/LP depending on VxRequest
 	 * VextSupply1RequestCtrl   = HP/LP depending on VxRequest
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2,       0xfc, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2,       0xf0, 0x00),
 	/*
 	 * VextSupply2RequestCtrl   = HP/LP depending on VxRequest
 	 * VextSupply3RequestCtrl   = HP/LP depending on VxRequest
@@ -159,16 +158,12 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4,       0x07, 0x00),
 	/*
-	 * Vsmps1SysClkReq1HPValid  = enabled
-	 * Vsmps2SysClkReq1HPValid  = enabled
-	 * Vsmps3SysClkReq1HPValid  = enabled
 	 * VanaSysClkReq1HPValid    = disabled
-	 * VpllSysClkReq1HPValid    = enabled
 	 * Vaux1SysClkReq1HPValid   = disabled
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0xff, 0x17),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0xe8, 0x00),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
@@ -255,17 +250,7 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC,         0x03, 0x00),
 	/*
-	 * Vsmps1Regu               = HW control
-	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x0f, 0x06),
-	/*
-	 * Vsmps2Regu               = HW control
-	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x0f, 0x06),
-	/*
-	 * VPll                     = Hw controlled
+	 * VPll                     = Hw controlled (NOTE! PRCMU bits)
 	 * VanaRegu                 = force off
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VPLLVANAREGU,           0x0f, 0x02),
@@ -288,14 +273,9 @@ static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU,             0x0f, 0x01),
 	/*
-	 * Vrf1Regu                 = HW control
 	 * Vaux3Regu                = force off
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU,          0x0f, 0x08),
-	/*
-	 * Vsmps1                   = 1.15V
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS1SEL1,             0x3f, 0x24),
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU,          0x03, 0x00),
 	/*
 	 * Vaux1Sel                 = 2.5 V
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 2b29ffa..2855b51 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -595,19 +595,10 @@ struct ab8500_reg_init {
 
 static struct ab8500_reg_init ab8500_reg_init[] = {
 	/*
-	 * 0x03, VarmRequestCtrl
-	 * 0x0c, VapeRequestCtrl
-	 * 0x30, Vsmps1RequestCtrl
-	 * 0xc0, Vsmps2RequestCtrl
-	 */
-	REG_INIT(AB8500_REGUREQUESTCTRL1,	0x03, 0x03, 0xff),
-	/*
-	 * 0x03, Vsmps3RequestCtrl
-	 * 0x0c, VpllRequestCtrl
 	 * 0x30, VanaRequestCtrl
 	 * 0xc0, VextSupply1RequestCtrl
 	 */
-	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xff),
+	REG_INIT(AB8500_REGUREQUESTCTRL2,	0x03, 0x04, 0xf0),
 	/*
 	 * 0x03, VextSupply2RequestCtrl
 	 * 0x0c, VextSupply3RequestCtrl
@@ -621,91 +612,74 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
 	/*
-	 * 0x01, Vsmps1SysClkReq1HPValid
-	 * 0x02, Vsmps2SysClkReq1HPValid
-	 * 0x04, Vsmps3SysClkReq1HPValid
 	 * 0x08, VanaSysClkReq1HPValid
-	 * 0x10, VpllSysClkReq1HPValid
 	 * 0x20, Vaux1SysClkReq1HPValid
 	 * 0x40, Vaux2SysClkReq1HPValid
 	 * 0x80, Vaux3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xe8),
 	/*
-	 * 0x01, VapeSysClkReq1HPValid
-	 * 0x02, VarmSysClkReq1HPValid
-	 * 0x04, VbbSysClkReq1HPValid
-	 * 0x08, VmodSysClkReq1HPValid
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
 	 * 0x40, VextSupply3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x7f),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x70),
 	/*
-	 * 0x01, Vsmps1HwHPReq1Valid
-	 * 0x02, Vsmps2HwHPReq1Valid
-	 * 0x04, Vsmps3HwHPReq1Valid
 	 * 0x08, VanaHwHPReq1Valid
-	 * 0x10, VpllHwHPReq1Valid
 	 * 0x20, Vaux1HwHPReq1Valid
 	 * 0x40, Vaux2HwHPReq1Valid
 	 * 0x80, Vaux3HwHPReq1Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xff),
+	REG_INIT(AB8500_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xe8),
 	/*
 	 * 0x01, VextSupply1HwHPReq1Valid
 	 * 0x02, VextSupply2HwHPReq1Valid
 	 * 0x04, VextSupply3HwHPReq1Valid
-	 * 0x08, VmodHwHPReq1Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x0f),
+	REG_INIT(AB8500_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x07),
 	/*
-	 * 0x01, Vsmps1HwHPReq2Valid
-	 * 0x02, Vsmps2HwHPReq2Valid
-	 * 0x03, Vsmps3HwHPReq2Valid
 	 * 0x08, VanaHwHPReq2Valid
-	 * 0x10, VpllHwHPReq2Valid
 	 * 0x20, Vaux1HwHPReq2Valid
 	 * 0x40, Vaux2HwHPReq2Valid
 	 * 0x80, Vaux3HwHPReq2Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xff),
+	REG_INIT(AB8500_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xe8),
 	/*
 	 * 0x01, VextSupply1HwHPReq2Valid
 	 * 0x02, VextSupply2HwHPReq2Valid
 	 * 0x04, VextSupply3HwHPReq2Valid
-	 * 0x08, VmodHwHPReq2Valid
 	 */
-	REG_INIT(AB8500_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x0f),
+	REG_INIT(AB8500_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x07),
 	/*
-	 * 0x01, VapeSwHPReqValid
-	 * 0x02, VarmSwHPReqValid
-	 * 0x04, Vsmps1SwHPReqValid
-	 * 0x08, Vsmps2SwHPReqValid
-	 * 0x10, Vsmps3SwHPReqValid
 	 * 0x20, VanaSwHPReqValid
-	 * 0x40, VpllSwHPReqValid
 	 * 0x80, Vaux1SwHPReqValid
 	 */
-	REG_INIT(AB8500_REGUSWHPREQVALID1,	0x03, 0x0d, 0xff),
+	REG_INIT(AB8500_REGUSWHPREQVALID1,	0x03, 0x0d, 0xa0),
 	/*
 	 * 0x01, Vaux2SwHPReqValid
 	 * 0x02, Vaux3SwHPReqValid
 	 * 0x04, VextSupply1SwHPReqValid
 	 * 0x08, VextSupply2SwHPReqValid
 	 * 0x10, VextSupply3SwHPReqValid
-	 * 0x20, VmodSwHPReqValid
 	 */
-	REG_INIT(AB8500_REGUSWHPREQVALID2,	0x03, 0x0e, 0x3f),
+	REG_INIT(AB8500_REGUSWHPREQVALID2,	0x03, 0x0e, 0x1f),
 	/*
 	 * 0x02, SysClkReq2Valid1
-	 * ...
+	 * 0x04, SysClkReq3Valid1
+	 * 0x08, SysClkReq4Valid1
+	 * 0x10, SysClkReq5Valid1
+	 * 0x20, SysClkReq6Valid1
+	 * 0x40, SysClkReq7Valid1
 	 * 0x80, SysClkReq8Valid1
 	 */
 	REG_INIT(AB8500_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xfe),
 	/*
 	 * 0x02, SysClkReq2Valid2
-	 * ...
+	 * 0x04, SysClkReq3Valid2
+	 * 0x08, SysClkReq4Valid2
+	 * 0x10, SysClkReq5Valid2
+	 * 0x20, SysClkReq6Valid2
+	 * 0x40, SysClkReq7Valid2
 	 * 0x80, SysClkReq8Valid2
 	 */
 	REG_INIT(AB8500_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xfe),
@@ -730,21 +704,7 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
 	/*
-	 * 0x03, Vsmps1Regu
-	 * 0x0c, Vsmps1SelCtrl
-	 * 0x10, Vsmps1AutoMode
-	 * 0x20, Vsmps1PWMMode
-	 */
-	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x3f),
-	/*
-	 * 0x03, Vsmps2Regu
-	 * 0x0c, Vsmps2SelCtrl
-	 * 0x10, Vsmps2AutoMode
-	 * 0x20, Vsmps2PWMMode
-	 */
-	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x3f),
-	/*
-	 * 0x03, VpllRegu
+	 * 0x03, VpllRegu (NOTE! PRCMU register bits)
 	 * 0x0c, VanaRegu
 	 */
 	REG_INIT(AB8500_VPLLVANAREGU,		0x04, 0x06, 0x0f),
@@ -767,14 +727,9 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VAUX12REGU,		0x04, 0x09, 0x0f),
 	/*
-	 * 0x0c, Vrf1Regu
 	 * 0x03, Vaux3Regu
 	 */
-	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
-	/*
-	 * 0x3f, Vsmps1Sel1
-	 */
-	REG_INIT(AB8500_VSMPS1SEL1,		0x04, 0x13, 0x3f),
+	REG_INIT(AB8500_VRF1VAUX3REGU,		0x04, 0x0a, 0x03),
 	/*
 	 * 0x0f, Vaux1Sel
 	 */
@@ -785,16 +740,13 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_VAUX2SEL,		0x04, 0x20, 0x0f),
 	/*
 	 * 0x07, Vaux3Sel
-	 * 0x30, Vrf1Sel
 	 */
-	REG_INIT(AB8500_VRF1VAUX3SEL,		0x04, 0x21, 0x37),
+	REG_INIT(AB8500_VRF1VAUX3SEL,		0x04, 0x21, 0x07),
 	/*
 	 * 0x01, VextSupply12LP
 	 */
 	REG_INIT(AB8500_REGUCTRL2SPARE,		0x04, 0x22, 0x01),
 	/*
-	 * 0x01, VpllDisch
-	 * 0x02, Vrf1Disch
 	 * 0x04, Vaux1Disch
 	 * 0x08, Vaux2Disch
 	 * 0x10, Vaux3Disch
@@ -802,15 +754,13 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 * 0x40, VTVoutDisch
 	 * 0x80, VaudioDisch
 	 */
-	REG_INIT(AB8500_REGUCTRLDISCH,		0x04, 0x43, 0xff),
+	REG_INIT(AB8500_REGUCTRLDISCH,		0x04, 0x43, 0xfc),
 	/*
-	 * 0x01, VsimDisch
 	 * 0x02, VanaDisch
 	 * 0x04, VdmicPullDownEna
-	 * 0x08, VpllPullDownEna
 	 * 0x10, VdmicDisch
 	 */
-	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x1f),
+	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
 };
 
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 094d24c..592a3f3 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -62,7 +62,6 @@ struct ab8500_regulator_reg_init {
 
 /* AB8500 registers */
 enum ab8500_regulator_reg {
-	AB8500_REGUREQUESTCTRL1,
 	AB8500_REGUREQUESTCTRL2,
 	AB8500_REGUREQUESTCTRL3,
 	AB8500_REGUREQUESTCTRL4,
@@ -79,22 +78,11 @@ enum ab8500_regulator_reg {
 	AB8500_REGUMISC1,
 	AB8500_VAUDIOSUPPLY,
 	AB8500_REGUCTRL1VAMIC,
-	AB8500_VSMPS1REGU,
-	AB8500_VSMPS2REGU,
-	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
 	AB8500_VPLLVANAREGU,
 	AB8500_VREFDDR,
 	AB8500_EXTSUPPLYREGU,
 	AB8500_VAUX12REGU,
 	AB8500_VRF1VAUX3REGU,
-	AB8500_VSMPS1SEL1,
-	AB8500_VSMPS1SEL2,
-	AB8500_VSMPS1SEL3,
-	AB8500_VSMPS2SEL1,
-	AB8500_VSMPS2SEL2,
-	AB8500_VSMPS2SEL3,
-	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
-	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_VAUX1SEL,
 	AB8500_VAUX2SEL,
 	AB8500_VRF1VAUX3SEL,
-- 
1.7.9.5

