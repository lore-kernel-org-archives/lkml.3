Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161748Ab3BOM6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:07 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38969 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761700Ab3BOM6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/35] mfd: ab8500-gpadc: Add support for the AB8540
Date: Fri, 15 Feb 2013 12:56:52 +0000
Message-Id: <1360933026-30325-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the GPADC to work on AB8540 based platforms.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c              |  316 +++++++++++++++++++++++++++----
 include/linux/mfd/abx500/ab8500-gpadc.h |   43 +++--
 2 files changed, 305 insertions(+), 54 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 6b18975..f3712d8 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -37,6 +37,13 @@
 #define AB8500_GPADC_AUTODATAL_REG	0x07
 #define AB8500_GPADC_AUTODATAH_REG	0x08
 #define AB8500_GPADC_MUX_CTRL_REG	0x09
+#define AB8540_GPADC_MANDATA2L_REG	0x09
+#define AB8540_GPADC_MANDATA2H_REG	0x0A
+#define AB8540_GPADC_APEAAX_REG		0x10
+#define AB8540_GPADC_APEAAT_REG		0x11
+#define AB8540_GPADC_APEAAM_REG		0x12
+#define AB8540_GPADC_APEAAH_REG		0x13
+#define AB8540_GPADC_APEAAL_REG		0x14
 
 /*
  * OTP register offsets
@@ -49,6 +56,10 @@
 #define AB8500_GPADC_CAL_5		0x13
 #define AB8500_GPADC_CAL_6		0x14
 #define AB8500_GPADC_CAL_7		0x15
+/* New calibration for 8540 */
+#define AB8540_GPADC_OTP4_REG_7	0x38
+#define AB8540_GPADC_OTP4_REG_6	0x39
+#define AB8540_GPADC_OTP4_REG_5	0x3A
 
 /* gpadc constants */
 #define EN_VINTCORE12			0x04
@@ -67,6 +78,7 @@
 #define GPADC_BUSY			0x01
 #define EN_FALLING			0x10
 #define EN_TRIG_EDGE			0x02
+#define EN_VBIAS_XTAL_TEMP		0x02
 
 /* GPADC constants from AB8500 spec, UM0836 */
 #define ADC_RESOLUTION			1024
@@ -85,8 +97,21 @@
 #define ADC_CH_BKBAT_MIN		0
 #define ADC_CH_BKBAT_MAX		3200
 
+/* GPADC constants from AB8540 spec */
+#define ADC_CH_IBAT_MIN			(-6000) /* mA range measured by ADC for ibat*/
+#define ADC_CH_IBAT_MAX			6000
+#define ADC_CH_IBAT_MIN_V		(-60)	/* mV range measured by ADC for ibat*/
+#define ADC_CH_IBAT_MAX_V		60
+#define IBAT_VDROP_L			(-56)  /* mV */
+#define IBAT_VDROP_H			56
+
 /* This is used to not lose precision when dividing to get gain and offset */
-#define CALIB_SCALE			1000
+#define CALIB_SCALE		1000
+/*
+ * Number of bits shift used to not lose precision
+ * when dividing to get ibat gain.
+ */
+#define CALIB_SHIFT_IBAT	20
 
 /* Time in ms before disabling regulator */
 #define GPADC_AUDOSUSPEND_DELAY		1
@@ -97,6 +122,7 @@ enum cal_channels {
 	ADC_INPUT_VMAIN = 0,
 	ADC_INPUT_BTEMP,
 	ADC_INPUT_VBAT,
+	ADC_INPUT_IBAT,
 	NBR_CAL_INPUTS,
 };
 
