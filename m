Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbbA0Mtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:49:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbbA0MRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 018/126] ACPI / PM: Fix PM initialization for devices that are not present
Date: Tue, 27 Jan 2015 12:15:23 +0000
Message-Id: <1422361031-19364-19-git-send-email-luis.henriques@canonical.com>
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

commit 1b1f3e1699a9886f1070f94171097ab4ccdbfc95 upstream.

If an ACPI device object whose _STA returns 0 (not present and not
functional) has _PR0 or _PS0, its power_manageable flag will be set
and acpi_bus_init_power() will return 0 for it.  Consequently, if
such a device object is passed to the ACPI device PM functions, they
will attempt to carry out the requested operation on the device,
although they should not do that for devices that are not present.

To fix that problem make acpi_bus_init_power() return an error code
for devices that are not present which will cause power_manageable to
be cleared for them as appropriate in acpi_bus_get_power_flags().
However, the lists of power resources should not be freed for the
device in that case, so modify acpi_bus_get_power_flags() to keep
those lists even if acpi_bus_init_power() returns an error.
Accordingly, when deciding whether or not the lists of power
resources need to be freed, acpi_free_power_resources_lists()
should check the power.flags.power_resources flag instead of
flags.power_manageable, so make that change too.

Furthermore, if acpi_bus_attach() sees that flags.initialized is
unset for the given device, it should reset the power management
settings of the device and re-initialize them from scratch instead
of relying on the previous settings (the device may have appeared
after being not present previously, for example), so make it use
the 'valid' flag of the D0 power state as the initial value of
flags.power_manageable for it and call acpi_bus_init_power() to
discover its current power state.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/device_pm.c |  2 +-
 drivers/acpi/scan.c      | 13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 9ea7b99bc9a0..f702dcef4df9 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -257,7 +257,7 @@ int acpi_bus_init_power(struct acpi_device *device)
 
 	device->power.state = ACPI_STATE_UNKNOWN;
 	if (!acpi_device_is_present(device))
-		return 0;
+		return -ENXIO;
 
 	result = acpi_device_get_power(device, &state);
 	if (result)
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 2e9ed9a4f13f..465712f3b7b4 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -869,7 +869,7 @@ static void acpi_free_power_resources_lists(struct acpi_device *device)
 	if (device->wakeup.flags.valid)
 		acpi_power_resources_list_free(&device->wakeup.resources);
 
-	if (!device->flags.power_manageable)
+	if (!device->power.flags.power_resources)
 		return;
 
 	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
@@ -1588,10 +1588,8 @@ static void acpi_bus_get_power_flags(struct acpi_device *device)
 			device->power.flags.power_resources)
 		device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible = 1;
 
-	if (acpi_bus_init_power(device)) {
-		acpi_free_power_resources_lists(device);
+	if (acpi_bus_init_power(device))
 		device->flags.power_manageable = 0;
-	}
 }
 
 static void acpi_bus_get_flags(struct acpi_device *device)
@@ -2159,13 +2157,18 @@ static void acpi_bus_attach(struct acpi_device *device)
 	/* Skip devices that are not present. */
 	if (!acpi_device_is_present(device)) {
 		device->flags.visited = false;
+		device->flags.power_manageable = 0;
 		return;
 	}
 	if (device->handler)
 		goto ok;
 
 	if (!device->flags.initialized) {
-		acpi_bus_update_power(device, NULL);
+		device->flags.power_manageable =
+			device->power.states[ACPI_STATE_D0].flags.valid;
+		if (acpi_bus_init_power(device))
+			device->flags.power_manageable = 0;
+
 		device->flags.initialized = true;
 	}
 	device->flags.visited = false;
-- 
2.1.4

