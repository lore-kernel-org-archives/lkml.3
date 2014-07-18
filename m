Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbaGRKCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:02:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49820 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaGRKCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:02:38 -0400
Message-ID: <1405677752.3584.8.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC V1] mfd: da9063: Add support for AD silicon variant
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Support Opensource <support.opensource@diasemi.com>
Date: Fri, 18 Jul 2014 12:02:32 +0200
In-Reply-To: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
References: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 16.07.2014, 17:39 +0100 schrieb Opensource [Steve
Twiss]:
> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add register definitions for DA9063 AD (0x3) silicon variant ID
> and Kconfig support to choose the silicon variant at compile time.
> This patch also adds RTC support for the AD silicon changes.
> 
> It adds AD support as a compile-time flag under a new menu item in
> Kconfig called 'Support DA9063 AD silicon variant ID'. This allows
> the user to choose AD support, or to leave blank and choose support
> for the newer silicon variant ID, but not both at the same time.

I second Alessandro's concern. I don't like peppering drivers with
#ifdefs.

If we get the readable/writeable/volatile register handling in
da9063-i2c sorted out, supporting both variants with the same kernel
should be possible.

How about something like this (on top of your patch):
---
 drivers/mfd/Kconfig                  |  10 --
 drivers/mfd/da9063-core.c            |  11 +--
 drivers/mfd/da9063-i2c.c             | 146 +++++++++++++++++++++++-----
 drivers/rtc/rtc-da9063.c             |  79 +++++++---------
 include/linux/mfd/da9063/registers.h | 178 ++++++++++++++++-------------------
 5 files changed, 237 insertions(+), 187 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 7a86563..6cc4b6a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -183,16 +183,6 @@ config MFD_DA9063
 	  Additional drivers must be enabled in order to use the functionality
 	  of the device.
 
-config MFD_DA9063_AD
-	bool "Support DA9063 AD silicon variant ID"
-	depends on MFD_DA9063
-	help
-	  This configures the DA9063 PMIC driver for use with AD silicon
-	  variant ID. Saying yes here will remove the driver support for new
-	  silicon variant IDs.
-
-	  Say N unless you know exactly what you are doing.
-
 config MFD_MC13XXX
 	tristate
 	depends on (SPI_MASTER || I2C)
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index 07b54ef..56b2dc4 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -153,21 +153,12 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		 "Device detected (chip-ID: 0x%02X, var-ID: 0x%02X)\n",
 		 model, variant_id);
 
