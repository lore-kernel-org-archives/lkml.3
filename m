Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3JDAbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:31:49 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1652 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3JDAap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:30:45 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>
cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        "Sherman Yin" <syin@broadcom.com>
Subject: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Date: Thu, 3 Oct 2013 17:23:18 -0700
Message-ID: <1380846199-12829-4-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380846199-12829-1-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E50D3AD2L891410615-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/mach-bcm/Kconfig       |    2 +
 drivers/pinctrl/Kconfig         |   10 +
 drivers/pinctrl/Makefile        |    1 +
 drivers/pinctrl/pinctrl-capri.c | 1727 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 1740 insertions(+)
 create mode 100644 drivers/pinctrl/pinctrl-capri.c

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 69d67f7..2546365 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -10,6 +10,8 @@ config ARCH_BCM
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_TIME
 	select GPIO_BCM
+	select PINCTRL
+	select PINCTRL_CAPRI
 	select SPARSE_IRQ
 	select TICK_ONESHOT
 	select CACHE_L2X0
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index b6e864e..f97eb11 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -75,6 +75,16 @@ config PINCTRL_BCM2835
 	select PINMUX
 	select PINCONF
 
+config PINCTRL_CAPRI
+	bool "Broadcom Capri pinctrl driver"
+	select PINMUX
+	select PINCONF
+	help
+	  Say Y here to support Broadcom Capri pinctrl driver, which is used for
+	  the BCM281xx SoC family, including BCM11130, BCM11140, BCM11351,
+	  BCM28145, and BCM28155 SoCs.  This driver requires the pinctrl
+	  framework.  GPIO is provided by a separate GPIO driver.
+
 config PINCTRL_IMX
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 496d9bf..5e1a68e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_PINCTRL_AB8505)	+= pinctrl-ab8505.o
 obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
+obj-$(CONFIG_PINCTRL_CAPRI)	+= pinctrl-capri.o
 obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
 obj-$(CONFIG_PINCTRL_IMX35)	+= pinctrl-imx35.o
 obj-$(CONFIG_PINCTRL_IMX51)	+= pinctrl-imx51.o
