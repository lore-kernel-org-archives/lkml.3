Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3AMRuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:50:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab3AMRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:38 -0500
Message-Id: <20130113174305.836348981@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:43 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 48/49] ACPI : do not use Lid and Sleep button for S5 wakeup
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b7e383046c2c7c13ad928cd7407eafff758ddd4b upstream.

When system enters power off, the _PSW of Lid device is enabled.
But this may cause the system to reboot instead of power off.

A proper way to fix this is to always disable lid wakeup capability for S5.

References: https://bugzilla.kernel.org/show_bug.cgi?id=35262
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d0b38ab..bd523bf 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -917,8 +917,8 @@ acpi_bus_extract_wakeup_device_power_package(acpi_handle handle,
 static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 {
 	struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0D", 0},
 		{"PNP0C0C", 0},
+		{"PNP0C0D", 0},
 		{"PNP0C0E", 0},
 		{"", 0},
 	};
@@ -930,6 +930,11 @@ static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 	/* Power button, Lid switch always enable wakeup */
 	if (!acpi_match_device_ids(device, button_device_ids)) {
 		device->wakeup.flags.run_wake = 1;
+		if (!acpi_match_device_ids(device, &button_device_ids[1])) {
+			/* Do not use Lid/sleep button for S5 wakeup */
+			if (device->wakeup.sleep_state == ACPI_STATE_S5)
+				device->wakeup.sleep_state = ACPI_STATE_S4;
+		}
 		device_set_wakeup_capable(&device->dev, true);
 		return;
 	}


