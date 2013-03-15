Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3COKLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:11:09 -0400
Received: from mout.web.de ([212.227.17.12]:50758 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3COKLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:11:08 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH v2 1/3] ACPI video: Fix brightness control initialization for some laptops.
Date: Fri, 15 Mar 2013 11:10:46 +0100
Message-Id: <1363342248-6496-1-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
X-Provags-ID: V02:K0:urpPtPey7XNz51emYmMIuYfAkgVijXDrXg3rZNbs/34
 DfwwboboqRWPm3vO8H6BUngCoKpBHkfAwLlCCTUwQg5hvmBeyX
 eIrIoWEal7vi4ekE+jGIn4QvDZoDtyUiETV13fp8MbKGYhOuqv
 m/s/yzcPb8bx86+l3HdbUaiMQgqHp2Ps4cHI5P7/n1x8hJ0Fje
 GGDHBVG2P/Z3wk3d5tlRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular, this fixes brightness control initialization for all
devices that return index values from _BQC and don't happen to have the
initial index set by the BIOS in their _BCL table. One example for that
is the Dell Inspiron 15R SE (model number 7520).

What happened for those devices is that acpi_init_brightness queried the
initial brightness by calling acpi_video_device_lcd_get_level_current.
This called _BQC, which returned e.g. 13. As _BQC_use_index isn't
determined at this point (and thus has its initial value of 0), the
index isn't converted into the actual level. As '13' isn't present in
the _BCL list, *level is later overwritten with brightness->curr, which
was initialized to max_level (100) before. Later in
acpi_init_brightness, level_old (with the value 100) is used as an index
into the _BCL table, which causes a value outside of the actual table to
be used as input into acpi_video_device_lcd_set_level(). Depending on
the (undefined) value of that location, this call will fail, causing the
brightness control for the device in question not to be enabled.

Fix that by returning the raw value returned by the _BQC call in the
initialization case.

Signed-off-by: Danny Baumann <dannybaumann@web.de>
---
 drivers/acpi/video.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 313f959..9c33871 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -222,7 +222,7 @@ static int acpi_video_device_lcd_set_level(struct acpi_video_device *device,
 			int level);
 static int acpi_video_device_lcd_get_level_current(
 			struct acpi_video_device *device,
-			unsigned long long *level, int init);
+			unsigned long long *level, int raw);
 static int acpi_video_get_next_level(struct acpi_video_device *device,
 				     u32 level_current, u32 event);
 static int acpi_video_switch_brightness(struct acpi_video_device *device,
@@ -452,7 +452,7 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 
 static int
 acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
-					unsigned long long *level, int init)
+					unsigned long long *level, int raw)
 {
 	acpi_status status = AE_OK;
 	int i;
@@ -463,6 +463,15 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 		status = acpi_evaluate_integer(device->dev->handle, buf,
 						NULL, level);
 		if (ACPI_SUCCESS(status)) {
+			if (raw) {
+				/*
+				 * Caller has indicated he wants the raw
+				 * value returned by _BQC, so don't furtherly
+				 * mess with the value.
+				 */
+				return 0;
+			}
+
 			if (device->brightness->flags._BQC_use_index) {
 				if (device->brightness->flags._BCL_reversed)
 					*level = device->brightness->count
@@ -476,16 +485,14 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 					device->brightness->curr = *level;
 					return 0;
 			}
-			if (!init) {
-				/*
-				 * BQC returned an invalid level.
-				 * Stop using it.
-				 */
-				ACPI_WARNING((AE_INFO,
-					      "%s returned an invalid level",
-					      buf));
-				device->cap._BQC = device->cap._BCQ = 0;
-			}
+			/*
+			 * BQC returned an invalid level.
+			 * Stop using it.
+			 */
+			ACPI_WARNING((AE_INFO,
+				      "%s returned an invalid level",
+				      buf));
+			device->cap._BQC = device->cap._BCQ = 0;
 		} else {
 			/* Fixme:
 			 * should we return an error or ignore this failure?
@@ -714,7 +721,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	if (result)
 		goto out_free_levels;
 
-	result = acpi_video_device_lcd_get_level_current(device, &level, 0);
+	result = acpi_video_device_lcd_get_level_current(device, &level, 1);
 	if (result)
 		goto out_free_levels;
 
-- 
1.8.1.4

