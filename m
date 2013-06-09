Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3FIXCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:02:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45793 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3FIXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:01:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl, Zhang Rui <rui.zhang@intel.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>, Aaron Lu <aaron.lu@intel.com>,
        Thomas Renninger <trenn@suse.de>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 1/3] acpi: video: add function to support unregister backlight interface
Date: Sun,  9 Jun 2013 19:01:37 -0400
Message-Id: <1370818899-8595-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

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
 drivers/acpi/video.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++----
 include/acpi/video.h |  2 ++
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5b32e15..da08ff7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -43,6 +43,7 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/suspend.h>
 #include <acpi/video.h>
+#include <linux/mutex.h>
 
 #define PREFIX "ACPI: "
 
@@ -86,6 +87,9 @@ module_param(allow_duplicates, bool, 0644);
 static bool use_bios_initial_backlight = 1;
 module_param(use_bios_initial_backlight, bool, 0644);
 
+static bool backlight_disable;
+module_param(backlight_disable, bool, 0644);
+
 static int register_count = 0;
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device);
@@ -214,6 +218,8 @@ static const char device_decode[][30] = {
 	"UNKNOWN",
 };
 
+static DEFINE_MUTEX(backlight_mutex);
+
 static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data);
 static void acpi_video_device_rebind(struct acpi_video_bus *video);
 static void acpi_video_device_bind(struct acpi_video_bus *video,
@@ -882,7 +888,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		device->cap._DDC = 1;
 	}
 
-	if (acpi_video_backlight_support()) {
+	if (acpi_video_backlight_support() || backlight_disable) {
 		struct backlight_properties props;
 		struct pci_dev *pdev;
 		acpi_handle acpi_parent;
@@ -1083,15 +1089,22 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	struct acpi_video_device *data;
 	struct acpi_video_device_attrib* attribute;
 
+	mutex_lock(&backlight_mutex);
+
 	status =
 	    acpi_evaluate_integer(device->handle, "_ADR", NULL, &device_id);
 	/* Some device omits _ADR, we skip them instead of fail */
-	if (ACPI_FAILURE(status))
-		return 0;
+	if (ACPI_FAILURE(status)) {
+		status = 0;
+		goto out;
+	}
 
 	data = kzalloc(sizeof(struct acpi_video_device), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		status = -ENOMEM;
+		goto out;
+	}
+
 
 	strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
@@ -1156,6 +1169,8 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	list_add_tail(&data->entry, &video->video_device_list);
 	mutex_unlock(&video->device_list_lock);
 
+out:
+	mutex_unlock(&backlight_mutex);
 	return status;
 }
 
@@ -1336,7 +1351,7 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
 	int result = -EINVAL;
 
 	/* no warning message if acpi_backlight=vendor is used */
-	if (!acpi_video_backlight_support())
+	if (!acpi_video_backlight_support() || backlight_disable)
 		return 0;
 
 	if (!device->brightness)
@@ -1869,6 +1884,72 @@ static int __init intel_opregion_present(void)
 	return opregion;
 }
 
+static acpi_status
+find_video_unregister_backlight(acpi_handle handle, u32 lvl, void *context,
+				void **rv)
+{
+	struct acpi_device *acpi_dev;
+	struct acpi_video_bus *video;
+	struct acpi_video_device *dev, *next;
+	acpi_status status = AE_OK;
+
+	mutex_lock(&backlight_mutex);
+
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		goto out;
+
+	if (!acpi_match_device_ids(acpi_dev, video_device_ids)) {
+		video = acpi_driver_data(acpi_dev);
+
+		if (!video)
+			goto out;
+
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
+out:
+	mutex_unlock(&backlight_mutex);
+	return status;
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
+
+	backlight_disable = 1;
+
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
1.8.2.1

