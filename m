Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3IXJrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:47:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:13092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab3IXJrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,969,1371106800"; 
   d="scan'208";a="364767665"
From: Aaron Lu <aaron.lu@intel.com>
To: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Ben Jencks <ben@bjencks.net>,
        Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH v3 3/4] ACPI / video: Do not register backlight if win8 and native interface exists
Date: Tue, 24 Sep 2013 17:47:31 +0800
Message-Id: <1380016052-15315-4-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
In-Reply-To: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Matthew Garrett, "Windows 8 leaves backlight control up
to individual graphics drivers rather than making ACPI calls itself.
There's plenty of evidence to suggest that the Intel driver for
Windows [8] doesn't use the ACPI interface, including the fact that
it's broken on a bunch of machines when the OS claims to support
Windows 8.  The simplest thing to do appears to be to disable the
ACPI backlight interface on these systems".

So for Win8 systems, if there is native backlight control interface
registered by GPU driver, ACPI video will not register its own. For
users who prefer to keep ACPI video's backlight interface, the existing
kernel cmdline option acpi_backlight=video can be used.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
---
 drivers/acpi/internal.h     |  5 ++---
 drivers/acpi/video.c        | 10 +++++-----
 drivers/acpi/video_detect.c | 14 ++++++++++++--
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 20f4233..453ae8d 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -169,9 +169,8 @@ int acpi_create_platform_device(struct acpi_device *adev,
 					Video
   -------------------------------------------------------------------------- */
 #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
-bool acpi_video_backlight_quirks(void);
-#else
-static inline bool acpi_video_backlight_quirks(void) { return false; }
+bool acpi_osi_is_win8(void);
+bool acpi_video_verify_backlight_support(void);
 #endif
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3bd1eaa..343db59 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1256,8 +1256,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
 	unsigned long long level_current, level_next;
 	int result = -EINVAL;
 
-	/* no warning message if acpi_backlight=vendor is used */
-	if (!acpi_video_backlight_support())
+	/* no warning message if acpi_backlight=vendor or a quirk is used */
+	if (!acpi_video_verify_backlight_support())
 		return 0;
 
 	if (!device->brightness)
@@ -1386,13 +1386,13 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
 static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
 {
 	return acpi_video_bus_DOS(video, 0,
-				  acpi_video_backlight_quirks() ? 1 : 0);
+				  acpi_osi_is_win8() ? 1 : 0);
 }
 
 static int acpi_video_bus_stop_devices(struct acpi_video_bus *video)
 {
 	return acpi_video_bus_DOS(video, 0,
-				  acpi_video_backlight_quirks() ? 0 : 1);
+				  acpi_osi_is_win8() ? 0 : 1);
 }
 
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
@@ -1558,7 +1558,7 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
 
 static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 {
-	if (acpi_video_backlight_support()) {
+	if (acpi_video_verify_backlight_support()) {
 		struct backlight_properties props;
 		struct pci_dev *pdev;
 		acpi_handle acpi_parent;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 940edbf..23d7d26 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -37,6 +37,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/pci.h>
+#include <linux/backlight.h>
 
 #include "internal.h"
 
@@ -233,11 +234,11 @@ static void acpi_video_caps_check(void)
 		acpi_video_get_capabilities(NULL);
 }
 
-bool acpi_video_backlight_quirks(void)
+bool acpi_osi_is_win8(void)
 {
 	return acpi_gbl_osi_data >= ACPI_OSI_WIN_8;
 }
-EXPORT_SYMBOL(acpi_video_backlight_quirks);
+EXPORT_SYMBOL(acpi_osi_is_win8);
 
 /* Promote the vendor interface instead of the generic video module.
  * This function allow DMI blacklists to be implemented by externals
@@ -283,6 +284,15 @@ int acpi_video_backlight_support(void)
 }
 EXPORT_SYMBOL(acpi_video_backlight_support);
 
+bool acpi_video_verify_backlight_support(void)
+{
+	if (!(acpi_video_support & ACPI_VIDEO_BACKLIGHT_FORCE_VIDEO) &&
+	    acpi_osi_is_win8() && backlight_device_registered(BACKLIGHT_RAW))
+		return false;
+	return acpi_video_backlight_support();
+}
+EXPORT_SYMBOL(acpi_video_verify_backlight_support);
+
 /*
  * Use acpi_backlight=vendor/video to force that backlight switching
  * is processed by vendor specific acpi drivers or video.ko driver.
-- 
1.8.4.12.g2ea3df6

