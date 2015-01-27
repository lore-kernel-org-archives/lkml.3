Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbbA0MS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35120 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbA0MSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 056/126] ACPI / scan: No implicit wake notification for buttons
Date: Tue, 27 Jan 2015 12:16:01 +0000
Message-Id: <1422361031-19364-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit bd9b2f9aff26c185c1f8e0cd08a850ee4ace391a upstream.

The ACPI device enumeration code in Linux assumes that buttons always
are wakeup devices, so it calls acpi_setup_gpe_for_wake() for them
which leads to undesirable side effects.  Namely, that function sets
up implicit device wake notification mechanism for a given GPE if
there is no handler method in the ACPI namespace, which from the
ACPICA's perspective means that there always is a way to handle
that GPE if enabled.  However, we don't handle wake notify events
for buttons, so if there are no handler methods for their GPEs in
the namespace, enabling a button GPE at run time leads to a GPE
storm in some cases (the GPE triggers, ACPICA carries out the
implicit wake notification for it which isn't handled, so the
GPE triggers again and so on).

To prevent that from happening use acpi_mark_gpe_for_wake()
instead of acpi_setup_gpe_for_wake() for buttons which will cause
ACPICA to only enable button GPEs if there are handler methods for
the in the namespace.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/scan.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 465712f3b7b4..f002835894c1 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1428,14 +1428,13 @@ static int acpi_bus_extract_wakeup_device_power_package(acpi_handle handle,
 			wakeup->sleep_state = sleep_state;
 		}
 	}
-	acpi_setup_gpe_for_wake(handle, wakeup->gpe_device, wakeup->gpe_number);
 
  out:
 	kfree(buffer.pointer);
 	return err;
 }
 
-static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
+static void acpi_wakeup_gpe_init(struct acpi_device *device)
 {
 	struct acpi_device_id button_device_ids[] = {
 		{"PNP0C0C", 0},
@@ -1443,29 +1442,33 @@ static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 		{"PNP0C0E", 0},
 		{"", 0},
 	};
+	struct acpi_device_wakeup *wakeup = &device->wakeup;
 	acpi_status status;
 	acpi_event_status event_status;
 
-	device->wakeup.flags.notifier_present = 0;
+	wakeup->flags.notifier_present = 0;
 
 	/* Power button, Lid switch always enable wakeup */
 	if (!acpi_match_device_ids(device, button_device_ids)) {
-		device->wakeup.flags.run_wake = 1;
+		wakeup->flags.run_wake = 1;
 		if (!acpi_match_device_ids(device, &button_device_ids[1])) {
 			/* Do not use Lid/sleep button for S5 wakeup */
-			if (device->wakeup.sleep_state == ACPI_STATE_S5)
-				device->wakeup.sleep_state = ACPI_STATE_S4;
+			if (wakeup->sleep_state == ACPI_STATE_S5)
+				wakeup->sleep_state = ACPI_STATE_S4;
 		}
+		acpi_mark_gpe_for_wake(wakeup->gpe_device, wakeup->gpe_number);
 		device_set_wakeup_capable(&device->dev, true);
 		return;
 	}
 
-	status = acpi_get_gpe_status(device->wakeup.gpe_device,
-					device->wakeup.gpe_number,
-						&event_status);
-	if (status == AE_OK)
-		device->wakeup.flags.run_wake =
-				!!(event_status & ACPI_EVENT_FLAG_HANDLE);
+	acpi_setup_gpe_for_wake(device->handle, wakeup->gpe_device,
+				wakeup->gpe_number);
+	status = acpi_get_gpe_status(wakeup->gpe_device, wakeup->gpe_number,
+				     &event_status);
+	if (ACPI_FAILURE(status))
+		return;
+
+	wakeup->flags.run_wake = !!(event_status & ACPI_EVENT_FLAG_HANDLE);
 }
 
 static void acpi_bus_get_wakeup_device_flags(struct acpi_device *device)
@@ -1485,7 +1488,7 @@ static void acpi_bus_get_wakeup_device_flags(struct acpi_device *device)
 
 	device->wakeup.flags.valid = 1;
 	device->wakeup.prepare_count = 0;
-	acpi_bus_set_run_wake_flags(device);
+	acpi_wakeup_gpe_init(device);
 	/* Call _PSW/_DSW object to disable its ability to wake the sleeping
 	 * system for the ACPI device with the _PRW object.
 	 * The _PSW object is depreciated in ACPI 3.0 and is replaced by _DSW.
-- 
2.1.4

