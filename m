Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3CSQXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:23:04 -0400
Received: from mout.web.de ([212.227.15.4]:49168 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab3CSQXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:23:01 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH v4 3/3] ACPI video: Fix applying indexed initial brightness value.
Date: Tue, 19 Mar 2013 17:22:52 +0100
Message-Id: <1363710172-2906-3-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363710172-2906-1-git-send-email-dannybaumann@web.de>
References: <1363710172-2906-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:OLFghg0edyjj04HtbF66JO5Vssg164mg6DJmYz8Mi61
 TjwZTStPS8yCPCcPERPwlG2mDkTh+/BdmBxKRctKAPrVycJqxc
 nNGw9CHnG+mtIq+khv8GaFZi7imdTp6wcZKBMslFAHrXt5yrJF
 0mTirxk8J2/CSjm5hmIw2ze78/Fqy8MnTigPpCxkXrXk0Y6DBu
 a141A7xyKBb1FMpJAsHlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value initially read via _BQC also needs to be offset by 2 to
compensate for the first 2 special items in _BCL. Introduce a helper
function that does the BQC-value-to-level conversion in order to not
needlessly duplicate code.

Signed-off-by: Danny Baumann <dannybaumann@web.de>
---
 drivers/acpi/video.c | 60 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 89bf61e..86beaa8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -450,6 +450,31 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	{}
 };
 
+static unsigned long long
+acpi_video_bqc_value_to_level(struct acpi_video_device *device,
+			      unsigned long long bqc_value)
+{
+	unsigned long long level;
+
+	if (device->brightness->flags._BQC_use_index) {
+		/*
+		 * _BQC returns an index that doesn't account for
+		 * the first 2 items with special meaning, so we need
+		 * to compensate for that by offsetting ourselves
+		 */
+		if (device->brightness->flags._BCL_reversed)
+			bqc_value = device->brightness->count - 3 - bqc_value;
+
+		level = device->brightness->levels[bqc_value + 2];
+	} else {
+		level = bqc_value;
+	}
+
+	level += bqc_offset_aml_bug_workaround;
+
+	return level;
+}
+
 static int
 acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 					unsigned long long *level, bool raw)
@@ -472,14 +497,8 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 				return 0;
 			}
 
-			if (device->brightness->flags._BQC_use_index) {
-				if (device->brightness->flags._BCL_reversed)
-					*level = device->brightness->count
-								 - 3 - (*level);
-				*level = device->brightness->levels[*level + 2];
+			*level = acpi_video_bqc_value_to_level(device, *level);
 
-			}
-			*level += bqc_offset_aml_bug_workaround;
 			for (i = 2; i < device->brightness->count; i++)
 				if (device->brightness->levels[i] == *level) {
 					device->brightness->curr = *level;
@@ -728,24 +747,19 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 
 	br->flags._BQC_use_index = (level == max_level ? 0 : 1);
 
-	if (!br->flags._BQC_use_index) {
+	if (use_bios_initial_backlight) {
+		level = acpi_video_bqc_value_to_level(device, level_old);
 		/*
-		 * Set the backlight to the initial state.
-		 * On some buggy laptops, _BQC returns an uninitialized value
-		 * when invoked for the first time, i.e. level_old is invalid.
-		 * set the backlight to max_level in this case
+		 * On some buggy laptops, _BQC returns an uninitialized
+		 * value when invoked for the first time, i.e.
+		 * level_old is invalid (no matter whether it's a level
+		 * or an index). Set the backlight to max_level in this case.
 		 */
-		if (use_bios_initial_backlight) {
-			for (i = 2; i < br->count; i++)
-				if (level_old == br->levels[i]) {
-					level = level_old;
-					break;
-				}
-		}
-	} else {
-		if (br->flags._BCL_reversed)
-			level_old = (br->count - 1) - level_old;
-		level = br->levels[level_old];
+		for (i = 2; i < br->count; i++)
+			if (level_old == br->levels[i])
+				break;
+		if (i == br->count)
+			level = max_level;
 	}
 
 set_level:
-- 
1.8.1.4

