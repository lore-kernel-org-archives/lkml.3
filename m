Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaBRFyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:54:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:9597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaBRFyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:54:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="457208107"
Message-ID: <5302F58C.1080001@intel.com>
Date: Tue, 18 Feb 2014 13:54:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Peter Weber <bugs@ttyhoney.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kevin Smith <thirdwiggin@gmail.com>,
        Rinat Ibragimov <ibragimovrinat@mail.ru>, sov.info@mail.ru,
        Thomas Christensen <christensenthomas@gmail.com>,
        Vladimir Sherenkov <a_12300@mail.ru>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: [PATCH v4] ACPI / video: Add systems that should favour native backlight
 interface
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some system's ACPI video backlight control interface is broken and the
native backlight control interface should be used by default. This patch
sets the use_native_backlight parameter to true for those systems so
that video backlight control interface will not be created. For detailed
models that are added here, reference the following list.

Note that the user specified kernel cmdline option will always have the
highest priority, i.e. if use_native_backlight=0 is specified and the
system is in the DMI table, the video module will not skip registering
backlight interface for it.

Thinkpad T430s:
Reported-by: Theodore Tso <tytso@mit.edu>
Reported-and-tested-by: Peter Weber <bugs@ttyhoney.com>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=51231
Thinkpad X230:
Reported-and-tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=51231
ThinkPad X1 Carbon:
Reported-and-tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Lenovo Yoga 13:
Reported-by: Lennart Poettering <lennart@poettering.net>
Reported-and-tested-by: Kevin Smith <thirdwiggin@gmail.com>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=63811
Dell Inspiron 7520:
Reported-by: Rinat Ibragimov <ibragimovrinat@mail.ru>
Acer Aspire 5733Z:
Reported-by: <sov.info@mail.ru>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=62941
Acer Aspire V5-431:
Reported-by: Thomas Christensen <christensenthomas@gmail.com>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=68751
HP ProBook 4340s:
Reported-and-tested-by: Vladimir Sherenkov <a_12300@mail.ru>
Reference: http://redmine.russianfedora.pro/issues/1258
HP EliteBook/ProBook 2013 models, ZBook and some others:
Provided-by: Takashi Iwai <tiwai@suse.de>

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/blacklist.c    |   8 ---
 drivers/acpi/video.c        | 139 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/video_detect.c |  16 -----
 3 files changed, 134 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 10e4964d051a..e8e4c3dfaff7 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -260,14 +260,6 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	},
 	{
 	.callback = dmi_disable_osi_win8,
-	.ident = "Dell Inspiron 15R SE",
-	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7520"),
-		},
-	},
-	{
-	.callback = dmi_disable_osi_win8,
 	.ident = "ThinkPad Edge E530",
 	.matches = {
 		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index ea9d914d937a..b6ba88ed31ae 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -81,11 +81,12 @@ static bool allow_duplicates;
 module_param(allow_duplicates, bool, 0644);
 
 /*
- * For Windows 8 systems: if set ture and the GPU driver has
- * registered a backlight interface, skip registering ACPI video's.
+ * For Windows 8 systems: used to decide if video module
+ * should skip registering backlight interface of its own.
  */
-static bool use_native_backlight = false;
-module_param(use_native_backlight, bool, 0644);
+static int use_native_backlight_param = -1;
+module_param_named(use_native_backlight, use_native_backlight_param, int, 0444);
+static bool use_native_backlight_dmi = false;
 
 static int register_count;
 static struct mutex video_list_lock;
@@ -231,9 +232,17 @@ static int acpi_video_get_next_level(struct acpi_video_device *device,
 static int acpi_video_switch_brightness(struct acpi_video_device *device,
 					 int event);
 
+static bool acpi_video_use_native_backlight(void)
+{
+	if (use_native_backlight_param != -1)
+		return use_native_backlight_param;
+	else
+		return use_native_backlight_dmi;
+}
+
 static bool acpi_video_verify_backlight_support(void)
 {
-	if (acpi_osi_is_win8() && use_native_backlight &&
+	if (acpi_osi_is_win8() && acpi_video_use_native_backlight() &&
 	    backlight_device_registered(BACKLIGHT_RAW))
 		return false;
 	return acpi_video_backlight_support();
@@ -398,6 +407,12 @@ static int __init video_set_bqc_offset(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init video_set_use_native_backlight(const struct dmi_system_id *d)
+{
+	use_native_backlight_dmi = true;
+	return 0;
+}
+
 static struct dmi_system_id video_dmi_table[] __initdata = {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=13121
@@ -442,6 +457,120 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720"),
 		},
 	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "ThinkPad T430s",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T430s"),
+		},
+	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "ThinkPad X230",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X230"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "ThinkPad X1 Carbon",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X1 Carbon"),
+		},
+	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Lenovo Yoga 13",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
+		},
+	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Dell Inspiron 7520",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Inspiron 7520"),
+		},
+	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Acer Aspire 5733Z",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5733Z"),
+		},
+	},
+	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Acer Aspire V5-431",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire V5-431"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP ProBook 4340s",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "HP ProBook 4340s"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP ProBook 2013 models",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook "),
+		DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP EliteBook 2013 models",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
+		DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP ZBook 14",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 14"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP ZBook 15",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 15"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP ZBook 17",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 17"),
+		},
+	},
+	{
+	.callback = video_set_use_native_backlight,
+	.ident = "HP EliteBook 8780w",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8780w"),
+		},
+	},
 	{}
 };
 
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index a697b77b8865..19080c8e2f2a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -168,22 +168,6 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
 		},
 	},
-	{
-	.callback = video_detect_force_vendor,
-	.ident = "HP EliteBook Revolve 810",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Revolve 810 G1"),
-		},
-	},
-	{
-	.callback = video_detect_force_vendor,
-	.ident = "Lenovo Yoga 13",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
-		},
-	},
 	{ },
 };
 
-- 
1.8.5.3

