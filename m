Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3BCNHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:07:42 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54808 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3BCNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:07:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Handle missing _PSC in acpi_bus_update_power()
Date: Sun, 03 Feb 2013 14:13:54 +0100
Message-ID: <1432840.s0A6LzWFfU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

If _PS0 is defined for an ACPI device node, but _PSC isn't and
the device node doesn't use power resources for power management,
acpi_bus_update_power() will fail to update the power state of it,
because acpi_device_get_power() returns ACPI_STATE_UNKNOWN in that
case.

To handle that situation make acpi_bus_update_power() follow
acpi_bus_init_power() and try to force the given device node into
power state D0 if its actual power state cannot be determined.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of linux-pm.git/bleeding-edge.

Thanks,
Rafael

---
 drivers/acpi/device_pm.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -355,6 +355,9 @@ int acpi_bus_update_power(acpi_handle ha
 	if (result)
 		return result;
 
+	if (state == ACPI_STATE_UNKNOWN)
+		state = ACPI_STATE_D0;
+
 	result = acpi_device_set_power(device, state);
 	if (!result && state_p)
 		*state_p = state;

