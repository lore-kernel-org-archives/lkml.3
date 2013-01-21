Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3AUMEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:43 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:61230 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3AUMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Loic Pallardy <loic.pallardy@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/24] pm2301: Add deep debug
Date: Mon, 21 Jan 2013 12:03:43 +0000
Message-Id: <1358769840-4763-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@stericsson.com>

Register access for HATS testing purposes

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
---
 drivers/power/Kconfig            |    9 +
 drivers/power/Makefile           |    1 +
 drivers/power/pm2301_charger.c   |  492 ++----------------------------------
 drivers/power/pm2301_charger.h   |  508 ++++++++++++++++++++++++++++++++++++++
 drivers/power/pm2301_deepdebug.c |  131 ++++++++++
 5 files changed, 664 insertions(+), 477 deletions(-)
 create mode 100644 drivers/power/pm2301_charger.h
 create mode 100644 drivers/power/pm2301_deepdebug.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 4811b59..b9de00d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -353,6 +353,15 @@ config CHARGER_PM2301
 	  Say Y to include support for PM2301 charger driver.
 	  Depends on AB8500 battery management core.
 
+config PM2XXX_DEEP_DEBUG
+	bool "PM2XXX Deep Debug"
+	depends on DEEP_DEBUG && CHARGER_PM2301
+	help
+	  Deep Debug interface provides an access to all registers.
+	  It allows to read or write directly a register.
+	  Say Y to include support for Deep Debug.
+	  If unsure, say N.
+
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index aa966e8..ef1e79c 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_PM2301)	+= pm2301_charger.o
+obj-$(CONFIG_PM2XXX_DEEP_DEBUG)	+= pm2301_deepdebug.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index c470066..c196de7 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1,8 +1,8 @@
 /*
- * Power supply driver for ST Ericsson pm2xxx_charger charger
- *
  * Copyright 2012 ST Ericsson.
  *
+ * Power supply driver for ST Ericsson pm2xxx_charger charger
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -29,285 +29,7 @@
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/pm2301_charger.h>
 
-#define MAIN_WDOG_ENA			0x01
-#define MAIN_WDOG_KICK			0x02
-#define MAIN_WDOG_DIS			0x00
-#define CHARG_WD_KICK			0x01
-#define MAIN_CH_ENA			0x01
-#define MAIN_CH_NO_OVERSHOOT_ENA_N	0x02
-#define MAIN_CH_DET			0x01
-#define MAIN_CH_CV_ON			0x04
-#define OTP_ENABLE_WD			0x01
-
-#define MAIN_CH_INPUT_CURR_SHIFT	4
-
-#define LED_INDICATOR_PWM_ENA		0x01
-#define LED_INDICATOR_PWM_DIS		0x00
-#define LED_IND_CUR_5MA			0x04
-#define LED_INDICATOR_PWM_DUTY_252_256	0xBF
-
-/* HW failure constants */
-#define MAIN_CH_TH_PROT			0x02
-#define MAIN_CH_NOK			0x01
-
-/* Watchdog timeout constant */
-#define WD_TIMER			0x30 /* 4min */
-#define WD_KICK_INTERVAL		(60 * HZ)
-
-/* Constant voltage/current */
-#define PM2XXX_CONST_CURR		0x0
-#define PM2XXX_CONST_VOLT		0x1
-
-/* Lowest charger voltage is 3.39V -> 0x4E */
-#define LOW_VOLT_REG			0x4E
-
-#define PM2XXX_BATT_CTRL_REG1		0x00
-#define PM2XXX_BATT_CTRL_REG2		0x01
-#define PM2XXX_BATT_CTRL_REG3		0x02
-#define PM2XXX_BATT_CTRL_REG4		0x03
-#define PM2XXX_BATT_CTRL_REG5		0x04
-#define PM2XXX_BATT_CTRL_REG6		0x05
-#define PM2XXX_BATT_CTRL_REG7		0x06
-#define PM2XXX_BATT_CTRL_REG8		0x07
-#define PM2XXX_NTC_CTRL_REG1		0x08
-#define PM2XXX_NTC_CTRL_REG2		0x09
-#define PM2XXX_BATT_CTRL_REG9		0x0A
-#define PM2XXX_BATT_STAT_REG1		0x0B
-#define PM2XXX_INP_VOLT_VPWR2		0x11
-#define PM2XXX_INP_DROP_VPWR2		0x13
-#define PM2XXX_INP_VOLT_VPWR1		0x15
-#define PM2XXX_INP_DROP_VPWR1		0x17
-#define PM2XXX_INP_MODE_VPWR		0x18
-#define PM2XXX_BATT_WD_KICK		0x70
-#define PM2XXX_DEV_VER_STAT		0x0C
-#define PM2XXX_THERM_WARN_CTRL_REG	0x20
-#define PM2XXX_BATT_DISC_REG		0x21
-#define PM2XXX_BATT_LOW_LEV_COMP_REG	0x22
-#define PM2XXX_BATT_LOW_LEV_VAL_REG	0x23
-#define PM2XXX_I2C_PAD_CTRL_REG		0x24
-#define PM2XXX_SW_CTRL_REG		0x26
-#define PM2XXX_LED_CTRL_REG		0x28
-
-#define PM2XXX_REG_INT1		0x40
-#define PM2XXX_MASK_REG_INT1	0x50
-#define PM2XXX_SRCE_REG_INT1	0x60
-#define PM2XXX_REG_INT2		0x41
-#define PM2XXX_MASK_REG_INT2	0x51
-#define PM2XXX_SRCE_REG_INT2	0x61
-#define PM2XXX_REG_INT3		0x42
-#define PM2XXX_MASK_REG_INT3	0x52
-#define PM2XXX_SRCE_REG_INT3	0x62
-#define PM2XXX_REG_INT4		0x43
-#define PM2XXX_MASK_REG_INT4	0x53
-#define PM2XXX_SRCE_REG_INT4	0x63
-#define PM2XXX_REG_INT5		0x44
-#define PM2XXX_MASK_REG_INT5	0x54
-#define PM2XXX_SRCE_REG_INT5	0x64
-#define PM2XXX_REG_INT6		0x45
-#define PM2XXX_MASK_REG_INT6	0x55
-#define PM2XXX_SRCE_REG_INT6	0x65
-
-#define VPWR_OVV 0x0
-#define VSYSTEM_OVV 0x1
-
-/* control Reg 1 */
-#define PM2XXX_CH_RESUME_EN	     0x1
-#define PM2XXX_CH_RESUME_DIS		0x0
-
-/* control Reg 2 */
-#define PM2XXX_CH_AUTO_RESUME_EN	0X2
-#define PM2XXX_CH_AUTO_RESUME_DIS	0X0
-#define PM2XXX_CHARGER_ENA		0x4
-#define PM2XXX_CHARGER_DIS		0x0
-
-/* control Reg 3 */
-#define PM2XXX_CH_WD_CC_PHASE_OFF	0x0
-#define PM2XXX_CH_WD_CC_PHASE_5MIN	0x1
-#define PM2XXX_CH_WD_CC_PHASE_10MIN	0x2
-#define PM2XXX_CH_WD_CC_PHASE_30MIN	0x3
-#define PM2XXX_CH_WD_CC_PHASE_60MIN	0x4
-#define PM2XXX_CH_WD_CC_PHASE_120MIN	0x5
-#define PM2XXX_CH_WD_CC_PHASE_240MIN	0x6
-#define PM2XXX_CH_WD_CC_PHASE_360MIN	0x7
-
-#define PM2XXX_CH_WD_CV_PHASE_OFF	(0x0<<3)
-#define PM2XXX_CH_WD_CV_PHASE_5MIN	(0x1<<3)
-#define PM2XXX_CH_WD_CV_PHASE_10MIN	(0x2<<3)
-#define PM2XXX_CH_WD_CV_PHASE_30MIN	(0x3<<3)
-#define PM2XXX_CH_WD_CV_PHASE_60MIN	(0x4<<3)
-#define PM2XXX_CH_WD_CV_PHASE_120MIN	(0x5<<3)
-#define PM2XXX_CH_WD_CV_PHASE_240MIN	(0x6<<3)
-#define PM2XXX_CH_WD_CV_PHASE_360MIN	(0x7<<3)
-
-/* control Reg 4 */
-#define PM2XXX_CH_WD_PRECH_PHASE_OFF	0x0
-#define PM2XXX_CH_WD_PRECH_PHASE_1MIN	0x1
-#define PM2XXX_CH_WD_PRECH_PHASE_5MIN	0x2
-#define PM2XXX_CH_WD_PRECH_PHASE_10MIN	0x3
-#define PM2XXX_CH_WD_PRECH_PHASE_30MIN	0x4
-#define PM2XXX_CH_WD_PRECH_PHASE_60MIN	0x5
-#define PM2XXX_CH_WD_PRECH_PHASE_120MIN	0x6
-#define PM2XXX_CH_WD_PRECH_PHASE_240MIN	0x7
-
-/* control Reg 5 */
-#define PM2XXX_CH_WD_AUTO_TIMEOUT_NONE	0x0
-#define PM2XXX_CH_WD_AUTO_TIMEOUT_20MIN	0x1
-
-/* control Reg 6 */
-#define PM2XXX_DIR_CH_CC_CURRENT_MASK	0x0F
-#define PM2XXX_DIR_CH_CC_CURRENT_200MA	0x0
-#define PM2XXX_DIR_CH_CC_CURRENT_400MA	0x2
-#define PM2XXX_DIR_CH_CC_CURRENT_600MA	0x3
-#define PM2XXX_DIR_CH_CC_CURRENT_800MA	0x4
-#define PM2XXX_DIR_CH_CC_CURRENT_1000MA	0x5
-#define PM2XXX_DIR_CH_CC_CURRENT_1200MA	0x6
-#define PM2XXX_DIR_CH_CC_CURRENT_1400MA	0x7
-#define PM2XXX_DIR_CH_CC_CURRENT_1600MA	0x8
-#define PM2XXX_DIR_CH_CC_CURRENT_1800MA	0x9
-#define PM2XXX_DIR_CH_CC_CURRENT_2000MA	0xA
-#define PM2XXX_DIR_CH_CC_CURRENT_2200MA	0xB
-#define PM2XXX_DIR_CH_CC_CURRENT_2400MA	0xC
-#define PM2XXX_DIR_CH_CC_CURRENT_2600MA	0xD
-#define PM2XXX_DIR_CH_CC_CURRENT_2800MA	0xE
-#define PM2XXX_DIR_CH_CC_CURRENT_3000MA	0xF
-
-#define PM2XXX_CH_PRECH_CURRENT_MASK	0x30
-#define PM2XXX_CH_PRECH_CURRENT_25MA	(0x0<<4)
-#define PM2XXX_CH_PRECH_CURRENT_50MA	(0x1<<4)
-#define PM2XXX_CH_PRECH_CURRENT_75MA	(0x2<<4)
-#define PM2XXX_CH_PRECH_CURRENT_100MA	(0x3<<4)
-
-#define PM2XXX_CH_EOC_CURRENT_MASK	0xC0
-#define PM2XXX_CH_EOC_CURRENT_100MA	(0x0<<6)
-#define PM2XXX_CH_EOC_CURRENT_150MA	(0x1<<6)
-#define PM2XXX_CH_EOC_CURRENT_300MA	(0x2<<6)
-#define PM2XXX_CH_EOC_CURRENT_400MA	(0x3<<6)
-
-/* control Reg 7 */
-#define PM2XXX_CH_PRECH_VOL_2_5		0x0
-#define PM2XXX_CH_PRECH_VOL_2_7		0x1
-#define PM2XXX_CH_PRECH_VOL_2_9		0x2
-#define PM2XXX_CH_PRECH_VOL_3_1		0x3
-
-#define PM2XXX_CH_VRESUME_VOL_3_2	(0x0<<2)
-#define PM2XXX_CH_VRESUME_VOL_3_4	(0x1<<2)
-#define PM2XXX_CH_VRESUME_VOL_3_6	(0x2<<2)
-#define PM2XXX_CH_VRESUME_VOL_3_8	(0x3<<2)
-
-/* control Reg 8 */
-#define PM2XXX_CH_VOLT_MASK		0x3F
-#define PM2XXX_CH_VOLT_3_5		0x0
-#define PM2XXX_CH_VOLT_3_5225		0x1
-#define PM2XXX_CH_VOLT_3_6		0x4
-#define PM2XXX_CH_VOLT_3_7		0x8
-#define PM2XXX_CH_VOLT_4_0		0x14
-#define PM2XXX_CH_VOLT_4_175		0x1B
-#define PM2XXX_CH_VOLT_4_2		0x1C
-#define PM2XXX_CH_VOLT_4_275		0x1F
-#define PM2XXX_CH_VOLT_4_3		0x20
-
-/*NTC control register 1*/
-#define PM2XXX_BTEMP_HIGH_TH_45		0x0
-#define PM2XXX_BTEMP_HIGH_TH_50		0x1
-#define PM2XXX_BTEMP_HIGH_TH_55		0x2
-#define PM2XXX_BTEMP_HIGH_TH_60		0x3
-#define PM2XXX_BTEMP_HIGH_TH_65		0x4
-
-#define PM2XXX_BTEMP_LOW_TH_N5		(0x0<<3)
-#define PM2XXX_BTEMP_LOW_TH_0		(0x1<<3)
-#define PM2XXX_BTEMP_LOW_TH_5		(0x2<<3)
-#define PM2XXX_BTEMP_LOW_TH_10		(0x3<<3)
-
-/*NTC control register 2*/
-#define PM2XXX_NTC_BETA_COEFF_3477	0x0
-#define PM2XXX_NTC_BETA_COEFF_3964	0x1
-
-#define PM2XXX_NTC_RES_10K		(0x0<<2)
-#define PM2XXX_NTC_RES_47K		(0x1<<2)
-#define PM2XXX_NTC_RES_100K		(0x2<<2)
-#define PM2XXX_NTC_RES_NO_NTC		(0x3<<2)
-
-/* control Reg 9 */
-#define PM2XXX_CH_CC_MODEDROP_EN	1
-#define PM2XXX_CH_CC_MODEDROP_DIS	0
-
-#define PM2XXX_CH_CC_REDUCED_CURRENT_100MA	(0x0<<1)
-#define PM2XXX_CH_CC_REDUCED_CURRENT_200MA	(0x1<<1)
-#define PM2XXX_CH_CC_REDUCED_CURRENT_400MA	(0x2<<1)
-#define PM2XXX_CH_CC_REDUCED_CURRENT_IDENT	(0x3<<1)
-
-#define PM2XXX_CHARCHING_INFO_DIS	(0<<3)
-#define PM2XXX_CHARCHING_INFO_EN	(1<<3)
-
-#define PM2XXX_CH_150MV_DROP_300MV	(0<<4)
-#define PM2XXX_CH_150MV_DROP_150MV	(1<<4)
-
-
-/* charger status register */
-#define PM2XXX_CHG_STATUS_OFF		0x0
-#define PM2XXX_CHG_STATUS_ON		0x1
-#define PM2XXX_CHG_STATUS_FULL		0x2
-#define PM2XXX_CHG_STATUS_ERR		0x3
-#define PM2XXX_CHG_STATUS_WAIT		0x4
-#define PM2XXX_CHG_STATUS_NOBAT		0x5
-
-/* Input charger voltage VPWR2 */
-#define PM2XXX_VPWR2_OVV_6_0		0x0
-#define PM2XXX_VPWR2_OVV_6_3		0x1
-#define PM2XXX_VPWR2_OVV_10		0x2
-#define PM2XXX_VPWR2_OVV_NONE		0x3
-
-/* Input charger voltage VPWR1 */
-#define PM2XXX_VPWR1_OVV_6_0		0x0
-#define PM2XXX_VPWR1_OVV_6_3		0x1
-#define PM2XXX_VPWR1_OVV_10		0x2
-#define PM2XXX_VPWR1_OVV_NONE		0x3
-
-/* Battery low level comparator control register */
-#define PM2XXX_VBAT_LOW_MONITORING_DIS	0x0
-#define PM2XXX_VBAT_LOW_MONITORING_ENA	0x1
-
-/* Battery low level value control register */
-#define PM2XXX_VBAT_LOW_LEVEL_2_3	0x0
-#define PM2XXX_VBAT_LOW_LEVEL_2_4	0x1
-#define PM2XXX_VBAT_LOW_LEVEL_2_5	0x2
-#define PM2XXX_VBAT_LOW_LEVEL_2_6	0x3
-#define PM2XXX_VBAT_LOW_LEVEL_2_7	0x4
-#define PM2XXX_VBAT_LOW_LEVEL_2_8	0x5
-#define PM2XXX_VBAT_LOW_LEVEL_2_9	0x6
-#define PM2XXX_VBAT_LOW_LEVEL_3_0	0x7
-#define PM2XXX_VBAT_LOW_LEVEL_3_1	0x8
-#define PM2XXX_VBAT_LOW_LEVEL_3_2	0x9
-#define PM2XXX_VBAT_LOW_LEVEL_3_3	0xA
-#define PM2XXX_VBAT_LOW_LEVEL_3_4	0xB
-#define PM2XXX_VBAT_LOW_LEVEL_3_5	0xC
-#define PM2XXX_VBAT_LOW_LEVEL_3_6	0xD
-#define PM2XXX_VBAT_LOW_LEVEL_3_7	0xE
-#define PM2XXX_VBAT_LOW_LEVEL_3_8	0xF
-#define PM2XXX_VBAT_LOW_LEVEL_3_9	0x10
-#define PM2XXX_VBAT_LOW_LEVEL_4_0	0x11
-#define PM2XXX_VBAT_LOW_LEVEL_4_1	0x12
-#define PM2XXX_VBAT_LOW_LEVEL_4_2	0x13
-
-/* SW CTRL */
-#define PM2XXX_SWCTRL_HW		0x0
-#define PM2XXX_SWCTRL_SW		0x1
-
-
-/* LED Driver Control */
-#define PM2XXX_LED_CURRENT_MASK		0x0C
-#define PM2XXX_LED_CURRENT_2_5MA	(0X0<<2)
-#define PM2XXX_LED_CURRENT_1MA		(0X1<<2)
-#define PM2XXX_LED_CURRENT_5MA		(0X2<<2)
-#define PM2XXX_LED_CURRENT_10MA		(0X3<<2)
-
-#define PM2XXX_LED_SELECT_MASK		0x02
-#define PM2XXX_LED_SELECT_EN		(0X0<<1)
-#define PM2XXX_LED_SELECT_DIS		(0X1<<1)
-
-#define PM2XXX_ANTI_OVERSHOOT_MASK	0x01
-#define PM2XXX_ANTI_OVERSHOOT_DIS	0X0
-#define PM2XXX_ANTI_OVERSHOOT_EN	0X1
+#include "pm2301_charger.h"
 
 #define to_pm2xxx_charger_ac_device_info(x) container_of((x), \
 		struct pm2xxx_charger, ac_chg)
