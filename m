Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaCaAOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:14:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36408 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Aaron Lu" <aaron.lu@intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.230873611@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 132/200] ACPI / video: Filter the _BCL table for
 duplicate brightness values
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -646,6 +646,7 @@ acpi_video_init_brightness(struct acpi_v
 	union acpi_object *o;
 	struct acpi_video_device_brightness *br = NULL;
 	int result = -EINVAL;
+	u32 value;
 
 	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
@@ -676,7 +677,12 @@ acpi_video_init_brightness(struct acpi_v
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

