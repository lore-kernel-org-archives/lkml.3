Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaI3Cki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:40:38 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48384 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaI3CkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:40:18 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 3/3] toshiba_acpi: Change HCI/SCI functions return code type
Date: Mon, 29 Sep 2014 20:40:09 -0600
Message-Id: <1412044809-3366-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
References: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the HCI/SCI read/write functions are returning
the status of the ACPI call and also assigning the
returned value of the HCI/SCI function, however, only
the HCI/SCI status is being checked.

This patch changes such functions, returning the value
of the HCI/SCI function instead of the ACPI call status,
eliminating one parameter, and returning something
useful that indeed is being checked.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 129 +++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 67 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 589a858..5d509ea 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -317,47 +317,49 @@ static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
  * may be useful (such as "not supported").
  */
 
-static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
-			      u32 in1, u32 *result)
+static u32 hci_write1(struct toshiba_acpi_dev *dev, u32 reg, u32 in1)
 {
 	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
-static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 *out1, u32 *result)
+static u32 hci_read1(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1)
 {
 	u32 in[TCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
-static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
-			      u32 in1, u32 in2, u32 *result)
+static u32 hci_write2(struct toshiba_acpi_dev *dev, u32 reg, u32 in1, u32 in2)
 {
 	u32 in[TCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
-static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 *out1, u32 *out2, u32 *result)
+static u32 hci_read2(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1, u32 *out2)
 {
 	u32 in[TCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
 	*out2 = out[3];
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
 /* common sci tasks
@@ -407,25 +409,26 @@ static void sci_close(struct toshiba_acpi_dev *dev)
 		pr_info("Toshiba SCI is not present\n");
 }
 
-static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
-			    u32 *out1, u32 *result)
+static u32 sci_read(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1)
 {
 	u32 in[TCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
-	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
-static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 in1, u32 *result)
+static u32 sci_write(struct toshiba_acpi_dev *dev, u32 reg, u32 in1)
 {
 	u32 in[TCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[TCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
 /* Illumination support */
@@ -457,7 +460,6 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, led_dev);
 	u32 state, result;
-	acpi_status status;
 
 	/* First request : initialize communication. */
 	if (!sci_open(dev))
@@ -465,9 +467,9 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 
 	/* Switch the illumination on/off */
 	state = brightness ? 1 : 0;
-	status = sci_write(dev, SCI_ILLUMINATION, state, &result);
+	result = sci_write(dev, SCI_ILLUMINATION, state);
 	sci_close(dev);
-	if (ACPI_FAILURE(status)) {
+	if (result == TOS_FAILURE) {
 		pr_err("ACPI call for illumination failed\n");
 		return;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -481,16 +483,15 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, led_dev);
 	u32 state, result;
-	acpi_status status;
 
 	/* First request : initialize communication. */
 	if (!sci_open(dev))
 		return LED_OFF;
 
 	/* Check the illumination */
-	status = sci_read(dev, SCI_ILLUMINATION, &state, &result);
+	result = sci_read(dev, SCI_ILLUMINATION, &state);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
+	if (result == TOS_FAILURE || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call for illumination failed\n");
 		return LED_OFF;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -541,14 +542,13 @@ static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
 static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
 {
 	u32 result;
-	acpi_status status;
 
 	if (!sci_open(dev))
 		return -EIO;
 
-	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	result = sci_write(dev, SCI_KBD_ILLUM_STATUS, time);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
+	if (result == TOS_FAILURE || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set KBD backlight status failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -562,14 +562,13 @@ static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
 static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
 {
 	u32 result;
-	acpi_status status;
 
 	if (!sci_open(dev))
 		return -EIO;
 
-	status = sci_read(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	result = sci_read(dev, SCI_KBD_ILLUM_STATUS, time);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
+	if (result == TOS_FAILURE || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get KBD backlight status failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -585,11 +584,10 @@ static enum led_brightness toshiba_kbd_backlight_get(struct led_classdev *cdev)
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, kbd_led);
 	u32 state, result;
-	acpi_status status;
 
 	/* Check the keyboard backlight state */
-	status = hci_read1(dev, HCI_KBD_ILLUMINATION, &state, &result);
-	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
+	result = hci_read1(dev, HCI_KBD_ILLUMINATION, &state);
+	if (result == TOS_FAILURE || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get the keyboard backlight failed\n");
 		return LED_OFF;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -606,12 +604,11 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, kbd_led);
 	u32 state, result;
-	acpi_status status;
 
 	/* Set the keyboard backlight state */
 	state = brightness ? 1 : 0;
-	status = hci_write1(dev, HCI_KBD_ILLUMINATION, state, &result);
-	if (ACPI_FAILURE(status) || result == TOS_INPUT_DATA_ERROR) {
+	result = hci_write1(dev, HCI_KBD_ILLUMINATION, state);
+	if (result == TOS_FAILURE || result == TOS_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set KBD Illumination mode failed\n");
 		return;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -624,14 +621,13 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
 static int toshiba_touchpad_set(struct toshiba_acpi_dev *dev, u32 state)
 {
 	u32 result;
-	acpi_status status;
 
 	if (!sci_open(dev))
 		return -EIO;
 
-	status = sci_write(dev, SCI_TOUCHPAD, state, &result);
+	result = sci_write(dev, SCI_TOUCHPAD, state);
 	sci_close(dev);
-	if (ACPI_FAILURE(status)) {
+	if (result == TOS_FAILURE) {
 		pr_err("ACPI call to set the touchpad failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -644,14 +640,13 @@ static int toshiba_touchpad_set(struct toshiba_acpi_dev *dev, u32 state)
 static int toshiba_touchpad_get(struct toshiba_acpi_dev *dev, u32 *state)
 {
 	u32 result;
-	acpi_status status;
 
 	if (!sci_open(dev))
 		return -EIO;
 
-	status = sci_read(dev, SCI_TOUCHPAD, state, &result);
+	result = sci_read(dev, SCI_TOUCHPAD, state);
 	sci_close(dev);
-	if (ACPI_FAILURE(status)) {
+	if (result == TOS_FAILURE) {
 		pr_err("ACPI call to query the touchpad failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
@@ -767,7 +762,7 @@ static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
 
 	value = 0;
 	value2 = 0;
-	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
+	hci_result = hci_read2(dev, HCI_WIRELESS, &value, &value2);
 	if (hci_result == TOS_SUCCESS)
 		*present = (value & HCI_WIRELESS_BT_PRESENT) ? true : false;
 
@@ -781,7 +776,7 @@ static u32 hci_get_radio_state(struct toshiba_acpi_dev *dev, bool *radio_state)
 
 	value = 0;
 	value2 = 0x0001;
-	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
+	hci_result = hci_read2(dev, HCI_WIRELESS, &value, &value2);
 
 	*radio_state = value & HCI_WIRELESS_KILL_SWITCH;
 	return hci_result;
@@ -808,8 +803,8 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 		goto out;
 	}
 
-	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
-	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
+	result1 = hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER);
+	result2 = hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH);
 
 	if (result1 != TOS_SUCCESS || result2 != TOS_SUCCESS)
 		err = -EIO;
@@ -854,7 +849,7 @@ static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, bool *enabled)
 	u32 hci_result;
 	u32 status;
 
-	hci_read1(dev, HCI_TR_BACKLIGHT, &status, &hci_result);
+	hci_result = hci_read1(dev, HCI_TR_BACKLIGHT, &status);
 	*enabled = !status;
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
@@ -864,7 +859,7 @@ static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
 	u32 hci_result;
 	u32 value = !enable;
 
-	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
+	hci_result = hci_write1(dev, HCI_TR_BACKLIGHT, value);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -886,7 +881,7 @@ static int __get_lcd_brightness(struct toshiba_acpi_dev *dev)
 		brightness++;
 	}
 
-	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
+	hci_result = hci_read1(dev, HCI_LCD_BRIGHTNESS, &value);
 	if (hci_result == TOS_SUCCESS)
 		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);
 
@@ -1001,7 +996,7 @@ static int get_video_status(struct toshiba_acpi_dev *dev, u32 *status)
 {
 	u32 hci_result;
 
-	hci_read1(dev, HCI_VIDEO_OUT, status, &hci_result);
+	hci_result = hci_read1(dev, HCI_VIDEO_OUT, status);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -1105,7 +1100,7 @@ static int get_fan_status(struct toshiba_acpi_dev *dev, u32 *status)
 {
 	u32 hci_result;
 
-	hci_read1(dev, HCI_FAN, status, &hci_result);
+	hci_result = hci_read1(dev, HCI_FAN, status);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -1145,7 +1140,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 
 	if (sscanf(cmd, " force_on : %i", &value) == 1 &&
 	    value >= 0 && value <= 1) {
-		hci_write1(dev, HCI_FAN, value, &hci_result);
+		hci_result = hci_write1(dev, HCI_FAN, value);
 		if (hci_result != TOS_SUCCESS)
 			return -EIO;
 		else
@@ -1173,7 +1168,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 	u32 value;
 
 	if (!dev->key_event_valid && dev->system_event_supported) {
-		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
+		hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
 		if (hci_result == TOS_SUCCESS) {
 			dev->key_event_valid = 1;
 			dev->last_key_event = value;
@@ -1183,7 +1178,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
 			 * become disabled. */
-			hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+			hci_result = hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 			pr_notice("Re-enabled hotkeys\n");
 		} else {
 			pr_err("Error reading hotkey status\n");
@@ -1677,7 +1672,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	if (acpi_has_method(dev->acpi_dev->handle, "INFO"))
 		dev->info_supported = 1;
 	else {
-		hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+		hci_result = hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 		if (hci_result == TOS_SUCCESS)
 			dev->system_event_supported = 1;
 	}
@@ -1700,7 +1695,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		goto err_remove_filter;
 	}
 
-	hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &hci_result);
+	hci_result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	return 0;
 
  err_remove_filter:
@@ -1961,7 +1956,7 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 			toshiba_acpi_report_hotkey(dev, scancode);
 	} else if (dev->system_event_supported) {
 		do {
-			hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
+			hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
 			switch (hci_result) {
 			case TOS_SUCCESS:
 				toshiba_acpi_report_hotkey(dev, (int)value);
@@ -1972,8 +1967,8 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 				 * issue on some machines where system events
 				 * sporadically become disabled.
 				 */
-				hci_write1(dev, HCI_SYSTEM_EVENT, 1,
-					   &hci_result);
+				hci_result =
+					hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 				pr_notice("Re-enabled hotkeys\n");
 				/* fall through */
 			default:
@@ -1991,7 +1986,7 @@ static int toshiba_acpi_suspend(struct device *device)
 	u32 result;
 
 	if (dev->hotkey_dev)
-		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE, &result);
+		result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE);
 
 	return 0;
 }
@@ -2008,7 +2003,7 @@ static int toshiba_acpi_resume(struct device *device)
 		if (ACPI_FAILURE(status))
 			pr_info("Unable to re-enable hotkeys\n");
 
-		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
+		result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	}
 
 	return 0;
-- 
2.0.0

