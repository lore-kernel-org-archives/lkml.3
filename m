Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3BFLC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:02:28 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41280 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab3BFKzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:06 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/49] regulator: ab8500: add support for ab8505
Date: Wed,  6 Feb 2013 10:53:49 +0000
Message-Id: <1360148051-7560-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To obtain full AB8505 regulator support, the AB8500 regulator driver
first needs to know its register layout and their initialisation values
for each. That information is provided via a couple of large data
structures which we provide here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |  511 +++++++++++++++++++-
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 drivers/regulator/ab8500.c                    |  616 +++++++++++++++++++++++++
 include/linux/regulator/ab8500.h              |   75 ++-
 4 files changed, 1194 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 16745e2..83dcbd1 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -5,6 +5,7 @@
  *
  * Authors: Sundar Iyer <sundar.iyer@stericsson.com>
  *          Bengt Jonsson <bengt.g.jonsson@stericsson.com>
+ *          Daniel Willerud <daniel.willerud@stericsson.com>
  *
  * MOP500 board specific initialization for regulators
  */
@@ -99,6 +100,27 @@ static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
 	REGULATOR_SUPPLY("vmmc", "sdi0"),
 };
 
+static struct regulator_consumer_supply ab8505_vaux4_consumers[] = {
+};
+
+static struct regulator_consumer_supply ab8505_vaux5_consumers[] = {
+};
+
+static struct regulator_consumer_supply ab8505_vaux6_consumers[] = {
+};
+
+static struct regulator_consumer_supply ab8505_vaux8_consumers[] = {
+	/* AB8500 audio codec device */
+	REGULATOR_SUPPLY("v-aux8", NULL),
+};
+
+static struct regulator_consumer_supply ab8505_vadc_consumers[] = {
+	/* Internal general-purpose ADC */
+	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
+	/* ADC for charger */
+	REGULATOR_SUPPLY("vddadc", "ab8500-charger.0"),
+};
+
 static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 	/* TV-out DENC supply */
 	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
@@ -133,6 +155,11 @@ static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
 	REGULATOR_SUPPLY("vddulpivio18", "ab8500-usb.0"),
 };
 
+static struct regulator_consumer_supply ab8505_usb_consumers[] = {
+	/* HS USB OTG physical interface */
+	REGULATOR_SUPPLY("v-usb", NULL),
+};
+
 static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 	/* External displays, connector on board, 1v8 power supply */
 	REGULATOR_SUPPLY("vsmps2", "mcde.0"),
@@ -472,6 +499,450 @@ static struct regulator_init_data ab8500_ext_regulators[] = {
 	},
 };
 
