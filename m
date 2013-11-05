Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3KEDug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:50:36 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35378 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3KEDsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:51 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 2/8] toshiba_acpi: Adapt illumination_* code to use the new SCI
Date: Mon,  4 Nov 2013 20:48:39 -0700
Message-Id: <1383623325-4004-3-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the toshiba_illumination_* code to use the newly
introduced sci_read and sci_write functions, and in the
process fix toshiba_illumination_available code, since
it was only opening the SCI and the return value was
never checked for errors or actual illumination support.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 91 ++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 58 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 1e580dd..d7ecef3 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -111,6 +111,7 @@ MODULE_LICENSE("GPL");
 #define HCI_HOTKEY_EVENT		0x001e
 #define HCI_LCD_BRIGHTNESS		0x002a
 #define HCI_WIRELESS			0x0056
+#define SCI_ILLUMINATION		0x014e
 
 /* field definitions */
 #define HCI_HOTKEY_DISABLE		0x0b
@@ -369,18 +370,23 @@ static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
 /* Illumination support */
 static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
 {
-	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
+	u32 in[TCI_WORDS] = { SCI_GET, SCI_ILLUMINATION, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status;
 
-	in[0] = 0xf100;
+	if (!sci_open(dev))
+		return 0;
+
 	status = hci_raw(dev, in, out);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status) || out[0] == FAILURE) {
+		pr_err("ACPI call to query Illumination support failed\n");
+		return 0;
+	} else if (out[0] == NOT_SUPPORTED || out[1] != 1) {
 		pr_info("Illumination device not available\n");
 		return 0;
 	}
-	in[0] = 0xf400;
-	status = hci_raw(dev, in, out);
+	sci_close(dev);
+
 	return 1;
 }
 
@@ -391,43 +397,23 @@ static void toshiba_illumination_set(struct led_classdev *cdev,
 			struct toshiba_acpi_dev, led_dev);
 	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
+	u32 state, result;
 	acpi_status status;
 
-	/* First request : initialize communication. */
-	in[0] = 0xf100;
-	status = hci_raw(dev, in, out);
-	if (ACPI_FAILURE(status)) {
-		pr_info("Illumination device not available\n");
+	if (!sci_open(dev))
 		return;
-	}
 
-	if (brightness) {
-		/* Switch the illumination on */
-		in[0] = 0xf400;
-		in[1] = 0x14e;
-		in[2] = 1;
-		status = hci_raw(dev, in, out);
-		if (ACPI_FAILURE(status)) {
-			pr_info("ACPI call for illumination failed\n");
-			return;
-		}
-	} else {
-		/* Switch the illumination off */
-		in[0] = 0xf400;
-		in[1] = 0x14e;
-		in[2] = 0;
-		status = hci_raw(dev, in, out);
-		if (ACPI_FAILURE(status)) {
-			pr_info("ACPI call for illumination failed.\n");
-			return;
-		}
+	/* Switch the illumination on/off */
+	state = brightness ? 1 : 0;
+	status = sci_write(dev, SCI_ILLUMINATION, state, &result);
+	if (ACPI_FAILURE(status)) {
+		pr_err("ACPI call for illumination failed\n");
+		return;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Illumination not supported\n");
+		return;
 	}
-
-	/* Last request : close communication. */
-	in[0] = 0xf200;
-	in[1] = 0;
-	in[2] = 0;
-	hci_raw(dev, in, out);
+	sci_close(dev);
 }
 
 static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
@@ -436,35 +422,24 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 			struct toshiba_acpi_dev, led_dev);
 	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
+	u32 state, result;
 	acpi_status status;
-	enum led_brightness result;
 
-	/* First request : initialize communication. */
-	in[0] = 0xf100;
-	status = hci_raw(dev, in, out);
-	if (ACPI_FAILURE(status)) {
-		pr_info("Illumination device not available\n");
+	if (!sci_open(dev))
 		return LED_OFF;
-	}
 
 	/* Check the illumination */
-	in[0] = 0xf300;
-	in[1] = 0x14e;
-	status = hci_raw(dev, in, out);
-	if (ACPI_FAILURE(status)) {
-		pr_info("ACPI call for illumination failed.\n");
+	status = sci_read(dev, SCI_ILLUMINATION, &state, &result);
+	if (ACPI_FAILURE(status) || result == INPUT_DATA_ERROR) {
+		pr_err("ACPI call for illumination failed\n");
+		return LED_OFF;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Illumination not supported\n");
 		return LED_OFF;
 	}
+	sci_close(dev);
 
-	result = out[2] ? LED_FULL : LED_OFF;
-
-	/* Last request : close communication. */
-	in[0] = 0xf200;
-	in[1] = 0;
-	in[2] = 0;
-	hci_raw(dev, in, out);
-
-	return result;
+	return state ? LED_FULL : LED_OFF;
 }
 
 /* Bluetooth rfkill handlers */
-- 
1.8.1.4

