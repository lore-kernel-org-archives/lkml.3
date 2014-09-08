Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaIHC1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:27:15 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:48199 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaIHC1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:27:13 -0400
From: Morgan Phillips <winter2718@gmail.com>
To: brijohn@gmail.com
Cc: hdegoede@redhat.com, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, wolfram@the-dreams.de,
        Morgan Phillips <winter2718@gmail.com>
Subject: [PATCH] [media] sn9c20x: refactor initialization functions and fix lint warnings/errors
Date: Sun,  7 Sep 2014 21:25:07 -0500
Message-Id: <1410143107-16515-1-git-send-email-winter2718@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralize redundant print messages and references to sensor names via macros.

Change msleep time from 10ms to 20ms in order to address checkpatch.pl warning:
"msleep < 20ms can sleep for up to 20ms."

Refactor redundant sensor initialization logic into two functions (_init_sensor_w1,
_init_sensor_w2).

Alter generically named function parameters (data, len), annotated with comments,
so that they are self descriptive.

Reformat struct initializations, line lengths, and variable declarations to
follow style guidelines.

Signed-off-by: Morgan Phillips <winter2718@gmail.com>
---
 drivers/media/usb/gspca/sn9c20x.c | 351 +++++++++++++++++++-------------------
 1 file changed, 176 insertions(+), 175 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41a9a89..39fbc4b 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -65,6 +65,30 @@ MODULE_LICENSE("GPL");
 #define LED_REVERSE	0x2 /* some cameras unset gpio to turn on leds */
 #define FLIP_DETECT	0x4
 
+/* message constants */
+#define SENSOR_OV9650_STR "OV9650"
+#define SENSOR_OV9655_STR "OV9655"
+#define SENSOR_SOI968_STR "SOI968"
+#define SENSOR_OV7660_STR "OV7660"
+#define SENSOR_OV7670_STR "OV7670"
+#define SENSOR_MT9V011_STR "MT9V011"
+#define SENSOR_MT9V111_STR "MT9V111"
+#define SENSOR_MT9V112_STR "MT9V112"
+#define SENSOR_MT9M001_STR "MT9M001"
+#define SENSOR_MT9M111_STR "MT9M111"
+#define SENSOR_MT9M112_STR "MT9M112"
+#define SENSOR_HV7131R_STR "HV7131R"
+#define SENSOR_MT9VPRB_STR "MT9VPRB"
+#define SENSOR_OV9650_STR "OV9650"
+
+/* info messages */
+#define sensor_detected_info(sensor_name)\
+			pr_info("%s sensor detected\n", sensor_name)
+
+/* error messages */
+#define sensor_init_err(sensor_name)\
+			pr_err("%s sensor initialization failed\n", sensor_name)
+
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;
@@ -971,7 +995,7 @@ static void i2c_w(struct gspca_dev *gspca_dev, const u8 *buffer)
 			}
 			return;
 		}
-		msleep(10);
+		msleep(20);
 	}
 	pr_err("i2c_w reg %02x no response\n", buffer[2]);
 /*	gspca_dev->usb_err = -EIO;	fixme: may occur */
@@ -1079,85 +1103,128 @@ static void i2c_r2(struct gspca_dev *gspca_dev, u8 reg, u16 *val)
 	*val = (gspca_dev->usb_buf[3] << 8) | gspca_dev->usb_buf[4];
 }
 