+/* ab8505 regulator register initialization */
+static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
+	/*
+	 * VarmRequestCtrl
+	 * VsmpsCRequestCtrl
+	 * VsmpsARequestCtrl
+	 * VsmpsBRequestCtrl
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL1,       0x00, 0x00),
+	/*
+	 * VsafeRequestCtrl
+	 * VpllRequestCtrl
+	 * VanaRequestCtrl          = HP/LP depending on VxRequest
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL2,       0x30, 0x00),
+	/*
+	 * Vaux1RequestCtrl         = HP/LP depending on VxRequest
+	 * Vaux2RequestCtrl         = HP/LP depending on VxRequest
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL3,       0xf0, 0x00),
+	/*
+	 * Vaux3RequestCtrl         = HP/LP depending on VxRequest
+	 * SwHPReq                  = Control through SWValid disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL4,       0x07, 0x00),
+	/*
+	 * VsmpsASysClkReq1HPValid
+	 * VsmpsBSysClkReq1HPValid
+	 * VsafeSysClkReq1HPValid
+	 * VanaSysClkReq1HPValid    = disabled
+	 * VpllSysClkReq1HPValid
+	 * Vaux1SysClkReq1HPValid   = disabled
+	 * Vaux2SysClkReq1HPValid   = disabled
+	 * Vaux3SysClkReq1HPValid   = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID1, 0xe8, 0x00),
+	/*
+	 * VsmpsCSysClkReq1HPValid
+	 * VarmSysClkReq1HPValid
+	 * VbbSysClkReq1HPValid
+	 * VsmpsMSysClkReq1HPValid
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID2, 0x00, 0x00),
+	/*
+	 * VsmpsAHwHPReq1Valid
+	 * VsmpsBHwHPReq1Valid
+	 * VsafeHwHPReq1Valid
+	 * VanaHwHPReq1Valid        = disabled
+	 * VpllHwHPReq1Valid
+	 * Vaux1HwHPreq1Valid       = disabled
+	 * Vaux2HwHPReq1Valid       = disabled
+	 * Vaux3HwHPReqValid        = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID1,     0xe8, 0x00),
+	/*
+	 * VsmpsMHwHPReq1Valid
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID2,     0x00, 0x00),
+	/*
+	 * VsmpsAHwHPReq2Valid
+	 * VsmpsBHwHPReq2Valid
+	 * VsafeHwHPReq2Valid
+	 * VanaHwHPReq2Valid        = disabled
+	 * VpllHwHPReq2Valid
+	 * Vaux1HwHPReq2Valid       = disabled
+	 * Vaux2HwHPReq2Valid       = disabled
+	 * Vaux3HwHPReq2Valid       = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID1,     0xe8, 0x00),
+	/*
+	 * VsmpsMHwHPReq2Valid
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID2,     0x00, 0x00),
+	/**
+	 * VsmpsCSwHPReqValid
+	 * VarmSwHPReqValid
+	 * VsmpsASwHPReqValid
+	 * VsmpsBSwHPReqValid
+	 * VsafeSwHPReqValid
+	 * VanaSwHPReqValid
+	 * VanaSwHPReqValid         = disabled
+	 * VpllSwHPReqValid
+	 * Vaux1SwHPReqValid        = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID1,      0xa0, 0x00),
+	/*
+	 * Vaux2SwHPReqValid        = disabled
+	 * Vaux3SwHPReqValid        = disabled
+	 * VsmpsMSwHPReqValid
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID2,      0x03, 0x00),
+	/*
+	 * SysClkReq2Valid1         = SysClkReq2 controlled
+	 * SysClkReq3Valid1         = disabled
+	 * SysClkReq4Valid1         = SysClkReq4 controlled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID1,    0x0e, 0x0a),
+	/*
+	 * SysClkReq2Valid2         = disabled
+	 * SysClkReq3Valid2         = disabled
+	 * SysClkReq4Valid2         = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID2,    0x0e, 0x00),
+	/*
+	 * Vaux4SwHPReqValid
+	 * Vaux4HwHPReq2Valid
+	 * Vaux4HwHPReq1Valid
+	 * Vaux4SysClkReq1HPValid
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUVAUX4REQVALID,    0x00, 0x00),
+	/*
+	 * VadcEna                  = disabled
+	 * VintCore12Ena            = disabled
+	 * VintCore12Sel            = 1.25 V
+	 * VintCore12LP             = inactive (HP)
+	 * VadcLP                   = inactive (HP)
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUMISC1,              0xfe, 0x10),
+	/*
+	 * VaudioEna                = disabled
+	 * Vaux8Ena                 = disabled
+	 * Vamic1Ena                = disabled
+	 * Vamic2Ena                = disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUDIOSUPPLY,           0x1e, 0x00),
+	/*
+	 * Vamic1_dzout             = high-Z when Vamic1 is disabled
+	 * Vamic2_dzout             = high-Z when Vamic2 is disabled
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUCTRL1VAMIC,         0x03, 0x00),
+	/*
+	 * VsmpsARegu
+	 * VsmpsASelCtrl
+	 * VsmpsAAutoMode
+	 * VsmpsAPWMMode
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSAREGU,    0x00, 0x00),
+	/*
+	 * VsmpsBRegu
+	 * VsmpsBSelCtrl
+	 * VsmpsBAutoMode
+	 * VsmpsBPWMMode
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSBREGU,    0x00, 0x00),
+	/*
+	 * VsafeRegu
+	 * VsafeSelCtrl
+	 * VsafeAutoMode
+	 * VsafePWMMode
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSAFEREGU,    0x00, 0x00),
+	/*
+	 * VPll                     = Hw controlled (NOTE! PRCMU bits)
+	 * VanaRegu                 = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VPLLVANAREGU,           0x0f, 0x02),
+	/*
+	 * VextSupply1Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
+	 * VextSupply2Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
+	 * VextSupply3Regu          = force OFF (OTP_ExtSupply3LPnPolarity 0)
+	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
+	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_EXTSUPPLYREGU,          0xff, 0x30),
+	/*
+	 * Vaux1Regu                = force HP
+	 * Vaux2Regu                = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX12REGU,             0x0f, 0x01),
+	/*
+	 * Vaux3Regu                = force off
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3REGU,          0x03, 0x00),
+	/*
+	 * VsmpsASel1
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL1,    0x00, 0x00),
+	/*
+	 * VsmpsASel2
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL2,    0x00, 0x00),
+	/*
+	 * VsmpsASel3
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL3,    0x00, 0x00),
+	/*
+	 * VsmpsBSel1
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL1,    0x00, 0x00),
+	/*
+	 * VsmpsBSel2
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL2,    0x00, 0x00),
+	/*
+	 * VsmpsBSel3
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL3,    0x00, 0x00),
+	/*
+	 * VsafeSel1
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL1,    0x00, 0x00),
+	/*
+	 * VsafeSel2
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL2,    0x00, 0x00),
+	/*
+	 * VsafeSel3
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL3,    0x00, 0x00),
+	/*
+	 * Vaux1Sel                 = 2.8 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX1SEL,               0x0f, 0x0C),
+	/*
+	 * Vaux2Sel                 = 2.9 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX2SEL,               0x0f, 0x0d),
+	/*
+	 * Vaux3Sel                 = 2.91 V
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3SEL,           0x07, 0x07),
+	/*
+	 * Vaux4RequestCtrl
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX4REQCTRL,    0x00, 0x00),
+	/*
+	 * Vaux4Regu
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX4REGU,    0x00, 0x00),
+	/*
+	 * Vaux4Sel
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_VAUX4SEL,    0x00, 0x00),
+	/*
+	 * Vaux1Disch               = short discharge time
+	 * Vaux2Disch               = short discharge time
+	 * Vaux3Disch               = short discharge time
+	 * Vintcore12Disch          = short discharge time
+	 * VTVoutDisch              = short discharge time
+	 * VaudioDisch              = short discharge time
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH,          0xfc, 0x00),
+	/*
+	 * VanaDisch                = short discharge time
+	 * Vaux8PullDownEna         = pulldown disabled when Vaux8 is disabled
+	 * Vaux8Disch               = short discharge time
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH2,         0x16, 0x00),
+	/*
+	 * Vaux4Disch               = short discharge time
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH3,         0x01, 0x00),
+	/*
+	 * Vaux5Sel
+	 * Vaux5LP
+	 * Vaux5Ena
+	 * Vaux5Disch
+	 * Vaux5DisSfst
+	 * Vaux5DisPulld
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX5,              0x00, 0x00),
+	/*
+	 * Vaux6Sel
+	 * Vaux6LP
+	 * Vaux6Ena
+	 * Vaux6DisPulld
+	 */
+	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX6,              0x00, 0x00),
+};
+
+struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
+	/* supplies to the display/camera */
+	[AB8505_LDO_AUX1] = {
+		.constraints = {
+			.name = "V-DISPLAY",
+			.min_uV = 2800000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS,
+			.boot_on = 1, /* display is on at boot */
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
+		.consumer_supplies = ab8500_vaux1_consumers,
+	},
+	/* supplies to the on-board eMMC */
+	[AB8505_LDO_AUX2] = {
+		.constraints = {
+			.name = "V-eMMC1",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
+		.consumer_supplies = ab8500_vaux2_consumers,
+	},
+	/* supply for VAUX3, supplies to SDcard slots */
+	[AB8505_LDO_AUX3] = {
+		.constraints = {
+			.name = "V-MMC-SD",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
+		.consumer_supplies = ab8500_vaux3_consumers,
+	},
+	/* supply for VAUX4, supplies to NFC and standalone secure element */
+	[AB8505_LDO_AUX4] = {
+		.constraints = {
+			.name = "V-NFC-SE",
+			.min_uV = 1100000,
+			.max_uV = 3300000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux4_consumers),
+		.consumer_supplies = ab8505_vaux4_consumers,
+	},
+	/* supply for VAUX5, supplies to TBD */
+	[AB8505_LDO_AUX5] = {
+		.constraints = {
+			.name = "V-AUX5",
+			.min_uV = 1050000,
+			.max_uV = 2790000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux5_consumers),
+		.consumer_supplies = ab8505_vaux5_consumers,
+	},
+	/* supply for VAUX6, supplies to TBD */
+	[AB8505_LDO_AUX6] = {
+		.constraints = {
+			.name = "V-AUX6",
+			.min_uV = 1050000,
+			.max_uV = 2790000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux6_consumers),
+		.consumer_supplies = ab8505_vaux6_consumers,
+	},
+	/* supply for gpadc, ADC LDO */
+	[AB8505_LDO_ADC] = {
+		.constraints = {
+			.name = "V-ADC",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vadc_consumers),
+		.consumer_supplies = ab8505_vadc_consumers,
+	},
+	/* supply for ab8500-vaudio, VAUDIO LDO */
+	[AB8505_LDO_AUDIO] = {
+		.constraints = {
+			.name = "V-AUD",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaud_consumers),
+		.consumer_supplies = ab8500_vaud_consumers,
+	},
+	/* supply for v-anamic1 VAMic1-LDO */
+	[AB8505_LDO_ANAMIC1] = {
+		.constraints = {
+			.name = "V-AMIC1",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
+		.consumer_supplies = ab8500_vamic1_consumers,
+	},
+	/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
+	[AB8505_LDO_ANAMIC2] = {
+		.constraints = {
+			.name = "V-AMIC2",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
+		.consumer_supplies = ab8500_vamic2_consumers,
+	},
+	/* supply for v-aux8, VAUX8 LDO */
+	[AB8505_LDO_AUX8] = {
+		.constraints = {
+			.name = "V-AUX8",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux8_consumers),
+		.consumer_supplies = ab8505_vaux8_consumers,
+	},
+	/* supply for v-intcore12, VINTCORE12 LDO */
+	[AB8505_LDO_INTCORE] = {
+		.constraints = {
+			.name = "V-INTCORE",
+			.min_uV = 1250000,
+			.max_uV = 1350000,
+			.input_uV = 1800000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE |
+					  REGULATOR_CHANGE_DRMS,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
+		.consumer_supplies = ab8500_vintcore_consumers,
+	},
+	/* supply for LDO USB */
+	[AB8505_LDO_USB] = {
+		.constraints = {
+			.name = "V-USB",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_usb_consumers),
+		.consumer_supplies = ab8505_usb_consumers,
+	},
+	/* supply for U8500 CSI-DSI, VANA LDO */
+	[AB8505_LDO_ANA] = {
+		.constraints = {
+			.name = "V-CSI-DSI",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
+		.consumer_supplies = ab8500_vana_consumers,
+	},
+};
+
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.reg_init               = ab8500_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
@@ -481,18 +952,39 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
 
+/* Use the AB8500 init settings for AB8505 as they are the same right now */
+struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
+	.reg_init               = ab8505_reg_init,
+	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
+	.regulator              = ab8505_regulators,
+	.num_regulator          = ARRAY_SIZE(ab8505_regulators),
+};
+
 static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
 {
 	int i;
 
-	for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
-		if (ab8500_reg_init[i].id == id) {
-			u8 initval = ab8500_reg_init[i].value;
-			initval = (initval & ~mask) | (value & mask);
-			ab8500_reg_init[i].value = initval;
+	if (cpu_is_u8520()) {
+		for (i = ARRAY_SIZE(ab8505_reg_init) - 1; i >= 0; i--) {
+			if (ab8505_reg_init[i].id == id) {
+				u8 initval = ab8505_reg_init[i].value;
+				initval = (initval & ~mask) | (value & mask);
+				ab8505_reg_init[i].value = initval;
 
-			BUG_ON(mask & ~ab8500_reg_init[i].mask);
-			return;
+				BUG_ON(mask & ~ab8505_reg_init[i].mask);
+				return;
+			}
+		}
+	} else {
+		for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
+			if (ab8500_reg_init[i].id == id) {
+				u8 initval = ab8500_reg_init[i].value;
+				initval = (initval & ~mask) | (value & mask);
+				ab8500_reg_init[i].value = initval;
+
+				BUG_ON(mask & ~ab8500_reg_init[i].mask);
+				return;
+			}
 		}
 	}
 
@@ -514,6 +1006,11 @@ void mop500_regulator_init(void)
 		regulator->constraints.state_standby.disabled = 1;
 	}
 
+	if (cpu_is_u8520()) {
+		/* Vaux2 initialized to be on */
+		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
+	}
+
 	/*
 	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
 	 * all HREFP_V20 boards)
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 3d4c412..9bece38 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -15,6 +15,7 @@
 #include <linux/regulator/ab8500.h>
 
 extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
+extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index df4fd1a..338edfe 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -5,11 +5,15 @@
  *
  * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
  *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *          Daniel Willerud <daniel.willerud@stericsson.com> for ST-Ericsson
  *
  * AB8500 peripheral regulators
  *
  * AB8500 supports the following regulators:
  *   VAUX1/2/3, VINTCORE, VTVOUT, VUSB, VAUDIO, VAMIC1/2, VDMIC, VANA
+ *
+ * AB8505 supports the following regulators:
+ *   VAUX1/2/3/4/5/6, VINTCORE, VADC, VUSB, VAUDIO, VAMIC1/2, VDMIC, VANA
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -94,6 +98,17 @@ static const unsigned int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
+static const int ldo_vaux56_voltages[] = {
+	1800000,
+	1050000,
+	1100000,
+	1200000,
+	1500000,
+	2200000,
+	2500000,
+	2790000,
+};
+
 static const unsigned int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
@@ -579,6 +594,312 @@ static struct ab8500_regulator_info
 	},
 };
 
+/* AB8505 regulator information */
+static struct ab8500_regulator_info
+		ab8505_regulator_info[AB8505_NUM_REGULATORS] = {
+	/*
+	 * Variable Voltage Regulators
+	 *   name, min mV, max mV,
+	 *   update bank, reg, mask, enable val
+	 *   volt bank, reg, mask, table, table length
+	 */
+	[AB8505_LDO_AUX1] = {
+		.desc = {
+			.name		= "LDO-AUX1",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
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
+	[AB8505_LDO_AUX2] = {
+		.desc = {
+			.name		= "LDO-AUX2",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
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
+	[AB8505_LDO_AUX3] = {
+		.desc = {
+			.name		= "LDO-AUX3",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
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
+		.voltages		= ldo_vaux3_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
+	},
+	[AB8505_LDO_AUX4] = {
+		.desc = {
+			.name		= "LDO-AUX4",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB9540_LDO_AUX4,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
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
+	[AB8505_LDO_AUX5] = {
+		.desc = {
+			.name		= "LDO-AUX5",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8505_LDO_AUX5,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+		},
+		.min_uV			= 1050000,
+		.max_uV			= 2790000,
+		.load_lp_uA		= 2000,
+		/* values for CtrlVaux5 register */
+		.update_bank		= 0x01,
+		.update_reg		= 0x55,
+		.update_mask		= 0x08,
+		.update_val		= 0x00,
+		.update_val_idle	= 0x01,
+		.update_val_normal	= 0x00,
+		.voltage_bank		= 0x01,
+		.voltage_reg		= 0x55,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_vaux56_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
+	},
+	[AB8505_LDO_AUX6] = {
+		.desc = {
+			.name		= "LDO-AUX6",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8505_LDO_AUX6,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+		},
+		.min_uV			= 1050000,
+		.max_uV			= 2790000,
+		.load_lp_uA		= 2000,
+		/* values for CtrlVaux6 register */
+		.update_bank		= 0x01,
+		.update_reg		= 0x56,
+		.update_mask		= 0x08,
+		.update_val		= 0x00,
+		.update_val_idle	= 0x01,
+		.update_val_normal	= 0x00,
+		.voltage_bank		= 0x01,
+		.voltage_reg		= 0x56,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_vaux56_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
+	},
+	[AB8505_LDO_INTCORE] = {
+		.desc = {
+			.name		= "LDO-INTCORE",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_INTCORE,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
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
+	[AB8505_LDO_ADC] = {
+		.desc = {
+			.name		= "LDO-ADC",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8505_LDO_ADC,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.delay			= 10000,
+		.fixed_uV		= 2000000,
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x82,
+		.update_val		= 0x02,
+		.update_val_idle	= 0x82,
+		.update_val_normal	= 0x02,
+	},
+	[AB8505_LDO_USB] = {
+		.desc = {
+			.name           = "LDO-USB",
+			.ops            = &ab8500_regulator_mode_ops,
+			.type           = REGULATOR_VOLTAGE,
+			.id             = AB9540_LDO_USB,
+			.owner          = THIS_MODULE,
+			.n_voltages     = 1,
+		},
+		.fixed_uV               = 3300000,
+		.update_bank            = 0x03,
+		.update_reg             = 0x82,
+		.update_mask            = 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+	},
+	[AB8505_LDO_AUDIO] = {
+		.desc = {
+			.name		= "LDO-AUDIO",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2000000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x02,
+		.update_val		= 0x02,
+	},
+	[AB8505_LDO_ANAMIC1] = {
+		.desc = {
+			.name		= "LDO-ANAMIC1",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x08,
+		.update_val		= 0x08,
+	},
+	[AB8505_LDO_ANAMIC2] = {
+		.desc = {
+			.name		= "LDO-ANAMIC2",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x10,
+		.update_val		= 0x10,
+	},
+	[AB8505_LDO_AUX8] = {
+		.desc = {
+			.name		= "LDO-AUX8",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8505_LDO_AUX8,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1800000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x04,
+		.update_val		= 0x04,
+	},
+	/*
+	 * Regulators with fixed voltage and normal/idle modes
+	 */
+	[AB8505_LDO_ANA] = {
+		.desc = {
+			.name		= "LDO-ANA",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANA,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1200000,
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x06,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
+	},
+};
+
 /* AB9540 regulator information */
 static struct ab8500_regulator_info
 		ab9540_regulator_info[AB9540_NUM_REGULATORS] = {
@@ -1021,6 +1342,276 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
 };
 
+/* AB8505 register init */
+static struct ab8500_reg_init ab8505_reg_init[] = {
+	/*
+	 * 0x03, VarmRequestCtrl
+	 * 0x0c, VsmpsCRequestCtrl
+	 * 0x30, VsmpsARequestCtrl
+	 * 0xc0, VsmpsBRequestCtrl
+	 */
+	REG_INIT(AB8505_REGUREQUESTCTRL1,	0x03, 0x03, 0xff),
+	/*
+	 * 0x03, VsafeRequestCtrl
+	 * 0x0c, VpllRequestCtrl
+	 * 0x30, VanaRequestCtrl
+	 */
+	REG_INIT(AB8505_REGUREQUESTCTRL2,	0x03, 0x04, 0x3f),
+	/*
+	 * 0x30, Vaux1RequestCtrl
+	 * 0xc0, Vaux2RequestCtrl
+	 */
+	REG_INIT(AB8505_REGUREQUESTCTRL3,	0x03, 0x05, 0xf0),
+	/*
+	 * 0x03, Vaux3RequestCtrl
+	 * 0x04, SwHPReq
+	 */
+	REG_INIT(AB8505_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
+	/*
+	 * 0x01, VsmpsASysClkReq1HPValid
+	 * 0x02, VsmpsBSysClkReq1HPValid
+	 * 0x04, VsafeSysClkReq1HPValid
+	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x10, VpllSysClkReq1HPValid
+	 * 0x20, Vaux1SysClkReq1HPValid
+	 * 0x40, Vaux2SysClkReq1HPValid
+	 * 0x80, Vaux3SysClkReq1HPValid
+	 */
+	REG_INIT(AB8505_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
+	/*
+	 * 0x01, VsmpsCSysClkReq1HPValid
+	 * 0x02, VarmSysClkReq1HPValid
+	 * 0x04, VbbSysClkReq1HPValid
+	 * 0x08, VsmpsMSysClkReq1HPValid
+	 */
+	REG_INIT(AB8505_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x0f),
+	/*
+	 * 0x01, VsmpsAHwHPReq1Valid
+	 * 0x02, VsmpsBHwHPReq1Valid
+	 * 0x04, VsafeHwHPReq1Valid
+	 * 0x08, VanaHwHPReq1Valid
+	 * 0x10, VpllHwHPReq1Valid
+	 * 0x20, Vaux1HwHPReq1Valid
+	 * 0x40, Vaux2HwHPReq1Valid
+	 * 0x80, Vaux3HwHPReq1Valid
+	 */
+	REG_INIT(AB8505_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xff),
+	/*
+	 * 0x08, VsmpsMHwHPReq1Valid
+	 */
+	REG_INIT(AB8505_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x08),
+	/*
+	 * 0x01, VsmpsAHwHPReq2Valid
+	 * 0x02, VsmpsBHwHPReq2Valid
+	 * 0x04, VsafeHwHPReq2Valid
+	 * 0x08, VanaHwHPReq2Valid
+	 * 0x10, VpllHwHPReq2Valid
+	 * 0x20, Vaux1HwHPReq2Valid
+	 * 0x40, Vaux2HwHPReq2Valid
+	 * 0x80, Vaux3HwHPReq2Valid
+	 */
+	REG_INIT(AB8505_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xff),
+	/*
+	 * 0x08, VsmpsMHwHPReq2Valid
+	 */
+	REG_INIT(AB8505_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x08),
+	/*
+	 * 0x01, VsmpsCSwHPReqValid
+	 * 0x02, VarmSwHPReqValid
+	 * 0x04, VsmpsASwHPReqValid
+	 * 0x08, VsmpsBSwHPReqValid
+	 * 0x10, VsafeSwHPReqValid
+	 * 0x20, VanaSwHPReqValid
+	 * 0x40, VpllSwHPReqValid
+	 * 0x80, Vaux1SwHPReqValid
+	 */
+	REG_INIT(AB8505_REGUSWHPREQVALID1,	0x03, 0x0d, 0xff),
+	/*
+	 * 0x01, Vaux2SwHPReqValid
+	 * 0x02, Vaux3SwHPReqValid
+	 * 0x20, VsmpsMSwHPReqValid
+	 */
+	REG_INIT(AB8505_REGUSWHPREQVALID2,	0x03, 0x0e, 0x23),
+	/*
+	 * 0x02, SysClkReq2Valid1
+	 * 0x04, SysClkReq3Valid1
+	 * 0x08, SysClkReq4Valid1
+	 */
+	REG_INIT(AB8505_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0x0e),
+	/*
+	 * 0x02, SysClkReq2Valid2
+	 * 0x04, SysClkReq3Valid2
+	 * 0x08, SysClkReq4Valid2
+	 */
+	REG_INIT(AB8505_REGUSYSCLKREQVALID2,	0x03, 0x10, 0x0e),
+	/*
+	 * 0x01, Vaux4SwHPReqValid
+	 * 0x02, Vaux4HwHPReq2Valid
+	 * 0x04, Vaux4HwHPReq1Valid
+	 * 0x08, Vaux4SysClkReq1HPValid
+	 */
+	REG_INIT(AB8505_REGUVAUX4REQVALID,	0x03, 0x11, 0x0f),
+	/*
+	 * 0x02, VadcEna
+	 * 0x04, VintCore12Ena
+	 * 0x38, VintCore12Sel
+	 * 0x40, VintCore12LP
+	 * 0x80, VadcLP
+	 */
+	REG_INIT(AB8505_REGUMISC1,		0x03, 0x80, 0xfe),
+	/*
+	 * 0x02, VaudioEna
+	 * 0x04, VdmicEna
+	 * 0x08, Vamic1Ena
+	 * 0x10, Vamic2Ena
+	 */
+	REG_INIT(AB8505_VAUDIOSUPPLY,		0x03, 0x83, 0x1e),
+	/*
+	 * 0x01, Vamic1_dzout
+	 * 0x02, Vamic2_dzout
+	 */
+	REG_INIT(AB8505_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
+	/*
+	 * 0x03, VsmpsARegu
+	 * 0x0c, VsmpsASelCtrl
+	 * 0x10, VsmpsAAutoMode
+	 * 0x20, VsmpsAPWMMode
+	 */
+	REG_INIT(AB8505_VSMPSAREGU,		0x04, 0x03, 0x3f),
+	/*
+	 * 0x03, VsmpsBRegu
+	 * 0x0c, VsmpsBSelCtrl
+	 * 0x10, VsmpsBAutoMode
+	 * 0x20, VsmpsBPWMMode
+	 */
+	REG_INIT(AB8505_VSMPSBREGU,		0x04, 0x04, 0x3f),
+	/*
+	 * 0x03, VsafeRegu
+	 * 0x0c, VsafeSelCtrl
+	 * 0x10, VsafeAutoMode
+	 * 0x20, VsafePWMMode
+	 */
+	REG_INIT(AB8505_VSAFEREGU,		0x04, 0x05, 0x3f),
+	/*
+	 * 0x03, VpllRegu (NOTE! PRCMU register bits)
+	 * 0x0c, VanaRegu
+	 */
+	REG_INIT(AB8505_VPLLVANAREGU,		0x04, 0x06, 0x0f),
+	/*
+	 * 0x03, VextSupply1Regu
+	 * 0x0c, VextSupply2Regu
+	 * 0x30, VextSupply3Regu
+	 * 0x40, ExtSupply2Bypass
+	 * 0x80, ExtSupply3Bypass
+	 */
+	REG_INIT(AB8505_EXTSUPPLYREGU,		0x04, 0x08, 0xff),
+	/*
+	 * 0x03, Vaux1Regu
+	 * 0x0c, Vaux2Regu
+	 */
+	REG_INIT(AB8505_VAUX12REGU,		0x04, 0x09, 0x0f),
+	/*
+	 * 0x0f, Vaux3Regu
+	 */
+	REG_INIT(AB8505_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
+	/*
+	 * 0x3f, VsmpsASel1
+	 */
+	REG_INIT(AB8505_VSMPSASEL1,		0x04, 0x13, 0x3f),
+	/*
+	 * 0x3f, VsmpsASel2
+	 */
+	REG_INIT(AB8505_VSMPSASEL2,		0x04, 0x14, 0x3f),
+	/*
+	 * 0x3f, VsmpsASel3
+	 */
+	REG_INIT(AB8505_VSMPSASEL3,		0x04, 0x15, 0x3f),
+	/*
+	 * 0x3f, VsmpsBSel1
+	 */
+	REG_INIT(AB8505_VSMPSBSEL1,		0x04, 0x17, 0x3f),
+	/*
+	 * 0x3f, VsmpsBSel2
+	 */
+	REG_INIT(AB8505_VSMPSBSEL2,		0x04, 0x18, 0x3f),
+	/*
+	 * 0x3f, VsmpsBSel3
+	 */
+	REG_INIT(AB8505_VSMPSBSEL3,		0x04, 0x19, 0x3f),
+	/*
+	 * 0x7f, VsafeSel1
+	 */
+	REG_INIT(AB8505_VSAFESEL1,		0x04, 0x1b, 0x7f),
+	/*
+	 * 0x3f, VsafeSel2
+	 */
+	REG_INIT(AB8505_VSAFESEL2,		0x04, 0x1c, 0x7f),
+	/*
+	 * 0x3f, VsafeSel3
+	 */
+	REG_INIT(AB8505_VSAFESEL3,		0x04, 0x1d, 0x7f),
+	/*
+	 * 0x0f, Vaux1Sel
+	 */
+	REG_INIT(AB8505_VAUX1SEL,		0x04, 0x1f, 0x0f),
+	/*
+	 * 0x0f, Vaux2Sel
+	 */
+	REG_INIT(AB8505_VAUX2SEL,		0x04, 0x20, 0x0f),
+	/*
+	 * 0x07, Vaux3Sel
+	 * 0x30, VRF1Sel
+	 */
+	REG_INIT(AB8505_VRF1VAUX3SEL,		0x04, 0x21, 0x37),
+	/*
+	 * 0x03, Vaux4RequestCtrl
+	 */
+	REG_INIT(AB8505_VAUX4REQCTRL,		0x04, 0x2d, 0x03),
+	/*
+	 * 0x03, Vaux4Regu
+	 */
+	REG_INIT(AB8505_VAUX4REGU,		0x04, 0x2e, 0x03),
+	/*
+	 * 0x0f, Vaux4Sel
+	 */
+	REG_INIT(AB8505_VAUX4SEL,		0x04, 0x2f, 0x0f),
+	/*
+	 * 0x04, Vaux1Disch
+	 * 0x08, Vaux2Disch
+	 * 0x10, Vaux3Disch
+	 * 0x20, Vintcore12Disch
+	 * 0x40, VTVoutDisch
+	 * 0x80, VaudioDisch
+	 */
+	REG_INIT(AB8505_REGUCTRLDISCH,		0x04, 0x43, 0xfc),
+	/*
+	 * 0x02, VanaDisch
+	 * 0x04, VdmicPullDownEna
+	 * 0x10, VdmicDisch
+	 */
+	REG_INIT(AB8505_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
+	/*
+	 * 0x01, Vaux4Disch
+	 */
+	REG_INIT(AB8505_REGUCTRLDISCH3,		0x04, 0x48, 0x01),
+	/*
+	 * 0x07, Vaux5Sel
+	 * 0x08, Vaux5LP
+	 * 0x10, Vaux5Ena
+	 * 0x20, Vaux5Disch
+	 * 0x40, Vaux5DisSfst
+	 * 0x80, Vaux5DisPulld
+	 */
+	REG_INIT(AB8505_CTRLVAUX5,		0x01, 0x55, 0xff),
+	/*
+	 * 0x07, Vaux6Sel
+	 * 0x08, Vaux6LP
+	 * 0x10, Vaux6Ena
+	 * 0x80, Vaux6DisPulld
+	 */
+	REG_INIT(AB8505_CTRLVAUX6,		0x01, 0x56, 0x9f),
+};
+
 /* AB9540 register init */
 static struct ab8500_reg_init ab9540_reg_init[] = {
 	/*
@@ -1386,6 +1977,22 @@ static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8500_LDO_ANA, },
 };
 
+static struct of_regulator_match ab8505_regulator_match[] = {
+	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8505_LDO_AUX1, },
+	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8505_LDO_AUX2, },
+	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8505_LDO_AUX3, },
+	{ .name	= "ab8500_ldo_aux4",    .driver_data = (void *) AB8505_LDO_AUX4, },
+	{ .name	= "ab8500_ldo_aux5",    .driver_data = (void *) AB8505_LDO_AUX5, },
+	{ .name	= "ab8500_ldo_aux6",    .driver_data = (void *) AB8505_LDO_AUX6, },
+	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8505_LDO_INTCORE, },
+	{ .name	= "ab8500_ldo_adc",	.driver_data = (void *) AB8505_LDO_ADC, },
+	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8505_LDO_AUDIO, },
+	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8505_LDO_ANAMIC1, },
+	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8505_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_aux8",    .driver_data = (void *) AB8505_LDO_AUX8, },
+	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8505_LDO_ANA, },
+};
+
 static struct of_regulator_match ab9540_regulator_match[] = {
 	{ .name = "ab9540_ldo_aux1",    .driver_data = (void *) AB9540_LDO_AUX1, },
 	{ .name = "ab9540_ldo_aux2",    .driver_data = (void *) AB9540_LDO_AUX2, },
@@ -1440,6 +2047,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
 		match = ab9540_regulator_match;
 		match_size = ARRAY_SIZE(ab9540_regulator_match)
+	} else if (is_ab8505(ab8500)) {
+		regulator_info = ab8505_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
+		reg_init = ab8505_reg_init;
+		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
@@ -1533,6 +2145,9 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 	if (is_ab9540(ab8500)) {
 		regulator_info = ab9540_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
+	} else if (is_ab8505(ab8500)) {
+		regulator_info = ab8505_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
@@ -1591,5 +2206,6 @@ module_exit(ab8500_regulator_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sundar Iyer <sundar.iyer@stericsson.com>");
 MODULE_AUTHOR("Bengt Jonsson <bengt.g.jonsson@stericsson.com>");
+MODULE_AUTHOR("Daniel Willerud <daniel.willerud@stericsson.com>");
 MODULE_DESCRIPTION("Regulator Driver for ST-Ericsson AB8500 Mixed-Sig PMIC");
 MODULE_ALIAS("platform:ab8500-regulator");
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 592a3f3..9a7cf97 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -5,6 +5,7 @@
  *
  * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
  *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *          Daniel Willerud <daniel.willerud@stericsson.com> for ST-Ericsson
  */
 
 #ifndef __LINUX_MFD_AB8500_REGULATOR_H
@@ -27,7 +28,28 @@ enum ab8500_regulator_id {
 	AB8500_NUM_REGULATORS,
 };
 
-/* AB9450 regulators */
+/* AB8505 regulators */
+enum ab8505_regulator_id {
+	AB8505_LDO_AUX1,
+	AB8505_LDO_AUX2,
+	AB8505_LDO_AUX3,
+	AB8505_LDO_AUX4,
+	AB8505_LDO_AUX5,
+	AB8505_LDO_AUX6,
+	AB8505_LDO_INTCORE,
+	AB8505_LDO_ADC,
+	AB8505_LDO_USB,
+	AB8505_LDO_AUDIO,
+	AB8505_LDO_ANAMIC1,
+	AB8505_LDO_ANAMIC2,
+	AB8505_LDO_AUX8,
+	AB8505_LDO_ANA,
+	AB8505_SYSCLKREQ_2,
+	AB8505_SYSCLKREQ_4,
+	AB8505_NUM_REGULATORS,
+};
+
+/* AB9540 regulators */
 enum ab9540_regulator_id {
 	AB9540_LDO_AUX1,
 	AB9540_LDO_AUX2,
@@ -46,7 +68,7 @@ enum ab9540_regulator_id {
 	AB9540_NUM_REGULATORS,
 };
 
-/* AB8500 and AB9540 register initialization */
+/* AB8500, AB8505, and AB9540 register initialization */
 struct ab8500_regulator_reg_init {
 	int id;
 	u8 mask;
@@ -92,6 +114,55 @@ enum ab8500_regulator_reg {
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
 
+/* AB8505 registers */
+enum ab8505_regulator_reg {
+	AB8505_REGUREQUESTCTRL1,
+	AB8505_REGUREQUESTCTRL2,
+	AB8505_REGUREQUESTCTRL3,
+	AB8505_REGUREQUESTCTRL4,
+	AB8505_REGUSYSCLKREQ1HPVALID1,
+	AB8505_REGUSYSCLKREQ1HPVALID2,
+	AB8505_REGUHWHPREQ1VALID1,
+	AB8505_REGUHWHPREQ1VALID2,
+	AB8505_REGUHWHPREQ2VALID1,
+	AB8505_REGUHWHPREQ2VALID2,
+	AB8505_REGUSWHPREQVALID1,
+	AB8505_REGUSWHPREQVALID2,
+	AB8505_REGUSYSCLKREQVALID1,
+	AB8505_REGUSYSCLKREQVALID2,
+	AB8505_REGUVAUX4REQVALID,
+	AB8505_REGUMISC1,
+	AB8505_VAUDIOSUPPLY,
+	AB8505_REGUCTRL1VAMIC,
+	AB8505_VSMPSAREGU,
+	AB8505_VSMPSBREGU,
+	AB8505_VSAFEREGU, /* NOTE! PRCMU register */
+	AB8505_VPLLVANAREGU,
+	AB8505_EXTSUPPLYREGU,
+	AB8505_VAUX12REGU,
+	AB8505_VRF1VAUX3REGU,
+	AB8505_VSMPSASEL1,
+	AB8505_VSMPSASEL2,
+	AB8505_VSMPSASEL3,
+	AB8505_VSMPSBSEL1,
+	AB8505_VSMPSBSEL2,
+	AB8505_VSMPSBSEL3,
+	AB8505_VSAFESEL1, /* NOTE! PRCMU register */
+	AB8505_VSAFESEL2, /* NOTE! PRCMU register */
+	AB8505_VSAFESEL3, /* NOTE! PRCMU register */
+	AB8505_VAUX1SEL,
+	AB8505_VAUX2SEL,
+	AB8505_VRF1VAUX3SEL,
+	AB8505_VAUX4REQCTRL,
+	AB8505_VAUX4REGU,
+	AB8505_VAUX4SEL,
+	AB8505_REGUCTRLDISCH,
+	AB8505_REGUCTRLDISCH2,
+	AB8505_REGUCTRLDISCH3,
+	AB8505_CTRLVAUX5,
+	AB8505_CTRLVAUX6,
+	AB8505_NUM_REGULATOR_REGISTERS,
+};
 
 /* AB9540 registers */
 enum ab9540_regulator_reg {
-- 
1.7.9.5

