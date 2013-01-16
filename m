Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3APQUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:20:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab3APQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 191/222] ACPI : do not use Lid and Sleep button for S5 wakeup
Date: Wed, 16 Jan 2013 13:56:31 -0200
Message-Id: <1358351822-7675-192-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b7e383046c2c7c13ad928cd7407eafff758ddd4b upstream.

When system enters power off, the _PSW of Lid device is enabled.
But this may cause the system to reboot instead of power off.

A proper way to fix this is to always disable lid wakeup capability for S5.

References: https://bugzilla.kernel.org/show_bug.cgi?id=35262
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c8a1f3b..803c4ec 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -789,8 +789,8 @@ acpi_bus_extract_wakeup_device_power_package(acpi_handle handle,
 static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 {
 	struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0D", 0},
 		{"PNP0C0C", 0},
+		{"PNP0C0D", 0},
 		{"PNP0C0E", 0},
 		{"", 0},
 	};
@@ -802,6 +802,11 @@ static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
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
-- 
1.7.9.5

