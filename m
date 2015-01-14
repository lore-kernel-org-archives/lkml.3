Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbbANH3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:29:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbANH3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.18 106/150] ACPI / video: update the skip case for acpi_video_device_in_dod()
Date: Tue, 13 Jan 2015 23:22:57 -0800
Message-Id: <20150114072100.669944280@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit b4df463678fb9c6dae9548dbb7545993779fd416 upstream.

If the firmware has declared more than 8 video output devices, and the
one that control the internal panel's backlight is listed after the
first 8 output devices, the _DOD will not include it due to the current
i915 operation region implementation. As a result, we will not create a
backlight device for it while we should. Solve this problem by special
case the firmware that has 8+ output devices in that if we see such a
firmware, we do not test if the device is in _DOD list. The creation of
the backlight device will also enable the firmware to emit events on
backlight hotkey press when the acpi_osi= cmdline option is specified on
those affected ASUS laptops.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=70241
Reported-and-tested-by: Oleksij Rempel <linux@rempel-privat.de>
Reported-and-tested-by: Dmitry Tunin <hanipouspilot@gmail.com>
Reported-and-tested-by: Jimbo <jaime.91@hotmail.es>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -155,6 +155,7 @@ struct acpi_video_bus {
 	u8 dos_setting;
 	struct acpi_video_enumerated_device *attached_array;
 	u8 attached_count;
+	u8 child_count;
 	struct acpi_video_bus_cap cap;
 	struct acpi_video_bus_flags flags;
 	struct list_head video_device_list;
@@ -1159,8 +1160,12 @@ static bool acpi_video_device_in_dod(str
 	struct acpi_video_bus *video = device->video;
 	int i;
 
-	/* If we have a broken _DOD, no need to test */
-	if (!video->attached_count)
+	/*
+	 * If we have a broken _DOD or we have more than 8 output devices
+	 * under the graphics controller node that we can't proper deal with
+	 * in the operation region code currently, no need to test.
+	 */
+	if (!video->attached_count || video->child_count > 8)
 		return true;
 
 	for (i = 0; i < video->attached_count; i++) {
@@ -1413,6 +1418,7 @@ acpi_video_bus_get_devices(struct acpi_v
 			dev_err(&dev->dev, "Can't attach device\n");
 			break;
 		}
+		video->child_count++;
 	}
 	return status;
 }


