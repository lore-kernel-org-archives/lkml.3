Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3BFKzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:21 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60274 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab3BFKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:08 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/49] regulator: ab8500: Add support for the ab8540
Date: Wed,  6 Feb 2013 10:53:52 +0000
Message-Id: <1360148051-7560-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To obtain full AB8540 regulator support, the AB8500 regulator driver
first needs to know its register layout and their initialisation values
for each. That information is provided via a couple of large data
structures which we provide here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c       |  685 +++++++++++++++++++++++++++++++++++++-
 include/linux/regulator/ab8500.h |   86 +++++
 2 files changed, 763 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 338edfe..3040985 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -109,6 +109,18 @@ static const int ldo_vaux56_voltages[] = {
 	2790000,
 };
 
+static const int ldo_vaux3_ab8540_voltages[] = {
+	1200000,
+	1500000,
+	1800000,
+	2100000,
+	2500000,
+	2750000,
+	2790000,
+	2910000,
+	3050000,
+};
+
 static const unsigned int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
@@ -119,6 +131,17 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
+static const int ldo_sdio_voltages[] = {
+	1160000,
+	1050000,
+	1100000,
+	1500000,
+	1800000,
+	2200000,
+	2910000,
+	3050000,
+};
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -716,10 +739,10 @@ static struct ab8500_regulator_info
 		/* values for CtrlVaux5 register */
 		.update_bank		= 0x01,
 		.update_reg		= 0x55,
-		.update_mask		= 0x08,
-		.update_val		= 0x00,
-		.update_val_idle	= 0x01,
-		.update_val_normal	= 0x00,
+		.update_mask		= 0x18,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x18,
+		.update_val_normal	= 0x10,
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x55,
 		.voltage_mask		= 0x07,
@@ -741,10 +764,10 @@ static struct ab8500_regulator_info
 		/* values for CtrlVaux6 register */
 		.update_bank		= 0x01,
 		.update_reg		= 0x56,
-		.update_mask		= 0x08,
-		.update_val		= 0x00,
-		.update_val_idle	= 0x01,
-		.update_val_normal	= 0x00,
+		.update_mask		= 0x18,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x18,
+		.update_val_normal	= 0x10,
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x56,
 		.voltage_mask		= 0x07,
@@ -1158,6 +1181,254 @@ static struct ab8500_regulator_info
 	},
 };
 
