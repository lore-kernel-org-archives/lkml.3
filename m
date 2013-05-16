Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab3EPEFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:05:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64362 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3EPEFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:05:03 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: rui.zhang@intel.com, mjg@redhat.com, rjw@sisk.pl
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Len Brown <lenb@kernel.org>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Aaron Lu <aaron.lu@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH v2 2/2] acer-wmi: add Acer Aspire 5750G to video vendor list but keep acpi video driver
Date: Thu, 16 May 2013 12:01:48 +0800
Message-Id: <1368676908-17274-2-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1368676908-17274-1-git-send-email-jlee@suse.com>
References: <1368676908-17274-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Andrzej's testing, we found the acpi backlight methods broken on Acer
Aspire 5750G but the i915 backlight control works when we set to vendor mode.
And, we still want to keep the acpi/video driver for transfer acpi event to key
event but not unregister whole acpi/video driver.

This patch introduced a new capability flag is ACER_CAP_KEEP_VIDEO_KEY, it
indicates the machine works fine with acpi/video driver for key event but want
to unregister the backlight interface of acpi/video.

Reference: bko#35622
        https://bugzilla.kernel.org/show_bug.cgi?id=35622

v2: changed the information statement of keeping acpi video driver.

Tested-by: Andrzej Krentosz <endrjux@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
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
index c9076bd..a81c9ed 100644
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
+	pr_info("Keeping acpi video driver active to emit backlight brightness change key events\n");
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
1.6.4.2

