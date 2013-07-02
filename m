Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3GBWdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:33:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56996 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3GBWdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:33:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Fix corner case in acpi_bus_update_power()
Date: Wed, 03 Jul 2013 00:42:53 +0200
Message-ID: <7100481.jeTkAIjIl8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The role of acpi_bus_update_power() is to update the given ACPI
device object's power.state field to reflect the current physical
state of the device (as inferred from the configuration of power
resources and _PSC, if available).  For this purpose it calls
acpi_device_set_power() that should update the power resources'
reference counters and set power.state as appropriate.  However,
that doesn't work if the "new" state is D1, D2 or D3hot and the
the current value of power.state means D3cold, because in that
case acpi_device_set_power() will refuse to transition the device
from D3cold to non-D0.

To address this problem, make acpi_bus_update_power() call
acpi_power_transition() directly to update the power resources'
reference counters and only use acpi_device_set_power() to put
the device into D0 if the current physical state of it cannot
be determined.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -324,14 +324,27 @@ int acpi_bus_update_power(acpi_handle ha
 	if (result)
 		return result;
 
-	if (state == ACPI_STATE_UNKNOWN)
+	if (state == ACPI_STATE_UNKNOWN) {
 		state = ACPI_STATE_D0;
-
-	result = acpi_device_set_power(device, state);
-	if (!result && state_p)
+		result = acpi_device_set_power(device, state);
+		if (result)
+			return result;
+	} else {
+		if (device->power.flags.power_resources) {
+			/*
+			 * We don't need to really switch the state, bu we need
+			 * to update the power resources' reference counters.
+			 */
+			result = acpi_power_transition(device, state);
+			if (result)
+				return result;
+		}
+		device->power.state = state;
+	}
+	if (state_p)
 		*state_p = state;
 
-	return result;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_bus_update_power);
 

