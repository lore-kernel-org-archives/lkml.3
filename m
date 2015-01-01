Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbbAAWQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 17:16:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56221 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751450AbbAAWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 17:16:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Fix PM initialization for devices that are not present
Date: Thu, 01 Jan 2015 23:38:28 +0100
Message-ID: <4453924.d7c5RYZUJi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
---

"Stable" material.

---
 drivers/acpi/device_pm.c |    2 +-
 drivers/acpi/scan.c      |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -257,7 +257,7 @@ int acpi_bus_init_power(struct acpi_devi
 
 	device->power.state = ACPI_STATE_UNKNOWN;
 	if (!acpi_device_is_present(device))
-		return 0;
+		return -ENXIO;
 
 	result = acpi_device_get_power(device, &state);
 	if (result)
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1001,7 +1001,7 @@ static void acpi_free_power_resources_li
 	if (device->wakeup.flags.valid)
 		acpi_power_resources_list_free(&device->wakeup.resources);
 
-	if (!device->flags.power_manageable)
+	if (!device->power.flags.power_resources)
 		return;
 
 	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
@@ -1744,10 +1744,8 @@ static void acpi_bus_get_power_flags(str
 			device->power.flags.power_resources)
 		device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible = 1;
 
-	if (acpi_bus_init_power(device)) {
-		acpi_free_power_resources_lists(device);
+	if (acpi_bus_init_power(device))
 		device->flags.power_manageable = 0;
-	}
 }
 
 static void acpi_bus_get_flags(struct acpi_device *device)
@@ -2371,13 +2369,18 @@ static void acpi_bus_attach(struct acpi_
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

