Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3AaW0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:26:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37258 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab3AaW02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:26:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Peter Wu <lekensteyn@gmail.com>
Subject: [Resend][PATCH] ACPI / PM: Do not power manage devices in unknown initial states
Date: Thu, 31 Jan 2013 23:32:40 +0100
Message-ID: <3676077.i6vcpp7Nrn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In general, for ACPI device power management to work, the initial
power states of devices must be known (otherwise, we wouldn't be able
to keep track of power resources, for example).  Hence, if it is
impossible to determine the initial ACPI power states of some
devices, they can't be regarded as power-manageable using ACPI.

For this reason, modify acpi_bus_get_power_flags() to clear the
power_manageable flag if acpi_bus_init_power() fails and add some
extra fallback code to acpi_bus_init_power() to cover broken
BIOSes that provide _PS0/_PS3 without _PSC for some devices.

Verified to work on my HP nx6325 that has this problem.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    6 ++++++
 drivers/acpi/scan.c      |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -330,6 +330,12 @@ int acpi_bus_init_power(struct acpi_devi
 		result = acpi_dev_pm_explicit_set(device, state);
 		if (result)
 			return result;
+	} else if (state == ACPI_STATE_UNKNOWN) {
+		/* No power resources and missing _PSC? Try to force D0. */
+		state = ACPI_STATE_D0;
+		result = acpi_dev_pm_explicit_set(device, state);
+		if (result)
+			return result;
 	}
 	device->power.state = state;
 	return 0;
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1175,7 +1175,10 @@ static void acpi_bus_get_power_flags(str
 			device->power.flags.power_resources)
 		device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible = 1;
 
-	acpi_bus_init_power(device);
+	if (acpi_bus_init_power(device)) {
+		acpi_free_power_resources_lists(device);
+		device->flags.power_manageable = 0;
+	}
 }
 
 static void acpi_bus_get_flags(struct acpi_device *device)

