Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaI3CkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:40:20 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56422 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaI3CkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:40:17 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 2/3] toshiba_acpi: Unify return codes prefix from HCI/SCI to TOS
Date: Mon, 29 Sep 2014 20:40:08 -0600
Message-Id: <1412044809-3366-3-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
References: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return codes are split in between HCI/SCI prefixes,
but they are shared (used) by both interfaces, mixing
hci_read/write calls with SCI_* return codes, and
sci_read/write calls with HCI_* ones.

This patch changes the prefix of the return codes
definitions, dropping the HCI/SCI naming and instead
replacing it with TOS (for TOShiba).

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 143 ++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index ed3671c..589a858 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -96,17 +96,18 @@ MODULE_LICENSE("GPL");
 #define SCI_SET				0xf400
 
 /* return codes */
-#define HCI_SUCCESS			0x0000
-#define HCI_FAILURE			0x1000
-#define HCI_NOT_SUPPORTED		0x8000
-#define HCI_EMPTY			0x8c00
-#define HCI_DATA_NOT_AVAILABLE		0x8d20
-#define HCI_NOT_INITIALIZED		0x8d50
-#define SCI_OPEN_CLOSE_OK		0x0044
-#define SCI_ALREADY_OPEN		0x8100
-#define SCI_NOT_OPENED			0x8200
-#define SCI_INPUT_DATA_ERROR		0x8300
-#define SCI_NOT_PRESENT			0x8600
+#define TOS_SUCCESS			0x0000
+#define TOS_OPEN_CLOSE_OK		0x0044
+#define TOS_FAILURE			0x1000
+#define TOS_NOT_SUPPORTED		0x8000
+#define TOS_ALREADY_OPEN		0x8100
+#define TOS_NOT_OPENED			0x8200
+#define TOS_INPUT_DATA_ERROR		0x8300
+#define TOS_WRITE_PROTECTED		0x8400
+#define TOS_NOT_PRESENT			0x8600
+#define TOS_FIFO_EMPTY			0x8c00
+#define TOS_DATA_NOT_AVAILABLE		0x8d20
+#define TOS_NOT_INITIALIZED		0x8d50
 
 /* registers */
 #define HCI_FAN				0x0004
@@ -322,7 +323,7 @@ static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -333,7 +334,7 @@ static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -343,7 +344,7 @@ static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -355,7 +356,7 @@ static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
 	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*out2 = out[3];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -369,17 +370,17 @@ static int sci_open(struct toshiba_acpi_dev *dev)
 	acpi_status status;
 
 	status = tci_raw(dev, in, out);
-	if  (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
+	if  (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
 		pr_err("ACPI call to open SCI failed\n");
 		return 0;
 	}
 
-	if (out[0] == SCI_OPEN_CLOSE_OK) {
+	if (out[0] == TOS_OPEN_CLOSE_OK) {
 		return 1;
-	} else if (out[0] == SCI_ALREADY_OPEN) {
+	} else if (out[0] == TOS_ALREADY_OPEN) {
 		pr_info("Toshiba SCI already opened\n");
 		return 1;
-	} else if (out[0] == SCI_NOT_PRESENT) {
+	} else if (out[0] == TOS_NOT_PRESENT) {
 		pr_info("Toshiba SCI is not present\n");
 	}
 
@@ -393,16 +394,16 @@ static void sci_close(struct toshiba_acpi_dev *dev)
 	acpi_status status;
 
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
 		pr_err("ACPI call to close SCI failed\n");
 		return;
 	}
 
-	if (out[0] == SCI_OPEN_CLOSE_OK)
+	if (out[0] == TOS_OPEN_CLOSE_OK)
 		return;
-	else if (out[0] == SCI_NOT_OPENED)
+	else if (out[0] == TOS_NOT_OPENED)
 		pr_info("Toshiba SCI not opened\n");
-	else if (out[0] == SCI_NOT_PRESENT)
+	else if (out[0] == TOS_NOT_PRESENT)
 		pr_info("Toshiba SCI is not present\n");
 }
 
@@ -413,7 +414,7 @@ static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
-	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -423,7 +424,7 @@ static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 in[TCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
+	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
 	return status;
 }
 
@@ -439,10 +440,10 @@ static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
 
 	status = tci_raw(dev, in, out);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
 		pr_err("ACPI call to query Illumination support failed\n");
 		return 0;
-	} else if (out[0] == HCI_NOT_SUPPORTED) {
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
 		pr_info("Illumination device not available\n");
 		return 0;
 	}
@@ -469,7 +470,7 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 	if (ACPI_FAILURE(status)) {
 		pr_err("ACPI call for illumination failed\n");
 		return;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Illumination not supported\n");
 		return;
 	}
@@ -489,10 +490,10 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 	/* Check the illumination */
 	status = sci_read(dev, SCI_ILLUMINATION, &state, &result);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call for illumination failed\n");
 		return LED_OFF;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Illumination not supported\n");
 		return LED_OFF;
 	}
