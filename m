Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaI3C5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:57:11 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58882 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3C5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:57:09 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH] toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd type
Date: Mon, 29 Sep 2014 20:57:04 -0600
Message-Id: <1412045824-3515-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduccion of the new keyboard backlight
implementation, the *_timeout_store function is
broken, as it only supports the first kbd_type.

This patch adapt such function for the new kbd_type,
as well as convert from using sscanf to kstrtoint.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 5d509ea..13ee56b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1453,18 +1453,35 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	int time = -1;
+	int time;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &time);
+	if (ret)
+		return ret;
 
-	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
+	if (time < 1 || time > 60)
 		return -EINVAL;
 
-	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
-	if (time != -1 && toshiba->kbd_time != time) {
+	/* Set the Keyboard Backlight Timeout: 1-60 seconds */
+	
+	/* Only make a change if the actual timeout has changed */
+	if (toshiba->kbd_time != time) {
+		/* Shift the time to "base time" (0x3c0000 == 60 seconds)*/
 		time = time << HCI_MISC_SHIFT;
-		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
-							time + 1 : time + 2;
-		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
-			return -EIO;
+		/* OR the "base time" to the actual method format */
+		if (toshiba->kbd_type == 1) {
+			/* Type 1 requires the oposite mode */
+			time |= SCI_KBD_MODE_FNZ;
+		} else if (toshiba->kbd_type == 2) {
+			/* Type 2 requires the actual mode */
+			time |= SCI_KBD_MODE_AUTO;
+		}
+
+		ret = toshiba_kbd_illum_status_set(toshiba, time);
+		if (ret)
+			return ret;
+
 		toshiba->kbd_time = time >> HCI_MISC_SHIFT;
 	}
 
-- 
2.0.0

