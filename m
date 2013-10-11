Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3JKN12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:27:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:15038 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3JKN10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:27:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="415484321"
From: Aaron Lu <aaron.lu@intel.com>
To: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Ben Jencks <ben@bjencks.net>,
        Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH v5 3/4] ACPI / video: Do not register backlight if win8 and native interface exists
Date: Fri, 11 Oct 2013 21:27:45 +0800
Message-Id: <1381498066-16011-4-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
In-Reply-To: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
References: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
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
registered by GPU driver, ACPI video does not need to register its own.
Since there are systems that don't work well with this approach, a
parameter for video module named use_native_backlight is introduced and
has the value of false by default. For users who have a broken ACPI
video backlight interface, video.use_native_backlight=1 is needed in
kernel cmdline.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/internal.h     |  4 +---
 drivers/acpi/video.c        | 25 ++++++++++++++++++++-----
 drivers/acpi/video_detect.c |  4 ++--
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 20f4233..e9304dc 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -169,9 +169,7 @@ int acpi_create_platform_device(struct acpi_device *adev,
 					Video
   -------------------------------------------------------------------------- */
 #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
-bool acpi_video_backlight_quirks(void);
-#else
-static inline bool acpi_video_backlight_quirks(void) { return false; }
+bool acpi_osi_is_win8(void);
 #endif
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3bd1eaa..d020df5 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -88,6 +88,13 @@ module_param(allow_duplicates, bool, 0644);
 static bool use_bios_initial_backlight = 1;
 module_param(use_bios_initial_backlight, bool, 0644);
 
+/*
+ * For Windows 8 systems: if set ture and the GPU driver has
+ * registered a backlight interface, skip registering ACPI video's.
+ */
+static bool use_native_backlight = false;
+module_param(use_native_backlight, bool, 0644);
+
 static int register_count;
 static struct mutex video_list_lock;
 static struct list_head video_bus_head;
@@ -232,6 +239,14 @@ static int acpi_video_get_next_level(struct acpi_video_device *device,
 static int acpi_video_switch_brightness(struct acpi_video_device *device,
 					 int event);
 
+static bool acpi_video_verify_backlight_support(void)
+{
+	if (acpi_osi_is_win8() && use_native_backlight &&
+	    backlight_device_registered(BACKLIGHT_RAW))
+		return false;
+	return acpi_video_backlight_support();
+}
+
 /* backlight device sysfs support */
 static int acpi_video_get_brightness(struct backlight_device *bd)
 {
@@ -1256,8 +1271,8 @@ acpi_video_switch_brightness(struct acpi_video_device *device, int event)
 	unsigned long long level_current, level_next;
 	int result = -EINVAL;
 
-	/* no warning message if acpi_backlight=vendor is used */
-	if (!acpi_video_backlight_support())
+	/* no warning message if acpi_backlight=vendor or a quirk is used */
+	if (!acpi_video_verify_backlight_support())
 		return 0;
 
 	if (!device->brightness)
@@ -1386,13 +1401,13 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
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
@@ -1558,7 +1573,7 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
 
 static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 {
-	if (acpi_video_backlight_support()) {
+	if (acpi_video_verify_backlight_support()) {
 		struct backlight_properties props;
 		struct pci_dev *pdev;
 		acpi_handle acpi_parent;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 940edbf..b639934 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -233,11 +233,11 @@ static void acpi_video_caps_check(void)
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
-- 
1.8.4.12.g2ea3df6