@@ -107,8 +133,8 @@ enum cal_channels {
  * @offset:		Offset of the ADC channel
  */
 struct adc_cal_data {
-	u64 gain;
-	u64 offset;
+	s64 gain;
+	s64 offset;
 };
 
 /**
@@ -183,6 +209,7 @@ int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 channel,
 			gpadc->cal_data[ADC_INPUT_VMAIN].offset) / CALIB_SCALE;
 		break;
 
+	case XTAL_TEMP:
 	case BAT_CTRL:
 	case BTEMP_BALL:
 	case ACC_DETECT1:
@@ -201,6 +228,7 @@ int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 channel,
 		break;
 
 	case MAIN_BAT_V:
+	case VBAT_TRUE_MEAS:
 		/* For some reason we don't have calibrated data */
 		if (!gpadc->cal_data[ADC_INPUT_VBAT].gain) {
 			res = ADC_CH_VBAT_MIN + (ADC_CH_VBAT_MAX -
@@ -244,6 +272,20 @@ int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 channel,
 			ADC_RESOLUTION;
 		break;
 
+	case IBAT_VIRTUAL_CHANNEL:
+		/* For some reason we don't have calibrated data */
+		if (!gpadc->cal_data[ADC_INPUT_IBAT].gain) {
+			res = ADC_CH_IBAT_MIN + (ADC_CH_IBAT_MAX -
+				ADC_CH_IBAT_MIN) * ad_value /
+				ADC_RESOLUTION;
+			break;
+		}
+		/* Here we can use the calibrated data */
+		res = (int) (ad_value * gpadc->cal_data[ADC_INPUT_IBAT].gain +
+				gpadc->cal_data[ADC_INPUT_IBAT].offset)
+				>> CALIB_SHIFT_IBAT;
+		break;
+
 	default:
 		dev_err(gpadc->dev,
 			"unknown channel, not possible to convert\n");
@@ -307,9 +349,19 @@ EXPORT_SYMBOL(ab8500_gpadc_convert);
 int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type)
 {
+	int raw_data;
+	raw_data = ab8500_gpadc_double_read_raw(gpadc, channel,
+			avg_sample, trig_edge, trig_timer, conv_type, NULL);
+	return raw_data;
+}
+
+int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type,
+		int *ibat)
+{
 	int ret;
 	int looplimit = 0;
-	u8 val, low_data, high_data;
+	u8 val, low_data, high_data, low_data2, high_data2;
 
 	if (!gpadc)
 		return -ENODEV;
@@ -362,7 +414,6 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	default:
 		val = channel | AVG_16;
 		break;
-
 	}
 
 	if (conv_type == ADC_HW)
@@ -386,8 +437,8 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
 			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
 			EN_FALLING, EN_FALLING);
-
 	}
+
 	switch (channel) {
 	case MAIN_CHARGER_C:
 	case USB_CHARGER_C:
@@ -404,6 +455,55 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 				EN_BUF | EN_ICHAR,
 				EN_BUF | EN_ICHAR);
 		break;
+
+	case XTAL_TEMP:
+		if (conv_type == ADC_HW)
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF  | EN_TRIG_EDGE,
+				EN_BUF  | EN_TRIG_EDGE);
+		else
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF ,
+				EN_BUF);
+		break;
+
+	case VBAT_TRUE_MEAS:
+		if (conv_type == ADC_HW)
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF  | EN_TRIG_EDGE,
+				EN_BUF  | EN_TRIG_EDGE);
+		else
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF ,
+				EN_BUF);
+		break;
+
+	case BAT_CTRL_AND_IBAT:
+	case VBAT_MEAS_AND_IBAT:
+	case VBAT_TRUE_MEAS_AND_IBAT:
+	case BAT_TEMP_AND_IBAT:
+		if (conv_type == ADC_HW)
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_TRIG_EDGE,
+				EN_TRIG_EDGE);
+		else
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF,
+				0);
+		break;
+
 	case BTEMP_BALL:
 		if (!is_ab8500_2p0_or_earlier(gpadc->parent)) {
 			if (conv_type == ADC_HW)
@@ -474,21 +574,19 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	/* wait for completion of conversion */
 	if (conv_type == ADC_HW) {
 		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
-			2*HZ)) {
-				dev_err(gpadc->dev,
-					"timeout didn't receive"
-					" hw GPADC conv interrupt\n");
-				ret = -EINVAL;
-				goto out;
+				2 * HZ)) {
+			dev_err(gpadc->dev,
+				"timeout didn't receive hw GPADC conv interrupt\n");
+			ret = -EINVAL;
+			goto out;
 		}
 	} else {
 		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
-			msecs_to_jiffies(CONVERSION_TIME))) {
-				dev_err(gpadc->dev,
-					"timeout didn't receive"
-					" sw GPADC conv interrupt\n");
-				ret = -EINVAL;
-				goto out;
+				msecs_to_jiffies(CONVERSION_TIME))) {
+			dev_err(gpadc->dev,
+				"timeout didn't receive sw GPADC conv interrupt\n");
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -526,6 +624,46 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 			goto out;
 		}
 	}
