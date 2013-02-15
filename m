Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161880Ab3BONCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:02:31 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47308 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761696Ab3BOM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Alexandre Bourdiol <alexandre.bourdiol@stericsson.com>
Subject: [PATCH 22/35] mfd: ab8500-debug: Add support for the AB8540
Date: Fri, 15 Feb 2013 12:56:53 +0000
Message-Id: <1360933026-30325-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Bourdiol <alexandre.bourdiol@stericsson.com>

Allow GPADC debug information to be shown when executing on an AB8540
based platform.

Signed-off-by: Alexandre Bourdiol <alexandre.bourdiol@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c            |  286 ++++++++++++++++++++++++++++++-
 drivers/mfd/ab8500-gpadc.c              |   44 +++++
 include/linux/mfd/abx500/ab8500-gpadc.h |    3 +
 3 files changed, 332 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index ef1bd89..7173406 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1632,6 +1632,254 @@ static const struct file_operations ab8500_gpadc_die_temp_fops = {
 	.owner = THIS_MODULE,
 };
 
+static int ab8540_gpadc_xtal_temp_print(struct seq_file *s, void *p)
+{
+	int xtal_temp_raw;
+	int xtal_temp_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	xtal_temp_raw = ab8500_gpadc_read_raw(gpadc, XTAL_TEMP,
+		avg_sample, trig_edge, trig_timer, conv_type);
+	xtal_temp_convert = ab8500_gpadc_ad_to_voltage(gpadc, XTAL_TEMP,
+		xtal_temp_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			xtal_temp_convert, xtal_temp_raw);
+}
+
+static int ab8540_gpadc_xtal_temp_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8540_gpadc_xtal_temp_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_xtal_temp_fops = {
+	.open = ab8540_gpadc_xtal_temp_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_vbat_true_meas_print(struct seq_file *s, void *p)
+{
+	int vbat_true_meas_raw;
+	int vbat_true_meas_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	vbat_true_meas_raw = ab8500_gpadc_read_raw(gpadc, VBAT_TRUE_MEAS,
+		avg_sample, trig_edge, trig_timer, conv_type);
+	vbat_true_meas_convert = ab8500_gpadc_ad_to_voltage(gpadc, VBAT_TRUE_MEAS,
+		vbat_true_meas_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			vbat_true_meas_convert, vbat_true_meas_raw);
+}
+
+static int ab8540_gpadc_vbat_true_meas_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8540_gpadc_vbat_true_meas_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_vbat_true_meas_fops = {
+	.open = ab8540_gpadc_vbat_true_meas_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_bat_ctrl_and_ibat_print(struct seq_file *s, void *p)
+{
+	int bat_ctrl_raw;
+	int bat_ctrl_convert;
+	int ibat_raw;
+	int ibat_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	bat_ctrl_raw = ab8500_gpadc_double_read_raw(gpadc, BAT_CTRL_AND_IBAT,
+		avg_sample, trig_edge, trig_timer, conv_type, &ibat_raw);
+
+	bat_ctrl_convert = ab8500_gpadc_ad_to_voltage(gpadc, BAT_CTRL,
+		bat_ctrl_raw);
+	ibat_convert = ab8500_gpadc_ad_to_voltage(gpadc, IBAT_VIRTUAL_CHANNEL,
+		ibat_raw);
+
+	return seq_printf(s, "%d,0x%X\n"  "%d,0x%X\n",
+			bat_ctrl_convert, bat_ctrl_raw,
+			ibat_convert, ibat_raw);
+}
+
+static int ab8540_gpadc_bat_ctrl_and_ibat_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8540_gpadc_bat_ctrl_and_ibat_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_bat_ctrl_and_ibat_fops = {
+	.open = ab8540_gpadc_bat_ctrl_and_ibat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_vbat_meas_and_ibat_print(struct seq_file *s, void *p)
+{
+	int vbat_meas_raw;
+	int vbat_meas_convert;
+	int ibat_raw;
+	int ibat_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	vbat_meas_raw = ab8500_gpadc_double_read_raw(gpadc, VBAT_MEAS_AND_IBAT,
+		avg_sample, trig_edge, trig_timer, conv_type, &ibat_raw);
+	vbat_meas_convert = ab8500_gpadc_ad_to_voltage(gpadc, MAIN_BAT_V,
+		vbat_meas_raw);
+	ibat_convert = ab8500_gpadc_ad_to_voltage(gpadc, IBAT_VIRTUAL_CHANNEL,
+		ibat_raw);
+
+	return seq_printf(s, "%d,0x%X\n"  "%d,0x%X\n",
+			vbat_meas_convert, vbat_meas_raw,
+			ibat_convert, ibat_raw);
+}
+
+static int ab8540_gpadc_vbat_meas_and_ibat_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8540_gpadc_vbat_meas_and_ibat_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_vbat_meas_and_ibat_fops = {
+	.open = ab8540_gpadc_vbat_meas_and_ibat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_vbat_true_meas_and_ibat_print(struct seq_file *s, void *p)
+{
+	int vbat_true_meas_raw;
+	int vbat_true_meas_convert;
+	int ibat_raw;
+	int ibat_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	vbat_true_meas_raw = ab8500_gpadc_double_read_raw(gpadc,
+			VBAT_TRUE_MEAS_AND_IBAT, avg_sample, trig_edge,
+			trig_timer, conv_type, &ibat_raw);
+	vbat_true_meas_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+			VBAT_TRUE_MEAS, vbat_true_meas_raw);
+	ibat_convert = ab8500_gpadc_ad_to_voltage(gpadc, IBAT_VIRTUAL_CHANNEL,
+		ibat_raw);
+
+	return seq_printf(s, "%d,0x%X\n"  "%d,0x%X\n",
+			vbat_true_meas_convert, vbat_true_meas_raw,
+			ibat_convert, ibat_raw);
+}
+
+static int ab8540_gpadc_vbat_true_meas_and_ibat_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8540_gpadc_vbat_true_meas_and_ibat_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_vbat_true_meas_and_ibat_fops = {
+	.open = ab8540_gpadc_vbat_true_meas_and_ibat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_bat_temp_and_ibat_print(struct seq_file *s, void *p)
+{
+	int bat_temp_raw;
+	int bat_temp_convert;
+	int ibat_raw;
+	int ibat_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	bat_temp_raw = ab8500_gpadc_double_read_raw(gpadc, BAT_TEMP_AND_IBAT,
+		avg_sample, trig_edge, trig_timer, conv_type, &ibat_raw);
+	bat_temp_convert = ab8500_gpadc_ad_to_voltage(gpadc, BTEMP_BALL,
+		bat_temp_raw);
+	ibat_convert = ab8500_gpadc_ad_to_voltage(gpadc, IBAT_VIRTUAL_CHANNEL,
+		ibat_raw);
+
+	return seq_printf(s, "%d,0x%X\n"  "%d,0x%X\n",
+			bat_temp_convert, bat_temp_raw,
+			ibat_convert, ibat_raw);
+}
+
+static int ab8540_gpadc_bat_temp_and_ibat_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8540_gpadc_bat_temp_and_ibat_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_bat_temp_and_ibat_fops = {
+	.open = ab8540_gpadc_bat_temp_and_ibat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8540_gpadc_otp_cal_print(struct seq_file *s, void *p)
+{
+	struct ab8500_gpadc *gpadc;
+	u16 vmain_l, vmain_h, btemp_l, btemp_h;
+	u16 vbat_l, vbat_h, ibat_l, ibat_h;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	ab8540_gpadc_get_otp(gpadc, &vmain_l, &vmain_h, &btemp_l, &btemp_h,
+			&vbat_l, &vbat_h, &ibat_l, &ibat_h);
+	return seq_printf(s, "VMAIN_L:0x%X\n"
+			"VMAIN_H:0x%X\n"
+			"BTEMP_L:0x%X\n"
+			"BTEMP_H:0x%X\n"
+			"VBAT_L:0x%X\n"
+			"VBAT_H:0x%X\n"
+			"IBAT_L:0x%X\n"
+			"IBAT_H:0x%X\n"
+			,
+			vmain_l,
+			vmain_h,
+			btemp_l,
+			btemp_h,
+			vbat_l,
+			vbat_h,
+			ibat_l,
+			ibat_h);
+}
+
+static int ab8540_gpadc_otp_cal_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8540_gpadc_otp_cal_print, inode->i_private);
+}
+
+static const struct file_operations ab8540_gpadc_otp_calib_fops = {
+	.open = ab8540_gpadc_otp_cal_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static int ab8500_gpadc_avg_sample_print(struct seq_file *s, void *p)
 {
 	return seq_printf(s, "%d\n", avg_sample);
@@ -2385,7 +2633,43 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_die_temp_fops);
 	if (!file)
 		goto err;
-
+	if (is_ab8540(ab8500)) {
+		file = debugfs_create_file("xtal_temp", (S_IRUGO | S_IWUGO),
+		    ab8500_gpadc_dir, &plf->dev, &ab8540_gpadc_xtal_temp_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("vbattruemeas", (S_IRUGO | S_IWUGO),
+		    ab8500_gpadc_dir, &plf->dev,
+		    &ab8540_gpadc_vbat_true_meas_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("batctrl_and_ibat",
+				(S_IRUGO | S_IWUGO), ab8500_gpadc_dir,
+				&plf->dev, &ab8540_gpadc_bat_ctrl_and_ibat_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("vbatmeas_and_ibat",
+				(S_IRUGO | S_IWUGO), ab8500_gpadc_dir,
+				&plf->dev,
+				&ab8540_gpadc_vbat_meas_and_ibat_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("vbattruemeas_and_ibat",
+				(S_IRUGO | S_IWUGO), ab8500_gpadc_dir,
+				&plf->dev,
+				&ab8540_gpadc_vbat_true_meas_and_ibat_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("battemp_and_ibat",
+				(S_IRUGO | S_IWUGO), ab8500_gpadc_dir,
+				&plf->dev, &ab8540_gpadc_bat_temp_and_ibat_fops);
+		if (!file)
+			goto err;
+		file = debugfs_create_file("otp_calib", (S_IRUGO | S_IWUGO),
+		    ab8500_gpadc_dir, &plf->dev, &ab8540_gpadc_otp_calib_fops);
+		if (!file)
+			goto err;
+	}
 	file = debugfs_create_file("avg_sample", (S_IRUGO | S_IWUGO),
 		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_avg_sample_fops);
 	if (!file)
diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index f3712d8..e6fc511 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -135,6 +135,8 @@ enum cal_channels {
 struct adc_cal_data {
 	s64 gain;
 	s64 offset;
+	u16 otp_calib_hi;
+	u16 otp_calib_lo;
 };
 
 /**
@@ -832,6 +834,12 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 			vmain_high = (((gpadc_cal[1] & 0xFF) << 2) |
 				((gpadc_cal[2] & 0xC0) >> 6));
 			vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
+
+			gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_hi =
+				(u16)vmain_high;
+			gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_lo =
+				(u16)vmain_low;
+
 			gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
 				(19500 - 315) / (vmain_high - vmain_low);
 			gpadc->cal_data[ADC_INPUT_VMAIN].offset = CALIB_SCALE *
@@ -859,6 +867,11 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 			ibat_low = (((gpadc_otp4[1] & 0x01) << 5) |
 				((gpadc_otp4[2] & 0xF8) >> 3));
 
+			gpadc->cal_data[ADC_INPUT_IBAT].otp_calib_hi =
+				(u16)ibat_high;
+			gpadc->cal_data[ADC_INPUT_IBAT].otp_calib_lo =
+				(u16)ibat_low;
+
 			V_gain = ((IBAT_VDROP_H - IBAT_VDROP_L)
 				<< CALIB_SHIFT_IBAT) / (ibat_high - ibat_low);
 
@@ -895,6 +908,11 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 				((gpadc_cal[2] & 0xC0) >> 6));
 			vmain_low = ((gpadc_cal[2] & 0x3E) >> 1);
 
+			gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_hi =
+				(u16)vmain_high;
+			gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_lo =
+				(u16)vmain_low;
+
 			gpadc->cal_data[ADC_INPUT_VMAIN].gain = CALIB_SCALE *
 				(19500 - 315) / (vmain_high - vmain_low);
 
@@ -905,12 +923,16 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 			gpadc->cal_data[ADC_INPUT_VMAIN].gain = 0;
 		}
 	}
+
 	/* Calculate gain and offset for BTEMP if all reads succeeded */
 	if (!(ret[2] < 0 || ret[3] < 0 || ret[4] < 0)) {
 		btemp_high = (((gpadc_cal[2] & 0x01) << 9) |
 			(gpadc_cal[3] << 1) | ((gpadc_cal[4] & 0x80) >> 7));
 		btemp_low = ((gpadc_cal[4] & 0x7C) >> 2);
 
+		gpadc->cal_data[ADC_INPUT_BTEMP].otp_calib_hi = (u16)btemp_high;
+		gpadc->cal_data[ADC_INPUT_BTEMP].otp_calib_lo = (u16)btemp_low;
+
 		gpadc->cal_data[ADC_INPUT_BTEMP].gain =
 			CALIB_SCALE * (1300 - 21) / (btemp_high - btemp_low);
 		gpadc->cal_data[ADC_INPUT_BTEMP].offset = CALIB_SCALE * 1300 -
@@ -925,6 +947,9 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 		vbat_high = (((gpadc_cal[4] & 0x03) << 8) | gpadc_cal[5]);
 		vbat_low = ((gpadc_cal[6] & 0xFC) >> 2);
 
+		gpadc->cal_data[ADC_INPUT_VBAT].otp_calib_hi = (u16)vbat_high;
+		gpadc->cal_data[ADC_INPUT_VBAT].otp_calib_lo = (u16)vbat_low;
+
 		gpadc->cal_data[ADC_INPUT_VBAT].gain = CALIB_SCALE *
 			(4700 - 2380) /	(vbat_high - vbat_low);
 		gpadc->cal_data[ADC_INPUT_VBAT].offset = CALIB_SCALE * 4700 -
@@ -1136,6 +1161,25 @@ static void __exit ab8500_gpadc_exit(void)
 	platform_driver_unregister(&ab8500_gpadc_driver);
 }
 
+/**
+ * ab8540_gpadc_get_otp() - returns OTP values
+ *
+ */
+void ab8540_gpadc_get_otp(struct ab8500_gpadc *gpadc,
+			u16 *vmain_l, u16 *vmain_h, u16 *btemp_l, u16 *btemp_h,
+			u16 *vbat_l, u16 *vbat_h, u16 *ibat_l, u16 *ibat_h)
+{
+	*vmain_l = gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_lo;
+	*vmain_h = gpadc->cal_data[ADC_INPUT_VMAIN].otp_calib_hi;
+	*btemp_l = gpadc->cal_data[ADC_INPUT_BTEMP].otp_calib_lo;
+	*btemp_h = gpadc->cal_data[ADC_INPUT_BTEMP].otp_calib_hi;
+	*vbat_l = gpadc->cal_data[ADC_INPUT_VBAT].otp_calib_lo;
+	*vbat_h = gpadc->cal_data[ADC_INPUT_VBAT].otp_calib_hi;
+	*ibat_l = gpadc->cal_data[ADC_INPUT_IBAT].otp_calib_lo;
+	*ibat_h = gpadc->cal_data[ADC_INPUT_IBAT].otp_calib_hi;
+	return ;
+}
+
 subsys_initcall_sync(ab8500_gpadc_init);
 module_exit(ab8500_gpadc_exit);
 
diff --git a/include/linux/mfd/abx500/ab8500-gpadc.h b/include/linux/mfd/abx500/ab8500-gpadc.h
index 4131437..49ded00 100644
--- a/include/linux/mfd/abx500/ab8500-gpadc.h
+++ b/include/linux/mfd/abx500/ab8500-gpadc.h
@@ -68,5 +68,8 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 		int *ibat);
 int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc,
 		u8 channel, int ad_value);
+void ab8540_gpadc_get_otp(struct ab8500_gpadc *gpadc,
+			u16 *vmain_l, u16 *vmain_h, u16 *btemp_l, u16 *btemp_h,
+			u16 *vbat_l, u16 *vbat_h, u16 *ibat_l, u16 *ibat_h);
 
 #endif /* _AB8500_GPADC_H */
-- 
1.7.10.4

