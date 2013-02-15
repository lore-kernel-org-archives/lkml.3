Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161782Ab3BOM5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:46 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63742 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161476Ab3BOM5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/35] mfd: ab8500-core: Rework MFD sub-device initialisation structures
Date: Fri, 15 Feb 2013 12:56:41 +0000
Message-Id: <1360933026-30325-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we're separating Battery Management devices into their own
structure, removing the common device structure & redistribute them
amongst the individual platform structs and completing the population
of them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |  257 +++++++++++++++++++++++++++++++++------------
 1 file changed, 189 insertions(+), 68 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index ecf570f..8af002c 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -604,7 +604,7 @@ static struct resource ab8500_gpadc_resources[] = {
 	},
 };
 
-static struct resource ab8540_gpadc_resources[] = {
+static struct resource ab8505_gpadc_resources[] = {
 	{
 		.name	= "SW_CONV_END",
 		.start	= AB8500_INT_GP_SW_ADC_CONV_END,
@@ -941,7 +941,50 @@ static struct resource ab8500_temp_resources[] = {
 	},
 };
 
-static struct mfd_cell abx500_common_devs[] = {
+static struct mfd_cell ab8500_bm_devs[] = {
+	{
+		.name = "ab8500-charger",
+		.of_compatible = "stericsson,ab8500-charger",
+		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
+		.resources = ab8500_charger_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
+	},
+	{
+		.name = "ab8500-btemp",
+		.of_compatible = "stericsson,ab8500-btemp",
+		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
+		.resources = ab8500_btemp_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
+	},
+	{
+		.name = "ab8500-fg",
+		.of_compatible = "stericsson,ab8500-fg",
+		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
+		.resources = ab8500_fg_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
+	},
+	{
+		.name = "ab8500-chargalg",
+		.of_compatible = "stericsson,ab8500-chargalg",
+		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
+		.resources = ab8500_chargalg_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
+	},
+};
+
+static struct mfd_cell ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -963,6 +1006,11 @@ static struct mfd_cell abx500_common_devs[] = {
 		.of_compatible = "stericsson,abx500-clk",
 	},
 	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
+		.resources = ab8500_gpadc_resources,
+	},
+	{
 		.name = "ab8500-rtc",
 		.of_compatible = "stericsson,ab8500-rtc",
 		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
@@ -975,6 +1023,7 @@ static struct mfd_cell abx500_common_devs[] = {
 		.resources = ab8500_av_acc_detect_resources,
 	},
 	{
+
 		.name = "ab8500-poweron-key",
 		.of_compatible = "stericsson,ab8500-poweron-key",
 		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
@@ -1004,80 +1053,72 @@ static struct mfd_cell abx500_common_devs[] = {
 		.of_compatible = "stericsson,ab8500-denc",
 	},
 	{
+		.name = "ab8500-gpio",
+		.of_compatible = "stericsson,ab8500-gpio",
+	},
+	{
 		.name = "ab8500-temp",
 		.of_compatible = "stericsson,ab8500-temp",
 		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
 		.resources = ab8500_temp_resources,
 	},
+	{
+		.name = "ab8500-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+	{
+		.name = "ab8500-codec",
+	},
 };
 
-static struct mfd_cell ab8500_bm_devs[] = {
+static struct mfd_cell ab9540_devs[] = {
+#ifdef CONFIG_DEBUG_FS
 	{
-		.name = "ab8500-charger",
-		.of_compatible = "stericsson,ab8500-charger",
-		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
-		.resources = ab8500_charger_resources,
-#ifndef CONFIG_OF
-		.platform_data = &ab8500_bm_data,
-		.pdata_size = sizeof(ab8500_bm_data),
+		.name = "ab8500-debug",
+		.num_resources = ARRAY_SIZE(ab8500_debug_resources),
+		.resources = ab8500_debug_resources,
+	},
 #endif
+	{
+		.name = "ab8500-sysctrl",
 	},
 	{
-		.name = "ab8500-btemp",
-		.of_compatible = "stericsson,ab8500-btemp",
-		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
-		.resources = ab8500_btemp_resources,
-#ifndef CONFIG_OF
-		.platform_data = &ab8500_bm_data,
-		.pdata_size = sizeof(ab8500_bm_data),
-#endif
+		.name = "ab8500-regulator",
 	},
 	{
-		.name = "ab8500-fg",
-		.of_compatible = "stericsson,ab8500-fg",
-		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
-		.resources = ab8500_fg_resources,
-#ifndef CONFIG_OF
-		.platform_data = &ab8500_bm_data,
-		.pdata_size = sizeof(ab8500_bm_data),
-#endif
+		.name = "ab8500-gpadc",
+		.of_compatible = "stericsson,ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
+		.resources = ab8500_gpadc_resources,
 	},
 	{
-		.name = "ab8500-chargalg",
-		.of_compatible = "stericsson,ab8500-chargalg",
-		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
-		.resources = ab8500_chargalg_resources,
-#ifndef CONFIG_OF
-		.platform_data = &ab8500_bm_data,
-		.pdata_size = sizeof(ab8500_bm_data),
-#endif
+		.name = "ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
 	},
-};
-
-static struct mfd_cell ab8500_devs[] = {
 	{
-		.name = "ab8500-gpio",
-		.of_compatible = "stericsson,ab8500-gpio",
+		.name = "ab8500-acc-det",
+		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
+		.resources = ab8500_av_acc_detect_resources,
 	},
 	{
-		.name = "ab8500-usb",
-		.of_compatible = "stericsson,ab8500-usb",
-		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
-		.resources = ab8500_usb_resources,
+		.name = "ab8500-poweron-key",
+		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
+		.resources = ab8500_poweronkey_db_resources,
 	},
 	{
-		.name = "ab8500-codec",
-		.of_compatible = "stericsson,ab8500-codec",
+		.name = "ab8500-pwm",
+		.id = 1,
 	},
 	{
-		.name = "ab8500-gpadc",
-		.of_compatible = "stericsson,ab8500-gpadc",
-		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
-		.resources = ab8500_gpadc_resources,
+		.name = "ab8500-leds",
+	},
+	{
+		.name = "abx500-temp",
+		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
+		.resources = ab8500_temp_resources,
 	},
-};
-
-static struct mfd_cell ab9540_devs[] = {
 	{
 		.name = "ab8500-gpio",
 	},
@@ -1090,11 +1131,6 @@ static struct mfd_cell ab9540_devs[] = {
 		.name = "ab9540-codec",
 	},
 	{
-		.name = "ab8500-gpadc",
-		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
-		.resources = ab8500_gpadc_resources,
-	},
-	{
 		.name = "ab-iddet",
 		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
 		.resources = ab8505_iddet_resources,
@@ -1103,6 +1139,57 @@ static struct mfd_cell ab9540_devs[] = {
 
 /* Device list for ab8505  */
 static struct mfd_cell ab8505_devs[] = {
+#ifdef CONFIG_DEBUG_FS
+	{
+		.name = "ab8500-debug",
+		.num_resources = ARRAY_SIZE(ab8500_debug_resources),
+		.resources = ab8500_debug_resources,
+	},
+#endif
+	{
+		.name = "ab8500-sysctrl",
+	},
+	{
+		.name = "ab8500-regulator",
+	},
+	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
+		.resources = ab8505_gpadc_resources,
+	},
+	{
+		.name = "ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
+	},
+	{
+		.name = "ab8500-acc-det",
+		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
+		.resources = ab8500_av_acc_detect_resources,
+	},
+	{
+		.name = "ab8500-poweron-key",
+		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
+		.resources = ab8500_poweronkey_db_resources,
+	},
+	{
+		.name = "ab8500-pwm",
+		.id = 1,
+	},
+	{
+		.name = "ab8500-leds",
+	},
+	{
+		.name = "ab8500-gpio",
+	},
+	{
+		.name = "ab8500-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+	{
+		.name = "ab8500-codec",
+	},
 	{
 		.name = "ab-iddet",
 		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
@@ -1111,6 +1198,51 @@ static struct mfd_cell ab8505_devs[] = {
 };
 
 static struct mfd_cell ab8540_devs[] = {
+#ifdef CONFIG_DEBUG_FS
+	{
+		.name = "ab8500-debug",
+		.num_resources = ARRAY_SIZE(ab8500_debug_resources),
+		.resources = ab8500_debug_resources,
+	},
+#endif
+	{
+		.name = "ab8500-sysctrl",
+	},
+	{
+		.name = "ab8500-regulator",
+	},
+	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
+		.resources = ab8505_gpadc_resources,
+	},
+	{
+		.name = "ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
+	},
+	{
+		.name = "ab8500-acc-det",
+		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
+		.resources = ab8500_av_acc_detect_resources,
+	},
+	{
+		.name = "ab8500-poweron-key",
+		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
+		.resources = ab8500_poweronkey_db_resources,
+	},
+	{
+		.name = "ab8500-pwm",
+		.id = 1,
+	},
+	{
+		.name = "ab8500-leds",
+	},
+	{
+		.name = "abx500-temp",
+		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
+		.resources = ab8500_temp_resources,
+	},
 	{
 		.name = "ab8500-gpio",
 	},
@@ -1123,11 +1255,6 @@ static struct mfd_cell ab8540_devs[] = {
 		.name = "ab8540-codec",
 	},
 	{
-		.name = "ab8500-gpadc",
-		.num_resources = ARRAY_SIZE(ab8540_gpadc_resources),
-		.resources = ab8540_gpadc_resources,
-	},
-	{
 		.name = "ab-iddet",
 		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
 		.resources = ab8505_iddet_resources,
@@ -1449,12 +1576,6 @@ static int ab8500_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	ret = mfd_add_devices(ab8500->dev, 0, abx500_common_devs,
-			ARRAY_SIZE(abx500_common_devs), NULL,
-			ab8500->irq_base, ab8500->domain);
-	if (ret)
-		return ret;
-
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
-- 
1.7.10.4

