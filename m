Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJDSCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 14:02:42 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39279 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaJDSCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 14:02:41 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2] toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd type
Date: Sat,  4 Oct 2014 12:02:21 -0600
Message-Id: <1412445741-7719-1-git-send-email-coproscefalo@gmail.com>
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
Changes since v1:
- Check for timeout values depending on kbd_type
- Removed some misleading comments

Note: I'll be out of town until the next weekend,
in case something else needs to be changed, I'll
catch up whenever I'm back.

 drivers/platform/x86/toshiba_acpi.c | 38 ++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 5d509ea..f360dac 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1453,18 +1453,38 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	int time = -1;
+	int time;
+	int ret;
 
-	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
-		return -EINVAL;
+	ret = kstrtoint(buf, 0, &time);
+	if (ret)
+		return ret;
 
-	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
-	if (time != -1 && toshiba->kbd_time != time) {
+	/* Check for supported values depending on kbd_type */
+	if (toshiba->kbd_type == 1) {
+		if (time < 0 || time > 60)
+			return -EINVAL;
+	} else if (toshiba->kbd_type == 2) {
+		if (time < 1 || time > 60)
+			return -EINVAL;
+	}
+
+	/* Set the Keyboard Backlight Timeout */
+	
+	/* Only make a change if the actual timeout has changed */
+	if (toshiba->kbd_time != time) {
+		/* Shift the time to "base time" (0x3c0000 == 60 seconds) */
 		time = time << HCI_MISC_SHIFT;
-		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
-							time + 1 : time + 2;
-		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
-			return -EIO;
+		/* OR the "base time" to the actual method format */
+		if (toshiba->kbd_type == 1)
+			time |= SCI_KBD_MODE_FNZ;
+		else if (toshiba->kbd_type == 2)
+			time |= SCI_KBD_MODE_AUTO;
+
+		ret = toshiba_kbd_illum_status_set(toshiba, time);
+		if (ret)
+			return ret;
+
 		toshiba->kbd_time = time >> HCI_MISC_SHIFT;
 	}
 
-- 
2.0.0

