Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3CNKev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:34:51 -0400
Received: from mout.web.de ([212.227.17.12]:55631 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab3CNKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:34:48 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 3/3] ACPI video: Fix applying indexed initial brightness value.
Date: Thu, 14 Mar 2013 11:34:24 +0100
Message-Id: <1363257264-15984-4-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363257264-15984-1-git-send-email-dannybaumann@web.de>
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:ZxyMBB0wejwQeP0OH09ORO28TXWnen5f/qow5Lggiun
 fIAcIDYVg9MKJVWMiZuz1MeqMG1v6q6I9LnaRzHQpKRu+Bjjzi
 LvJceKvfQvluaoDOMWmCNQr5tkNRrM295r5+F1qP1gLVgxycHb
 PTURtnvfEPHQHHiPl28/fF8+FeaFnefZZSCdPL1AsCAimVkTqf
 zBkmH94/WBe82xoHKckCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value initially read via _BQC also needs to be offset by 2 to
compensate for the first 2 special items in _BCL. Introduce a helper
function to do the conversion in order to not needlessly duplicate code.
---
 drivers/acpi/video.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index d0fade7..562ccc3 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -450,6 +450,16 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	{}
 };
 
+static unsigned long long
+acpi_video_index_to_level(struct acpi_video_device *device,
+			  unsigned long long index)
+{
+	if (device->brightness->flags._BCL_reversed)
+		index = device->brightness->count - 3 - index;
+
+	return device->brightness->levels[index + 2];
+}
+
 static int
 acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 					unsigned long long *level, int init)
@@ -472,13 +482,10 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 				return 0;
 			}
 
-			if (device->brightness->flags._BQC_use_index) {
-				if (device->brightness->flags._BCL_reversed)
-					*level = device->brightness->count
-								 - 3 - (*level);
-				*level = device->brightness->levels[*level + 2];
+			if (device->brightness->flags._BQC_use_index)
+				*level = acpi_video_index_to_level(device,
+								   *level);
 
-			}
 			*level += bqc_offset_aml_bug_workaround;
 			for (i = 2; i < device->brightness->count; i++)
 				if (device->brightness->levels[i] == *level) {
@@ -742,9 +749,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 				}
 		}
 	} else {
-		if (br->flags._BCL_reversed)
-			level_old = (br->count - 1) - level_old;
-		level = br->levels[level_old];
+		level = acpi_video_index_to_level(device, level_old);
 	}
 
 set_level:
-- 
1.8.1.4

