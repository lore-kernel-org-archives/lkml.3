Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbaCEPO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:14:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbaCEOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 061/131] ACPI / video: Filter the _BCL table for duplicate brightness values
Date: Wed,  5 Mar 2014 14:23:05 +0000
Message-Id: <1394029455-23128-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit bd8ba20597f0cfef3ef65c3fd2aa92ab23d4c8e1 upstream.

Some devices have duplicate entries in there brightness levels table, ie
on my Dell Latitude E6430 the table looks like this:

[    3.686060] acpi backlight index   0, val 80
[    3.686095] acpi backlight index   1, val 50
[    3.686122] acpi backlight index   2, val 5
[    3.686147] acpi backlight index   3, val 5
[    3.686172] acpi backlight index   4, val 5
[    3.686197] acpi backlight index   5, val 5
[    3.686223] acpi backlight index   6, val 5
[    3.686248] acpi backlight index   7, val 5
[    3.686273] acpi backlight index   8, val 6
[    3.686332] acpi backlight index   9, val 7
[    3.686356] acpi backlight index  10, val 8
[    3.686380] acpi backlight index  11, val 9
etc.

Notice that brightness values 0-5 are all mapped to 5. This means that
if userspace writes any value between 0 and 5 to the brightness sysfs attribute
and then reads it, it will always return 0, which is somewhat unexpected.

This is a problem for ie gnome-settings-daemon, which uses read-modify-write
logic when the users presses the brightness up or down keys. This is done
this way to take brightness changes from other sources into account.

On this specific laptop what happens once the brightness has been set to 0,
is that gsd reads 0, adds 5, writes 5, and on the next brightness up key press
again reads 0, so things get stuck at the lowest brightness setting.

Filtering out the duplicate table entries, makes any write to brightness
read back as the written value as one would expect, fixing this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/video.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 28e5184..e37996d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -735,6 +735,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	union acpi_object *o;
 	struct acpi_video_device_brightness *br = NULL;
 	int result = -EINVAL;
+	u32 value;
 
 	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
@@ -765,7 +766,12 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 			printk(KERN_ERR PREFIX "Invalid data\n");
 			continue;
 		}
-		br->levels[count] = (u32) o->integer.value;
+		value = (u32) o->integer.value;
+		/* Skip duplicate entries */
+		if (count > 2 && br->levels[count - 1] == value)
+			continue;
+
+		br->levels[count] = value;
 
 		if (br->levels[count] > max_level)
 			max_level = br->levels[count];
-- 
1.9.0