-#ifdef CONFIG_MFD_DA9063_AD
-	if (variant_code != PMIC_DA9063_AD) {
-		dev_err(da9063->dev,
-			"Only AD (0x3) silicon is supported in this configuration: 0x%02X\n",
-			variant_code);
-		return -ENODEV;
-	}
-#else
-	if (variant_code < PMIC_DA9063_BB) {
+	if (variant_code < PMIC_DA9063_BB && variant_code != PMIC_DA9063_AD) {
 		dev_err(da9063->dev,
 			"Cannot support variant code < BB (0x5): 0x%02X\n",
 			variant_code);
 		return -ENODEV;
 	}
-#endif
 
 	da9063->model = model;
 	da9063->variant_code = variant_code;
diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
index 0c0e295..250f868 100644
--- a/drivers/mfd/da9063-i2c.c
+++ b/drivers/mfd/da9063-i2c.c
@@ -25,10 +25,10 @@
 #include <linux/mfd/da9063/pdata.h>
 #include <linux/mfd/da9063/registers.h>
 
-static const struct regmap_range da9063_readable_ranges[] = {
+static const struct regmap_range da9063_ad_readable_ranges[] = {
 	{
 		.range_min = DA9063_REG_PAGE_CON,
-		.range_max = DA9063_REG_SECOND_D,
+		.range_max = DA9063_AD_REG_SECOND_D,
 	}, {
 		.range_min = DA9063_REG_SEQ,
 		.range_max = DA9063_REG_ID_32_31,
@@ -37,14 +37,14 @@ static const struct regmap_range da9063_readable_ranges[] = {
 		.range_max = DA9063_REG_AUTO3_LOW,
 	}, {
 		.range_min = DA9063_REG_T_OFFSET,
-		.range_max = DA9063_REG_GP_ID_19,
+		.range_max = DA9063_AD_REG_GP_ID_19,
 	}, {
 		.range_min = DA9063_REG_CHIP_ID,
 		.range_max = DA9063_REG_CHIP_VARIANT,
 	},
 };
 
-static const struct regmap_range da9063_writeable_ranges[] = {
+static const struct regmap_range da9063_ad_writeable_ranges[] = {
 	{
 		.range_min = DA9063_REG_PAGE_CON,
 		.range_max = DA9063_REG_PAGE_CON,
@@ -53,7 +53,7 @@ static const struct regmap_range da9063_writeable_ranges[] = {
 		.range_max = DA9063_REG_VSYS_MON,
 	}, {
 		.range_min = DA9063_REG_COUNT_S,
-		.range_max = DA9063_REG_ALARM_Y,
+		.range_max = DA9063_AD_REG_ALARM_Y,
 	}, {
 		.range_min = DA9063_REG_SEQ,
 		.range_max = DA9063_REG_ID_32_31,
@@ -62,14 +62,14 @@ static const struct regmap_range da9063_writeable_ranges[] = {
 		.range_max = DA9063_REG_AUTO3_LOW,
 	}, {
 		.range_min = DA9063_REG_CONFIG_I,
-		.range_max = DA9063_REG_MON_REG_4,
+		.range_max = DA9063_AD_REG_MON_REG_4,
 	}, {
-		.range_min = DA9063_REG_GP_ID_0,
-		.range_max = DA9063_REG_GP_ID_19,
+		.range_min = DA9063_AD_REG_GP_ID_0,
+		.range_max = DA9063_AD_REG_GP_ID_19,
 	},
 };
 
-static const struct regmap_range da9063_volatile_ranges[] = {
+static const struct regmap_range da9063_ad_volatile_ranges[] = {
 	{
 		.range_min = DA9063_REG_STATUS_A,
 		.range_max = DA9063_REG_EVENT_D,
@@ -81,26 +81,104 @@ static const struct regmap_range da9063_volatile_ranges[] = {
 		.range_max = DA9063_REG_ADC_MAN,
 	}, {
 		.range_min = DA9063_REG_ADC_RES_L,
-		.range_max = DA9063_REG_SECOND_D,
+		.range_max = DA9063_AD_REG_SECOND_D,
 	}, {
-		.range_min = DA9063_REG_MON_REG_5,
-		.range_max = DA9063_REG_MON_REG_6,
+		.range_min = DA9063_AD_REG_MON_REG_5,
+		.range_max = DA9063_AD_REG_MON_REG_6,
 	},
 };
 
-static const struct regmap_access_table da9063_readable_table = {
-	.yes_ranges = da9063_readable_ranges,
-	.n_yes_ranges = ARRAY_SIZE(da9063_readable_ranges),
+static const struct regmap_access_table da9063_ad_readable_table = {
+	.yes_ranges = da9063_ad_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_ad_readable_ranges),
 };
 
-static const struct regmap_access_table da9063_writeable_table = {
-	.yes_ranges = da9063_writeable_ranges,
-	.n_yes_ranges = ARRAY_SIZE(da9063_writeable_ranges),
+static const struct regmap_access_table da9063_ad_writeable_table = {
+	.yes_ranges = da9063_ad_writeable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_ad_writeable_ranges),
 };
 
-static const struct regmap_access_table da9063_volatile_table = {
-	.yes_ranges = da9063_volatile_ranges,
-	.n_yes_ranges = ARRAY_SIZE(da9063_volatile_ranges),
+static const struct regmap_access_table da9063_ad_volatile_table = {
+	.yes_ranges = da9063_ad_volatile_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_ad_volatile_ranges),
+};
+
+static const struct regmap_range da9063_bb_readable_ranges[] = {
+	{
+		.range_min = DA9063_REG_PAGE_CON,
+		.range_max = DA9063_BB_REG_SECOND_D,
+	}, {
+		.range_min = DA9063_REG_SEQ,
+		.range_max = DA9063_REG_ID_32_31,
+	}, {
+		.range_min = DA9063_REG_SEQ_A,
+		.range_max = DA9063_REG_AUTO3_LOW,
+	}, {
+		.range_min = DA9063_REG_T_OFFSET,
+		.range_max = DA9063_BB_REG_GP_ID_19,
+	}, {
+		.range_min = DA9063_REG_CHIP_ID,
+		.range_max = DA9063_REG_CHIP_VARIANT,
+	},
+};
+
+static const struct regmap_range da9063_bb_writeable_ranges[] = {
+	{
+		.range_min = DA9063_REG_PAGE_CON,
+		.range_max = DA9063_REG_PAGE_CON,
+	}, {
+		.range_min = DA9063_REG_FAULT_LOG,
+		.range_max = DA9063_REG_VSYS_MON,
+	}, {
+		.range_min = DA9063_REG_COUNT_S,
+		.range_max = DA9063_BB_REG_ALARM_Y,
+	}, {
+		.range_min = DA9063_REG_SEQ,
+		.range_max = DA9063_REG_ID_32_31,
+	}, {
+		.range_min = DA9063_REG_SEQ_A,
+		.range_max = DA9063_REG_AUTO3_LOW,
+	}, {
+		.range_min = DA9063_REG_CONFIG_I,
+		.range_max = DA9063_BB_REG_MON_REG_4,
+	}, {
+		.range_min = DA9063_BB_REG_GP_ID_0,
+		.range_max = DA9063_BB_REG_GP_ID_19,
+	},
+};
+
+static const struct regmap_range da9063_bb_volatile_ranges[] = {
+	{
+		.range_min = DA9063_REG_STATUS_A,
+		.range_max = DA9063_REG_EVENT_D,
+	}, {
+		.range_min = DA9063_REG_CONTROL_F,
+		.range_max = DA9063_REG_CONTROL_F,
+	}, {
+		.range_min = DA9063_REG_ADC_MAN,
+		.range_max = DA9063_REG_ADC_MAN,
+	}, {
+		.range_min = DA9063_REG_ADC_RES_L,
+		.range_max = DA9063_BB_REG_SECOND_D,
+	}, {
+		.range_min = DA9063_BB_REG_MON_REG_5,
+		.range_max = DA9063_BB_REG_MON_REG_6,
+	},
+};
+
+static const struct regmap_access_table da9063_bb_readable_table = {
+	.yes_ranges = da9063_bb_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_bb_readable_ranges),
+};
+
+static const struct regmap_access_table da9063_bb_writeable_table = {
+	.yes_ranges = da9063_bb_writeable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_bb_writeable_ranges),
+};
+
+static const struct regmap_access_table da9063_bb_volatile_table = {
+	.yes_ranges = da9063_bb_volatile_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_bb_volatile_ranges),
 };
 
 static const struct regmap_range_cfg da9063_range_cfg[] = {
@@ -123,10 +201,6 @@ static struct regmap_config da9063_regmap_config = {
 	.max_register = DA9063_REG_CHIP_VARIANT,
 
 	.cache_type = REGCACHE_RBTREE,
-
-	.rd_table = &da9063_readable_table,
-	.wr_table = &da9063_writeable_table,
-	.volatile_table = &da9063_volatile_table,
 };
 
 static int da9063_i2c_probe(struct i2c_client *i2c,
@@ -143,7 +217,7 @@ static int da9063_i2c_probe(struct i2c_client *i2c,
 	da9063->dev = &i2c->dev;
 	da9063->chip_irq = i2c->irq;
 
-	da9063->regmap = devm_regmap_init_i2c(i2c, &da9063_regmap_config);
+	da9063->regmap = regmap_init_i2c(i2c, &da9063_regmap_config);
 	if (IS_ERR(da9063->regmap)) {
 		ret = PTR_ERR(da9063->regmap);
 		dev_err(da9063->dev, "Failed to allocate register map: %d\n",
@@ -152,9 +226,29 @@ static int da9063_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = da9063_device_init(da9063, i2c->irq);
+	regmap_exit(da9063->regmap);
 	if (ret)
 		return ret;
 
+
+	if (da9063->variant_code == PMIC_DA9063_AD) {
+		da9063_regmap_config.rd_table = &da9063_ad_readable_table;
+		da9063_regmap_config.wr_table = &da9063_ad_writeable_table;
+		da9063_regmap_config.volatile_table = &da9063_ad_volatile_table;
+	} else {
+		da9063_regmap_config.rd_table = &da9063_bb_readable_table;
+		da9063_regmap_config.wr_table = &da9063_bb_writeable_table;
+		da9063_regmap_config.volatile_table = &da9063_bb_volatile_table;
+	}
+
+	da9063->regmap = devm_regmap_init_i2c(i2c, &da9063_regmap_config);
+	if (IS_ERR(da9063->regmap)) {
+		ret = PTR_ERR(da9063->regmap);
+		dev_err(da9063->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
 	/*
 	 * Disabling bit BIT(6) in the CONFIG_J register supposedly disables
 	 * the SMBus timeout feature or switches the chip to I2C mode.
diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
index 66c3073..815f756 100644
--- a/drivers/rtc/rtc-da9063.c
+++ b/drivers/rtc/rtc-da9063.c
@@ -29,9 +29,7 @@
 #define YEARS_FROM_DA9063(year)		((year) + 100)
 #define MONTHS_FROM_DA9063(month)	((month) - 1)
 
-#ifdef CONFIG_MFD_DA9063_AD
-#define RTC_ALARM_DATA_LEN (DA9063_REG_ALARM_Y - DA9063_REG_ALARM_MI + 1)
-#endif
+#define RTC_ALARM_DATA_LEN (DA9063_AD_REG_ALARM_Y - DA9063_AD_REG_ALARM_MI + 1)
 
 #define RTC_DATA_LEN	(DA9063_REG_COUNT_Y - DA9063_REG_COUNT_S + 1)
 #define RTC_SEC		0
@@ -46,6 +44,10 @@ struct da9063_rtc {
 	struct da9063		*hw;
 	struct rtc_time		alarm_time;
 	bool			rtc_sync;
+	int			alarm_year;
+	int			alarm_start;
+	int			alarm_len;
+	int			data_start;
 };
 
 static void da9063_data_to_tm(u8 *data, struct rtc_time *tm)
@@ -87,7 +89,7 @@ static int da9063_rtc_stop_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
 
-	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+	return regmap_update_bits(rtc->hw->regmap, rtc->alarm_year,
 				  DA9063_ALARM_ON, 0);
 }
 
@@ -95,7 +97,7 @@ static int da9063_rtc_start_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
 
-	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+	return regmap_update_bits(rtc->hw->regmap, rtc->alarm_year,
 				  DA9063_ALARM_ON, DA9063_ALARM_ON);
 }
 
@@ -155,14 +157,9 @@ static int da9063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 	unsigned int val;
 
-#ifdef CONFIG_MFD_DA9063_AD
 	data[RTC_SEC] = 0;
-	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_MI,
-			       &data[RTC_MIN], RTC_ALARM_DATA_LEN);
-#else
-	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_S,
-			       &data[RTC_SEC], RTC_DATA_LEN);
-#endif
+	ret = regmap_bulk_read(rtc->hw->regmap, rtc->alarm_start,
+			       &data[rtc->data_start], rtc->alarm_len);
 	if (ret < 0)
 		return ret;
 
@@ -196,14 +193,9 @@ static int da9063_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		return ret;
 	}
 
-#ifdef CONFIG_MFD_DA9063_AD
 	data[RTC_SEC] = 0;
-	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_ALARM_MI,
-				&data[RTC_MIN], RTC_ALARM_DATA_LEN);
-#else
-	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_ALARM_S,
-				data, RTC_DATA_LEN);
-#endif
+	ret = regmap_bulk_read(rtc->hw->regmap, rtc->alarm_start,
+			       &data[rtc->data_start], rtc->alarm_len);
 	if (ret < 0) {
 		dev_err(dev, "Failed to write alarm: %d\n", ret);
 		return ret;
@@ -234,7 +226,7 @@ static irqreturn_t da9063_alarm_event(int irq, void *data)
 {
 	struct da9063_rtc *rtc = data;
 
-	regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+	regmap_update_bits(rtc->hw->regmap, rtc->alarm_year,
 			   DA9063_ALARM_ON, 0);
 
 	rtc->rtc_sync = true;
@@ -273,59 +265,54 @@ static int da9063_rtc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-#ifdef CONFIG_MFD_DA9063_AD
-	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_MI,
-			DA9063_ALARM_STATUS_TICK | DA9063_ALARM_STATUS_ALARM,
-			0);
-#else
-	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	if (da9063->variant_code == PMIC_DA9063_AD) {
+		rtc->alarm_year = DA9063_AD_REG_ALARM_Y;
+		rtc->alarm_start = DA9063_AD_REG_ALARM_MI;
+		rtc->alarm_len = RTC_ALARM_DATA_LEN;
+		rtc->data_start = RTC_MIN;
+	} else {
+		rtc->alarm_year = DA9063_BB_REG_ALARM_Y;
+		rtc->alarm_start = DA9063_BB_REG_ALARM_S;
+		rtc->alarm_len = RTC_DATA_LEN;
+		rtc->data_start = RTC_SEC;
+	}
+
+	ret = regmap_update_bits(da9063->regmap, rtc->alarm_start,
 			DA9063_ALARM_STATUS_TICK | DA9063_ALARM_STATUS_ALARM,
 			0);
-#endif
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
 		goto err;
 	}
 
-#ifdef CONFIG_MFD_DA9063_AD
-	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_MI,
-				 DA9063_ALARM_STATUS_ALARM,
-				 DA9063_ALARM_STATUS_ALARM);
-#else
-	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
+	ret = regmap_update_bits(da9063->regmap, rtc->alarm_start,
 				 DA9063_ALARM_STATUS_ALARM,
 				 DA9063_ALARM_STATUS_ALARM);
-#endif
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
 		goto err;
 	}
 
-	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_Y,
+	ret = regmap_update_bits(da9063->regmap, rtc->alarm_year,
 				 DA9063_TICK_ON, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to disable TICKs\n");
 		goto err;
 	}
 
-#ifdef CONFIG_MFD_DA9063_AD
 	data[RTC_SEC] = 0;
-	ret = regmap_bulk_read(da9063->regmap, DA9063_REG_ALARM_MI,
-			       &data[RTC_MIN], RTC_ALARM_DATA_LEN);
-#else
-	ret = regmap_bulk_read(da9063->regmap, DA9063_REG_ALARM_S,
-			       data, RTC_DATA_LEN);
-#endif
+	ret = regmap_bulk_read(da9063->regmap, rtc->alarm_start,
+			       &data[rtc->data_start], rtc->alarm_len);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to read initial alarm data: %d\n",
 			ret);
 		goto err;
 	}
 
-	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
-	if (!rtc)
-		return -ENOMEM;
-
 	platform_set_drvdata(pdev, rtc);
 
 	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da9063/registers.h
index e5201f9..66deb1d 100644
--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -105,28 +105,26 @@
 #define	DA9063_REG_COUNT_MO		0x44
 #define	DA9063_REG_COUNT_Y		0x45
 
-#ifdef CONFIG_MFD_DA9063_AD
-#define	DA9063_REG_ALARM_MI		0x46
-#define	DA9063_REG_ALARM_H		0x47
-#define	DA9063_REG_ALARM_D		0x48
-#define	DA9063_REG_ALARM_MO		0x49
-#define	DA9063_REG_ALARM_Y		0x4A
-#define	DA9063_REG_SECOND_A		0x4B
-#define	DA9063_REG_SECOND_B		0x4C
-#define	DA9063_REG_SECOND_C		0x4D
-#define	DA9063_REG_SECOND_D		0x4E
-#else
-#define	DA9063_REG_ALARM_S		0x46
-#define	DA9063_REG_ALARM_MI		0x47
-#define	DA9063_REG_ALARM_H		0x48
-#define	DA9063_REG_ALARM_D		0x49
-#define	DA9063_REG_ALARM_MO		0x4A
-#define	DA9063_REG_ALARM_Y		0x4B
-#define	DA9063_REG_SECOND_A		0x4C
-#define	DA9063_REG_SECOND_B		0x4D
-#define	DA9063_REG_SECOND_C		0x4E
-#define	DA9063_REG_SECOND_D		0x4F
-#endif
+#define	DA9063_AD_REG_ALARM_MI		0x46
+#define	DA9063_AD_REG_ALARM_H		0x47
+#define	DA9063_AD_REG_ALARM_D		0x48
+#define	DA9063_AD_REG_ALARM_MO		0x49
+#define	DA9063_AD_REG_ALARM_Y		0x4A
+#define	DA9063_AD_REG_SECOND_A		0x4B
+#define	DA9063_AD_REG_SECOND_B		0x4C
+#define	DA9063_AD_REG_SECOND_C		0x4D
+#define	DA9063_AD_REG_SECOND_D		0x4E
+
+#define	DA9063_BB_REG_ALARM_S		0x46
+#define	DA9063_BB_REG_ALARM_MI		0x47
+#define	DA9063_BB_REG_ALARM_H		0x48
+#define	DA9063_BB_REG_ALARM_D		0x49
+#define	DA9063_BB_REG_ALARM_MO		0x4A
+#define	DA9063_BB_REG_ALARM_Y		0x4B
+#define	DA9063_BB_REG_SECOND_A		0x4C
+#define	DA9063_BB_REG_SECOND_B		0x4D
+#define	DA9063_BB_REG_SECOND_C		0x4E
+#define	DA9063_BB_REG_SECOND_D		0x4F
 
 /* Sequencer Control Registers */
 #define	DA9063_REG_SEQ			0x81
@@ -237,69 +235,67 @@
 #define	DA9063_REG_CONFIG_K		0x110
 #define	DA9063_REG_CONFIG_L		0x111
 
-#ifdef CONFIG_MFD_DA9063_AD
-#define	DA9063_REG_MON_REG_1		0x112
-#define	DA9063_REG_MON_REG_2		0x113
-#define	DA9063_REG_MON_REG_3		0x114
-#define	DA9063_REG_MON_REG_4		0x115
-#define	DA9063_REG_MON_REG_5		0x116
-#define	DA9063_REG_MON_REG_6		0x117
-#define	DA9063_REG_TRIM_CLDR		0x118
+#define	DA9063_AD_REG_MON_REG_1		0x112
+#define	DA9063_AD_REG_MON_REG_2		0x113
+#define	DA9063_AD_REG_MON_REG_3		0x114
+#define	DA9063_AD_REG_MON_REG_4		0x115
+#define	DA9063_AD_REG_MON_REG_5		0x116
+#define	DA9063_AD_REG_MON_REG_6		0x117
+#define	DA9063_AD_REG_TRIM_CLDR		0x118
+
+#define	DA9063_BB_REG_CONFIG_M		0x112
+#define	DA9063_BB_REG_CONFIG_N		0x113
+
+#define	DA9063_BB_REG_MON_REG_1		0x114
+#define	DA9063_BB_REG_MON_REG_2		0x115
+#define	DA9063_BB_REG_MON_REG_3		0x116
+#define	DA9063_BB_REG_MON_REG_4		0x117
+#define	DA9063_BB_REG_MON_REG_5		0x11E
+#define	DA9063_BB_REG_MON_REG_6		0x11F
+#define	DA9063_BB_REG_TRIM_CLDR		0x120
 
 /* General Purpose Registers */
-#define	DA9063_REG_GP_ID_0		0x119
-#define	DA9063_REG_GP_ID_1		0x11A
-#define	DA9063_REG_GP_ID_2		0x11B
-#define	DA9063_REG_GP_ID_3		0x11C
-#define	DA9063_REG_GP_ID_4		0x11D
-#define	DA9063_REG_GP_ID_5		0x11E
-#define	DA9063_REG_GP_ID_6		0x11F
-#define	DA9063_REG_GP_ID_7		0x120
-#define	DA9063_REG_GP_ID_8		0x121
-#define	DA9063_REG_GP_ID_9		0x122
-#define	DA9063_REG_GP_ID_10		0x123
-#define	DA9063_REG_GP_ID_11		0x124
-#define	DA9063_REG_GP_ID_12		0x125
-#define	DA9063_REG_GP_ID_13		0x126
-#define	DA9063_REG_GP_ID_14		0x127
-#define	DA9063_REG_GP_ID_15		0x128
-#define	DA9063_REG_GP_ID_16		0x129
-#define	DA9063_REG_GP_ID_17		0x12A
-#define	DA9063_REG_GP_ID_18		0x12B
-#define	DA9063_REG_GP_ID_19		0x12C
-#else
-#define	DA9063_REG_CONFIG_M		0x112
-#define	DA9063_REG_CONFIG_N		0x113
-
-#define	DA9063_REG_MON_REG_1		0x114
-#define	DA9063_REG_MON_REG_2		0x115
-#define	DA9063_REG_MON_REG_3		0x116
-#define	DA9063_REG_MON_REG_4		0x117
-#define	DA9063_REG_MON_REG_5		0x11E
-#define	DA9063_REG_MON_REG_6		0x11F
-#define	DA9063_REG_TRIM_CLDR		0x120
-/* General Purpose Registers */
-#define	DA9063_REG_GP_ID_0		0x121
-#define	DA9063_REG_GP_ID_1		0x122
-#define	DA9063_REG_GP_ID_2		0x123
-#define	DA9063_REG_GP_ID_3		0x124
-#define	DA9063_REG_GP_ID_4		0x125
-#define	DA9063_REG_GP_ID_5		0x126
-#define	DA9063_REG_GP_ID_6		0x127
-#define	DA9063_REG_GP_ID_7		0x128
-#define	DA9063_REG_GP_ID_8		0x129
-#define	DA9063_REG_GP_ID_9		0x12A
-#define	DA9063_REG_GP_ID_10		0x12B
-#define	DA9063_REG_GP_ID_11		0x12C
-#define	DA9063_REG_GP_ID_12		0x12D
-#define	DA9063_REG_GP_ID_13		0x12E
-#define	DA9063_REG_GP_ID_14		0x12F
-#define	DA9063_REG_GP_ID_15		0x130
-#define	DA9063_REG_GP_ID_16		0x131
-#define	DA9063_REG_GP_ID_17		0x132
-#define	DA9063_REG_GP_ID_18		0x133
-#define	DA9063_REG_GP_ID_19		0x134
-#endif
+#define	DA9063_AD_REG_GP_ID_0		0x119
+#define	DA9063_AD_REG_GP_ID_1		0x11A
+#define	DA9063_AD_REG_GP_ID_2		0x11B
+#define	DA9063_AD_REG_GP_ID_3		0x11C
+#define	DA9063_AD_REG_GP_ID_4		0x11D
+#define	DA9063_AD_REG_GP_ID_5		0x11E
+#define	DA9063_AD_REG_GP_ID_6		0x11F
+#define	DA9063_AD_REG_GP_ID_7		0x120
+#define	DA9063_AD_REG_GP_ID_8		0x121
+#define	DA9063_AD_REG_GP_ID_9		0x122
+#define	DA9063_AD_REG_GP_ID_10		0x123
+#define	DA9063_AD_REG_GP_ID_11		0x124
+#define	DA9063_AD_REG_GP_ID_12		0x125
+#define	DA9063_AD_REG_GP_ID_13		0x126
+#define	DA9063_AD_REG_GP_ID_14		0x127
+#define	DA9063_AD_REG_GP_ID_15		0x128
+#define	DA9063_AD_REG_GP_ID_16		0x129
+#define	DA9063_AD_REG_GP_ID_17		0x12A
+#define	DA9063_AD_REG_GP_ID_18		0x12B
+#define	DA9063_AD_REG_GP_ID_19		0x12C
+
+#define	DA9063_BB_REG_GP_ID_0		0x121
+#define	DA9063_BB_REG_GP_ID_1		0x122
+#define	DA9063_BB_REG_GP_ID_2		0x123
+#define	DA9063_BB_REG_GP_ID_3		0x124
+#define	DA9063_BB_REG_GP_ID_4		0x125
+#define	DA9063_BB_REG_GP_ID_5		0x126
+#define	DA9063_BB_REG_GP_ID_6		0x127
+#define	DA9063_BB_REG_GP_ID_7		0x128
+#define	DA9063_BB_REG_GP_ID_8		0x129
+#define	DA9063_BB_REG_GP_ID_9		0x12A
+#define	DA9063_BB_REG_GP_ID_10		0x12B
+#define	DA9063_BB_REG_GP_ID_11		0x12C
+#define	DA9063_BB_REG_GP_ID_12		0x12D
+#define	DA9063_BB_REG_GP_ID_13		0x12E
+#define	DA9063_BB_REG_GP_ID_14		0x12F
+#define	DA9063_BB_REG_GP_ID_15		0x130
+#define	DA9063_BB_REG_GP_ID_16		0x131
+#define	DA9063_BB_REG_GP_ID_17		0x132
+#define	DA9063_BB_REG_GP_ID_18		0x133
+#define	DA9063_BB_REG_GP_ID_19		0x134
 
 /* Chip ID and variant */
 #define	DA9063_REG_CHIP_ID		0x181
@@ -450,14 +446,10 @@
 /* DA9063_REG_CONTROL_B (addr=0x0F) */
 #define	DA9063_CHG_SEL				0x01
 #define	DA9063_WATCHDOG_PD			0x02
-#ifndef CONFIG_MFD_DA9063_AD
-#define	DA9063_RESET_BLINKING			0x04
-#endif
+#define	DA9063_BB_RESET_BLINKING		0x04
 #define	DA9063_NRES_MODE			0x08
 #define	DA9063_NONKEY_LOCK			0x10
-#ifndef CONFIG_MFD_DA9063_AD
-#define	DA9063_BUCK_SLOWSTART			0x80
-#endif
+#define	DA9063_BB_BUCK_SLOWSTART		0x80
 
 /* DA9063_REG_CONTROL_C (addr=0x10) */
 #define	DA9063_DEBOUNCING_MASK			0x07
@@ -517,9 +509,7 @@
 #define	DA9063_GPADC_PAUSE			0x02
 #define	DA9063_PMIF_DIS				0x04
 #define	DA9063_HS2WIRE_DIS			0x08
-#ifndef CONFIG_MFD_DA9063_AD
-#define	DA9063_CLDR_PAUSE			0x10
-#endif
+#define	DA9063_BB_CLDR_PAUSE			0x10
 #define	DA9063_BBAT_DIS				0x20
 #define	DA9063_OUT_32K_PAUSE			0x40
 #define	DA9063_PMCONT_DIS			0x80
@@ -895,10 +885,8 @@
 #define DA9063_COUNT_YEAR_MASK			0x3F
 #define DA9063_MONITOR				0x40
 
-#ifndef CONFIG_MFD_DA9063_AD
 /* DA9063_REG_ALARM_S (addr=0x46) */
-#define DA9063_ALARM_S_MASK			0x3F
-#endif
+#define DA9063_BB_ALARM_S_MASK			0x3F
 #define DA9063_ALARM_STATUS_ALARM		0x80
 #define DA9063_ALARM_STATUS_TICK		0x40
 /* DA9063_REG_ALARM_MI (addr=0x47) */

regards
Philipp