diff --git a/drivers/pinctrl/pinctrl-capri.c b/drivers/pinctrl/pinctrl-capri.c
new file mode 100644
index 0000000..2a4dcf1
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-capri.c
@@ -0,0 +1,1727 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/slab.h>
+#include "core.h"
+
+#define CAPRI_PINCONF_PACK(val, mask)     (((val) << 16) | ((mask) & 0xffff))
+#define CAPRI_PINCONF_UNPACK_VAL(conf)    ((conf) >> 16)
+#define CAPRI_PINCONF_UNPACK_MASK(conf)   ((conf) & 0xffff)
+
+enum capri_pinconf_param {
+	CAPRI_PINCONF_PARAM_NONE = 0,
+	CAPRI_PINCONF_PARAM_HYST,
+	CAPRI_PINCONF_PARAM_PULL,
+	CAPRI_PINCONF_PARAM_SLEW,
+	CAPRI_PINCONF_PARAM_INPUT_DIS,
+	CAPRI_PINCONF_PARAM_DRV_STR,
+	CAPRI_PINCONF_PARAM_PULL_UP_STR,
+	CAPRI_PINCONF_PARAM_MODE,
+};
+
+struct capri_cfg_param {
+	const char *property;
+	enum capri_pinconf_param id;
+};
+
+static const struct capri_cfg_param capri_pinconf_params[] = {
+	{"brcm,hysteresis",	CAPRI_PINCONF_PARAM_HYST},
+	{"brcm,pull",		CAPRI_PINCONF_PARAM_PULL},
+	{"brcm,slew",		CAPRI_PINCONF_PARAM_SLEW},
+	{"brcm,input_dis",	CAPRI_PINCONF_PARAM_INPUT_DIS},
+	{"brcm,drive_str",	CAPRI_PINCONF_PARAM_DRV_STR},
+	{"brcm,pull_up_str",	CAPRI_PINCONF_PARAM_PULL_UP_STR},
+	{"brcm,mode",		CAPRI_PINCONF_PARAM_MODE},
+};
+
+/* Capri Pin Control Registers Definitions */
+
+/* Functionn Select bits are the same for all pin control registers */
+#define CAPRI_PIN_REG_F_SEL_MASK		0x0700
+#define CAPRI_PIN_REG_F_SEL_SHIFT		8
+
+/* Standard pin register */
+#define CAPRI_STD_PIN_REG_DRV_STR_MASK		0x0007
+#define CAPRI_STD_PIN_REG_DRV_STR_SHIFT		0
+#define CAPRI_STD_PIN_REG_INPUT_DIS_MASK	0x0008
+#define CAPRI_STD_PIN_REG_INPUT_DIS_SHIFT	3
+#define CAPRI_STD_PIN_REG_SLEW_MASK		0x0010
+#define CAPRI_STD_PIN_REG_SLEW_SHIFT		4
+#define CAPRI_STD_PIN_REG_PULL_MASK		0x0060
+#define CAPRI_STD_PIN_REG_PULL_SHIFT		5
+#define CAPRI_STD_PIN_REG_HYST_MASK		0x0080
+#define CAPRI_STD_PIN_REG_HYST_SHIFT		7
+
+/* I2C pin register */
+#define CAPRI_I2C_PIN_REG_INPUT_DIS_MASK	0x0004
+#define CAPRI_I2C_PIN_REG_INPUT_DIS_SHIFT	2
+#define CAPRI_I2C_PIN_REG_SLEW_MASK		0x0008
+#define CAPRI_I2C_PIN_REG_SLEW_SHIFT		3
+#define CAPRI_I2C_PIN_REG_PULL_UP_STR_MASK	0x0070
+#define CAPRI_I2C_PIN_REG_PULL_UP_STR_SHIFT	4
+
+/* HDMI pin register */
+#define CAPRI_HDMI_PIN_REG_INPUT_DIS_MASK	0x0008
+#define CAPRI_HDMI_PIN_REG_INPUT_DIS_SHIFT	3
+#define CAPRI_HDMI_PIN_REG_MODE_MASK		0x0010
+#define CAPRI_HDMI_PIN_REG_MODE_SHIFT		4
+
+/* Macro to update reg with new pin config param */
+#define CAPRI_PIN_REG_SET(reg, type, param, val)			\
+	(((reg) & ~CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK)	\
+	| (((val) << CAPRI_ ## type ## _PIN_REG_ ## param ## _SHIFT)	\
+	& CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK))
+
+/**
+ * capri_pin_type - types of pin register
+ */
+enum capri_pin_type {
+	CAPRI_PIN_TYPE_UNKNOWN = 0,
+	CAPRI_PIN_TYPE_STD,
+	CAPRI_PIN_TYPE_I2C,
+	CAPRI_PIN_TYPE_HDMI,
+};
+
+static enum capri_pin_type std_pin = CAPRI_PIN_TYPE_STD;
+static enum capri_pin_type i2c_pin = CAPRI_PIN_TYPE_I2C;
+static enum capri_pin_type hdmi_pin = CAPRI_PIN_TYPE_HDMI;
+
+/**
+ * capri_pin_function- define pin function
+ */
+struct capri_pin_function {
+	const char *name;
+	const char * const *groups;
+	const unsigned ngroups;
+};
+
+/**
+ * capri_pinctrl_data - Broadcom-specific pinctrl data
+ * @reg_base - base of pinctrl registers
+ */
+struct capri_pinctrl_data {
+	void __iomem *reg_base;
+
+	/* List of all pins */
+	const struct pinctrl_pin_desc *pins;
+	const unsigned npins;
+
+	const struct capri_pin_function *functions;
+	const unsigned nfunctions;
+};
+
+#define _PIN(offset)			(offset)
+
+/*
+ * Pin number definition.  The order here must be the same as defined in the
+ * PADCTRLREG block in the RDB.
+ */
+#define CAPRI_PIN_ADCSYNC		_PIN(0)
+#define CAPRI_PIN_BAT_RM		_PIN(1)
+#define CAPRI_PIN_BSC1_SCL		_PIN(2)
+#define CAPRI_PIN_BSC1_SDA		_PIN(3)
+#define CAPRI_PIN_BSC2_SCL		_PIN(4)
+#define CAPRI_PIN_BSC2_SDA		_PIN(5)
+#define CAPRI_PIN_CLASSGPWR		_PIN(6)
+#define CAPRI_PIN_CLK_CX8		_PIN(7)
+#define CAPRI_PIN_CLKOUT_0		_PIN(8)
+#define CAPRI_PIN_CLKOUT_1		_PIN(9)
+#define CAPRI_PIN_CLKOUT_2		_PIN(10)
+#define CAPRI_PIN_CLKOUT_3		_PIN(11)
+#define CAPRI_PIN_CLKREQ_IN_0		_PIN(12)
+#define CAPRI_PIN_CLKREQ_IN_1		_PIN(13)
+#define CAPRI_PIN_CWS_SYS_REQ1		_PIN(14)
+#define CAPRI_PIN_CWS_SYS_REQ2		_PIN(15)
+#define CAPRI_PIN_CWS_SYS_REQ3		_PIN(16)
+#define CAPRI_PIN_DIGMIC1_CLK		_PIN(17)
+#define CAPRI_PIN_DIGMIC1_DQ		_PIN(18)
+#define CAPRI_PIN_DIGMIC2_CLK		_PIN(19)
+#define CAPRI_PIN_DIGMIC2_DQ		_PIN(20)
+#define CAPRI_PIN_GPEN13		_PIN(21)
+#define CAPRI_PIN_GPEN14		_PIN(22)
+#define CAPRI_PIN_GPEN15		_PIN(23)
+#define CAPRI_PIN_GPIO00		_PIN(24)
+#define CAPRI_PIN_GPIO01		_PIN(25)
+#define CAPRI_PIN_GPIO02		_PIN(26)
+#define CAPRI_PIN_GPIO03		_PIN(27)
+#define CAPRI_PIN_GPIO04		_PIN(28)
+#define CAPRI_PIN_GPIO05		_PIN(29)
+#define CAPRI_PIN_GPIO06		_PIN(30)
+#define CAPRI_PIN_GPIO07		_PIN(31)
+#define CAPRI_PIN_GPIO08		_PIN(32)
+#define CAPRI_PIN_GPIO09		_PIN(33)
+#define CAPRI_PIN_GPIO10		_PIN(34)
+#define CAPRI_PIN_GPIO11		_PIN(35)
+#define CAPRI_PIN_GPIO12		_PIN(36)
+#define CAPRI_PIN_GPIO13		_PIN(37)
+#define CAPRI_PIN_GPIO14		_PIN(38)
+#define CAPRI_PIN_GPS_PABLANK		_PIN(39)
+#define CAPRI_PIN_GPS_TMARK		_PIN(40)
+#define CAPRI_PIN_HDMI_SCL		_PIN(41)
+#define CAPRI_PIN_HDMI_SDA		_PIN(42)
+#define CAPRI_PIN_IC_DM			_PIN(43)
+#define CAPRI_PIN_IC_DP			_PIN(44)
+#define CAPRI_PIN_KP_COL_IP_0		_PIN(45)
+#define CAPRI_PIN_KP_COL_IP_1		_PIN(46)
+#define CAPRI_PIN_KP_COL_IP_2		_PIN(47)
+#define CAPRI_PIN_KP_COL_IP_3		_PIN(48)
+#define CAPRI_PIN_KP_ROW_OP_0		_PIN(49)
+#define CAPRI_PIN_KP_ROW_OP_1		_PIN(50)
+#define CAPRI_PIN_KP_ROW_OP_2		_PIN(51)
+#define CAPRI_PIN_KP_ROW_OP_3		_PIN(52)
+#define CAPRI_PIN_LCD_B_0		_PIN(53)
+#define CAPRI_PIN_LCD_B_1		_PIN(54)
+#define CAPRI_PIN_LCD_B_2		_PIN(55)
+#define CAPRI_PIN_LCD_B_3		_PIN(56)
+#define CAPRI_PIN_LCD_B_4		_PIN(57)
+#define CAPRI_PIN_LCD_B_5		_PIN(58)
+#define CAPRI_PIN_LCD_B_6		_PIN(59)
+#define CAPRI_PIN_LCD_B_7		_PIN(60)
+#define CAPRI_PIN_LCD_G_0		_PIN(61)
+#define CAPRI_PIN_LCD_G_1		_PIN(62)
+#define CAPRI_PIN_LCD_G_2		_PIN(63)
+#define CAPRI_PIN_LCD_G_3		_PIN(64)
+#define CAPRI_PIN_LCD_G_4		_PIN(65)
+#define CAPRI_PIN_LCD_G_5		_PIN(66)
+#define CAPRI_PIN_LCD_G_6		_PIN(67)
+#define CAPRI_PIN_LCD_G_7		_PIN(68)
+#define CAPRI_PIN_LCD_HSYNC		_PIN(69)
+#define CAPRI_PIN_LCD_OE		_PIN(70)
+#define CAPRI_PIN_LCD_PCLK		_PIN(71)
+#define CAPRI_PIN_LCD_R_0		_PIN(72)
+#define CAPRI_PIN_LCD_R_1		_PIN(73)
+#define CAPRI_PIN_LCD_R_2		_PIN(74)
+#define CAPRI_PIN_LCD_R_3		_PIN(75)
+#define CAPRI_PIN_LCD_R_4		_PIN(76)
+#define CAPRI_PIN_LCD_R_5		_PIN(77)
+#define CAPRI_PIN_LCD_R_6		_PIN(78)
+#define CAPRI_PIN_LCD_R_7		_PIN(79)
+#define CAPRI_PIN_LCD_VSYNC		_PIN(80)
+#define CAPRI_PIN_MDMGPIO0		_PIN(81)
+#define CAPRI_PIN_MDMGPIO1		_PIN(82)
+#define CAPRI_PIN_MDMGPIO2		_PIN(83)
+#define CAPRI_PIN_MDMGPIO3		_PIN(84)
+#define CAPRI_PIN_MDMGPIO4		_PIN(85)
+#define CAPRI_PIN_MDMGPIO5		_PIN(86)
+#define CAPRI_PIN_MDMGPIO6		_PIN(87)
+#define CAPRI_PIN_MDMGPIO7		_PIN(88)
+#define CAPRI_PIN_MDMGPIO8		_PIN(89)
+#define CAPRI_PIN_MPHI_DATA_0		_PIN(90)
+#define CAPRI_PIN_MPHI_DATA_1		_PIN(91)
+#define CAPRI_PIN_MPHI_DATA_2		_PIN(92)
+#define CAPRI_PIN_MPHI_DATA_3		_PIN(93)
+#define CAPRI_PIN_MPHI_DATA_4		_PIN(94)
+#define CAPRI_PIN_MPHI_DATA_5		_PIN(95)
+#define CAPRI_PIN_MPHI_DATA_6		_PIN(96)
+#define CAPRI_PIN_MPHI_DATA_7		_PIN(97)
+#define CAPRI_PIN_MPHI_DATA_8		_PIN(98)
+#define CAPRI_PIN_MPHI_DATA_9		_PIN(99)
+#define CAPRI_PIN_MPHI_DATA_10		_PIN(100)
+#define CAPRI_PIN_MPHI_DATA_11		_PIN(101)
+#define CAPRI_PIN_MPHI_DATA_12		_PIN(102)
+#define CAPRI_PIN_MPHI_DATA_13		_PIN(103)
+#define CAPRI_PIN_MPHI_DATA_14		_PIN(104)
+#define CAPRI_PIN_MPHI_DATA_15		_PIN(105)
+#define CAPRI_PIN_MPHI_HA0		_PIN(106)
+#define CAPRI_PIN_MPHI_HAT0		_PIN(107)
+#define CAPRI_PIN_MPHI_HAT1		_PIN(108)
+#define CAPRI_PIN_MPHI_HCE0_N		_PIN(109)
+#define CAPRI_PIN_MPHI_HCE1_N		_PIN(110)
+#define CAPRI_PIN_MPHI_HRD_N		_PIN(111)
+#define CAPRI_PIN_MPHI_HWR_N		_PIN(112)
+#define CAPRI_PIN_MPHI_RUN0		_PIN(113)
+#define CAPRI_PIN_MPHI_RUN1		_PIN(114)
+#define CAPRI_PIN_MTX_SCAN_CLK		_PIN(115)
+#define CAPRI_PIN_MTX_SCAN_DATA		_PIN(116)
+#define CAPRI_PIN_NAND_AD_0		_PIN(117)
+#define CAPRI_PIN_NAND_AD_1		_PIN(118)
+#define CAPRI_PIN_NAND_AD_2		_PIN(119)
+#define CAPRI_PIN_NAND_AD_3		_PIN(120)
+#define CAPRI_PIN_NAND_AD_4		_PIN(121)
+#define CAPRI_PIN_NAND_AD_5		_PIN(122)
+#define CAPRI_PIN_NAND_AD_6		_PIN(123)
+#define CAPRI_PIN_NAND_AD_7		_PIN(124)
+#define CAPRI_PIN_NAND_ALE		_PIN(125)
+#define CAPRI_PIN_NAND_CEN_0		_PIN(126)
+#define CAPRI_PIN_NAND_CEN_1		_PIN(127)
+#define CAPRI_PIN_NAND_CLE		_PIN(128)
+#define CAPRI_PIN_NAND_OEN		_PIN(129)
+#define CAPRI_PIN_NAND_RDY_0		_PIN(130)
+#define CAPRI_PIN_NAND_RDY_1		_PIN(131)
+#define CAPRI_PIN_NAND_WEN		_PIN(132)
+#define CAPRI_PIN_NAND_WP		_PIN(133)
+#define CAPRI_PIN_PC1			_PIN(134)
+#define CAPRI_PIN_PC2			_PIN(135)
+#define CAPRI_PIN_PMU_INT		_PIN(136)
+#define CAPRI_PIN_PMU_SCL		_PIN(137)
+#define CAPRI_PIN_PMU_SDA		_PIN(138)
+#define CAPRI_PIN_RFST2G_MTSLOTEN3G	_PIN(139)
+#define CAPRI_PIN_RGMII_0_RX_CTL	_PIN(140)
+#define CAPRI_PIN_RGMII_0_RXC		_PIN(141)
+#define CAPRI_PIN_RGMII_0_RXD_0		_PIN(142)
+#define CAPRI_PIN_RGMII_0_RXD_1		_PIN(143)
+#define CAPRI_PIN_RGMII_0_RXD_2		_PIN(144)
+#define CAPRI_PIN_RGMII_0_RXD_3		_PIN(145)
+#define CAPRI_PIN_RGMII_0_TX_CTL	_PIN(146)
+#define CAPRI_PIN_RGMII_0_TXC		_PIN(147)
+#define CAPRI_PIN_RGMII_0_TXD_0		_PIN(148)
+#define CAPRI_PIN_RGMII_0_TXD_1		_PIN(149)
+#define CAPRI_PIN_RGMII_0_TXD_2		_PIN(150)
+#define CAPRI_PIN_RGMII_0_TXD_3		_PIN(151)
+#define CAPRI_PIN_RGMII_1_RX_CTL	_PIN(152)
+#define CAPRI_PIN_RGMII_1_RXC		_PIN(153)
+#define CAPRI_PIN_RGMII_1_RXD_0		_PIN(154)
+#define CAPRI_PIN_RGMII_1_RXD_1		_PIN(155)
+#define CAPRI_PIN_RGMII_1_RXD_2		_PIN(156)
+#define CAPRI_PIN_RGMII_1_RXD_3		_PIN(157)
+#define CAPRI_PIN_RGMII_1_TX_CTL	_PIN(158)
+#define CAPRI_PIN_RGMII_1_TXC		_PIN(159)
+#define CAPRI_PIN_RGMII_1_TXD_0		_PIN(160)
+#define CAPRI_PIN_RGMII_1_TXD_1		_PIN(161)
+#define CAPRI_PIN_RGMII_1_TXD_2		_PIN(162)
+#define CAPRI_PIN_RGMII_1_TXD_3		_PIN(163)
+#define CAPRI_PIN_RGMII_GPIO_0		_PIN(164)
+#define CAPRI_PIN_RGMII_GPIO_1		_PIN(165)
+#define CAPRI_PIN_RGMII_GPIO_2		_PIN(166)
+#define CAPRI_PIN_RGMII_GPIO_3		_PIN(167)
+#define CAPRI_PIN_RTXDATA2G_TXDATA3G1	_PIN(168)
+#define CAPRI_PIN_RTXEN2G_TXDATA3G2	_PIN(169)
+#define CAPRI_PIN_RXDATA3G0		_PIN(170)
+#define CAPRI_PIN_RXDATA3G1		_PIN(171)
+#define CAPRI_PIN_RXDATA3G2		_PIN(172)
+#define CAPRI_PIN_SDIO1_CLK		_PIN(173)
+#define CAPRI_PIN_SDIO1_CMD		_PIN(174)
+#define CAPRI_PIN_SDIO1_DATA_0		_PIN(175)
+#define CAPRI_PIN_SDIO1_DATA_1		_PIN(176)
+#define CAPRI_PIN_SDIO1_DATA_2		_PIN(177)
+#define CAPRI_PIN_SDIO1_DATA_3		_PIN(178)
+#define CAPRI_PIN_SDIO4_CLK		_PIN(179)
+#define CAPRI_PIN_SDIO4_CMD		_PIN(180)
+#define CAPRI_PIN_SDIO4_DATA_0		_PIN(181)
+#define CAPRI_PIN_SDIO4_DATA_1		_PIN(182)
+#define CAPRI_PIN_SDIO4_DATA_2		_PIN(183)
+#define CAPRI_PIN_SDIO4_DATA_3		_PIN(184)
+#define CAPRI_PIN_SIM_CLK		_PIN(185)
+#define CAPRI_PIN_SIM_DATA		_PIN(186)
+#define CAPRI_PIN_SIM_DET		_PIN(187)
+#define CAPRI_PIN_SIM_RESETN		_PIN(188)
+#define CAPRI_PIN_SIM2_CLK		_PIN(189)
+#define CAPRI_PIN_SIM2_DATA		_PIN(190)
+#define CAPRI_PIN_SIM2_DET		_PIN(191)
+#define CAPRI_PIN_SIM2_RESETN		_PIN(192)
+#define CAPRI_PIN_SRI_C			_PIN(193)
+#define CAPRI_PIN_SRI_D			_PIN(194)
+#define CAPRI_PIN_SRI_E			_PIN(195)
+#define CAPRI_PIN_SSP_EXTCLK		_PIN(196)
+#define CAPRI_PIN_SSP0_CLK		_PIN(197)
+#define CAPRI_PIN_SSP0_FS		_PIN(198)
+#define CAPRI_PIN_SSP0_RXD		_PIN(199)
+#define CAPRI_PIN_SSP0_TXD		_PIN(200)
+#define CAPRI_PIN_SSP2_CLK		_PIN(201)
+#define CAPRI_PIN_SSP2_FS_0		_PIN(202)
+#define CAPRI_PIN_SSP2_FS_1		_PIN(203)
+#define CAPRI_PIN_SSP2_FS_2		_PIN(204)
+#define CAPRI_PIN_SSP2_FS_3		_PIN(205)
+#define CAPRI_PIN_SSP2_RXD_0		_PIN(206)
+#define CAPRI_PIN_SSP2_RXD_1		_PIN(207)
+#define CAPRI_PIN_SSP2_TXD_0		_PIN(208)
+#define CAPRI_PIN_SSP2_TXD_1		_PIN(209)
+#define CAPRI_PIN_SSP3_CLK		_PIN(210)
+#define CAPRI_PIN_SSP3_FS		_PIN(211)
+#define CAPRI_PIN_SSP3_RXD		_PIN(212)
+#define CAPRI_PIN_SSP3_TXD		_PIN(213)
+#define CAPRI_PIN_SSP4_CLK		_PIN(214)
+#define CAPRI_PIN_SSP4_FS		_PIN(215)
+#define CAPRI_PIN_SSP4_RXD		_PIN(216)
+#define CAPRI_PIN_SSP4_TXD		_PIN(217)
+#define CAPRI_PIN_SSP5_CLK		_PIN(218)
+#define CAPRI_PIN_SSP5_FS		_PIN(219)
+#define CAPRI_PIN_SSP5_RXD		_PIN(220)
+#define CAPRI_PIN_SSP5_TXD		_PIN(221)
+#define CAPRI_PIN_SSP6_CLK		_PIN(222)
+#define CAPRI_PIN_SSP6_FS		_PIN(223)
+#define CAPRI_PIN_SSP6_RXD		_PIN(224)
+#define CAPRI_PIN_SSP6_TXD		_PIN(225)
+#define CAPRI_PIN_STAT_1		_PIN(226)
+#define CAPRI_PIN_STAT_2		_PIN(227)
+#define CAPRI_PIN_SYSCLKEN		_PIN(228)
+#define CAPRI_PIN_TRACECLK		_PIN(229)
+#define CAPRI_PIN_TRACEDT00		_PIN(230)
+#define CAPRI_PIN_TRACEDT01		_PIN(231)
+#define CAPRI_PIN_TRACEDT02		_PIN(232)
+#define CAPRI_PIN_TRACEDT03		_PIN(233)
+#define CAPRI_PIN_TRACEDT04		_PIN(234)
+#define CAPRI_PIN_TRACEDT05		_PIN(235)
+#define CAPRI_PIN_TRACEDT06		_PIN(236)
+#define CAPRI_PIN_TRACEDT07		_PIN(237)
+#define CAPRI_PIN_TRACEDT08		_PIN(238)
+#define CAPRI_PIN_TRACEDT09		_PIN(239)
+#define CAPRI_PIN_TRACEDT10		_PIN(240)
+#define CAPRI_PIN_TRACEDT11		_PIN(241)
+#define CAPRI_PIN_TRACEDT12		_PIN(242)
+#define CAPRI_PIN_TRACEDT13		_PIN(243)
+#define CAPRI_PIN_TRACEDT14		_PIN(244)
+#define CAPRI_PIN_TRACEDT15		_PIN(245)
+#define CAPRI_PIN_TXDATA3G0		_PIN(246)
+#define CAPRI_PIN_TXPWRIND		_PIN(247)
+#define CAPRI_PIN_UARTB1_UCTS		_PIN(248)
+#define CAPRI_PIN_UARTB1_URTS		_PIN(249)
+#define CAPRI_PIN_UARTB1_URXD		_PIN(250)
+#define CAPRI_PIN_UARTB1_UTXD		_PIN(251)
+#define CAPRI_PIN_UARTB2_URXD		_PIN(252)
+#define CAPRI_PIN_UARTB2_UTXD		_PIN(253)
+#define CAPRI_PIN_UARTB3_UCTS		_PIN(254)
+#define CAPRI_PIN_UARTB3_URTS		_PIN(255)
+#define CAPRI_PIN_UARTB3_URXD		_PIN(256)
+#define CAPRI_PIN_UARTB3_UTXD		_PIN(257)
+#define CAPRI_PIN_UARTB4_UCTS		_PIN(258)
+#define CAPRI_PIN_UARTB4_URTS		_PIN(259)
+#define CAPRI_PIN_UARTB4_URXD		_PIN(260)
+#define CAPRI_PIN_UARTB4_UTXD		_PIN(261)
+#define CAPRI_PIN_VC_CAM1_SCL		_PIN(262)
+#define CAPRI_PIN_VC_CAM1_SDA		_PIN(263)
+#define CAPRI_PIN_VC_CAM2_SCL		_PIN(264)
+#define CAPRI_PIN_VC_CAM2_SDA		_PIN(265)
+#define CAPRI_PIN_VC_CAM3_SCL		_PIN(266)
+#define CAPRI_PIN_VC_CAM3_SDA		_PIN(267)
+
+#define CAPRI_PIN_DESC(a, b, c) \
+	{ .number = a, .name = b, .drv_data = &c##_pin }
+
+/*
+ * Pin description definition.  The order here must be the same as defined in
+ * the PADCTRLREG block in the RDB, since the pin number is used as an index
+ * into this array.
+ */
+static const struct pinctrl_pin_desc capri_pinctrl_pins[] = {
+	CAPRI_PIN_DESC(CAPRI_PIN_ADCSYNC, "adcsync", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_BAT_RM, "bat_rm", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_BSC1_SCL, "bsc1_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_BSC1_SDA, "bsc1_sda", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_BSC2_SCL, "bsc2_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_BSC2_SDA, "bsc2_sda", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLASSGPWR, "classgpwr", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLK_CX8, "clk_cx8", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKOUT_0, "clkout_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKOUT_1, "clkout_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKOUT_2, "clkout_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKOUT_3, "clkout_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKREQ_IN_0, "clkreq_in_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CLKREQ_IN_1, "clkreq_in_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CWS_SYS_REQ1, "cws_sys_req1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CWS_SYS_REQ2, "cws_sys_req2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_CWS_SYS_REQ3, "cws_sys_req3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_DIGMIC1_CLK, "digmic1_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_DIGMIC1_DQ, "digmic1_dq", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_DIGMIC2_CLK, "digmic2_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_DIGMIC2_DQ, "digmic2_dq", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPEN13, "gpen13", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPEN14, "gpen14", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPEN15, "gpen15", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO00, "gpio00", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO01, "gpio01", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO02, "gpio02", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO03, "gpio03", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO04, "gpio04", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO05, "gpio05", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO06, "gpio06", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO07, "gpio07", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO08, "gpio08", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO09, "gpio09", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO10, "gpio10", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO11, "gpio11", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO12, "gpio12", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO13, "gpio13", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPIO14, "gpio14", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPS_PABLANK, "gps_pablank", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_GPS_TMARK, "gps_tmark", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_HDMI_SCL, "hdmi_scl", hdmi),
+	CAPRI_PIN_DESC(CAPRI_PIN_HDMI_SDA, "hdmi_sda", hdmi),
+	CAPRI_PIN_DESC(CAPRI_PIN_IC_DM, "ic_dm", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_IC_DP, "ic_dp", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_COL_IP_0, "kp_col_ip_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_COL_IP_1, "kp_col_ip_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_COL_IP_2, "kp_col_ip_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_COL_IP_3, "kp_col_ip_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_ROW_OP_0, "kp_row_op_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_ROW_OP_1, "kp_row_op_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_ROW_OP_2, "kp_row_op_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_KP_ROW_OP_3, "kp_row_op_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_0, "lcd_b_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_1, "lcd_b_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_2, "lcd_b_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_3, "lcd_b_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_4, "lcd_b_4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_5, "lcd_b_5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_6, "lcd_b_6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_B_7, "lcd_b_7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_0, "lcd_g_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_1, "lcd_g_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_2, "lcd_g_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_3, "lcd_g_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_4, "lcd_g_4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_5, "lcd_g_5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_6, "lcd_g_6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_G_7, "lcd_g_7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_HSYNC, "lcd_hsync", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_OE, "lcd_oe", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_PCLK, "lcd_pclk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_0, "lcd_r_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_1, "lcd_r_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_2, "lcd_r_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_3, "lcd_r_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_4, "lcd_r_4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_5, "lcd_r_5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_6, "lcd_r_6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_R_7, "lcd_r_7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_LCD_VSYNC, "lcd_vsync", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO0, "mdmgpio0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO1, "mdmgpio1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO2, "mdmgpio2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO3, "mdmgpio3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO4, "mdmgpio4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO5, "mdmgpio5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO6, "mdmgpio6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO7, "mdmgpio7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MDMGPIO8, "mdmgpio8", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_0, "mphi_data_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_1, "mphi_data_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_2, "mphi_data_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_3, "mphi_data_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_4, "mphi_data_4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_5, "mphi_data_5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_6, "mphi_data_6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_7, "mphi_data_7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_8, "mphi_data_8", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_9, "mphi_data_9", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_10, "mphi_data_10", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_11, "mphi_data_11", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_12, "mphi_data_12", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_13, "mphi_data_13", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_14, "mphi_data_14", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_DATA_15, "mphi_data_15", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HA0, "mphi_ha0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HAT0, "mphi_hat0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HAT1, "mphi_hat1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HCE0_N, "mphi_hce0_n", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HCE1_N, "mphi_hce1_n", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HRD_N, "mphi_hrd_n", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_HWR_N, "mphi_hwr_n", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_RUN0, "mphi_run0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MPHI_RUN1, "mphi_run1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MTX_SCAN_CLK, "mtx_scan_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_MTX_SCAN_DATA, "mtx_scan_data", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_0, "nand_ad_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_1, "nand_ad_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_2, "nand_ad_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_3, "nand_ad_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_4, "nand_ad_4", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_5, "nand_ad_5", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_6, "nand_ad_6", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_AD_7, "nand_ad_7", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_ALE, "nand_ale", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_CEN_0, "nand_cen_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_CEN_1, "nand_cen_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_CLE, "nand_cle", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_OEN, "nand_oen", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_RDY_0, "nand_rdy_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_RDY_1, "nand_rdy_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_WEN, "nand_wen", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_NAND_WP, "nand_wp", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_PC1, "pc1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_PC2, "pc2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_PMU_INT, "pmu_int", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_PMU_SCL, "pmu_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_PMU_SDA, "pmu_sda", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_RFST2G_MTSLOTEN3G, "rfst2g_mtsloten3g", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RX_CTL, "rgmii_0_rx_ctl", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RXC, "rgmii_0_rxc", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RXD_0, "rgmii_0_rxd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RXD_1, "rgmii_0_rxd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RXD_2, "rgmii_0_rxd_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_RXD_3, "rgmii_0_rxd_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TX_CTL, "rgmii_0_tx_ctl", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TXC, "rgmii_0_txc", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TXD_0, "rgmii_0_txd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TXD_1, "rgmii_0_txd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TXD_2, "rgmii_0_txd_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_0_TXD_3, "rgmii_0_txd_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RX_CTL, "rgmii_1_rx_ctl", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RXC, "rgmii_1_rxc", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RXD_0, "rgmii_1_rxd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RXD_1, "rgmii_1_rxd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RXD_2, "rgmii_1_rxd_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_RXD_3, "rgmii_1_rxd_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TX_CTL, "rgmii_1_tx_ctl", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TXC, "rgmii_1_txc", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TXD_0, "rgmii_1_txd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TXD_1, "rgmii_1_txd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TXD_2, "rgmii_1_txd_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_1_TXD_3, "rgmii_1_txd_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_GPIO_0, "rgmii_gpio_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_GPIO_1, "rgmii_gpio_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_GPIO_2, "rgmii_gpio_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RGMII_GPIO_3, "rgmii_gpio_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RTXDATA2G_TXDATA3G1, "rtxdata2g_txdata3g1",
+		std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RTXEN2G_TXDATA3G2, "rtxen2g_txdata3g2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RXDATA3G0, "rxdata3g0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RXDATA3G1, "rxdata3g1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_RXDATA3G2, "rxdata3g2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_CLK, "sdio1_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_CMD, "sdio1_cmd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_DATA_0, "sdio1_data_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_DATA_1, "sdio1_data_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_DATA_2, "sdio1_data_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO1_DATA_3, "sdio1_data_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_CLK, "sdio4_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_CMD, "sdio4_cmd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_DATA_0, "sdio4_data_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_DATA_1, "sdio4_data_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_DATA_2, "sdio4_data_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SDIO4_DATA_3, "sdio4_data_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM_CLK, "sim_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM_DATA, "sim_data", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM_DET, "sim_det", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM_RESETN, "sim_resetn", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM2_CLK, "sim2_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM2_DATA, "sim2_data", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM2_DET, "sim2_det", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SIM2_RESETN, "sim2_resetn", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SRI_C, "sri_c", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SRI_D, "sri_d", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SRI_E, "sri_e", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP_EXTCLK, "ssp_extclk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP0_CLK, "ssp0_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP0_FS, "ssp0_fs", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP0_RXD, "ssp0_rxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP0_TXD, "ssp0_txd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_CLK, "ssp2_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_FS_0, "ssp2_fs_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_FS_1, "ssp2_fs_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_FS_2, "ssp2_fs_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_FS_3, "ssp2_fs_3", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_RXD_0, "ssp2_rxd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_RXD_1, "ssp2_rxd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_TXD_0, "ssp2_txd_0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP2_TXD_1, "ssp2_txd_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP3_CLK, "ssp3_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP3_FS, "ssp3_fs", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP3_RXD, "ssp3_rxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP3_TXD, "ssp3_txd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP4_CLK, "ssp4_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP4_FS, "ssp4_fs", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP4_RXD, "ssp4_rxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP4_TXD, "ssp4_txd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP5_CLK, "ssp5_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP5_FS, "ssp5_fs", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP5_RXD, "ssp5_rxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP5_TXD, "ssp5_txd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP6_CLK, "ssp6_clk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP6_FS, "ssp6_fs", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP6_RXD, "ssp6_rxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SSP6_TXD, "ssp6_txd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_STAT_1, "stat_1", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_STAT_2, "stat_2", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_SYSCLKEN, "sysclken", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACECLK, "traceclk", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT00, "tracedt00", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT01, "tracedt01", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT02, "tracedt02", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT03, "tracedt03", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT04, "tracedt04", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT05, "tracedt05", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT06, "tracedt06", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT07, "tracedt07", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT08, "tracedt08", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT09, "tracedt09", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT10, "tracedt10", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT11, "tracedt11", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT12, "tracedt12", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT13, "tracedt13", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT14, "tracedt14", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TRACEDT15, "tracedt15", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TXDATA3G0, "txdata3g0", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_TXPWRIND, "txpwrind", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB1_UCTS, "uartb1_ucts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB1_URTS, "uartb1_urts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB1_URXD, "uartb1_urxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB1_UTXD, "uartb1_utxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB2_URXD, "uartb2_urxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB2_UTXD, "uartb2_utxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB3_UCTS, "uartb3_ucts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB3_URTS, "uartb3_urts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB3_URXD, "uartb3_urxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB3_UTXD, "uartb3_utxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB4_UCTS, "uartb4_ucts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB4_URTS, "uartb4_urts", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB4_URXD, "uartb4_urxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_UARTB4_UTXD, "uartb4_utxd", std),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM1_SCL, "vc_cam1_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM1_SDA, "vc_cam1_sda", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM2_SCL, "vc_cam2_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM2_SDA, "vc_cam2_sda", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM3_SCL, "vc_cam3_scl", i2c),
+	CAPRI_PIN_DESC(CAPRI_PIN_VC_CAM3_SDA, "vc_cam3_sda", i2c),
+};
+
+static const char * const capri_alt_groups[] = {
+	"adcsync",
+	"bat_rm",
+	"bsc1_scl",
+	"bsc1_sda",
+	"bsc2_scl",
+	"bsc2_sda",
+	"classgpwr",
+	"clk_cx8",
+	"clkout_0",
+	"clkout_1",
+	"clkout_2",
+	"clkout_3",
+	"clkreq_in_0",
+	"clkreq_in_1",
+	"cws_sys_req1",
+	"cws_sys_req2",
+	"cws_sys_req3",
+	"digmic1_clk",
+	"digmic1_dq",
+	"digmic2_clk",
+	"digmic2_dq",
+	"gpen13",
+	"gpen14",
+	"gpen15",
+	"gpio00",
+	"gpio01",
+	"gpio02",
+	"gpio03",
+	"gpio04",
+	"gpio05",
+	"gpio06",
+	"gpio07",
+	"gpio08",
+	"gpio09",
+	"gpio10",
+	"gpio11",
+	"gpio12",
+	"gpio13",
+	"gpio14",
+	"gps_pablank",
+	"gps_tmark",
+	"hdmi_scl",
+	"hdmi_sda",
+	"ic_dm",
+	"ic_dp",
+	"kp_col_ip_0",
+	"kp_col_ip_1",
+	"kp_col_ip_2",
+	"kp_col_ip_3",
+	"kp_row_op_0",
+	"kp_row_op_1",
+	"kp_row_op_2",
+	"kp_row_op_3",
+	"lcd_b_0",
+	"lcd_b_1",
+	"lcd_b_2",
+	"lcd_b_3",
+	"lcd_b_4",
+	"lcd_b_5",
+	"lcd_b_6",
+	"lcd_b_7",
+	"lcd_g_0",
+	"lcd_g_1",
+	"lcd_g_2",
+	"lcd_g_3",
+	"lcd_g_4",
+	"lcd_g_5",
+	"lcd_g_6",
+	"lcd_g_7",
+	"lcd_hsync",
+	"lcd_oe",
+	"lcd_pclk",
+	"lcd_r_0",
+	"lcd_r_1",
+	"lcd_r_2",
+	"lcd_r_3",
+	"lcd_r_4",
+	"lcd_r_5",
+	"lcd_r_6",
+	"lcd_r_7",
+	"lcd_vsync",
+	"mdmgpio0",
+	"mdmgpio1",
+	"mdmgpio2",
+	"mdmgpio3",
+	"mdmgpio4",
+	"mdmgpio5",
+	"mdmgpio6",
+	"mdmgpio7",
+	"mdmgpio8",
+	"mphi_data_0",
+	"mphi_data_1",
+	"mphi_data_2",
+	"mphi_data_3",
+	"mphi_data_4",
+	"mphi_data_5",
+	"mphi_data_6",
+	"mphi_data_7",
+	"mphi_data_8",
+	"mphi_data_9",
+	"mphi_data_10",
+	"mphi_data_11",
+	"mphi_data_12",
+	"mphi_data_13",
+	"mphi_data_14",
+	"mphi_data_15",
+	"mphi_ha0",
+	"mphi_hat0",
+	"mphi_hat1",
+	"mphi_hce0_n",
+	"mphi_hce1_n",
+	"mphi_hrd_n",
+	"mphi_hwr_n",
+	"mphi_run0",
+	"mphi_run1",
+	"mtx_scan_clk",
+	"mtx_scan_data",
+	"nand_ad_0",
+	"nand_ad_1",
+	"nand_ad_2",
+	"nand_ad_3",
+	"nand_ad_4",
+	"nand_ad_5",
+	"nand_ad_6",
+	"nand_ad_7",
+	"nand_ale",
+	"nand_cen_0",
+	"nand_cen_1",
+	"nand_cle",
+	"nand_oen",
+	"nand_rdy_0",
+	"nand_rdy_1",
+	"nand_wen",
+	"nand_wp",
+	"pc1",
+	"pc2",
+	"pmu_int",
+	"pmu_scl",
+	"pmu_sda",
+	"rfst2g_mtsloten3g",
+	"rgmii_0_rx_ctl",
+	"rgmii_0_rxc",
+	"rgmii_0_rxd_0",
+	"rgmii_0_rxd_1",
+	"rgmii_0_rxd_2",
+	"rgmii_0_rxd_3",
+	"rgmii_0_tx_ctl",
+	"rgmii_0_txc",
+	"rgmii_0_txd_0",
+	"rgmii_0_txd_1",
+	"rgmii_0_txd_2",
+	"rgmii_0_txd_3",
+	"rgmii_1_rx_ctl",
+	"rgmii_1_rxc",
+	"rgmii_1_rxd_0",
+	"rgmii_1_rxd_1",
+	"rgmii_1_rxd_2",
+	"rgmii_1_rxd_3",
+	"rgmii_1_tx_ctl",
+	"rgmii_1_txc",
+	"rgmii_1_txd_0",
+	"rgmii_1_txd_1",
+	"rgmii_1_txd_2",
+	"rgmii_1_txd_3",
+	"rgmii_gpio_0",
+	"rgmii_gpio_1",
+	"rgmii_gpio_2",
+	"rgmii_gpio_3",
+	"rtxdata2g_txdata3g1",
+	"rtxen2g_txdata3g2",
+	"rxdata3g0",
+	"rxdata3g1",
+	"rxdata3g2",
+	"sdio1_clk",
+	"sdio1_cmd",
+	"sdio1_data_0",
+	"sdio1_data_1",
+	"sdio1_data_2",
+	"sdio1_data_3",
+	"sdio4_clk",
+	"sdio4_cmd",
+	"sdio4_data_0",
+	"sdio4_data_1",
+	"sdio4_data_2",
+	"sdio4_data_3",
+	"sim_clk",
+	"sim_data",
+	"sim_det",
+	"sim_resetn",
+	"sim2_clk",
+	"sim2_data",
+	"sim2_det",
+	"sim2_resetn",
+	"sri_c",
+	"sri_d",
+	"sri_e",
+	"ssp_extclk",
+	"ssp0_clk",
+	"ssp0_fs",
+	"ssp0_rxd",
+	"ssp0_txd",
+	"ssp2_clk",
+	"ssp2_fs_0",
+	"ssp2_fs_1",
+	"ssp2_fs_2",
+	"ssp2_fs_3",
+	"ssp2_rxd_0",
+	"ssp2_rxd_1",
+	"ssp2_txd_0",
+	"ssp2_txd_1",
+	"ssp3_clk",
+	"ssp3_fs",
+	"ssp3_rxd",
+	"ssp3_txd",
+	"ssp4_clk",
+	"ssp4_fs",
+	"ssp4_rxd",
+	"ssp4_txd",
+	"ssp5_clk",
+	"ssp5_fs",
+	"ssp5_rxd",
+	"ssp5_txd",
+	"ssp6_clk",
+	"ssp6_fs",
+	"ssp6_rxd",
+	"ssp6_txd",
+	"stat_1",
+	"stat_2",
+	"sysclken",
+	"traceclk",
+	"tracedt00",
+	"tracedt01",
+	"tracedt02",
+	"tracedt03",
+	"tracedt04",
+	"tracedt05",
+	"tracedt06",
+	"tracedt07",
+	"tracedt08",
+	"tracedt09",
+	"tracedt10",
+	"tracedt11",
+	"tracedt12",
+	"tracedt13",
+	"tracedt14",
+	"tracedt15",
+	"txdata3g0",
+	"txpwrind",
+	"uartb1_ucts",
+	"uartb1_urts",
+	"uartb1_urxd",
+	"uartb1_utxd",
+	"uartb2_urxd",
+	"uartb2_utxd",
+	"uartb3_ucts",
+	"uartb3_urts",
+	"uartb3_urxd",
+	"uartb3_utxd",
+	"uartb4_ucts",
+	"uartb4_urts",
+	"uartb4_urxd",
+	"uartb4_utxd",
+	"vc_cam1_scl",
+	"vc_cam1_sda",
+	"vc_cam2_scl",
+	"vc_cam2_sda",
+	"vc_cam3_scl",
+	"vc_cam3_sda",
+};
+
+/* Every pin can implement all ALT1-ALT4 functions */
+#define CAPRI_PIN_FUNCTION(fcn_name)			\
+{							\
+	.name = #fcn_name,				\
+	.groups = capri_alt_groups,			\
+	.ngroups = ARRAY_SIZE(capri_alt_groups),	\
+}
+
+static const struct capri_pin_function capri_functions[] = {
+	CAPRI_PIN_FUNCTION(alt1),
+	CAPRI_PIN_FUNCTION(alt2),
+	CAPRI_PIN_FUNCTION(alt3),
+	CAPRI_PIN_FUNCTION(alt4),
+};
+
+static struct capri_pinctrl_data capri_pinctrl = {
+	.pins = capri_pinctrl_pins,
+	.npins = ARRAY_SIZE(capri_pinctrl_pins),
+	.functions = capri_functions,
+	.nfunctions = ARRAY_SIZE(capri_functions),
+};
+
+static int capri_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	return pdata->npins;
+}
+
+static const char *capri_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
+						unsigned group)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	return pdata->pins[group].name;
+}
+
+static int capri_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+					unsigned group,
+					const unsigned **pins,
+					unsigned *num_pins)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = &pdata->pins[group].number;
+	*num_pins = 1;
+
+	return 0;
+}
+
+static void capri_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
+				       struct seq_file *s,
+				       unsigned offset)
+{
+	seq_printf(s, " %s", dev_name(pctldev->dev));
+}
+
+static void capri_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				      struct pinctrl_map *map,
+				      unsigned num_maps)
+{
+	int i;
+
+	/*
+	 * First free all the per-pin config arrays since they are dynamically
+	 * allocated.
+	 */
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+/**
+ * capri_resize_map - krealloc for pinctrl_map
+ * @pctldev: ptr to pinctrl_dev, for logging purposes
+ * @map: ptr to pinctrl_map array
+ * @nmaps: in - current size of pinctrl_map, out - new size of pinctrl_map
+ * @change: number of elements to expand/shrink pinctrl_map array by
+ *
+ * Shrinks or expands the existing pinctrl_map <maps> by <change> elements by
+ * memory reallocation.  Sets the new elements to zero before returning.
+ * the new array is <nmaps + change> elements long.
+ */
+static int capri_resize_map(struct pinctrl_dev *pctldev,
+			    struct pinctrl_map **map,
+			    unsigned *nmaps,
+			    int change)
+{
+	int old_num = *nmaps;
+	int new_num = old_num + change;
+	struct pinctrl_map *new_map;
+
+	/* If no change, just return */
+	if (!change)
+		goto resize_exit;
+
+	/* New size should never be < 0 */
+	if (new_num < 0) {
+		dev_warn(pctldev->dev,
+			 "Negative size requested for pinctrl_map\n");
+		new_num = 0;
+	}
+
+	/* Shrink or expand map */
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map) {
+		dev_err(pctldev->dev, "No memory for new pinctrl mappings.\n");
+		return -ENOMEM;
+	}
+
+	/* Clear new maps */
+	if (change > 0)
+		memset(new_map + old_num, 0, change * sizeof(*new_map));
+
+	*map = new_map;
+	*nmaps = new_num;
+
+resize_exit:
+	dev_dbg(pctldev->dev, "%s(): pinctrl_map size %d->%d\n",
+		__func__, old_num, new_num);
+
+	return 0;
+}
+
+/* Add a pinmux mapping for one pin */
+static int capri_dt_pinmux_to_map(struct pinctrl_dev *pctldev,
+				  struct device_node *pnode,
+				  struct pinctrl_map **map,
+				  int *map_index,
+				  int pin_count,
+				  int pin_index,
+				  const char *pin_name)
+{
+	int mux_count, index, ret;
+	const char *function = NULL;
+
+	mux_count = of_property_count_strings(pnode, "brcm,function");
+
+	dev_dbg(pctldev->dev, "%s(): mux_count = %d\n", __func__, mux_count);
+
+	if (mux_count <= 0)
+		/* Nothing to do, just return */
+		return 0;
+	else if ((mux_count != 1) && (mux_count != pin_count)) {
+		dev_err(pctldev->dev,
+			"%s(): Invalid # of functions in DT node %s.\n",
+			__func__, pnode->name);
+		return -EINVAL;
+	}
+
+	index = (mux_count == 1 ? 0 : pin_index);
+
+	ret = of_property_read_string_index(pnode,
+					    "brcm,function",
+					    index,
+					    &function);
+	if (ret < 0) {
+		dev_err(pctldev->dev,
+			"%s(): Error reading pinmux in node %s\n",
+			__func__, pnode->name);
+		return -EINVAL;
+	}
+
+	/*
+	 * dt_remember_or_free_map() will set the following members of
+	 * struct pinctrl_map later: dev_name, name, ctrl_dev_name
+	 */
+	(*map)[*map_index].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*map_index].data.mux.group = pin_name;
+	(*map)[*map_index].data.mux.function = function;
+
+	(*map_index)++;
+
+	dev_dbg(pctldev->dev, "%s(): New pinmux mapping: %s->%s\n",
+		__func__, pin_name, function);
+
+	return 0;
+}
+
+/* Return the pin type for a given pin name */
+static enum capri_pin_type pin_type_get(struct pinctrl_dev *pctldev,
+					const char *pin_name)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+	struct pinctrl_pin_desc const *desc;
+	int i;
+
+	for (i = 0; i < pdata->npins; i++) {
+		desc = &pdata->pins[i];
+		if (desc->name && !strcmp(pin_name, desc->name)) {
+			dev_dbg(pctldev->dev,
+				"%s(): Pin %s is pin number %d, type %d\n",
+				__func__, pin_name, desc->number,
+				*(enum capri_pin_type *)desc->drv_data);
+
+			return *(enum capri_pin_type *)desc->drv_data;
+		}
+	}
+
+	dev_warn(pctldev->dev,
+		 "%s(): Cannot find pin named %s\n",
+		 __func__, pin_name);
+
+	return CAPRI_PIN_TYPE_UNKNOWN;
+}
+
+static int capri_std_pin_update(struct pinctrl_dev *pctldev,
+				enum capri_pinconf_param param,
+				unsigned val,
+				u32 *reg_val,
+				u32 *reg_mask)
+{
+	switch (param) {
+	case CAPRI_PINCONF_PARAM_HYST:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Hysteresis.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, STD, HYST, val);
+		*reg_mask |= CAPRI_STD_PIN_REG_HYST_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_PULL:
+		if (val > 3) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Pull up/down.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, STD, PULL, val);
+		*reg_mask |= CAPRI_STD_PIN_REG_PULL_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_SLEW:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Slew Rate.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, STD, SLEW, val);
+		*reg_mask |= CAPRI_STD_PIN_REG_SLEW_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_INPUT_DIS:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Input Disable.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, STD, INPUT_DIS, val);
+		*reg_mask |= CAPRI_STD_PIN_REG_INPUT_DIS_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_DRV_STR:
+		/* Valid range is 2-16 mA, even numbers only */
+		if ((val < 2) || (val > 16) || (val % 2)) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Drive Strength.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, STD, DRV_STR, (val/2)-1);
+		*reg_mask |= CAPRI_STD_PIN_REG_DRV_STR_MASK;
+		break;
+
+	default:
+		dev_err(pctldev->dev, "Unrecognized pin config.\n");
+		return -EINVAL;
+
+	} /* switch config */
+
+	return 0;
+}
+
+static int capri_i2c_pin_update(struct pinctrl_dev *pctldev,
+				enum capri_pinconf_param param,
+				unsigned val,
+				u32 *reg_val,
+				u32 *reg_mask)
+{
+	switch (param) {
+	case CAPRI_PINCONF_PARAM_PULL_UP_STR:
+		if (val > 7) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Pull Up Strength.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, I2C, PULL_UP_STR, val);
+		*reg_mask |= CAPRI_I2C_PIN_REG_PULL_UP_STR_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_SLEW:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Slew Rate.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, I2C, SLEW, val);
+		*reg_mask |= CAPRI_I2C_PIN_REG_SLEW_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_INPUT_DIS:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Input Disable.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, I2C, INPUT_DIS, val);
+		*reg_mask |= CAPRI_I2C_PIN_REG_INPUT_DIS_MASK;
+		break;
+
+	default:
+		dev_err(pctldev->dev, "Unrecognized pin config.\n");
+		return -EINVAL;
+
+	} /* switch config */
+
+	return 0;
+}
+
+static int capri_hdmi_pin_update(struct pinctrl_dev *pctldev,
+				 enum capri_pinconf_param param,
+				 unsigned val,
+				 u32 *reg_val,
+				 u32 *reg_mask)
+{
+	switch (param) {
+	case CAPRI_PINCONF_PARAM_MODE:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Mode.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, HDMI, MODE, val);
+		*reg_mask |= CAPRI_HDMI_PIN_REG_MODE_MASK;
+		break;
+
+	case CAPRI_PINCONF_PARAM_INPUT_DIS:
+		if (val > 1) {
+			dev_err(pctldev->dev,
+				"Invalid pin config for Input Disable.\n");
+			return -EINVAL;
+		}
+		*reg_val = CAPRI_PIN_REG_SET(*reg_val, HDMI, INPUT_DIS, val);
+		*reg_mask |= CAPRI_HDMI_PIN_REG_INPUT_DIS_MASK;
+		break;
+
+	default:
+		dev_err(pctldev->dev, "Unrecognized pin config.\n");
+		return -EINVAL;
+
+	} /* switch config */
+
+	return 0;
+}
+
+/**
+ * capri_dt_pincfg_to_map - Add a pincfg mapping for one pin
+ * @map_index - the index into the map array to write next
+ */
+static int capri_dt_pincfg_to_map(struct pinctrl_dev *pctldev,
+				  struct device_node *pnode,
+				  struct pinctrl_map **map,
+				  int *map_index,
+				  int pin_count,
+				  int pin_index,
+				  const char *pin_name)
+{
+	int val_count, prop_index, i, rc;
+	enum capri_pin_type pin_type;
+	unsigned long prop_val = 0;
+	u32 cfg_val, cfg_mask;
+	unsigned long *cfgs;
+	const struct capri_cfg_param *param;
+	struct property *prop;
+
+	cfg_val = 0;
+	cfg_mask = 0;
+
+	pin_type = pin_type_get(pctldev, pin_name);
+	if (pin_type == CAPRI_PIN_TYPE_UNKNOWN)
+		return -EINVAL;
+
+	/*
+	 * Loop through each of the defined pin config properties, and build
+	 * cfg_val and cfg_mask as we go.  cfg_val will be written straight to
+	 * the pin config register when this pin config is applied.
+	 */
+	for (i = 0; i < ARRAY_SIZE(capri_pinconf_params); i++) {
+		param = &capri_pinconf_params[i];
+
+		/* TODO: replace with of_property_count_u32() */
+		prop = of_find_property(pnode, param->property, NULL);
+
+		if (!prop)
+			continue;
+
+		val_count = prop->length / sizeof(u32);
+
+		dev_dbg(pctldev->dev, "%s(): %d values for %s.\n",
+			__func__, val_count, param->property);
+
+		if ((val_count != 1) && (val_count != pin_count)) {
+			dev_err(pctldev->dev,
+				"%s(): Invalid # of values for %s "
+				"in DT node %s\n",
+				__func__, param->property, pnode->name);
+			return -EINVAL;
+		}
+
+		prop_index = (val_count == 1 ? 0 : pin_index);
+
+		/* TODO: replace with of_property_read_u32_index() */
+		prop_val = be32_to_cpup((u32 *)prop->value + prop_index);
+
+		/* Different pins have different configuration options */
+		switch (pin_type) {
+		case CAPRI_PIN_TYPE_STD:
+			rc = capri_std_pin_update(pctldev,
+				param->id,
+				prop_val,
+				&cfg_val,
+				&cfg_mask);
+			break;
+
+		case CAPRI_PIN_TYPE_I2C:
+			rc = capri_i2c_pin_update(pctldev,
+				param->id,
+				prop_val,
+				&cfg_val,
+				&cfg_mask);
+			break;
+
+		case CAPRI_PIN_TYPE_HDMI:
+			rc = capri_hdmi_pin_update(pctldev,
+				param->id,
+				prop_val,
+				&cfg_val,
+				&cfg_mask);
+			break;
+
+		default:
+			dev_err(pctldev->dev, "Unknown pin type.\n");
+			return -EINVAL;
+
+		} /* switch pin type */
+
+		if (rc) {
+			dev_err(pctldev->dev, "Error setting pin config\n");
+			return rc;
+		}
+
+		dev_dbg(pctldev->dev,
+			 "%s(): cfg_val=0x%x, cfg_mask=0x%x for pin %s\n",
+			 __func__, cfg_val, cfg_mask, pin_name);
+	} /* for each defined pin config parameter */
+
+	/*
+	 * In Capri, the top 16 bits of the pin control register are reserved,
+	 * so we only need to set the lower 16 bits.  Since the pinctrl core
+	 * stores pin configs as an array of u32, we will pack the register
+	 * value in the upper 16 bits and the mask in the lower 16 bits.
+	 */
+	cfgs = kmalloc(sizeof(unsigned long), GFP_KERNEL);
+	if (!cfgs)
+		return -ENOMEM;
+
+	*cfgs = CAPRI_PINCONF_PACK(cfg_val, cfg_mask);
+
+	/*
+	 * dt_remember_or_free_map() will set the following members of
+	 * struct pinctrl_map later: dev_name, name, ctrl_dev_name
+	 */
+
+	dev_dbg(pctldev->dev,
+		 "%s(): Add new pin conf map: config = 0x%lx for pin %s\n",
+		 __func__, *cfgs, pin_name);
+
+	(*map)[*map_index].type = PIN_MAP_TYPE_CONFIGS_PIN;
+	(*map)[*map_index].data.configs.group_or_pin = pin_name;
+	(*map)[*map_index].data.configs.configs = cfgs;
+	(*map)[*map_index].data.configs.num_configs = 1;
+
+	(*map_index)++;
+
+	return 0;
+}
+
+/* Process the pin configuration node */
+static int capri_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+					struct device_node *pnode,
+					struct pinctrl_map **map,
+					unsigned *nmaps)
+{
+	struct device_node *pchild;
+	int pin_count, pin_index, ret, map_index;
+	const char *pin_name;
+	struct property *prop;
+
+	*map = NULL;
+	*nmaps = 0;
+
+	/* Index of next spot to write in pinctrl_map array */
+	map_index = 0;
+
+	/* For each pin group */
+	for_each_child_of_node(pnode, pchild) {
+		/* Requires at least 1 pin per group. */
+		pin_count = of_property_count_strings(pchild, "brcm,pins");
+
+		dev_dbg(pctldev->dev, "%s(): Node %s configures %d pins.\n",
+			__func__, pchild->name, pin_count);
+
+		if (pin_count <= 0) {
+			dev_err(pctldev->dev,
+				"%s(): No pins specified in DT node %s.\n",
+				__func__, pchild->name);
+			return -EINVAL;
+		}
+
+		/* Pre-alloc a pinctrl_map array of size pin_count*2 */
+		ret = capri_resize_map(pctldev, map, nmaps, pin_count * 2);
+		if (ret)
+			return ret;
+
+		pin_index = 0;
+
+		/* Create pin maps for each pin */
+		of_property_for_each_string(pchild,
+					    "brcm,pins",
+					    prop,
+					    pin_name) {
+			ret = capri_dt_pinmux_to_map(pctldev,
+						     pchild,
+						     map,
+						     &map_index,
+						     pin_count,
+						     pin_index,
+						     pin_name);
+			if (ret)
+				return ret;
+
+			ret = capri_dt_pincfg_to_map(pctldev,
+						     pchild,
+						     map,
+						     &map_index,
+						     pin_count,
+						     pin_index,
+						     pin_name);
+			if (ret)
+				return ret;
+			dev_dbg(pctldev->dev,
+				 "%s(): Done pin %s in, next map is %d\n",
+				 __func__, pin_name, map_index);
+			pin_index++;
+		} /* for each pin */
+	} /* for each group */
+
+	/*
+	 * Clean up any over-allocated elements for the pinctrl_map array. This
+	 * could be moved to the end of for each group loop, but it's probably
+	 * more efficient here.
+	 */
+	if (map_index < *nmaps) {
+		ret = capri_resize_map(pctldev, map, nmaps, *nmaps-map_index);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct pinctrl_ops capri_pinctrl_ops = {
+	.get_groups_count = capri_pinctrl_get_groups_count,
+	.get_group_name = capri_pinctrl_get_group_name,
+	.get_group_pins = capri_pinctrl_get_group_pins,
+	.pin_dbg_show = capri_pinctrl_pin_dbg_show,
+	.dt_node_to_map = capri_pinctrl_dt_node_to_map,
+	.dt_free_map = capri_pinctrl_dt_free_map,
+};
+
+static int capri_pinctrl_get_fcns_count(struct pinctrl_dev *pctldev)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	return pdata->nfunctions;
+}
+
+static const char *capri_pinctrl_get_fcn_name(struct pinctrl_dev *pctldev,
+					      unsigned function)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	return pdata->functions[function].name;
+}
+
+static int capri_pinctrl_get_fcn_groups(struct pinctrl_dev *pctldev,
+					unsigned function,
+					const char * const **groups,
+					unsigned * const num_groups)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = pdata->functions[function].groups;
+	*num_groups = pdata->functions[function].ngroups;
+
+	return 0;
+}
+
+static int capri_pinmux_enable(struct pinctrl_dev *pctldev,
+			       unsigned function,
+			       unsigned group)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+	const struct capri_pin_function *f = &pdata->functions[function];
+	void __iomem *reg = pdata->reg_base + (4 * pdata->pins[group].number);
+	u32 old_reg_val;
+	u32 new_reg_val;
+
+	dev_dbg(pctldev->dev,
+		"%s(): Enable function %s (%d) of pin %s (%d) @reg 0x%p.\n",
+		__func__, f->name, function, pdata->pins[group].name,
+		pdata->pins[group].number, reg);
+
+	old_reg_val = readl(reg);
+	new_reg_val = (old_reg_val & ~CAPRI_PIN_REG_F_SEL_MASK)
+		| ((function << CAPRI_PIN_REG_F_SEL_SHIFT)
+		& CAPRI_PIN_REG_F_SEL_MASK);
+
+	if (new_reg_val != old_reg_val) {
+		dev_dbg(pctldev->dev,
+			"Reg 0x%p change from 0x%x to 0x%x\n",
+			reg, old_reg_val, new_reg_val);
+		writel(new_reg_val, reg);
+	} else
+		dev_dbg(pctldev->dev,
+			"Reg 0x%p=0x%x (no change)\n",
+			reg, old_reg_val);
+
+	return 0;
+}
+
+static struct pinmux_ops capri_pinctrl_pinmux_ops = {
+	.get_functions_count = capri_pinctrl_get_fcns_count,
+	.get_function_name = capri_pinctrl_get_fcn_name,
+	.get_function_groups = capri_pinctrl_get_fcn_groups,
+	.enable = capri_pinmux_enable,
+};
+
+static int capri_pinctrl_pin_config_get(struct pinctrl_dev *pctldev,
+					unsigned pin,
+					unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+static int capri_pinctrl_pin_config_set(struct pinctrl_dev *pctldev,
+					unsigned pin,
+					unsigned long *configs,
+					unsigned num_configs)
+{
+	struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
+	void __iomem *reg = pdata->reg_base + (4 * pin);
+	u32 old_reg_val;
+	u32 new_reg_val;
+	unsigned cfg_val, cfg_mask;
+
+	/*
+	 * This driver packs the pin config register value and mask into one
+	 * 32 bit value, so it only expects 1 config.
+	 */
+	if ((num_configs != 1) || (!configs)) {
+		dev_err(pctldev->dev,
+			"Unable to set config pin %s - incorrect parameters",
+			pdata->pins[pin].name);
+		return -EPERM;
+	}
+
+	cfg_val = CAPRI_PINCONF_UNPACK_VAL(*configs);
+	cfg_mask = CAPRI_PINCONF_UNPACK_MASK(*configs);
+
+	dev_dbg(pctldev->dev,
+		"%s(): Set pin %s (%d) with config 0x%x, mask 0x%x\n",
+		__func__, pdata->pins[pin].name, pin, cfg_val, cfg_mask);
+
+	old_reg_val = readl(reg);
+	new_reg_val = (old_reg_val & ~cfg_mask) | cfg_val;
+
+	if (new_reg_val != old_reg_val) {
+		dev_dbg(pctldev->dev,
+			"Reg 0x%p change from 0x%x to 0x%x\n",
+			reg, old_reg_val, new_reg_val);
+		writel(new_reg_val, reg);
+	} else
+		dev_dbg(pctldev->dev,
+			"Reg 0x%p=0x%x (no change)\n",
+			reg, old_reg_val);
+
+
+	return 0;
+}
+
+static struct pinconf_ops capri_pinctrl_pinconf_ops = {
+	.pin_config_get = capri_pinctrl_pin_config_get,
+	.pin_config_set = capri_pinctrl_pin_config_set,
+};
+
+static struct pinctrl_desc capri_pinctrl_desc = {
+	/* name, pins, npins members initialized in probe function */
+	.pctlops = &capri_pinctrl_ops,
+	.pmxops = &capri_pinctrl_pinmux_ops,
+	.confops = &capri_pinctrl_pinconf_ops,
+	.owner = THIS_MODULE,
+};
+
+int __init capri_pinctrl_probe(struct platform_device *pdev)
+{
+	struct capri_pinctrl_data *pdata = &capri_pinctrl;
+	struct resource *res;
+	struct pinctrl_dev *pctl;
+
+	/* So far We can assume there is only 1 bank of registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Missing MEM resource\n");
+		return -ENODEV;
+	}
+
+	pdata->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->reg_base)) {
+		dev_err(&pdev->dev, "Failed to ioremap MEM resource\n");
+		return -ENODEV;
+	}
+
+	/* Initialize the dynamic part of pinctrl_desc */
+	capri_pinctrl_desc.name = dev_name(&pdev->dev);
+	capri_pinctrl_desc.pins = capri_pinctrl.pins;
+	capri_pinctrl_desc.npins = capri_pinctrl.npins;
+
+	pctl = pinctrl_register(&capri_pinctrl_desc,
+				&pdev->dev,
+				pdata);
+	if (!pctl) {
+		dev_err(&pdev->dev, "Failed to register pinctrl\n");
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, pdata);
+
+	return 0;
+}
+
+static struct of_device_id capri_pinctrl_of_match[] = {
+	{ .compatible = "brcm,capri-pinctrl", },
+	{ },
+};
+
+static struct platform_driver capri_pinctrl_driver = {
+	.driver = {
+		.name = "bcm-capri-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = capri_pinctrl_of_match,
+	},
+};
+
+module_platform_driver_probe(capri_pinctrl_driver, capri_pinctrl_probe);
+
+MODULE_AUTHOR("Sherman Yin <syin@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom Capri pinctrl driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5


