Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbaGPQ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:56:04 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.137]:55574 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbaGPQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:56:02 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-7.tower-180.messagelabs.com!1405529757!26665873!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Wed, 16 Jul 2014 17:39:20 +0100
Subject: [RFC V1] mfd: da9063: Add support for AD silicon variant
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Support Opensource" <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Add register definitions for DA9063 AD (0x3) silicon variant ID
and Kconfig support to choose the silicon variant at compile time.
This patch also adds RTC support for the AD silicon changes.

It adds AD support as a compile-time flag under a new menu item in
Kconfig called 'Support DA9063 AD silicon variant ID'. This allows
the user to choose AD support, or to leave blank and choose support
for the newer silicon variant ID, but not both at the same time.

This extra option for supporting AD will only appear if the main 'Dialog
Semiconductor DA9063 PMIC Support' option is chosen. The AD support
boolean will be defaulted to false (unchecked) until the user
modifies it. This means that AD support is not turned on by default.

The DA9063 probe function has been modified to use the compile time
directive CONFIG_MFD_DA9063_AD. This configuration option will allow
AD support only if this boolean is true, otherwise it will default to
support BB (or greater) silicon.


Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with linux-next/v3.16-rc5/scripts/checkpatch.pl
 rtc-da9063.c              total: 0 errors, 0 warnings, 367 lines checked
 da9063-core.c             total: 0 errors, 0 warnings, 198 lines checked
 Kconfig                   total: 0 errors, 41 warnings, 1285 lines checked
 core.h                    total: 0 errors, 0 warnings, 98 lines checked
 registers.h               total: 0 errors, 0 warnings, 1086 lines checked

This patch adds DA9063 registers for silicon variant ID corresponding
to AD (0x3) and adds RTC support for these register changes.

The requirement add the AD register map back into the Linux kernel
in order to support existing hardware was foreseen as a possible
future change:
https://lkml.org/lkml/2014/2/14/455 

This patch applies against linux-next and v3.16-rc5

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/mfd/Kconfig                  |   10 +++++++
 drivers/mfd/da9063-core.c            |   16 ++++++++--
 drivers/rtc/rtc-da9063.c             |   36 ++++++++++++++++++++++-
 include/linux/mfd/da9063/core.h      |    3 +-
 include/linux/mfd/da9063/registers.h |   54 ++++++++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6cc4b6a..7a86563 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -183,6 +183,16 @@ config MFD_DA9063
 	  Additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_DA9063_AD
+	bool "Support DA9063 AD silicon variant ID"
+	depends on MFD_DA9063
+	help
+	  This configures the DA9063 PMIC driver for use with AD silicon
+	  variant ID. Saying yes here will remove the driver support for new
+	  silicon variant IDs.
+
+	  Say N unless you know exactly what you are doing.
+
 config MFD_MC13XXX
 	tristate
 	depends on (SPI_MASTER || I2C)
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index e70ae31..07b54ef 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -153,11 +153,21 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		 "Device detected (chip-ID: 0x%02X, var-ID: 0x%02X)\n",
 		 model, variant_id);
 
-	if (variant_code != PMIC_DA9063_BB) {
-		dev_err(da9063->dev, "Unknown chip variant code: 0x%02X\n",
-				variant_code);
+#ifdef CONFIG_MFD_DA9063_AD
+	if (variant_code != PMIC_DA9063_AD) {
+		dev_err(da9063->dev,
+			"Only AD (0x3) silicon is supported in this configuration: 0x%02X\n",
+			variant_code);
 		return -ENODEV;
 	}
+#else
+	if (variant_code < PMIC_DA9063_BB) {
+		dev_err(da9063->dev,
+			"Cannot support variant code < BB (0x5): 0x%02X\n",
+			variant_code);
+		return -ENODEV;
+	}
+#endif
 
 	da9063->model = model;
 	da9063->variant_code = variant_code;
diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
index 5953930..66c3073 100644
--- a/drivers/rtc/rtc-da9063.c
+++ b/drivers/rtc/rtc-da9063.c
@@ -29,6 +29,10 @@
 #define YEARS_FROM_DA9063(year)		((year) + 100)
 #define MONTHS_FROM_DA9063(month)	((month) - 1)
 
+#ifdef CONFIG_MFD_DA9063_AD
+#define RTC_ALARM_DATA_LEN (DA9063_REG_ALARM_Y - DA9063_REG_ALARM_MI + 1)
+#endif
+
 #define RTC_DATA_LEN	(DA9063_REG_COUNT_Y - DA9063_REG_COUNT_S + 1)
 #define RTC_SEC		0
 #define RTC_MIN		1
@@ -151,8 +155,14 @@ static int da9063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 	unsigned int val;
 
+#ifdef CONFIG_MFD_DA9063_AD
+	data[RTC_SEC] = 0;
+	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_MI,
+			       &data[RTC_MIN], RTC_ALARM_DATA_LEN);
+#else
 	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_S,
 			       &data[RTC_SEC], RTC_DATA_LEN);