+	/* Check if double convertion is required */
+	if ((channel == BAT_CTRL_AND_IBAT) ||
+			(channel == VBAT_MEAS_AND_IBAT) ||
+			(channel == VBAT_TRUE_MEAS_AND_IBAT) ||
+			(channel == BAT_TEMP_AND_IBAT)) {
+
+		if (conv_type == ADC_HW) {
+			/* not supported */
+			ret = -ENOTSUPP;
+			dev_err(gpadc->dev,
+				"gpadc_conversion: only SW double conversion supported\n");
+			goto out;
+		} else {
+			/* Read the converted RAW data 2 */
+			ret = abx500_get_register_interruptible(gpadc->dev,
+				AB8500_GPADC, AB8540_GPADC_MANDATA2L_REG,
+				&low_data2);
+			if (ret < 0) {
+				dev_err(gpadc->dev,
+					"gpadc_conversion: read sw low data 2 failed\n");
+				goto out;
+			}
+
+			ret = abx500_get_register_interruptible(gpadc->dev,
+				AB8500_GPADC, AB8540_GPADC_MANDATA2H_REG,
+				&high_data2);
+			if (ret < 0) {
+				dev_err(gpadc->dev,
+					"gpadc_conversion: read sw high data 2 failed\n");
+				goto out;
+			}
+			if (ibat != NULL) {
+				*ibat = (high_data2 << 8) | low_data2;
+			} else {
+				dev_warn(gpadc->dev,
+					"gpadc_conversion: ibat not stored\n");
+			}
+
+		}
+	}
 
 	/* Disable GPADC */
 	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
@@ -589,15 +727,27 @@ static int otp_cal_regs[] = {
 	AB8500_GPADC_CAL_7,
 };
 
