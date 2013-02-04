Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3BDMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:16:56 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:58950 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3BDLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:55:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
Date: Mon,  4 Feb 2013 11:53:20 +0000
Message-Id: <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vsmps3 is put in HW control by SysClkReq1 at init. The
corresponding settings in suspend-force are removed.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   27 ++++++++++++++++++++-----
 drivers/regulator/ab8500.c                    |   21 ++++++++++++++++---
 include/linux/regulator/ab8500.h              |    3 +++
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index ae0695b..556eba5 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -143,15 +143,16 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
 	/*
+	 * Vsmps1SysClkReq1HPValid  = enabled
+	 * Vsmps2SysClkReq1HPValid  = enabled
+	 * Vsmps3SysClkReq1HPValid  = enabled
 	 * VanaSysClkReq1HPValid    = disabled
 	 * VpllSysClkReq1HPValid    = enabled
 	 * Vaux1SysClkReq1HPValid   = disabled
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
-	 * Vsmps2SysClkReq1HPValid  = enabled
-	 * Vsmps1SysClkReq1HPValid  = enabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x13),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x17),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
@@ -256,16 +257,32 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x00),
 	/*
-	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
 	 * Vsmps1Regu               = HW control
+	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x06),
 	/*
-	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
 	 * Vsmps2Regu               = HW control
+	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x06),
 	/*
+	 * Vsmps3Sel2               = 1.2125 V
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS3SEL2,             0x29),
+	/*
+	 * Vsmps3Regu               = HW control
+	 * Vsmps3SelCtrl            = Vsmps3 voltage defined by Vsmps3Sel2
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS3REGU,             0x06),
+	/*
+	 * Vsmps3Sel1               = 0.9 V
+	 * NOTE! PRCMU register
+	 */
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS3SEL1,             0x10),
+	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8edc413..ba1483b 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -496,13 +496,14 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	/*
 	 * 0x01, Vsmps1SysClkReq1HPValid
 	 * 0x02, Vsmps2SysClkReq1HPValid
+	 * 0x04, Vsmps3SysClkReq1HPValid
 	 * 0x08, VanaSysClkReq1HPValid
 	 * 0x10, VpllSysClkReq1HPValid
 	 * 0x20, Vaux1SysClkReq1HPValid
 	 * 0x40, Vaux2SysClkReq1HPValid
 	 * 0x80, Vaux3SysClkReq1HPValid
 	 */
-	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xfb),
+	REG_INIT(AB8500_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
 	/*
 	 * 0x10, VextSupply1SysClkReq1HPValid
 	 * 0x20, VextSupply2SysClkReq1HPValid
@@ -599,16 +600,22 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VBBSEL2,		0x04, 0x12, 0x0f),
 	/*
-	 * 0x0c, Vsmps1SelCtrl
 	 * 0x03, Vsmps1Regu
+	 * 0x0c, Vsmps1SelCtrl
 	 */
 	REG_INIT(AB8500_VSMPS1REGU,		0x04, 0x03, 0x0f),
 	/*
-	 * 0x0c, Vsmps2SelCtrl
 	 * 0x03, Vsmps2Regu
+	 * 0x0c, Vsmps2SelCtrl
 	 */
 	REG_INIT(AB8500_VSMPS2REGU,		0x04, 0x04, 0x0f),
 	/*
+	 * 0x03, Vsmps3Regu
+	 * 0x0c, Vsmps3SelCtrl
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8500_VSMPS3REGU,		0x04, 0x05, 0x0f),
+	/*
 	 * 0x0c, VanaRegu
 	 * 0x03, VpllRegu
 	 */
@@ -641,6 +648,14 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	 */
 	REG_INIT(AB8500_VSMPS1SEL1,		0x04, 0x13, 0x3f),
 	/*
+	 * 0x7f, Vsmps3Sel1
+	 */
+	REG_INIT(AB8500_VSMPS3SEL1,             0x04, 0x1b, 0x7f),
+	/*
+	 * 0x7f, Vsmps3Sel2
+	 */
+	REG_INIT(AB8500_VSMPS3SEL2,             0x04, 0x1c, 0x7f),
+	/*
 	 * 0x0f, Vaux1Sel
 	 */
 	REG_INIT(AB8500_VAUX1SEL,		0x04, 0x1f, 0x0f),
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index e54c8af..2c6c962 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -91,7 +91,10 @@ enum ab8500_regulator_reg {
 	AB8500_VBBSEL2, /* NOTE! PRCMU register */
 	AB8500_VSMPS1REGU,
 	AB8500_VSMPS2REGU,
+	AB8500_VSMPS3REGU, /* NOTE! PRCMU register */
 	AB8500_VSMPS1SEL1,
+	AB8500_VSMPS3SEL1, /* NOTE! PRCMU register */
+	AB8500_VSMPS3SEL2, /* NOTE! PRCMU register */
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
 
-- 
1.7.9.5