+#endif
 	if (ret < 0)
 		return ret;
 
@@ -186,14 +196,20 @@ static int da9063_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		return ret;
 	}
 
+#ifdef CONFIG_MFD_DA9063_AD
+	data[RTC_SEC] = 0;
+	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_ALARM_MI,
+				&data[RTC_MIN], RTC_ALARM_DATA_LEN);
+#else
 	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_ALARM_S,
 				data, RTC_DATA_LEN);
+#endif
 	if (ret < 0) {
 		dev_err(dev, "Failed to write alarm: %d\n", ret);
 		return ret;
 	}
 
-	rtc->alarm_time = alrm->time;
+	da9063_data_to_tm(data, &rtc->alarm_time);
 
 	if (alrm->enabled) {
 		ret = da9063_rtc_start_alarm(dev);
@@ -257,17 +273,29 @@ static int da9063_rtc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+#ifdef CONFIG_MFD_DA9063_AD
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_MI,
+			DA9063_ALARM_STATUS_TICK | DA9063_ALARM_STATUS_ALARM,
+			0);
+#else
 	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
 			DA9063_ALARM_STATUS_TICK | DA9063_ALARM_STATUS_ALARM,
 			0);
+#endif
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
 		goto err;
 	}
 
+#ifdef CONFIG_MFD_DA9063_AD
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_MI,
+				 DA9063_ALARM_STATUS_ALARM,
+				 DA9063_ALARM_STATUS_ALARM);
+#else
 	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
 				 DA9063_ALARM_STATUS_ALARM,
 				 DA9063_ALARM_STATUS_ALARM);
+#endif
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
 		goto err;
@@ -280,8 +308,14 @@ static int da9063_rtc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+#ifdef CONFIG_MFD_DA9063_AD
+	data[RTC_SEC] = 0;
+	ret = regmap_bulk_read(da9063->regmap, DA9063_REG_ALARM_MI,
+			       &data[RTC_MIN], RTC_ALARM_DATA_LEN);
+#else
 	ret = regmap_bulk_read(da9063->regmap, DA9063_REG_ALARM_S,
 			       data, RTC_DATA_LEN);
+#endif
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to read initial alarm data: %d\n",
 			ret);
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
index 00a9aac..b92a326 100644
--- a/include/linux/mfd/da9063/core.h
+++ b/include/linux/mfd/da9063/core.h
@@ -34,7 +34,8 @@ enum da9063_models {
 };
 
 enum da9063_variant_codes {
-	PMIC_DA9063_BB = 0x5
+	PMIC_DA9063_AD = 0x3,
+	PMIC_DA9063_BB = 0x5,
 };
 
 /* Interrupts */
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da9063/registers.h
index 09a85c6..e5201f9 100644
--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -104,6 +104,18 @@
 #define	DA9063_REG_COUNT_D		0x43
 #define	DA9063_REG_COUNT_MO		0x44
 #define	DA9063_REG_COUNT_Y		0x45
+
+#ifdef CONFIG_MFD_DA9063_AD
+#define	DA9063_REG_ALARM_MI		0x46
+#define	DA9063_REG_ALARM_H		0x47
+#define	DA9063_REG_ALARM_D		0x48
+#define	DA9063_REG_ALARM_MO		0x49
+#define	DA9063_REG_ALARM_Y		0x4A
+#define	DA9063_REG_SECOND_A		0x4B
+#define	DA9063_REG_SECOND_B		0x4C
+#define	DA9063_REG_SECOND_C		0x4D
+#define	DA9063_REG_SECOND_D		0x4E
+#else
 #define	DA9063_REG_ALARM_S		0x46
 #define	DA9063_REG_ALARM_MI		0x47
 #define	DA9063_REG_ALARM_H		0x48
@@ -114,6 +126,7 @@
 #define	DA9063_REG_SECOND_B		0x4D
 #define	DA9063_REG_SECOND_C		0x4E
 #define	DA9063_REG_SECOND_D		0x4F