+static int otp4_cal_regs[] = {
+	AB8540_GPADC_OTP4_REG_7,
+	AB8540_GPADC_OTP4_REG_6,
+	AB8540_GPADC_OTP4_REG_5,
+};
+
 static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 {
 	int i;
 	int ret[ARRAY_SIZE(otp_cal_regs)];
 	u8 gpadc_cal[ARRAY_SIZE(otp_cal_regs)];
-
+	int ret_otp4[ARRAY_SIZE(otp4_cal_regs)];
+	u8 gpadc_otp4[ARRAY_SIZE(otp4_cal_regs)];
 	int vmain_high, vmain_low;
 	int btemp_high, btemp_low;
 	int vbat_high, vbat_low;
+	int ibat_high, ibat_low;
+	s64 V_gain, V_offset, V2A_gain, V2A_offset;
+	struct ab8500 *ab8500;
+
+	ab8500 = gpadc->parent;
 
 	/* First we read all OTP registers and store the error code */
 	for (i = 0; i < ARRAY_SIZE(otp_cal_regs); i++) {
@@ -617,7 +767,7 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 	 * bt_h/l = btemp_high/low
 	 * vb_h/l = vbat_high/low
 	 *
-	 * Data bits:
+	 * Data bits 8500/9540:
 	 * | 7	   | 6	   | 5	   | 4	   | 3	   | 2	   | 1	   | 0
 	 * |.......|.......|.......|.......|.......|.......|.......|.......
 	 * |						   | vm_h9 | vm_h8
@@ -635,6 +785,35 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 	 * | vb_l5 | vb_l4 | vb_l3 | vb_l2 | vb_l1 | vb_l0 |
 	 * |.......|.......|.......|.......|.......|.......|.......|.......
 	 *
+	 * Data bits 8540:
+	 * OTP2
+	 * | 7	   | 6	   | 5	   | 4	   | 3	   | 2	   | 1	   | 0
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * |
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vm_h9 | vm_h8 | vm_h7 | vm_h6 | vm_h5 | vm_h4 | vm_h3 | vm_h2
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vm_h1 | vm_h0 | vm_l4 | vm_l3 | vm_l2 | vm_l1 | vm_l0 | bt_h9
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | bt_h8 | bt_h7 | bt_h6 | bt_h5 | bt_h4 | bt_h3 | bt_h2 | bt_h1
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | bt_h0 | bt_l4 | bt_l3 | bt_l2 | bt_l1 | bt_l0 | vb_h9 | vb_h8
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vb_h7 | vb_h6 | vb_h5 | vb_h4 | vb_h3 | vb_h2 | vb_h1 | vb_h0
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | vb_l5 | vb_l4 | vb_l3 | vb_l2 | vb_l1 | vb_l0 |
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 *
+	 * Data bits 8540:
+	 * OTP4
+	 * | 7	   | 6	   | 5	   | 4	   | 3	   | 2	   | 1	   | 0
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * |					   | ib_h9 | ib_h8 | ib_h7
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | ib_h6 | ib_h5 | ib_h4 | ib_h3 | ib_h2 | ib_h1 | ib_h0 | ib_l5
+	 * |.......|.......|.......|.......|.......|.......|.......|.......
+	 * | ib_l4 | ib_l3 | ib_l2 | ib_l1 | ib_l0 |
+	 *
 	 *
 	 * Ideal output ADC codes corresponding to injected input voltages
 	 * during manufacturing is:
@@ -647,38 +826,96 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 	 * vbat_low:   Vin = 2380mV  / ADC ideal code = 33
 	 */
 
-	/* Calculate gain and offset for VMAIN if all reads succeeded */
-	if (!(ret[0] < 0 || ret[1] < 0 || ret[2] < 0)) {
-		vmain_high = (((gpadc_cal[0] & 0x03) << 8) |
-			((gpadc_cal[1] & 0x3F) << 2) |
-			((gpadc_cal[2] & 0xC0) >> 6));
+	if (is_ab8540(ab8500)) {
+		/* Calculate gain and offset for VMAIN if all reads succeeded*/
+		if (!(ret[1] < 0 || ret[2] < 0)) {
+			vmain_high = (((gpadc_cal[1] & 0xFF) << 2) |
+				((gpadc_cal[2] & 0xC0) >> 6));
+			vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
+			gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
+				(19500 - 315) / (vmain_high - vmain_low);
+			gpadc->cal_data[ADC_INPUT_VMAIN].offset = CALIB_SCALE *
+				19500 - (CALIB_SCALE * (19500 - 315) /
+				(vmain_high - vmain_low)) * vmain_high;
+		} else {
+		gpadc->cal_data[ADC_INPUT_VMAIN].gain = 0;
+		}
 
-		vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
+		/* Read IBAT calibration Data */
+		for (i = 0; i < ARRAY_SIZE(otp4_cal_regs); i++) {
+			ret_otp4[i] = abx500_get_register_interruptible(
+					gpadc->dev, AB8500_OTP_EMUL,
+					otp4_cal_regs[i],  &gpadc_otp4[i]);
+			if (ret_otp4[i] < 0)
+				dev_err(gpadc->dev,
+					"%s: read otp4 reg 0x%02x failed\n",
+					__func__, otp4_cal_regs[i]);
+		}
 
-		gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
-			(19500 - 315) /	(vmain_high - vmain_low);
+		/* Calculate gain and offset for IBAT if all reads succeeded */
+		if (!(ret_otp4[0] < 0 || ret_otp4[1] < 0 || ret_otp4[2] < 0)) {
+			ibat_high = (((gpadc_otp4[0] & 0x07) << 7) |
+				((gpadc_otp4[1] & 0xFE) >> 1));
+			ibat_low = (((gpadc_otp4[1] & 0x01) << 5) |
+				((gpadc_otp4[2] & 0xF8) >> 3));
+
+			V_gain = ((IBAT_VDROP_H - IBAT_VDROP_L)
+				<< CALIB_SHIFT_IBAT) / (ibat_high - ibat_low);
+
+			V_offset = (IBAT_VDROP_H << CALIB_SHIFT_IBAT) -
+				(((IBAT_VDROP_H - IBAT_VDROP_L) <<
+				CALIB_SHIFT_IBAT) / (ibat_high - ibat_low))
+				* ibat_high;
+			/*
+			 * Result obtained is in mV (at a scale factor),
+			 * we need to calculate gain and offset to get mA
+			 */
+			V2A_gain = (ADC_CH_IBAT_MAX - ADC_CH_IBAT_MIN)/
+				(ADC_CH_IBAT_MAX_V - ADC_CH_IBAT_MIN_V);
+			V2A_offset = ((ADC_CH_IBAT_MAX_V * ADC_CH_IBAT_MIN -
+				ADC_CH_IBAT_MAX * ADC_CH_IBAT_MIN_V)
+				<< CALIB_SHIFT_IBAT)
+				/ (ADC_CH_IBAT_MAX_V - ADC_CH_IBAT_MIN_V);
+
+			gpadc->cal_data[ADC_INPUT_IBAT].gain = V_gain * V2A_gain;
+			gpadc->cal_data[ADC_INPUT_IBAT].offset = V_offset *
+				V2A_gain + V2A_offset;
+		} else {
+			gpadc->cal_data[ADC_INPUT_IBAT].gain = 0;
+		}
 
-		gpadc->cal_data[ADC_INPUT_VMAIN].offset = CALIB_SCALE * 19500 -
-			(CALIB_SCALE * (19500 - 315) /
-			 (vmain_high - vmain_low)) * vmain_high;
+		dev_dbg(gpadc->dev, "IBAT gain %llu offset %llu\n",
+			gpadc->cal_data[ADC_INPUT_IBAT].gain,
+			gpadc->cal_data[ADC_INPUT_IBAT].offset);
 	} else {
-		gpadc->cal_data[ADC_INPUT_VMAIN].gain = 0;
+		/* Calculate gain and offset for VMAIN if all reads succeeded */
+		if (!(ret[0] < 0 || ret[1] < 0 || ret[2] < 0)) {
+			vmain_high = (((gpadc_cal[0] & 0x03) << 8) |
+				((gpadc_cal[1] & 0x3F) << 2) |
+				((gpadc_cal[2] & 0xC0) >> 6));
+			vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
+
+			gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
+				(19500 - 315) / (vmain_high - vmain_low);
+
+			gpadc->cal_data[ADC_INPUT_VMAIN].offset = CALIB_SCALE *
+				19500 - (CALIB_SCALE * (19500 - 315) /
+				(vmain_high - vmain_low)) * vmain_high;
+		} else {
+			gpadc->cal_data[ADC_INPUT_VMAIN].gain = 0;
+		}
 	}
-
 	/* Calculate gain and offset for BTEMP if all reads succeeded */
 	if (!(ret[2] < 0 || ret[3] < 0 || ret[4] < 0)) {
 		btemp_high = (((gpadc_cal[2] & 0x01) << 9) |
-			(gpadc_cal[3] << 1) |
-			((gpadc_cal[4] & 0x80) >> 7));
-
+			(gpadc_cal[3] << 1) | ((gpadc_cal[4] & 0x80) >> 7));
 		btemp_low = ((gpadc_cal[4] & 0x7C) >> 2);
 
 		gpadc->cal_data[ADC_INPUT_BTEMP].gain =
 			CALIB_SCALE * (1300 - 21) / (btemp_high - btemp_low);
-
 		gpadc->cal_data[ADC_INPUT_BTEMP].offset = CALIB_SCALE * 1300 -
-			(CALIB_SCALE * (1300 - 21) /
-			(btemp_high - btemp_low)) * btemp_high;
+			(CALIB_SCALE * (1300 - 21) / (btemp_high - btemp_low))
+			* btemp_high;
 	} else {
 		gpadc->cal_data[ADC_INPUT_BTEMP].gain = 0;
 	}
@@ -690,7 +927,6 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 
 		gpadc->cal_data[ADC_INPUT_VBAT].gain = CALIB_SCALE *
 			(4700 - 2380) /	(vbat_high - vbat_low);
-
 		gpadc->cal_data[ADC_INPUT_VBAT].offset = CALIB_SCALE * 4700 -
 			(CALIB_SCALE * (4700 - 2380) /
 			(vbat_high - vbat_low)) * vbat_high;
diff --git a/include/linux/mfd/abx500/ab8500-gpadc.h b/include/linux/mfd/abx500/ab8500-gpadc.h
index 7694e7a..4131437 100644
--- a/include/linux/mfd/abx500/ab8500-gpadc.h
+++ b/include/linux/mfd/abx500/ab8500-gpadc.h
@@ -12,19 +12,32 @@
 
 /* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2
  * and ADCHwSel[4:0] in GPADCCtrl3 ) */
-#define BAT_CTRL	0x01
-#define BTEMP_BALL	0x02
-#define MAIN_CHARGER_V	0x03
-#define ACC_DETECT1	0x04
-#define ACC_DETECT2	0x05
-#define ADC_AUX1	0x06
-#define ADC_AUX2	0x07
-#define MAIN_BAT_V	0x08
-#define VBUS_V		0x09
-#define MAIN_CHARGER_C	0x0A
-#define USB_CHARGER_C	0x0B
-#define BK_BAT_V	0x0C
-#define DIE_TEMP	0x0D
+#define BAT_CTRL		0x01
+#define BTEMP_BALL		0x02
+#define MAIN_CHARGER_V		0x03
+#define ACC_DETECT1		0x04
+#define ACC_DETECT2		0x05
+#define ADC_AUX1		0x06
+#define ADC_AUX2		0x07
+#define MAIN_BAT_V		0x08
+#define VBUS_V			0x09
+#define MAIN_CHARGER_C		0x0A
+#define USB_CHARGER_C		0x0B
+#define BK_BAT_V		0x0C
+#define DIE_TEMP		0x0D
+#define USB_ID			0x0E
+#define XTAL_TEMP		0x12
+#define VBAT_TRUE_MEAS		0x13
+#define BAT_CTRL_AND_IBAT	0x1C
+#define VBAT_MEAS_AND_IBAT	0x1D
+#define VBAT_TRUE_MEAS_AND_IBAT	0x1E
+#define BAT_TEMP_AND_IBAT	0x1F
+
+/* Virtual channel used only for ibat convertion to ampere
+ * Battery current conversion (ibat) cannot be requested as a single conversion
+ *  but it is always in combination with other input requests
+ */
+#define IBAT_VIRTUAL_CHANNEL		0xFF
 
 #define SAMPLE_1        1
 #define SAMPLE_4        4
@@ -37,7 +50,6 @@
 #define ADC_SW				0
 #define ADC_HW				1
 
-
 struct ab8500_gpadc;
 
 struct ab8500_gpadc *ab8500_gpadc_get(char *name);
@@ -51,6 +63,9 @@ static inline int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel)
 
 int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type);
+int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type,
+		int *ibat);
 int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc,
 		u8 channel, int ad_value);
 
-- 
1.7.10.4

