Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaIXAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:25:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaIXAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:24:46 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 4/4] toshiba_acpi: Adapt functions to the changes made to HCI/SCI
Date: Tue, 23 Sep 2014 18:24:28 -0600
Message-Id: <1411518268-2773-5-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch changed the return type for the HCI/SCI
read/write functions.

This patch adapts the code for that change, as now the
"result" parameter is returned by those functions, instead
of the ACPI status call.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 77 ++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 43385f7..582563d 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -459,7 +459,6 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 	struct toshiba_acpi_dev *dev = container_of(cdev,
 			struct toshiba_acpi_dev, led_dev);
 	u32 state, result;
-	acpi_status status;
 
 	/* First request : initialize communication. */
 	if (!sci_open(dev))
@@ -467,9 +466,9 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 
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
@@ -483,16 +482,15 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
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
@@ -543,14 +541,13 @@ static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
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
@@ -564,14 +561,13 @@ static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
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
@@ -587,11 +583,10 @@ static enum led_brightness toshiba_kbd_backlight_get(struct led_classdev *cdev)
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
@@ -608,12 +603,11 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
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
@@ -626,14 +620,13 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
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
@@ -646,14 +639,13 @@ static int toshiba_touchpad_set(struct toshiba_acpi_dev *dev, u32 state)
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
@@ -769,7 +761,7 @@ static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
 
 	value = 0;
 	value2 = 0;
-	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
+	hci_result = hci_read2(dev, HCI_WIRELESS, &value, &value2);
 	if (hci_result == TOS_SUCCESS)
 		*present = (value & HCI_WIRELESS_BT_PRESENT) ? true : false;
 
@@ -783,7 +775,7 @@ static u32 hci_get_radio_state(struct toshiba_acpi_dev *dev, bool *radio_state)
 
 	value = 0;
 	value2 = 0x0001;
-	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
+	hci_result = hci_read2(dev, HCI_WIRELESS, &value, &value2);
 
 	*radio_state = value & HCI_WIRELESS_KILL_SWITCH;
 	return hci_result;
@@ -810,8 +802,8 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 		goto out;
 	}
 
-	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
-	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
+	result1 = hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER);
+	result2 = hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH);
 
 	if (result1 != TOS_SUCCESS || result2 != TOS_SUCCESS)
 		err = -EIO;
@@ -856,7 +848,7 @@ static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, bool *enabled)
 	u32 hci_result;
 	u32 status;
 
-	hci_read1(dev, HCI_TR_BACKLIGHT, &status, &hci_result);
+	hci_result = hci_read1(dev, HCI_TR_BACKLIGHT, &status);
 	*enabled = !status;
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
@@ -866,7 +858,7 @@ static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
 	u32 hci_result;
 	u32 value = !enable;
 
-	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
+	hci_result = hci_write1(dev, HCI_TR_BACKLIGHT, value);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -888,7 +880,7 @@ static int __get_lcd_brightness(struct toshiba_acpi_dev *dev)
 		brightness++;
 	}
 
-	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
+	hci_result = hci_read1(dev, HCI_LCD_BRIGHTNESS, &value);
 	if (hci_result == TOS_SUCCESS)
 		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);
 
@@ -1003,7 +995,7 @@ static int get_video_status(struct toshiba_acpi_dev *dev, u32 *status)
 {
 	u32 hci_result;
 
-	hci_read1(dev, HCI_VIDEO_OUT, status, &hci_result);
+	hci_result = hci_read1(dev, HCI_VIDEO_OUT, status);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -1107,7 +1099,7 @@ static int get_fan_status(struct toshiba_acpi_dev *dev, u32 *status)
 {
 	u32 hci_result;
 
-	hci_read1(dev, HCI_FAN, status, &hci_result);
+	hci_result = hci_read1(dev, HCI_FAN, status);
 	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
@@ -1147,7 +1139,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 
 	if (sscanf(cmd, " force_on : %i", &value) == 1 &&
 	    value >= 0 && value <= 1) {
-		hci_write1(dev, HCI_FAN, value, &hci_result);
+		hci_result = hci_write1(dev, HCI_FAN, value);
 		if (hci_result != TOS_SUCCESS)
 			return -EIO;
 		else
@@ -1175,7 +1167,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 	u32 value;
 
 	if (!dev->key_event_valid && dev->system_event_supported) {
-		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
+		hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
 		if (hci_result == TOS_SUCCESS) {
 			dev->key_event_valid = 1;
 			dev->last_key_event = value;
@@ -1185,7 +1177,7 @@ static int keys_proc_show(struct seq_file *m, void *v)
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
 			 * become disabled. */
-			hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+			hci_result = hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 			pr_notice("Re-enabled hotkeys\n");
 		} else {
 			pr_err("Error reading hotkey status\n");
@@ -1679,7 +1671,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	if (acpi_has_method(dev->acpi_dev->handle, "INFO"))
 		dev->info_supported = 1;
 	else {
-		hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
+		hci_result = hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 		if (hci_result == TOS_SUCCESS)
 			dev->system_event_supported = 1;
 	}
@@ -1702,7 +1694,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		goto err_remove_filter;
 	}
 
-	hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &hci_result);
+	hci_result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	return 0;
 
  err_remove_filter:
@@ -1963,7 +1955,7 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 			toshiba_acpi_report_hotkey(dev, scancode);
 	} else if (dev->system_event_supported) {
 		do {
-			hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
+			hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
 			switch (hci_result) {
 			case TOS_SUCCESS:
 				toshiba_acpi_report_hotkey(dev, (int)value);
@@ -1974,8 +1966,7 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 				 * issue on some machines where system events
 				 * sporadically become disabled.
 				 */
-				hci_write1(dev, HCI_SYSTEM_EVENT, 1,
-					   &hci_result);
+				hci_result = hci_write1(dev, HCI_SYSTEM_EVENT, 1);
 				pr_notice("Re-enabled hotkeys\n");
 				/* fall through */
 			default:
@@ -1993,7 +1984,7 @@ static int toshiba_acpi_suspend(struct device *device)
 	u32 result;
 
 	if (dev->hotkey_dev)
-		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE, &result);
+		result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE);
 
 	return 0;
 }
@@ -2010,7 +2001,7 @@ static int toshiba_acpi_resume(struct device *device)
 		if (ACPI_FAILURE(status))
 			pr_info("Unable to re-enable hotkeys\n");
 
-		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
+		result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	}
 
 	return 0;
-- 
2.0.0