@@ -512,10 +513,10 @@ static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
 
 	status = tci_raw(dev, in, out);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query kbd illumination support failed\n");
 		return 0;
-	} else if (out[0] == HCI_NOT_SUPPORTED) {
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
 		pr_info("Keyboard illumination not available\n");
 		return 0;
 	}
@@ -547,10 +548,10 @@ static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
 
 	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set KBD backlight status failed\n");
 		return -EIO;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Keyboard backlight status not supported\n");
 		return -ENODEV;
 	}
@@ -568,10 +569,10 @@ static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
 
 	status = sci_read(dev, SCI_KBD_ILLUM_STATUS, time, &result);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get KBD backlight status failed\n");
 		return -EIO;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Keyboard backlight status not supported\n");
 		return -ENODEV;
 	}
@@ -588,10 +589,10 @@ static enum led_brightness toshiba_kbd_backlight_get(struct led_classdev *cdev)
 
 	/* Check the keyboard backlight state */
 	status = hci_read1(dev, HCI_KBD_ILLUMINATION, &state, &result);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get the keyboard backlight failed\n");
 		return LED_OFF;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Keyboard backlight not supported\n");
 		return LED_OFF;
 	}
@@ -610,10 +611,10 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
 	/* Set the keyboard backlight state */
 	state = brightness ? 1 : 0;
 	status = hci_write1(dev, HCI_KBD_ILLUMINATION, state, &result);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set KBD Illumination mode failed\n");
 		return;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		pr_info("Keyboard backlight not supported\n");
 		return;
 	}
@@ -633,7 +634,7 @@ static int toshiba_touchpad_set(struct toshiba_acpi_dev *dev, u32 state)
 	if (ACPI_FAILURE(status)) {
 		pr_err("ACPI call to set the touchpad failed\n");
 		return -EIO;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		return -ENODEV;
 	}
 
@@ -653,7 +654,7 @@ static int toshiba_touchpad_get(struct toshiba_acpi_dev *dev, u32 *state)
 	if (ACPI_FAILURE(status)) {
 		pr_err("ACPI call to query the touchpad failed\n");
 		return -EIO;
-	} else if (result == HCI_NOT_SUPPORTED) {
+	} else if (result == TOS_NOT_SUPPORTED) {
 		return -ENODEV;
 	}
 
@@ -668,7 +669,7 @@ static int toshiba_eco_mode_available(struct toshiba_acpi_dev *dev)
 	u32 out[TCI_WORDS];
 
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_info("ACPI call to get ECO led failed\n");
 		return 0;
 	}
@@ -685,7 +686,7 @@ static enum led_brightness toshiba_eco_mode_get_status(struct led_classdev *cdev
 	acpi_status status;
 
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get ECO led failed\n");
 		return LED_OFF;
 	}
@@ -705,7 +706,7 @@ static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
 	/* Switch the Eco Mode led on/off */
 	in[2] = (brightness) ? 1 : 0;
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set ECO led failed\n");
 		return;
 	}
@@ -722,14 +723,14 @@ static int toshiba_accelerometer_supported(struct toshiba_acpi_dev *dev)
 	 * this call also serves as initialization
 	 */
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
-	} else if (out[0] == HCI_DATA_NOT_AVAILABLE ||
-		   out[0] == HCI_NOT_INITIALIZED) {
+	} else if (out[0] == TOS_DATA_NOT_AVAILABLE ||
+		   out[0] == TOS_NOT_INITIALIZED) {
 		pr_err("Accelerometer not initialized\n");
 		return -EIO;
-	} else if (out[0] == HCI_NOT_SUPPORTED) {
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
 		pr_info("Accelerometer not supported\n");
 		return -ENODEV;
 	}
@@ -746,7 +747,7 @@ static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
 
 	/* Check the Accelerometer status */
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
 	}
@@ -767,7 +768,7 @@ static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
 	value = 0;
 	value2 = 0;
 	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
-	if (hci_result == HCI_SUCCESS)
+	if (hci_result == TOS_SUCCESS)
 		*present = (value & HCI_WIRELESS_BT_PRESENT) ? true : false;
 
 	return hci_result;
@@ -797,7 +798,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 	value = (blocked == false);
 
 	mutex_lock(&dev->mutex);