@@ -321,148 +43,6 @@ static int pm2xxx_interrupt_registers[] = {
 	PM2XXX_REG_INT6,
 };
 
-enum pm2xxx_reg_int1 {
-	PM2XXX_INT1_ITVBATDISCONNECT	= 0x02,
-	PM2XXX_INT1_ITVBATLOWR		= 0x04,
-	PM2XXX_INT1_ITVBATLOWF		= 0x08,
-};
-
-enum pm2xxx_mask_reg_int1 {
-	PM2XXX_INT1_M_ITVBATDISCONNECT	= 0x02,
-	PM2XXX_INT1_M_ITVBATLOWR	= 0x04,
-	PM2XXX_INT1_M_ITVBATLOWF	= 0x08,
-};
-
-enum pm2xxx_source_reg_int1 {
-	PM2XXX_INT1_S_ITVBATDISCONNECT	= 0x02,
-	PM2XXX_INT1_S_ITVBATLOWR	= 0x04,
-	PM2XXX_INT1_S_ITVBATLOWF	= 0x08,
-};
-
-enum pm2xxx_reg_int2 {
-	PM2XXX_INT2_ITVPWR2PLUG		= 0x01,
-	PM2XXX_INT2_ITVPWR2UNPLUG	= 0x02,
-	PM2XXX_INT2_ITVPWR1PLUG		= 0x04,
-	PM2XXX_INT2_ITVPWR1UNPLUG	= 0x08,
-};
-
-enum pm2xxx_mask_reg_int2 {
-	PM2XXX_INT2_M_ITVPWR2PLUG	= 0x01,
-	PM2XXX_INT2_M_ITVPWR2UNPLUG	= 0x02,
-	PM2XXX_INT2_M_ITVPWR1PLUG	= 0x04,
-	PM2XXX_INT2_M_ITVPWR1UNPLUG	= 0x08,
-};
-
-enum pm2xxx_source_reg_int2 {
-	PM2XXX_INT2_S_ITVPWR2PLUG	= 0x03,
-	PM2XXX_INT2_S_ITVPWR1PLUG	= 0x0c,
-};
-
-enum pm2xxx_reg_int3 {
-	PM2XXX_INT3_ITCHPRECHARGEWD	= 0x01,
-	PM2XXX_INT3_ITCHCCWD		= 0x02,
-	PM2XXX_INT3_ITCHCVWD		= 0x04,
-	PM2XXX_INT3_ITAUTOTIMEOUTWD	= 0x08,
-};
-
-enum pm2xxx_mask_reg_int3 {
-	PM2XXX_INT3_M_ITCHPRECHARGEWD	= 0x01,
-	PM2XXX_INT3_M_ITCHCCWD		= 0x02,
-	PM2XXX_INT3_M_ITCHCVWD		= 0x04,
-	PM2XXX_INT3_M_ITAUTOTIMEOUTWD	= 0x08,
-};
-
-enum pm2xxx_source_reg_int3 {
-	PM2XXX_INT3_S_ITCHPRECHARGEWD	= 0x01,
-	PM2XXX_INT3_S_ITCHCCWD		= 0x02,
-	PM2XXX_INT3_S_ITCHCVWD		= 0x04,
-	PM2XXX_INT3_S_ITAUTOTIMEOUTWD	= 0x08,
-};
-
-enum pm2xxx_reg_int4 {
-	PM2XXX_INT4_ITBATTEMPCOLD	= 0x01,
-	PM2XXX_INT4_ITBATTEMPHOT	= 0x02,
-	PM2XXX_INT4_ITVPWR2OVV		= 0x04,
-	PM2XXX_INT4_ITVPWR1OVV		= 0x08,
-	PM2XXX_INT4_ITCHARGINGON	= 0x10,
-	PM2XXX_INT4_ITVRESUME		= 0x20,
-	PM2XXX_INT4_ITBATTFULL		= 0x40,
-	PM2XXX_INT4_ITCVPHASE		= 0x80,
-};
-
-enum pm2xxx_mask_reg_int4 {
-	PM2XXX_INT4_M_ITBATTEMPCOLD	= 0x01,
-	PM2XXX_INT4_M_ITBATTEMPHOT	= 0x02,
-	PM2XXX_INT4_M_ITVPWR2OVV	= 0x04,
-	PM2XXX_INT4_M_ITVPWR1OVV	= 0x08,
-	PM2XXX_INT4_M_ITCHARGINGON	= 0x10,
-	PM2XXX_INT4_M_ITVRESUME		= 0x20,
-	PM2XXX_INT4_M_ITBATTFULL	= 0x40,
-	PM2XXX_INT4_M_ITCVPHASE		= 0x80,
-};
-
-enum pm2xxx_source_reg_int4 {
-	PM2XXX_INT4_S_ITBATTEMPCOLD	= 0x01,
-	PM2XXX_INT4_S_ITBATTEMPHOT	= 0x02,
-	PM2XXX_INT4_S_ITVPWR2OVV	= 0x04,
-	PM2XXX_INT4_S_ITVPWR1OVV	= 0x08,
-	PM2XXX_INT4_S_ITCHARGINGON	= 0x10,
-	PM2XXX_INT4_S_ITVRESUME		= 0x20,
-	PM2XXX_INT4_S_ITBATTFULL	= 0x40,
-	PM2XXX_INT4_S_ITCVPHASE		= 0x80,
-};
-
-enum pm2xxx_reg_int5 {
-	PM2XXX_INT5_ITTHERMALSHUTDOWNRISE	= 0x01,
-	PM2XXX_INT5_ITTHERMALSHUTDOWNFALL	= 0x02,
-	PM2XXX_INT5_ITTHERMALWARNINGRISE	= 0x04,
-	PM2XXX_INT5_ITTHERMALWARNINGFALL	= 0x08,
-	PM2XXX_INT5_ITVSYSTEMOVV		= 0x10,
-};
-
-enum pm2xxx_mask_reg_int5 {
-	PM2XXX_INT5_M_ITTHERMALSHUTDOWNRISE	= 0x01,
-	PM2XXX_INT5_M_ITTHERMALSHUTDOWNFALL	= 0x02,
-	PM2XXX_INT5_M_ITTHERMALWARNINGRISE	= 0x04,
-	PM2XXX_INT5_M_ITTHERMALWARNINGFALL	= 0x08,
-	PM2XXX_INT5_M_ITVSYSTEMOVV		= 0x10,
-};
-
-enum pm2xxx_source_reg_int5 {
-	PM2XXX_INT5_S_ITTHERMALSHUTDOWNRISE	= 0x01,
-	PM2XXX_INT5_S_ITTHERMALSHUTDOWNFALL	= 0x02,
-	PM2XXX_INT5_S_ITTHERMALWARNINGRISE	= 0x04,
-	PM2XXX_INT5_S_ITTHERMALWARNINGFALL	= 0x08,
-	PM2XXX_INT5_S_ITVSYSTEMOVV		= 0x10,
-};
-
-enum pm2xxx_reg_int6 {
-	PM2XXX_INT6_ITVPWR2DROP		= 0x01,
-	PM2XXX_INT6_ITVPWR1DROP		= 0x02,
-	PM2XXX_INT6_ITVPWR2VALIDRISE	= 0x04,
-	PM2XXX_INT6_ITVPWR2VALIDFALL	= 0x08,
-	PM2XXX_INT6_ITVPWR1VALIDRISE	= 0x10,
-	PM2XXX_INT6_ITVPWR1VALIDFALL	= 0x20,
-};
-
-enum pm2xxx_mask_reg_int6 {
-	PM2XXX_INT6_M_ITVPWR2DROP	= 0x01,
-	PM2XXX_INT6_M_ITVPWR1DROP	= 0x02,
-	PM2XXX_INT6_M_ITVPWR2VALIDRISE	= 0x04,
-	PM2XXX_INT6_M_ITVPWR2VALIDFALL	= 0x08,
-	PM2XXX_INT6_M_ITVPWR1VALIDRISE	= 0x10,
-	PM2XXX_INT6_M_ITVPWR1VALIDFALL	= 0x20,
-};
-
-enum pm2xxx_source_reg_int6 {
-	PM2XXX_INT6_S_ITVPWR2DROP	= 0x01,
-	PM2XXX_INT6_S_ITVPWR1DROP	= 0x02,
-	PM2XXX_INT6_S_ITVPWR2VALIDRISE	= 0x04,
-	PM2XXX_INT6_S_ITVPWR2VALIDFALL	= 0x08,
-	PM2XXX_INT6_S_ITVPWR1VALIDRISE	= 0x10,
-	PM2XXX_INT6_S_ITVPWR1VALIDFALL	= 0x20,
-};
-
 static enum power_supply_property pm2xxx_charger_ac_props[] = {
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -527,64 +107,12 @@ static int pm2xxx_charger_current_map[] = {
 	3000,
 };
 
-struct pm2xxx_irq {
-	char *name;
-	irqreturn_t (*isr)(int irq, void *data);
-};
-
-struct pm2xxx_charger_info {
-	int charger_connected;
-	int charger_online;
-	int charger_voltage;
-	int cv_active;
-	bool wd_expired;
-};
-
-struct pm2xxx_charger_event_flags {
-	bool mainextchnotok;
-	bool main_thermal_prot;
-	bool ovv;
-	bool chgwdexp;
-};
-
-struct pm2xxx_config {
-	struct i2c_client *pm2xxx_i2c;
-	struct i2c_device_id *pm2xxx_id;
-};
-
-struct pm2xxx_charger {
-	struct device *dev;
-	u8 chip_id;
-	bool vddadc_en_ac;
-	struct pm2xxx_config config;
-	bool ac_conn;
-	unsigned int gpio_irq;
-	int vbat;
-	int old_vbat;
-	int failure_case;
-	int failure_input_ovv;
-	u8 pm2_int[6];
-	struct ab8500_gpadc *gpadc;
-	struct regulator *regu;
-	struct pm2xxx_bm_data *bat;
-	struct mutex lock;
-	struct ab8500 *parent;
-	struct pm2xxx_charger_info ac;
-	struct pm2xxx_charger_platform_data *pdata;
-	struct workqueue_struct *charger_wq;
-	struct delayed_work check_vbat_work;
-	struct work_struct ac_work;
-	struct work_struct check_main_thermal_prot_work;
-	struct ux500_charger ac_chg;
-	struct pm2xxx_charger_event_flags flags;
-};
-
 static const struct i2c_device_id pm2xxx_ident[] = {
 	{ "pm2301", 0 },
 	{ }
 };
 
-static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
+int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 {
 	int ret;
 
@@ -596,7 +124,7 @@ static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val)
 	return ret;
 }
 
