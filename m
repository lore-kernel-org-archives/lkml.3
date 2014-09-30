Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaI3ClE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:41:04 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:58389 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaI3CkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:40:15 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 1/3] toshiba_acpi: Rename hci_raw to tci_raw
Date: Mon, 29 Sep 2014 20:40:07 -0600
Message-Id: <1412044809-3366-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
References: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name hci_raw was used before to reflect
a raw (read/write) call to Toshiba's Hardware
Configuration Interface (HCI), however, since the
introduction of the System Configuration Interface
(SCI), that "name" no longer applies.

This patch changes the name of that function to
tci_raw (for Toshiba Configuration Interface), and
change the comments about it.

Also, the HCI_WORDS definition was changed to TCI_RAW,
to better reflect that we're no longer using pure HCI
calls, but a combination of HCI and SCI, which form
part of the Toshiba Configuration Interface.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 119 ++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 59 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index edd8f3d..ed3671c 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -71,7 +71,8 @@ MODULE_LICENSE("GPL");
 /* Toshiba ACPI method paths */
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
 
-/* Toshiba HCI interface definitions
+/* The Toshiba configuration interface is composed of the HCI and the SCI,
+ * which are defined as follows:
  *
  * HCI is Toshiba's "Hardware Control Interface" which is supposed to
  * be uniform across all their models.  Ideally we would just call
@@ -84,7 +85,7 @@ MODULE_LICENSE("GPL");
  * conceal differences in hardware between different models.
  */
 
-#define HCI_WORDS			6
+#define TCI_WORDS			6
 
 /* operations */
 #define HCI_SET				0xff00
@@ -274,22 +275,22 @@ static int write_acpi_int(const char *methodName, int val)
 	return (status == AE_OK) ? 0 : -EIO;
 }
 
-/* Perform a raw HCI call.  Here we don't care about input or output buffer
- * format.
+/* Perform a raw configuration call.  Here we don't care about input or output
+ * buffer format.
  */
-static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
-			   const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
+static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
+			   const u32 in[TCI_WORDS], u32 out[TCI_WORDS])
 {
 	struct acpi_object_list params;
-	union acpi_object in_objs[HCI_WORDS];
+	union acpi_object in_objs[TCI_WORDS];
 	struct acpi_buffer results;
-	union acpi_object out_objs[HCI_WORDS + 1];
+	union acpi_object out_objs[TCI_WORDS + 1];
 	acpi_status status;
 	int i;
 
-	params.count = HCI_WORDS;
+	params.count = TCI_WORDS;
 	params.pointer = in_objs;
-	for (i = 0; i < HCI_WORDS; ++i) {
+	for (i = 0; i < TCI_WORDS; ++i) {
 		in_objs[i].type = ACPI_TYPE_INTEGER;
 		in_objs[i].integer.value = in[i];
 	}
@@ -300,7 +301,7 @@ static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
 	status = acpi_evaluate_object(dev->acpi_dev->handle,
 				      (char *)dev->method_hci, &params,
 				      &results);
-	if ((status == AE_OK) && (out_objs->package.count <= HCI_WORDS)) {
+	if ((status == AE_OK) && (out_objs->package.count <= TCI_WORDS)) {
 		for (i = 0; i < out_objs->package.count; ++i) {
 			out[i] = out_objs->package.elements[i].integer.value;
 		}
@@ -318,9 +319,9 @@ static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
 static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
 			      u32 in1, u32 *result)
 {
-	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -328,9 +329,9 @@ static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
 static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
 			     u32 *out1, u32 *result)
 {
-	u32 in[HCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
@@ -339,9 +340,9 @@ static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
 static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
 			      u32 in1, u32 in2, u32 *result)
 {
-	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -349,9 +350,9 @@ static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
 static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
 			     u32 *out1, u32 *out2, u32 *result)
 {
-	u32 in[HCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*out2 = out[3];
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
@@ -363,11 +364,11 @@ static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
 
 static int sci_open(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { SCI_OPEN, 0, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { SCI_OPEN, 0, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if  (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to open SCI failed\n");
 		return 0;
@@ -387,11 +388,11 @@ static int sci_open(struct toshiba_acpi_dev *dev)
 
 static void sci_close(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { SCI_CLOSE, 0, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { SCI_CLOSE, 0, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to close SCI failed\n");
 		return;
@@ -408,9 +409,9 @@ static void sci_close(struct toshiba_acpi_dev *dev)
 static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
 			    u32 *out1, u32 *result)
 {
-	u32 in[HCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
@@ -419,9 +420,9 @@ static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
 static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
 			     u32 in1, u32 *result)
 {
-	u32 in[HCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
-	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	u32 in[TCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -429,14 +430,14 @@ static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
 /* Illumination support */
 static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { SCI_GET, SCI_ILLUMINATION, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { SCI_GET, SCI_ILLUMINATION, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	if (!sci_open(dev))
 		return 0;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to query Illumination support failed\n");
@@ -502,14 +503,14 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 /* KBD Illumination */
 static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { SCI_GET, SCI_KBD_ILLUM_STATUS, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { SCI_GET, SCI_KBD_ILLUM_STATUS, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	if (!sci_open(dev))
 		return 0;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query kbd illumination support failed\n");
@@ -663,10 +664,10 @@ static int toshiba_touchpad_get(struct toshiba_acpi_dev *dev, u32 *state)
 static int toshiba_eco_mode_available(struct toshiba_acpi_dev *dev)
 {
 	acpi_status status;
-	u32 in[HCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[TCI_WORDS];
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_info("ACPI call to get ECO led failed\n");
 		return 0;
@@ -679,11 +680,11 @@ static enum led_brightness toshiba_eco_mode_get_status(struct led_classdev *cdev
 {
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, eco_led);
-	u32 in[HCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get ECO led failed\n");
 		return LED_OFF;
@@ -697,13 +698,13 @@ static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
 {
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, eco_led);
-	u32 in[HCI_WORDS] = { HCI_SET, HCI_ECO_MODE, 0, 1, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_SET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	/* Switch the Eco Mode led on/off */
 	in[2] = (brightness) ? 1 : 0;
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set ECO led failed\n");
 		return;
@@ -713,14 +714,14 @@ static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
 /* Accelerometer support */
 static int toshiba_accelerometer_supported(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER2, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER2, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	/* Check if the accelerometer call exists,
 	 * this call also serves as initialization
 	 */
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
@@ -739,12 +740,12 @@ static int toshiba_accelerometer_supported(struct toshiba_acpi_dev *dev)
 static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
 				      u32 *xy, u32 *z)
 {
-	u32 in[HCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER, 0, 1, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER, 0, 1, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	/* Check the Accelerometer status */
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
@@ -925,8 +926,8 @@ static int lcd_proc_open(struct inode *inode, struct file *file)
 
 static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 {
-	u32 in[HCI_WORDS] = { HCI_SET, HCI_LCD_BRIGHTNESS, 0, 0, 0, 0 };
-	u32 out[HCI_WORDS];
+	u32 in[TCI_WORDS] = { HCI_SET, HCI_LCD_BRIGHTNESS, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
 	acpi_status status;
 
 	if (dev->tr_backlight_supported) {
@@ -939,7 +940,7 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 	}
 
 	in[2] = value << HCI_LCD_BRIGHTNESS_SHIFT;
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to set brightness failed");
 		return -EIO;
-- 
2.0.0

