Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3KEDsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:48:51 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42333 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3KEDst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:49 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 1/8] toshiba_acpi: Add System Configuration Interface (SCI)
Date: Mon,  4 Nov 2013 20:48:38 -0700
Message-Id: <1383623325-4004-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCI stands for System Configuration Interface and
it is supposed to be uniform across all their
models.

This patch introduces four new calls, sci_open, sci_close
sci_read and sci_write, along with its definitions and
return codes.

The HCI_ prefix has been removed from all return codes,
since they are shared among the HCI and the SCI.

More information about the SCI can be found at
Jonathan Buzzard's website [1].

[1] http://www.buzzard.me.uk/toshiba/docs.html

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 146 +++++++++++++++++++++++++++---------
 1 file changed, 112 insertions(+), 34 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index eb3467e..1e580dd 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -71,27 +71,37 @@ MODULE_LICENSE("GPL");
 /* Toshiba ACPI method paths */
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
 
-/* Toshiba HCI interface definitions
+/* TCI - Toshiba Configuration Interface definitions
  *
- * HCI is Toshiba's "Hardware Control Interface" which is supposed to
- * be uniform across all their models.  Ideally we would just call
- * dedicated ACPI methods instead of using this primitive interface.
- * However the ACPI methods seem to be incomplete in some areas (for
- * example they allow setting, but not reading, the LCD brightness value),
+ * This configuration interface is composed by the HCI (Hardware Configuration
+ * Interface) and the SCI (Software Configuration Interface), which are
+ * supposed to be uniform across all their models.  Ideally we would just call
+ * dedicated ACPI methods instead of using these primitive interfaces.
+ * However the ACPI methods seem to be incomplete in some areas (for example
+ * they allow setting, but not reading, the LCD brightness value),
  * so this is still useful.
  */
 
 #define HCI_WORDS			6
 
 /* operations */
-#define HCI_SET				0xff00
+#define SCI_OPEN			0xf100
+#define SCI_CLOSE			0xf200
+#define SCI_GET				0xf300
+#define SCI_SET				0xf400
 #define HCI_GET				0xfe00
+#define HCI_SET				0xff00
 
 /* return codes */
-#define HCI_SUCCESS			0x0000
-#define HCI_FAILURE			0x1000
-#define HCI_NOT_SUPPORTED		0x8000
-#define HCI_EMPTY			0x8c00
+#define SUCCESS				0x0000
+#define OPEN_CLOSE_SUCCESS		0x0044
+#define FAILURE				0x1000
+#define NOT_SUPPORTED			0x8000
+#define ALREADY_OPEN			0x8100
+#define NOT_OPENED			0x8200
+#define INPUT_DATA_ERROR		0x8300
+#define NOT_PRESENT			0x8600
+#define FIFO_EMPTY			0x8c00
 
 /* registers */
 #define HCI_FAN				0x0004
@@ -251,7 +261,7 @@ static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : FAILURE;
 	return status;
 }
 
@@ -262,7 +272,7 @@ static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(dev, in, out);
 	*out1 = out[2];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : FAILURE;
 	return status;
 }
 
@@ -272,7 +282,7 @@ static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = hci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : FAILURE;
 	return status;
 }
 
@@ -284,7 +294,75 @@ static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
 	acpi_status status = hci_raw(dev, in, out);
 	*out1 = out[2];
 	*out2 = out[3];
-	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+	*result = (status == AE_OK) ? out[0] : FAILURE;
+	return status;
+}
+
+/* common sci tasks
+ */
+
+static int sci_open(struct toshiba_acpi_dev *dev)
+{
+	u32 in[HCI_WORDS] = { SCI_OPEN, 0, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	status = hci_raw(dev, in, out);
+	if  (ACPI_FAILURE(status) || out[0] == FAILURE) {
+		pr_err("ACPI call to open SCI failed\n");
+		return 0;
+	}
+
+	if (out[0] == OPEN_CLOSE_SUCCESS) {
+		return 1;
+	} else if (out[0] == ALREADY_OPEN) {
+		pr_info("Toshiba SCI already opened\n");
+		return 1;
+	} else if (out[0] == NOT_PRESENT) {
+		pr_info("Toshiba SCI is not present\n");
+	}
+
+	return 0;
+}
+
+static void sci_close(struct toshiba_acpi_dev *dev)
+{
+	u32 in[HCI_WORDS] = { SCI_CLOSE, 0, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == FAILURE) {
+		pr_err("ACPI call to close SCI failed\n");
+		return;
+	}
+
+	if (out[0] == OPEN_CLOSE_SUCCESS)
+		return;
+	else if (out[0] == NOT_OPENED)
+		pr_info("Toshiba SCI not opened\n");
+	else if (out[0] == NOT_PRESENT)
+		pr_info("Toshiba SCI is not present\n");
+}
+
+static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
+			    u32 *out1, u32 *result)
+{
+	u32 in[HCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status = hci_raw(dev, in, out);
+	*out1 = out[2];
+	*result = (ACPI_SUCCESS(status)) ? out[0] : FAILURE;
+	return status;
+}
+
+static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
+			     u32 in1, u32 *result)
+{
+	u32 in[HCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status = hci_raw(dev, in, out);
+	*result = (ACPI_SUCCESS(status)) ? out[0] : FAILURE;
 	return status;
 }
 
@@ -399,7 +477,7 @@ static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
 	value = 0;
 	value2 = 0;
 	hci_read2(dev, HCI_WIRELESS, &value, &value2, &hci_result);
-	if (hci_result == HCI_SUCCESS)
+	if (hci_result == SUCCESS)
 		*present = (value & HCI_WIRELESS_BT_PRESENT) ? true : false;
 
 	return hci_result;
@@ -429,7 +507,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 	value = (blocked == false);
 
 	mutex_lock(&dev->mutex);
-	if (hci_get_radio_state(dev, &radio_state) != HCI_SUCCESS) {
+	if (hci_get_radio_state(dev, &radio_state) != SUCCESS) {
 		err = -EIO;
 		goto out;
 	}
@@ -442,7 +520,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
 	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
 
-	if (result1 != HCI_SUCCESS || result2 != HCI_SUCCESS)
+	if (result1 != SUCCESS || result2 != SUCCESS)
 		err = -EIO;
 	else
 		err = 0;
@@ -461,7 +539,7 @@ static void bt_rfkill_poll(struct rfkill *rfkill, void *data)
 	mutex_lock(&dev->mutex);
 
 	hci_result = hci_get_radio_state(dev, &value);
-	if (hci_result != HCI_SUCCESS) {
+	if (hci_result != SUCCESS) {
 		/* Can't do anything useful */
 		mutex_unlock(&dev->mutex);
 		return;
@@ -487,7 +565,7 @@ static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, bool *enabled)
 
 	hci_read1(dev, HCI_TR_BACKLIGHT, &status, &hci_result);
 	*enabled = !status;
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == SUCCESS ? 0 : -EIO;
 }
 
 static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
@@ -496,7 +574,7 @@ static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
 	u32 value = !enable;
 
 	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == SUCCESS ? 0 : -EIO;
 }
 
 static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
@@ -518,7 +596,7 @@ static int __get_lcd_brightness(struct toshiba_acpi_dev *dev)
 	}
 
 	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
