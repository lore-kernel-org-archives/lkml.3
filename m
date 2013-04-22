Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3DVMkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:40:31 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:44546 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3DVMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:40:27 -0400
From: Chun-Yi Lee <joeyli.kernel@gmail.com>
To: mjg@redhat.com, rjw@sisk.pl
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Aaron Lu <aaron.lu@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/2] acer-wmi: add Acer Aspire 5750G to video vendor list but keep acpi video driver
Date: Mon, 22 Apr 2013 20:39:14 +0800
Message-Id: <1366634355-26482-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@suse.com>

After Andrzej's testing, we found the acpi backlight methods broken on Acer
Aspire 5750G but the i915 backlight control works when we set to vendor mode.
And, we still want to keep the acpi/video driver for transfer acpi event to key
event but not unregister whole acpi/video driver.

This patch introduced a new capability flag is ACER_CAP_KEEP_VIDEO_KEY, it
indicates the machine works fine with acpi/video driver for key event but want
to unregister the backlight interface of acpi/video.

Reference: bko#35622
        https://bugzilla.kernel.org/show_bug.cgi?id=35622

Tested-by: Andrzej Krentosz <endrjux@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/platform/x86/acer-wmi.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c9076bd..2a02409 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -207,6 +207,7 @@ struct hotkey_function_type_aa {
 #define ACER_CAP_BRIGHTNESS		(1<<3)
 #define ACER_CAP_THREEG			(1<<4)
 #define ACER_CAP_ACCEL			(1<<5)
+#define ACER_CAP_KEEP_VIDEO_KEY		(1<<6)
 #define ACER_CAP_ANY			(0xFFFFFFFF)
 
 /*
@@ -539,6 +540,15 @@ static int video_set_backlight_video_vendor(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int video_set_backlight_video_vendor_keep_acpi_video(
+		const struct dmi_system_id *d)
+{
+	video_set_backlight_video_vendor(d);
+	interface->capability |= ACER_CAP_KEEP_VIDEO_KEY;
+	pr_info("Keep acpi video driver for emit keycode against backlight change\n");
+	return 0;
+}
+
 static const struct dmi_system_id video_vendor_dmi_table[] = {
 	{
 		.callback = video_set_backlight_video_vendor,
@@ -572,6 +582,14 @@ static const struct dmi_system_id video_vendor_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5750"),
 		},
 	},
+	{
+		.callback = video_set_backlight_video_vendor_keep_acpi_video,
+		.ident = "Acer Aspire 5750G",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5750G"),
+		},
+	},
 	{}
 };
 
@@ -2228,6 +2246,8 @@ static int __init acer_wmi_init(void)
 	if (acpi_video_backlight_support()) {
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 		pr_info("Brightness must be controlled by acpi video driver\n");
+	} else if (interface->capability & ACER_CAP_KEEP_VIDEO_KEY) {
+		acpi_video_backlight_unregister();
 	} else {
 		pr_info("Disabling ACPI video driver\n");
 		acpi_video_unregister();
-- 
1.6.0.2