+#endif
 
 /* Sequencer Control Registers */
 #define	DA9063_REG_SEQ			0x81
@@ -223,6 +236,38 @@
 #define	DA9063_REG_CONFIG_J		0x10F
 #define	DA9063_REG_CONFIG_K		0x110
 #define	DA9063_REG_CONFIG_L		0x111
+
+#ifdef CONFIG_MFD_DA9063_AD
+#define	DA9063_REG_MON_REG_1		0x112
+#define	DA9063_REG_MON_REG_2		0x113
+#define	DA9063_REG_MON_REG_3		0x114
+#define	DA9063_REG_MON_REG_4		0x115
+#define	DA9063_REG_MON_REG_5		0x116
+#define	DA9063_REG_MON_REG_6		0x117
+#define	DA9063_REG_TRIM_CLDR		0x118
+
+/* General Purpose Registers */
+#define	DA9063_REG_GP_ID_0		0x119
+#define	DA9063_REG_GP_ID_1		0x11A
+#define	DA9063_REG_GP_ID_2		0x11B
+#define	DA9063_REG_GP_ID_3		0x11C
+#define	DA9063_REG_GP_ID_4		0x11D
+#define	DA9063_REG_GP_ID_5		0x11E
+#define	DA9063_REG_GP_ID_6		0x11F
+#define	DA9063_REG_GP_ID_7		0x120
+#define	DA9063_REG_GP_ID_8		0x121
+#define	DA9063_REG_GP_ID_9		0x122
+#define	DA9063_REG_GP_ID_10		0x123
+#define	DA9063_REG_GP_ID_11		0x124
+#define	DA9063_REG_GP_ID_12		0x125
+#define	DA9063_REG_GP_ID_13		0x126
+#define	DA9063_REG_GP_ID_14		0x127
+#define	DA9063_REG_GP_ID_15		0x128
+#define	DA9063_REG_GP_ID_16		0x129
+#define	DA9063_REG_GP_ID_17		0x12A
+#define	DA9063_REG_GP_ID_18		0x12B
+#define	DA9063_REG_GP_ID_19		0x12C
+#else
 #define	DA9063_REG_CONFIG_M		0x112
 #define	DA9063_REG_CONFIG_N		0x113
 
@@ -254,6 +299,7 @@
 #define	DA9063_REG_GP_ID_17		0x132
 #define	DA9063_REG_GP_ID_18		0x133
 #define	DA9063_REG_GP_ID_19		0x134
+#endif
 
 /* Chip ID and variant */
 #define	DA9063_REG_CHIP_ID		0x181
@@ -404,10 +450,14 @@
 /* DA9063_REG_CONTROL_B (addr=0x0F) */
 #define	DA9063_CHG_SEL				0x01
 #define	DA9063_WATCHDOG_PD			0x02
+#ifndef CONFIG_MFD_DA9063_AD
 #define	DA9063_RESET_BLINKING			0x04
+#endif
 #define	DA9063_NRES_MODE			0x08
 #define	DA9063_NONKEY_LOCK			0x10
+#ifndef CONFIG_MFD_DA9063_AD
 #define	DA9063_BUCK_SLOWSTART			0x80
+#endif
 
 /* DA9063_REG_CONTROL_C (addr=0x10) */
 #define	DA9063_DEBOUNCING_MASK			0x07
@@ -467,7 +517,9 @@
 #define	DA9063_GPADC_PAUSE			0x02
 #define	DA9063_PMIF_DIS				0x04
 #define	DA9063_HS2WIRE_DIS			0x08
+#ifndef CONFIG_MFD_DA9063_AD
 #define	DA9063_CLDR_PAUSE			0x10
+#endif
 #define	DA9063_BBAT_DIS				0x20
 #define	DA9063_OUT_32K_PAUSE			0x40
 #define	DA9063_PMCONT_DIS			0x80
@@ -843,8 +895,10 @@
 #define DA9063_COUNT_YEAR_MASK			0x3F
 #define DA9063_MONITOR				0x40
 
+#ifndef CONFIG_MFD_DA9063_AD
 /* DA9063_REG_ALARM_S (addr=0x46) */
 #define DA9063_ALARM_S_MASK			0x3F
+#endif
 #define DA9063_ALARM_STATUS_ALARM		0x80
 #define DA9063_ALARM_STATUS_TICK		0x40
 /* DA9063_REG_ALARM_MI (addr=0x47) */
-- 
end-of-patch for RFC V1