+/* AB8540 regulator information */
+static struct ab8500_regulator_info
+		ab8540_regulator_info[AB8540_NUM_REGULATORS] = {
+	/*
+	 * Variable Voltage Regulators
+	 *   name, min mV, max mV,
+	 *   update bank, reg, mask, enable val
+	 *   volt bank, reg, mask, table, table length
+	 */
+	[AB8540_LDO_AUX1] = {
+		.desc = {
+			.name		= "LDO-AUX1",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x1f,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8540_LDO_AUX2] = {
+		.desc = {
+			.name		= "LDO-AUX2",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x20,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8540_LDO_AUX3] = {
+		.desc = {
+			.name		= "LDO-AUX3",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+		},
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x0a,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x21,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_vaux3_ab8540_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+	},
+	[AB8540_LDO_AUX4] = {
+		.desc = {
+			.name		= "LDO-AUX4",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB9540_LDO_AUX4,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.load_lp_uA		= 5000,
+		/* values for Vaux4Regu register */
+		.update_bank		= 0x04,
+		.update_reg		= 0x2e,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		/* values for Vaux4SEL register */
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x2f,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8540_LDO_INTCORE] = {
+		.desc = {
+			.name		= "LDO-INTCORE",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_INTCORE,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+		},
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x44,
+		.update_val		= 0x44,
+		.update_val_idle	= 0x44,
+		.update_val_normal	= 0x04,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x80,
+		.voltage_mask		= 0x38,
+		.voltages		= ldo_vintcore_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
+	},
+
+	/*
+	 * Fixed Voltage Regulators
+	 *   name, fixed mV,
+	 *   update bank, reg, mask, enable val
+	 */
+	[AB8540_LDO_TVOUT] = {
+		.desc = {
+			.name		= "LDO-TVOUT",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_TVOUT,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.delay			= 10000,
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x82,
+		.update_val		= 0x02,
+		.update_val_idle	= 0x82,
+		.update_val_normal	= 0x02,
+	},
+	[AB8540_LDO_AUDIO] = {
+		.desc = {
+			.name		= "LDO-AUDIO",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x02,
+		.update_val		= 0x02,
+	},
+	[AB8540_LDO_ANAMIC1] = {
+		.desc = {
+			.name		= "LDO-ANAMIC1",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x08,
+		.update_val		= 0x08,
+	},
+	[AB8540_LDO_ANAMIC2] = {
+		.desc = {
+			.name		= "LDO-ANAMIC2",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x10,
+		.update_val		= 0x10,
+	},
+	[AB8540_LDO_DMIC] = {
+		.desc = {
+			.name		= "LDO-DMIC",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_DMIC,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x04,
+		.update_val		= 0x04,
+	},
+
+	/*
+	 * Regulators with fixed voltage and normal/idle modes
+	 */
+	[AB8540_LDO_ANA] = {
+		.desc = {
+			.name		= "LDO-ANA",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANA,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x06,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
+	},
+	[AB8540_LDO_SDIO] = {
+		.desc = {
+			.name		= "LDO-SDIO",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8540_LDO_SDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+		},
+		.min_uV			= 1050000,
+		.max_uV			= 3050000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x88,
+		.update_mask		= 0x30,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x00,
+		.update_val_normal	= 0x20,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x88,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_sdio_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
+	},
+};
+
 struct ab8500_reg_init {
 	u8 bank;
 	u8 addr;
@@ -1887,6 +2158,384 @@ static struct ab8500_reg_init ab9540_reg_init[] = {
 	REG_INIT(AB9540_REGUCTRLDISCH3,		0x04, 0x48, 0x01),
 };
 
+/* AB8540 register init */
+static struct ab8500_reg_init ab8540_reg_init[] = {
+	/*
+	 * 0x01, VSimSycClkReq1Valid
+	 * 0x02, VSimSycClkReq2Valid
+	 * 0x04, VSimSycClkReq3Valid
+	 * 0x08, VSimSycClkReq4Valid
+	 * 0x10, VSimSycClkReq5Valid
+	 * 0x20, VSimSycClkReq6Valid
+	 * 0x40, VSimSycClkReq7Valid
+	 * 0x80, VSimSycClkReq8Valid
+	 */
+	REG_INIT(AB8540_VSIMSYSCLKCTRL,		0x02, 0x33, 0xff),
+	/*
+	 * 0x03, VarmRequestCtrl
+	 * 0x0c, VapeRequestCtrl
+	 * 0x30, Vsmps1RequestCtrl
+	 * 0xc0, Vsmps2RequestCtrl
+	 */
+	REG_INIT(AB8540_REGUREQUESTCTRL1,	0x03, 0x03, 0xff),
+	/*
+	 * 0x03, Vsmps3RequestCtrl
+	 * 0x0c, VpllRequestCtrl
+	 * 0x30, VanaRequestCtrl
+	 * 0xc0, VextSupply1RequestCtrl
+	 */
+	REG_INIT(AB8540_REGUREQUESTCTRL2,	0x03, 0x04, 0xff),
+	/*
+	 * 0x03, VextSupply2RequestCtrl
+	 * 0x0c, VextSupply3RequestCtrl
+	 * 0x30, Vaux1RequestCtrl
+	 * 0xc0, Vaux2RequestCtrl
+	 */
+	REG_INIT(AB8540_REGUREQUESTCTRL3,	0x03, 0x05, 0xff),
+	/*
+	 * 0x03, Vaux3RequestCtrl
+	 * 0x04, SwHPReq
+	 */
+	REG_INIT(AB8540_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
+	/*
+	 * 0x01, Vsmps1SysClkReq1HPValid
+	 * 0x02, Vsmps2SysClkReq1HPValid
+	 * 0x04, Vsmps3SysClkReq1HPValid
+	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x10, VpllSysClkReq1HPValid
+	 * 0x20, Vaux1SysClkReq1HPValid
+	 * 0x40, Vaux2SysClkReq1HPValid
+	 * 0x80, Vaux3SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
+	/*
+	 * 0x01, VapeSysClkReq1HPValid
+	 * 0x02, VarmSysClkReq1HPValid
+	 * 0x04, VbbSysClkReq1HPValid
+	 * 0x10, VextSupply1SysClkReq1HPValid
+	 * 0x20, VextSupply2SysClkReq1HPValid
+	 * 0x40, VextSupply3SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x77),
+	/*
+	 * 0x01, Vsmps1HwHPReq1Valid
+	 * 0x02, Vsmps2HwHPReq1Valid
+	 * 0x04, Vsmps3HwHPReq1Valid
+	 * 0x08, VanaHwHPReq1Valid
+	 * 0x10, VpllHwHPReq1Valid
+	 * 0x20, Vaux1HwHPReq1Valid
+	 * 0x40, Vaux2HwHPReq1Valid
+	 * 0x80, Vaux3HwHPReq1Valid
+	 */
+	REG_INIT(AB8540_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xff),
+	/*
+	 * 0x01, VextSupply1HwHPReq1Valid
+	 * 0x02, VextSupply2HwHPReq1Valid
+	 * 0x04, VextSupply3HwHPReq1Valid
+	 */
+	REG_INIT(AB8540_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x07),
+	/*
+	 * 0x01, Vsmps1HwHPReq2Valid
+	 * 0x02, Vsmps2HwHPReq2Valid
+	 * 0x03, Vsmps3HwHPReq2Valid
+	 * 0x08, VanaHwHPReq2Valid
+	 * 0x10, VpllHwHPReq2Valid
+	 * 0x20, Vaux1HwHPReq2Valid
+	 * 0x40, Vaux2HwHPReq2Valid
+	 * 0x80, Vaux3HwHPReq2Valid
+	 */
+	REG_INIT(AB8540_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xff),
+	/*
+	 * 0x01, VextSupply1HwHPReq2Valid
+	 * 0x02, VextSupply2HwHPReq2Valid
+	 * 0x04, VextSupply3HwHPReq2Valid
+	 */
+	REG_INIT(AB8540_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x07),
+	/*
+	 * 0x01, VapeSwHPReqValid
+	 * 0x02, VarmSwHPReqValid
+	 * 0x04, Vsmps1SwHPReqValid
+	 * 0x08, Vsmps2SwHPReqValid
+	 * 0x10, Vsmps3SwHPReqValid
+	 * 0x20, VanaSwHPReqValid
+	 * 0x40, VpllSwHPReqValid
+	 * 0x80, Vaux1SwHPReqValid
+	 */
+	REG_INIT(AB8540_REGUSWHPREQVALID1,	0x03, 0x0d, 0xff),
+	/*
+	 * 0x01, Vaux2SwHPReqValid
+	 * 0x02, Vaux3SwHPReqValid
+	 * 0x04, VextSupply1SwHPReqValid
+	 * 0x08, VextSupply2SwHPReqValid
+	 * 0x10, VextSupply3SwHPReqValid
+	 */
+	REG_INIT(AB8540_REGUSWHPREQVALID2,	0x03, 0x0e, 0x1f),
+	/*
+	 * 0x02, SysClkReq2Valid1
+	 * ...
+	 * 0x80, SysClkReq8Valid1
+	 */
+	REG_INIT(AB8540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xff),
+	/*
+	 * 0x02, SysClkReq2Valid2
+	 * ...
+	 * 0x80, SysClkReq8Valid2
+	 */
+	REG_INIT(AB8540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xff),
+	/*
+	 * 0x01, Vaux4SwHPReqValid
+	 * 0x02, Vaux4HwHPReq2Valid
+	 * 0x04, Vaux4HwHPReq1Valid
+	 * 0x08, Vaux4SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUVAUX4REQVALID,	0x03, 0x11, 0x0f),
+	/*
+	 * 0x01, Vaux5SwHPReqValid
+	 * 0x02, Vaux5HwHPReq2Valid
+	 * 0x04, Vaux5HwHPReq1Valid
+	 * 0x08, Vaux5SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUVAUX5REQVALID,	0x03, 0x12, 0x0f),
+	/*
+	 * 0x01, Vaux6SwHPReqValid
+	 * 0x02, Vaux6HwHPReq2Valid
+	 * 0x04, Vaux6HwHPReq1Valid
+	 * 0x08, Vaux6SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUVAUX6REQVALID,	0x03, 0x13, 0x0f),
+	/*
+	 * 0x01, VclkbSwHPReqValid
+	 * 0x02, VclkbHwHPReq2Valid
+	 * 0x04, VclkbHwHPReq1Valid
+	 * 0x08, VclkbSysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUVCLKBREQVALID,	0x03, 0x14, 0x0f),
+	/*
+	 * 0x01, Vrf1SwHPReqValid
+	 * 0x02, Vrf1HwHPReq2Valid
+	 * 0x04, Vrf1HwHPReq1Valid
+	 * 0x08, Vrf1SysClkReq1HPValid
+	 */
+	REG_INIT(AB8540_REGUVRF1REQVALID,	0x03, 0x15, 0x0f),
+	/*
+	 * 0x02, VTVoutEna
+	 * 0x04, Vintcore12Ena
+	 * 0x38, Vintcore12Sel
+	 * 0x40, Vintcore12LP
+	 * 0x80, VTVoutLP
+	 */
+	REG_INIT(AB8540_REGUMISC1,		0x03, 0x80, 0xfe),
+	/*
+	 * 0x02, VaudioEna
+	 * 0x04, VdmicEna
+	 * 0x08, Vamic1Ena
+	 * 0x10, Vamic2Ena
+	 * 0x20, Vamic12LP
+	 * 0xC0, VdmicSel
+	 */
+	REG_INIT(AB8540_VAUDIOSUPPLY,		0x03, 0x83, 0xfe),
+	/*
+	 * 0x01, Vamic1_dzout
+	 * 0x02, Vamic2_dzout
+	 */
+	REG_INIT(AB8540_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
+	/*
+	 * 0x07, VHSICSel
+	 * 0x08, VHSICOffState
+	 * 0x10, VHSIEna
+	 * 0x20, VHSICLP
+	 */
+	REG_INIT(AB8540_VHSIC,			0x03, 0x87, 0x3f),
+	/*
+	 * 0x07, VSDIOSel
+	 * 0x08, VSDIOOffState
+	 * 0x10, VSDIOEna
+	 * 0x20, VSDIOLP
+	 */
+	REG_INIT(AB8540_VSDIO,			0x03, 0x88, 0x3f),
+	/*
+	 * 0x03, Vsmps1Regu
+	 * 0x0c, Vsmps1SelCtrl
+	 * 0x10, Vsmps1AutoMode
+	 * 0x20, Vsmps1PWMMode
+	 */
+	REG_INIT(AB8540_VSMPS1REGU,		0x04, 0x03, 0x3f),
+	/*
+	 * 0x03, Vsmps2Regu
+	 * 0x0c, Vsmps2SelCtrl
+	 * 0x10, Vsmps2AutoMode
+	 * 0x20, Vsmps2PWMMode
+	 */
+	REG_INIT(AB8540_VSMPS2REGU,		0x04, 0x04, 0x3f),
+	/*
+	 * 0x03, Vsmps3Regu
+	 * 0x0c, Vsmps3SelCtrl
+	 * 0x10, Vsmps3AutoMode
+	 * 0x20, Vsmps3PWMMode
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8540_VSMPS3REGU,		0x04, 0x05, 0x0f),
+	/*
+	 * 0x03, VpllRegu
+	 * 0x0c, VanaRegu
+	 */
+	REG_INIT(AB8540_VPLLVANAREGU,		0x04, 0x06, 0x0f),
+	/*
+	 * 0x03, VextSupply1Regu
+	 * 0x0c, VextSupply2Regu
+	 * 0x30, VextSupply3Regu
+	 * 0x40, ExtSupply2Bypass
+	 * 0x80, ExtSupply3Bypass
+	 */
+	REG_INIT(AB8540_EXTSUPPLYREGU,		0x04, 0x08, 0xff),
+	/*
+	 * 0x03, Vaux1Regu
+	 * 0x0c, Vaux2Regu
+	 */
+	REG_INIT(AB8540_VAUX12REGU,		0x04, 0x09, 0x0f),
+	/*
+	 * 0x0c, VRF1Regu
+	 * 0x03, Vaux3Regu
+	 */
+	REG_INIT(AB8540_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
+	/*
+	 * 0x3f, Vsmps1Sel1
+	 */
+	REG_INIT(AB8540_VSMPS1SEL1,		0x04, 0x13, 0x3f),
+	/*
+	 * 0x3f, Vsmps1Sel2
+	 */
+	REG_INIT(AB8540_VSMPS1SEL2,		0x04, 0x14, 0x3f),
+	/*
+	 * 0x3f, Vsmps1Sel3
+	 */
+	REG_INIT(AB8540_VSMPS1SEL3,		0x04, 0x15, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel1
+	 */
+	REG_INIT(AB8540_VSMPS2SEL1,		0x04, 0x17, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel2
+	 */
+	REG_INIT(AB8540_VSMPS2SEL2,		0x04, 0x18, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel3
+	 */
+	REG_INIT(AB8540_VSMPS2SEL3,		0x04, 0x19, 0x3f),
+	/*
+	 * 0x7f, Vsmps3Sel1
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8540_VSMPS3SEL1,             0x04, 0x1b, 0x7f),
+	/*
+	 * 0x7f, Vsmps3Sel2
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB8540_VSMPS3SEL2,             0x04, 0x1c, 0x7f),
+	/*
+	 * 0x0f, Vaux1Sel
+	 */
+	REG_INIT(AB8540_VAUX1SEL,		0x04, 0x1f, 0x0f),
+	/*
+	 * 0x0f, Vaux2Sel
+	 */
+	REG_INIT(AB8540_VAUX2SEL,		0x04, 0x20, 0x0f),
+	/*
+	 * 0x07, Vaux3Sel
+	 * 0x70, Vrf1Sel
+	 */
+	REG_INIT(AB8540_VRF1VAUX3SEL,		0x04, 0x21, 0x77),
+	/*
+	 * 0x01, VextSupply12LP
+	 */
+	REG_INIT(AB8540_REGUCTRL2SPARE,		0x04, 0x22, 0x01),
+	/*
+	 * 0x07, Vanasel
+	 * 0x30, Vpllsel
+	 */
+	REG_INIT(AB8540_VANAVPLLSEL,		0x04, 0x29, 0x37),
+	/*
+	 * 0x03, Vaux4RequestCtrl
+	 */
+	REG_INIT(AB8540_VAUX4REQCTRL,		0x04, 0x2d, 0x03),
+	/*
+	 * 0x03, Vaux4Regu
+	 */
+	REG_INIT(AB8540_VAUX4REGU,		0x04, 0x2e, 0x03),
+	/*
+	 * 0x0f, Vaux4Sel
+	 */
+	REG_INIT(AB8540_VAUX4SEL,		0x04, 0x2f, 0x0f),
+	/*
+	 * 0x03, Vaux5RequestCtrl
+	 */
+	REG_INIT(AB8540_VAUX5REQCTRL,		0x04, 0x31, 0x03),
+	/*
+	 * 0x03, Vaux5Regu
+	 */
+	REG_INIT(AB8540_VAUX5REGU,		0x04, 0x32, 0x03),
+	/*
+	 * 0x3f, Vaux5Sel
+	 */
+	REG_INIT(AB8540_VAUX5SEL,		0x04, 0x33, 0x3f),
+	/*
+	 * 0x03, Vaux6RequestCtrl
+	 */
+	REG_INIT(AB8540_VAUX6REQCTRL,		0x04, 0x34, 0x03),
+	/*
+	 * 0x03, Vaux6Regu
+	 */
+	REG_INIT(AB8540_VAUX6REGU,		0x04, 0x35, 0x03),
+	/*
+	 * 0x3f, Vaux6Sel
+	 */
+	REG_INIT(AB8540_VAUX6SEL,		0x04, 0x36, 0x3f),
+	/*
+	 * 0x03, VCLKBRequestCtrl
+	 */
+	REG_INIT(AB8540_VCLKBREQCTRL,		0x04, 0x37, 0x03),
+	/*
+	 * 0x03, VCLKBRegu
+	 */
+	REG_INIT(AB8540_VCLKBREGU,		0x04, 0x38, 0x03),
+	/*
+	 * 0x07, VCLKBSel
+	 */
+	REG_INIT(AB8540_VCLKBSEL,		0x04, 0x39, 0x07),
+	/*
+	 * 0x03, Vrf1RequestCtrl
+	 */
+	REG_INIT(AB8540_VRF1REQCTRL,		0x04, 0x3a, 0x03),
+	/*
+	 * 0x01, VpllDisch
+	 * 0x02, Vrf1Disch
+	 * 0x04, Vaux1Disch
+	 * 0x08, Vaux2Disch
+	 * 0x10, Vaux3Disch
+	 * 0x20, Vintcore12Disch
+	 * 0x40, VTVoutDisch
+	 * 0x80, VaudioDisch
+	 */
+	REG_INIT(AB8540_REGUCTRLDISCH,		0x04, 0x43, 0xff),
+	/*
+	 * 0x02, VanaDisch
+	 * 0x04, VdmicPullDownEna
+	 * 0x08, VpllPullDownEna
+	 * 0x10, VdmicDisch
+	 */
+	REG_INIT(AB8540_REGUCTRLDISCH2,		0x04, 0x44, 0x1e),
+	/*
+	 * 0x01, Vaux4Disch
+	 */
+	REG_INIT(AB8540_REGUCTRLDISCH3,		0x04, 0x48, 0x01),
+	/*
+	 * 0x01, Vaux5Disch
+	 * 0x02, Vaux6Disch
+	 * 0x04, VCLKBDisch
+	 */
+	REG_INIT(AB8540_REGUCTRLDISCH4,		0x04, 0x49, 0x07),
+};
+
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
 					   struct ab8500_reg_init *reg_init,
 					   int id, int mask, int value)
@@ -1993,6 +2642,21 @@ static struct of_regulator_match ab8505_regulator_match[] = {
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8505_LDO_ANA, },
 };
 
+static struct of_regulator_match ab8540_regulator_match[] = {
+	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8540_LDO_AUX1, },
+	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8540_LDO_AUX2, },
+	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8540_LDO_AUX3, },
+	{ .name	= "ab8500_ldo_aux4",    .driver_data = (void *) AB8540_LDO_AUX4, },
+	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8540_LDO_INTCORE, },
+	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8540_LDO_TVOUT, },
+	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8540_LDO_AUDIO, },
+	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8540_LDO_ANAMIC1, },
+	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8540_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB8540_LDO_DMIC, },
+	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8540_LDO_ANA, },
+	{ .name = "ab8500_ldo_sdio",    .driver_data = (void *) AB8540_LDO_SDIO, },
+};
+
 static struct of_regulator_match ab9540_regulator_match[] = {
 	{ .name = "ab9540_ldo_aux1",    .driver_data = (void *) AB9540_LDO_AUX1, },
 	{ .name = "ab9540_ldo_aux2",    .driver_data = (void *) AB9540_LDO_AUX2, },
@@ -2052,6 +2716,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
 		reg_init = ab8505_reg_init;
 		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
+	} else if (is_ab8540(ab8500)) {
+		regulator_info = ab8540_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
+		reg_init = ab8540_reg_init;
+		reg_init_size = AB8540_NUM_REGULATOR_REGISTERS;
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 9a7cf97..bb0140c 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -68,6 +68,25 @@ enum ab9540_regulator_id {
 	AB9540_NUM_REGULATORS,
 };
 
+/* AB8540 regulators */
+enum ab8540_regulator_id {
+	AB8540_LDO_AUX1,
+	AB8540_LDO_AUX2,
+	AB8540_LDO_AUX3,
+	AB8540_LDO_AUX4,
+	AB8540_LDO_INTCORE,
+	AB8540_LDO_TVOUT,
+	AB8540_LDO_AUDIO,
+	AB8540_LDO_ANAMIC1,
+	AB8540_LDO_ANAMIC2,
+	AB8540_LDO_DMIC,
+	AB8540_LDO_ANA,
+	AB8540_LDO_SDIO,
+	AB8540_SYSCLKREQ_2,
+	AB8540_SYSCLKREQ_4,
+	AB8540_NUM_REGULATORS,
+};
+
 /* AB8500, AB8505, and AB9540 register initialization */
 struct ab8500_regulator_reg_init {
 	int id;
@@ -212,6 +231,73 @@ enum ab9540_regulator_reg {
 	AB9540_NUM_REGULATOR_REGISTERS,
 };
 
+/* AB8540 registers */
+enum ab8540_regulator_reg {
+	AB8540_REGUREQUESTCTRL1,
+	AB8540_REGUREQUESTCTRL2,
+	AB8540_REGUREQUESTCTRL3,
+	AB8540_REGUREQUESTCTRL4,
+	AB8540_REGUSYSCLKREQ1HPVALID1,
+	AB8540_REGUSYSCLKREQ1HPVALID2,
+	AB8540_REGUHWHPREQ1VALID1,
+	AB8540_REGUHWHPREQ1VALID2,
+	AB8540_REGUHWHPREQ2VALID1,
+	AB8540_REGUHWHPREQ2VALID2,
+	AB8540_REGUSWHPREQVALID1,
+	AB8540_REGUSWHPREQVALID2,
+	AB8540_REGUSYSCLKREQVALID1,
+	AB8540_REGUSYSCLKREQVALID2,
+	AB8540_REGUVAUX4REQVALID,
+	AB8540_REGUVAUX5REQVALID,
+	AB8540_REGUVAUX6REQVALID,
+	AB8540_REGUVCLKBREQVALID,
+	AB8540_REGUVRF1REQVALID,
+	AB8540_REGUMISC1,
+	AB8540_VAUDIOSUPPLY,
+	AB8540_REGUCTRL1VAMIC,
+	AB8540_VHSIC,
+	AB8540_VSDIO,
+	AB8540_VSMPS1REGU,
+	AB8540_VSMPS2REGU,
+	AB8540_VSMPS3REGU,
+	AB8540_VPLLVANAREGU,
+	AB8540_EXTSUPPLYREGU,
+	AB8540_VAUX12REGU,
+	AB8540_VRF1VAUX3REGU,
+	AB8540_VSMPS1SEL1,
+	AB8540_VSMPS1SEL2,
+	AB8540_VSMPS1SEL3,
+	AB8540_VSMPS2SEL1,
+	AB8540_VSMPS2SEL2,
+	AB8540_VSMPS2SEL3,
+	AB8540_VSMPS3SEL1,
+	AB8540_VSMPS3SEL2,
+	AB8540_VAUX1SEL,
+	AB8540_VAUX2SEL,
+	AB8540_VRF1VAUX3SEL,
+	AB8540_REGUCTRL2SPARE,
+	AB8540_VAUX4REQCTRL,
+	AB8540_VAUX4REGU,
+	AB8540_VAUX4SEL,
+	AB8540_VAUX5REQCTRL,
+	AB8540_VAUX5REGU,
+	AB8540_VAUX5SEL,
+	AB8540_VAUX6REQCTRL,
+	AB8540_VAUX6REGU,
+	AB8540_VAUX6SEL,
+	AB8540_VCLKBREQCTRL,
+	AB8540_VCLKBREGU,
+	AB8540_VCLKBSEL,
+	AB8540_VRF1REQCTRL,
+	AB8540_REGUCTRLDISCH,
+	AB8540_REGUCTRLDISCH2,
+	AB8540_REGUCTRLDISCH3,
+	AB8540_REGUCTRLDISCH4,
+	AB8540_VSIMSYSCLKCTRL,
+	AB8540_VANAVPLLSEL,
+	AB8540_NUM_REGULATOR_REGISTERS,
+};
+
 /* AB8500 external regulators */
 struct ab8500_ext_regulator_cfg {
 	bool hwreq; /* requires hw mode or high power mode */
-- 
1.7.9.5