-	if (hci_get_radio_state(dev, &radio_state) != HCI_SUCCESS) {
+	if (hci_get_radio_state(dev, &radio_state) != TOS_SUCCESS) {
 		err = -EIO;
 		goto out;
 	}
@@ -810,7 +811,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
 	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
 
-	if (result1 != HCI_SUCCESS || result2 != HCI_SUCCESS)
+	if (result1 != TOS_SUCCESS || result2 != TOS_SUCCESS)
 		err = -EIO;
 	else
 		err = 0;
@@ -829,7 +830,7 @@ static void bt_rfkill_poll(struct rfkill *rfkill, void *data)
 	mutex_lock(&dev->mutex);
 
 	hci_result = hci_get_radio_state(dev, &value);
-	if (hci_result != HCI_SUCCESS) {
+	if (hci_result != TOS_SUCCESS) {
 		/* Can't do anything useful */
 		mutex_unlock(&dev->mutex);
 		return;
@@ -855,7 +856,7 @@ static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, bool *enabled)
 
 	hci_read1(dev, HCI_TR_BACKLIGHT, &status, &hci_result);
 	*enabled = !status;
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
@@ -864,7 +865,7 @@ static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
 	u32 value = !enable;
 
 	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
@@ -886,7 +887,7 @@ static int __get_lcd_brightness(struct toshiba_acpi_dev *dev)
 	}
 
 	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
-	if (hci_result == HCI_SUCCESS)
+	if (hci_result == TOS_SUCCESS)
 		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);
 
 	return -EIO;
@@ -941,18 +942,18 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 
 	in[2] = value << HCI_LCD_BRIGHTNESS_SHIFT;
 	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
 		pr_err("ACPI call to set brightness failed");
 		return -EIO;
 	}
 	/* Extra check for "incomplete" backlight method, where the AML code
-	 * doesn't check for HCI_SET or HCI_GET and returns HCI_SUCCESS,
+	 * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
 	 * the actual brightness, and in some cases the max brightness.
 	 */
 	if (out[2] > 0  || out[3] == 0xE000)
 		return -ENODEV;
 
-	return out[0] == HCI_SUCCESS ? 0 : -EIO;
+	return out[0] == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static int set_lcd_status(struct backlight_device *bd)
@@ -1001,7 +1002,7 @@ static int get_video_status(struct toshiba_acpi_dev *dev, u32 *status)
 	u32 hci_result;
 
 	hci_read1(dev, HCI_VIDEO_OUT, status, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static int video_proc_show(struct seq_file *m, void *v)
@@ -1105,7 +1106,7 @@ static int get_fan_status(struct toshiba_acpi_dev *dev, u32 *status)
 	u32 hci_result;
 
 	hci_read1(dev, HCI_FAN, status, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static int fan_proc_show(struct seq_file *m, void *v)
@@ -1145,7 +1146,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 	if (sscanf(cmd, " force_on : %i", &value) == 1 &&
 	    value >= 0 && value <= 1) {
 		hci_write1(dev, HCI_FAN, value, &hci_result);
-		if (hci_result != HCI_SUCCESS)
+		if (hci_result != TOS_SUCCESS)
 			return -EIO;
 		else
 			dev->force_fan = value;
@@ -1173,12 +1174,12 @@ static int keys_proc_show(struct seq_file *m, void *v)
 
 	if (!dev->key_event_valid && dev->system_event_supported) {
 		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
-		if (hci_result == HCI_SUCCESS) {
+		if (hci_result == TOS_SUCCESS) {
 			dev->key_event_valid = 1;
 			dev->last_key_event = value;
-		} else if (hci_result == HCI_EMPTY) {
+		} else if (hci_result == TOS_FIFO_EMPTY) {
 			/* better luck next time */
-		} else if (hci_result == HCI_NOT_SUPPORTED) {
+		} else if (hci_result == TOS_NOT_SUPPORTED) {
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
 			 * become disabled. */
@@ -1677,7 +1678,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		dev->info_supported = 1;
 	else {
 		hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
-		if (hci_result == HCI_SUCCESS)
+		if (hci_result == TOS_SUCCESS)
 			dev->system_event_supported = 1;
 	}
 
@@ -1857,7 +1858,7 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 		goto error;
 
 	/* Register rfkill switch for Bluetooth */
-	if (hci_get_bt_present(dev, &bt_present) == HCI_SUCCESS && bt_present) {
+	if (hci_get_bt_present(dev, &bt_present) == TOS_SUCCESS && bt_present) {
 		dev->bt_rfk = rfkill_alloc("Toshiba Bluetooth",
 					   &acpi_dev->dev,
 					   RFKILL_TYPE_BLUETOOTH,
@@ -1962,10 +1963,10 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 		do {
 			hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
 			switch (hci_result) {
-			case HCI_SUCCESS:
+			case TOS_SUCCESS:
 				toshiba_acpi_report_hotkey(dev, (int)value);
 				break;
-			case HCI_NOT_SUPPORTED:
+			case TOS_NOT_SUPPORTED:
 				/*
 				 * This is a workaround for an unresolved
 				 * issue on some machines where system events
@@ -1979,7 +1980,7 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 				retries--;
 				break;
 			}
-		} while (retries && hci_result != HCI_EMPTY);
+		} while (retries && hci_result != TOS_FIFO_EMPTY);
 	}
 }
 
-- 
2.0.0