-static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
+int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
 {
 	int ret;
 
@@ -1376,8 +904,16 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		sysfs_notify(&pm2->ac_chg.psy.dev->kobj, NULL, "present");
 	}
 
+	ret = pm2xxx_ddbg_init(pm2);
+	if (ret)
+		goto err_deep_debug;
+
 	return 0;
 
+err_deep_debug:
+	/* disable interrupt */
+	free_irq(pm2->pdata->irq_number, pm2);
+
 unregister_pm2xxx_charger:
 	/* unregister power supply */
 	power_supply_unregister(&pm2->ac_chg.psy);
@@ -1404,6 +940,8 @@ static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 	/* Delete the work queue */
 	destroy_workqueue(pm2->charger_wq);
 
+	pm2xxx_ddbg_exit();
+
 	flush_scheduled_work();
 
 	/* disable the regulator */
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
new file mode 100644
index 0000000..27bf931
--- /dev/null
+++ b/drivers/power/pm2301_charger.h
@@ -0,0 +1,508 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2012
+ *
+ * PM2301 power supply interface
+ *
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef PM2301_CHARGER_H
+#define PM2301_CHARGER_H
+
+#define MAIN_WDOG_ENA			0x01
+#define MAIN_WDOG_KICK			0x02
+#define MAIN_WDOG_DIS			0x00
+#define CHARG_WD_KICK			0x01
+#define MAIN_CH_ENA			0x01
+#define MAIN_CH_NO_OVERSHOOT_ENA_N	0x02
+#define MAIN_CH_DET			0x01
+#define MAIN_CH_CV_ON			0x04
+#define OTP_ENABLE_WD			0x01
+
+#define MAIN_CH_INPUT_CURR_SHIFT	4
+
+#define LED_INDICATOR_PWM_ENA		0x01
+#define LED_INDICATOR_PWM_DIS		0x00
+#define LED_IND_CUR_5MA			0x04
+#define LED_INDICATOR_PWM_DUTY_252_256	0xBF
+
+/* HW failure constants */
+#define MAIN_CH_TH_PROT			0x02
+#define MAIN_CH_NOK			0x01
+
+/* Watchdog timeout constant */
+#define WD_TIMER			0x30 /* 4min */
+#define WD_KICK_INTERVAL		(60 * HZ)
+
+/* Constant voltage/current */
+#define PM2XXX_CONST_CURR		0x0
+#define PM2XXX_CONST_VOLT		0x1
+
+/* Lowest charger voltage is 3.39V -> 0x4E */
+#define LOW_VOLT_REG			0x4E
+
+#define PM2XXX_BATT_CTRL_REG1		0x00
+#define PM2XXX_BATT_CTRL_REG2		0x01
+#define PM2XXX_BATT_CTRL_REG3		0x02
+#define PM2XXX_BATT_CTRL_REG4		0x03
+#define PM2XXX_BATT_CTRL_REG5		0x04
+#define PM2XXX_BATT_CTRL_REG6		0x05
+#define PM2XXX_BATT_CTRL_REG7		0x06
+#define PM2XXX_BATT_CTRL_REG8		0x07
+#define PM2XXX_NTC_CTRL_REG1		0x08
+#define PM2XXX_NTC_CTRL_REG2		0x09
+#define PM2XXX_BATT_CTRL_REG9		0x0A
+#define PM2XXX_BATT_STAT_REG1		0x0B
+#define PM2XXX_INP_VOLT_VPWR2		0x11
+#define PM2XXX_INP_DROP_VPWR2		0x13
+#define PM2XXX_INP_VOLT_VPWR1		0x15
+#define PM2XXX_INP_DROP_VPWR1		0x17
+#define PM2XXX_INP_MODE_VPWR		0x18
+#define PM2XXX_BATT_WD_KICK		0x70
+#define PM2XXX_DEV_VER_STAT		0x0C
+#define PM2XXX_THERM_WARN_CTRL_REG	0x20
+#define PM2XXX_BATT_DISC_REG		0x21
+#define PM2XXX_BATT_LOW_LEV_COMP_REG	0x22
+#define PM2XXX_BATT_LOW_LEV_VAL_REG	0x23
+#define PM2XXX_I2C_PAD_CTRL_REG		0x24
+#define PM2XXX_SW_CTRL_REG		0x26
+#define PM2XXX_LED_CTRL_REG		0x28
+
+#define PM2XXX_REG_INT1			0x40
+#define PM2XXX_MASK_REG_INT1		0x50
+#define PM2XXX_SRCE_REG_INT1		0x60
+#define PM2XXX_REG_INT2			0x41
+#define PM2XXX_MASK_REG_INT2		0x51
+#define PM2XXX_SRCE_REG_INT2		0x61
+#define PM2XXX_REG_INT3			0x42
+#define PM2XXX_MASK_REG_INT3		0x52
+#define PM2XXX_SRCE_REG_INT3		0x62
+#define PM2XXX_REG_INT4			0x43
+#define PM2XXX_MASK_REG_INT4		0x53
+#define PM2XXX_SRCE_REG_INT4		0x63
+#define PM2XXX_REG_INT5			0x44
+#define PM2XXX_MASK_REG_INT5		0x54
+#define PM2XXX_SRCE_REG_INT5		0x64
+#define PM2XXX_REG_INT6			0x45
+#define PM2XXX_MASK_REG_INT6		0x55
+#define PM2XXX_SRCE_REG_INT6		0x65
+
+#define VPWR_OVV			0x0
+#define VSYSTEM_OVV			0x1
+
+/* control Reg 1 */
+#define PM2XXX_CH_RESUME_EN		0x1
+#define PM2XXX_CH_RESUME_DIS		0x0
+
+/* control Reg 2 */
+#define PM2XXX_CH_AUTO_RESUME_EN	0X2
+#define PM2XXX_CH_AUTO_RESUME_DIS	0X0
+#define PM2XXX_CHARGER_ENA		0x4
+#define PM2XXX_CHARGER_DIS		0x0
+
+/* control Reg 3 */
+#define PM2XXX_CH_WD_CC_PHASE_OFF	0x0
+#define PM2XXX_CH_WD_CC_PHASE_5MIN	0x1
+#define PM2XXX_CH_WD_CC_PHASE_10MIN	0x2
+#define PM2XXX_CH_WD_CC_PHASE_30MIN	0x3
+#define PM2XXX_CH_WD_CC_PHASE_60MIN	0x4
+#define PM2XXX_CH_WD_CC_PHASE_120MIN	0x5
+#define PM2XXX_CH_WD_CC_PHASE_240MIN	0x6
+#define PM2XXX_CH_WD_CC_PHASE_360MIN	0x7
+
+#define PM2XXX_CH_WD_CV_PHASE_OFF	(0x0<<3)
+#define PM2XXX_CH_WD_CV_PHASE_5MIN	(0x1<<3)
+#define PM2XXX_CH_WD_CV_PHASE_10MIN	(0x2<<3)
+#define PM2XXX_CH_WD_CV_PHASE_30MIN	(0x3<<3)
+#define PM2XXX_CH_WD_CV_PHASE_60MIN	(0x4<<3)
+#define PM2XXX_CH_WD_CV_PHASE_120MIN	(0x5<<3)
+#define PM2XXX_CH_WD_CV_PHASE_240MIN	(0x6<<3)
+#define PM2XXX_CH_WD_CV_PHASE_360MIN	(0x7<<3)
+
+/* control Reg 4 */
+#define PM2XXX_CH_WD_PRECH_PHASE_OFF	0x0
+#define PM2XXX_CH_WD_PRECH_PHASE_1MIN	0x1
+#define PM2XXX_CH_WD_PRECH_PHASE_5MIN	0x2
+#define PM2XXX_CH_WD_PRECH_PHASE_10MIN	0x3
+#define PM2XXX_CH_WD_PRECH_PHASE_30MIN	0x4
+#define PM2XXX_CH_WD_PRECH_PHASE_60MIN	0x5
+#define PM2XXX_CH_WD_PRECH_PHASE_120MIN	0x6
+#define PM2XXX_CH_WD_PRECH_PHASE_240MIN	0x7
+
+/* control Reg 5 */
+#define PM2XXX_CH_WD_AUTO_TIMEOUT_NONE	0x0
+#define PM2XXX_CH_WD_AUTO_TIMEOUT_20MIN	0x1
+
+/* control Reg 6 */
+#define PM2XXX_DIR_CH_CC_CURRENT_MASK	0x0F
+#define PM2XXX_DIR_CH_CC_CURRENT_200MA	0x0
+#define PM2XXX_DIR_CH_CC_CURRENT_400MA	0x2
+#define PM2XXX_DIR_CH_CC_CURRENT_600MA	0x3
+#define PM2XXX_DIR_CH_CC_CURRENT_800MA	0x4
+#define PM2XXX_DIR_CH_CC_CURRENT_1000MA	0x5
+#define PM2XXX_DIR_CH_CC_CURRENT_1200MA	0x6
+#define PM2XXX_DIR_CH_CC_CURRENT_1400MA	0x7
+#define PM2XXX_DIR_CH_CC_CURRENT_1600MA	0x8
+#define PM2XXX_DIR_CH_CC_CURRENT_1800MA	0x9
+#define PM2XXX_DIR_CH_CC_CURRENT_2000MA	0xA
+#define PM2XXX_DIR_CH_CC_CURRENT_2200MA	0xB
+#define PM2XXX_DIR_CH_CC_CURRENT_2400MA	0xC
+#define PM2XXX_DIR_CH_CC_CURRENT_2600MA	0xD
+#define PM2XXX_DIR_CH_CC_CURRENT_2800MA	0xE
+#define PM2XXX_DIR_CH_CC_CURRENT_3000MA	0xF
+
+#define PM2XXX_CH_PRECH_CURRENT_MASK	0x30
+#define PM2XXX_CH_PRECH_CURRENT_25MA	(0x0<<4)
+#define PM2XXX_CH_PRECH_CURRENT_50MA	(0x1<<4)
+#define PM2XXX_CH_PRECH_CURRENT_75MA	(0x2<<4)
+#define PM2XXX_CH_PRECH_CURRENT_100MA	(0x3<<4)
+
+#define PM2XXX_CH_EOC_CURRENT_MASK	0xC0
+#define PM2XXX_CH_EOC_CURRENT_100MA	(0x0<<6)
+#define PM2XXX_CH_EOC_CURRENT_150MA	(0x1<<6)
+#define PM2XXX_CH_EOC_CURRENT_300MA	(0x2<<6)
+#define PM2XXX_CH_EOC_CURRENT_400MA	(0x3<<6)
+
+/* control Reg 7 */
+#define PM2XXX_CH_PRECH_VOL_2_5		0x0
+#define PM2XXX_CH_PRECH_VOL_2_7		0x1
+#define PM2XXX_CH_PRECH_VOL_2_9		0x2
+#define PM2XXX_CH_PRECH_VOL_3_1		0x3
+
+#define PM2XXX_CH_VRESUME_VOL_3_2	(0x0<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_4	(0x1<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_6	(0x2<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_8	(0x3<<2)
+
+/* control Reg 8 */
+#define PM2XXX_CH_VOLT_MASK		0x3F
+#define PM2XXX_CH_VOLT_3_5		0x0
+#define PM2XXX_CH_VOLT_3_5225		0x1
+#define PM2XXX_CH_VOLT_3_6		0x4
+#define PM2XXX_CH_VOLT_3_7		0x8
+#define PM2XXX_CH_VOLT_4_0		0x14
+#define PM2XXX_CH_VOLT_4_175		0x1B
+#define PM2XXX_CH_VOLT_4_2		0x1C
+#define PM2XXX_CH_VOLT_4_275		0x1F
+#define PM2XXX_CH_VOLT_4_3		0x20
+
+/*NTC control register 1*/
+#define PM2XXX_BTEMP_HIGH_TH_45		0x0
+#define PM2XXX_BTEMP_HIGH_TH_50		0x1
+#define PM2XXX_BTEMP_HIGH_TH_55		0x2
+#define PM2XXX_BTEMP_HIGH_TH_60		0x3
+#define PM2XXX_BTEMP_HIGH_TH_65		0x4
+
+#define PM2XXX_BTEMP_LOW_TH_N5		(0x0<<3)
+#define PM2XXX_BTEMP_LOW_TH_0		(0x1<<3)
+#define PM2XXX_BTEMP_LOW_TH_5		(0x2<<3)
+#define PM2XXX_BTEMP_LOW_TH_10		(0x3<<3)
+
+/*NTC control register 2*/
+#define PM2XXX_NTC_BETA_COEFF_3477	0x0
+#define PM2XXX_NTC_BETA_COEFF_3964	0x1
+
+#define PM2XXX_NTC_RES_10K		(0x0<<2)
+#define PM2XXX_NTC_RES_47K		(0x1<<2)
+#define PM2XXX_NTC_RES_100K		(0x2<<2)
+#define PM2XXX_NTC_RES_NO_NTC		(0x3<<2)
+
+/* control Reg 9 */
+#define PM2XXX_CH_CC_MODEDROP_EN	1
+#define PM2XXX_CH_CC_MODEDROP_DIS	0
+
+#define PM2XXX_CH_CC_REDUCED_CURRENT_100MA	(0x0<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_200MA	(0x1<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_400MA	(0x2<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_IDENT	(0x3<<1)
+
+#define PM2XXX_CHARCHING_INFO_DIS	(0<<3)
+#define PM2XXX_CHARCHING_INFO_EN	(1<<3)
+
+#define PM2XXX_CH_150MV_DROP_300MV	(0<<4)
+#define PM2XXX_CH_150MV_DROP_150MV	(1<<4)
+
+
+/* charger status register */
+#define PM2XXX_CHG_STATUS_OFF		0x0
+#define PM2XXX_CHG_STATUS_ON		0x1
+#define PM2XXX_CHG_STATUS_FULL		0x2
+#define PM2XXX_CHG_STATUS_ERR		0x3
+#define PM2XXX_CHG_STATUS_WAIT		0x4
+#define PM2XXX_CHG_STATUS_NOBAT		0x5
+
+/* Input charger voltage VPWR2 */
+#define PM2XXX_VPWR2_OVV_6_0		0x0
+#define PM2XXX_VPWR2_OVV_6_3		0x1
+#define PM2XXX_VPWR2_OVV_10		0x2
+#define PM2XXX_VPWR2_OVV_NONE		0x3
+
+/* Input charger voltage VPWR1 */
+#define PM2XXX_VPWR1_OVV_6_0		0x0
+#define PM2XXX_VPWR1_OVV_6_3		0x1
+#define PM2XXX_VPWR1_OVV_10		0x2
+#define PM2XXX_VPWR1_OVV_NONE		0x3
+
+/* Battery low level comparator control register */
+#define PM2XXX_VBAT_LOW_MONITORING_DIS	0x0
+#define PM2XXX_VBAT_LOW_MONITORING_ENA	0x1
+
+/* Battery low level value control register */
+#define PM2XXX_VBAT_LOW_LEVEL_2_3	0x0
+#define PM2XXX_VBAT_LOW_LEVEL_2_4	0x1
+#define PM2XXX_VBAT_LOW_LEVEL_2_5	0x2
+#define PM2XXX_VBAT_LOW_LEVEL_2_6	0x3
+#define PM2XXX_VBAT_LOW_LEVEL_2_7	0x4
+#define PM2XXX_VBAT_LOW_LEVEL_2_8	0x5
+#define PM2XXX_VBAT_LOW_LEVEL_2_9	0x6
+#define PM2XXX_VBAT_LOW_LEVEL_3_0	0x7
+#define PM2XXX_VBAT_LOW_LEVEL_3_1	0x8
+#define PM2XXX_VBAT_LOW_LEVEL_3_2	0x9
+#define PM2XXX_VBAT_LOW_LEVEL_3_3	0xA
+#define PM2XXX_VBAT_LOW_LEVEL_3_4	0xB
+#define PM2XXX_VBAT_LOW_LEVEL_3_5	0xC
+#define PM2XXX_VBAT_LOW_LEVEL_3_6	0xD
+#define PM2XXX_VBAT_LOW_LEVEL_3_7	0xE
+#define PM2XXX_VBAT_LOW_LEVEL_3_8	0xF
+#define PM2XXX_VBAT_LOW_LEVEL_3_9	0x10
+#define PM2XXX_VBAT_LOW_LEVEL_4_0	0x11
+#define PM2XXX_VBAT_LOW_LEVEL_4_1	0x12
+#define PM2XXX_VBAT_LOW_LEVEL_4_2	0x13
+
+/* SW CTRL */
+#define PM2XXX_SWCTRL_HW		0x0
+#define PM2XXX_SWCTRL_SW		0x1
+
+
+/* LED Driver Control */
+#define PM2XXX_LED_CURRENT_MASK		0x0C
+#define PM2XXX_LED_CURRENT_2_5MA	(0X0<<2)
+#define PM2XXX_LED_CURRENT_1MA		(0X1<<2)
+#define PM2XXX_LED_CURRENT_5MA		(0X2<<2)
+#define PM2XXX_LED_CURRENT_10MA		(0X3<<2)
+
+#define PM2XXX_LED_SELECT_MASK		0x02
+#define PM2XXX_LED_SELECT_EN		(0X0<<1)
+#define PM2XXX_LED_SELECT_DIS		(0X1<<1)
+
+#define PM2XXX_ANTI_OVERSHOOT_MASK	0x01
+#define PM2XXX_ANTI_OVERSHOOT_DIS	0X0
+#define PM2XXX_ANTI_OVERSHOOT_EN	0X1
+
+enum pm2xxx_reg_int1 {
+	PM2XXX_INT1_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_ITVBATLOWR		= 0x04,
+	PM2XXX_INT1_ITVBATLOWF		= 0x08,
+};
+
+enum pm2xxx_mask_reg_int1 {
+	PM2XXX_INT1_M_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_M_ITVBATLOWR	= 0x04,
+	PM2XXX_INT1_M_ITVBATLOWF	= 0x08,
+};
+
+enum pm2xxx_source_reg_int1 {
+	PM2XXX_INT1_S_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_S_ITVBATLOWR	= 0x04,
+	PM2XXX_INT1_S_ITVBATLOWF	= 0x08,
+};
+
+enum pm2xxx_reg_int2 {
+	PM2XXX_INT2_ITVPWR2PLUG		= 0x01,
+	PM2XXX_INT2_ITVPWR2UNPLUG	= 0x02,
+	PM2XXX_INT2_ITVPWR1PLUG		= 0x04,
+	PM2XXX_INT2_ITVPWR1UNPLUG	= 0x08,
+};
+
+enum pm2xxx_mask_reg_int2 {
+	PM2XXX_INT2_M_ITVPWR2PLUG	= 0x01,
+	PM2XXX_INT2_M_ITVPWR2UNPLUG	= 0x02,
+	PM2XXX_INT2_M_ITVPWR1PLUG	= 0x04,
+	PM2XXX_INT2_M_ITVPWR1UNPLUG	= 0x08,
+};
+
+enum pm2xxx_source_reg_int2 {
+	PM2XXX_INT2_S_ITVPWR2PLUG	= 0x03,
+	PM2XXX_INT2_S_ITVPWR1PLUG	= 0x0c,
+};
+
+enum pm2xxx_reg_int3 {
+	PM2XXX_INT3_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_mask_reg_int3 {
+	PM2XXX_INT3_M_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_M_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_M_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_M_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_source_reg_int3 {
+	PM2XXX_INT3_S_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_S_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_S_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_S_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_reg_int4 {
+	PM2XXX_INT4_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_ITVPWR2OVV		= 0x04,
+	PM2XXX_INT4_ITVPWR1OVV		= 0x08,
+	PM2XXX_INT4_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_ITVRESUME		= 0x20,
+	PM2XXX_INT4_ITBATTFULL		= 0x40,
+	PM2XXX_INT4_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_mask_reg_int4 {
+	PM2XXX_INT4_M_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_M_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_M_ITVPWR2OVV	= 0x04,
+	PM2XXX_INT4_M_ITVPWR1OVV	= 0x08,
+	PM2XXX_INT4_M_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_M_ITVRESUME		= 0x20,
+	PM2XXX_INT4_M_ITBATTFULL	= 0x40,
+	PM2XXX_INT4_M_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_source_reg_int4 {
+	PM2XXX_INT4_S_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_S_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_S_ITVPWR2OVV	= 0x04,
+	PM2XXX_INT4_S_ITVPWR1OVV	= 0x08,
+	PM2XXX_INT4_S_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_S_ITVRESUME		= 0x20,
+	PM2XXX_INT4_S_ITBATTFULL	= 0x40,
+	PM2XXX_INT4_S_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_reg_int5 {
+	PM2XXX_INT5_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_mask_reg_int5 {
+	PM2XXX_INT5_M_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_M_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_M_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_M_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_M_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_source_reg_int5 {
+	PM2XXX_INT5_S_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_S_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_S_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_S_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_S_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_reg_int6 {
+	PM2XXX_INT6_ITVPWR2DROP		= 0x01,
+	PM2XXX_INT6_ITVPWR1DROP		= 0x02,
+	PM2XXX_INT6_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_ITVPWR1VALIDFALL	= 0x20,
+};
+
+enum pm2xxx_mask_reg_int6 {
+	PM2XXX_INT6_M_ITVPWR2DROP	= 0x01,
+	PM2XXX_INT6_M_ITVPWR1DROP	= 0x02,
+	PM2XXX_INT6_M_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_M_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_M_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_M_ITVPWR1VALIDFALL	= 0x20,
+};
+
+enum pm2xxx_source_reg_int6 {
+	PM2XXX_INT6_S_ITVPWR2DROP	= 0x01,
+	PM2XXX_INT6_S_ITVPWR1DROP	= 0x02,
+	PM2XXX_INT6_S_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_S_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_S_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_S_ITVPWR1VALIDFALL	= 0x20,
+};
+
+struct pm2xxx_charger_info {
+	int charger_connected;
+	int charger_online;
+	int charger_voltage;
+	int cv_active;
+	bool wd_expired;
+};
+
+struct pm2xxx_charger_event_flags {
+	bool mainextchnotok;
+	bool main_thermal_prot;
+	bool ovv;
+	bool chgwdexp;
+};
+
+struct pm2xxx_config {
+	struct i2c_client *pm2xxx_i2c;
+	struct i2c_device_id *pm2xxx_id;
+};
+
+struct pm2xxx_irq {
+	char *name;
+	irqreturn_t (*isr)(int irq, void *data);
+};
+
+struct pm2xxx_charger {
+	struct device *dev;
+	u8 chip_id;
+	bool vddadc_en_ac;
+	struct pm2xxx_config config;
+	bool ac_conn;
+	unsigned int gpio_irq;
+	int vbat;
+	int old_vbat;
+	int failure_case;
+	int failure_input_ovv;
+	u8 pm2_int[6];
+	struct ab8500_gpadc *gpadc;
+	struct regulator *regu;
+	struct pm2xxx_bm_data *bat;
+	struct mutex lock;
+	struct ab8500 *parent;
+	struct pm2xxx_charger_info ac;
+	struct pm2xxx_charger_platform_data *pdata;
+	struct workqueue_struct *charger_wq;
+	struct delayed_work check_vbat_work;
+	struct work_struct ac_work;
+	struct work_struct check_main_thermal_prot_work;
+	struct ux500_charger ac_chg;
+	struct pm2xxx_charger_event_flags flags;
+};
+
+int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg, u8 *val);
+int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val);
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+
+int pm2xxx_ddbg_init(struct pm2xxx_charger *pm2);
+int pm2xxx_ddbg_exit(void);
+
+#else /* CONFIG_PM2XXX_DEEP_DEBUG */
+
+static inline int pm2xxx_ddbg_init(struct pm2xxx_charger *pm2)
+{
+	return 0;
+}
+
+static inline int pm2xxx_ddbg_exit(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PM2XXX_DEEP_DEBUG */
+
+#endif /* PM2301_CHARGER_H */
diff --git a/drivers/power/pm2301_deepdebug.c b/drivers/power/pm2301_deepdebug.c
new file mode 100644
index 0000000..6132006
--- /dev/null
+++ b/drivers/power/pm2301_deepdebug.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright 2012 ST Ericsson.
+ *
+ * Deepdebug support for ST Ericsson pm2xxx_charger charger
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/completion.h>
+#include <linux/regulator/consumer.h>
+#include <linux/err.h>
+#include <linux/workqueue.h>
+#include <linux/kobject.h>
+#include <linux/debugfs.h>
+#include <linux/ux500_deepdebug.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
+#include <linux/mfd/abx500/ux500_chargalg.h>
+#include <linux/pm2301_charger.h>
+
+#include "pm2301_charger.h"
+
+/* PM2XXX registers list */
+static struct ddbg_register ddbg_pm2xxx_registers[] = {
+	DDBG_REG("PM2XXX_BATT_CTRL_REG1", PM2XXX_BATT_CTRL_REG1, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG2", PM2XXX_BATT_CTRL_REG2, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG3", PM2XXX_BATT_CTRL_REG3, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG4", PM2XXX_BATT_CTRL_REG4, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG5", PM2XXX_BATT_CTRL_REG5, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG6", PM2XXX_BATT_CTRL_REG6, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG7", PM2XXX_BATT_CTRL_REG7, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG8", PM2XXX_BATT_CTRL_REG8, DDBG_RW),
+	DDBG_REG("PM2XXX_NTC_CTRL_REG1", PM2XXX_NTC_CTRL_REG1, DDBG_RW),
+	DDBG_REG("PM2XXX_NTC_CTRL_REG2", PM2XXX_NTC_CTRL_REG2, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG9", PM2XXX_BATT_CTRL_REG9, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_STAT_REG1", PM2XXX_BATT_STAT_REG1, DDBG_RO),
+	DDBG_REG("PM2XXX_INP_VOLT_VPWR2", PM2XXX_INP_VOLT_VPWR2, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_DROP_VPWR2", PM2XXX_INP_DROP_VPWR2, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_VOLT_VPWR1", PM2XXX_INP_VOLT_VPWR1, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_DROP_VPWR1", PM2XXX_INP_DROP_VPWR1, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_MODE_VPWR", PM2XXX_INP_MODE_VPWR, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_WD_KICK", PM2XXX_BATT_WD_KICK, DDBG_RW),
+	DDBG_REG("PM2XXX_DEV_VER_STAT", PM2XXX_DEV_VER_STAT, DDBG_RO),
+	DDBG_REG("PM2XXX_THERM_WARN_CTRL", PM2XXX_THERM_WARN_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_DISC_REG", PM2XXX_BATT_DISC_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_LWLEV_CMP", PM2XXX_BATT_LOW_LEV_COMP_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_LWLEV_VAL", PM2XXX_BATT_LOW_LEV_VAL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_I2C_PAD_CTRL_REG", PM2XXX_I2C_PAD_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_SW_CTRL_REG", PM2XXX_SW_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_LED_CTRL_REG", PM2XXX_LED_CTRL_REG, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT1", PM2XXX_REG_INT1, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT1", PM2XXX_MASK_REG_INT1, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT1", PM2XXX_SRCE_REG_INT1, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT2", PM2XXX_REG_INT2, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT2", PM2XXX_MASK_REG_INT2, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT2", PM2XXX_SRCE_REG_INT2, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT3", PM2XXX_REG_INT3, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT3", PM2XXX_MASK_REG_INT3, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT3", PM2XXX_SRCE_REG_INT3, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT4", PM2XXX_REG_INT4, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT4", PM2XXX_MASK_REG_INT4, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT4", PM2XXX_SRCE_REG_INT4, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT5", PM2XXX_REG_INT5, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT5", PM2XXX_MASK_REG_INT5, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT5", PM2XXX_SRCE_REG_INT5, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT6", PM2XXX_REG_INT6, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT6", PM2XXX_MASK_REG_INT6, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT6", PM2XXX_SRCE_REG_INT6, DDBG_RO),
+	DDBG_REG_NULL,
+};
+
+static struct pm2xxx_charger *pm2xxx_ddbg;
+
+static int pm2xxx_ddbg_write(u32 addr, u32 val)
+{
+	int err;
+
+	err = pm2xxx_reg_write(pm2xxx_ddbg, addr, val);
+
+	if (err < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int pm2xxx_ddbg_read(u32 addr, u32 *val)
+{
+	int ret = pm2xxx_reg_read(pm2xxx_ddbg, addr, (u8 *)val);
+
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static struct ddbg_target ddbg_pm2xxx = {
+	.name = "pm2xxx",
+	.phyaddr = 0,
+	.reg = ddbg_pm2xxx_registers,
+	.read_reg = pm2xxx_ddbg_read,
+	.write_reg = pm2xxx_ddbg_write,
+};
+
+int __init pm2xxx_ddbg_init(struct pm2xxx_charger *pm2)
+{
+	int ret;
+	pm2xxx_ddbg = pm2;
+	ret = deep_debug_regaccess_register(&ddbg_pm2xxx);
+	if(ret)
+		pr_err("failed to create debugfs entries.\n");
+
+	return ret;
+}
+
+int __exit pm2xxx_ddbg_exit(void)
+{
+	return (deep_debug_regaccess_unregister(&ddbg_pm2xxx));
+}
+
-- 
1.7.9.5

