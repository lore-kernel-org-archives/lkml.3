Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3EPEE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:04:57 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54619 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPEEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:04:55 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: rui.zhang@intel.com, mjg@redhat.com, rjw@sisk.pl
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Len Brown <lenb@kernel.org>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Aaron Lu <aaron.lu@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH v2 1/2] acpi: video: add function to support unregister backlight interface
Date: Thu, 16 May 2013 12:01:47 +0800
Message-Id: <1368676908-17274-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have some situation we unregister whole acpi/video driver by downstream
driver just want to remove backlight control interface of acpi/video. It caues
we lost other functions of acpi/video, e.g. transfer acpi event to input event.

So, this patch add a new function, find_video_unregister_backlight, it provide
the interface let downstream driver can tell acpi/video to unregister backlight
interface of all acpi video devices. Then we can keep functions of acpi/video
but only remove backlight support.

Reference: bko#35622
        https://bugzilla.kernel.org/show_bug.cgi?id=35622

v2: Also unregister cooling devices.

Tested-by: Andrzej Krentosz <endrjux@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/acpi/video.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/video.h |    2 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index c3932d0..f21104d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1861,6 +1861,60 @@ static int __init intel_opregion_present(void)
 	return opregion;
 }
 
+static acpi_status
+find_video_unregister_backlight(acpi_handle handle, u32 lvl, void *context,
+				void **rv)
+{
+	struct acpi_device *acpi_dev;
+	struct acpi_video_bus *video;
+	struct acpi_video_device *dev, *next;
+
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		return AE_OK;
+
+	if (!acpi_match_device_ids(acpi_dev, video_device_ids)) {
+		video = acpi_driver_data(acpi_dev);
+		acpi_video_bus_stop_devices(video);
+		mutex_lock(&video->device_list_lock);
+		list_for_each_entry_safe(dev, next, &video->video_device_list,
+					entry) {
+			if (dev->backlight) {
+				backlight_device_unregister(dev->backlight);
+				dev->backlight = NULL;
+				kfree(dev->brightness->levels);
+				kfree(dev->brightness);
+			}
+			if (dev->cooling_dev) {
+				sysfs_remove_link(&dev->dev->dev.kobj,
+						  "thermal_cooling");
+				sysfs_remove_link(&dev->cooling_dev->device.kobj,
+						  "device");
+				thermal_cooling_device_unregister(dev->cooling_dev);
+				dev->cooling_dev = NULL;
+			}
+		}
+		mutex_unlock(&video->device_list_lock);
+		acpi_video_bus_start_devices(video);
+	}
+	return AE_OK;
+}
+
+void acpi_video_backlight_unregister(void)
+{
+	if (!register_count) {
+		/*
+		 * If the acpi video bus is already unloaded, don't
+		 * unregister backlight of devices and return directly.
+		 */
+		return;
+	}
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX, find_video_unregister_backlight,
+			    NULL, NULL, NULL);
+	return;
+}
+EXPORT_SYMBOL(acpi_video_backlight_unregister);
+
 int acpi_video_register(void)
 {
 	int result = 0;
diff --git a/include/acpi/video.h b/include/acpi/video.h
index 61109f2..1e810a1 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -19,11 +19,13 @@ struct acpi_device;
 #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
 extern int acpi_video_register(void);
 extern void acpi_video_unregister(void);
+extern void acpi_video_backlight_unregister(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
 static inline int acpi_video_register(void) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
+static inline void acpi_video_backlight_unregister(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 				      int device_id, void **edid)
 {
-- 
1.6.4.2

