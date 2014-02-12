Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaBLDFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:05:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:36437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaBLDFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:05:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,829,1384329600"; 
   d="scan'208";a="480005421"
Message-ID: <52FAE504.8020001@intel.com>
Date: Wed, 12 Feb 2014 11:05:40 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: [PATCH] drm/i915/opregion: work around buggy firmware that provides
 8+ output devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI table on ASUS UX302LA has more than 8 output devices under the
graphics controller device node. The problem is, the real active output
device, the LCD panel, is listed the last. The result is, the LCD's
device id doesn't get recorded in the active device list CADL array and
when the _DCS control method for the LCD device is executed, it returns
0x1d, meaning it is not active. This affects the hotkey delivery ASL
code that will not deliver a notification if the output device is not
active on backlight hotkey press.

I don't see a clean way to solve this problem since the operation region
spec doesn't allow more than 8 output devices so we have no way of
storing all these output devices. The fact that output devices that have
_BCM control method usually means they have a higher possibility of being
used than those who don't made me choose a simple way to work around
the buggy firmware by replacing the last entry in CADL array with the one
that has _BCM control method. There is no specific reason why the last
entry is picked instead of others.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=70241
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reported-and-tested-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/gpu/drm/i915/intel_opregion.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 4e960ec7419f..fc4348284f41 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -613,6 +613,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 	acpi_status status;
 	u32 temp;
 	int i = 0;
+	bool done;
 
 	handle = ACPI_HANDLE(&dev->pdev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
@@ -634,11 +635,20 @@ static void intel_didl_outputs(struct drm_device *dev)
 		return;
 	}
 
+	done = false;
 	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
 		if (i >= 8) {
 			dev_dbg(&dev->pdev->dev,
-				"More than 8 outputs detected via ACPI\n");
-			return;
+				"More than 8 outputs detected via ACPI, %s\n",
+				acpi_device_bid(acpi_cdev));
+			if (acpi_has_method(acpi_cdev->handle, "_BCM")) {
+				dev_dbg(&dev->pdev->dev,
+					"%s has _BCM, replacing 8th entry\n",
+					acpi_device_bid(acpi_cdev));
+				i = 7;
+				done = true;
+			} else
+				continue;
 		}
 		status =
 			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
@@ -650,6 +660,9 @@ static void intel_didl_outputs(struct drm_device *dev)
 				  &opregion->acpi->didl[i]);
 			i++;
 		}
+
+		if (done)
+			return;
 	}
 
 end:
-- 
1.8.5.3