-	if (hci_result == HCI_SUCCESS)
+	if (hci_result == SUCCESS)
 		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);
 
 	return -EIO;
@@ -571,7 +649,7 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 
 	value = value << HCI_LCD_BRIGHTNESS_SHIFT;
 	hci_write1(dev, HCI_LCD_BRIGHTNESS, value, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == SUCCESS ? 0 : -EIO;
 }
 
 static int set_lcd_status(struct backlight_device *bd)
@@ -620,7 +698,7 @@ static int get_video_status(struct toshiba_acpi_dev *dev, u32 *status)
 	u32 hci_result;
 
 	hci_read1(dev, HCI_VIDEO_OUT, status, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == SUCCESS ? 0 : -EIO;
 }
 
 static int video_proc_show(struct seq_file *m, void *v)
@@ -724,7 +802,7 @@ static int get_fan_status(struct toshiba_acpi_dev *dev, u32 *status)
 	u32 hci_result;
 
 	hci_read1(dev, HCI_FAN, status, &hci_result);
-	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+	return hci_result == SUCCESS ? 0 : -EIO;
 }
 
 static int fan_proc_show(struct seq_file *m, void *v)
@@ -764,7 +842,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 	if (sscanf(cmd, " force_on : %i", &value) == 1 &&
 	    value >= 0 && value <= 1) {
 		hci_write1(dev, HCI_FAN, value, &hci_result);
-		if (hci_result != HCI_SUCCESS)
+		if (hci_result != SUCCESS)
 			return -EIO;
 		else
 			dev->force_fan = value;
@@ -792,12 +870,12 @@ static int keys_proc_show(struct seq_file *m, void *v)
 
 	if (!dev->key_event_valid && dev->system_event_supported) {
 		hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
-		if (hci_result == HCI_SUCCESS) {
+		if (hci_result == SUCCESS) {
 			dev->key_event_valid = 1;
 			dev->last_key_event = value;
-		} else if (hci_result == HCI_EMPTY) {
+		} else if (hci_result == FIFO_EMPTY) {
 			/* better luck next time */
-		} else if (hci_result == HCI_NOT_SUPPORTED) {
+		} else if (hci_result == NOT_SUPPORTED) {
 			/* This is a workaround for an unresolved issue on
 			 * some machines where system events sporadically
 			 * become disabled. */
@@ -1032,7 +1110,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		dev->info_supported = 1;
 	} else {
 		hci_write1(dev, HCI_SYSTEM_EVENT, 1, &hci_result);
-		if (hci_result == HCI_SUCCESS)
+		if (hci_result == SUCCESS)
 			dev->system_event_supported = 1;
 	}
 
@@ -1206,7 +1284,7 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 		goto error;
 
 	/* Register rfkill switch for Bluetooth */
-	if (hci_get_bt_present(dev, &bt_present) == HCI_SUCCESS && bt_present) {
+	if (hci_get_bt_present(dev, &bt_present) == SUCCESS && bt_present) {
 		dev->bt_rfk = rfkill_alloc("Toshiba Bluetooth",
 					   &acpi_dev->dev,
 					   RFKILL_TYPE_BLUETOOTH,
@@ -1274,10 +1352,10 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 		do {
 			hci_read1(dev, HCI_SYSTEM_EVENT, &value, &hci_result);
 			switch (hci_result) {
-			case HCI_SUCCESS:
+			case SUCCESS:
 				toshiba_acpi_report_hotkey(dev, (int)value);
 				break;
-			case HCI_NOT_SUPPORTED:
+			case NOT_SUPPORTED:
 				/*
 				 * This is a workaround for an unresolved
 				 * issue on some machines where system events
@@ -1291,7 +1369,7 @@ static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 				retries--;
 				break;
 			}
-		} while (retries && hci_result != HCI_EMPTY);
+		} while (retries && hci_result != FIFO_EMPTY);
 	}
 }
 
-- 
1.8.1.4

