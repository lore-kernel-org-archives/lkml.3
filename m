Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161964Ab3BONB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:01:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36090 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161449Ab3BOM6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Bourdiol <alexandre.bourdiol@stericsson.com>
Subject: [PATCH 23/35] mfd: ab8500-gpadc: Optimise GPADC driver
Date: Fri, 15 Feb 2013 12:56:54 +0000
Message-Id: <1360933026-30325-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimise GPADC driver:
 * for code readability and maintenance by grouping similar cheking
 * for performance by grouping several writing to control register

Signed-off-by: Alexandre Bourdiol <alexandre.bourdiol@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/mfd/ab8500-gpadc.c |  212 ++++++++++++--------------------------------
 1 file changed, 55 insertions(+), 157 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index e6fc511..4e668f0 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -363,7 +363,12 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 {
 	int ret;
 	int looplimit = 0;
+	unsigned long completion_timeout;
 	u8 val, low_data, high_data, low_data2, high_data2;
+	u8 val_reg1 = 0;
+	unsigned int delay_min = 0;
+	unsigned int delay_max = 0;
+	u8 data_low_addr, data_high_addr;
 
 	if (!gpadc)
 		return -ENODEV;
@@ -395,12 +400,7 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	}
 
 	/* Enable GPADC */
-	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_GPADC, EN_GPADC);
-	if (ret < 0) {
-		dev_err(gpadc->dev, "gpadc_conversion: enable gpadc failed\n");
-		goto out;
-	}
+	val_reg1 |= EN_GPADC;
 
 	/* Select the channel source and set average samples */
 	switch (avg_sample) {
@@ -418,9 +418,13 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 		break;
 	}
 
-	if (conv_type == ADC_HW)
+	if (conv_type == ADC_HW) {
 		ret = abx500_set_register_interruptible(gpadc->dev,
 				AB8500_GPADC, AB8500_GPADC_CTRL3_REG, val);
+		val_reg1 |= EN_TRIG_EDGE;
+		if (trig_edge)
+			val_reg1 |= EN_FALLING;
+	}
 	else
 		ret = abx500_set_register_interruptible(gpadc->dev,
 				AB8500_GPADC, AB8500_GPADC_CTRL2_REG, val);
@@ -435,123 +439,42 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	 * charging current sense if it needed, ABB 3.0 needs some special
 	 * treatment too.
 	 */
-	if ((conv_type == ADC_HW) && (trig_edge)) {
-		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-			EN_FALLING, EN_FALLING);
-	}
-
 	switch (channel) {
 	case MAIN_CHARGER_C:
 	case USB_CHARGER_C:
-		if (conv_type == ADC_HW)
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF | EN_ICHAR | EN_TRIG_EDGE,
-				EN_BUF | EN_ICHAR | EN_TRIG_EDGE);
-		else
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF | EN_ICHAR,
-				EN_BUF | EN_ICHAR);
-		break;
-
-	case XTAL_TEMP:
-		if (conv_type == ADC_HW)
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF  | EN_TRIG_EDGE,
-				EN_BUF  | EN_TRIG_EDGE);
-		else
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF ,
-				EN_BUF);
-		break;
-
-	case VBAT_TRUE_MEAS:
-		if (conv_type == ADC_HW)
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF  | EN_TRIG_EDGE,
-				EN_BUF  | EN_TRIG_EDGE);
-		else
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF ,
-				EN_BUF);
-		break;
-
-	case BAT_CTRL_AND_IBAT:
-	case VBAT_MEAS_AND_IBAT:
-	case VBAT_TRUE_MEAS_AND_IBAT:
-	case BAT_TEMP_AND_IBAT:
-		if (conv_type == ADC_HW)
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_TRIG_EDGE,
-				EN_TRIG_EDGE);
-		else
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF,
-				0);
+		val_reg1 |= EN_BUF | EN_ICHAR;
 		break;
-
 	case BTEMP_BALL:
 		if (!is_ab8500_2p0_or_earlier(gpadc->parent)) {
-			if (conv_type == ADC_HW)
-				/* Turn on btemp pull-up on ABB 3.0 */
-				ret = abx500_mask_and_set_register_interruptible
-					(gpadc->dev,
-					AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-					EN_BUF | BTEMP_PULL_UP | EN_TRIG_EDGE,
-					EN_BUF | BTEMP_PULL_UP | EN_TRIG_EDGE);
-			else
-				ret = abx500_mask_and_set_register_interruptible
-					(gpadc->dev,
-					AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-					EN_BUF | BTEMP_PULL_UP,
-					EN_BUF | BTEMP_PULL_UP);
-
-		 /*
-		  * Delay might be needed for ABB8500 cut 3.0, if not, remove
-		  * when hardware will be available
-		  */
-			usleep_range(1000, 1000);
+			val_reg1 |= EN_BUF | BTEMP_PULL_UP;
+			/*
+			* Delay might be needed for ABB8500 cut 3.0, if not,
+			* remove when hardware will be availible
+			*/
+			delay_min = 1000; /* Delay in micro seconds */
+			delay_max = 10000; /* large range to optimise sleep mode */
 			break;
 		}
 		/* Intentional fallthrough */
 	default:
-		if (conv_type == ADC_HW)
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF | EN_TRIG_EDGE,
-				EN_BUF | EN_TRIG_EDGE);
-		else
-			ret = abx500_mask_and_set_register_interruptible(
-				gpadc->dev,
-				AB8500_GPADC,
-				AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+		val_reg1 |= EN_BUF;
 		break;
 	}
+
+	/* Write configuration to register */
+	ret = abx500_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, val_reg1);
 	if (ret < 0) {
 		dev_err(gpadc->dev,
-			"gpadc_conversion: select falling edge failed\n");
+			"gpadc_conversion: set Control register failed\n");
 		goto out;
 	}
 
-	/* Set trigger delay timer */
+	if (delay_min != 0)
+		usleep_range(delay_min, delay_max);
+
 	if (conv_type == ADC_HW) {
+		/* Set trigger delay timer */
 		ret = abx500_set_register_interruptible(gpadc->dev,
 			AB8500_GPADC, AB8500_GPADC_AUTO_TIMER_REG, trig_timer);
 		if (ret < 0) {
@@ -559,10 +482,11 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 				"gpadc_conversion: trig timer failed\n");
 			goto out;
 		}
-	}
-
-	/* Start SW conversion */
-	if (conv_type == ADC_SW) {
+		completion_timeout = 2 * HZ;
+		data_low_addr = AB8500_GPADC_AUTODATAL_REG;
+		data_high_addr = AB8500_GPADC_AUTODATAH_REG;
+	} else {
+		/* Start SW conversion */
 		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
 			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
 			ADC_SW_CONV, ADC_SW_CONV);
@@ -571,61 +495,35 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 				"gpadc_conversion: start s/w conv failed\n");
 			goto out;
 		}
+		completion_timeout = msecs_to_jiffies(CONVERSION_TIME);
+		data_low_addr = AB8500_GPADC_MANDATAL_REG;
+		data_high_addr = AB8500_GPADC_MANDATAH_REG;
 	}
 
 	/* wait for completion of conversion */
-	if (conv_type == ADC_HW) {
-		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
-				2 * HZ)) {
-			dev_err(gpadc->dev,
-				"timeout didn't receive hw GPADC conv interrupt\n");
-			ret = -EINVAL;
-			goto out;
-		}
-	} else {
-		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
-				msecs_to_jiffies(CONVERSION_TIME))) {
-			dev_err(gpadc->dev,
-				"timeout didn't receive sw GPADC conv interrupt\n");
-			ret = -EINVAL;
-			goto out;
-		}
+	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
+			completion_timeout)) {
+		dev_err(gpadc->dev,
+			"timeout didn't receive GPADC conv interrupt\n");
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Read the converted RAW data */
-	if (conv_type == ADC_HW) {
-		ret = abx500_get_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_AUTODATAL_REG, &low_data);
-		if (ret < 0) {
-			dev_err(gpadc->dev,
-				"gpadc_conversion: read hw low data failed\n");
-			goto out;
-		}
-
-		ret = abx500_get_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_AUTODATAH_REG, &high_data);
-		if (ret < 0) {
-			dev_err(gpadc->dev,
-				"gpadc_conversion: read hw high data failed\n");
-			goto out;
-		}
-	} else {
-		ret = abx500_get_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_MANDATAL_REG, &low_data);
-		if (ret < 0) {
-			dev_err(gpadc->dev,
-				"gpadc_conversion: read sw low data failed\n");
-			goto out;
-		}
+	ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, data_low_addr, &low_data);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "gpadc_conversion: read low data failed\n");
+		goto out;
+	}
 
-		ret = abx500_get_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_MANDATAH_REG, &high_data);
-		if (ret < 0) {
-			dev_err(gpadc->dev,
-				"gpadc_conversion: read sw high data failed\n");
-			goto out;
-		}
+	ret = abx500_get_register_interruptible(gpadc->dev,
+		AB8500_GPADC, data_high_addr, &high_data);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "gpadc_conversion: read high data failed\n");
+		goto out;
 	}
+
 	/* Check if double convertion is required */
 	if ((channel == BAT_CTRL_AND_IBAT) ||
 			(channel == VBAT_MEAS_AND_IBAT) ||
-- 
1.7.10.4