+/* Initialize sensors with i2c_reg_u8 buffers. */
+static void _init_sensor_w1(struct gspca_dev *gspca_dev,
+			const struct i2c_reg_u8 buf[], int buf_size,
+			const char *sensor_str,	u8 hstart, u8 vstart,
+			bool sensor_reset)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sensor_reset) {
+		i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
+		msleep(200);
+	}
+	i2c_w1_buf(gspca_dev, buf, buf_size);
+	if (gspca_dev->usb_err < 0)
+		sensor_init_err(sensor_str);
+	sd->hstart = hstart;
+	sd->vstart = vstart;
+}
+
+/* Initialize sensors with i2c_reg_u16 buffers. */
+static void _init_sensor_w2(struct gspca_dev *gspca_dev,
+			const struct i2c_reg_u16 buf[], int buf_size,
+			const char *sensor_str, u8 hstart, u8 vstart)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	i2c_w2_buf(gspca_dev, buf, buf_size);
+	if (gspca_dev->usb_err < 0)
+		sensor_init_err(sensor_str);
+	sd->hstart = hstart;
+	sd->vstart = vstart;
+}
+
 static void ov9650_init_sensor(struct gspca_dev *gspca_dev)
 {
 	u16 id;
-	struct sd *sd = (struct sd *) gspca_dev;
 
 	i2c_r2(gspca_dev, 0x1c, &id);
+
 	if (gspca_dev->usb_err < 0)
 		return;
-
 	if (id != 0x7fa2) {
 		pr_err("sensor id for ov9650 doesn't match (0x%04x)\n", id);
 		gspca_dev->usb_err = -ENODEV;
 		return;
 	}
 
-	i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
-	msleep(200);
-	i2c_w1_buf(gspca_dev, ov9650_init, ARRAY_SIZE(ov9650_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("OV9650 sensor initialization failed\n");
-	sd->hstart = 1;
-	sd->vstart = 7;
+	_init_sensor_w1(gspca_dev, ov9650_init, ARRAY_SIZE(ov9650_init),
+			SENSOR_OV9650_STR, 1, 7, true);
 }
 
 static void ov9655_init_sensor(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
-	msleep(200);
-	i2c_w1_buf(gspca_dev, ov9655_init, ARRAY_SIZE(ov9655_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("OV9655 sensor initialization failed\n");
-
-	sd->hstart = 1;
-	sd->vstart = 2;
+	_init_sensor_w1(gspca_dev, ov9655_init, ARRAY_SIZE(ov9655_init),
+			SENSOR_OV9655_STR, 1, 2, true);
 }
 
 static void soi968_init_sensor(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	_init_sensor_w1(gspca_dev, soi968_init, ARRAY_SIZE(soi968_init),
+			SENSOR_SOI968_STR, 60, 11, true);
+}
 
-	i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
-	msleep(200);
-	i2c_w1_buf(gspca_dev, soi968_init, ARRAY_SIZE(soi968_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("SOI968 sensor initialization failed\n");
+static void ov7660_init_sensor(struct gspca_dev *gspca_dev)
+{
+	_init_sensor_w1(gspca_dev, ov7660_init, ARRAY_SIZE(ov7660_init),
+			SENSOR_OV7660_STR, 3, 3, true);
+}
+
+static void ov7670_init_sensor(struct gspca_dev *gspca_dev)
+{
+	_init_sensor_w1(gspca_dev, ov7670_init, ARRAY_SIZE(ov7670_init),
+			SENSOR_OV7670_STR, 0, 1, true);
+}
 
-	sd->hstart = 60;
-	sd->vstart = 11;
+static void hv7131r_init_sensor(struct gspca_dev *gspca_dev)
+{
+	_init_sensor_w1(gspca_dev, hv7131r_init, ARRAY_SIZE(hv7131r_init),
+			SENSOR_HV7131R_STR, 0, 1, false);
 }
 
-static void ov7660_init_sensor(struct gspca_dev *gspca_dev)
+static void mt9m112_init_sensor(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	_init_sensor_w2(gspca_dev, mt9m112_init, ARRAY_SIZE(mt9m112_init),
+			SENSOR_MT9M112_STR, 0, 2);
+}
 
-	i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
-	msleep(200);
-	i2c_w1_buf(gspca_dev, ov7660_init, ARRAY_SIZE(ov7660_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("OV7660 sensor initialization failed\n");
-	sd->hstart = 3;
-	sd->vstart = 3;
+static void mt9m111_init_sensor(struct gspca_dev *gspca_dev)
+{
+	_init_sensor_w2(gspca_dev, mt9m111_init, ARRAY_SIZE(mt9m111_init),
+			SENSOR_MT9M111_STR, 0, 2);
 }
 
-static void ov7670_init_sensor(struct gspca_dev *gspca_dev)
+static void mt9m001_init_sensor(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	u16 id;
 
-	i2c_w1(gspca_dev, 0x12, 0x80);		/* sensor reset */
-	msleep(200);
-	i2c_w1_buf(gspca_dev, ov7670_init, ARRAY_SIZE(ov7670_init));
+	i2c_r2(gspca_dev, 0x00, &id);
 	if (gspca_dev->usb_err < 0)
-		pr_err("OV7670 sensor initialization failed\n");
+		return;
+
+	/* must be 0x8411 or 0x8421 for colour sensor and 8431 for bw */
+	switch (id) {
+	case 0x8411:
+	case 0x8421:
+		sensor_detected_info("MT9M001 color");
+		break;
+	case 0x8431:
+		sensor_detected_info("MT9M001 mono");
+		break;
+	default:
+		pr_err("No MT9M001 chip detected, ID = %x\n\n", id);
+		gspca_dev->usb_err = -ENODEV;
+		return;
+	}
 
-	sd->hstart = 0;
-	sd->vstart = 1;
+	_init_sensor_w2(gspca_dev, mt9m001_init, ARRAY_SIZE(mt9m001_init),
+			SENSOR_MT9M001_STR, 1, 1);
 }
 
+
+
 static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1169,13 +1236,13 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x8243) {
 		i2c_w2_buf(gspca_dev, mt9v011_init, ARRAY_SIZE(mt9v011_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V011 sensor initialization failed\n");
+			sensor_init_err(SENSOR_MT9V011_STR);
 			return;
 		}
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V011;
-		pr_info("MT9V011 sensor detected\n");
+		sensor_detected_info(SENSOR_MT9V011_STR);
 		return;
 	}
 
@@ -1187,13 +1254,13 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x823a) {
 		i2c_w2_buf(gspca_dev, mt9v111_init, ARRAY_SIZE(mt9v111_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V111 sensor initialization failed\n");
+			sensor_init_err(SENSOR_MT9V111_STR);
 			return;
 		}
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V111;
-		pr_info("MT9V111 sensor detected\n");
+		sensor_detected_info(SENSOR_MT9V111_STR);
 		return;
 	}
 
@@ -1210,94 +1277,26 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x1229) {
 		i2c_w2_buf(gspca_dev, mt9v112_init, ARRAY_SIZE(mt9v112_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V112 sensor initialization failed\n");
+			sensor_init_err(SENSOR_MT9V112_STR);
 			return;
 		}
 		sd->hstart = 6;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V112;
-		pr_info("MT9V112 sensor detected\n");
+		sensor_detected_info(SENSOR_MT9V112_STR);
 		return;
 	}
 
 	gspca_dev->usb_err = -ENODEV;
 }
 
-static void mt9m112_init_sensor(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	i2c_w2_buf(gspca_dev, mt9m112_init, ARRAY_SIZE(mt9m112_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M112 sensor initialization failed\n");
-
-	sd->hstart = 0;
-	sd->vstart = 2;
-}
-
-static void mt9m111_init_sensor(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	i2c_w2_buf(gspca_dev, mt9m111_init, ARRAY_SIZE(mt9m111_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M111 sensor initialization failed\n");
-
-	sd->hstart = 0;
-	sd->vstart = 2;
-}
-
-static void mt9m001_init_sensor(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	u16 id;
-
-	i2c_r2(gspca_dev, 0x00, &id);
-	if (gspca_dev->usb_err < 0)
-		return;
-
-	/* must be 0x8411 or 0x8421 for colour sensor and 8431 for bw */
-	switch (id) {
-	case 0x8411:
-	case 0x8421:
-		pr_info("MT9M001 color sensor detected\n");
-		break;
-	case 0x8431:
-		pr_info("MT9M001 mono sensor detected\n");
-		break;
-	default:
-		pr_err("No MT9M001 chip detected, ID = %x\n\n", id);
-		gspca_dev->usb_err = -ENODEV;
-		return;
-	}
-
-	i2c_w2_buf(gspca_dev, mt9m001_init, ARRAY_SIZE(mt9m001_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M001 sensor initialization failed\n");
-
-	sd->hstart = 1;
-	sd->vstart = 1;
-}
-
-static void hv7131r_init_sensor(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	i2c_w1_buf(gspca_dev, hv7131r_init, ARRAY_SIZE(hv7131r_init));
-	if (gspca_dev->usb_err < 0)
-		pr_err("HV7131R Sensor initialization failed\n");
-
-	sd->hstart = 0;
-	sd->vstart = 1;
-}
-
 static void set_cmatrix(struct gspca_dev *gspca_dev,
 		s32 brightness, s32 contrast, s32 satur, s32 hue)
 {
 	s32 hue_coord, hue_index = 180 + hue;
 	u8 cmatrix[21];
 
-	memset(cmatrix, 0, sizeof cmatrix);
+	memset(cmatrix, 0, sizeof(cmatrix));
 	cmatrix[2] = (contrast * 0x25 / 0x100) + 0x26;
 	cmatrix[0] = 0x13 + (cmatrix[2] - 0x26) * 0x13 / 0x25;
 	cmatrix[4] = 0x07 + (cmatrix[2] - 0x26) * 0x07 / 0x25;
@@ -1787,8 +1786,9 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
 	u8 value;
-	u8 i2c_init[9] =
-		{0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03};
+	u8 i2c_init[9] = {
+		0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03
+	};
 
 	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
 		value = bridge_init[i][1];
@@ -1815,49 +1815,49 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		ov9650_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV9650 sensor detected\n");
+		sensor_detected_info(SENSOR_OV9650_STR);
 		break;
 	case SENSOR_OV9655:
 		ov9655_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV9655 sensor detected\n");
+		sensor_detected_info(SENSOR_OV9655_STR);
 		break;
 	case SENSOR_SOI968:
 		soi968_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("SOI968 sensor detected\n");
+		sensor_detected_info(SENSOR_SOI968_STR);
 		break;
 	case SENSOR_OV7660:
 		ov7660_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV7660 sensor detected\n");
+		sensor_detected_info(SENSOR_OV7660_STR);
 		break;
 	case SENSOR_OV7670:
 		ov7670_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV7670 sensor detected\n");
+		sensor_detected_info(SENSOR_OV7670_STR);
 		break;
 	case SENSOR_MT9VPRB:
 		mt9v_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9VPRB sensor detected\n");
+		sensor_detected_info(SENSOR_MT9VPRB_STR);
 		break;
 	case SENSOR_MT9M111:
 		mt9m111_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9M111 sensor detected\n");
+		sensor_detected_info(SENSOR_MT9M111_STR);
 		break;
 	case SENSOR_MT9M112:
 		mt9m112_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9M112 sensor detected\n");
+		sensor_detected_info(SENSOR_MT9M112_STR);
 		break;
 	case SENSOR_MT9M001:
 		mt9m001_init_sensor(gspca_dev);
@@ -1868,7 +1868,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		hv7131r_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("HV7131R sensor detected\n");
+		sensor_detected_info(SENSOR_HV7131R_STR);
 		break;
 	default:
 		pr_err("Unsupported sensor\n");
@@ -2171,13 +2171,12 @@ static void qual_upd(struct work_struct *work)
 }
 
 #if IS_ENABLED(CONFIG_INPUT)
-static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
-			u8 *data,		/* interrupt packet */
-			int len)		/* interrupt packet length */
+static int sd_int_pkt_scan(struct gspca_dev *gspca_dev, u8 *interrupt_pkt_data,
+				 int interrupt_pkt_len)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (!(sd->flags & HAS_NO_BUTTON) && len == 1) {
+	if (!(sd->flags & HAS_NO_BUTTON) && interrupt_pkt_len == 1) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
 		input_sync(gspca_dev->input_dev);
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
@@ -2189,8 +2188,7 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 #endif
 
 /* check the JPEG compression */
-static void transfer_check(struct gspca_dev *gspca_dev,
-			u8 *data)
+static void transfer_check(struct gspca_dev *gspca_dev, u8 *data)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int new_qual, r;
@@ -2219,8 +2217,10 @@ static void transfer_check(struct gspca_dev *gspca_dev,
 			   use v4l2_ctrl_g/s_ctrl here. Access the value
 			   directly instead. */
 			s32 curqual = sd->jpegqual->cur.val;
+
 			sd->nchg = 0;
 			new_qual += curqual;
+
 			if (new_qual < sd->jpegqual->minimum)
 				new_qual = sd->jpegqual->minimum;
 			else if (new_qual > sd->jpegqual->maximum)
@@ -2236,70 +2236,71 @@ static void transfer_check(struct gspca_dev *gspca_dev,
 	sd->pktsz = sd->npkt = 0;
 }
 
-static void sd_pkt_scan(struct gspca_dev *gspca_dev,
-			u8 *data,			/* isoc packet */
-			int len)			/* iso packet length */
+static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *isoc_pkt_data,
+			int isoc_pkt_len)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum, is_jpeg;
-	static const u8 frame_header[] =
-		{0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
+	static const u8 frame_header[] = {
+		0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96
+	};
 
 	is_jpeg = (sd->fmt & 0x03) == 0;
-	if (len >= 64 && memcmp(data, frame_header, 6) == 0) {
-		avg_lum = ((data[35] >> 2) & 3) |
-			   (data[20] << 2) |
-			   (data[19] << 10);
-		avg_lum += ((data[35] >> 4) & 3) |
-			    (data[22] << 2) |
-			    (data[21] << 10);
-		avg_lum += ((data[35] >> 6) & 3) |
-			    (data[24] << 2) |
-			    (data[23] << 10);
-		avg_lum += (data[36] & 3) |
-			   (data[26] << 2) |
-			   (data[25] << 10);
-		avg_lum += ((data[36] >> 2) & 3) |
-			    (data[28] << 2) |
-			    (data[27] << 10);
-		avg_lum += ((data[36] >> 4) & 3) |
-			    (data[30] << 2) |
-			    (data[29] << 10);
-		avg_lum += ((data[36] >> 6) & 3) |
-			    (data[32] << 2) |
-			    (data[31] << 10);
-		avg_lum += ((data[44] >> 4) & 3) |
-			    (data[34] << 2) |
-			    (data[33] << 10);
+	if (isoc_pkt_len >= 64 && memcmp(isoc_pkt_data, frame_header, 6) == 0) {
+		avg_lum = ((isoc_pkt_data[35] >> 2) & 3) |
+			   (isoc_pkt_data[20] << 2) |
+			   (isoc_pkt_data[19] << 10);
+		avg_lum += ((isoc_pkt_data[35] >> 4) & 3) |
+			    (isoc_pkt_data[22] << 2) |
+			    (isoc_pkt_data[21] << 10);
+		avg_lum += ((isoc_pkt_data[35] >> 6) & 3) |
+			    (isoc_pkt_data[24] << 2) |
+			    (isoc_pkt_data[23] << 10);
+		avg_lum += (isoc_pkt_data[36] & 3) |
+			   (isoc_pkt_data[26] << 2) |
+			   (isoc_pkt_data[25] << 10);
+		avg_lum += ((isoc_pkt_data[36] >> 2) & 3) |
+			    (isoc_pkt_data[28] << 2) |
+			    (isoc_pkt_data[27] << 10);
+		avg_lum += ((isoc_pkt_data[36] >> 4) & 3) |
+			    (isoc_pkt_data[30] << 2) |
+			    (isoc_pkt_data[29] << 10);
+		avg_lum += ((isoc_pkt_data[36] >> 6) & 3) |
+			    (isoc_pkt_data[32] << 2) |
+			    (isoc_pkt_data[31] << 10);
+		avg_lum += ((isoc_pkt_data[44] >> 4) & 3) |
+			    (isoc_pkt_data[34] << 2) |
+			    (isoc_pkt_data[33] << 10);
 		avg_lum >>= 9;
 		atomic_set(&sd->avg_lum, avg_lum);
 
 		if (is_jpeg)
-			transfer_check(gspca_dev, data);
+			transfer_check(gspca_dev, isoc_pkt_data);
 
 		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
-		len -= 64;
-		if (len == 0)
+		isoc_pkt_len -= 64;
+		if (isoc_pkt_len == 0)
 			return;
-		data += 64;
+		isoc_pkt_data += 64;
 	}
 	if (gspca_dev->last_packet_type == LAST_PACKET) {
 		if (is_jpeg) {
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
 				sd->jpeg_hdr, JPEG_HDR_SZ);
 			gspca_frame_add(gspca_dev, INTER_PACKET,
-				data, len);
+				isoc_pkt_data, isoc_pkt_len);
 		} else {
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
-				data, len);
+				isoc_pkt_data, isoc_pkt_len);
 		}
 	} else {
 		/* if JPEG, count the packets and their size */
 		if (is_jpeg) {
 			sd->npkt++;
-			sd->pktsz += len;
+			sd->pktsz += isoc_pkt_len;
 		}
-		gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
+		gspca_frame_add(gspca_dev, INTER_PACKET, isoc_pkt_data,
+				isoc_pkt_len);
 	}
 }
 
-- 
1.9.1

